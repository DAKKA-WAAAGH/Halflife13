/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Mech prizes
 *		AI core prizes
 *		Toy codex gigas
 * 		Skeleton toys
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *      Kitty toys!
 *		Snowballs
 *		Clockwork Watches
 *		Toy Daggers
 *		Turn Tracker
 *		ceremonial Rod of Asclepius
 *		cult sickles
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0


/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"


/obj/item/toy/balloon/Initialize(mapload)
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if (istype(A, /obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/RD = A
		if(RD.reagents.total_volume <= 0)
			to_chat(user, span_warning("[RD] is empty."))
		else if(reagents.total_volume >= 10)
			to_chat(user, span_warning("[src] is full."))
		else
			A.reagents.trans_to(src, 10, transfered_by = user)
			to_chat(user, span_notice("You fill the balloon with the contents of [A]."))
			desc = "A translucent balloon with some form of liquid sloshing around in it."
			update_appearance(UPDATE_ICON)

/obj/item/toy/balloon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(I.reagents)
			if(I.reagents.total_volume <= 0)
				to_chat(user, span_warning("[I] is empty."))
			else if(reagents.total_volume >= 10)
				to_chat(user, span_warning("[src] is full."))
			else
				desc = "A translucent balloon with some form of liquid sloshing around in it."
				to_chat(user, span_notice("You fill the balloon with the contents of [I]."))
				I.reagents.trans_to(src, 10, transfered_by = user)
				update_appearance(UPDATE_ICON)
	else if(I.is_sharp())
		balloon_burst()
	else
		return ..()

/obj/item/toy/balloon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //was it caught by a mob?
		balloon_burst(hit_atom)

/obj/item/toy/balloon/proc/balloon_burst(atom/AT)
	if(reagents.total_volume >= 1)
		var/turf/T
		if(AT)
			T = get_turf(AT)
		else
			T = get_turf(src)
		T.visible_message(span_danger("[src] bursts!"),span_italics("You hear a pop and a splash."))
		reagents.reaction(T)
		for(var/atom/A in T)
			reagents.reaction(A)
		icon_state = "burst"
		qdel(src)

/obj/item/toy/balloon/update_icon_state()
	. = ..()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "syndicate balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0
	icon = 'icons/obj/toy.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	lefthand_file = 'icons/mob/inhands/antag/balloons_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/balloons_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY

/obj/item/toy/mballoon
	name = "toy mballoon"
	desc = "A blue balloon, it looks.. mentory?"
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0
	icon = 'icons/obj/toy.dmi'
	icon_state = "mballoon"
	item_state = "mballoon"
	lefthand_file = 'icons/mob/inhands/antag/balloons_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/balloons_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY


/obj/item/toy/syndicateballoon/pickup(mob/user)
	. = ..()
	if(user && user.mind && user.mind.has_antag_datum(/datum/antagonist, TRUE))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)

/obj/item/toy/syndicateballoon/dropped(mob/user)
	if(user)
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)
	. = ..()


/obj/item/toy/syndicateballoon/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)
	. = ..()


/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy gun: Why isnt this an /obj/item/gun?
 */
/obj/item/toy/gun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up. Please recycle in an autolathe when you're out of caps."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "revolver"
	item_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=10, /datum/material/glass=10)
	attack_verb = list("struck", "pistol whipped", "hit", "bashed")
	var/bullets = 7

/obj/item/toy/gun/examine(mob/user)
	. = ..()
	. += "There [bullets == 1 ? "is" : "are"] [bullets] cap\s left."

/obj/item/toy/gun/attackby(obj/item/toy/ammo/gun/A, mob/user, params)

	if(istype(A, /obj/item/toy/ammo/gun))
		if (src.bullets >= 7)
			to_chat(user, span_warning("It's already fully loaded!"))
			return 1
		if (A.amount_left <= 0)
			to_chat(user, span_warning("There are no more caps!"))
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			to_chat(user, span_notice("You reload [A.amount_left] cap\s."))
			A.amount_left = 0
		else
			to_chat(user, span_notice("You reload [7 - src.bullets] cap\s."))
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_appearance(UPDATE_ICON)
		return 1
	else
		return ..()

/obj/item/toy/gun/afterattack(atom/target as mob|obj|turf|area, mob/user, flag)
	. = ..()
	if (flag)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message(span_warning("*click*"), MSG_AUDIBLE)
		playsound(src, 'sound/weapons/gun_dry_fire.ogg', 30, TRUE)
		return
	playsound(user, 'sound/weapons/gunshot.ogg', 100, 1)
	src.bullets--
	user.visible_message(span_danger("[user] fires [src] at [target]!"), \
						span_danger("You fire [src] at [target]!"), \
						 span_italics("You hear a gunshot!"))

/obj/item/toy/ammo/gun
	name = "capgun ammo"
	desc = "Make sure to recycle the box in an autolathe when it gets empty."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "357OLD-7"
	w_class = WEIGHT_CLASS_TINY
	materials = list(/datum/material/iron=10, /datum/material/glass=10)
	var/amount_left = 7

/obj/item/toy/ammo/gun/update_icon_state()
	. = ..()
	icon_state = text("357OLD-[]", amount_left)

/obj/item/toy/ammo/gun/examine(mob/user)
	. = ..()
	. += "There [amount_left == 1 ? "is" : "are"] [amount_left] cap\s left."

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons/energy.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	var/active = 0
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/hacked = FALSE
	var/saber_color = "blue"

/obj/item/toy/sword/attack_self(mob/user)
	active = !( active )
	if (active)
		to_chat(user, span_notice("You extend the plastic blade with a quick flick of your wrist."))
		playsound(user, 'sound/weapons/saberon.ogg', 20, 1)
		icon_state = "sword[saber_color]"
		item_state = "sword[saber_color]"
		w_class = WEIGHT_CLASS_BULKY
	else
		to_chat(user, span_notice("You push the plastic blade back down into the handle."))
		playsound(user, 'sound/weapons/saberoff.ogg', 20, 1)
		icon_state = "sword0"
		item_state = "sword0"
		w_class = WEIGHT_CLASS_SMALL
	add_fingerprint(user)

