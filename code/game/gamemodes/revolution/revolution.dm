// To add a rev to the list of revolutionaries, make sure it's rev (with if(SSticker.mode.name == "revolution)),
// then call SSticker.mode:add_revolutionary(_THE_PLAYERS_MIND_)
// nothing else needs to be done, as that proc will check if they are a valid target.
// Just make sure the converter is a head before you call it!
// To remove a rev (from brainwashing or w/e), call SSticker.mode:remove_revolutionary(_THE_PLAYERS_MIND_),
// this will also check they're not a head, so it can just be called freely
// If the game somtimes isn't registering a win properly, then SSticker.mode.check_win() isn't being called somewhere.

//Timer after all heads/headrevs die, before we check again and end the round
#define REV_VICTORY_TIMER (2.5 MINUTES)
//If revs haven't "won" by this time (from the start of the round) then there will be an announcement, basically forcing them to go loud.
#define REV_LOUD_TIMER (1 HOURS)

/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"
	report_type = "revolution"
	antag_flag = ROLE_REV_HEAD
	false_report_weight = 10
	restricted_jobs = list("Civil Protection Officer", "Warden", "Detective", "AI", "Cyborg", "City Administrator", "Labor Lead", "Divisional Lead", "Chief Engineer", "Research Director", "Chief Medical Officer", "Shaft Miner", "Mining Medic", "Brig Physician", "Synthetic") //Yogs: Added Brig Physician
	required_jobs = list(list("City Administrator"=1),list("Labor Lead"=1),list("Divisional Lead"=1),list("Chief Engineer"=1),list("Research Director"=1),list("Chief Medical Officer"=1)) //Any head present
	required_players = 25
	required_enemies = 2
	recommended_enemies = 3
	enemy_minimum_age = 14

	announce_span = "Revolution"
	announce_text = "Some crewmembers are attempting a coup!\n\
	<span class='danger'>Revolutionaries</span>: Expand your cause and overthrow the heads of staff by execution or otherwise.\n\
	<span class='notice'>Crew</span>: Prevent the revolutionaries from taking over the station."

	var/finished = 0
	var/check_counter = 0
	var/max_headrevs = 3
	var/datum/team/revolution/revolution
	var/list/datum/mind/headrev_candidates = list()
	var/end_when_heads_dead = TRUE

	var/victory_timer

	var/victory_timer_ended = FALSE

	var/go_fucking_loud_time = 0
	var/loud = FALSE //HAVE WE BEEN ANNOUNCED?!?!?!?!

///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	for (var/i=1 to max_headrevs)
		if (antag_candidates.len==0)
			break
		var/datum/mind/lenin = antag_pick(antag_candidates)
		antag_candidates -= lenin
		headrev_candidates += lenin
		lenin.restricted_roles = restricted_jobs

	if(headrev_candidates.len < required_enemies)
		setup_error = "Not enough headrev candidates"
		return FALSE

	return TRUE

/datum/game_mode/revolution/post_setup()
	var/list/heads = SSjob.get_living_heads()
	var/list/sec = SSjob.get_living_sec()
	var/weighted_score = min(max(round(heads.len - ((8 - sec.len) / 3)),1),max_headrevs)

	for(var/datum/mind/rev_mind in headrev_candidates)	//People with return to lobby may still be in the lobby. Let's pick someone else in that case.
		if(isnewplayer(rev_mind.current))
			headrev_candidates -= rev_mind
			var/list/newcandidates = shuffle(antag_candidates)
			if(newcandidates.len == 0)
				continue
			for(var/M in newcandidates)
				var/datum/mind/lenin = M
				antag_candidates -= lenin
				newcandidates -= lenin
				if(isnewplayer(lenin.current)) //We don't want to make the same mistake again
					continue
				else
					var/mob/Nm = lenin.current
					if(Nm.job in restricted_jobs)	//Don't make the HOS a replacement revhead
						antag_candidates += lenin	//Let's let them keep antag chance for other antags
						continue

					headrev_candidates += lenin
					break

	var/list/temp_candidates = headrev_candidates.Copy()

	// Remove excess headrevs, skip those who have used an antag token
	while(weighted_score < headrev_candidates.len && temp_candidates.len) //das vi danya
		var/datum/mind/trotsky = pick_n_take(temp_candidates)
		if(trotsky.token_picked)
			continue
		antag_candidates += trotsky
		headrev_candidates -= trotsky

	// If there are still too many head revs, start removing the ones that have used tokens (Token will not be consumed)
	while(weighted_score < headrev_candidates.len) //das vi danya
		var/datum/mind/trotsky = pick(headrev_candidates)
		antag_candidates += trotsky
		headrev_candidates -= trotsky

	revolution = new()

	for(var/datum/mind/rev_mind in headrev_candidates)
		//log_game("[key_name(rev_mind)] has been selected as a head rev") | yogs - redundant
		var/datum/antagonist/rev/head/new_head = new()
		new_head.give_flash = TRUE
		new_head.give_hud = TRUE
		new_head.remove_clumsy = TRUE
		rev_mind.add_antag_datum(new_head,revolution)

	revolution.update_objectives()
	revolution.update_heads()

	SSshuttle.registerHostileEnvironment(src)

	go_fucking_loud_time = world.time + REV_LOUD_TIMER

	..()


/datum/game_mode/revolution/process()
	check_counter++
	if(check_counter >= 5)
		if(!finished)
			SSticker.mode.check_win()
		check_counter = 0
		if(!loud && go_fucking_loud_time && world.time >= go_fucking_loud_time)
			go_loud()
	return FALSE

