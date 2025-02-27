/datum/chemical_reaction/reagent_explosion
	name = "Generic explosive"
	id = "reagent_explosion"
	var/strengthdiv = 10
	var/modifier = 0

/datum/chemical_reaction/reagent_explosion/on_reaction(datum/reagents/holder, created_volume)
	explode(holder, created_volume)

/datum/chemical_reaction/reagent_explosion/proc/explode(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/inside_msg
	if(ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		inside_msg = " inside [ADMIN_LOOKUPFLW(M)]"
	var/lastkey = holder.my_atom.fingerprintslast
	var/touch_msg = "N/A"
	if(lastkey)
		var/mob/toucher = get_mob_by_key(lastkey)
		touch_msg = "[ADMIN_LOOKUPFLW(toucher)]"
	message_admins("Reagent explosion reaction occurred at [ADMIN_VERBOSEJMP(T)][inside_msg]. Last Fingerprint: [touch_msg].")
	log_game("Reagent explosion reaction occurred at [AREACOORD(T)]. Last Fingerprint: [lastkey ? lastkey : "N/A"]." )
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(modifier + round(created_volume/strengthdiv, 1), T, 0, 0)
	e.start()
	if(!ismob(holder.my_atom))
		holder.clear_reagents()


/datum/chemical_reaction/reagent_explosion/nitroglycerin
	name = "Nitroglycerin"
	id = /datum/reagent/nitroglycerin
	results = list(/datum/reagent/nitroglycerin = 2)
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/toxin/acid/fluacid = 1, /datum/reagent/toxin/acid = 1)
	strengthdiv = 2
	mob_react = FALSE

/datum/chemical_reaction/reagent_explosion/nitroglycerin/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/nitroglycerin, created_volume*2)
	..()

/datum/chemical_reaction/reagent_explosion/nitroglycerin_explosion
	name = "Nitroglycerin explosion"
	id = "nitroglycerin_explosion"
	required_reagents = list(/datum/reagent/nitroglycerin = 1)
	required_temp = 474
	strengthdiv = 2
	mob_react = FALSE


/datum/chemical_reaction/reagent_explosion/potassium_explosion
	name = "Explosion"
	id = "potassium_explosion"
	var/size_cap = 50
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	strengthdiv = 10

/datum/chemical_reaction/reagent_explosion/potassium_explosion/on_reaction(datum/reagents/holder, created_volume)
	created_volume = min(created_volume, size_cap)
	..()

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom
	name = "Holy Explosion"
	id = "holyboom"
	size_cap = 100
	required_reagents = list(/datum/reagent/water/holywater = 1, /datum/reagent/potassium = 1)

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom/on_reaction(datum/reagents/holder, created_volume)
	if(created_volume >= 100)
		playsound(get_turf(holder.my_atom), 'sound/effects/pray.ogg', 80, 0, round(created_volume/20))
		strengthdiv = 8
		for(var/mob/living/simple_animal/revenant/R in get_hearers_in_view(7,get_turf(holder.my_atom)))
			var/deity
			if(GLOB.deity)
				deity = GLOB.deity
			else
				deity = "Christ"
			to_chat(R, span_userdanger("The power of [deity] compels you!"))
			R.stun(20)
			R.reveal(100)
			R.adjustHealth(50)
		addtimer(CALLBACK(src, PROC_REF(divine_explosion), round(created_volume/48,1),get_turf(holder.my_atom)), 2 SECONDS)
	..()

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom/proc/divine_explosion(size, turf/T)
	for(var/mob/living/carbon/C in get_hearers_in_view(size,T))
		if(iscultist(C))
			to_chat(C, span_userdanger("The divine explosion sears you!"))
			C.Paralyze(40)
			C.adjust_fire_stacks(5)
			C.ignite_mob()

/datum/chemical_reaction/blackpowder
	name = "Black Powder"
	id = /datum/reagent/blackpowder
	results = list(/datum/reagent/blackpowder = 3)
	required_reagents = list(/datum/reagent/saltpetre = 1, /datum/reagent/medicine/charcoal = 1, /datum/reagent/sulphur = 1)

/datum/chemical_reaction/reagent_explosion/blackpowder_explosion
	name = "Black Powder Kaboom"
	id = "blackpowder_explosion"
	required_reagents = list(/datum/reagent/blackpowder = 1)
	required_temp = 737		//Yogs change - 464 C, actual ignition temp
	strengthdiv = 12
	modifier = 5

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = /datum/reagent/thermite
	results = list(/datum/reagent/thermite = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/gas/oxygen = 1)