// Copied from /obj/item/melee/transforming/energy/sword/attackby
/obj/item/toy/sword/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/toy/sword))
		if(HAS_TRAIT(W, TRAIT_NODROP) || HAS_TRAIT(src, TRAIT_NODROP))
			to_chat(user, span_warning("\the [HAS_TRAIT(src, TRAIT_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_NODROP) ? W : src]!"))
			return
		else
			to_chat(user, span_notice("You attach the ends of the two plastic swords, making a single double-bladed toy! You're fake-cool."))
			var/obj/item/melee/dualsaber/toy/newSaber = new /obj/item/melee/dualsaber/toy(user.loc)
			if(hacked) // That's right, we'll only check the "original" "sword".
				newSaber.hacked = TRUE
				newSaber.saber_color = "rainbow"
			qdel(W)
			qdel(src)
	else if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!hacked)
			hacked = TRUE
			saber_color = "rainbow"
			to_chat(user, span_warning("RNBW_ENGAGE"))

			if(active)
				icon_state = "swordrainbow"
				user.update_inv_hands()
		else
			to_chat(user, span_warning("It's already fabulous!"))
	else
		return ..()

/*
 * Foam armblade
 */
/obj/item/toy/foamblade
	name = "foam armblade"
	desc = "It says \"Sternside Changs #1 fan\" on it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamblade"
	item_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	attack_verb = list("pricked", "absorbed", "gored")
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE

/obj/item/toy/foamblade/light_eater
	name = "foam armblade"
	desc = "It says \"Nulton Dawns #1 fan\" on it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamblade"
	item_state = "light_eater"
	lefthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_lefthand.dmi'
	righthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_righthand.dmi'
	attack_verb = list("eated", "absorbed", "slashed")

/obj/item/toy/foamblade/umbral_tendrils
	name = "malformed foam mass"
	desc = "A terrible defect produced by a foam armblade manufacturer."
	icon = 'yogstation/icons/obj/darkspawn_items.dmi'
	icon_state = "umbral_tendrils"
	item_state = "umbral_tendrils"
	lefthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_lefthand.dmi'
	righthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_righthand.dmi'
	attack_verb = list("devoured", "absorbed", "bludgeoned")

/obj/item/toy/foamblade/baseball
	name = "toy baseball bat"
	desc = "A colorful foam baseball bat. The label on the handle reads Donksoft."
	icon = 'icons/obj/weapons/bat.dmi'
	icon_state = "baseball_bat_donk"
	item_state = "baseball_bat_donk"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	attack_verb = list("beat", "smacked")
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE

/obj/item/toy/foamblade/baseball/nerf
	name = "antique toy baseball bat"
	desc = "A colorful foam baseball bat. The label on the handle is almost rubbed off...\"nerf or nothing\"? what does that mean"
	icon_state = "baseball_bat_toy"
	item_state = "baseball_bat_plastic"

/obj/item/toy/windupToolbox
	name = "windup toolbox"
	desc = "A replica toolbox that rumbles when you turn the key."
	icon_state = "his_grace"
	item_state = "artistic_toolbox"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	var/active = FALSE
	icon = 'icons/obj/storage.dmi'
	attack_verb = list("robusted")

/obj/item/toy/windupToolbox/attack_self(mob/user)
	if(!active)
		icon_state = "his_grace_awakened"
		to_chat(user, span_warning("You wind up [src], it begins to rumble."))
		active = TRUE
		addtimer(CALLBACK(src, PROC_REF(stopRumble)), 600)
	else
		to_chat(user, "[src] is already active.")

/obj/item/toy/windupToolbox/proc/stopRumble()
	icon_state = initial(icon_state)
	active = FALSE

/*
 * Subtype of Double-Bladed Energy Swords
 */
/obj/item/melee/dualsaber/toy
	name = "double-bladed toy sword"
	desc = "A cheap, plastic replica of TWO energy swords. Double the fun!"
	force = 0
	force_wielded = 0 // Why did someone make this a subtype of dualsabers
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "struck", "hit")
	toy = TRUE

/*
 * Subtype of Vxtvul Hammer
 */
/obj/item/melee/vxtvulhammer/toy
	name = "toy sledgehammer"
	desc = "A Donksoft motorized hammer with realistic flashing lights and speakers."
	base_icon_state = "vxtvul_hammer"
	throwforce = 0
	resistance_flags = NONE
	armour_penetration = 0
	w_class = WEIGHT_CLASS_NORMAL
	toy = TRUE

	force = 0
	force_wielded = 0

	var/pirated = FALSE // knockoff brand!

/obj/item/melee/vxtvulhammer/toy/Initialize(mapload)
	. = ..()
	if(pirated || prob(10)) // man i got scammed!
		pirated = TRUE
		name = "toy pirate sledgehammer"
		desc += " This one looks different from the ones you see on commercials..."
		base_icon_state = "vxtvul_hammer_pirate"
		icon_state = "[base_icon_state]0-0"
		update_appearance(UPDATE_ICON)

/obj/item/melee/vxtvulhammer/toy/pirate
	base_icon_state = "vxtvul_hammer_pirate"
	pirated = TRUE

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons/longsword.dmi'
	icon_state = "katana"
	item_state = "katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'

//singularity wakizashi
/obj/item/toy/katana/singulo_wakizashi
	name = "replica singularity wakizashi"
	desc = "The power of the singularity condensed into one short, cheap, and fake wakizashi!"
	icon_state = "singulo_wakizashi"
	item_state = "singulo_wakizashi"
	force = 0 //sorry, no
	throwforce = 0
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
/*
 * Snap pops
 */

/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY
	var/ash_type = /obj/effect/decal/cleanable/ash

/obj/item/toy/snappop/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)


/obj/item/toy/snappop/proc/pop_burst(n=3, c=1)
	var/datum/effect_system/spark_spread/s = new()
	s.set_up(n, c, src)
	s.start()
	new ash_type(loc)
	visible_message(span_warning("[src] explodes!"),
		span_italics("You hear a snap!"))
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	qdel(src)

/obj/item/toy/snappop/fire_act(exposed_temperature, exposed_volume)
	pop_burst()

/obj/item/toy/snappop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		pop_burst()

/obj/item/toy/snappop/proc/on_entered(datum/source, atom/movable/H, ...)
	if(ishuman(H) || issilicon(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(issilicon(H) || M.m_intent == MOVE_INTENT_RUN)
			to_chat(M, span_danger("You step on the snap pop!"))
			pop_burst(2, 0)

/obj/item/toy/snappop/phoenix
	name = "phoenix snap pop"
	desc = "Wow! And wow! And wow!"
	ash_type = /obj/effect/decal/cleanable/ash/snappop_phoenix

/obj/effect/decal/cleanable/ash/snappop_phoenix
	var/respawn_time = 300

/obj/effect/decal/cleanable/ash/snappop_phoenix/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), respawn_time)

/obj/effect/decal/cleanable/ash/snappop_phoenix/proc/respawn()
	new /obj/item/toy/snappop/phoenix(get_turf(src))
	qdel(src)


