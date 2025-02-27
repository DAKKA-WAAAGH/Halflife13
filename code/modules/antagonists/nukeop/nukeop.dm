/datum/antagonist/nukeop
	name = "Rebel"
	roundend_category = "rebels" //just in case
	antagpanel_category = "Rebels"
	job_rank = ROLE_REBEL
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/rebel
	show_to_ghosts = TRUE
	show_in_antagpanel = TRUE
	var/datum/team/nuclear/nuke_team
	var/always_new_team = FALSE //If not assigned a team by default ops will try to join existing ones, set this to TRUE to always create new team.
	var/send_to_spawnpoint = TRUE //Should the user be moved to default spawnpoint.
	var/nukeop_outfit = /datum/outfit/rebel
	can_hijack = HIJACK_HIJACKER //Alternative way to wipe out the station.

	preview_outfit = /datum/outfit/rebel

	/// In the preview icon, the nukies who are behind the leader
	var/preview_outfit_behind = /datum/outfit/rebel

/datum/antagonist/nukeop/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current, /datum/antagonist/nukeop)
	ADD_TRAIT(owner, TRAIT_DISK_VERIFIER, NUKEOP_TRAIT)

/datum/antagonist/nukeop/remove_innate_effects(mob/living/mob_override)
	REMOVE_TRAIT(owner, TRAIT_DISK_VERIFIER, NUKEOP_TRAIT)

/datum/antagonist/nukeop/proc/equip_op()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/H = owner.current

	H.set_species(/datum/species/human) //Plasamen burn up otherwise, and lizards are vulnerable to asimov AIs

	H.equipOutfit(nukeop_outfit)
	return TRUE

/datum/antagonist/nukeop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/particleghost.ogg',50,0)
	to_chat(owner, span_notice("You are a member of the resistance!"))
	owner.announce_objectives()

/datum/antagonist/nukeop/on_gain()
	. = ..()
	equip_op()
	if(send_to_spawnpoint)
		move_to_spawnpoint()



/datum/antagonist/nukeop/get_team()
	return nuke_team

/datum/antagonist/nukeop/proc/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/syndicate/nuke = find_nuke() //Yogs -- Puts find_nuke() here to fix bananium nukes fucking up normal nuke ops
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == "ADMIN")
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
			for(var/obj/machinery/nuclearbomb/beer/beernuke in GLOB.nuke_list)
				beernuke.r_code = nuke_team.memorized_code
		else
			stack_trace("Syndicate nuke not found during nuke team creation.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/proc/memorize_code()
	if(nuke_team && nuke_team.tracked_nuke && nuke_team.memorized_code)
		antag_memory += "<B>[nuke_team.tracked_nuke] Code</B>: [nuke_team.memorized_code]<br>"
		to_chat(owner, "The nuclear authorization code is: <B>[nuke_team.memorized_code]</B>")
	else
		to_chat(owner, "Unfortunately the Syndicate was unable to provide you with the nuclear authorization code.")

/datum/antagonist/nukeop/proc/move_to_spawnpoint()
	var/team_number = 1
	if(nuke_team)
		team_number = nuke_team.members.Find(owner)
	owner.current.forceMove(GLOB.nukeop_start[((team_number - 1) % GLOB.nukeop_start.len) + 1])

/datum/antagonist/nukeop/leader/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.nukeop_leader_start))

/datum/antagonist/nukeop/create_team(datum/team/nuclear/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/nukeop/N in GLOB.antagonists)
				if(!N.owner)
					continue
				if(N.nuke_team)
					nuke_team = N.nuke_team
					return
		nuke_team = new /datum/team/nuclear
		nuke_team.update_objectives()
		assign_nuke() //This is bit ugly
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	nuke_team = new_team

/datum/antagonist/nukeop/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = ROLE_SYNDICATE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has nuke op'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has nuke op'ed [key_name(new_owner)].")

/datum/antagonist/nukeop/get_admin_commands()
	. = ..()
	.["Send to base"] = CALLBACK(src, PROC_REF(admin_send_to_base))
	.["Tell code"] = CALLBACK(src, PROC_REF(admin_tell_code))

/datum/antagonist/nukeop/proc/admin_send_to_base(mob/admin)
	owner.current.forceMove(pick(GLOB.nukeop_start))

/datum/antagonist/nukeop/proc/admin_tell_code(mob/admin)
	var/code
	for (var/obj/machinery/nuclearbomb/bombue in GLOB.machines)
		if (length(bombue.r_code) <= 5 && bombue.r_code != initial(bombue.r_code))
			code = bombue.r_code
			break
	if (code)
		antag_memory += "<B>Syndicate Nuclear Bomb Code</B>: [code]<br>"
		to_chat(owner.current, "The nuclear authorization code is: <B>[code]</B>")
	else
		to_chat(admin, span_danger("No valid nuke found!"))

