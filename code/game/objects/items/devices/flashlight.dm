#define FAILURE 0
#define SUCCESS 1
#define NO_FUEL 2
#define ALREADY_LIT 3

/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	custom_price = 10
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	materials = list(/datum/material/iron=50, /datum/material/glass=20)
	actions_types = list(/datum/action/item_action/toggle_light)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	/// If we've been forcibly disabled for a temporary amount of time.
	COOLDOWN_DECLARE(disabled_time)
	/// Can we toggle this light on and off (used for contexual screentips only)
	var/toggle_context = TRUE
	/// The sound the light makes when it's turned on
	var/sound_on = 'sound/weapons/magin.ogg'
	/// The sound the light makes when it's turned off
	var/sound_off = 'sound/weapons/magout.ogg'
	/// Should the flashlight start turned on?
	var/start_on = FALSE

/obj/item/flashlight/Initialize(mapload)
	. = ..()
	if(start_on)
		set_light_on(TRUE)
	update_brightness()

/obj/item/flashlight/update_icon_state()
	. = ..()
	if(light_on)
		icon_state = "[initial(icon_state)]-on"
		if(!isnull(item_state))
			item_state = "[initial(item_state)]-on"
	else
		icon_state = initial(icon_state)
		if(!isnull(item_state))
			item_state = initial(item_state)

/obj/item/flashlight/proc/update_brightness()
	update_appearance(UPDATE_ICON)
	if(light_system == STATIC_LIGHT)
		update_light()
	
/obj/item/flashlight/proc/toggle_light(mob/user)
	playsound(src, light_on ? sound_off : sound_on, 40, TRUE)
	if(!COOLDOWN_FINISHED(src, disabled_time))
		if(user)
			balloon_alert(user, "disrupted!")
		set_light_on(FALSE)
		update_brightness()
		update_item_action_buttons()
		return FALSE
	var/old_light_on = light_on
	set_light_on(!light_on)
	update_brightness()
	update_item_action_buttons()
	return light_on != old_light_on // If the value of light_on didn't change, return false. Otherwise true.

/obj/item/flashlight/attack_self(mob/user)
	toggle_light(user)

/obj/item/flashlight/suicide_act(mob/living/carbon/human/user)
	if (user.eye_blind)
		user.visible_message(span_suicide("[user] is putting [src] close to [user.p_their()] eyes and turning it on... but [user.p_theyre()] blind!"))
		return SHAME
	if(!light_on)
		user.visible_message(span_suicide("[user] is putting [src] close to [user.p_their()] eyes but it's not on!"))
		return SHAME
	user.visible_message(span_suicide("[user] is putting [src] close to [user.p_their()] eyes! It looks like [user.p_theyre()] trying to commit suicide!"))
	return FIRELOSS