/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	var/timer = 0
	var/cooldown = 30
	var/quiet = 0

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	if(timer < world.time)
		to_chat(user, span_notice("You play with [src]."))
		timer = world.time + cooldown
		if(!quiet)
			playsound(user, 'sound/mecha/mechstep.ogg', 20, 1)
	else
		. = ..()

/obj/item/toy/prize/attack_hand(mob/user, modifiers)
	. = ..()
	if(.)
		return
	if(loc == user)
		attack_self(user)

/obj/item/toy/prize/ripley
	name = "toy Ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/12."

/obj/item/toy/prize/fireripley
	name = "toy firefighting Ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/12."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad Ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/12."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy Gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/12."
	icon_state = "gygaxtoy"

/obj/item/toy/prize/durand
	name = "toy Durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/12."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/12."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy Marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/12."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy Seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/12."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy Mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/12."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy Odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/12."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy Phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/12."
	icon_state = "phazonprize"

/obj/item/toy/prize/reticence
	name = "toy Reticence"
	desc = "Mini-Mecha action figure! Collect them all! 12/12."
	icon_state = "reticenceprize"
	quiet = 1


/obj/item/toy/talking
	name = "talking action figure"
	desc = "A generic action figure modeled after nothing in particular."
	icon = 'icons/obj/toy.dmi'
	icon_state = "owlprize"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = FALSE
	var/messages = list("I'm super generic!", "Mathematics class is of variable difficulty!")
	var/span = "danger"
	var/recharge_time = 30

	var/chattering = FALSE
	var/phomeme

// Talking toys are language universal, and thus all species can use them
/obj/item/toy/talking/attack_alien(mob/user)
	return attack_hand(user)

/obj/item/toy/talking/attack_self(mob/user)
	if(!cooldown)
		var/list/messages = generate_messages()
		activation_message(user)
		playsound(loc, 'sound/machines/click.ogg', 20, 1)

		spawn(0)
			for(var/message in messages)
				toy_talk(user, message)
				sleep(1 SECONDS)

		cooldown = TRUE
		spawn(recharge_time)
			cooldown = FALSE
		return
	..()

/obj/item/toy/talking/proc/activation_message(mob/user)
	user.visible_message(
		span_notice("[user] pulls the string on \the [src]."),
		span_notice("You pull the string on \the [src]."),
		span_notice("You hear a string being pulled."))

/obj/item/toy/talking/proc/generate_messages()
	return list(pick(messages))

/obj/item/toy/talking/proc/toy_talk(mob/user, message)
	user.loc.visible_message("<span class='[span]'>[icon2html(src, viewers(user.loc))] [message]</span>")
	if(chattering)
		chatter(message, phomeme, user)

/*
 * AI core prizes
 */
/obj/item/toy/talking/AI
	name = "toy AI"
	desc = "A little toy model AI core with real law announcing action!"
	icon_state = "AI"

/obj/item/toy/talking/AI/generate_messages()
	return list(generate_ion_law())

/obj/item/toy/talking/codex_gigas
	name = "Toy Codex Gigas"
	desc = "A tool to help you write fictional devils!"
	icon = 'icons/obj/library.dmi'
	icon_state = "demonomicon"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	recharge_time = 60

/obj/item/toy/talking/codex_gigas/activation_message(mob/user)
	user.visible_message(
		span_notice("[user] presses the button on \the [src]."),
		span_notice("You press the button on \the [src]."),
		span_notice("You hear a soft click."))

/obj/item/toy/talking/codex_gigas/generate_messages()
	var/datum/fakeDevil/devil = new
	var/list/messages = list()
	messages += "Some fun facts about: [devil.truename]"
	messages += "[GLOB.lawlorify[LORE][devil.bane]]"
	messages += "[GLOB.lawlorify[LORE][devil.obligation]]"
	messages += "[GLOB.lawlorify[LORE][devil.ban]]"
	messages += "[GLOB.lawlorify[LORE][devil.banish]]"
	return messages

/obj/item/toy/talking/owl
	name = "owl action figure"
	desc = "An action figure modeled after 'The Owl', defender of justice."
	icon_state = "owlprize"
	messages = list("You won't get away this time, Griffin!", "Stop right there, criminal!", "Hoot! Hoot!", "I am the night!")
	chattering = TRUE
	phomeme = "owl"

/obj/item/toy/talking/griffin
	name = "griffin action figure"
	desc = "An action figure modeled after 'The Griffin', criminal mastermind."
	icon_state = "griffinprize"
	messages = list("You can't stop me, Owl!", "My plan is flawless! The vault is mine!", "Caaaawwww!", "You will never catch me!")
	chattering = TRUE
	phomeme = "griffin"

/*
|| A Deck of Cards for playing various games of chance ||
*/

/obj/item/toy/cards
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/parentdeck = null
	var/deckstyle = "nanotrasen"
	var/card_hitsound = null
	var/card_force = 0
	var/card_throwforce = 0
	var/card_throw_speed = 3
	var/card_throw_range = 7
	var/list/card_attack_verb = list("attacked")

/obj/item/toy/cards/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] wrists with \the [src]! It looks like [user.p_they()] [user.p_have()] a crummy hand!"))
	playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
	return BRUTELOSS

/obj/item/toy/cards/proc/apply_card_vars(obj/item/toy/cards/newobj, obj/item/toy/cards/sourceobj) // Applies variables for supporting multiple types of card deck
	if(!istype(sourceobj))
		return

/obj/item/toy/cards/deck
	name = "deck of cards"
	desc = "A deck of space-grade playing cards."
	icon = 'icons/obj/toy.dmi'
	deckstyle = "nanotrasen"
	icon_state = "deck_nanotrasen_full"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/obj/machinery/computer/holodeck/holo = null // Holodeck cards should not be infinite
	var/list/cards = list()

/obj/item/toy/cards/deck/Initialize(mapload)
	. = ..()
	populate_deck()

/obj/item/toy/cards/deck/proc/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/i in 2 to 10)
		cards += "[i] of Hearts"
		cards += "[i] of Spades"
		cards += "[i] of Clubs"
		cards += "[i] of Diamonds"
	cards += "King of Hearts"
	cards += "King of Spades"
	cards += "King of Clubs"
	cards += "King of Diamonds"
	cards += "Queen of Hearts"
	cards += "Queen of Spades"
	cards += "Queen of Clubs"
	cards += "Queen of Diamonds"
	cards += "Jack of Hearts"
	cards += "Jack of Spades"
	cards += "Jack of Clubs"
	cards += "Jack of Diamonds"
	cards += "Ace of Hearts"
	cards += "Ace of Spades"
	cards += "Ace of Clubs"
	cards += "Ace of Diamonds"

