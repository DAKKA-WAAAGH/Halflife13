/mob/living/carbon/movement_delay()
	. = ..()
	. += grab_state * 3 //can't go fast while grabbing something.

	if(!get_leg_ignore()) //ignore the fact we lack legs
		var/leg_amount = get_num_legs()
		. += max(6 - 3*leg_amount, 0) //the fewer the legs, the slower the mob
		if(!leg_amount)
			. += max((12 - 6*get_num_arms()), 0) //crawling is harder with fewer arms
		if(legcuffed)
			. += legcuffed.slowdown

/mob/living/carbon/slip(knockdown_amount, obj/O, lube, stun, force_drop)
	if(movement_type & FLYING)
		return 0
	if(!(lube&SLIDE_ICE))
		log_combat(src, (O ? O : get_turf(src)), "slipped on the", null, ((lube & SLIDE) ? "(LUBE)" : null))
	. = ..()
	
/mob/living/carbon/Process_Spacemove(movement_dir = 0)
	if(!.)
		. = ..()
	if(!isturf(loc))
		return FALSE
	// Do we have a jetpack implant (and is it on)?
	var/obj/item/organ/cyberimp/chest/thrusters/T = getorganslot(ORGAN_SLOT_TORSO_IMPLANT)
	if(istype(T))
		if(movement_dir && T.allow_thrust(0.01))
			. = TRUE

	var/obj/item/tank/jetpack/J = get_jetpack()
	if(istype(J))
		if((movement_dir || J.stabilizers) && J.allow_thrust(0.01, src))
			. =  TRUE

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(. && !(movement_type & FLOATING)) //floating is easy
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			set_nutrition(NUTRITION_LEVEL_FED - 1)	//just less than feeling vigorous
			set_hydration(HYDRATION_LEVEL_START_MAX - 1)	//just less than feeling vigorous
		else if(nutrition && stat != DEAD)
			adjust_nutrition(-(HUNGER_FACTOR/10))
			adjust_hydration(-(HUNGER_FACTOR/5))
			if(m_intent == MOVE_INTENT_RUN)
				adjust_nutrition(-(HUNGER_FACTOR/10))
				adjust_hydration(-(HUNGER_FACTOR/5))