/obj/item/flashlight/attack(mob/living/carbon/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	if(istype(M) && light_on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH)))

		if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!user.IsAdvancedToolUser())
			to_chat(user, span_warning("You don't have the dexterity to do this!"))
			return

		if(!M.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[M] doesn't have a head!"))
			return

		if(light_power < 1)
			to_chat(user, "[span_warning("\The [src] isn't bright enough to see anything!")] ")
			return

		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_EYES)
				if((M.head && M.head.flags_cover & HEADCOVERSEYES) || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) || (M.glasses && M.glasses.flags_cover & GLASSESCOVERSEYES))
					to_chat(user, span_notice("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSEYES) ? "helmet" : (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) ? "mask": "glasses"] first."))
					return

				var/obj/item/organ/eyes/E = M.getorganslot(ORGAN_SLOT_EYES)
				if(!E)
					to_chat(user, span_danger("[M] doesn't have any eyes!"))
					return

				if(M == user)	//they're using it on themselves
					if(M.flash_act(visual = 1))
						M.visible_message("[M] directs [src] to [M.p_their()] eyes.", span_notice("You wave the light in front of your eyes! Trippy!"))
					else
						M.visible_message("[M] directs [src] to [M.p_their()] eyes.", span_notice("You wave the light in front of your eyes."))
				else
					user.visible_message(span_warning("[user] directs [src] to [M]'s eyes."), \
										 span_danger("You direct [src] to [M]'s eyes."))
					if(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_BLIND)) || !M.flash_act(visual = 1)) //mob is dead or fully blind
						to_chat(user, span_warning("[M]'s pupils don't react to the light!"))
					else
						for(var/datum/brain_trauma/trauma in M.get_traumas())
							trauma.on_shine_light(user, M, src)
						if(M.dna && M.dna.check_mutation(XRAY))	//mob has X-ray vision
							to_chat(user, span_danger("[M]'s pupils give an eerie glow!"))
						else //they're okay!
							to_chat(user, span_notice("[M]'s pupils narrow."))

			if(BODY_ZONE_PRECISE_MOUTH)

				if(M.is_mouth_covered())
					to_chat(user, span_notice("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSMOUTH) ? "helmet" : "mask"] first."))
					return

				var/their = M.p_their()

				var/list/mouth_organs = new
				for(var/obj/item/organ/O in M.internal_organs)
					if(O.zone == BODY_ZONE_PRECISE_MOUTH)
						mouth_organs.Add(O)
				var/organ_list = ""
				var/organ_count = LAZYLEN(mouth_organs)
				if(organ_count)
					for(var/I in 1 to organ_count)
						if(I > 1)
							if(I == mouth_organs.len)
								organ_list += ", and "
							else
								organ_list += ", "
						var/obj/item/organ/O = mouth_organs[I]
						organ_list += (O.gender == "plural" ? O.name : "\an [O.name]")

				var/pill_count = 0
				for(var/datum/action/item_action/hands_free/activate_pill/AP in M.actions)
					pill_count++

				if(M == user)
					var/can_use_mirror = FALSE
					if(isturf(user.loc))
						var/obj/structure/mirror/mirror = locate(/obj/structure/mirror, user.loc)
						if(mirror)
							switch(user.dir)
								if(NORTH)
									can_use_mirror = mirror.pixel_y > 0
								if(SOUTH)
									can_use_mirror = mirror.pixel_y < 0
								if(EAST)
									can_use_mirror = mirror.pixel_x > 0
								if(WEST)
									can_use_mirror = mirror.pixel_x < 0

					M.visible_message("[M] directs [src] to [their] mouth.", \
					span_notice("You point [src] into your mouth."))
					if(!can_use_mirror)
						to_chat(user, span_notice("You can't see anything without a mirror."))
						return
					if(organ_count)
						to_chat(user, span_notice("Inside your mouth [organ_count > 1 ? "are" : "is"] [organ_list]."))
					else
						to_chat(user, span_notice("There's nothing inside your mouth."))
					if(pill_count)
						to_chat(user, span_notice("You have [pill_count] implanted pill[pill_count > 1 ? "s" : ""]."))

				else
					user.visible_message(span_notice("[user] directs [src] to [M]'s mouth."),\
										 span_notice("You direct [src] to [M]'s mouth."))
					if(organ_count)
						to_chat(user, span_notice("Inside [their] mouth [organ_count > 1 ? "are" : "is"] [organ_list]."))
					else
						to_chat(user, span_notice("[M] doesn't have any organs in [their] mouth."))
					if(pill_count)
						to_chat(user, span_notice("[M] has [pill_count] pill[pill_count > 1 ? "s" : ""] implanted in [their] teeth."))

	else
		return ..()

/// for directional sprites - so we get the same sprite in the inventory each time we pick one up
/obj/item/flashlight/equipped(mob/user, slot, initial)
	. = ..()
	setDir(initial(dir))
	SEND_SIGNAL(user, COMSIG_ATOM_DIR_CHANGE, user.dir, user.dir) // This is dumb, but if we don't do this then the lighting overlay may be facing the wrong direction depending on how it is picked up

/// for directional sprites - so when we drop the flashlight, it drops facing the same way the user is facing
/obj/item/flashlight/dropped(mob/user, silent = FALSE)
	. = ..()
	if(istype(user) && dir != user.dir)
		setDir(user.dir)

/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff. It can also be used to create a hologram to alert people of incoming medical assistance."
	icon_state = "penlight"
	item_state = ""
	flags_1 = CONDUCT_1
	light_range = 2
	COOLDOWN_DECLARE(holosign_cooldown)

