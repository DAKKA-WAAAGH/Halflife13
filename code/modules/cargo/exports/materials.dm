/datum/export/material
	cost = 5 // Cost per MINERAL_MATERIAL_AMOUNT, which is 2000cm3 as of April 2016.
	message = "cm3 of developer's tears. Please, report this on github"
	var/material_id = null
	export_types = list(
		/obj/item/stack/sheet/mineral, /obj/item/stack/tile/mineral,
		/obj/item/stack/ore, /obj/item/coin)
// Yes, it's a base type containing export_types.
// But it has no material_id, so any applies_to check will return false, and these types reduce amount of copypasta a lot

/datum/export/material/get_amount(obj/O)
	if(!material_id)
		return 0
	if(!isitem(O))
		return 0
	var/obj/item/I = O
	if(!(getmaterialref(material_id) in I.materials))
		return 0

	var/amount = I.materials[getmaterialref(material_id)]

	if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		amount *= S.amount
		if(istype(I, /obj/item/stack/ore))
			amount *= 0.8 // Station's ore redemption equipment is really goddamn good.

	return round(amount/MINERAL_MATERIAL_AMOUNT)

/datum/export/material/diamond
	cost = 200
	export_limit = 150 //150k
	material_id = /datum/material/diamond
	message = "cm3 of diamonds"

/datum/export/material/uranium
	cost = 100
	export_limit = 300 //120k
	material_id = /datum/material/uranium
	message = "cm3 of uranium"

/datum/export/material/gold
	cost = 150
	export_limit = 500 //125k
	material_id = /datum/material/gold
	message = "cm3 of gold"

/datum/export/material/silver
	cost = 75
	export_limit = 500 //50k
	material_id = /datum/material/silver
	message = "cm3 of silver"

/datum/export/material/titanium
	cost = 75
	export_limit = 500 //62.5k
	material_id = /datum/material/titanium
	message = "cm3 of titanium"

/datum/export/material/plastitanium
	cost = 100 // plasma + titanium costs, no export limit bc plasma :^
	material_id = /datum/material/titanium // code can only check for one material_id; plastitanium is half plasma, half titanium
	message = "cm3 of plastitanium"

/datum/export/material/metal
	cost = 5
	message = "cm3 of metal"
	material_id = /datum/material/iron
	export_types = list(
		/obj/item/stack/sheet/metal, /obj/item/stack/tile/plasteel,
		/obj/item/stack/rods, /obj/item/stack/ore, /obj/item/coin)

/datum/export/material/glass
	cost = 5
	message = "cm3 of glass"
	material_id = /datum/material/glass
	export_types = list(/obj/item/stack/sheet/glass, /obj/item/stack/ore,
		/obj/item/shard)

/datum/export/material/hot_ice
	cost = 400
	export_limit = 500 // 200k
	message = "cm3 of Hot Ice"
	material_id = /datum/material/hot_ice
	export_types = list(/obj/item/stack/sheet/hot_ice)

/datum/export/material/metal_hydrogen
	cost = 550
	export_limit = 1000 //500k
	unit_name = "of metallic hydrogen"
	material_id = /datum/material/metalhydrogen
	export_types = list(/obj/item/stack/sheet/mineral/metal_hydrogen)

/datum/export/material/zaukerite
	cost = 900
	export_limit = 1000 //900k if you somehow get that much which I don't doubt
	material_id = /datum/material/zaukerite
	export_types = list(/obj/item/stack/sheet/mineral/zaukerite)