//ATTACK HAND IGNORING PARENT RETURN VALUE
//ATTACK HAND NOT CALLING PARENT
/obj/item/toy/cards/deck/attack_hand(mob/user)
	draw_card(user)

/obj/item/toy/cards/deck/proc/draw_card(mob/user, drawnumber = 1)//Person who draws the card, number of cards to be drawn
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	var/choice = null
	if(cards.len == 0)
		to_chat(user, span_warning("There are no more cards to draw!"))
		return
	if (drawnumber == 1)
		var/obj/item/toy/cards/singlecard/C = new(user.loc)
		choice = cards[1]
		user.visible_message("[user] draws a card from the deck.", span_notice("You draw a card from the deck."))
		C.cardname = choice
		if(holo)
			holo.spawned += C // track them leaving the holodeck
		C.parentdeck = src
		C.apply_card_vars(C, src)
		C.deckstyle = deckstyle
		cards.Cut(1,2)
		user.put_in_hands(C)
		update_appearance(UPDATE_ICON)
		C.interact(user)
	else //if more than one card is drawn
		var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.drop_location())
		user.visible_message("[user] draws [drawnumber] cards from the deck.", span_notice("You draw [drawnumber] cards from the deck."))
		var/i
		for (i=1,i<=drawnumber,i++)
			H.currenthand+=cards[i]
		if(holo)
			holo.spawned += H // track them leaving the holodeck
		H.parentdeck = src
		H.deckstyle=deckstyle
		src.cards.Cut(1,drawnumber+1)
		user.put_in_hands(H)
		update_appearance(UPDATE_ICON)
		H.interact(user)
		H.update_appearance(UPDATE_ICON)

/obj/item/toy/cards/deck/AltClick(mob/living/L)
	if(!(L.mobility_flags & MOBILITY_PICKUP))
		return
	if(cards.len == 0)
		to_chat(L, span_warning("There are no more cards to draw!"))
		return
	var/drawsize = input(L, "How many cards to draw? (1-[min(cards.len,10)])", "Cards") as null|num
	if (drawsize && isnum(drawsize))
		drawsize=clamp(drawsize,1,min(cards.len,10))
		draw_card(L,drawsize)

/obj/item/toy/cards/deck/update_icon_state()
	. = ..()
	if(cards.len > 26)
		icon_state = "deck_[deckstyle]_full"
	else if(cards.len > 10)
		icon_state = "deck_[deckstyle]_half"
	else if(cards.len > 0)
		icon_state = "deck_[deckstyle]_low"
	else if(cards.len == 0)
		icon_state = "deck_[deckstyle]_empty"

/obj/item/toy/cards/deck/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This one contains [cards.len] cards.<span>"
	. += "<span class='notice'>Alt-click the deck to draw multiple cards at once.<span>"

/obj/item/toy/cards/deck/attack_self(mob/user)
	if(cooldown < world.time - 50)
		cards = shuffle(cards)
		playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
		user.visible_message("[user] shuffles the deck.", span_notice("You shuffle the deck."))
		cooldown = world.time

/obj/item/toy/cards/deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard))
		var/obj/item/toy/cards/singlecard/SC = I
		if(SC.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(SC))
				to_chat(user, span_warning("The card is stuck to your hand, you can't add it to the deck!"))
				return
			cards += SC.cardname
			user.visible_message("[user] adds a card to the bottom of the deck.",span_notice("You add the card to the bottom of the deck."))
			qdel(SC)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))
		update_appearance(UPDATE_ICON)
	else if(istype(I, /obj/item/toy/cards/cardhand))
		var/obj/item/toy/cards/cardhand/CH = I
		if(CH.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(CH))
				to_chat(user, span_warning("The hand of cards is stuck to your hand, you can't add it to the deck!"))
				return
			cards += CH.currenthand
			user.visible_message("[user] puts [user.p_their()] hand of cards in the deck.", span_notice("You put the hand of cards in the deck."))
			qdel(CH)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))
		update_appearance(UPDATE_ICON)
	else
		return ..()

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, span_notice("You pick up the deck."))

		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, span_notice("You pick up the deck."))

	else
		to_chat(usr, span_warning("You can't reach it from here!"))


/obj/item/toy/cards/cardhand
	name = "hand of cards"
	desc = "A number of cards not in a deck, customarily held in ones hand."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nanotrasen_hand2"
	w_class = WEIGHT_CLASS_TINY
	var/list/currenthand = list()
	var/choice = null