/datum/game_mode/revolution/proc/go_loud()
	loud = TRUE //OH FUCK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	priority_announce("Through intercepted transmissions, we have detected a group of anti-corporate activists on [station_name()]. Comply with Command and Security personnel, and report all anti-corporate or revolutionary activities.", null, null, null, "Central Command Intelligence Division")
	message_admins("The revolution has been detected and announced.")
	log_game("The revolution has been detected and announced.")

//////////////////////////////////////
//Checks if the revs have won or not//
//////////////////////////////////////
/datum/game_mode/revolution/check_win()
	if(victory_timer_ended && victory_timer)
		victory_timer = null

	if(check_rev_victory())
		if(!loud)
			go_loud()
		if(victory_timer_ended)
			finished = 1
		if(!victory_timer)
			victory_timer = addtimer(VARSET_CALLBACK(src, victory_timer_ended, TRUE), REV_VICTORY_TIMER)
			message_admins("Revs victory timer started")
			log_game("Revs victory timer started")

	else if(check_heads_victory())
		if(victory_timer_ended)
			finished = 2
		if(!victory_timer)
			victory_timer = addtimer(VARSET_CALLBACK(src, victory_timer_ended, TRUE), REV_VICTORY_TIMER)
			message_admins("Revs victory timer started")
			log_game("Revs victory timer started")

	if(victory_timer_ended)
		victory_timer = null
		victory_timer_ended = FALSE
	return

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/revolution/check_finished()
	if(CONFIG_GET(keyed_list/continuous)["revolution"])
		if(finished)
			SSshuttle.clearHostileEnvironment(src)
		return ..()
	if(finished != 0 && end_when_heads_dead)
		return TRUE
	else
		return ..()

///////////////////////////////////////////////////
//Deals with converting players to the revolution//
///////////////////////////////////////////////////
/proc/is_revolutionary(mob/M)
	return M?.mind?.has_antag_datum(/datum/antagonist/rev)

/proc/is_head_revolutionary(mob/M)
	return M?.mind?.has_antag_datum(/datum/antagonist/rev/head)

//////////////////////////
//Checks for rev victory//
//////////////////////////
/datum/game_mode/revolution/proc/check_rev_victory()
	for(var/datum/objective/mutiny/objective in revolution.objectives)
		if(!(objective.check_completion()))
			return FALSE
	return TRUE

/////////////////////////////
//Checks for a head victory//
/////////////////////////////
/datum/game_mode/revolution/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in revolution.head_revolutionaries())
		var/turf/T = get_turf(rev_mind.current)
		if(!considered_afk(rev_mind) && considered_alive(rev_mind) && is_station_level(T.z))
			if(ishuman(rev_mind.current) || ismonkey(rev_mind.current))
				return FALSE
	return TRUE


/datum/game_mode/revolution/set_round_result()
	..()
	if(finished == 1)
		SSticker.mode_result = "win - heads killed"
		SSticker.news_report = REVS_WIN
	else if(finished == 2)
		SSticker.mode_result = "loss - rev heads killed"
		SSticker.news_report = REVS_LOSE

//TODO What should be displayed for revs in non-rev rounds
/datum/game_mode/revolution/special_report()
	if(finished == 1)
		return "<span class='redtext big'>The heads of staff were killed or exiled! The revolutionaries win!</span>"
	else if(finished == 2)
		return "<span class='redtext big'>The heads of staff managed to stop the revolution!</span>"

/datum/game_mode/revolution/generate_report()
	return "Employee unrest has spiked in recent weeks, with several attempted mutinies on heads of staff. Some crew have been observed using flashbulb devices to blind their colleagues, \
		who then follow their orders without question and work towards dethroning departmental leaders. Watch for behavior such as this with caution. If the crew attempts a mutiny, you and \
		your heads of staff are fully authorized to execute them using lethal weaponry - they will be later cloned and interrogated at Central Command."

/datum/game_mode/revolution/extended
	name = "extended_revolution"
	config_tag = "extended_revolution"
	end_when_heads_dead = FALSE

/datum/game_mode/revolution/speedy
	name = "speedy_revolution"
	config_tag = "speedy_revolution"
	end_when_heads_dead = FALSE
	var/endtime = null
	var/fuckingdone = FALSE

/datum/game_mode/revolution/speedy/pre_setup()
	endtime = world.time + 20 MINUTES
	return ..()

/datum/game_mode/revolution/speedy/process()
	. = ..()
	if(check_counter == 0)
		if (world.time > endtime && !fuckingdone)
			fuckingdone = TRUE
			for (var/obj/machinery/nuclearbomb/N in GLOB.nuke_list)
				if (!N.timing)
					N.timer_set = 200
					N.set_safety()
					N.set_active()

/datum/game_mode/revolution/generate_credit_text()
	var/list/round_credits = list()
	var/len_before_addition

	round_credits += "<center><h1>The Disgruntled Revolutionaries:</h1>"
	len_before_addition = round_credits.len
	for(var/datum/mind/headrev in revolution.head_revolutionaries())
		round_credits += "<center><h2>[headrev.name] as a revolutionary leader</h2>"
	for(var/datum/mind/grunt in (revolution.members - revolution.head_revolutionaries()))
		round_credits += "<center><h2>[grunt.name] as a grunt of the revolution</h2>"
	if(len_before_addition == round_credits.len)
		round_credits += list("<center><h2>The revolutionaries were all destroyed as martyrs!</h2>", "<center><h2>We couldn't identify their remains!</h2>")
	round_credits += "<br>"

	round_credits += ..()
	return round_credits
