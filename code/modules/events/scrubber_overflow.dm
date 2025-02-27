/datum/round_event_control/scrubber_overflow
	name = "Scrubber Overflow: Normal"
	typepath = /datum/round_event/scrubber_overflow
	weight = 10
	max occurrences = 0
	min_players = 10

/datum/round_event/scrubber_overflow
	announceWhen = 1
	startWhen = 5
	endWhen = 35
	/// The probability that the ejected reagents will be dangerous
	var/danger_chance = 1
	/// Amount of reagents ejected from each scrubber
	var/reagents_amount = 50
	/// Probability of an individual scrubber overflowing
	var/overflow_probability = 50
	/// Specific reagent to force all scrubbers to use, null for random reagent choice
	var/forced_reagent
	/// A list of scrubbers that will have reagents ejected from them
	var/list/scrubbers = list()
	/// The list of chems that scrubbers can produce
	var/list/safer_chems = list(
		/datum/reagent/water,
		/datum/reagent/carbon,
		/datum/reagent/consumable/flour,
		/datum/reagent/space_cleaner,
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/condensedcapsaicin,
		/datum/reagent/drug/mushroomhallucinogen,
		/datum/reagent/lube,
		/datum/reagent/glitter/pink,
		/datum/reagent/cryptobiolin,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/blood,
		/datum/reagent/medicine/charcoal,
		/datum/reagent/drug/space_drugs,
		/datum/reagent/medicine/morphine,
		/datum/reagent/water/holywater,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/hot_coco,
		/datum/reagent/toxin/acid,
		/datum/reagent/toxin/mindbreaker,
		/datum/reagent/toxin/rotatium,
		/datum/reagent/bluespace,
		/datum/reagent/pax,
		/datum/reagent/consumable/laughter,
		/datum/reagent/concentrated_barbers_aid,
		/datum/reagent/baldium,
		/datum/reagent/colorful_reagent,
		/datum/reagent/peaceborg/confuse,
		/datum/reagent/peaceborg/tire,
		/datum/reagent/consumable/sodiumchloride,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/hair_dye,
		/datum/reagent/consumable/sugar,
		/datum/reagent/glitter/white,
		/datum/reagent/growthserum
	)
	//needs to be chemid unit checked at some point

/datum/round_event/scrubber_overflow/announce(fake)
	priority_announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert")

/datum/round_event/scrubber_overflow/setup()
	for(var/obj/machinery/atmospherics/components/unary/vent_scrubber/temp_vent in GLOB.machines)
		var/turf/scrubber_turf = get_turf(temp_vent)
		if(!scrubber_turf)
			continue
		if(!is_station_level(scrubber_turf.z))
			continue
		if(temp_vent.welded)
			continue
		if(!prob(overflow_probability))
			continue
		scrubbers += temp_vent

	if(!scrubbers.len)
		return kill()

/datum/round_event/scrubber_overflow/start()
	for(var/obj/machinery/atmospherics/components/unary/vent_scrubber/vent as anything in scrubbers)
		if(!vent.loc)
			CRASH("SCRUBBER SURGE: [vent] has no loc somehow?")

		var/datum/reagents/dispensed_reagent = new /datum/reagents(reagents_amount)
		dispensed_reagent.my_atom = vent
		if (forced_reagent)
			dispensed_reagent.add_reagent(forced_reagent, reagents_amount)
		else if (prob(danger_chance))
			dispensed_reagent.add_reagent(get_random_reagent_id(), reagents_amount)
			new /mob/living/simple_animal/cockroach(get_turf(vent))
			new /mob/living/simple_animal/cockroach(get_turf(vent))
		else
			dispensed_reagent.add_reagent(pick(safer_chems), reagents_amount)

		dispensed_reagent.create_foam(/datum/effect_system/fluid_spread/foam/short, reagents_amount)

		CHECK_TICK

/datum/round_event_control/scrubber_overflow/threatening
	name = "Scrubber Overflow: Threatening"
	typepath = /datum/round_event/scrubber_overflow/threatening
	weight = 4
	min_players = 25
	max occurrences = 0
	earliest_start = 35 MINUTES

/datum/round_event/scrubber_overflow/threatening
	danger_chance = 10
	reagents_amount = 100

/datum/round_event_control/scrubber_overflow/catastrophic
	name = "Scrubber Overflow: Catastrophic"
	typepath = /datum/round_event/scrubber_overflow/catastrophic
	weight = 2
	min_players = 35
	max occurrences = 0
	earliest_start = 45 MINUTES

/datum/round_event/scrubber_overflow/catastrophic
	danger_chance = 30
	reagents_amount = 150

/datum/round_event_control/scrubber_overflow/beer // Used when the beer nuke "detonates"
	name = "Scrubber Overflow: Beer"
	typepath = /datum/round_event/scrubber_overflow/beer
	weight = 0
	max_occurrences = 0

/datum/round_event/scrubber_overflow/beer
	overflow_probability = 100
	forced_reagent = /datum/reagent/consumable/ethanol/beer
	reagents_amount = 100