/obj/item/toy/cards/cardhand/attack_self(mob/user)
	var/list/handradial = list()

	interact(user)

	for(var/t in currenthand)
		handradial[t] = image(icon = src.icon, icon_state = "sc_[t]_[deckstyle]")

	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	if(!(cardUser.mobility_flags & MOBILITY_USE))
		return
	var/O = src
	var/choice = show_radial_menu(usr,src, handradial, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE
	var/obj/item/toy/cards/singlecard/C = new/obj/item/toy/cards/singlecard(cardUser.loc)
	currenthand -= choice
	handradial -= choice
	C.parentdeck = parentdeck
	C.cardname = choice
	C.apply_card_vars(C,O)
	cardUser.put_in_hands(C)
	cardUser.visible_message(span_notice("[cardUser] draws a card from [cardUser.p_their()] hand."), span_notice("You take the [C.cardname] from your hand."))

	interact(cardUser)
	update_appearance(UPDATE_ICON)
	if(length(currenthand) == 1)
		var/obj/item/toy/cards/singlecard/N = new/obj/item/toy/cards/singlecard(loc)
		N.parentdeck = parentdeck
		N.cardname = currenthand[1]
		N.apply_card_vars(N,O)
		qdel(src)
		cardUser.put_in_hands(N)
		cardUser.visible_message("[cardUser] also takes their last card and holds it.", span_notice("You also take [currenthand[1]] and hold it.")) //the outside world will now know when you break a 2 card hand into two separate cards. Useful for UNO but can be used by any card game

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == src.parentdeck)
			src.currenthand += C.cardname
			user.visible_message("[user] adds a card to [user.p_their()] hand.", span_notice("You add the [C.cardname] to your hand."))
			qdel(C)
			interact(user)
			update_appearance(UPDATE_ICON)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/cardhand/C, mob/living/user, params) //Same as above, but for card hands!
	if(istype(C))
		if(C.parentdeck == src.parentdeck) //if the cards come from the same deck
			var/i
			for(i=1, i<=C.currenthand.len, i++)
				src.currenthand += C.currenthand[i] //adds all the cards from the other hand to this one
			user.visible_message("[user] adds the cards from [user.p_their()] hand to another, consolidating them.", span_notice("You add the cards from one hand to another."))
			qdel(C)
			interact(user)
			update_appearance(UPDATE_ICON)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/cardhand/apply_card_vars(obj/item/toy/cards/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "[deckstyle]_hand2" // Another dumb hack, without this the hand is invisible (or has the default deckstyle) until another card is added.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.resistance_flags = sourceobj.resistance_flags

///check_menu: Checks if we are allowed to interact with a radial menu

///Arguments:
///user The mob interacting with a menu

/obj/item/toy/cards/cardhand/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/toy/cards/cardhand/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This hand has [currenthand.len] cards in it.<span>"

/obj/item/toy/cards/cardhand/update_icon_state()
	. = ..()
	if(currenthand.len > 4)
		icon_state = "[deckstyle]_hand5"
	else
		icon_state = "[deckstyle]_hand[currenthand.len]"

/obj/item/toy/cards/cardhand/update_overlays()
	. = ..()
	var/overlay_cards = currenthand.len

	var/k = overlay_cards == 2 ? 1 : overlay_cards - 2
	for(var/i = k; i <= overlay_cards; i++)
		var/card_overlay = image(icon=src.icon,icon_state="sc_[currenthand[i]]_[deckstyle]",pixel_x=(1-i+k)*3,pixel_y=(1-i+k)*3)
		. += card_overlay

/obj/item/toy/cards/singlecard
	name = "card"
	desc = "A card."
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_down_nanotrasen"
	w_class = WEIGHT_CLASS_TINY
	var/cardname = null
	var/flipped = 0
	pixel_x = -5

/obj/item/toy/cards/singlecard/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.is_holding(src))
			cardUser.visible_message("[cardUser] checks [cardUser.p_their()] card.", span_notice("The card reads: [cardname]."))
		else
			. += span_warning("You need to have the card in your hand to check it!")

/obj/item/toy/cards/singlecard/verb/Flip()
	set name = "Flip Card"
	set category = "Object"
	set src in range(1)
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return
	if(!flipped)
		src.flipped = 1
		if (cardname)
			src.icon_state = "sc_[cardname]_[deckstyle]"
			src.name = src.cardname
		else
			src.icon_state = "sc_Ace of Spades_[deckstyle]"
			src.name = "What Card"
		src.pixel_x = 5
	else if(flipped)
		src.flipped = 0
		src.icon_state = "singlecard_down_[deckstyle]"
		src.name = "card"
		src.pixel_x = -5

/obj/item/toy/cards/singlecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/))
		var/obj/item/toy/cards/singlecard/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			to_chat(user, span_notice("You combine the [C.cardname] and the [src.cardname] into a hand."))
			qdel(C)
			qdel(src)
			user.put_in_active_hand(H)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))

	if(istype(I, /obj/item/toy/cards/cardhand/))
		var/obj/item/toy/cards/cardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.visible_message("[user] adds a card to [user.p_their()] hand.", span_notice("You add the [cardname] to your hand."))
			qdel(src)
			H.interact(user)
			H.update_appearance(UPDATE_ICON)
		else
			to_chat(user, span_warning("You can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/singlecard/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user) || !(user.mobility_flags & MOBILITY_USE))
		return
	Flip()

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]" // Without this the card is invisible until flipped. It's an ugly hack, but it works.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.attack_verb = newobj.card_attack_verb


/*
|| Syndicate playing cards, for pretending you're Gambit and playing poker for the nuke disk. ||
*/

/obj/item/toy/cards/deck/syndicate
	name = "suspicious looking deck of cards"
	desc = "A deck of space-grade playing cards. They seem unusually rigid."
	icon_state = "deck_syndicate_full"
	deckstyle = "syndicate"
	card_hitsound = 'sound/weapons/bladeslice.ogg'
	card_force = 5
	card_throwforce = 10
	card_throw_speed = 3
	card_throw_range = 7
	card_attack_verb = list("attacked", "sliced", "diced", "slashed", "cut")
	resistance_flags = NONE

/*
 * YOU HAVE UNO IT CAME FREE WITH YOUR FUCKING PDA
 */

/obj/item/toy/cards/deck/uno
	name = "deck of UNO cards"
	desc = "A deck of space-grade UNO cards."
	deckstyle = "uno"
	icon_state = "deck_uno_full"

/obj/item/toy/cards/deck/uno/populate_deck() //RED GREEN YELLOW BLUE
	icon_state = "deck_[deckstyle]_full"
	for(var/i in 0 to 9)
		cards += "Red [i]"
		cards += "Green [i]"
		cards += "Yellow [i]"
		cards += "Blue [i]"
	for(var/k in 1 to 9) //there is only 1 zero, but 2 of each other card, yes this is shitcode :(
		cards += "Red [k]"
		cards += "Green [k]"
		cards += "Yellow [k]"
		cards += "Blue [k]"
	var/j=1
	for(j=1; j<=2; j++)
		cards += "Red Draw Two"
		cards += "Green Draw Two"
		cards += "Yellow Draw Two"
		cards += "Blue Draw Two"
		cards += "Red Skip"
		cards += "Green Skip"
		cards += "Yellow Skip"
		cards += "Blue Skip"
		cards += "Red Reverse"
		cards += "Green Reverse"
		cards += "Yellow Reverse"
		cards += "Blue Reverse"
	j=1
	for(j=1; j<=4; j++)
		cards += "Wildcard"
		cards += "Wild Draw Four"

/obj/item/toy/cards/deck/uno/update_icon_state()
	. = ..()
	if(cards.len > 54)
		icon_state = "deck_[deckstyle]_full"
	else if(cards.len > 25)
		icon_state = "deck_[deckstyle]_half"
	else if(cards.len > 0)
		icon_state = "deck_[deckstyle]_low"
	else if(cards.len == 0)
		icon_state = "deck_[deckstyle]_empty"

/*
 * Fake nuke
 */

/obj/item/toy/nuke
	name = "\improper Nuclear Fission Explosive toy"
	desc = "A plastic model of a Nuclear Fission Explosive."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nuketoyidle"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/nuke/attack_self(mob/user)
	if (cooldown < world.time)
		cooldown = world.time + 3 MINUTES //3 minutes
		user.visible_message(span_warning("[user] presses a button on [src]."), span_notice("You activate [src], it plays a loud noise!"), span_italics("You hear the click of a button."))
		sleep(0.5 SECONDS)
		icon_state = "nuketoy"
		playsound(src, 'sound/machines/alarm.ogg', 100, 0)
		sleep(13.5 SECONDS)
		icon_state = "nuketoycool"
		sleep(cooldown - world.time)
		icon_state = "nuketoyidle"
	else
		var/timeleft = (cooldown - world.time)
		to_chat(user, "[span_alert("Nothing happens, and '")][round(timeleft/10)][span_alert("' appears on a small display.")]")

/*
 * Fake meteor
 */

/obj/item/toy/minimeteor
	name = "\improper Mini-Meteor"
	desc = "Relive the excitement of a meteor shower! SweetMeat-eor. Co is not responsible for any injuries, headaches or hearing loss caused by Mini-Meteor."
	icon = 'icons/obj/toy.dmi'
	icon_state = "minimeteor"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/minimeteor/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)
		for(var/mob/M in urange(10, src))
			if(!M.stat && !isAI(M))
				shake_camera(M, 3, 1)
		qdel(src)