/datum/antagonist/nukeop/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/captain = new
	var/icon/final_icon = render_preview_outfit(preview_outfit, captain)
	final_icon.Blend(make_assistant_icon(), ICON_UNDERLAY, -8, 0)
	final_icon.Blend(make_assistant_icon(), ICON_UNDERLAY, 8, 0)

	return finish_preview_icon(final_icon)

/datum/antagonist/nukeop/proc/make_assistant_icon()
	var/mob/living/carbon/human/dummy/assistant = new
	var/icon/assistant_icon = render_preview_outfit(preview_outfit_behind, assistant)
	assistant_icon.ChangeOpacity(0.5)

	return assistant_icon

/datum/outfit/nuclear_operative
	name = "Nuclear Operative (Preview only)"
	mask = /obj/item/clothing/mask/gas/syndicate
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/syndi
	head = /obj/item/clothing/head/helmet/space/hardsuit/syndi

/datum/outfit/nuclear_operative_elite
	name = "Nuclear Operative (Elite, Preview only)"
	mask = /obj/item/clothing/mask/gas/syndicate
	uniform = /obj/item/clothing/under/syndicate 
	suit = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	head = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	r_hand = /obj/item/shield/energy

/datum/outfit/nuclear_operative_elite/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/shield/energy/shield = locate() in H.held_items
	shield.icon_state = "[shield.base_icon_state]1"
	H.update_inv_hands()

/datum/antagonist/nukeop/leader
	name = "Nuclear Operative Leader"
	nukeop_outfit = /datum/outfit/rebel
	always_new_team = TRUE
	var/title
	preview_outfit = /datum/outfit/rebel
	preview_outfit_behind = /datum/outfit/rebel
	
/datum/antagonist/nukeop/leader/memorize_code()
	..()
	if(nuke_team && nuke_team.memorized_code)
		var/obj/item/paper/P = new
		P.info = "The nuclear authorization code is: <b>[nuke_team.memorized_code]</b>"
		P.name = "nuclear bomb code"
		var/mob/living/carbon/human/H = owner.current
		if(!istype(H))
			P.forceMove(get_turf(H))
		else
			H.put_in_hands(P, TRUE, no_sound = TRUE)
			H.update_icons()

/datum/antagonist/nukeop/leader/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0)
	to_chat(owner, "<B>You are the Syndicate Boss for this mission. You are responsible for the distribution of telecrystals and your ID is the only one who can open the launch bay doors.</B>")
	to_chat(owner, "<B>If you feel you are not up to this task, give your ID to another operative.</B>")
	to_chat(owner, "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>")
	owner.announce_objectives()
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 1)


/datum/antagonist/nukeop/leader/proc/nuketeam_name_assign()
	if(!nuke_team)
		return
	nuke_team.rename_team(ask_name())

/datum/team/nuclear/proc/rename_team(new_name)
	syndicate_name = new_name
	name = "[syndicate_name] Team"
	for(var/I in members)
		var/datum/mind/synd_mind = I
		var/mob/living/carbon/human/H = synd_mind.current
		if(!istype(H))
			continue
		var/chosen_name = H.dna.species.random_name(H.gender,0,syndicate_name)
		H.fully_replace_character_name(H.real_name,chosen_name)

/datum/antagonist/nukeop/leader/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = stripped_input(owner.current,"You are the nuke operative [title]. Please choose a last name for your family.", "Name change",randomname)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

	return capitalize(newname)

/datum/outfit/nuclear_operative/leader
	name = "Nuclear Operative Leader (Preview only)"
	neck = /obj/item/clothing/neck/cloak/nukie

/datum/antagonist/nukeop/lone
	name = "Lone Operative"
	always_new_team = TRUE
	send_to_spawnpoint = FALSE //Handled by event
	nukeop_outfit = /datum/outfit/syndicate/full

