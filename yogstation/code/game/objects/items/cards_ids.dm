/obj/item/card
	icon = 'yogstation/icons/obj/card.dmi'
	var/has_fluff

/obj/item/card/id/update_label(newname, newjob)
	..()
	ID_fluff()

/obj/item/card/id/proc/ID_fluff()
	var/job = originalassignment
	var/static/list/idfluff = list(
		"Assistant" = list("civillian","green"),
		"City Administrator" = list("captain","gold"),
		"Labor Lead" = list("civillian","silver"),
		"Divisional Lead" = list("security","silver"),
		"Chief Engineer" = list("engineering","silver"),
		"Research Director" = list("science","silver"),
		"Chief Medical Officer" = list("medical","silver"),
		"Station Engineer" = list("engineering","yellow"),
		"Atmospheric Technician" = list("engineering","white"),
		"Network Admin" = list("engineering","green"),
		"Medical Doctor" = list("medical","blue"),
		"Geneticist" = list("medical","purple"),
		"Virologist" = list("medical","green"),
		"Chemist" = list("medical","orange"),
		"Paramedic" = list("medical","white"),
		"Psychiatrist" = list("medical","brown"),
		"Scientist" = list("science","purple"),
		"Roboticist" = list("science","black"),
		"Quartermaster" = list("cargo","silver"),
		"Cargo Technician" = list("cargo","brown"),
		"Shaft Miner" = list("cargo","black"),
		"Mining Medic" = list("cargo","blue"),
		"Bartender" = list("civillian","black"),
		"Botanist" = list("civillian","blue"),
		"Cook" = list("civillian","white"),
		"Vortigaunt Slave" = list("civillian","purple"),
		"Curator" = list("civillian","purple"),
		"Chaplain" = list("civillian","black"),
		"Clown" = list("clown","rainbow"),
		"Mime" = list("mime","white"),
		"Artist" = list("civillian","yellow"),
		"Clerk" = list("civillian","blue"),
		"Tourist" = list("civillian","yellow"),
		"Synthetic" = list("",""),
		"Warden" = list("security","black"),
		"Civil Protection Officer" = list("security","red"),
		"Detective" = list("security","brown"),
		"Brig Physician" = list("security","blue"),
		"Lawyer" = list("security","purple"),
	)
	if(job in idfluff)
		has_fluff = TRUE
	else if(!job)
		return
	else
		if(has_fluff)
			return
		else
			job = "Assistant" //Loads up the basic green ID
	overlays.Cut()
	overlays += idfluff[job][1]
	overlays += idfluff[job][2]

/obj/item/card/id/silver
	icon_state = "id_silver"

/obj/item/card/id/gold
	icon_state = "id_gold"

/obj/item/card/id/captains_spare
	icon_state = "id_gold"

/obj/item/card/emag/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(!emag_card)
		return FALSE
	if(istype(emag_card, /obj/item/card/emag/improvised))
		return FALSE
	if(prob(7))
		to_chat(user, span_notice("By some ungodly miracle, the emag gains new functionality instead of being destroyed."))
		playsound(src.loc, "sparks", 50, 1)
		qdel(emag_card)
		color = rgb(40, 130, 255)
		prox_check = FALSE
		return TRUE
	to_chat(user, span_notice("The cyptographic sequencers attempt to override each other before destroying themselves."))
	playsound(src.loc, "sparks", 50, 1)
	qdel(emag_card)
	qdel(src)
	return TRUE

/obj/item/card/id/gasclerk
	name = "Clerk"
	desc = "An employee ID used to access areas around the gas station."
	access = list(ACCESS_CLERK)

/obj/item/card/id/gasclerk/New()
	..()
	registered_account = new("Clerk", FALSE)
