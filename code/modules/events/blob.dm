/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/ghost_role/blob
	weight = 8
	max_occurrences = 0
	min_players = 30
	dynamic_should_hijack = TRUE
	gamemode_blacklist = list("blob") //Just in case a blob survives that long
	
/datum/round_event/ghost_role/blob
	announceWhen	= -1
	role_name = "blob overmind"
	fakeable = TRUE
	var/pointmodifier = 1

/datum/round_event/ghost_role/blob/New(pointrate = 1)
	. = ..()
	pointmodifier = pointrate
	
/datum/round_event/ghost_role/blob/announce(fake)
	priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", ANNOUNCER_OUTBREAK5)

/datum/round_event/ghost_role/blob/spawn_role()
	if(!GLOB.blobstart.len)
		return MAP_ERROR
	var/list/candidates = get_candidates(ROLE_BLOB, null, ROLE_BLOB)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS
	var/mob/dead/observer/new_blob = pick(candidates)
	var/mob/camera/blob/BC = new_blob.become_overmind(60, pointmodifier)
	spawned_mobs += BC
	message_admins("[ADMIN_LOOKUPFLW(BC)] has been made into a blob overmind by an event.")
	log_game("[key_name(BC)] was spawned as a blob overmind by an event.")
	return SUCCESSFUL_SPAWN
