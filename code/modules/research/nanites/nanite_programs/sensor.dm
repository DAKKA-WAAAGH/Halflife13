/datum/nanite_program/sensor
	name = "Sensor Nanites"
	desc = "These nanites send a signal code when a certain condition is met."
	unique = FALSE
	extra_settings = list("Sent Code")

	var/sent_code = 0

/datum/nanite_program/sensor/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)

/datum/nanite_program/sensor/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code

/datum/nanite_program/sensor/copy_extra_settings_to(datum/nanite_program/sensor/target)
	target.sent_code = sent_code

/datum/nanite_program/sensor/proc/check_event()
	return FALSE

/datum/nanite_program/sensor/proc/send_code()
	if(activated && sent_code != trigger_code)
		SEND_SIGNAL(host_mob, COMSIG_NANITE_SIGNAL, sent_code, "a [name] program")

/datum/nanite_program/sensor/active_effect()
	if(sent_code && check_event())
		send_code()

/datum/nanite_program/sensor/repeat
	name = "Signal Repeater"
	desc = "When triggered, sends another signal to the nanites, optionally with a delay."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 10
	extra_settings = list("Sent Code","Delay")
	var/spent = FALSE
	var/delay = 0

/datum/nanite_program/sensor/repeat/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		if(round(new_code, 1) == trigger_code)
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Delay")
		var/new_delay = input(user, "Set the delay in seconds:", name, null) as null|num
		if(isnull(new_delay))
			return
		delay = (clamp(round(new_delay, 1), 0, 3600)) * 10 //max 1 hour

/datum/nanite_program/sensor/repeat/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Delay")
		return "[delay/10] seconds"

/datum/nanite_program/sensor/repeat/copy_extra_settings_to(datum/nanite_program/sensor/repeat/target)
	target.sent_code = sent_code
	target.delay = delay

/datum/nanite_program/sensor/repeat/trigger()
	if(!..())
		return
	addtimer(CALLBACK(src, PROC_REF(send_code)), delay)

/datum/nanite_program/sensor/relay_repeat
	name = "Relay Signal Repeater"
	desc = "When triggered, sends another signal to a relay channel, optionally with a delay."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 10
	extra_settings = list("Sent Code","Relay Channel","Delay")
	var/spent = FALSE
	var/delay = 0
	var/relay_channel = 0

/datum/nanite_program/sensor/relay_repeat/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		if(round(new_code, 1) == trigger_code)
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Relay Channel")
		var/new_channel = input(user, "Set the relay channel (1-9999):", name, null) as null|num
		if(isnull(new_channel))
			return
		relay_channel = clamp(round(new_channel, 1), 1, 9999)
	if(setting == "Delay")
		var/new_delay = input(user, "Set the delay in seconds:", name, null) as null|num
		if(isnull(new_delay))
			return
		delay = (clamp(round(new_delay, 1), 0, 3600)) * 10 //max 1 hour

/datum/nanite_program/sensor/relay_repeat/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Relay Channel")
		return relay_channel
	if(setting == "Delay")
		return "[delay/10] seconds"

/datum/nanite_program/sensor/relay_repeat/copy_extra_settings_to(datum/nanite_program/sensor/relay_repeat/target)
	target.sent_code = sent_code
	target.delay = delay
	target.relay_channel = relay_channel

/datum/nanite_program/sensor/relay_repeat/trigger()
	if(!..())
		return
	addtimer(CALLBACK(src, PROC_REF(send_code)), delay)

/datum/nanite_program/sensor/relay_repeat/send_code()
	if(activated && relay_channel && sent_code != trigger_code)
		for(var/X in SSnanites.nanite_relays)
			var/datum/nanite_program/relay/N = X
			N.relay_signal(sent_code, relay_channel, "a [name] program")

/datum/nanite_program/sensor/health
	name = "Health Sensor"
	desc = "The nanites receive a signal when the host's health is above/below a target percentage."
	extra_settings = list("Sent Code","Health Percent","Direction")
	var/spent = FALSE
	var/percent = 50
	var/direction = "Above"