/*
/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense

/datum/chemical_reaction/emp_pulse/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 8 severity & 14 range. 4 tiles larger than traitor EMP grenades.
	// 200 created volume = 16 (capped to 10) severity & 28 range. 12 tiles larger than traitor EMP grenades. This is the maximum
	created_volume = min(created_volume, 200)
	empulse(location, min(round(created_volume / 12), EMP_HEAVY), round(created_volume / 7), 1)
	holder.clear_reagents()
*/

/datum/chemical_reaction/beesplosion
	name = "Bee Explosion"
	id = "beesplosion"
	required_reagents = list(/datum/reagent/consumable/honey = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/uranium/radium = 1)

/datum/chemical_reaction/beesplosion/on_reaction(datum/reagents/holder, created_volume)
	var/location = holder.my_atom.drop_location()
	if(created_volume < 5)
		playsound(location,'sound/effects/sparks1.ogg', 100, TRUE)
	else
		playsound(location,'sound/creatures/bee.ogg', 100, TRUE)
		var/list/beeagents = list()
		for(var/R in holder.reagent_list)
			if(required_reagents[R])
				continue
			beeagents += R
		var/bee_amount = round(created_volume * 0.2)
		for(var/i in 1 to bee_amount)
			var/mob/living/simple_animal/hostile/poison/bees/short/new_bee = new(location)
			if(LAZYLEN(beeagents))
				new_bee.assign_reagent(pick(beeagents))


/datum/chemical_reaction/stabilizing_agent
	name = /datum/reagent/stabilizing_agent
	id = /datum/reagent/stabilizing_agent
	results = list(/datum/reagent/stabilizing_agent = 3)
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/gas/oxygen = 1, /datum/reagent/gas/hydrogen = 1)

/datum/chemical_reaction/clf3
	name = "Chlorine Trifluoride"
	id = /datum/reagent/clf3
	results = list(/datum/reagent/clf3 = 4)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/fluorine = 3)
	required_temp = 424

/datum/chemical_reaction/clf3/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 1000 // hot as shit

/datum/chemical_reaction/reagent_explosion/methsplosion
	name = "Meth explosion"
	id = "methboom1"
	required_temp = 380 //slightly above the meth mix time.
	required_reagents = list(/datum/reagent/drug/methamphetamine = 1)
	strengthdiv = 6
	modifier = 1
	mob_react = FALSE

/datum/chemical_reaction/reagent_explosion/methsplosion/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 1000 // hot as shit
	..()

/datum/chemical_reaction/reagent_explosion/methsplosion/methboom2
	id = "methboom2"
	required_reagents = list(/datum/reagent/diethylamine = 1, /datum/reagent/iodine = 1, /datum/reagent/phosphorus = 1, /datum/reagent/gas/hydrogen = 1) //diethylamine is often left over from mixing the ephedrine.
	required_temp = 300 //room temperature, chilling it even a little will prevent the explosion

/datum/chemical_reaction/sorium
	name = "Sorium"
	id = /datum/reagent/sorium
	results = list(/datum/reagent/sorium = 4)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/gas/oxygen = 1, /datum/reagent/gas/nitrogen = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/sorium/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sorium, created_volume*4)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume*4), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/sorium_vortex
	name = "sorium_vortex"
	id = "sorium_vortex"
	required_reagents = list(/datum/reagent/sorium = 1)
	required_temp = 474

/datum/chemical_reaction/sorium_vortex/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/liquid_dark_matter
	name = "Liquid Dark Matter"
	id = /datum/reagent/liquid_dark_matter
	results = list(/datum/reagent/liquid_dark_matter = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/liquid_dark_matter/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/liquid_dark_matter, created_volume*3)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume*3), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/ldm_vortex
	name = "LDM Vortex"
	id = "ldm_vortex"
	required_reagents = list(/datum/reagent/liquid_dark_matter = 1)
	required_temp = 474

/datum/chemical_reaction/ldm_vortex/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume/2), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = /datum/reagent/flash_powder
	results = list(/datum/reagent/flash_powder = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulphur = 1 )

/datum/chemical_reaction/flash_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = created_volume/3
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2))
	for(var/mob/living/carbon/C in get_hearers_in_view(range, location))
		if(C.flash_act())
			if(get_dist(C, location) < 4)
				C.Paralyze(60)
			else
				C.Stun(100)
	holder.remove_reagent(/datum/reagent/flash_powder, created_volume*3)