/obj/item/flashlight/pen/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		return

	if(!COOLDOWN_FINISHED(src, holosign_cooldown))
		balloon_alert(user, "not ready!")
		return

	var/target_turf = get_turf(target)
	var/mob/living/living_target = locate(/mob/living) in target_turf

	if(!living_target || (living_target == user))
		return

	to_chat(living_target, span_boldnotice("[user] is offering medical assistance; please halt your actions."))
	new /obj/effect/temp_visual/medical_holosign(target_turf, user) //produce a holographic glow
	COOLDOWN_START(src, holosign_cooldown, 10 SECONDS)

// see: [/datum/wound/burn/proc/uv()]
/obj/item/flashlight/pen/paramedic
	name = "paramedic penlight"
	desc = "A high-powered UV penlight intended to help stave off infection in the field on serious burned patients. Probably really bad to look into."
	icon_state = "penlight_surgical"
	light_color = LIGHT_COLOR_PURPLE
	/// Our current UV cooldown
	COOLDOWN_DECLARE(uv_cooldown)
	/// How long between UV fryings
	var/uv_cooldown_length = 30 SECONDS
	/// How much sanitization to apply to the burn wound
	var/uv_power = 1

/obj/item/flashlight/pen/paramedic/advanced
	name = "advanced penlight"
	desc = "A stronger version of the UV penlight that paramedics and doctors receive, it is capable of cauterizing bleeding as well as sterilizing burns."
	icon_state = "penlight_cmo"
	light_range = 4
	uv_power = 2
	toolspeed = 0.5
	tool_behaviour = TOOL_CAUTERY

/obj/item/flashlight/pen/paramedic/advanced/ignition_effect(atom/A, mob/user)
	. = ..()
	return "[user] holds [src] against [A] until it ignites."

/obj/effect/temp_visual/medical_holosign
	name = "medical holosign"
	desc = "A small holographic glow that indicates a medic is coming to treat a patient."
	icon_state = "medi_holo"
	duration = 30

/obj/effect/temp_visual/medical_holosign/Initialize(mapload, mob/creator)
	. = ..()
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE) //make some noise!
	if(creator)
		visible_message(span_danger("[creator] created a medical hologram, indicating that [creator.p_theyre(FALSE, FALSE)] coming to help!"))


/obj/item/flashlight/seclite
	name = "flashlight"
	desc = "A robust flashlight."
	icon_state = "seclite"
	item_state = "seclite"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	force = 9 // Not as good as a stun baton.
	light_range = 5 // A little better than the standard flashlight.
	hitsound = 'sound/weapons/genhit1.ogg'

// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 10
	light_range = 5
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	materials = list()
	start_on = TRUE


// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"

//Bananalamp
/obj/item/flashlight/lamp/bananalamp
	name = "banana lamp"
	desc = "Only a clown would think to make a ghetto banana-shaped lamp. Even has a goofy pullstring."
	icon_state = "bananalamp"
	item_state = "bananalamp"

// FLARES

/obj/item/flashlight/flare
	name = "flare"
	desc = "A red Nanotrasen issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = WEIGHT_CLASS_SMALL
	light_range = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "flare"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	actions_types = list()
	heat = 1000
	light_color = LIGHT_COLOR_FLARE
	light_system = MOVABLE_LIGHT
	grind_results = list(/datum/reagent/sulphur = 15)
	sound_on = 'sound/items/flare_strike_1.ogg'
	/// How many seconds of fuel we have left
	var/fuel = 0
	/// Do we randomize the fuel when initialized
	var/randomize_fuel = TRUE
	/// Randomized fuel amount minimum
	var/frng_min = 25 MINUTES
	/// Randomized fuel amount maximum
	var/frng_max = 35 MINUTES
	/// How much damage it does when turned on
	var/on_damage = 7
	/// Type of atom thats spawns after fuel is used up
	//var/trash_type = /obj/item/trash/flare
	/// If the light source can be extinguished
	var/can_be_extinguished = FALSE
	/// Does this use particle effects
	var/flare_particle = TRUE

/obj/item/flashlight/flare/Initialize(mapload)
	. = ..()
	if(randomize_fuel)
		fuel = rand(25 MINUTES, 35 MINUTES)
	if(light_on)
		attack_verb = list("burnt","scorched","scalded")
		hitsound = 'sound/items/welder.ogg'
		force = on_damage
		damtype = BURN
		update_brightness()
	RegisterSignal(src, COMSIG_LIGHT_EATER_ACT, PROC_REF(on_light_eater))

