/datum/export/stack
	unit_name = "sheet"

/datum/export/stack/get_amount(obj/O)
	var/obj/item/stack/S = O
	if(istype(S))
		return S.amount
	return 0

// Hides

/datum/export/stack/skin/monkey
	cost = 150
	unit_name = "monkey hide"
	export_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/export/stack/skin/human
	cost = 100	//surprisingly easy to get human skin who would have thought
	export_limit = 50
	export_category = EXPORT_CONTRABAND
	unit_name = "piece"
	message = "of human skin"
	export_types = list(/obj/item/stack/sheet/animalhide/human)

/datum/export/stack/skin/goliath_hide
	cost = 2500
	export_limit = 50
	unit_name = "goliath hide"
	export_types = list(/obj/item/stack/sheet/animalhide/goliath_hide)

/datum/export/stack/skin/cat
	cost = 500
	export_limit = 100
	export_category = EXPORT_CONTRABAND
	unit_name = "cat hide"
	export_types = list(/obj/item/stack/sheet/animalhide/cat)

/datum/export/stack/skin/corgi
	cost = 500
	export_limit = 100
	export_category = EXPORT_CONTRABAND
	unit_name = "corgi hide"
	export_types = list(/obj/item/stack/sheet/animalhide/corgi)

/datum/export/stack/skin/lizard
	cost = 2500
	export_limit = 200
	unit_name = "lizard hide"
	export_types = list(/obj/item/stack/sheet/animalhide/lizard)

/datum/export/stack/skin/gondola
	cost = 5000
	unit_name = "gondola hide"
	export_types = list(/obj/item/stack/sheet/animalhide/gondola)

/datum/export/stack/skin/xeno
	cost = 3000
	unit_name = "alien hide"
	export_types = list(/obj/item/stack/sheet/animalhide/xeno)

/datum/export/stack/licenseplate
	cost = 25
	unit_name = "license plate"
	export_types = list(/obj/item/stack/license_plates/filled)

// Common materials.
// For base materials, see materials.dm

/datum/export/stack/plasteel
	cost = 75 // 2000u of plasma + 2000u of metal.
	message = "of plasteel"
	export_types = list(/obj/item/stack/sheet/plasteel)

// 1 glass + 0.5 metal, cost is rounded up.
/datum/export/stack/rglass
	cost = 8
	message = "of reinforced glass"
	export_types = list(/obj/item/stack/sheet/rglass)

/datum/export/stack/bscrystal
	cost = 750
	export_limit = 200
	message = "of bluespace crystals"
	export_types = list(/obj/item/stack/sheet/bluespace_crystal)

/datum/export/stack/wood
	cost = 5
	unit_name = "wood plank"
	export_types = list(/obj/item/stack/sheet/mineral/wood)

/datum/export/stack/cardboard
	cost = 2
	message = "of cardboard"
	export_types = list(/obj/item/stack/sheet/cardboard)

/datum/export/stack/sandstone
	cost = 1
	unit_name = "block"
	message = "of sandstone"
	export_types = list(/obj/item/stack/sheet/mineral/sandstone)

/datum/export/stack/cable
	cost = 0.2
	unit_name = "cable piece"
	export_types = list(/obj/item/stack/cable_coil)

/datum/export/stack/ammonia_crystals
	cost = 25
	unit_name = "of ammonia crystal"
	export_types = list(/obj/item/stack/ammonia_crystals)