/*
 * Toy big red button
 */
/obj/item/toy/redbutton
	name = "big red button"
	desc = "A big, plastic red button. Reads 'From HonkCo Pranks?' on the back."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/boom_sound = 'sound/effects/explosionfar.ogg'

/obj/item/toy/redbutton/attack_self(mob/user)
	if (cooldown < world.time)
		cooldown = (world.time + 300) // Sets cooldown at 30 seconds
		user.visible_message(span_warning("[user] presses the big red button."), span_notice("You press the button, it plays a loud noise!"), span_italics("The button clicks loudly."))
		playsound(src, boom_sound, 50, 0)
		for(var/mob/M in urange(10, src)) // Checks range
			if(!M.stat && !isAI(M)) // Checks to make sure whoever's getting shaken is alive/not the AI
				sleep(0.8 SECONDS) // Short delay to match up with the explosion sound
				shake_camera(M, 2, 1) // Shakes player camera 2 squares for 1 second.

	else
		to_chat(user, span_alert("Nothing happens."))

/*
 * Snowballs
 */

/obj/item/toy/snowball
	name = "snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 20
	damtype = STAMINA

/obj/item/toy/snowball/afterattack(atom/target as mob|obj|turf|area, mob/user)
	. = ..()
	if(user.dropItemToGround(src))
		throw_at(target, throw_range, throw_speed)

/obj/item/toy/snowball/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/effects/pop.ogg', 20, 1)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.apply_damage(20, STAMINA)
		qdel(src)

/*
 * Beach ball
 */
/obj/item/toy/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "beachball"
	w_class = WEIGHT_CLASS_BULKY //Stops people from hiding it in their bags/pockets

/obj/item/toy/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user)
	. = ..()
	if(user.dropItemToGround(src))
		throw_at(target, throw_range, throw_speed)
/*
 * Turn tracker
 */

obj/item/toy/turn_tracker
	name= "turn tracker"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigblue"
	desc= "A turn tracker, used to track turns. Duh.\nClick on it in hand to set it up.\nAlt-click to reverse turn order."
	var/list/names=list()
	var/turn=0
	var/info=null
	var/turndir=1//1 for forwards, -1 for backwards
	var/cooldown=0


/obj/item/toy/turn_tracker/attack_self(mob/user)
	info=stripped_input(user, "Insert a list of names seperated by commas (John, Rose, Steve)", "Names")
	if (info)
		names = splittext(info,",")
		to_chat(user, span_notice("You set up the turn tracker. "))
	return

/obj/item/toy/turn_tracker/attack_hand(mob/user)
	if (cooldown < world.time)
		cooldown = (world.time + 5) //0.5 second cooldown
		if (names.len==0)
			to_chat(user, span_warning("You need to set it up first!"))
			return
		turn+=turndir//+1 for normal, -1 for backwardz
		if(turn>names.len)
			turn=1
		else if(turn<1)
			turn=names.len
		audible_message(span_notice("[user] clicks the button. [src] says: \"It is [names[turn]]'s turn!\""))
		flick("bigblue_press", src)

/obj/item/toy/turn_tracker/AltClick(mob/user)
	audible_message(span_notice("[user] clicks the button. [src] says: \"Direction Reversed!\""))
	turndir=turndir*-1 //this reverses the direction (1 becomes -1, -1 becomes 1)

/obj/item/toy/turn_tracker/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, span_notice("You pick up the turn tracker."))

		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, span_notice("You pick up the turn tracker."))
	else
		to_chat(usr, span_warning("You can't reach it from here!"))

/*
 * Clockwork Watch
 */

/obj/item/toy/clockwork_watch
	name = "steampunk watch"
	desc = "A stylish steampunk watch made out of thousands of tiny cogwheels."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "dread_ipad"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/clockwork_watch/attack_self(mob/user)
	if (cooldown < world.time)
		cooldown = world.time + 1800 //3 minutes
		user.visible_message(span_warning("[user] rotates a cogwheel on [src]."), span_notice("You rotate a cogwheel on [src], it plays a loud noise!"), span_italics("You hear cogwheels turning."))
		playsound(src, 'sound/magic/clockwork/ark_activation.ogg', 50, 0)
	else
		to_chat(user, span_alert("The cogwheels are already turning!"))

/obj/item/toy/clockwork_watch/examine(mob/user)
	. = ..()
	. += span_info("Station Time: [station_time_timestamp()]")

/*
 * Toy Dagger
 */

/obj/item/toy/toy_dagger
	name = "toy dagger"
	desc = "A cheap plastic replica of a dagger. Produced by THE ARM Toys, Inc."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "render"
	item_state = "cultdagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/*
 * Xenomorph action figure
 */

/obj/item/toy/toy_xeno
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_xeno"
	name = "xenomorph action figure"
	desc = "MEGA presents the new Xenos Isolated action figure! Comes complete with realistic sounds! Pull back string to use."
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/toy_xeno/attack_self(mob/user)
	if(cooldown <= world.time)
		cooldown = (world.time + 50) //5 second cooldown
		user.visible_message(span_notice("[user] pulls back the string on [src]."))
		icon_state = "[initial(icon_state)]_used"
		sleep(0.5 SECONDS)
		audible_message(span_danger("[icon2html(src, viewers(src))] Hiss!"))
		var/list/possible_sounds = list('sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg', 'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg')
		var/chosen_sound = pick(possible_sounds)
		playsound(get_turf(src), chosen_sound, 50, 1)
		spawn(45)
			if(src)
				icon_state = "[initial(icon_state)]"
	else
		to_chat(user, span_warning("The string on [src] hasn't rewound all the way!"))
		return