/obj/item/flashlight/flare/toggle_light()
	if(light_on || !fuel)
		return FALSE
	. = ..()

	name = "lit [initial(name)]"
	attack_verb = list("burnt","scorched","scalded")
	hitsound = 'sound/items/welder.ogg'
	force = on_damage
	damtype = BURN

/obj/item/flashlight/flare/proc/turn_off()
	set_light_on(FALSE)
	name = initial(name)
	attack_verb = initial(attack_verb)
	hitsound = initial(hitsound)
	force = initial(force)
	damtype = initial(damtype)
	update_brightness()

/obj/item/flashlight/flare/extinguish()
	. = ..()
	if((fuel != INFINITY) && can_be_extinguished)
		turn_off()

/obj/item/flashlight/flare/process(seconds_per_tick)
	open_flame(heat)
	fuel = max(fuel - seconds_per_tick * (1 SECONDS), 0)
	if(!fuel || !light_on)
		turn_off()
		if(!fuel)
			icon_state = "[initial(icon_state)]-empty"
			name = "spent [initial(name)]"
			desc = "[initial(desc)] It's all used up."
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/ignition_effect(atom/A, mob/user)
	if(fuel && light_on)
		. = "<span class='notice'>[user] lights [A] with [src] like a real \
			badass.</span>"
	else
		. = ""

/obj/item/flashlight/flare/update_brightness(mob/user = null)
	..()
	if(light_on)
		if(flare_particle)
			add_emitter(/obj/emitter/sparks/flare, "spark", 10)
			add_emitter(/obj/emitter/flare_smoke, "smoke", 9)
		item_state = "[initial(item_state)]-on"
	else
		if(flare_particle)
			remove_emitter("spark")
			remove_emitter("smoke")
		item_state = "[initial(item_state)]"

/obj/item/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(fuel <= 0)
		to_chat(user, span_warning("[src] is out of fuel!"))
		return
	if(light_on)
		to_chat(user, span_notice("[src] is already on."))
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(span_notice("[user] lights \the [src]."), span_notice("You light \the [src]!"))
		playsound(loc, sound_on, 50, 1) //make some noise!
		force = on_damage
		name = "lit [initial(src.name)]"
		desc = "[initial(src.desc)] This one is lit."
		damtype = BURN
		attack_verb = list("burnt","scorched","scalded")
		hitsound = 'sound/items/welder.ogg'
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/is_hot()
	return light_on * heat

//fire isn't one light source, it's several constantly appearing and disappearing... or something
/obj/item/flashlight/flare/proc/on_light_eater(atom/source, datum/light_eater)
	SIGNAL_HANDLER 
	if(light_on)
		visible_message("The enduring flickering of \the [src] refuses to fade.")
	return COMPONENT_BLOCK_LIGHT_EATER
	
/obj/item/flashlight/flare/emergency
	name = "safety flare"
	desc = "A flare issued to Nanotrasen employees for emergencies. There are instructions on the side, it reads 'pull cord, make light, obey Nanotrasen'."
	light_range = 3
	item_state = "flare"
	icon_state = "flaresafety"
	sound_on = 'sound/items/flare_strike_2.ogg'
	frng_min = 40
	frng_max = 70

/obj/item/flashlight/flare/signal
	name = "signalling flare"
	desc = "A specialized formulation of the standard Nanotrasen-issued flare, containing increased magnesium content. There are instructions on the side, it reads 'pull cord, make intense light'."
	light_range = 5
	light_power = 2
	item_state = "flaresignal"
	icon_state = "flaresignal"
	light_color = LIGHT_COLOR_HALOGEN
	frng_min = 540
	frng_max = 700
	heat = 2500
	grind_results = list(/datum/reagent/sulphur = 15, /datum/reagent/potassium = 10)

/obj/item/flashlight/flare/torch
	name = "torch"
	desc = "A torch fashioned from some leaves and a log."
	w_class = WEIGHT_CLASS_BULKY
	light_range = 4
	icon_state = "torch"
	item_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	sound_on = 'sound/items/match_strike.ogg'
	light_color = LIGHT_COLOR_ORANGE
	on_damage = 10
	slot_flags = null
	flare_particle = FALSE

