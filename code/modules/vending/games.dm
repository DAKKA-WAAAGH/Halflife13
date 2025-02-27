/obj/machinery/vending/games
	name = "\improper Good Clean Fun"
	desc = "Vends things that the City Administrator and Labor Lead are probably not going to appreciate you fiddling with instead of your job..."
	product_ads = "Escape to a fantasy world!;Fuel your gambling addiction!;Ruin your friendships!;Roll for initiative!;Elves and dwarves!;Paranoid computers!;Totally not satanic!;Fun times forever!"
	icon_state = "games"
	panel_type = "panel4"
	products = list(/obj/item/toy/cards/deck = 5,
					/obj/item/toy/cards/deck/uno = 3,
		            /obj/item/storage/pill_bottle/dice = 10,
		            /obj/item/toy/cards/deck/cas = 3,
		            /obj/item/toy/cards/deck/cas/black = 3,
					/obj/item/toy/cards/deck/wizoff = 3,
					/obj/item/hourglass = 2,
					/obj/item/toy/turn_tracker = 6,
					/obj/item/instrument/musicalmoth = 1,
					/obj/machinery/golfhole = 4,
					/obj/machinery/golfhole/blue = 4,
					/obj/item/golfclub = 4,
					/obj/item/golfball = 8,
					/obj/item/dyespray = 3,
					/obj/item/balloonbox = 3)
	contraband = list(/obj/item/dice/fudge = 9)
	premium = list(/obj/item/melee/skateboard/pro = 3,
					/obj/item/melee/skateboard/hoverboard = 1)
	refill_canister = /obj/item/vending_refill/games
	default_price = 10
	extra_price = 25
	payment_department = ACCOUNT_SRV
	light_mask = "games-light-mask"

/obj/item/vending_refill/games
	machine_name = "\improper Good Clean Fun"
	icon_state = "refill_games"
