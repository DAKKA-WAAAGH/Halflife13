//////////////////////////////////////////////
//                                          //
//            LATEJOIN RULESETS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/trim_candidates()
	for(var/mob/P in candidates)
		if (!P.client || !P.mind || !P.mind.assigned_role) // Are they connected?
			candidates.Remove(P)
			continue
		if(!mode.check_age(P.client, minimum_required_age))
			candidates.Remove(P)
			continue
		if(antag_flag_override)
			if(!(antag_flag_override in P.client.prefs.be_special) || is_banned_from(P.ckey, list(antag_flag_override, ROLE_SYNDICATE)))
				candidates.Remove(P)
				continue
		else
			if(!(antag_flag in P.client.prefs.be_special) || is_banned_from(P.ckey, list(antag_flag, ROLE_SYNDICATE)))
				candidates.Remove(P)
				continue
		if (P.mind.assigned_role in restricted_roles) // Does their job allow for it?
			candidates.Remove(P)
			continue
		if ((exclusive_roles.len > 0) && !(P.mind.assigned_role in exclusive_roles)) // Is the rule exclusive to their job?
			candidates.Remove(P)
			continue
		if(P.mind.quiet_round) //Does the candidate have quiet mode enabled?
			candidates.Remove(P)
			continue
		if(P.mind && !(P.mind.assigned_role in GLOB.crew_positions)) //don't antag non crewmembers
			candidates.Remove(P)
			continue

/datum/dynamic_ruleset/latejoin/ready(forced = 0)
	if (!forced)
		var/job_check = 0
		if (enemy_roles.len > 0)
			for (var/mob/M in mode.current_players[CURRENT_LIVING_PLAYERS])
				if (M.stat == DEAD)
					continue // Dead players cannot count as opponents
				if (M.mind && M.mind.assigned_role && (M.mind.assigned_role in enemy_roles) && (!(M in candidates) || (M.mind.assigned_role in restricted_roles)))
					job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that rule, or have a job that restricts them from it

		var/threat = round(mode.threat_level/10)
		if (job_check < required_enemies[threat])
			return FALSE
	return ..()

/datum/dynamic_ruleset/latejoin/execute()
	var/mob/M = pick(candidates)
	assigned += M.mind
	M.mind.special_role = antag_flag
	M.mind.add_antag_datum(antag_datum)
	return TRUE

//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/infiltrator
	name = "Syndicate Infiltrator"
	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_TRAITOR
	protected_roles = list("Civil Protection Officer", "Warden", "Detective", "Divisional Lead", "City Administrator", "Labor Lead", "Chief Engineer", "Chief Medical Officer", "Research Director", "Brig Physician")
	restricted_roles = list("AI","Cyborg", "Synthetic")
	required_candidates = 1
	weight = 7
	cost = 10
	requirements = list(40,30,20,10,10,10,10,10,10,10)
	repeatable = TRUE

//////////////////////////////////////////////
//                                          //
//       REVOLUTIONARY PROVOCATEUR          //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/provocateur
	name = "Provocateur"
	persistent = TRUE
	antag_datum = /datum/antagonist/rev/head
	antag_flag = ROLE_REV_HEAD
	antag_flag_override = ROLE_REV
	restricted_roles = list("AI", "Cyborg", "Civil Protection Officer", "Warden", "Detective", "Divisional Lead", "City Administrator", "Labor Lead", "Chief Engineer", "Chief Medical Officer", "Research Director", "Synthetic")
	enemy_roles = list("AI", "Cyborg", "Civil Protection Officer","Detective","Divisional Lead", "City Administrator", "Warden")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 1
	cost = 100000
	delay = 1 MINUTES
	requirements = list(80,75,60,60,55,50,40,30,20,20)
	blocking_rules = list(/datum/dynamic_ruleset/roundstart/revs)
	var/required_heads_of_staff = 3
	var/finished = FALSE
	var/datum/team/revolution/revolution
	minimum_players = 30

