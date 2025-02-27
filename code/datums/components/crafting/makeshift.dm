///////////
// TOOLS //
///////////

/datum/crafting_recipe/makeshiftcrowbar
	name = "Makeshift Crowbar"
	reqs = list(/obj/item/stack/rods = 3) //just bang them together
	result = /obj/item/crowbar/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftwrench
	name = "Makeshift Wrench"
	reqs = list(/obj/item/stack/sheet/metal = 2)
	result = /obj/item/wrench/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftwirecutters
	name = "Makeshift Wirecutters"
	reqs = list(/obj/item/stack/sheet/metal = 2,
				/obj/item/stack/rods = 2)
	result = /obj/item/wirecutters/makeshift
	time = 15 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftweldingtool
	name = "Makeshift Welding Tool"
	reqs = list(/obj/item/tank/internals/emergency_oxygen = 1,
				/obj/item/assembly/igniter = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	result = /obj/item/weldingtool/makeshift
	time = 16 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftscrewdriver
	name = "Makeshift Screwdriver"
	reqs = list(/obj/item/stack/rods = 3)
	result = /obj/item/screwdriver/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshifttoolbelt
	name = "Makeshift Toolbelt"
	reqs = list(/obj/item/stack/rods = 5,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/sheet/cloth = 2)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/storage/belt/utility/makeshift
	time = 20 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshiftknife
	name = "Makeshift Knife"
	reqs = list(/obj/item/stack/rods = 3,
				/obj/item/stack/sheet/metal = 1,
        		/obj/item/stack/tape = 2)
	result = /obj/item/kitchen/knife/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftpickaxe
	name = "Makeshift Pickaxe"
	reqs = list(
           /obj/item/crowbar = 1,
           /obj/item/kitchen/knife = 1,
           /obj/item/stack/tape = 1)
	result = /obj/item/pickaxe/makeshift
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftradio
	name = "Makeshift Radio"	
	reqs = list(/obj/item/assembly/signaler = 1,
        		/obj/item/radio/headset = 1,
				/obj/item/stack/cable_coil = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	result = /obj/item/radio/off/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS
	always_available = FALSE

/datum/crafting_recipe/makeshiftid
	name = "Makeshift ID"
	result = /obj/item/card/id/makeshift
	reqs = list(/obj/item/stack/sheet/cardboard = 2,
				/obj/item/stack/tape = 1,
				/obj/item/pen = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	time = 30
	category = CAT_MISC
