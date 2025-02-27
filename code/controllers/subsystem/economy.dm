SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	var/roundstart_paychecks = 5
	var/budget_starting_amt = 1000
	var/list/department_accounts = list(ACCOUNT_CIV = ACCOUNT_CIV_NAME,
										ACCOUNT_ENG = ACCOUNT_ENG_NAME,
										ACCOUNT_SCI = ACCOUNT_SCI_NAME,
										ACCOUNT_MED = ACCOUNT_MED_NAME,
										ACCOUNT_SRV = ACCOUNT_SRV_NAME,
										ACCOUNT_CAR = ACCOUNT_CAR_NAME,
										ACCOUNT_SEC = ACCOUNT_SEC_NAME)
	var/list/generated_accounts = list()
	var/full_ancap = FALSE // Enables extra money charges for things that normally would be free, such as sleepers/cryo/cloning.
							//Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	var/datum/station_state/engineering_check = new /datum/station_state()
	var/alive_humans_bounty = 1
	var/crew_safety_bounty = 1500
	var/mood_bounty = 1
	var/techweb_bounty = 25 // yogs start - nerf insane rd budget
	var/slime_bounty = list("grey" = 0,
							// tier 1
							"orange" = 1,
							"metal" = 1,
							"blue" = 1,
							"purple" = 1,
							// tier 2
							"dark purple" = 2,
							"dark blue" = 2,
							"green" = 2,
							"silver" = 2,
							"gold" = 2,
							"yellow" = 2,
							"red" = 2,
							"pink" = 2,
							// tier 3
							"cerulean" = 3,
							"sepia" = 3,
							"bluespace" = 3,
							"pyrite" = 3,
							"light pink" = 3,
							"oil" = 3,
							"adamantine" = 3, // yogs end
							// tier 4
							"rainbow" = 10)
	var/list/bank_accounts = list() //List of normal accounts (not department accounts)
	var/list/dep_cards = list()
	///ref to moneysink. Only one should exist on the map. Has its payout() proc called every budget cycle
	var/obj/item/energy_harvester/moneysink = null
	///The modifier multiplied to the value of bounties paid out.
	var/bounty_modifier = 1
	///The modifier multiplied to the value of cargo pack prices.
	var/pack_price_modifier = 1
		/// Number of mail items generated.
	var/mail_waiting = 0
	/// Mail Holiday: AKA does mail arrive today? Always blocked on Sundays.
	var/mail_blocked = FALSE

	//only re-tally jobs when this changes. based on race conditions means this isn't 100% accurate, but oh well
	var/last_player_count

	var/department_count = list(
		ACCOUNT_CIV = 0,
		ACCOUNT_ENG = 0,
		ACCOUNT_SCI = 0,
		ACCOUNT_MED = 0,
		ACCOUNT_SRV = 0,
		ACCOUNT_CAR = 0,
		ACCOUNT_SEC = 0,
	)

/datum/controller/subsystem/economy/Initialize(timeofday)
	if(time2text(world.timeofday, "DDD") == SUNDAY)
		mail_blocked = TRUE
	for(var/A in department_accounts)
		switch(A)
			if(ACCOUNT_SEC)
				new /datum/bank_account/department(A, STARTING_SEC_BUDGET)
				continue
			if(ACCOUNT_CAR)
				new /datum/bank_account/department(A, STARTING_CAR_BUDGET)
				continue
			else
				new /datum/bank_account/department(A, budget_starting_amt)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/economy/fire(resumed = 0)
	tally_departments() //see how many staff in each department
	department_subsidy() //Give 95% of what we need to pay the department
	eng_payout() // Payout based on station integrity. Also adds money from excess power sold via energy harvester.
	sci_payout() // Payout based on slimes.
	secmedsrv_payout() // Payout based on crew safety, health, and mood.
	civ_payout() // Payout based on ??? Profit
	car_payout() // Cargo's natural gain in the cash moneys.
	var/delta_time = wait / (5 MINUTES)
	var/list/dictionary = list()
	for(var/datum/corporation/c in GLOB.corporations)
		dictionary[c] = list()
		for(var/datum/mind/m in c.employees)
			dictionary[c] += m.name
	for(var/A in bank_accounts)
		var/datum/bank_account/B = bank_accounts[A]
		for(var/datum/corporation/c in dictionary)
			if(B.account_holder in dictionary[c])
				B.payday(c.paymodifier, TRUE)
		B.payday(1)	
	var/effective_mailcount = living_player_count()
	mail_waiting += clamp(effective_mailcount, 1, MAX_MAIL_PER_MINUTE * delta_time)

