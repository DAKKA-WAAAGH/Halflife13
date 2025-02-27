GLOBAL_LIST_INIT(possible_changeling_IDs, list(
	"Alpha",
	"Beta",
	"Gamma",
	"Delta",
	"Epsilon",
	"Zeta",
	"Eta",
	"Theta",
	"Iota",
	"Kappa",
	"Lambda",
	"Mu",
	"Nu",
	"Xi",
	"Omicron",
	"Pi",
	"Rho",
	"Sigma",
	"Tau",
	"Upsilon",
	"Phi",
	"Chi",
	"Psi",
	"Omega",
))

GLOBAL_LIST_INIT(slots, list(
	"head",
	"wear_mask",
	"back",
	"wear_suit",
	"w_uniform",
	"shoes",
	"belt",
	"gloves",
	"glasses",
	"ears",
	"wear_id",
	"s_store",
))
GLOBAL_LIST_INIT(slot2slot, list(
	"head" = ITEM_SLOT_HEAD,
	"wear_mask" = ITEM_SLOT_MASK,
	"neck" = ITEM_SLOT_NECK,
	"back" = ITEM_SLOT_BACK,
	"wear_suit" = ITEM_SLOT_OCLOTHING,
	"w_uniform" = ITEM_SLOT_ICLOTHING,
	"shoes" = ITEM_SLOT_FEET,
	"belt" = ITEM_SLOT_BELT,
	"gloves" = ITEM_SLOT_GLOVES,
	"glasses" = ITEM_SLOT_EYES,
	"ears" = ITEM_SLOT_EARS,
	"wear_id" = ITEM_SLOT_ID,
	"s_store" = ITEM_SLOT_SUITSTORE,
))

GLOBAL_LIST_INIT(slot2type, list(
	"head" = /obj/item/clothing/head/changeling,
	"wear_mask" = /obj/item/clothing/mask/changeling,
	"back" = /obj/item/changeling,
	"wear_suit" = /obj/item/clothing/suit/changeling,
	"w_uniform" = /obj/item/clothing/under/changeling,
	"shoes" = /obj/item/clothing/shoes/changeling,
	"belt" = /obj/item/changeling,
	"gloves" = /obj/item/clothing/gloves/changeling,
	"glasses" = /obj/item/clothing/glasses/changeling,
	"ears" = /obj/item/changeling,
	"wear_id" = /obj/item/changeling,
	"s_store" = /obj/item/changeling,
))

///If this is not null, we hand our this objective to all lings
GLOBAL_VAR(changeling_team_objective_type)

/datum/game_mode/changeling
	name = "changeling"
	config_tag = "changeling"
	report_type = "changeling"
	antag_flag = ROLE_CHANGELING
	false_report_weight = 10
	restricted_jobs = list("AI", "Cyborg", "Synthetic")
	protected_jobs = list("Civil Protection Officer", "Warden", "Detective", "Divisional Lead", "City Administrator", "Labor Lead", "Chief Engineer", "Chief Medical Officer", "Research Director", "Brig Physician") //YOGS - added hop and brig physician
	required_players = 15
	required_enemies = 1
	recommended_enemies = 4
	reroll_friendly = 1

	announce_span = "green"
	announce_text = "Alien changelings have infiltrated the crew!\n\
	<span class='green'>Changelings</span>: Accomplish the objectives assigned to you.\n\
	<span class='notice'>Crew</span>: Root out and eliminate the changeling menace."

	title_icon = "changeling"
	var/const/changeling_amount = 4 //hard limit on changelings if scaling is turned off
	var/list/changelings = list()

/datum/game_mode/changeling/pre_setup()

	if(num_players() <= lowpop_amount)
		if(!prob((2*1.14**num_players())-2)) //exponential equation, chance of restriction goes up as pop goes down.
			protected_jobs += GLOB.command_positions

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/num_changelings = 1

	var/csc = CONFIG_GET(number/changeling_scaling_coeff)
	if(csc)
		num_changelings = max(1, min(round(num_players() / (csc * 2)) + 2, round(num_players() / csc)))
	else
		num_changelings = max(1, min(num_players(), changeling_amount))

	if(antag_candidates.len>0)
		for(var/i = 0, i < num_changelings, i++)
			if(!antag_candidates.len)
				break
			var/datum/mind/changeling = antag_pick(antag_candidates)
			antag_candidates -= changeling
			changelings += changeling
			changeling.special_role = ROLE_CHANGELING
			changeling.restricted_roles = restricted_jobs
		return 1
	else
		setup_error = "Not enough changeling candidates"
		return 0

/datum/game_mode/changeling/post_setup()
	//Decide if it's ok for the lings to have a team objective
	//And then set it up to be handed out in forge_changeling_objectives
	var/list/team_objectives = subtypesof(/datum/objective/changeling_team_objective)
	var/list/possible_team_objectives = list()
	for(var/T in team_objectives)
		var/datum/objective/changeling_team_objective/CTO = T

		if(changelings.len >= initial(CTO.min_lings))
			possible_team_objectives += T

	if(possible_team_objectives.len && prob(20*changelings.len))
		GLOB.changeling_team_objective_type = pick(possible_team_objectives)

	for(var/datum/mind/changeling in changelings)
		//log_game("[key_name(changeling)] has been selected as a changeling") | yogs - redundant
		var/datum/antagonist/changeling/new_antag = new()
		//new_antag.team_mode = TRUE //yogs - lol
		changeling.add_antag_datum(new_antag)
	..()