/obj/item/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	item_state = "lantern"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "A mining lantern."
	light_range = 6			// luminosity when on
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/lantern/pinapolantern
	name = "pinap-o'-lantern"
	desc = "It's a pineapple."
	icon = 'yogstation/icons/obj/items.dmi'
	icon_state = "pinapolantern"
	item_state = "pinapolantern"

/obj/item/flashlight/lantern/heirloom_moth
	name = "old lantern"
	desc = "An old lantern that has seen plenty of use."
	light_range = 4

/obj/item/flashlight/lantern/syndicate
	name = "suspicious lantern"
	desc = "A suspicious looking lantern."
	icon_state = "syndilantern"
	item_state = "syndilantern"
	light_range = 10

/obj/item/flashlight/lantern/jade
	name = "jade lantern"
	desc = "An ornate, green lantern."
	color = LIGHT_COLOR_GREEN
	light_color = LIGHT_COLOR_GREEN

/obj/item/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "Extract from a yellow slime. It emits a strong light when squeezed."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "slime"
	item_state = "slime"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	materials = list()
	light_range = 6 //luminosity when on
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/emp
	var/emp_max_charges = 4
	var/emp_cur_charges = 4
	var/charge_timer = 0
	/// How many seconds between each recharge
	var/charge_delay = 20

/obj/item/flashlight/emp/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/flashlight/emp/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/flashlight/emp/process(delta_time)
	charge_timer += delta_time
	if(charge_timer < charge_delay)
		return FALSE
	charge_timer -= charge_delay
	emp_cur_charges = min(emp_cur_charges+1, emp_max_charges)
	return TRUE

/obj/item/flashlight/emp/attack(mob/living/M, mob/living/user)

	if(!is_syndicate(user))
		return
	if(light_on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH))) // call original attack when examining organs
		..()
	return

/obj/item/flashlight/emp/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!is_syndicate(user)) // non syndicates don't know the flashlight is an EMP flashlight therefore won't know how to use it as such.
		return
	if(!proximity)
		return

	if(emp_cur_charges > 0)
		emp_cur_charges -= 1

		if(ismob(A))
			var/mob/M = A
			log_combat(user, M, "attacked", "EMP-light")
			M.visible_message(span_danger("[user] blinks \the [src] at \the [A]."), \
								span_userdanger("[user] blinks \the [src] at you."))
		else
			A.visible_message(span_danger("[user] blinks \the [src] at \the [A]."))
		to_chat(user, "\The [src] now has [emp_cur_charges] charge\s.</span>")
		A.emp_act(EMP_HEAVY)
	else
		to_chat(user, span_warning("\The [src] needs time to recharge!"))
	return

/obj/item/flashlight/emp/debug //for testing emp_act()
	name = "debug EMP flashlight"
	emp_max_charges = 100
	emp_cur_charges = 100

// Glowsticks, in the uncomfortable range of similar to flares,
// but not similar enough to make it worth a refactor
/obj/item/flashlight/glowstick
	name = "glowstick"
	desc = "A military-grade glowstick."
	custom_price = 10
	w_class = WEIGHT_CLASS_SMALL
	light_range = 4
	light_system = MOVABLE_LIGHT
	color = LIGHT_COLOR_GREEN
	icon_state = "glowstick"
	item_state = "glowstick"
	grind_results = list(/datum/reagent/phenol = 15, /datum/reagent/gas/hydrogen = 10, /datum/reagent/gas/oxygen = 5) //Meth-in-a-stick
	sound_on = 'sound/effects/wounds/crack2.ogg' // the cracking sound isn't just for wounds silly
	var/fuel = 0

/obj/item/flashlight/glowstick/Initialize(mapload)
	fuel = rand(1600, 2000)
	set_light_color(color)
	. = ..()

/obj/item/flashlight/glowstick/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/flashlight/glowstick/process(delta_time)
	fuel = max(fuel -= delta_time, 0)
	if(fuel <=  0)
		turn_off()
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/proc/turn_off()
	light_on = FALSE
	update_appearance()

/obj/item/flashlight/glowstick/update_appearance(updates=ALL)
	. = ..()
	if(fuel <= 0)
		set_light_on(FALSE)
		return
	if(light_on)
		set_light_on(TRUE)
		return