/datum/nanite_program/sensor/health/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Health Percent")
		var/new_percent = input(user, "Set the health percentage:", name, null) as null|num
		if(isnull(new_percent))
			return
		percent = clamp(round(new_percent, 1), -99, 100)
	if(setting == "Direction")
		if(direction == "Above")
			direction = "Below"
		else
			direction = "Above"

/datum/nanite_program/sensor/health/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Health Percent")
		return "[percent]%"
	if(setting == "Direction")
		return direction

/datum/nanite_program/sensor/health/copy_extra_settings_to(datum/nanite_program/sensor/health/target)
	target.sent_code = sent_code
	target.percent = percent
	target.direction = direction

/datum/nanite_program/sensor/health/check_event()
	var/health_percent = host_mob.health / host_mob.maxHealth * 100
	var/detected = FALSE
	if(direction == "Above")
		if(health_percent >= percent)
			detected = TRUE
	else
		if(health_percent < percent)
			detected = TRUE

	if(detected)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/crit
	name = "Critical Health Sensor"
	desc = "The nanites receive a signal when the host first reaches critical health."
	var/spent = FALSE

/datum/nanite_program/sensor/crit/check_event()
	if(host_mob.InCritical())
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/death
	name = "Death Sensor"
	desc = "The nanites receive a signal when they detect the host is dead."
	var/spent = FALSE

/datum/nanite_program/sensor/death/on_death()
	send_code()

/datum/nanite_program/sensor/nanite_volume
	name = "Nanite Volume Sensor"
	desc = "The nanites receive a signal when the nanite supply is above/below a certain percentage."
	extra_settings = list("Sent Code","Nanite Percent","Direction")
	var/spent = FALSE
	var/percent = 50
	var/direction = "Above"

/datum/nanite_program/sensor/nanite_volume/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Nanite Percent")
		var/new_percent = input(user, "Set the nanite percentage:", name, null) as null|num
		if(isnull(new_percent))
			return
		percent = clamp(round(new_percent, 1), 1, 100)
	if(setting == "Direction")
		if(direction == "Above")
			direction = "Below"
		else
			direction = "Above"

/datum/nanite_program/sensor/nanite_volume/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Nanite Percent")
		return "[percent]%"
	if(setting == "Direction")
		return direction

/datum/nanite_program/sensor/nanite_volume/copy_extra_settings_to(datum/nanite_program/sensor/nanite_volume/target)
	target.sent_code = sent_code
	target.percent = percent
	target.direction = direction

/datum/nanite_program/sensor/nanite_volume/check_event()
	var/nanite_percent = (nanites.nanite_volume - nanites.safety_threshold)/(nanites.max_nanites - nanites.safety_threshold)*100
	var/detected = FALSE

	if(direction == "Above")
		if(nanite_percent >= percent)
			detected = TRUE
	else
		if(nanite_percent < percent)
			detected = TRUE

	if(detected)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/damage
	name = "Damage Sensor"
	desc = "The nanites receive a signal when a host's specific damage type is above/below a target value."
	extra_settings = list("Sent Code","Damage Type","Damage","Direction")
	var/spent = FALSE
	var/damage_type = "Brute"
	var/damage = 50
	var/direction = "Above"

/datum/nanite_program/sensor/damage/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Damage")
		var/new_damage = input(user, "Set the damage threshold:", name, null) as null|num
		if(isnull(new_damage))
			return
		damage = clamp(round(new_damage, 1), 0, 500)
	if(setting == "Damage Type")
		var/list/damage_types = list("Brute","Burn","Toxin","Oxygen","Cellular")
		var/new_damage_type = input("Choose the damage type", name) as null|anything in damage_types
		if(!new_damage_type)
			return
		damage_type = new_damage_type
	if(setting == "Direction")
		if(direction == "Above")
			direction = "Below"
		else
			direction = "Above"

/datum/nanite_program/sensor/damage/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Damage")
		return damage
	if(setting == "Damage Type")
		return damage_type
	if(setting == "Direction")
		return direction

/datum/nanite_program/sensor/damage/copy_extra_settings_to(datum/nanite_program/sensor/damage/target)
	target.sent_code = sent_code
	target.damage = damage
	target.damage_type = damage_type
	target.direction = direction

