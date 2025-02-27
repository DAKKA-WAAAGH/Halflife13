#define VENDING_WEAPON "Weapons" // such as kinetic accelerators and crushers
#define VENDING_UPGRADE "Kinetic Accelerator Upgrades" //KA mods
#define VENDING_TOOL "Tools" //items that miners can actively use
#define VENDING_MINEBOT "Minebot"
#define VENDING_MECHA "Mecha Equipment" //for free miners
#define VENDING_EQUIPMENT "Equipment" // equipment/clothing that miners can wear
#define VENDING_MEDS "Medicial Items"
#define VENDING_MISC "Miscellaneous" // other

/**********************Mining Equipment Vendor**************************/

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor
	var/icon_deny = "mining-deny"
	var/list/prize_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		new /datum/data/mining_equipment("Kinetic Accelerator",			/obj/item/gun/energy/kinetic_accelerator,							750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Kinetic Crusher",				/obj/item/kinetic_crusher,											750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Resonator",					/obj/item/resonator,												800, VENDING_WEAPON),
		new /datum/data/mining_equipment("Super Resonator",				/obj/item/resonator/upgraded,										2500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,											1000, VENDING_WEAPON),
		new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,											2000, VENDING_WEAPON),
		new /datum/data/mining_equipment("Mini Plasma Cutter",			/obj/item/gun/energy/plasmacutter/mini,								2500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Plasma Cutter Shotgun",		/obj/item/gun/energy/plasmacutter/scatter,							5000, VENDING_WEAPON),
		new /datum/data/mining_equipment("PC Defuser Upgrade",			/obj/item/borg/upgrade/plasmacutter/defuser,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Capacity Upgrade",			/obj/item/borg/upgrade/plasmacutter/capacity,							4500, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Cooldown Upgrade",			/obj/item/borg/upgrade/plasmacutter/cooldown,							5000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Range Upgrade",			/obj/item/borg/upgrade/plasmacutter/range,								5000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Ore Upgrade",				/obj/item/borg/upgrade/plasmacutter/ore,									10000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Minebot Passthrough",		/obj/item/borg/upgrade/modkit/minebot_passthrough,					100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,								100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,					150, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,							250, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Hardness Increase",		/obj/item/borg/upgrade/modkit/hardness,								1200, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,								2000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,											400, VENDING_TOOL),
		new /datum/data/mining_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,									3000, VENDING_TOOL),
		new /datum/data/mining_equipment("Luxury Elite Bar Capsule",	/obj/item/survivalcapsule/luxuryelite,								20000, VENDING_TOOL),
		new /datum/data/mining_equipment("Advanced Scanner",			/obj/item/t_scanner/adv_mining_scanner,								800, VENDING_TOOL),
		new /datum/data/mining_equipment("Fulton Pack",					/obj/item/extraction_pack,											1000, VENDING_TOOL),
		new /datum/data/mining_equipment("Fulton Beacon",				/obj/item/fulton_core,												400, VENDING_TOOL),
		new /datum/data/mining_equipment("Jaunter",						/obj/item/wormhole_jaunter,											750, VENDING_TOOL),
		new /datum/data/mining_equipment("Stabilizing Serum",			/obj/item/hivelordstabilizer,										400, VENDING_TOOL),
		new /datum/data/mining_equipment("Lazarus Injector",			/obj/item/lazarus_injector,											1000, VENDING_TOOL),
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10, VENDING_TOOL),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100, VENDING_TOOL),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300, VENDING_TOOL),
		new /datum/data/mining_equipment("Nanotrasen Minebot",			/mob/living/simple_animal/hostile/mining_drone,						800, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Melee Upgrade",		/obj/item/mine_bot_upgrade,											400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Armor Upgrade",		/obj/item/mine_bot_upgrade/health,									400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Cooldown Upgrade",	/obj/item/borg/upgrade/modkit/cooldown/minebot,						600, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot AI Upgrade",			/obj/item/slimepotion/slime/sentience/mining,						1000, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Pocket Fire Extinguisher",		/obj/item/extinguisher/mini,									50, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Lesser Mining Charge",		/obj/item/grenade/plastic/miningcharge/lesser,						300, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Gem Satchel",					/obj/item/storage/bag/gem,											150, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Explorer's Webbing",			/obj/item/storage/belt/mining,										500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Mining Conscription Kit",		/obj/item/storage/backpack/duffelbag/mining_conscript,				1000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("GAR Meson Scanners",			/obj/item/clothing/glasses/meson/gar,								500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Meson Health Scanner HUD",	/obj/item/clothing/glasses/hud/health/meson,						1000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										2500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jump Boots Implants",			/obj/item/storage/box/jumpbootimplant,								5000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Mining Hardsuit",				/obj/item/clothing/suit/space/hardsuit/mining,						2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jetpack Upgrade",				/obj/item/tank/jetpack/suit,										2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Environment Proof Bodybag", 	/obj/item/bodybag/environmental, 									1000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/autoinjector/medipen/survival,			500, VENDING_MEDS),
		new /datum/data/mining_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Tracking Implant Kit", 		/obj/item/storage/box/minertracker,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Point Transfer Card (500)",	/obj/item/card/mining_point_card,									500, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (1000)", 	/obj/item/card/mining_point_card/thousand,							1000, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (5000)", 	/obj/item/card/mining_point_card/fivethousand,						5000, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (10000)",	/obj/item/card/mining_point_card/tenthousand,						10000, VENDING_MISC),
		new /datum/data/mining_equipment("Alien Toy",					/obj/item/clothing/mask/facehugger/toy,								300, VENDING_MISC),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100, VENDING_MISC),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100, VENDING_MISC),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/cigarette/cigar/havana,						150, VENDING_MISC),
		new /datum/data/mining_equipment("Soap",						/obj/item/soap/nanotrasen,											200, VENDING_MISC),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/laser_pointer,											300, VENDING_MISC),
		new /datum/data/mining_equipment("Space Cash",					/obj/item/stack/spacecash/c1000,									2000, VENDING_MISC),
		new /datum/data/mining_equipment("Giga Drill",					/obj/vehicle/ridden/gigadrill,										50000, VENDING_MISC)
	)


