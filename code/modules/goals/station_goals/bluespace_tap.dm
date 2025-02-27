//Station goal stuff goes here
#define BLUESPACE_TAP_POINT_GOAL 45000 // Yogs
/datum/station_goal/bluespace_tap
	name = "Bluespace Harvester"
	var/goal = BLUESPACE_TAP_POINT_GOAL // Yogs

/datum/station_goal/bluespace_tap/get_report()
	return {"<b>Bluespace Harvester Experiment</b><br>
	Another research station has developed a device called a Bluespace Harvester.
	It reaches through bluespace into other dimensions to shift through them for interesting objects.<br>
	Due to unforseen circumstances the large-scale test of the prototype could not be completed on the original research station. It will instead be carried out on your station.
	Acquire the circuit board, construct the device over a wire knot and feed it enough power to generate [goal] mining points by shift end.
	<br><br>
	Be advised that the device is experimental and might act in slightly unforseen ways if sufficiently powered.
	<br>
	Nanotrasen Science Directorate"}

/datum/station_goal/bluespace_tap/check_completion()
	if(..())
		return TRUE
	var/highscore = 0
	for(var/obj/machinery/power/bluespace_tap/T in GLOB.machines)
		highscore = max(highscore, T.total_points)
	to_chat(world, "<b>Bluespace Harvester Highscore</b>: [highscore >= goal ? "<span class='greenannounce'>": "<span class='boldannounce'>"][highscore]</span>")
	if(highscore >= goal)
		return TRUE
	return FALSE

//needed for the vending part of it
/datum/data/bluespace_tap_product
	var/product_name = "generic"
	var/product_path = null
	var/product_cost = 0	//cost in mining points to generate


/datum/data/bluespace_tap_product/New(name, path, cost)
	product_name = name
	product_path = path
	product_cost = cost

/obj/item/circuitboard/machine/bluespace_tap
	name = "Bluespace Harvester"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/power/bluespace_tap
	req_components = list(
							/obj/item/stock_parts/capacitor/quadratic = 5,//Probably okay, right?
							/obj/item/stack/ore/bluespace_crystal = 5)

/obj/effect/spawner/lootdrop/bluespace_tap
	name = "bluespace harvester reward spawner"
	lootcount = 1

/obj/effect/spawner/lootdrop/bluespace_tap/hat
	name = "exotic hat"
	loot = list(
			/obj/item/clothing/head/collectable/chef,	//same weighing on all of them
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/crown/fancy,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/HoS,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat
	)


/obj/effect/spawner/lootdrop/bluespace_tap/cultural
	name = "cultural artifacts"
	loot = list(
		/obj/item/grenade/clusterbuster/cleaner,
		/obj/item/grenade/clusterbuster/soap,
		/obj/item/toy/katana,
	    /obj/item/sord,
		/obj/item/toy/syndicateballoon,
		/obj/item/lighter/greyscale,
		/obj/item/lighter,
		/obj/item/gun/ballistic/automatic/toy/pistol,
		/obj/item/gun/ballistic/automatic/c20r/toy,
		/obj/item/gun/ballistic/automatic/l6_saw/toy,
		/obj/item/gun/ballistic/shotgun/toy,
		/obj/item/gun/ballistic/shotgun/toy/crossbow,
		/obj/item/melee/dualsaber/toy,
		/obj/machinery/smoke_machine,
		/obj/item/clothing/head/kitty,
		/obj/item/coin/antagtoken,
		/obj/item/clothing/suit/cardborg,
		/obj/item/toy/prize/honk,
		/obj/item/bedsheet/patriot,
		/obj/item/bedsheet/rainbow,
		/obj/item/bedsheet/captain,
		/obj/item/bedsheet/centcom,
		/obj/item/bedsheet/syndie,
		/obj/item/bedsheet/cult,
		/obj/item/bedsheet/wiz,
		/obj/item/clothing/gloves/combat,
	)

/obj/effect/spawner/lootdrop/bluespace_tap/organic
	name = "organic objects"
	loot = list(
		/obj/item/seeds/random,
		/obj/item/storage/pill_bottle/charcoal,
		/obj/item/storage/pill_bottle/mannitol,
		/obj/item/storage/pill_bottle/mutadone,
		/obj/item/dnainjector/telemut,
		/obj/item/dnainjector/chameleonmut,
		/obj/item/dnainjector/dwarf,
		/mob/living/simple_animal/pet/dog/corgi/,
		/mob/living/simple_animal/pet/cat,
		/mob/living/simple_animal/pet/dog/bullterrier,
		/mob/living/simple_animal/pet/penguin,
		/mob/living/simple_animal/parrot,
		/obj/item/slimepotion/slime/sentience,
		/obj/item/clothing/mask/cigarette/cigar/havana,
		/obj/item/stack/sheet/mineral/bananium/five,	//bananas are organic, clearly.
		/obj/item/storage/box/monkeycubes,
		/obj/item/stack/tile/carpet/black/fifty,
		/obj/item/stack/tile/carpet/blue/fifty,
		/obj/item/stack/tile/carpet/cyan/fifty,
		/obj/item/soap/deluxe,
	)

/obj/effect/spawner/lootdrop/bluespace_tap/food
	name = "fancy food"
	lootcount = 3
	loot = list(
		/obj/item/reagent_containers/food/snacks/burger/superbite,
		/obj/item/reagent_containers/food/snacks/monkeycube/goat,
		/obj/item/reagent_containers/food/snacks/scotchegg,
		/obj/item/reagent_containers/food/snacks/pancakes/chocolatechip,
		/obj/item/reagent_containers/food/snacks/carrotfries,
		/obj/item/reagent_containers/food/snacks/chocolatebunny,
		/obj/item/reagent_containers/food/snacks/benedict,
		/obj/item/reagent_containers/food/snacks/cornedbeef,
		/obj/item/reagent_containers/food/snacks/soup/meatball,
		/obj/item/reagent_containers/food/snacks/soup/monkeysdelight,
		/obj/item/reagent_containers/food/snacks/soup/stew,
		/obj/item/reagent_containers/food/snacks/soup/hotchili,
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/burger/fish,
		/obj/item/reagent_containers/food/snacks/cubancarp,
		/obj/item/reagent_containers/food/snacks/fishandchips,
		/obj/item/reagent_containers/food/snacks/pie/meatpie,
		/obj/item/pizzabox,
	)

/obj/effect/spawner/lootdrop/bluespace_tap/mats
	name = "materials"
	lootcount = 70 //average miners should get the total of this
	loot = list(
		/obj/item/stack/ore/iron = 21,
		/obj/item/stack/ore/glass = 21,
		/obj/item/stack/ore/titanium = 6,
		/obj/item/stack/ore/uranium = 6,
		/obj/item/stack/ore/diamond = 4,
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stack/ore/plasma = 9,
		/obj/item/stack/ore/gold = 6,
		/obj/item/stack/ore/silver = 6
	)

/obj/effect/spawner/lootdrop/bluespace_tap/maintenance
	name = "assorted trash"
	loot = list(
		/obj/effect/spawner/lootdrop/maintenance = 8,
		/obj/effect/spawner/lootdrop/maintenance/two = 7,
		/obj/effect/spawner/lootdrop/maintenance/three = 6,
		/obj/effect/spawner/lootdrop/maintenance/four = 5,
		/obj/effect/spawner/lootdrop/maintenance/five = 4,
		/obj/effect/spawner/lootdrop/maintenance/six = 3,
		/obj/effect/spawner/lootdrop/maintenance/seven = 2,
		/obj/effect/spawner/lootdrop/maintenance/eight = 1
	)

#define kW *1000
#define MW kW *1000
#define GW MW *1000

/**
  * # Bluespace Harvester
  *
  * A station goal that consumes enormous amounts of power to generate (mostly fluff) rewards
  *
  * A machine that takes power each tick, generates points based on it
  * and lets you spend those points on rewards. A certain amount of points
  * has to be generated for the station goal to count as completed.
  */
/obj/machinery/power/bluespace_tap
	name = "Bluespace harvester"
	icon = 'icons/obj/machines/bluespace_tap.dmi'
	icon_state = "bluespace_tap"
	base_icon_state = "bluespace_tap"
	max_integrity = 300
	pixel_x = -32	//shamelessly stolen from dna vault
	pixel_y = -32
	/// For faking having a big machine, dummy 'machines' that are hidden inside the large sprite and make certain tiles dense. See new and destroy.
	var/list/obj/structure/fillers = list()
	use_power = NO_POWER_USE	// power usage is handelled manually
	density = TRUE
	luminosity = 1

	/// Correspond to power required for a mining level, first entry for level 1, etc.
	var/list/power_needs = list(1 kW, 5 kW, 50 kW, 100 kW, 500 kW,
								1 MW, 2 MW, 5 MW, 10 MW, 25 MW,
								50 MW, 75 MW, 125 MW, 200 MW, 500 MW,
								1 GW, 5 GW, 15 GW, 45 GW, 500 GW)

	/// list of possible products
	var/static/product_list = list(
	new /datum/data/bluespace_tap_product("Unknown Exotic Hat", /obj/effect/spawner/lootdrop/bluespace_tap/hat, 5000),
	new /datum/data/bluespace_tap_product("Unknown Snack", /obj/effect/spawner/lootdrop/bluespace_tap/food, 6000),
	new /datum/data/bluespace_tap_product("Unknown Refuse", /obj/effect/spawner/lootdrop/bluespace_tap/maintenance, 10000),
	new /datum/data/bluespace_tap_product("Unknown Cultural Artifact", /obj/effect/spawner/lootdrop/bluespace_tap/cultural, 15000),
	new /datum/data/bluespace_tap_product("Unknown Biological Artifact", /obj/effect/spawner/lootdrop/bluespace_tap/organic, 20000),
	new /datum/data/bluespace_tap_product("Unknown Materials", /obj/effect/spawner/lootdrop/bluespace_tap/mats, 30000),
	)

	/// The level the machine is currently mining at. 0 means off
	var/input_level = 0
	/// The machine you WANT the machine to mine at. It will try to match this.
	var/desired_level = 0
	/// Available mining points
	var/points = 0
	/// The total points earned by this machine so far, for tracking station goal and highscore
	var/total_points = 0
	/// How much power the machine needs per processing tick at the current level.
	var/actual_power_usage = 0


	// Tweak these and active_power_usage to balance power generation

	/// Max power input level, I don't expect this to be ever reached
	var/max_level = 20
	/// Amount of points to give per mining level
	var/base_points = 100
	/// How high the machine can be run before it starts having a chance for dimension breaches.
	var/safe_levels = 10
	/// When event triggers this will hold references to all portals so we can fix the sprite after they're broken
	var/list/active_nether_portals = list()
	var/emagged = FALSE

	/// Cooldown to prevent spamming portal spawns without an emag
	COOLDOWN_DECLARE(emergency_shutdown)

/obj/machinery/power/bluespace_tap/New()
	..()
	//more code stolen from dna vault, inculding comment below. Taking bets on that datum being made ever.
	//TODO: Replace this,bsa and gravgen with some big machinery datum
	var/list/occupied = list()
	for(var/direct in list(NORTH, NORTHEAST, NORTHWEST, EAST, WEST, SOUTHEAST, SOUTHWEST))
		occupied += get_step(src, direct)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/bluespace_tap(null)
	for(var/i = 1 to 5)	//five of each
		component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
		component_parts += new /obj/item/stack/ore/bluespace_crystal(null)
	if(!powernet)
		connect_to_network()

/obj/machinery/power/bluespace_tap/update_icon_state()
	. = ..()

	if(length(active_nether_portals))
		icon_state = "redspace_tap"
		return

	if(avail() <= 0)
		icon_state = base_icon_state
	else
		icon_state = "[base_icon_state][get_icon_state_number()]"


/obj/machinery/power/bluespace_tap/update_overlays()
	. = ..()

	underlays.Cut()

	if(length(active_nether_portals))
		. += "redspace"
		. += "redspace_flash"
		set_light(15, 5, "#ff0000")
		return

	if(stat & (BROKEN|NOPOWER))
		set_light(0)
	else
		set_light(1, 1, "#353535")

	if(avail())
		. += "screen"
		if(light)
			underlays += mutable_appearance(icon, "light_mask")


/obj/machinery/power/bluespace_tap/proc/get_icon_state_number()
	switch(input_level)
		if(0)
			return 0
		if(1 to 2)
			return 1
		if(3 to 5)
			return 2
		if(6 to 7)
			return 3
		if(8 to 10)
			return 4
		if(11 to INFINITY)
			return 5

/obj/machinery/power/bluespace_tap/power_change()
	. = ..()
	if(stat & (BROKEN|NOPOWER))
		set_light(0)
	else
		set_light(1, 1, "#353535")


/obj/machinery/power/bluespace_tap/connect_to_network()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/machinery/power/bluespace_tap/disconnect_from_network()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/machinery/power/bluespace_tap/Destroy()
	QDEL_LIST(fillers)
	return ..()

/**
  * Increases the desired mining level
  *
  * Increases the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT increase the actual mining level directly.
  */
/obj/machinery/power/bluespace_tap/proc/increase_level()
	if(!COOLDOWN_FINISHED(src, emergency_shutdown))
		desired_level = 0
		return
	if(desired_level < max_level)
		desired_level++
/**
  * Decreases the desired mining level
  *
  * Decreases the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT decrease the actual mining level directly.
  */
/obj/machinery/power/bluespace_tap/proc/decrease_level()
	if(!COOLDOWN_FINISHED(src, emergency_shutdown))
		desired_level = 0
		return
	if(desired_level > 0)
		desired_level--

/**
  * Sets the desired mining level
  *
  * Sets the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT change the actual mining level directly.
  * Arguments:
  * * t_level - The level we try to set it at, between 0 and max_level
 */
/obj/machinery/power/bluespace_tap/proc/set_level(t_level)
	if(t_level < 0)
		return
	if(t_level > max_level)
		return
	desired_level = t_level

/**
  * Gets the amount of power at a set input level
  *
  * Gets the amount of power (in W) a set input level needs.
  * Note that this is not necessarily the current power use.
  * * i_level - The hypothetical input level for which we want to know the power use.
  */
/obj/machinery/power/bluespace_tap/proc/get_power_use(i_level)
	if(!i_level)
		return 0
	return power_needs[i_level]

/obj/machinery/power/bluespace_tap/process()
	if(avail() && icon_state == "bluespace_tap")
		update_appearance(UPDATE_ICON)
	else if(!avail() && icon_state == "bluespace_tap0")
		update_appearance(UPDATE_ICON)
	actual_power_usage = get_power_use(input_level)
	if(surplus() < actual_power_usage)	//not enough power, so turn down a level
		input_level--
		update_appearance(UPDATE_ICON)
		return	// and no mining gets done
	if(actual_power_usage)
		add_load(actual_power_usage)
		var/points_to_add = (input_level + emagged) * base_points
		points += points_to_add	//point generation, emagging gets you 'free' points at the cost of higher anomaly chance
		total_points += points_to_add
	// actual input level changes slowly
	if(input_level < desired_level && (surplus() >= get_power_use(input_level + 1)))
		input_level++
		update_appearance(UPDATE_ICON)
	else if(input_level > desired_level)
		input_level--
		update_appearance(UPDATE_ICON)
	if(prob(input_level - safe_levels + (emagged * 5)))	//at dangerous levels, start doing freaky shit. prob with values less than 0 treat it as 0
		priority_announce("Unexpected power spike during Bluespace Harvester Operation. Extra-dimensional intruder alert. Expected location: [get_area_name(src)]. [emagged ? "DANGER: Emergency shutdown failed! Please proceed with manual shutdown." : "Emergency shutdown initiated."]", "Bluespace Harvester Malfunction",sound = SSstation.announcer.get_rand_report_sound())
		if(!emagged)
			input_level = 0	//emergency shutdown unless we're sabotaged
			desired_level = 0
		start_nether_portaling(rand(3,5))

/obj/machinery/power/bluespace_tap/proc/start_nether_portaling(amount)
	var/turf/location = locate(x + rand(-5, -2) || rand(2, 5), y + rand(-5, -2) || rand(2, 5), z)
	var/obj/structure/spawner/nether/bluespace_tap/P = new /obj/structure/spawner/nether/bluespace_tap(location)
	amount--
	active_nether_portals += P
	P.linked_source_object = src
	update_appearance(UPDATE_ICON)
	if(amount)
		addtimer(CALLBACK(src, PROC_REF(start_nether_portaling), amount), rand(3,5) SECONDS)



/obj/machinery/power/bluespace_tap/ui_data(mob/user)
	var/list/data = list()

	data["desiredLevel"] = desired_level
	data["inputLevel"] = input_level
	data["points"] = points
	data["totalPoints"] = total_points
	data["powerUse"] = actual_power_usage
	data["availablePower"] = surplus()
	data["maxLevel"] = max_level
	data["emagged"] = emagged
	data["safeLevels"] = safe_levels
	data["nextLevelPower"] = get_power_use(input_level + 1)

	/// A list of lists, each inner list equals a datum
	var/list/listed_items = list()
	for(var/key = 1 to length(product_list))
		var/datum/data/bluespace_tap_product/A = product_list[key]
		listed_items[++listed_items.len] = list(
				"key" = key,
				"name" = A.product_name,
				"price" = A.product_cost)
	data["product"] = listed_items
	return data


/obj/machinery/power/bluespace_tap/attack_hand(mob/user)
	add_fingerprint(user)
	if(length(active_nether_portals))		//this would be cool if we made unique TGUI for this
		to_chat(user, span_warning("UNKNOWN INTERFERENCE ... UNRESPONSIVE"))
		return
	ui_interact(user)

/obj/machinery/power/bluespace_tap/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/power/bluespace_tap/attack_ai(mob/user)
	if(length(active_nether_portals))		//this would be cool if we made unique TGUI for this
		to_chat(user, span_warning("UNKNOWN INTERFERENCE ... UNRESPONSIVE"))
		return
	ui_interact(user)

/**
  * Produces the product with the desired key and increases product cost accordingly
  */
/obj/machinery/power/bluespace_tap/proc/produce(key)
	if(key <= 0 || key > length(product_list))	//invalid key
		return
	var/datum/data/bluespace_tap_product/A = product_list[key]
	if(!A)
		return
	if(A.product_cost > points)
		return
	points -= A.product_cost
	playsound(src, 'sound/magic/blink.ogg', 50)
	flick_overlay_view(image(icon, src, "flash", layer+1), src, 6)
	do_sparks(2, FALSE, src)
	new A.product_path(get_turf(src))



//UI stuff below

/obj/machinery/power/bluespace_tap/ui_act(action, params)
	if(..())
		return
	. = TRUE	// we want to refresh in all the cases below
	switch(action)
		if("decrease")
			decrease_level()
		if("increase")
			increase_level()
		if("set")
			set_level(text2num(params["set_level"]))
		if("vend")//it's not really vending as producing, but eh
			var/key = text2num(params["target"])
			produce(key)

/obj/machinery/power/bluespace_tap/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BluespaceTap", "Bluespace Harvester")
		ui.open()

//emaging provides slightly more points but at much greater risk
/obj/machinery/power/bluespace_tap/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(emagged)
		return FALSE
	emagged = TRUE
	do_sparks(5, FALSE, src)
	if(user)
		user.visible_message(span_warning("[user] overrides the safety protocols of [src]."), span_warning("You override the safety protocols."))
	return TRUE
	
/obj/structure/spawner/nether/bluespace_tap
	spawn_time = 30 SECONDS
	max_mobs = 5		//Dont' want them overrunning the station
	max_integrity = 250
	/// the BSH that spawned this portal
	var/obj/machinery/power/bluespace_tap/linked_source_object

/obj/structure/spawner/nether/bluespace_tap/deconstruct(disassembled)
	new /obj/item/stack/ore/bluespace_crystal(loc)	//have a reward
	return ..()

/obj/structure/spawner/nether/bluespace_tap/Destroy()
	. = ..()
	if(linked_source_object)
		linked_source_object.active_nether_portals -= src
		linked_source_object.update_appearance(UPDATE_ICON)

/obj/item/paper/bluespace_tap
	name = "paper- 'The Experimental NT Bluespace Harvester - Mining other universes for science and profit!'"
	info = "<h1>Important Instructions!</h1>Please follow all setup instructions to ensure proper operation. <br>\
	1. Create a wire node with ample access to spare power. The device operates independently of APCs. <br>\
	2. Create a machine frame as normal on the wire node, taking into account the device's dimensions (3 by 3 meters). <br>\
	3. Insert wiring, circuit board and required components and finish construction according to NT engineering standards. <br>\
	4. Ensure the device is connected to the proper power network and the network contains sufficient power. <br>\
	5. Set machine to desired level. Check periodically on machine progress. <br>\
	6. Optionally, spend earned points on fun and exciting rewards. <br><hr>\
	<h2>Operational Principles</h2> \
	<p>The Bluespace Harvester is capable of accepting a nearly limitless amount of power to search other universes for valuables to recover. The speed of this search is controlled via the 'level' control of the device. \
	While it can be run on a low level by almost any power generation system, higher levels require work by a dedicated engineering team to power. \
	As we are interested in testing how the device performs under stress, we wish to encourage you to stress-test it and see how much power you can provide it. \
	For this reason, total shift point production will be calculated and announced at shift end. High totals may result in bonus payments to members of the Engineering department. <p>\
	<p>NT Science Directorate, Extradimensional Exploitation Research Group</p> \
	<p><small>Device highly experimental. Not for sale. Do not operate near small children or vital NT assets. Do not tamper with machine. In case of existential dread, stop machine immediately. \
	Please document any and all extradimensional incursions. In case of imminent death, please leave said documentation in plain sight for clean-up teams to recover.</small></p>"

#undef kW
#undef MW
#undef GW