/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	for(var/datum/bank_account/department/D in generated_accounts)
		if(D.department_id == dep_id)
			return D

/datum/controller/subsystem/economy/proc/tally_departments()
	var/player_count = SSticker.mode.current_players[CURRENT_LIVING_PLAYERS].len
	if(last_player_count >= player_count)
		return
	last_player_count = player_count
	department_count = list(
		ACCOUNT_CIV = 0,
		ACCOUNT_ENG = 0,
		ACCOUNT_SCI = 0,
		ACCOUNT_MED = 0,
		ACCOUNT_SRV = 0,
		ACCOUNT_CAR = 0,
		ACCOUNT_SEC = 0,
	)
	for(var/datum/job/J in SSjob.occupations)
		if(!(J.paycheck && J.paycheck_department))
			continue
		department_count[J.paycheck_department] += J.paycheck

/datum/controller/subsystem/economy/proc/department_subsidy()
	for(var/D in department_count)
		var/datum/bank_account/ACC = get_dep_account(D)
		if(ACC)
			ACC.adjust_money(round(department_count[D] * 0.95))


/** Payout for engineering every cycle. Uses a base of 3000 then multiplies it by station integrity. Afterwards, calls the payout proc from
  * the energy harvester and adds the cash from that to the budget.
  */
/datum/controller/subsystem/economy/proc/eng_payout()
	var/engineering_cash = 3000
	engineering_check.count()
	var/station_integrity = 100
	if(GLOB.start_state)
		station_integrity = min(PERCENT(GLOB.start_state.score(engineering_check)), 100)
	station_integrity *= 0.01
	engineering_cash *= station_integrity
	if(moneysink)
		engineering_cash += moneysink.payout()
	var/datum/bank_account/D = get_dep_account(ACCOUNT_ENG)
	var/datum/bank_account/C = get_dep_account(ACCOUNT_CAR)
	if(D)
		D.adjust_money(engineering_cash)
	if(C)
		C.adjust_money(engineering_cash*0.5)


/datum/controller/subsystem/economy/proc/car_payout()
	var/datum/bank_account/D = get_dep_account(ACCOUNT_CAR)
	if(D)
		D.adjust_money(50) //small stipend for cargo to get naturally

/datum/controller/subsystem/economy/proc/secmedsrv_payout()
	for(var/mob/living/carbon/human/human_player in GLOB.player_list)
		if(human_player.stat == DEAD)
			continue
		var/datum/component/mood/mood = human_player.GetComponent(/datum/component/mood)
		var/medical_cash = (human_player.health / human_player.maxHealth) * alive_humans_bounty
		if(mood)
			var/datum/bank_account/D = get_dep_account(ACCOUNT_SRV)
			if(D)
				var/mood_dosh = (mood.mood_level / 9) * mood_bounty
				D.adjust_money(mood_dosh)
			medical_cash *= (mood.sanity / 100)
		var/datum/bank_account/D = get_dep_account(ACCOUNT_MED)
		if(D)
			D.adjust_money(medical_cash)
		CHECK_TICK

	var/service_passive_income = (rand(1, 6) * 400) //min 400, max 2400
	var/datum/bank_account/SRV = get_dep_account(ACCOUNT_SRV)
	if(SRV)
		SRV.adjust_money(service_passive_income)

/datum/controller/subsystem/economy/proc/sci_payout()
	var/science_bounty = 0
	for(var/mob/living/simple_animal/slime/S in GLOB.mob_list)
		if(S.stat == DEAD)
			continue
		if(!is_station_level(S.z))
			continue
		science_bounty += slime_bounty[S.colour]
	var/datum/bank_account/D = get_dep_account(ACCOUNT_SCI)
	if(D)
		D.adjust_money(min(science_bounty, MAX_GRANT_SCI))

/datum/controller/subsystem/economy/proc/civ_payout()
	var/civ_cash = (rand(1,5) * 500)
	var/datum/bank_account/D = get_dep_account(ACCOUNT_CIV)
	if(D)
		D.adjust_money(min(civ_cash, MAX_GRANT_CIV))