/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0
	var/category

/datum/data/mining_equipment/New(name, path, pcost, cat)
	equipment_name = name
	equipment_path = path
	cost = pcost
	category = cat

/obj/machinery/mineral/equipment_vendor/Initialize(mapload)
	. = ..()
	build_inventory()

/obj/machinery/mineral/equipment_vendor/proc/build_inventory()
	for(var/p in prize_list)
		var/datum/data/mining_equipment/M = p
		GLOB.vending_products[M.equipment_path] = 1

/obj/machinery/mineral/equipment_vendor/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"


/obj/machinery/mineral/equipment_vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/mineral/equipment_vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/datum/asset/assets = get_asset_datum(/datum/asset/spritesheet/vending)
		assets.send(user)
		ui = new(user, src, "MiningVendor", name)
		ui.open()

/obj/machinery/mineral/equipment_vendor/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/mining_equipment/prize in prize_list)
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			price = prize.cost,
			ref = REF(prize)
		)
		.["product_records"] += list(product_data)

/obj/machinery/mineral/equipment_vendor/ui_data(mob/user)
	. = list()
	var/mob/living/carbon/human/H
	var/obj/item/card/id/C
	if(ishuman(user))
		H = user
		C = H.get_idcard(TRUE)
		if(C)
			.["user"] = list()
			.["user"]["points"] = C.mining_points
			if(C.registered_account)
				.["user"]["name"] = C.registered_account.account_holder
				if(C.registered_account.account_job)
					.["user"]["job"] = C.registered_account.account_job.title
				else
					.["user"]["job"] = "No Job"

