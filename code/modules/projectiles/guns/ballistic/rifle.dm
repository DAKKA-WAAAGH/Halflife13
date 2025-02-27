/obj/item/gun/ballistic/rifle
	name = "Bolt Rifle"
	desc = "Some kind of bolt action rifle. You get the feeling you shouldn't have this."
	icon_state = "moistnugget"
	icon_state = "moistnugget"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = "sound/weapons/rifleshot.ogg"
	fire_sound_volume = 80
	vary_fire_sound = FALSE
	rack_sound = "sound/weapons/mosinboltout.ogg"
	bolt_drop_sound = "sound/weapons/mosinboltin.ogg"
	tac_reloads = FALSE

obj/item/gun/ballistic/rifle/update_overlays()
	. = ..()
	. += "[icon_state]_bolt[bolt_locked ? "_locked" : ""]"

obj/item/gun/ballistic/rifle/rack(mob/user = null)
	if (bolt_locked == FALSE)
		to_chat(user, span_notice("You open the bolt of \the [src]"))
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_appearance(UPDATE_ICON)
		return
	drop_bolt(user)

obj/item/gun/ballistic/rifle/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

obj/item/gun/ballistic/rifle/attackby(obj/item/A, mob/user, params)
	if(internal_magazine && !bolt_locked)
		to_chat(user, span_notice("The bolt is closed!"))
		return
	return ..()

/obj/item/gun/ballistic/rifle/examine(mob/user)
	. = ..()
	. += "The bolt is [bolt_locked ? "open" : "closed"]."

///////////////////////
// BOLT ACTION RIFLE //
///////////////////////

/obj/item/gun/ballistic/rifle/boltaction
	name = "\improper Mosin Nagant"
	desc = "This piece of junk looks like something that could have been used 700 years ago. It feels slightly moist."
	sawn_desc = "An extremely sawn-off Mosin Nagant, popularly known as an \"obrez\". There was probably a reason it wasn't manufactured this short to begin with."
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "moistnugget"
	item_state = "moistnugget"
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	can_bayonet = TRUE
	knife_x_offset = 27
	knife_y_offset = 13
	can_be_sawn_off = TRUE
	weapon_weight = WEAPON_HEAVY

/obj/item/gun/ballistic/rifle/boltaction/sawoff(mob/user)
	. = ..()
	if(.)
		spread = 36
		can_bayonet = FALSE

/obj/item/gun/ballistic/rifle/boltaction/blow_up(mob/user)
	. = 0
	if(chambered && chambered.BB)
		process_fire(user, user, FALSE)
		. = 1

/obj/item/gun/ballistic/rifle/boltaction/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter))
		sawoff(user)
	if(istype(A, /obj/item/melee/transforming/energy))
		var/obj/item/melee/transforming/energy/W = A
		if(W.active)
			sawoff(user)

/obj/item/gun/ballistic/rifle/boltaction/sawoff(mob/user)
	if(bayonet)
		to_chat(user, span_warning("You cannot saw-off \the [src] with \the [bayonet] attached!"))
		return
	. = ..()
	if(.)
		spread = 36
		can_bayonet = FALSE
		weapon_weight = WEAPON_LIGHT

/obj/item/gun/ballistic/rifle/boltaction/blow_up(mob/user)
	. = 0
	if(chambered && chambered.BB)
		process_fire(user, user, FALSE)
		. = 1

/obj/item/gun/ballistic/rifle/boltaction/enchanted
	name = "enchanted bolt action rifle"
	desc = "Careful not to lose your head."
	var/guns_left = 30
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted
	can_be_sawn_off = FALSE

/obj/item/gun/ballistic/rifle/boltaction/enchanted/oneuse
	name = "enchanted bolt action rifle"
	desc = "Careful not to lose your head."
	guns_left = 0
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted
	can_be_sawn_off = FALSE

/obj/item/gun/ballistic/rifle/boltaction/enchanted/arcane_barrage
	name = "arcane barrage"
	desc = "Pew Pew Pew."
	fire_sound = 'sound/weapons/emitter.ogg'
	pin = /obj/item/firing_pin/magic
	icon_state = "arcane_barrage"
	item_state = "arcane_barrage"
	can_bayonet = FALSE
	item_flags = NEEDS_PERMIT | DROPDEL | ABSTRACT | NOBLUDGEON
	flags_1 = NONE

	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage

/obj/item/gun/ballistic/rifle/boltaction/enchanted/vort_blast
	name = "vortal blast"
	desc = "Galunga."
	pin = /obj/item/firing_pin/magic
	guns_left = 0
	icon = 'icons/obj/weapons/hand.dmi'
	fire_sound = "sound/weapons/halflife/attack_charge.ogg"
	icon_state = "mansus"
	item_state = "vort"
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	can_bayonet = FALSE
	item_flags = NEEDS_PERMIT | DROPDEL | ABSTRACT | NOBLUDGEON
	flags_1 = NONE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL

	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted/vort_blast

/obj/item/gun/ballistic/rifle/boltaction/enchanted/dropped()
	. = ..()
	guns_left = 0

/obj/item/gun/ballistic/rifle/boltaction/enchanted/proc/discard_gun(mob/living/user)
	user.throw_item(pick(oview(7,get_turf(user))))

/obj/item/gun/ballistic/rifle/boltaction/enchanted/arcane_barrage/discard_gun(mob/living/user)
	qdel(src)

/obj/item/gun/ballistic/rifle/boltaction/enchanted/vort_blast/discard_gun(mob/living/user)
	qdel(src)

/obj/item/gun/ballistic/rifle/boltaction/enchanted/attack_self()
	return

/obj/item/gun/ballistic/rifle/boltaction/enchanted/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	if(guns_left)
		var/obj/item/gun/ballistic/rifle/boltaction/enchanted/gun = new type
		gun.guns_left = guns_left - 1
		discard_gun(user)
		user.swap_hand()
		user.put_in_hands(gun)
	else
		user.dropItemToGround(src, TRUE)

//////////////////
// SNIPER RIFLE //
//////////////////

/obj/item/gun/ballistic/rifle/sniper_rifle
	name = "\improper anti-materiel sniper rifle"
	desc = "A long ranged weapon that does significant damage. No, you can't quickscope."
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = "sound/weapons/sniper_shot.ogg"
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	rack_sound = "sound/weapons/sniper_rack.ogg"
	recoil = 2
	rack_delay = 1 SECONDS
	weapon_weight = WEAPON_HEAVY
	internal_magazine = FALSE
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	spread = 0
	w_class = WEIGHT_CLASS_NORMAL
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/rifle/sniper_rifle/syndicate
	desc = "An illegally modified .50 BMG sniper rifle with suppression compatibility. Quickscoping still doesn't work."
	can_suppress = TRUE
	can_unsuppress = TRUE
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/rifle/sniper_rifle/ultrasecure
	pin = /obj/item/firing_pin/fucked