// TOY MOUSEYS :3 :3 :3

/obj/item/toy/cattoy
	name = "toy mouse"
	desc = "A colorful toy mouse!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_mouse"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	resistance_flags = FLAMMABLE


/*
 * Action Figures
 */

/obj/item/toy/figure
	name = "Non-Specific Action Figure action figure"
	desc = null
	icon = 'icons/obj/toy.dmi'
	icon_state = "nuketoy"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/toysay = "What the fuck did you do?"
	var/toysound = 'sound/machines/click.ogg'

/obj/item/toy/figure/Initialize(mapload)
	. = ..()
	desc = "A \"Space Life\" brand [src]."

/obj/item/toy/figure/attack_self(mob/user as mob)
	if(cooldown <= world.time)
		cooldown = world.time + 50
		to_chat(user, span_notice("[src] says \"[toysay]\""))
		playsound(user, toysound, 20, 1)

/obj/item/toy/figure/cmo
	name = "Chief Medical Officer action figure"
	icon_state = "cmo"
	toysay = "Suit sensors!"

/obj/item/toy/figure/assistant
	name = "Assistant action figure"
	icon_state = "assistant"
	toysay = "Grey tide world wide!"

/obj/item/toy/figure/atmos
	name = "Atmospheric Technician action figure"
	icon_state = "atmos"
	toysay = "Glory to Atmosia!"

/obj/item/toy/figure/bartender
	name = "Bartender action figure"
	icon_state = "bartender"
	toysay = "Where is Pun Pun?"

/obj/item/toy/figure/borg
	name = "Cyborg action figure"
	icon_state = "borg"
	toysay = "I. LIVE. AGAIN."
	toysound = 'sound/voice/liveagain.ogg'

/obj/item/toy/figure/botanist
	name = "Botanist action figure"
	icon_state = "botanist"
	toysay = "Blaze it!"

/obj/item/toy/figure/captain
	name = "City Administrator action figure"
	icon_state = "captain"
	toysay = "Any heads of staff?"

/obj/item/toy/figure/cargotech
	name = "Cargo Technician action figure"
	icon_state = "cargotech"
	toysay = "For Cargonia!"

/obj/item/toy/figure/ce
	name = "Chief Engineer action figure"
	icon_state = "ce"
	toysay = "Wire the solars!"

/obj/item/toy/figure/chaplain
	name = "Chaplain action figure"
	icon_state = "chaplain"
	toysay = "Praise Space Jesus!"

/obj/item/toy/figure/chef
	name = "Chef action figure"
	icon_state = "chef"
	toysay = "I'll make you into a burger!"

/obj/item/toy/figure/chemist
	name = "Chemist action figure"
	icon_state = "chemist"
	toysay = "Get your pills!"

/obj/item/toy/figure/clerk
	name = "Clerk action figure"
	icon_state = "clerk"
	toysay = "Perfectly legal rifle for sale!"

/obj/item/toy/figure/clown
	name = "Clown action figure"
	icon_state = "clown"
	toysay = "Honk!"
	toysound = 'sound/items/bikehorn.ogg'

/obj/item/toy/figure/ian
	name = "Ian action figure"
	icon_state = "ian"
	toysay = "Arf!"

/obj/item/toy/figure/detective
	name = "Detective action figure"
	icon_state = "detective"
	toysay = "This airlock has grey jumpsuit and insulated glove fibers on it."

/obj/item/toy/figure/dsquad
	name = "Death Squad Officer action figure"
	icon_state = "dsquad"
	toysay = "Kill em all!"

/obj/item/toy/figure/engineer
	name = "Engineer action figure"
	icon_state = "engineer"
	toysay = "Oh god, the singularity is loose!"

/obj/item/toy/figure/geneticist
	name = "Geneticist action figure"
	icon_state = "geneticist"
	toysay = "Smash!"

/obj/item/toy/figure/hop
	name = "Labor Lead action figure"
	icon_state = "hop"
	toysay = "Giving out all access!"

/obj/item/toy/figure/hos
	name = "Divisional Lead action figure"
	icon_state = "hos"
	toysay = "Go ahead, make my day."

/obj/item/toy/figure/qm
	name = "Quartermaster action figure"
	icon_state = "qm"
	toysay = "Please sign this form in triplicate and we will see about geting you a welding mask within 3 business days."

/obj/item/toy/figure/janitor
	name = "Janitor action figure"
	icon_state = "janitor"
	toysay = "Look at the signs, you idiot."

/obj/item/toy/figure/lawyer
	name = "Lawyer action figure"
	icon_state = "lawyer"
	toysay = "My client is a dirty traitor!"

/obj/item/toy/figure/curator
	name = "Curator action figure"
	icon_state = "curator"
	toysay = "One day while..."

/obj/item/toy/figure/md
	name = "Medical Doctor action figure"
	icon_state = "md"
	toysay = "The patient is already dead!"

/obj/item/toy/figure/mime
	name = "Mime action figure"
	icon_state = "mime"
	toysay = "..."
	toysound = null

/obj/item/toy/figure/miner
	name = "Shaft Miner action figure"
	icon_state = "miner"
	toysay = "COLOSSUS RIGHT OUTSIDE THE BASE!"

/obj/item/toy/figure/ninja
	name = "Ninja action figure"
	icon_state = "ninja"
	toysay = "Oh god! Stop shooting, I'm friendly!"

/obj/item/toy/figure/wizard
	name = "Wizard action figure"
	icon_state = "wizard"
	toysay = "Ei Nath!"
	toysound = 'sound/magic/disintegrate.ogg'

/obj/item/toy/figure/rd
	name = "Research Director action figure"
	icon_state = "rd"
	toysay = "Blowing all of the borgs!"

/obj/item/toy/figure/roboticist
	name = "Roboticist action figure"
	icon_state = "roboticist"
	toysay = "Big stompy mechs!"
	toysound = 'sound/mecha/mechstep.ogg'

/obj/item/toy/figure/scientist
	name = "Scientist action figure"
	icon_state = "scientist"
	toysay = "I call toxins."
	toysound = 'sound/effects/explosionfar.ogg'

/obj/item/toy/figure/syndie
	name = "Nuclear Operative action figure"
	icon_state = "syndie"
	toysay = "Get that fucking disk!"

/obj/item/toy/figure/secofficer
	name = "Security Officer action figure"
	icon_state = "secofficer"
	toysay = "I am the law!"
	toysound = 'sound/voice/complionator/dredd.ogg'