/datum/dynamic_ruleset/latejoin/provocateur/ready(forced=FALSE)
	if (forced)
		required_heads_of_staff = 1
	if(!..())
		return FALSE
	var/head_check = 0
	for(var/mob/player in mode.current_players[CURRENT_LIVING_PLAYERS])
		if (player.mind.assigned_role in GLOB.command_positions)
			head_check++
	return (head_check >= required_heads_of_staff)

/datum/dynamic_ruleset/latejoin/provocateur/execute()
	var/mob/M = pick(candidates)	// This should contain a single player, but in case.
	if(check_eligible(M.mind))	// Didnt die/run off z-level/get implanted since leaving shuttle.
		assigned += M.mind
		M.mind.special_role = antag_flag
		revolution = new()
		var/datum/antagonist/rev/head/new_head = new()
		new_head.give_flash = TRUE
		new_head.give_hud = TRUE
		new_head.remove_clumsy = TRUE
		new_head = M.mind.add_antag_datum(new_head, revolution)
		revolution.update_objectives()
		revolution.update_heads()
		SSshuttle.registerHostileEnvironment(src)
		return TRUE
	else
		log_game("DYNAMIC: [ruletype] [name] discarded [M.name] from head revolutionary due to ineligibility.")
		log_game("DYNAMIC: [ruletype] [name] failed to get any eligible headrevs. Refunding [cost] threat.")
		return FALSE

/datum/dynamic_ruleset/latejoin/provocateur/rule_process()
	if(check_rev_victory())
		finished = REVOLUTION_VICTORY
		return RULESET_STOP_PROCESSING
	else if (check_heads_victory())
		finished = STATION_VICTORY
		SSshuttle.clearHostileEnvironment(src)
		revolution.save_members()
		for(var/datum/mind/M in revolution.members)	// Remove antag datums and prevents podcloned or exiled headrevs restarting rebellions.
			if(M.has_antag_datum(/datum/antagonist/rev/head))
				var/datum/antagonist/rev/head/R = M.has_antag_datum(/datum/antagonist/rev/head)
				R.remove_revolutionary(FALSE, "gamemode")
				if(M.current)
					var/mob/living/carbon/C = M.current
					if(istype(C) && C.stat == DEAD)
						C.makeUncloneable()
			if(M.has_antag_datum(/datum/antagonist/rev))
				var/datum/antagonist/rev/R = M.has_antag_datum(/datum/antagonist/rev)
				R.remove_revolutionary(FALSE, "gamemode")
		priority_announce("It appears the mutiny has been quelled. Please return yourself and your incapacitated colleagues to work. \
			We have remotely blacklisted the head revolutionaries in your medical records to prevent accidental revival.", null, null, null, "Central Command Loyalty Monitoring Division")
		return RULESET_STOP_PROCESSING



/// Checks for revhead loss conditions and other antag datums.
/datum/dynamic_ruleset/latejoin/provocateur/proc/check_eligible(datum/mind/M)
	var/turf/T = get_turf(M.current)
	if(!considered_afk(M) && considered_alive(M) && is_station_level(T.z) && !M.antag_datums?.len && !HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return TRUE
	return FALSE

/datum/dynamic_ruleset/latejoin/provocateur/check_finished()
	if(finished == REVOLUTION_VICTORY)
		return TRUE
	else
		return ..()

/datum/dynamic_ruleset/latejoin/provocateur/proc/check_rev_victory()
	for(var/datum/objective/mutiny/objective in revolution.objectives)
		if(!(objective.check_completion()))
			return FALSE
	return TRUE

/datum/dynamic_ruleset/latejoin/provocateur/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in revolution.head_revolutionaries())
		var/turf/T = get_turf(rev_mind.current)
		if(!considered_afk(rev_mind) && considered_alive(rev_mind) && is_station_level(T.z))
			if(ishuman(rev_mind.current) || ismonkey(rev_mind.current))
				return FALSE
	return TRUE