/datum/chemical_reaction/flash_powder_flash
	name = "Flash powder activation"
	id = "flash_powder_flash"
	required_reagents = list(/datum/reagent/flash_powder = 1)
	required_temp = 374

/datum/chemical_reaction/flash_powder_flash/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = created_volume/10
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2))
	for(var/mob/living/carbon/C in get_hearers_in_view(range, location))
		if(C.flash_act())
			if(get_dist(C, location) < 4)
				C.Paralyze(60)
			else
				C.Stun(100)

/datum/chemical_reaction/smoke_powder
	name = /datum/reagent/smoke_powder
	id = /datum/reagent/smoke_powder
	results = list(/datum/reagent/smoke_powder = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/smoke_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/smoke_powder, created_volume*3)
	var/smoke_radius = round(sqrt(created_volume * 1.5), 1)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/fluid_spread/smoke/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(smoke_radius, location = location, carry = holder)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/smoke_powder_smoke
	name = "smoke_powder_smoke"
	id = "smoke_powder_smoke"
	required_reagents = list(/datum/reagent/smoke_powder = 1)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/smoke_powder_smoke/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	var/smoke_radius = round(sqrt(created_volume / 2), 1)
	var/datum/effect_system/fluid_spread/smoke/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(smoke_radius, location = location, carry = holder)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/sonic_powder
	name = /datum/reagent/sonic_powder
	id = /datum/reagent/sonic_powder
	results = list(/datum/reagent/sonic_powder = 3)
	required_reagents = list(/datum/reagent/gas/oxygen = 1, /datum/reagent/consumable/space_cola = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/sonic_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sonic_powder, created_volume*3)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/3, location))
		C.soundbang_act(1, 10, rand(0, 5))

/datum/chemical_reaction/sonic_powder_deafen
	name = "sonic_powder_deafen"
	id = "sonic_powder_deafen"
	required_reagents = list(/datum/reagent/sonic_powder = 1)
	required_temp = 374

/datum/chemical_reaction/sonic_powder_deafen/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		C.soundbang_act(1, 10, rand(0, 5))

/datum/chemical_reaction/phlogiston
	name = /datum/reagent/phlogiston
	id = /datum/reagent/phlogiston
	results = list(/datum/reagent/phlogiston = 3)
	required_reagents = list(/datum/reagent/phosphorus = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/stable_plasma = 1)

/datum/chemical_reaction/phlogiston/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/turf/open/T = get_turf(holder.my_atom)
	if(istype(T))
		T.atmos_spawn_air("plasma=[created_volume];TEMP=1000")
	holder.clear_reagents()
	return

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = /datum/reagent/napalm
	results = list(/datum/reagent/napalm = 3)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/consumable/ethanol = 1 )

/datum/chemical_reaction/cryostylane
	name = /datum/reagent/cryostylane
	id = /datum/reagent/cryostylane
	results = list(/datum/reagent/cryostylane = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/stable_plasma = 1, /datum/reagent/gas/nitrogen = 1)

/datum/chemical_reaction/cryostylane/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 20 // cools the fuck down
	return

/datum/chemical_reaction/cryostylane_oxygen
	name = "ephemeral cryostylane reaction"
	id = "cryostylane_oxygen"
	results = list(/datum/reagent/cryostylane = 1)
	required_reagents = list(/datum/reagent/cryostylane = 1, /datum/reagent/gas/oxygen = 1)
	mob_react = FALSE

/datum/chemical_reaction/cryostylane_oxygen/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = max(holder.chem_temp - 10*created_volume,0)

/datum/chemical_reaction/pyrosium_oxygen
	name = "ephemeral pyrosium reaction"
	id = "pyrosium_oxygen"
	results = list(/datum/reagent/pyrosium = 1)
	required_reagents = list(/datum/reagent/pyrosium = 1, /datum/reagent/gas/oxygen = 1)
	mob_react = FALSE

/datum/chemical_reaction/pyrosium_oxygen/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp += 10*created_volume