/obj/machinery/mineral/equipment_vendor/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("purchase")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_idcard(TRUE)
			if(!istype(I))
				to_chat(usr, span_alert("Error: An ID is required!"))
				flick(icon_deny, src)
				return
			var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, span_alert("Error: Invalid choice!"))
				flick(icon_deny, src)
				return
			if(prize.cost > I.mining_points)
				to_chat(usr, span_alert("Error: Insufficient points for [prize.equipment_name] on [I]!"))
				flick(icon_deny, src)
				return
			I.mining_points -= prize.cost
			to_chat(usr, span_notice("[src] clanks to life briefly before vending [prize.equipment_name]!"))
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_voucher))
		RedeemVoucher(I, user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/mineral/equipment_vendor/proc/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list(
		"Explorer's Kit" = image(icon = 'icons/obj/clothing/belts.dmi', icon_state = "explorer1"),
		"Resonator Kit" = image(icon = 'icons/obj/mining.dmi', icon_state = "resonator"),
		"Minebot Kit" = image(icon = 'icons/mob/aibots.dmi', icon_state = "mining_drone"),
		"Extraction and Rescue Kit" = image(icon = 'icons/obj/fulton.dmi', icon_state = "extraction_pack"),
		"Crusher Kit" = image(icon = 'icons/obj/mining.dmi', icon_state = "mining_hammer0"),
		"Mining Conscription Kit" = image(icon = 'icons/obj/storage.dmi', icon_state = "duffel"),
		"Mini Plasma Cutter Kit" = image(icon = 'icons/obj/guns/energy.dmi', icon_state="plasmacutter_mini"),

	)

	items = sortList(items)
	var/selection = show_radial_menu(redeemer, src, items, custom_check = CALLBACK(src, PROC_REF(check_menu), voucher, redeemer), radius = 38, require_near = TRUE, tooltips = TRUE)
	if(!selection)
		return

	var/drop_location = drop_location()
	switch(selection)
		if("Explorer's Kit")
			new /obj/item/storage/belt/mining/vendor(drop_location)
		if("Resonator Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/resonator(drop_location)
		if("Minebot Kit")
			new /mob/living/simple_animal/hostile/mining_drone(drop_location)
			new /obj/item/weldingtool/hugetank(drop_location)
			new /obj/item/clothing/head/welding(drop_location)
			new /obj/item/borg/upgrade/modkit/minebot_passthrough(drop_location)
		if("Extraction and Rescue Kit")
			new /obj/item/extraction_pack(drop_location)
			new /obj/item/fulton_core(drop_location)
			new /obj/item/stack/marker_beacon/thirty(drop_location)
		if("Crusher Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/kinetic_crusher(drop_location)
		if("Mining Conscription Kit")
			new /obj/item/storage/backpack/duffelbag/mining_conscript(drop_location)
		if("Mini Plasma Cutter Kit")
			new /obj/item/gun/energy/plasmacutter/mini(drop_location)

	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)

  /*
   check_menu: Checks if we are allowed to interact with a radial menu

   Arguments:
   redeemer The mob interacting with a menu
   voucher The mining voucher item
   */
/obj/machinery/mineral/equipment_vendor/proc/check_menu(obj/item/mining_voucher/voucher, mob/living/redeemer)
	if(!Adjacent(redeemer))
		return FALSE
	if(QDELETED(voucher))
		return FALSE
	if(voucher.loc != redeemer)
		return FALSE
	return TRUE

/obj/machinery/mineral/equipment_vendor/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(prob(50 / severity) && severity < 3)
		qdel(src)

/****************Golem Point Vendor**************************/

/obj/machinery/mineral/equipment_vendor/golem
	name = "golem ship equipment vendor"
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor/golem

/obj/machinery/mineral/equipment_vendor/golem/Initialize(mapload)
	desc += "\nIt seems a few selections have been added."
	prize_list += list(
		new /datum/data/mining_equipment("Brute Pill Bottle",			/obj/item/storage/pill_bottle/libi,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Burn Pill Bottle",			/obj/item/storage/pill_bottle/aiur,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Toxin Pill Bottle",			/obj/item/storage/pill_bottle/charcoal,								600, VENDING_MEDS),
		new /datum/data/mining_equipment("KA Trigger Guard Kit",    	/obj/item/borg/upgrade/modkit/trigger_guard,					1700, VENDING_UPGRADE),
		new /datum/data/mining_equipment("Extra ID",       				/obj/item/card/id/mining, 				                   		250, VENDING_MISC),
		new /datum/data/mining_equipment("Monkey Cube",					/obj/item/reagent_containers/food/snacks/monkeycube,        	300, VENDING_MISC),
		new /datum/data/mining_equipment("Grey Slime Extract",			/obj/item/slime_extract/grey,									1000, VENDING_MISC),
		new /datum/data/mining_equipment("Pocket Fire Extinguisher",		/obj/item/extinguisher/mini,									50, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Science Goggles",       		/obj/item/clothing/glasses/science,								250, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Toolbelt",					/obj/item/storage/belt/utility,	    							350, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Random Poster",				/obj/item/poster/random_official,								200, VENDING_MISC),
		new /datum/data/mining_equipment("Royal Cape of the Liberator", /obj/item/bedsheet/rd/royal_cape, 								500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("The Liberator's Legacy",  	/obj/item/storage/box/rndboards,								2000, VENDING_TOOL)
		)
	return ..()

/****************Free Miner Vendor**************************/

/obj/machinery/mineral/equipment_vendor/free_miner
	name = "free miner ship equipment vendor"
	desc = "A vendor sold by Nanotrasen to profit off small mining contractors."
	prize_list = list(
		new /datum/data/mining_equipment("Kinetic Accelerator", 		/obj/item/gun/energy/kinetic_accelerator,						750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Resonator",          			/obj/item/resonator,											800, VENDING_WEAPON),
		new /datum/data/mining_equipment("Super Resonator",     		/obj/item/resonator/upgraded,									2000, VENDING_WEAPON),
		new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,										750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,										1500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Mini Plasma Cutter",			/obj/item/gun/energy/plasmacutter/mini,							500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Plasma Cutter" ,				/obj/item/gun/energy/plasmacutter,								2500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Plasma Cutter Shotgun",		/obj/item/gun/energy/plasmacutter/scatter,						5000, VENDING_WEAPON),
		new /datum/data/mining_equipment("PC Defuser Upgrade",			/obj/item/borg/upgrade/plasmacutter/defuser,							1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Capacity Upgrade",			/obj/item/borg/upgrade/plasmacutter/capacity,						4500, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Cooldown Upgrade",			/obj/item/borg/upgrade/plasmacutter/cooldown,						5000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Range Upgrade",			/obj/item/borg/upgrade/plasmacutter/range,							5000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("PC Ore Upgrade",				/obj/item/borg/upgrade/plasmacutter/ore,									10000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Minebot Passthrough",		/obj/item/borg/upgrade/modkit/minebot_passthrough,				100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,							100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,				150, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,						250, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,				300, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,							1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,							1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,							1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,							2000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,										400, VENDING_TOOL),
		new /datum/data/mining_equipment("Advanced Scanner",			/obj/item/t_scanner/adv_mining_scanner,							800, VENDING_TOOL),
		new /datum/data/mining_equipment("Hivelord Stabilizer",			/obj/item/hivelordstabilizer,									400, VENDING_TOOL),
		new /datum/data/mining_equipment("Lazarus Injector",    		/obj/item/lazarus_injector,										800, VENDING_TOOL),
		new /datum/data/mining_equipment("Minebot",						/mob/living/simple_animal/hostile/mining_drone,					800, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Melee Upgrade",		/obj/item/mine_bot_upgrade,										400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Armor Upgrade",		/obj/item/mine_bot_upgrade/health,								400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Cooldown Upgrade",	/obj/item/borg/upgrade/modkit/cooldown/minebot,					600, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot AI Upgrade",			/obj/item/slimepotion/slime/sentience/mining,					1000, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Mecha Plasma Generator",		/obj/item/mecha_parts/mecha_equipment/generator,				1500, VENDING_MECHA),
		new /datum/data/mining_equipment("Diamond Mecha Drill",			/obj/item/mecha_parts/mecha_equipment/drill/diamonddrill,		2000, VENDING_MECHA),
		new /datum/data/mining_equipment("Mecha Plasma Cutter",			/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma,		3000, VENDING_MECHA),
		new /datum/data/mining_equipment("Pocket Fire Extinguisher",		/obj/item/extinguisher/mini,									50, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Lesser Mining Charge",		/obj/item/grenade/plastic/miningcharge/lesser,					300, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Gem Satchel",					/obj/item/storage/bag/gem,										150, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("GAR Meson Scanners",			/obj/item/clothing/glasses/meson/gar,							500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Mining Hardsuit",				/obj/item/clothing/suit/space/hardsuit/mining,					2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jetpack Upgrade",				/obj/item/tank/jetpack/suit,									2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/autoinjector/medipen/survival,		500, VENDING_MEDS),
		new /datum/data/mining_equipment("Stimpack",					/obj/item/reagent_containers/autoinjector/medipen/stimpack,		50, VENDING_MEDS),
		new /datum/data/mining_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,								600, VENDING_MEDS),
		new /datum/data/mining_equipment("Fire First-Aid Kit",			/obj/item/storage/firstaid/fire,								600, VENDING_MEDS),
		new /datum/data/mining_equipment("Toxin First-Aid Kit",			/obj/item/storage/firstaid/toxin,								600, VENDING_MEDS),
		new /datum/data/mining_equipment("Stimpack Bundle",				/obj/item/storage/box/medipens/utility,							200, VENDING_MEDS),
		new /datum/data/mining_equipment("Point Transfer Card (500)", 	/obj/item/card/mining_point_card,								500, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (1000)", 	/obj/item/card/mining_point_card/thousand,						1000, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (5000)", 	/obj/item/card/mining_point_card/fivethousand,					5000, VENDING_MISC),
		new /datum/data/mining_equipment("Point Transfer Card (10000)",	/obj/item/card/mining_point_card/tenthousand,					10000, VENDING_MISC),
		new /datum/data/mining_equipment("Space Cash",    				/obj/item/stack/spacecash/c1000,								2000, VENDING_MISC),
		new /datum/data/mining_equipment("R&D Starter Kit",  			/obj/item/storage/box/rndboards/miner,							2500, VENDING_TOOL)
		)

/obj/machinery/mineral/equipment_vendor/free_miner/New()
	..()
	var/obj/item/circuitboard/machine/B = new /obj/item/circuitboard/machine/mining_equipment_vendor/free_miner(null)
	B.apply_default_parts(src)

/obj/machinery/mineral/equipment_vendor/free_miner/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list(
		"Kinetic Accelerator" = image(icon = 'icons/obj/guns/energy.dmi', icon_state = "kineticgun"),
		"Resonator Kit" = image(icon = 'icons/obj/mining.dmi', icon_state = "resonator"),
		"Minebot Kit" = image(icon = 'icons/mob/aibots.dmi', icon_state = "mining_drone"),
		"Crusher Kit" = image(icon = 'icons/obj/mining.dmi', icon_state = "mining_hammer0"),
		"Advanced Scanner" = image(icon = 'icons/obj/device.dmi', icon_state = "adv_mining0")
		)

	items = sortList(items)
	var/selection = show_radial_menu(redeemer, src, items, custom_check = CALLBACK(src, PROC_REF(check_menu), voucher, redeemer), radius = 38, require_near = TRUE, tooltips = TRUE)
	if(!selection)
		return

	var/drop_location = drop_location()
	switch(selection)
		if("Kinetic Accelerator")
			new /obj/item/gun/energy/kinetic_accelerator(drop_location)
		if("Resonator Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/resonator(drop_location)
		if("Minebot Kit")
			new /mob/living/simple_animal/hostile/mining_drone(drop_location)
			new /obj/item/weldingtool/hugetank(drop_location)
			new /obj/item/clothing/head/welding(drop_location)
			new /obj/item/borg/upgrade/modkit/minebot_passthrough(drop_location)
		if("Crusher Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/kinetic_crusher(drop_location)
		if("Advanced Scanner")
			new /obj/item/t_scanner/adv_mining_scanner(drop_location)


	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)

/obj/item/circuitboard/machine/mining_equipment_vendor/free_miner
	name = "circuit board (Free Miner Ship Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor/free_miner

/**********************Mining Equipment Vendor Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data_1"
	var/points = 500

/obj/item/card/mining_point_card/thousand
	points = 1000

/obj/item/card/mining_point_card/fivethousand
	points = 5000

/obj/item/card/mining_point_card/tenthousand
	points = 10000

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, span_info("You transfer [points] points to [C]."))
			points = 0
		else
			to_chat(user, span_info("There's no points left on [src]."))
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	. = ..()
	. += "There's [points] point\s on the card."

///Conscript kit
/obj/item/card/mining_access_card
	name = "mining access card"
	desc = "A small card, that when used on any ID, will add mining access."
	icon_state = "data_1"

/obj/item/card/mining_access_card/afterattack(atom/movable/AM, mob/user, proximity)
	. = ..()
	if(istype(AM, /obj/item/card/id) && proximity)
		var/obj/item/card/id/I = AM
		I.access |=	ACCESS_MINING
		I.access |= ACCESS_MINING_STATION
		I.access |= ACCESS_MECH_MINING
		I.access |= ACCESS_CARGO
		I.access |= ACCESS_CARGO
		to_chat(user, "You upgrade [I] with mining access.")
		qdel(src)

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "mining conscription kit"
	desc = "A kit containing everything a crewmember needs to support a shaft miner in the field."

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/pickaxe/mini(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/storage/bag/gem(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/mining_access_card(src)
	new /obj/item/clothing/neck/bodycam/miner(src)

//jumpboot implant box
/obj/item/storage/box/jumpbootimplant
	name = "box of jumpboot implants"
	desc = "A box holding a set of jumpboot implants. They will require surgical implantation to function."
	illustration = "implant"

/obj/item/storage/box/jumpbootimplant/PopulateContents()
	new /obj/item/organ/cyberimp/leg/jumpboots(src)
	new /obj/item/organ/cyberimp/leg/jumpboots/l(src)

#undef VENDING_WEAPON
#undef VENDING_UPGRADE
#undef VENDING_TOOL
#undef VENDING_MINEBOT
#undef VENDING_MECHA
#undef VENDING_EQUIPMENT
#undef VENDING_MEDS
#undef VENDING_MISC
