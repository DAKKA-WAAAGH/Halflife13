//gang.dm
//Gang War Game Mode
GLOBAL_LIST_INIT(possible_gangs, subtypesof(/datum/team/gang))
GLOBAL_LIST_EMPTY(gangs)
/datum/game_mode/gang
	name = "gang war"
	config_tag = "gang"
	antag_flag = ROLE_GANG
	restricted_jobs = list("Civil Protection Officer", "Warden", "Detective", "AI", "Cyborg","City Administrator", "Labor Lead", "Divisional Lead", "Chief Engineer", "Research Director", "Chief Medical Officer", "Brig Physician", "Synthetic") //Added Brig Physician
	required_players = 35
	required_enemies = 1
	recommended_enemies = 2
	enemy_minimum_age = 14
	title_icon = "gang"

	announce_span = "danger"
	announce_text = "A violent turf war has erupted on the station!\n\
	<span class='danger'>Gangsters</span>: Take over the station with a dominator.\n\
	<span class='notice'>Crew</span>: Prevent the gangs from expanding and initiating takeover."

	var/list/datum/mind/gangboss_candidates = list()

/datum/game_mode/gang/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	//Spawn more bosses depending on server population
	var/gangs_to_create = 4
	if(prob(num_players()) && num_players() > 1.5*required_players)
		gangs_to_create++
	if(prob(num_players()) && num_players() > 2*required_players)
		gangs_to_create++
	gangs_to_create = min(gangs_to_create, GLOB.possible_gangs.len)

	for(var/i in 1 to gangs_to_create)
		if(!antag_candidates.len)
			break

		//Now assign a boss for the gang
		var/datum/mind/boss = antag_pick(antag_candidates)
		antag_candidates -= boss
		gangboss_candidates += boss
		boss.special_role = ROLE_GANG
		boss.restricted_roles = restricted_jobs

	if(gangboss_candidates.len < 1) //Need at least one gangs
		return

	return TRUE

/datum/game_mode/gang/post_setup()
	..()
	for(var/i in gangboss_candidates)
		var/datum/mind/M = i
		var/datum/antagonist/gang/boss/B = new()
		M.add_antag_datum(B)
		B.equip_gang()

/proc/is_gangster(mob/M) // Gangster Checks
	return M?.mind?.has_antag_datum(/datum/antagonist/gang)

/proc/is_gang_boss(mob/M)
	return M?.mind?.has_antag_datum(/datum/antagonist/gang/boss)

/datum/game_mode/gang/generate_credit_text()
	var/list/round_credits = list()
	var/len_before_addition

	for(var/datum/team/gang/G in GLOB.gangs)
		round_credits += "<center><h1>The [G.name] Gang:</h1>"
		len_before_addition = round_credits.len
		for(var/datum/mind/boss in G.leaders)
			round_credits += "<center><h2>[boss.name] as a [G.name] Gang leader</h2>"
		for(var/datum/mind/gangster in (G.members - G.leaders))
			round_credits += "<center><h2>[gangster.name] as a [G.name] gangster</h2>"
		if(len_before_addition == round_credits.len)
			round_credits += list("<center><h2>The [G.name] Gang was wiped out!</h2>", "<center><h2>The competition was too tough!</h2>")
		round_credits += "<br>"

	round_credits += ..()
	return round_credits

/datum/game_mode/gang/set_round_result()
	..()
	var/didGangsWin = FALSE
	for(var/datum/team/gang/G in GLOB.gangs)
		if(G.winner)
			didGangsWin = TRUE
			break

	if(didGangsWin)
		SSticker.mode_result = "win - gangs dominated the station"
	else
		SSticker.mode_result = "loss - security stopped gangs from dominating the station"