/obj/item/flashlight/glowstick/update_overlays()
	. = ..()
	if(fuel <= 0 && !light_on)
		return
	
	var/mutable_appearance/glowstick_overlay = mutable_appearance(icon, "glowstick-glow")
	glowstick_overlay.color = color
	. += glowstick_overlay

/obj/item/flashlight/glowstick/update_icon_state()
	. = ..()
	item_state = "glowstick" //item state
	if(fuel <= 0)
		icon_state = "glowstick-empty"
	else if(light_on)
		item_state = "glowstick-on" //item state
	else
		icon_state = "glowstick"

/obj/item/flashlight/glowstick/attack_self(mob/user)
	if(fuel <= 0)
		to_chat(user, span_notice("[src] is spent."))
		return
	if(light_on)
		to_chat(user, span_notice("[src] is already lit."))
		return

	. = ..()
	if(.)
		user.visible_message(span_notice("[user] cracks and shakes [src]."), span_notice("You crack and shake [src], turning it on!"))
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/suicide_act(mob/living/carbon/human/user)
	if(!fuel)
		user.visible_message(span_suicide("[user] is trying to squirt [src]'s fluids into [user.p_their()] eyes... but it's empty!"))
		return SHAME
	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		user.visible_message(span_suicide("[user] is trying to squirt [src]'s fluids into [user.p_their()] eyes... but [user.p_they()] don't have any!"))
		return SHAME
	user.visible_message(span_suicide("[user] is squirting [src]'s fluids into [user.p_their()] eyes! It looks like [user.p_theyre()] trying to commit suicide!"))
	fuel = 0
	return (FIRELOSS)

/obj/item/flashlight/glowstick/red
	name = "red glowstick"
	color = LIGHT_COLOR_RED

/obj/item/flashlight/glowstick/blue
	name = "blue glowstick"
	color = LIGHT_COLOR_BLUE

/obj/item/flashlight/glowstick/cyan
	name = "cyan glowstick"
	color = LIGHT_COLOR_CYAN

/obj/item/flashlight/glowstick/orange
	name = "orange glowstick"
	color = LIGHT_COLOR_ORANGE

/obj/item/flashlight/glowstick/yellow
	name = "yellow glowstick"
	color = LIGHT_COLOR_YELLOW

/obj/item/flashlight/glowstick/pink
	name = "pink glowstick"
	color = LIGHT_COLOR_PINK

/obj/effect/spawner/lootdrop/glowstick
	name = "random colored glowstick"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "random_glowstick"

/obj/effect/spawner/lootdrop/glowstick/Initialize(mapload)
	loot = typesof(/obj/item/flashlight/glowstick)
	. = ..()

/obj/item/flashlight/spotlight //invisible lighting source
	name = "disco light"
	desc = "Groovy..."
	icon_state = null
	light_system = MOVABLE_LIGHT
	light_range = 4
	light_power = 10
	alpha = 0
	layer = 0
	start_on = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Boolean that switches when a full color flip ends, so the light can appear in all colors.
	var/even_cycle = FALSE
	///Base light_range that can be set on Initialize to use in smooth light range expansions and contractions.
	var/base_light_range = 4

/obj/item/flashlight/spotlight/Initialize(mapload, _light_range, _light_power, _light_color)
	. = ..()
	if(!isnull(_light_range))
		base_light_range = _light_range
		set_light_range(_light_range)
	if(!isnull(_light_power))
		set_light_power(_light_power)
	if(!isnull(_light_color))
		set_light_color(_light_color)

/obj/item/flashlight/flashdark
	name = "flashdark"
	desc = "A strange device manufactured with mysterious elements that somehow emits darkness. Or maybe it just sucks in light? Nobody knows for sure."
	icon_state = "flashdark"
	item_state = "flashdark"
	light_power = -2
	light_range = 5

/obj/item/flashlight/flashdark/Initialize(mapload)
	. = ..()
	set_light_color(COLOR_VELVET)

/obj/item/flashlight/eyelight
	name = "eyelight"
	desc = "This shouldn't exist outside of someone's head, how are you seeing this?"
	light_system = MOVABLE_LIGHT
	light_range = 15
	light_power = 1
	flags_1 = CONDUCT_1
	item_flags = DROPDEL
	actions_types = list()
