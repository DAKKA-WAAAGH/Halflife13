/*
Mineral Sheets
	Contains:
		- Sandstone
		- Sandbags
		- Diamond
		- Snow
		- Uranium
		- Plasma
		- Gold
		- Silver
		- Clown
		- Titanium
		- Plastitanium
	Others:
		- Adamantine
		- Mythril
		- Alien Alloy
		- Coal
*/

/obj/item/stack/sheet/mineral/Initialize(mapload)
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)
	. = ..()

/*
 * Sandstone
 */

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("aesthetic volcanic floor tile", /obj/item/stack/tile/basalt, 1, 4, 20), \
	new/datum/stack_recipe("Assistant Statue", /obj/structure/statue/sandstone/assistant, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Breakdown into sand", /obj/item/stack/ore/glass, 1, one_per_turf = 0, on_floor = 1), \
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	item_state = "sheet-sandstone"
	throw_speed = 3
	throw_range = 5
	materials = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	sheettype = "sandstone"
	merge_type = /obj/item/stack/sheet/mineral/sandstone

/obj/item/stack/sheet/mineral/sandstone/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.sandstone_recipes
	. = ..()

/obj/item/stack/sheet/mineral/sandstone/thirty
	amount = 30

/*
 * Sandbags
 */

/obj/item/stack/sheet/mineral/sandbags
	name = "sandbags"
	icon_state = "sandbags"
	singular_name = "sandbag"
	layer = LOW_ITEM_LAYER
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/mineral/sandbags

GLOBAL_LIST_INIT(sandbag_recipes, list ( \
	new/datum/stack_recipe("sandbags", /obj/structure/barricade/sandbags, 1, time = 25, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/sandbags/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.sandbag_recipes
	. = ..()

/obj/item/emptysandbag
	name = "empty sandbag"
	desc = "A bag to be filled with sand."
	icon = 'icons/obj/frame.dmi'
	icon_state = "sandbag"
	w_class = WEIGHT_CLASS_TINY

/obj/item/emptysandbag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/glass/G = W
		to_chat(user, span_notice("You fill the sandbag."))
		var/obj/item/stack/sheet/mineral/sandbags/I = new /obj/item/stack/sheet/mineral/sandbags(drop_location())
		qdel(src)
		if (Adjacent(user) && !issilicon(user))
			user.put_in_hands(I)
		G.use(1)
	else
		return ..()

/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	item_state = "sheet-diamond"
	singular_name = "diamond"
	sheettype = "diamond"
	materials = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/carbon = 30)
	point_value = 50
	merge_type = /obj/item/stack/sheet/mineral/diamond

/obj/item/stack/sheet/mineral/diamond/fifty
	amount = 50

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("AI Core Statue", /obj/structure/statue/diamond/ai2, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("AI Hologram Statue", /obj/structure/statue/diamond/ai1, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("City Administrator Statue", /obj/structure/statue/diamond/captain, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("diamond tile", /obj/item/stack/tile/mineral/diamond, 1, 4, 20),  \
	))

/obj/item/stack/sheet/mineral/diamond/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.diamond_recipes
	. = ..()

/*
 * Uranium
 */
/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	item_state = "sheet-uranium"
	singular_name = "uranium sheet"
	sheettype = "uranium"
	materials = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 20)
	point_value = 35
	merge_type = /obj/item/stack/sheet/mineral/uranium

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("Engineer Statue", /obj/structure/statue/uranium/eng, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Nuke Statue", /obj/structure/statue/uranium/nuke, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("uranium tile", /obj/item/stack/tile/mineral/uranium, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/uranium/fifty
	amount = 50

/obj/item/stack/sheet/mineral/uranium/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.uranium_recipes
	. = ..()

/*
 * Plasma
 */
/obj/item/stack/sheet/mineral/plasma
	name = "solid plasma"
	icon_state = "sheet-plasma"
	item_state = "sheet-plasma"
	singular_name = "plasma sheet"
	sheettype = "plasma"
	resistance_flags = FLAMMABLE
	max_integrity = 100
	materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/plasma = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/plasma

/obj/item/stack/sheet/mineral/plasma/ten
	amount = 10
/obj/item/stack/sheet/mineral/plasma/fifty
	amount = 50

/obj/item/stack/sheet/mineral/plasma/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins licking \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return TOXLOSS//dont you kids know that stuff is toxic?

GLOBAL_LIST_INIT(plasma_recipes, list ( \
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plasma tile", /obj/item/stack/tile/mineral/plasma, 1, 4, 20), \
	new/datum/stack_recipe("Scientist Statue", /obj/structure/statue/plasma/scientist, 5, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/plasma/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.plasma_recipes
	. = ..()

/obj/item/stack/sheet/mineral/plasma/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.is_hot() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Plasma sheets ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma sheets ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.is_hot())
	else
		return ..()

/obj/item/stack/sheet/mineral/plasma/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("plasma=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/plasma/bullet_act(obj/projectile/P)
	. = ..()
	if(!QDELETED(src) && !P.nodamage && ((P.damage_type == BURN)))
		var/turf/T = get_turf(src)
		if(P.firer)
			message_admins("Plasma stack ([amount]) ignited by [ADMIN_LOOKUPFLW(P.firer)] in [ADMIN_VERBOSEJMP(T)]")
			log_game("Plasma stack ([amount]) ignited by [key_name(P.firer)] in [AREACOORD(T)]")
		else
			message_admins("Plasma stack ([amount]) ignited by [P]. No known firer, in [ADMIN_VERBOSEJMP(T)]")
			log_game("Plasma stack ([amount]) ignited by [P] in [AREACOORD(T)]. No known firer.")
		fire_act(2500)

/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon_state = "sheet-gold"
	item_state = "sheet-gold"
	singular_name = "gold bar"
	sheettype = "gold"
	materials = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 20)
	point_value = 30
	merge_type = /obj/item/stack/sheet/mineral/gold

/obj/item/stack/sheet/mineral/gold/fifty
	amount = 50

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("CE Statue", /obj/structure/statue/gold/ce, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("CMO Statue", /obj/structure/statue/gold/cmo, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("gold tile", /obj/item/stack/tile/mineral/gold, 1, 4, 20), \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("HoP Statue", /obj/structure/statue/gold/hop, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("HoS Statue", /obj/structure/statue/gold/hos, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("RD Statue", /obj/structure/statue/gold/rd, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Simple Crown", /obj/item/clothing/head/crown, 5), \
	))

/obj/item/stack/sheet/mineral/gold/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.gold_recipes
	. = ..()

/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon_state = "sheet-silver"
	item_state = "sheet-silver"
	singular_name = "silver bar"
	sheettype = "silver"
	materials = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/silver = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/silver
	tableVariant = /obj/structure/table/optable

/obj/item/stack/sheet/mineral/silver/fifty
	amount = 50

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("Janitor Statue", /obj/structure/statue/silver/janitor, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Med Borg Statue", /obj/structure/statue/silver/medborg, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Med Officer Statue", /obj/structure/statue/silver/md, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("silver tile", /obj/item/stack/tile/mineral/silver, 1, 4, 20), \
	new/datum/stack_recipe("Sec Borg Statue", /obj/structure/statue/silver/secborg, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Sec Officer Statue", /obj/structure/statue/silver/sec, 5, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/silver/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.silver_recipes
	. = ..()

/*
 * Clown
 */
/obj/item/stack/sheet/mineral/bananium
	name = "bananium"
	icon_state = "sheet-bananium"
	item_state = "sheet-bananium"
	singular_name = "bananium sheet"
	sheettype = "bananium"
	materials = list(/datum/material/bananium=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/consumable/banana = 20)
	point_value = 50
	merge_type = /obj/item/stack/sheet/mineral/bananium

/obj/item/stack/sheet/mineral/bananium/fifty
	amount = 50

GLOBAL_LIST_INIT(bananium_recipes, list ( \
	new/datum/stack_recipe("Bananium Chair", /obj/structure/chair/bananium, 2, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("Bananium Table Frame", /obj/structure/table_frame/bananium, 1, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("bananium tile", /obj/item/stack/tile/mineral/bananium, 1, 4, 20), \
	new/datum/stack_recipe("Bananium Window", /obj/structure/window/bananium/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("Clown Statue", /obj/structure/statue/bananium/clown, 5, one_per_turf = 1, on_floor = 1), \
	)) //Yogstation added bananium recipes

/obj/item/stack/sheet/mineral/bananium/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.bananium_recipes
	. = ..()

/obj/item/stack/sheet/mineral/bananium/five
	amount = 5

/*
 * Titanium
 */
/obj/item/stack/sheet/mineral/titanium
	name = "titanium"
	icon_state = "sheet-titanium"
	item_state = "sheet-titanium"
	singular_name = "titanium sheet"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "titanium"
	materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT)
	point_value = 35
	merge_type = /obj/item/stack/sheet/mineral/titanium

/obj/item/stack/sheet/mineral/titanium/fifty
	amount = 50

GLOBAL_LIST_INIT(titanium_recipes, list ( \
	new/datum/stack_recipe("titanium tile", /obj/item/stack/tile/mineral/titanium, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/titanium/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.titanium_recipes
	. = ..()


/*
 * Plastitanium
 */
/obj/item/stack/sheet/mineral/plastitanium
	name = "plastitanium"
	icon_state = "sheet-plastitanium"
	item_state = "sheet-plastitanium"
	singular_name = "plastitanium sheet"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "plastitanium"
	materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT, /datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	point_value = 45
	merge_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/item/stack/sheet/mineral/plastitanium/fifty
	amount = 50

GLOBAL_LIST_INIT(plastitanium_recipes, list ( \
	new/datum/stack_recipe("plastitanium tile", /obj/item/stack/tile/mineral/plastitanium, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/plastitanium/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.plastitanium_recipes
	. = ..()


/*
 * Snow
 */
/obj/item/stack/sheet/mineral/snow
	name = "snow"
	icon_state = "sheet-snow"
	item_state = "sheet-snow"
	singular_name = "snow block"
	force = 1
	throwforce = 2
	grind_results = list(/datum/reagent/consumable/ice = 20)
	merge_type = /obj/item/stack/sheet/mineral/snow

GLOBAL_LIST_INIT(snow_recipes, list ( \
	new/datum/stack_recipe("Snowball", /obj/item/toy/snowball, 1), \
	new/datum/stack_recipe("Snowman", /obj/structure/statue/snow/snowman, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Snow tile", /obj/item/stack/tile/mineral/snow, 1, 4, 20), \
	new/datum/stack_recipe("Snow wall", /turf/closed/wall/mineral/snow, 5, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/snow/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.snow_recipes
	. = ..()

/****************************** Others ****************************/

/*
 * Adamantine
 */
GLOBAL_LIST_INIT(adamantine_recipes, list(
	new /datum/stack_recipe("incomplete servant golem shell", /obj/item/golem_shell/servant, req_amount=1, res_amount=1),
	))

/obj/item/stack/sheet/mineral/adamantine
	name = "adamantine"
	icon_state = "sheet-adamantine"
	item_state = "sheet-adamantine"
	singular_name = "adamantine sheet"
	merge_type = /obj/item/stack/sheet/mineral/adamantine

/obj/item/stack/sheet/mineral/adamantine/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.adamantine_recipes
	. = ..()

/*
 * Mythril
 */
/obj/item/stack/sheet/mineral/mythril
	name = "mythril"
	icon_state = "sheet-mythril"
	item_state = "sheet-mythril"
	singular_name = "mythril sheet"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/mineral/mythril

/*
 * Alien Alloy
 */
/obj/item/stack/sheet/mineral/abductor
	name = "alien alloy"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "sheet-abductor"
	item_state = "sheet-abductor"
	singular_name = "alien alloy sheet"
	sheettype = "abductor"
	merge_type = /obj/item/stack/sheet/mineral/abductor

GLOBAL_LIST_INIT(abductor_recipes, list ( \
	new/datum/stack_recipe("alien airlock assembly", /obj/structure/door_assembly/door_assembly_abductor, 4, time = 20, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien bed", /obj/structure/bed/abductor, 2, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien locker", /obj/structure/closet/abductor, 2, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien table frame", /obj/structure/table_frame/abductor, 1, time = 15, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("alien floor tile", /obj/item/stack/tile/mineral/abductor, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/abductor/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.abductor_recipes
	. = ..()

/*
 * Coal
 */

/obj/item/stack/sheet/mineral/coal
	name = "coal"
	desc = "Someone's gotten on the naughty list."
	icon = 'icons/obj/mining.dmi'
	icon_state = "slag"
	singular_name = "coal lump"
	merge_type = /obj/item/stack/sheet/mineral/coal
	grind_results = list(/datum/reagent/carbon = 20)

/obj/item/stack/sheet/mineral/coal/attackby(obj/item/W, mob/user, params)
	if(W.is_hot() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Coal ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Coal ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.is_hot())
		return TRUE
	else
		return ..()

/obj/item/stack/sheet/mineral/coal/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("co2=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/coal/five
	amount = 5

/obj/item/stack/sheet/mineral/coal/ten
	amount = 10

//Metal Hydrogen
GLOBAL_LIST_INIT(metalhydrogen_recipes, list(
	new /datum/stack_recipe("ancient armor", /obj/item/clothing/suit/armor/elder_atmosian, req_amount = 10, res_amount = 1),
	new /datum/stack_recipe("ancient helmet", /obj/item/clothing/head/helmet/elder_atmosian, req_amount = 5, res_amount = 1),
	new /datum/stack_recipe("metallic hydrogen axe", /obj/item/fireaxe/metal_h2_axe, req_amount = 15, res_amount = 1),
	))

/obj/item/stack/sheet/mineral/metal_hydrogen
	name = "metal hydrogen"
	icon_state = "sheet-metalhydrogen"
	item_state = "sheet-metalhydrogen"
	singular_name = "metal hydrogen sheet"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE
	point_value = 100
	materials = list(/datum/material/metalhydrogen=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/metal_hydrogen

/obj/item/stack/sheet/mineral/metal_hydrogen/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.metalhydrogen_recipes
	. = ..()

/obj/item/stack/sheet/mineral/zaukerite
	name = "zaukerite"
	icon_state = "zaukerite"
	item_state = "sheet-zaukerite"
	singular_name = "zaukerite crystal"
	w_class = WEIGHT_CLASS_NORMAL
	point_value = 120
	materials = list(/datum/material/zaukerite = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/zaukerite