/datum/game_mode/changeling/make_antag_chance(mob/living/carbon/human/character) //Assigns changeling to latejoiners
	var/csc = CONFIG_GET(number/changeling_scaling_coeff)
	var/changelingcap = min(round(GLOB.joined_player_list.len / (csc * 2)) + 2, round(GLOB.joined_player_list.len / csc))
	if(changelings.len >= changelingcap) //Caps number of latejoin antagonists
		return
	if(changelings.len <= (changelingcap - 2) || prob(100 - (csc * 2)))
		if(ROLE_CHANGELING in character.client.prefs.be_special)
			if(!is_banned_from(character.ckey, list(ROLE_CHANGELING, ROLE_SYNDICATE)) && !QDELETED(character))
				if(age_check(character.client))
					if(!(character.job in restricted_jobs))
						character.mind.make_Changeling()
						changelings += character.mind

/datum/game_mode/changeling/generate_report()
	return "The Gorlex Marauders have announced the successful raid and destruction of Central Command containment ship #S-[rand(1111, 9999)]. This ship housed only a single prisoner - \
			codenamed \"Thing\", and it was highly adaptive and extremely dangerous. We have reason to believe that the Thing has allied with the Syndicate, and you should note that likelihood \
			of the Thing being sent to a station in this sector is highly likely. It may be in the guise of any crew member. Trust nobody - suspect everybody. Do not announce this to the crew, \
			as paranoia may spread and inhibit workplace efficiency."

/proc/is_changeling(mob/M) //Usefull check changeling
	return M?.mind?.has_antag_datum(/datum/antagonist/changeling)

/proc/changeling_transform(mob/living/carbon/human/user, datum/changelingprofile/chosen_prof)
	var/datum/dna/chosen_dna = chosen_prof.dna
	user.real_name = chosen_prof.name
	user.underwear = chosen_prof.underwear
	user.undershirt = chosen_prof.undershirt
	user.socks = chosen_prof.socks
	user.mind.accent_name = chosen_prof.accent
	user.mind.RegisterSignal(user, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/mind, handle_speech))

	chosen_dna.transfer_identity(user, 1)
	user.updateappearance(mutcolor_update=1)
	user.update_body()
	user.domutcheck()

	// get rid of any scars from previous changeling-ing
	for(var/i in user.all_scars)
		var/datum/scar/iter_scar = i
		if(iter_scar.fake)
			qdel(iter_scar)

	//vars hackery. not pretty, but better than the alternative.
	for(var/slot in GLOB.slots)
		if(istype(user.vars[slot], GLOB.slot2type[slot]) && !(chosen_prof.exists_list[slot])) //remove unnecessary flesh items
			qdel(user.vars[slot])
			continue

		if((user.vars[slot] && !istype(user.vars[slot], GLOB.slot2type[slot])) || !(chosen_prof.exists_list[slot]))
			continue

		var/obj/item/new_flesh_item
		var/equip = 0
		if(!user.vars[slot])
			var/thetype = GLOB.slot2type[slot]
			equip = 1
			new_flesh_item = new thetype(user)

		else if(istype(user.vars[slot], GLOB.slot2type[slot]))
			new_flesh_item = user.vars[slot]

		new_flesh_item.appearance = chosen_prof.appearance_list[slot]
		new_flesh_item.name = chosen_prof.name_list[slot]
		new_flesh_item.flags_cover = chosen_prof.flags_cover_list[slot]
		new_flesh_item.lefthand_file = chosen_prof.lefthand_file_list[slot]
		new_flesh_item.righthand_file = chosen_prof.righthand_file_list[slot]
		new_flesh_item.item_state = chosen_prof.inhand_icon_state_list[slot]
		new_flesh_item.worn_icon = chosen_prof.worn_icon_list[slot]
		new_flesh_item.worn_icon_state = chosen_prof.worn_icon_state_list[slot]
		new_flesh_item.sprite_sheets = chosen_prof.sprite_sheets_list[slot]

		if(equip)
			user.equip_to_slot_or_del(new_flesh_item, GLOB.slot2slot[slot])
	for(var/stored_scar_line in chosen_prof.stored_scars)
		var/datum/scar/attempted_fake_scar = user.load_scar(stored_scar_line)
		if(attempted_fake_scar)
			attempted_fake_scar.fake = TRUE

	user.regenerate_icons()

/datum/game_mode/changeling/generate_credit_text()
	var/list/round_credits = list()
	var/len_before_addition

	round_credits += "<center><h1>The Slippery Changelings:</h1>"
	len_before_addition = round_credits.len
	for(var/datum/mind/M in changelings)
		var/datum/antagonist/changeling/cling = M.has_antag_datum(/datum/antagonist/changeling)
		if(cling)
			round_credits += "<center><h2>[cling.changelingID] in the body of [M.name]</h2>"
	if(len_before_addition == round_credits.len)
		round_credits += list("<center><h2>Uh oh, we lost track of the shape shifters!</h2>", "<center><h2>Nobody move!</h2>")
	round_credits += "<br>"

	round_credits += ..()
	return round_credits