/datum/nanite_program/sensor/damage/check_event()
	var/reached_threshold = FALSE
	var/check_above = (direction == "Above")
	var/damage_amt = 0
	switch(damage_type)
		if("Brute")
			damage_amt = host_mob.getBruteLoss()
		if("Burn")
			damage_amt = host_mob.getFireLoss()
		if("Toxin")
			damage_amt = host_mob.getToxLoss()
		if("Oxygen")
			damage_amt = host_mob.getOxyLoss()
		if("Cellular")
			damage_amt = host_mob.getCloneLoss()

	if(damage_amt >= damage)
		if(check_above)
			reached_threshold = TRUE
	else if(!check_above)
		reached_threshold = TRUE

	if(reached_threshold)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/voice
	name = "Voice Sensor"
	desc = "Sends a signal when the nanites hear a determined word or sentence."
	extra_settings = list("Sent Code","Sentence","Inclusive Mode")
	var/spent = FALSE
	var/sentence = ""
	var/inclusive = TRUE

/datum/nanite_program/sensor/voice/on_mob_add()
	. = ..()
	RegisterSignal(host_mob, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))

/datum/nanite_program/sensor/voice/on_mob_remove()
	UnregisterSignal(host_mob, COMSIG_MOVABLE_HEAR)

/datum/nanite_program/sensor/voice/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Sentence")
		var/new_sentence = stripped_input(user, "Choose the sentence that triggers the sensor.", "Sentence", sentence, MAX_MESSAGE_LEN)
		if(!new_sentence)
			return
		sentence = new_sentence
	if(setting == "Inclusive Mode")
		var/new_inclusive = input("Should the sensor detect the sentence if contained within another sentence?", name) as null|anything in list("Inclusive","Exclusive")
		if(!new_inclusive)
			return
		inclusive = (new_inclusive == "Inclusive")

/datum/nanite_program/sensor/voice/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Sentence")
		return sentence
	if(setting == "Inclusive Mode")
		if(inclusive)
			return "Inclusive"
		else
			return "Exclusive"

/datum/nanite_program/sensor/voice/copy_extra_settings_to(datum/nanite_program/sensor/voice/target)
	target.sent_code = sent_code
	target.sentence = sentence
	target.inclusive = inclusive

/datum/nanite_program/sensor/voice/proc/on_hear(datum/source, list/hearing_args)
	if(!sentence)
		return
	if(inclusive)
		if(findtextEx(hearing_args[HEARING_RAW_MESSAGE], sentence))
			send_code()
	else
		if(hearing_args[HEARING_RAW_MESSAGE] == sentence)
			send_code()
/datum/nanite_program/sensor/race
	name = "Race Sensor"
	desc = "When triggered, the nanites scan the host to determine their race and output a signal depending on the conditions set in the settings."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 5

	extra_settings = list("Sent Code","Race","Mode")
	var/race_type = "Human"
	var/mode = "Is"
	var/list/static/allowed_species = list(
    	"Human" = /datum/species/human,
	)
//preternis is yog only baybe
/datum/nanite_program/sensor/race/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = clamp(round(new_code, 1), 1, 9999)
	if(setting == "Race")
		var/list/race_types = list()
		for(var/name in allowed_species)
			race_types += name
		race_types += "Other"
		var/new_race_type = input("Choose the race", name) as null|anything in sortList(race_types)
		if(!new_race_type)
			return
		race_type = new_race_type
	if(setting == "Mode")
		mode = mode == "Is" ? "Is Not" : "Is"


/datum/nanite_program/sensor/race/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Race")
		return race_type
	if(setting == "Mode")
		return mode

/datum/nanite_program/sensor/race/copy_extra_settings_to(datum/nanite_program/sensor/race/target)
	target.sent_code = sent_code
	target.race_type = race_type
	target.mode = mode

/datum/nanite_program/sensor/race/trigger()
	if(!..())
		return

	var/species = allowed_species[race_type]
	var/race_match = FALSE

	if(species)
		if(is_species(host_mob, species))
			race_match = TRUE
	else	//this is the check for the "Other" option
		race_match = TRUE
		for(var/name in allowed_species)
			var/species_other = allowed_species[name]
			if(is_species(host_mob, species_other))
				race_match = FALSE
				break

	switch(mode)
		if("Is")
			if(race_match)
				send_code()
		if("Is Not")
			if(!race_match)
				send_code()
