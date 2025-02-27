/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "lipstick"
	grind_results = list(/datum/reagent/phenol = 5)
	w_class = WEIGHT_CLASS_TINY
	var/colour = "red"
	var/open = FALSE

/obj/item/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/lipstick/jade
	//It's still called Jade, but theres no HTML color for jade, so we use lime.
	name = "jade lipstick"
	colour = "lime"

/obj/item/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/lipstick/random
	name = "lipstick"
	icon_state = "random_lipstick"

/obj/item/lipstick/random/Initialize(mapload)
	. = ..()
	icon_state = "lipstick"
	colour = pick("red","purple","lime","black","green","blue","white")
	name = "[colour] lipstick"

/obj/item/lipstick/attack_self(mob/user)
	cut_overlays()
	to_chat(user, span_notice("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		var/mutable_appearance/colored_overlay = mutable_appearance(icon, "lipstick_uncap_color")
		colored_overlay.color = colour
		icon_state = "lipstick_uncap"
		add_overlay(colored_overlay)
	else
		icon_state = "lipstick"

/obj/item/lipstick/attack(mob/M, mob/user)
	if(!open)
		return

	if(!ismob(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_mouth_covered())
			to_chat(user, span_warning("Remove [ H == user ? "your" : "[H.p_their()]" ] mask!"))
			return
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, span_warning("You need to wipe off the old lipstick first!"))
			return
		if(H == user)
			user.visible_message(span_notice("[user] does [user.p_their()] lips with \the [src]."), \
								 span_notice("You take a moment to apply \the [src]. Perfect!"))
			H.lip_style = "lipstick"
			H.lip_color = colour
			H.update_body()
		else
			user.visible_message(span_warning("[user] begins to do [H]'s lips with \the [src]."), \
								 span_notice("You begin to apply \the [src] on [H]'s lips..."))
			if(do_after(user, 2 SECONDS, H))
				user.visible_message("[user] does [H]'s lips with \the [src].", \
									 span_notice("You apply \the [src] on [H]'s lips."))
				H.lip_style = "lipstick"
				H.lip_color = colour
				H.update_body()
	else
		to_chat(user, span_warning("Where are the lips on that?"))

//you can wipe off lipstick with paper!
/obj/item/paper/attack(mob/M, mob/user)
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(!ismob(M))
			return

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, span_notice("You wipe off the lipstick with [src]."))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(span_warning("[user] begins to wipe [H]'s lipstick off with \the [src]."), \
								 	 span_notice("You begin to wipe off [H]'s lipstick..."))
				if(do_after(user, 1 SECONDS, H))
					user.visible_message("[user] wipes [H]'s lipstick off with \the [src].", \
										 span_notice("You wipe off [H]'s lipstick."))
					H.lip_style = null
					H.update_body()
	else
		..()

/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "razor"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY

/obj/item/razor/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins shaving [user.p_them()]self without the razor guard! It looks like [user.p_theyre()] trying to commit suicide!"))
	shave(user, BODY_ZONE_PRECISE_MOUTH)
	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
	return BRUTELOSS

/obj/item/razor/proc/shave(mob/living/carbon/human/H, location = BODY_ZONE_PRECISE_MOUTH)
	if(location == BODY_ZONE_PRECISE_MOUTH)
		H.facial_hair_style = "Shaved"
	else
		H.hair_style = "Skinhead"

	H.update_hair()
	playsound(loc, 'sound/items/welder2.ogg', 20, 1)


/obj/item/razor/attack(mob/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/location = user.zone_selected
		if((location in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)) && !H.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[H] doesn't have a head!"))
			return
		var/hair_name = "hair"
		if(location == BODY_ZONE_PRECISE_MOUTH)
			if(!user.combat_mode)
				if(H.gender == MALE)
					if (H == user)
						to_chat(user, span_warning("You need a mirror to properly style your own facial [hair_name]!"))
						return
					if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
						return
					var/list/hair_list = GLOB.facial_hair_styles_list
					var/new_style = input(user, "Select a facial [hair_name] style", "Grooming")  as null|anything in hair_list
					if(!get_location_accessible(H, location))
						to_chat(user, span_warning("The mask is in the way!"))
						return
					user.visible_message(span_notice("[user] tries to change [H]'s facial [hair_name] style using [src]."), span_notice("You try to change [H]'s facial [hair_name] style using [src]."))
					if(new_style && do_after(user, 6 SECONDS, H))
						user.visible_message(span_notice("[user] successfully changes [H]'s facial [hair_name] style using [src]."), span_notice("You successfully change [H]'s facial [hair_name] style using [src]."))
						H.facial_hair_style = new_style
						H.update_hair()
						return
				else
					return

			else
				if(!get_location_accessible(H, location))
					to_chat(user, span_warning("The mask is in the way!"))
					return
				if(!(FACEHAIR in H.dna.species.species_traits))
					to_chat(user, span_warning("There is no facial hair to shave!"))
					return
				if(H.facial_hair_style == "Shaved")
					to_chat(user, span_warning("Already clean-shaven!"))
					return
				if(H == user) //shaving yourself
					user.visible_message("[user] starts to shave [user.p_their()] facial [hair_name] with [src].", \
										 span_notice("You take a moment to shave your facial [hair_name] with [src]..."))
					if(do_after(user, 5 SECONDS, H))
						user.visible_message("[user] shaves [user.p_their()] facial [hair_name] clean with [src].", \
											 span_notice("You finish shaving with [src]. Fast and clean!"))
						shave(H, location)
				else
					user.visible_message(span_warning("[user] tries to shave [H]'s facial [hair_name] with [src]."), \
										 span_notice("You start shaving [H]'s facial [hair_name]..."))
					if(do_after(user, 5 SECONDS, target = H))
						user.visible_message(span_warning("[user] shaves off [H]'s facial [hair_name] with [src]."), \
											 span_notice("You shave [H]'s facial [hair_name] clean off."))
						shave(H, location)

		else if(location == BODY_ZONE_HEAD)
			if(!user.combat_mode)
				if (H == user)
					to_chat(user, span_warning("You need a mirror to properly style your own [hair_name]!"))
					return
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				var/hair_list = GLOB.hair_styles_list
				var/new_style = input(user, "Select a [hair_name] style", "Grooming")  as null|anything in hair_list
				if(!get_location_accessible(H, location))
					to_chat(user, span_warning("The headgear is in the way!"))
					return
				if(HAS_TRAIT(H, TRAIT_BALD))
					to_chat(user, span_warning("[H] is just way too bald. Like, really really bald."))
					return
				user.visible_message(span_notice("[user] tries to change [H]'s [hair_name]style using [src]."), span_notice("You try to change [H]'s [hair_name]style using [src]."))
				if(new_style && do_after(user, 6 SECONDS, H))
					user.visible_message(span_notice("[user] successfully changes [H]'s [hair_name]style using [src]."), span_notice("You successfully change [H]'s [hair_name]style using [src]."))
					H.hair_style = new_style
					H.update_hair()
					return

			else
				if(!get_location_accessible(H, location))
					to_chat(user, span_warning("The headgear is in the way!"))
					return

				if(!(HAIR in H.dna.species.species_traits))
					to_chat(user, span_warning("There is no hair to shave!"))
					return
					
				if(H.hair_style == "Bald" || H.hair_style == "Balding Hair" || H.hair_style == "Skinhead")
					to_chat(user, span_warning("There is not enough hair left to shave!"))
					return
					
				if(H == user) //shaving yourself
					user.visible_message("[user] starts to shave [user.p_their()] head with [src].", \
										 span_notice("You start to shave your head with [src]..."))
					if(do_after(user, 0.5 SECONDS, H))
						user.visible_message("[user] shaves [user.p_their()] head with [src].", \
											 span_notice("You finish shaving with [src]."))
						shave(H, location)
				else
					var/turf/H_loc = H.loc
					user.visible_message(span_warning("[user] tries to shave [H]'s head with [src]!"), \
										 span_notice("You start shaving [H]'s head..."))
					if(do_after(user, 5 SECONDS, H))
						if(H_loc == H.loc)
							user.visible_message(span_warning("[user] shaves [H]'s head bald with [src]!"), \
												 span_notice("You shave [H]'s head bald."))
							shave(H, location)
		else
			..()
	else
		..()

/obj/item/dyespray
	name = "hair dye spray"
	desc = "A spray to dye your hair any gradients you'd like."
	grind_results = list(/datum/reagent/phenol = 10, /datum/reagent/hair_dye = 5)
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "dyespray"

/obj/item/dyespray/attack_self(mob/user)
	dye(user)

/obj/item/dyespray/pre_attack(atom/target, mob/living/user, params)
	dye(target)
	return ..()

/**
 * Applies a gradient and a gradient color to a mob.
 *
 * Arguments:
 * * target - The mob who we will apply the gradient and gradient color to.
 */

/obj/item/dyespray/proc/dye(mob/target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target

	var/new_grad_style = input(usr, "Choose a color pattern:", "Character Preference")  as null|anything in GLOB.hair_gradients_list
	if(!new_grad_style)
		return

	var/new_grad_color = input(usr, "Choose a secondary hair color:", "Character Preference",human_target.grad_color) as color|null
	if(!new_grad_color)
		return

	human_target.grad_style = new_grad_style
	human_target.grad_color = sanitize_hexcolor(new_grad_color)
	to_chat(human_target, "<span class='notice'>You start applying the hair dye...</span>")
	if(!do_after(usr, 3 SECONDS, target))
		return
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	human_target.update_hair()