/datum/antagonist/nukeop/lone/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/selfdestruct/nuke = locate() in GLOB.nuke_list
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == "ADMIN")
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
		else
			stack_trace("Station self destruct not found during lone op team creation.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/reinforcement
	send_to_spawnpoint = FALSE
	nukeop_outfit = /datum/outfit/syndicate/no_crystals

/datum/team/nuclear
	var/syndicate_name
	var/obj/machinery/nuclearbomb/tracked_nuke
	var/core_objective = /datum/objective/survive
	var/memorized_code
	var/list/team_discounts

/datum/team/nuclear/New()
	..()
	syndicate_name = syndicate_name()

/datum/team/nuclear/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O

/datum/team/nuclear/proc/disk_rescued()
	for(var/obj/item/disk/nuclear/D in GLOB.poi_list)
		//If emergency shuttle is in transit disk is only safe on it
		if(SSshuttle.emergency.mode == SHUTTLE_ESCAPE)
			if(!SSshuttle.emergency.is_in_shuttle_bounds(D))
				return FALSE
		//If shuttle escaped check if it's on centcom side
		else if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			if(!D.onCentCom())
				return FALSE
		else //Otherwise disk is safe when on station
			var/turf/T = get_turf(D)
			if(!T || !is_station_level(T.z))
				return FALSE
	return TRUE

/datum/team/nuclear/proc/operatives_dead()
	for(var/I in members)
		var/datum/mind/operative_mind = I
		if(ishuman(operative_mind.current) && (operative_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/team/nuclear/proc/syndies_escaped()
	var/obj/docking_port/mobile/S = SSshuttle.getShuttle("syndicate")
	var/obj/docking_port/stationary/transit/T = locate() in S.loc
	return S && (is_centcom_level(S.z) || T)

/datum/team/nuclear/proc/get_result()
	var/evacuation = EMERGENCY_ESCAPED_OR_ENDGAMED
	var/disk_rescued = disk_rescued()
	var/syndies_didnt_escape = !syndies_escaped()
	var/station_was_nuked = SSticker.mode.station_was_nuked
	var/nuke_off_station = SSticker.mode.nuke_off_station

	if(nuke_off_station == NUKE_SYNDICATE_BASE)
		return NUKE_RESULT_FLUKE
	else if(station_was_nuked && !nuke_off_station && !syndies_didnt_escape)
		return NUKE_RESULT_NUKE_WIN
	else if (station_was_nuked && !nuke_off_station && syndies_didnt_escape)
		return NUKE_RESULT_NOSURVIVORS
	else if (nuke_off_station && !syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION
	else if (nuke_off_station && syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION_DEAD
	else if ((disk_rescued && evacuation) && operatives_dead())
		return NUKE_RESULT_CREW_WIN_SYNDIES_DEAD
	else if (disk_rescued)
		return NUKE_RESULT_CREW_WIN
	else if (!disk_rescued && operatives_dead())
		return NUKE_RESULT_DISK_LOST
	else if (!disk_rescued && evacuation)
		return NUKE_RESULT_DISK_STOLEN
	else
		return	//Undefined result

/datum/team/nuclear/roundend_report()
	var/list/parts = list()
	parts += span_header("Resistance Operatives:")

	var/text = "<br>[span_header("The rebel operatives were:")]"
	var/purchases = ""
	var/TC_uses = 0
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	for(var/I in members)
		var/datum/mind/syndicate = I
		var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[syndicate.key]
		if(H)
			TC_uses += H.total_spent
			purchases += H.generate_render(show_key = FALSE)
	text += printplayerlist(members)
	text += "<br>"
	text += "(Syndicates used [TC_uses] TC) [purchases]"

	parts += text
	handle_achievements()
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/team/nuclear/proc/handle_achievements()
	switch(get_result())
		if(NUKE_RESULT_FLUKE)
			for(var/mob/living/carbon/human/H in GLOB.player_list) //if you observe, too bad
				if(!is_nuclear_operative(H))
					SSachievements.unlock_achievement(/datum/achievement/flukeops, H.client)
		if(NUKE_RESULT_NUKE_WIN, NUKE_RESULT_DISK_LOST)
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				var/datum/mind/M = H.mind
				if(M && M.has_antag_datum(/datum/antagonist/nukeop))
					if(M.has_antag_datum(/datum/antagonist/nukeop/clownop) || M.has_antag_datum(/datum/antagonist/nukeop/leader/clownop))
						SSachievements.unlock_achievement(/datum/achievement/greentext/clownop, H.client)
					else
						SSachievements.unlock_achievement(/datum/achievement/greentext/nukewin, H.client)


/datum/team/nuclear/antag_listing_name()
	if(syndicate_name)
		return "[syndicate_name] Syndicates"
	else
		return "Syndicates"

/datum/team/nuclear/antag_listing_entry()
	var/disk_report = "<b>Nuclear Disk(s)</b><br>"
	disk_report += "<table cellspacing=5>"
	for(var/obj/item/disk/nuclear/N in GLOB.poi_list)
		disk_report += "<tr><td>[N.name], "
		var/atom/disk_loc = N.loc
		while(!isturf(disk_loc))
			if(ismob(disk_loc))
				var/mob/M = disk_loc
				disk_report += "carried by <a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(M)]'>[M.real_name]</a> "
			if(isobj(disk_loc))
				var/obj/O = disk_loc
				disk_report += "in \a [O.name] "
			disk_loc = disk_loc.loc
		disk_report += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td><td><a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(N)]'>FLW</a></td></tr>"
	disk_report += "</table>"
	var/common_part = ..()
	return common_part + disk_report

/datum/team/nuclear/is_gamemode_hero()
	return SSticker.mode.name == "nuclear emergency"
