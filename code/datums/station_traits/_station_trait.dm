///Base class of station traits. These are used to influence rounds in one way or the other by influencing the levers of the station.
/datum/station_trait
	///Name of the trait
	var/name = "unnamed station trait"
	///The type of this trait. Used to classify how this trait influences the station
	var/trait_type = STATION_TRAIT_NEUTRAL
	///Whether or not this trait uses process()
	var/trait_processes = FALSE
	///Chance relative to other traits of its type to be picked
	var/weight = 0
	///The cost of the trait, which is removed from the budget.
	var/cost = STATION_TRAIT_COST_FULL
	///Whether this trait is always enabled; generally used for debugging
	var/force = FALSE
	///Does this trait show in the centcom report?
	var/show_in_report = FALSE
	///What message to show in the centcom report?
	var/report_message
	///What code-trait does this station trait give? gives none if null
	var/trait_to_give
	///What traits are incompatible with this one?
	var/blacklist
	///Extra flags for station traits such as it being abstract, planetary or space only
	var/trait_flags = STATION_TRAIT_MAP_UNRESTRICTED
	/// Whether or not this trait can be reverted by an admin
	var/can_revert = TRUE
	/// If set to true we'll show a button on the lobby to notify people about this trait
	var/sign_up_button = FALSE
	/// Lobby buttons controlled by this trait
	var/list/lobby_buttons = list()
	/// The ID that we look for in dynamic.json. Not synced with 'name' because I can already see this go wrong
	var/dynamic_threat_id
	/// If ran during dynamic, do we reduce the total threat? Will be overriden by config if set
	var/threat_reduction = 0
	/// Trait should not be instantiated in a round if its type matches this type
	var/abstract_type = /datum/station_trait


/datum/station_trait/New()
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_round_start)))
	if(trait_processes)
		START_PROCESSING(SSstation, src)
	if(trait_to_give)
		ADD_TRAIT(SSstation, trait_to_give, STATION_TRAIT)

/datum/station_trait/Destroy()
	SSstation.station_traits -= src
	return ..()

/// Returns the type of info the centcom report has on this trait, if any.
/datum/station_trait/proc/get_report()
	return "<i>[name]</i> - [report_message]"

/// Will attempt to revert the station trait, used by admins.
/datum/station_trait/proc/revert()
	if (!can_revert)
		CRASH("revert() was called on [type], which can't be reverted!")

	if (trait_to_give)
		REMOVE_TRAIT(SSstation, trait_to_give, STATION_TRAIT)

	qdel(src)

/// Called by decals if they can be colored, to see if we got some cool colors for them. Only takes the first station trait
/proc/request_station_colors(atom/thing_to_color, pattern)
	for(var/datum/station_trait/trait in SSstation.station_traits)
		var/decal_color = trait.get_decal_color(thing_to_color, pattern || PATTERN_DEFAULT)
		if(decal_color)
			return decal_color
	return null

/// Return a color for the decals, if any
/datum/station_trait/proc/get_decal_color(thing_to_color, pattern)
	return

///Proc ran when round starts. Use this for roundstart effects.
/datum/station_trait/proc/on_round_start()
	return