/datum/dynamic_ruleset/latejoin/provocateur/round_result()
	if(finished == REVOLUTION_VICTORY)
		SSticker.mode_result = "win - heads killed"
		SSticker.news_report = REVS_WIN
	else if(finished == STATION_VICTORY)
		SSticker.mode_result = "loss - rev heads killed"
		SSticker.news_report = REVS_LOSE

//////////////////////////////////////////////
//                                          //
//                VAMPIRE                   //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/vampire
	name = "Vampiric Infiltrator"
	antag_flag = ROLE_VAMPIRE
	antag_datum = /datum/antagonist/vampire
	protected_roles = list("Divisional Lead", "City Administrator", "Labor Lead", "Research Director", "Chief Engineer", "Chief Medical Officer", "Civil Protection Officer", "Chaplain", "Detective", "Warden", "Brig Physician")
	restricted_roles = list("AI", "Cyborg", "Synthetic")
	required_candidates = 1
	weight = 4
	cost = 15
	requirements = list(45,40,40,35,30,30,20,20,20,20)
	minimum_players = 15
	repeatable = TRUE


//////////////////////////////////////////////
//                                          //
//           HERETIC SMUGGLER          		//
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/heretic_smuggler
	name = "Heretic Smuggler"
	antag_datum = /datum/antagonist/heretic
	antag_flag = ROLE_HERETIC
	protected_roles = list("Chaplain","Civil Protection Officer", "Warden", "Detective", "Divisional Lead", "City Administrator", "Labor Lead", "Research Director", "Chief Engineer", "Chief Medical Officer", "Brig Physician")
	restricted_roles = list("AI","Cyborg", "Synthetic")
	required_candidates = 1
	weight = 2
	cost = 15
	requirements = list(45,40,30,30,20,20,15,10,10,10)
	minimum_players = 36
	repeatable = TRUE

//////////////////////////////////////////////
//                                          //
//              BLOODSUCKER                 //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/bloodsucker
	name = "Bloodsucker Breakout"
	antag_datum = /datum/antagonist/bloodsucker
	antag_flag = ROLE_BLOODSUCKERBREAKOUT
	antag_flag_override = ROLE_BLOODSUCKER
	protected_roles = list(
		"City Administrator", "Labor Lead", "Divisional Lead",
		"Warden", "Civil Protection Officer", "Detective", "Brig Physician",
		"Curator"
	)
	restricted_roles = list("AI","Cyborg", "Synthetic")
	required_candidates = 1
	weight = 5
	cost = 10
	requirements = list(10,10,10,10,10,10,10,10,10,10)
	minimum_players = 25
	repeatable = FALSE

/datum/dynamic_ruleset/latejoin/bloodsucker/trim_candidates()
	. = ..()
	for(var/mob/living/carbon/C in candidates)
		if(C?.dna?.species && (NOBLOOD in C?.dna?.species.species_traits))
			candidates -= C
			continue

/datum/dynamic_ruleset/latejoin/bloodsucker/execute()
	var/mob/latejoiner = pick(candidates) // This should contain a single player, but in case.
	assigned += latejoiner.mind

	for(var/selected_player in assigned)
		var/datum/mind/bloodsuckermind = selected_player
		var/datum/antagonist/bloodsucker/sucker = new
		if(!bloodsuckermind.make_bloodsucker(selected_player))
			assigned -= selected_player
			message_admins("[ADMIN_LOOKUPFLW(selected_player)] was selected by the [name] ruleset, but couldn't be made into a Bloodsucker.")
			return FALSE
		sucker.bloodsucker_level_unspent = rand(3,4)
		message_admins("[ADMIN_LOOKUPFLW(selected_player)] was selected by the [name] ruleset and has been made into a midround Bloodsucker.")
		log_game("DYNAMIC: [key_name(selected_player)] was selected by the [name] ruleset and has been made into a midround Bloodsucker.")
	return TRUE
