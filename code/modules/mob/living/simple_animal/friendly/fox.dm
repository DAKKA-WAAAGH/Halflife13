//Foxxy
/mob/living/simple_animal/pet/fox
	name = "fox"
	desc = "It's a fox."
	icon = 'icons/mob/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("AAAAAAAAAAAAAAAAAAAA","Hehehehehe")
	speak_emote = list("screams","screeches")
	emote_hear = list("yips.","screeches.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1) 
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	attack_vis_effect = ATTACK_EFFECT_BITE
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = TRUE
	footstep_type = FOOTSTEP_MOB_CLAW
	wuv_happy = "screams happily!"
	wuv_angy = "screams angrily!"

//City Administrator fox
/mob/living/simple_animal/pet/fox/Renault
	name = "Renault"
	desc = "Renault, the City Administrator's trustworthy fox."
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
