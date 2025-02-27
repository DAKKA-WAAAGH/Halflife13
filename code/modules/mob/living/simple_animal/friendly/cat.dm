//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSCOMPUTER
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2)
	initial_language_holder = /datum/language_holder/felinid
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attack_vis_effect = ATTACK_EFFECT_CLAW
	var/turns_since_scan = 0
	///Whether to draw the sitting sprite instead of the lying down sprite.
	var/sitting = FALSE
	var/mob/living/simple_animal/mouse/movement_target
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"
	can_be_held = TRUE
	footstep_type = FOOTSTEP_MOB_CLAW
	wuv_happy = "purrs!"
	wuv_angy = "hisses!"

/mob/living/simple_animal/pet/cat/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/living/proc/lay_down)


/mob/living/simple_animal/pet/cat/update_mobility()
	..()
	if(client && stat != DEAD && sitting)
		sitting = FALSE
	update_appearance(UPDATE_ICON_STATE)

/mob/living/simple_animal/pet/cat/space
	name = "space cat"
	desc = "It's a cat... in space!"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = "The product of alien DNA and bored geneticists."
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	collar_type = null
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	held_state = "cat2"
	density = FALSE
	pass_flags = PASSMOB
	collar_type = "kitten"
	var/list/pet_kitten_names = list("Fajita", "Pumpkin", "Mischief", "Nugget", "Lemon", "Pickle", "Runt", "Claws", "Paws", "Patches", "Skippy", "Teddy", "Frank", "Quilt", "Lenny", "Benny", "Hubert", "Scrungemuffin", "Pizza", "Fluff", "Cleo", "Eevee", "Mango", "Mayhem", "Cinnamon", "Snickerdoodle", "Spice", "Mocha", "Concrete", "Fish", "Fae", "Mittens", "Blaze", "Snuggles", "Boots", "Goofball", "Tiger")
	var/list/rare_pet_kitten_names = list("Fuckface", "Chief Meowdical Officer", "Catrick", "Mewcular Opurrative", "Meowgaret Thatcher", "Meowria", "Meowchelangelo", "Todd Meoward", "Dolly Purrton", "Dumbass Cat", "Genghis Kat", "Sir Isaac Mewton", "Backup Ian", "Pawl Meowcartney", "Runtime Jr", "Meowchael")

/mob/living/simple_animal/pet/cat/kitten/Initialize(mapload)
	. = ..()
	if(prob(5))
		name = pick(rare_pet_kitten_names)
	else
		name = pick(pet_kitten_names)

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE

/mob/living/simple_animal/pet/cat/Runtime/Initialize(mapload)
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/Runtime/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/Runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/Runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/Runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || !C.butcher_results) //That last one is a work around for hologram cats
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/Runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/update_icon_state()
	. = ..()
	if(stat == DEAD)
		icon_state = "[icon_living]_dead"
		collar_type = "[initial(collar_type)]_dead"
	else if(resting)
		if(sitting)
			icon_state = "[icon_living]_sit"
			collar_type = "[initial(collar_type)]_sit"
		else
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
	else
		icon_state = icon_living
		collar_type = initial(collar_type)

/mob/living/simple_animal/pet/cat/mob_pickup(mob/living/L)
	set_resting(FALSE) // resting cats don't show up properly when held
	update_appearance(UPDATE_ICON_STATE)
	return ..()

/mob/living/simple_animal/pet/cat/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", EMOTE_VISIBLE, pick("stretches out for a belly rub.", "wags its tail.", "lies down."), TRUE)
			sitting = FALSE
			set_resting(TRUE)
			update_appearance(UPDATE_ICON_STATE)
		else if (prob(1))
			emote("me", EMOTE_VISIBLE, pick("sits down.", "crouches on its hind legs.", "looks alert."), TRUE)
			sitting = TRUE
			set_resting(TRUE)
			update_appearance(UPDATE_ICON_STATE)
		else if (prob(1))
			if (resting)
				emote("me", EMOTE_VISIBLE, pick("gets up and meows.", "walks around.", "stops resting."), TRUE)
				set_resting(FALSE)
				update_appearance(UPDATE_ICON_STATE)
			else
				emote("me", EMOTE_VISIBLE, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."), TRUE)
		else if(prob(5))
			emote("meow", EMOTE_AUDIBLE, intentional = TRUE)

	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat && Adjacent(M))
					emote("me", 1, "splats \the [M]!", TRUE)
					M.splat()
					movement_target = null
					stop_automated_movement = 0
					break
			for(var/obj/item/toy/cattoy/T in view(1,src))
				if (T.cooldown < (world.time - 400))
					emote("me", 1, "bats \the [T] around with its paw!", TRUE)
					T.cooldown = world.time

	..()

	make_babies()

	if(!stat && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(snack.stat == DEAD)
						continue // already dead
					if(resting)
						emote("me", EMOTE_VISIBLE, pick("twitches its whiskers.", "crouches on its hind legs.", "looks alert."), TRUE)
						set_resting(FALSE) // get up and eat the mouse!
						update_appearance(UPDATE_ICON_STATE)
						break
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)

/mob/living/simple_animal/pet/cat/cak //I told you I'd do it, Remie
	name = "Keeki"
	desc = "It's a cat made out of cake."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	gender = FEMALE
	harm_intent_damage = 10
	butcher_results = list(/obj/item/organ/brain = 1, /obj/item/organ/heart = 1, /obj/item/reagent_containers/food/snacks/cakeslice/birthday = 3,  \
	/obj/item/reagent_containers/food/snacks/meat/slab = 2)
	response_harm = "takes a bite out of"
	attacked_sound = 'sound/items/eatfood.ogg'
	deathmessage = "loses its false life and collapses!"
	deathsound = "bodyfall"

/mob/living/simple_animal/pet/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/brain/B = locate(/obj/item/organ/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>You are a cak!</span><b> You're a harmless cat/cake hybrid that everyone loves. People can take bites out of you if they're hungry, but you regenerate health \
	so quickly that it generally doesn't matter. You're remarkably resilient to any damage besides this and it's hard for you to really die at all. You should go around and bring happiness and \
	free cake to the station!</b>")
	var/new_name = stripped_input(src, "Enter your name, or press \"Cancel\" to stick with Keeki.", "Name Change")
	if(new_name)
		to_chat(src, span_notice("Your name is now <b>\"new_name\"</b>!"))
		name = new_name

/mob/living/simple_animal/pet/cat/cak/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-8) //Fast life regen
	for(var/obj/item/reagent_containers/food/snacks/donut/D in range(1, src)) //Frosts nearby donuts!
		if(!D.is_frosted)
			D.frost_donut()

/mob/living/simple_animal/pet/cat/cak/attack_hand(mob/living/L, modifiers)
	..()
	if(L.combat_mode && L.reagents && !stat)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment, 0.4)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin, 0.4)