/datum/chemical_reaction/pyrosium
	name = /datum/reagent/pyrosium
	id = /datum/reagent/pyrosium
	results = list(/datum/reagent/pyrosium = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/pyrosium/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 20 // also cools the fuck down
	return

/datum/chemical_reaction/teslium
	name = "Teslium"
	id = /datum/reagent/teslium
	results = list(/datum/reagent/teslium = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/silver = 1, /datum/reagent/blackpowder = 1)
	mix_message = span_danger("A jet of sparks flies from the mixture as it merges into a flickering slurry.")
	required_temp = 400

/datum/chemical_reaction/energized_jelly
	name = "Energized Jelly"
	id = /datum/reagent/teslium/energized_jelly
	results = list(/datum/reagent/teslium/energized_jelly = 2)
	required_reagents = list(/datum/reagent/toxin/slimejelly = 1, /datum/reagent/teslium = 1)
	mix_message = span_danger("The slime jelly starts glowing intermittently.")

/datum/chemical_reaction/reagent_explosion/teslium_lightning
	name = "Teslium Destabilization"
	id = "teslium_lightning"
	required_reagents = list(/datum/reagent/teslium = 1, /datum/reagent/water = 1)
	strengthdiv = 100
	modifier = -100
	mix_message = span_boldannounce("The teslium starts to spark as electricity arcs away from it!")
	mix_sound = 'sound/machines/defib_zap.ogg'
	var/tesla_flags = TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE | TESLA_MOB_STUN

/datum/chemical_reaction/reagent_explosion/teslium_lightning/on_reaction(datum/reagents/holder, created_volume)
	var/T1 = created_volume * 20		//100 units : Zap 3 times, with powers 2000/5000/12000. Tesla revolvers have a power of 10000 for comparison.
	var/T2 = created_volume * 50
	var/T3 = created_volume * 120
	var/added_delay = 0.5 SECONDS
	var/turf/T = get_turf(holder.my_atom)
	if(created_volume >= 75)
		addtimer(CALLBACK(src, PROC_REF(zappy_zappy), T, T1), added_delay)
		added_delay += 1.5 SECONDS
	if(created_volume >= 40)
		addtimer(CALLBACK(src, PROC_REF(zappy_zappy), T, T2), added_delay)
		added_delay += 1.5 SECONDS
	if(created_volume >= 10)			//10 units minimum for lightning, 40 units for secondary blast, 75 units for tertiary blast.
		addtimer(CALLBACK(src, PROC_REF(zappy_zappy), T, T3), added_delay)
	addtimer(CALLBACK(src, PROC_REF(explode), holder, created_volume), added_delay)

/datum/chemical_reaction/reagent_explosion/teslium_lightning/proc/zappy_zappy(turf/T, power)
	if(QDELETED(T))
		return
	tesla_zap(T, 7, power, tesla_flags)
	playsound(T, 'sound/machines/defib_zap.ogg', 50, TRUE)

/datum/chemical_reaction/reagent_explosion/teslium_lightning/heat
	id = "teslium_lightning2"
	required_temp = 474
	required_reagents = list(/datum/reagent/teslium = 1)

/datum/chemical_reaction/firefighting_foam
	name = "Firefighting Foam"
	id = /datum/reagent/firefighting_foam
	results = list(/datum/reagent/firefighting_foam = 3)
	required_reagents = list(/datum/reagent/stabilizing_agent = 1,/datum/reagent/fluorosurfactant = 1,/datum/reagent/carbon = 1)
	required_temp = 200
	is_cold_recipe = TRUE

/datum/chemical_reaction/reagent_explosion/noblium_annihilation
	name = "Hypernoblium-Antinoblium Annihilation"
	id = "noblium_annihilation"
	required_reagents = list(/datum/reagent/gas/hypernoblium = 1, /datum/reagent/gas/antinoblium = 1)
	strengthdiv = 0.5
	noblium_suppression = FALSE
	mob_react = FALSE // no

/datum/chemical_reaction/frigorific_mixture
	name = /datum/reagent/frigorific_mixture
	id = /datum/reagent/frigorific_mixture
	results = list(/datum/reagent/frigorific_mixture = 2)
	required_reagents = list(/datum/reagent/consumable/sodiumchloride = 1, /datum/reagent/consumable/ice = 1)

/datum/chemical_reaction/frigorific_mixture/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 20 // cools the fuck down
	return

/datum/chemical_reaction/frigorific_mixture_water
	name = "ephemeral salty reaction"
	id = "frigorific_mixture_water"
	results = list(/datum/reagent/frigorific_mixture = 1)
	required_reagents = list(/datum/reagent/frigorific_mixture = 1, /datum/reagent/water = 1)
	mob_react = FALSE

/datum/chemical_reaction/frigorific_mixture_water/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = max(holder.chem_temp - 10*created_volume,0)