/obj/item/toy/figure/virologist
	name = "Virologist action figure"
	icon_state = "virologist"
	toysay = "The cure is potassium!"

/obj/item/toy/figure/warden
	name = "Warden action figure"
	icon_state = "warden"
	toysay = "Seventeen minutes for coughing at an officer!"

/obj/item/toy/figure/traitor
	name = "Traitor action figure"
	icon_state = "traitor"
	toysay = "I got this scroll from a dead assistant!"

/obj/item/toy/figure/traitor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen/red/edagger))
		var/obj/item/pen/red/edagger/pen = I
		if(pen.on)
			icon_state += "_pen" // edagger buddies
			playsound(I.loc, 'sound/weapons/saberon.ogg', 35, TRUE)
	..()

/obj/item/toy/figure/ling
	name = "Changeling action figure"
	icon_state = "ling"
	toysay = ";g absorbing AI in traitor maint!"

/obj/item/toy/figure/ling/Initialize(mapload)
	. = ..()
	if(prob(25))
		icon_state = "ling[rand(1,3)]"
		playsound(src.loc, 'sound/effects/blobattack.ogg', 30, TRUE)

/obj/item/toy/dummy
	name = "ventriloquist dummy"
	desc = "It's a dummy, dummy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"
	item_state = "doll"
	var/doll_name = "Dummy"

//Add changing looks when i feel suicidal about making 20 inhands for these.
/obj/item/toy/dummy/attack_self(mob/user)
	var/new_name = stripped_input(usr,"What would you like to name the dummy?","Input a name",doll_name,MAX_NAME_LEN)
	if(!new_name)
		return
	doll_name = new_name
	to_chat(user, "You name the dummy as \"[doll_name]\"")
	name = "[initial(name)] - [doll_name]"

/obj/item/toy/dummy/talk_into(atom/movable/A, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/M = A
	if (istype(M))
		M.log_talk(message, LOG_SAY, tag="dummy toy")

	say(message, language)
	return NOPASS

/obj/item/toy/dummy/GetVoice()
	return doll_name

/obj/item/toy/eldritch_book
	name = "Codex Cicatrix"
	desc = "A toy book that closely resembles the Codex Cicatrix. Covered in fake polyester human flesh and has a huge goggly eye attached to the cover. The runes are gibberish and cannot be used to summon demons... Hopefully?"
	icon = 'icons/obj/eldritch.dmi'
	icon_state = "book"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("sacrificed", "transmuted", "grasped", "cursed")
	/// Helps determine the icon state of this item when it's used on self.
	var/book_open = FALSE

/obj/item/toy/eldritch_book/attack_self(mob/user)
	book_open = !book_open
	update_appearance(UPDATE_ICON)

/obj/item/toy/eldritch_book/update_icon_state()
	. = ..()
	icon_state = book_open ? "book_open" : "book"

/*
 * Fake tear
 */

/obj/item/toy/reality_pierce
	name = "Pierced reality"
	desc = "Hah. You thought it was the real deal!"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "pierced_illusion"

/obj/item/storage/box/heretic_box
	name = "box of pierced realities"
	desc = "A box containing toys resembling pierced realities."

/obj/item/storage/box/heretic_box/PopulateContents()
	for(var/i in 1 to rand(1,4))
		new /obj/item/toy/reality_pierce(src)

/*
 * ceremonial Rod of Asclepius
 */

/obj/item/toy/rod_of_asclepius
	name = "ceremonial Rod of Asclepius"
	desc = "A wooden rod about the size of your forearm with a snake carved around it, winding its way up the sides of the rod. This is a ceremonial recreation given to the Chief Medical Officer, and has 'Nanotrasen Emergency Medical' engraved at the bottom."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	icon_state = "asclepius_dormant"

/*
 * Cult sickles
 */

/obj/item/gun/magic/sickly_blade_toy
	name = "plastic replica blade"
	desc = "A sickly green crescent blade, decorated with a plastic eye. You feel like this was cheaply made. A Donk Co logo is on the hilt."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "eldritch_blade"
	item_state = "eldritch_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "rends")
	recharge_rate = 3 // seconds
	ammo_type = /obj/item/ammo_casing/magic/sickly_blade_toy
	fire_sound = 'sound/effects/snap.ogg'
	item_flags = NEEDS_PERMIT // doesn't include NOBLUDGEON for obvious reasons

/obj/item/gun/magic/sickly_blade_toy/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, span_warning("The [name] grumbles quietly. It is not yet ready to fire again!"))

/obj/item/ammo_casing/magic/sickly_blade_toy
	projectile_type = /obj/projectile/sickly_blade_toy
	harmful = FALSE
/obj/projectile/sickly_blade_toy
	name = "hook"
	icon_state = "hook"
	icon = 'icons/obj/lavaland/artefacts.dmi'
	pass_flags = PASSTABLE
	damage = 0
	knockdown = 0
	immobilize = 0 // there's no escape
	range = 5 // hey now cowboy
	armour_penetration = 0 // no piercing shields
	knockdown = 0
	hitsound = 'sound/effects/gravhit.ogg'

/obj/projectile/sickly_blade_toy/on_hit(atom/target, blocked)
	. = ..()
	if(ismovable(target) && blocked != 100)
		var/atom/movable/A = target
		A.visible_message(span_danger("[A] is snagged by [firer]'s hook!"))
	return

/obj/item/gun/magic/sickly_blade_toy/attack(mob/living/M, mob/living/user)
	if((IS_HERETIC(user) || IS_HERETIC_MONSTER(user)))
		to_chat(user,span_danger("You feel a pulse of the old gods lash out at your mind, laughing how you're using a fake blade!")) //the outer gods need a lil chuckle every now and then
	return ..()

/obj/item/gun/magic/sickly_blade_toy/rust_toy
	name = "rustic replica blade"
	desc = "This crescent blade is decrepit, wasting to dust. Yet still it bites, catching flesh with jagged, rotten foam."
	icon_state = "rust_blade"
	item_state = "rust_blade"

/obj/item/gun/magic/sickly_blade_toy/ash_toy
	name = "metallic replica blade"
	desc = "A hunk of molten soft injection plastic warped to cinders and slag. Unmade and remade countless times over, it aspires to be more than it is."
	icon_state = "ash_blade"
	item_state = "ash_blade"

/obj/item/gun/magic/sickly_blade_toy/flesh_toy
	name = "flesh-like replica blade"
	desc = "A blade of strange material born from a fleshwarped creature. Keenly aware, it seeks to spread the excruciating comedy it has endured from dread origins."
	icon_state = "flesh_blade"
	item_state = "flesh_blade"
