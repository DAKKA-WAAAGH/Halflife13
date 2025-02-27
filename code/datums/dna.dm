
/**
 * Some identity blocks (basically pieces of the unique_identity string variable of the dna datum, commonly abbreviated with ui)
 * may have a length that differ from standard length of 3 ASCII characters. This list is necessary
 * for these non-standard blocks to work, as well as the entire unique identity string.
 * Should you add a new ui block which size differ from the standard (again, 3 ASCII characters), like for example, a color,
 * please do not forget to also include it in this list in the following format:
 *  "[dna block number]" = dna block size,
 * Failure to do that may result in bugs. Thanks.
 */
GLOBAL_LIST_INIT(identity_block_lengths, list(
		"[DNA_HAIR_COLOR_BLOCK]" = DNA_BLOCK_SIZE_COLOR,
		"[DNA_FACIAL_HAIR_COLOR_BLOCK]" = DNA_BLOCK_SIZE_COLOR,
		"[DNA_EYE_COLOR_BLOCK]" = DNA_BLOCK_SIZE_COLOR,
	))


GLOBAL_LIST_INIT(features_block_lengths, list())

/**
 * A list of numbers that keeps track of where ui blocks start in the unique_identity string variable of the dna datum.
 * Commonly used by the datum/dna/set_uni_identity_block and datum/dna/get_uni_identity_block procs.
 */
GLOBAL_LIST_INIT(total_ui_len_by_block, populate_total_ui_len_by_block())

/proc/populate_total_ui_len_by_block()
	. = list()
	var/total_block_len = 1
	for(var/blocknumber in 1 to DNA_UNI_IDENTITY_BLOCKS)
		. += total_block_len
		total_block_len += GET_UI_BLOCK_LEN(blocknumber)

///Ditto but for unique features. Used by the datum/dna/set_uni_feature_block and datum/dna/get_uni_feature_block procs.
GLOBAL_LIST_INIT(total_uf_len_by_block, populate_total_uf_len_by_block())

/proc/populate_total_uf_len_by_block()
	. = list()
	var/total_block_len = 1
	for(var/blocknumber in 1 to DNA_FEATURE_BLOCKS)
		. += total_block_len
		total_block_len += GET_UF_BLOCK_LEN(blocknumber)

/////////////////////////// DNA DATUM
/datum/dna
	///An md5 hash of the dna holder's real name
	var/unique_enzymes
	///Stores the hashed values of traits such as skin tones, hair style, and gender
	var/unique_identity
	var/datum/blood_type/blood_type
	///The type of mutant race the player is if applicable (i.e. potato-man)
	var/datum/species/species = new /datum/species/human
	/// Assoc list of feature keys to their value
	/// Note if you set these manually, and do not update [unique_features] afterwards, it will likely be reset.
	var/list/features = list("mcolor" = COLOR_WHITE)
	///Stores the hashed values of the person's non-human features
	var/unique_features
	///Stores the real name of the person who originally got this dna datum. Used primarely for changelings,
	var/real_name
	///All mutations are from now on here
	var/list/mutations = list()
	///Temporary changes to the UE
	var/list/temporary_mutations = list()
	///For temporary name/ui/ue/blood_type modifications
	var/list/previous = list()
	var/mob/living/holder
	///List of which mutations this carbon has and its assigned block
	var/mutation_index[DNA_MUTATION_BLOCKS]
	///List of the default genes from this mutation to allow DNA Scanner highlighting
	var/default_mutation_genes[DNA_MUTATION_BLOCKS]
	var/stability = 100
	///Did we take something like mutagen? In that case we cant get our genes scanned to instantly cheese all the powers.
	var/scrambled = FALSE

	var/delete_species = TRUE //Set to FALSE when a body is scanned by a cloner to fix #38875

/datum/dna/New(mob/living/new_holder)
	if(istype(new_holder))
		holder = new_holder

/datum/dna/Destroy()
	if(iscarbon(holder))
		var/mob/living/carbon/cholder = holder
		if(cholder.dna == src)
			cholder.dna = null
	holder = null

	if(delete_species)
		QDEL_NULL(species)

	mutations.Cut()					//This only references mutations, just dereference.
	temporary_mutations.Cut()		//^
	previous.Cut()					//^

	return ..()

/datum/dna/proc/transfer_identity(mob/living/carbon/destination, transfer_SE = 0)
	if(!istype(destination))
		return
	destination.dna.unique_enzymes = unique_enzymes
	destination.dna.unique_identity = unique_identity
	destination.dna.blood_type = blood_type
	destination.set_species(species.type, icon_update=0)
	destination.dna.unique_features = unique_features
	destination.dna.features = features.Copy()
	destination.dna.real_name = real_name
	destination.dna.temporary_mutations = temporary_mutations.Copy()
	if(transfer_SE)
		destination.dna.mutation_index = mutation_index
		destination.dna.default_mutation_genes = default_mutation_genes


/datum/dna/proc/copy_dna(datum/dna/new_dna)
	new_dna.unique_enzymes = unique_enzymes
	new_dna.mutation_index = mutation_index
	new_dna.default_mutation_genes = default_mutation_genes
	new_dna.unique_identity = unique_identity
	new_dna.unique_features = unique_features
	new_dna.blood_type = blood_type
	new_dna.features = features.Copy()
	new_dna.species = new species.type
	new_dna.real_name = real_name
	new_dna.mutations = mutations.Copy()

//See mutation.dm for what 'class' does. 'time' is time till it removes itself in decimals. 0 for no timer
/datum/dna/proc/add_mutation(mutation, class = MUT_OTHER, time)
	var/mutation_type = mutation
	if(istype(mutation, /datum/mutation/human))
		var/datum/mutation/human/HM = mutation
		mutation_type = HM.type
	if(get_mutation(mutation_type))
		return
	SEND_SIGNAL(holder, COMSIG_CARBON_GAIN_MUTATION, mutation_type, class)
	return force_give(new mutation_type (class, time, copymut = mutation))

/datum/dna/proc/remove_mutation(mutation_type)
	SEND_SIGNAL(holder, COMSIG_CARBON_LOSE_MUTATION, mutation_type)
	return force_lose(get_mutation(mutation_type))

/datum/dna/proc/check_mutation(mutation_type)
	return get_mutation(mutation_type)

/datum/dna/proc/remove_all_mutations(list/classes = list(MUT_NORMAL, MUT_EXTRA, MUT_OTHER), mutadone = FALSE)
	remove_mutation_group(mutations, classes, mutadone)
	scrambled = FALSE

/datum/dna/proc/remove_mutation_group(list/group, list/classes = list(MUT_NORMAL, MUT_EXTRA, MUT_OTHER), mutadone = FALSE)
	if(!group)
		return
	for(var/datum/mutation/human/HM in group)
		if((HM.class in classes) && !(HM.mutadone_proof && mutadone))
			force_lose(HM)

/datum/dna/proc/generate_unique_identity()
	. = ""
	var/list/L = new /list(DNA_UNI_IDENTITY_BLOCKS)

	switch(holder.gender)
		if(MALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_MALE, GENDERS)
		if(FEMALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_FEMALE, GENDERS)
		if(NEUTER)
			L[DNA_GENDER_BLOCK] = construct_block(G_NEUTER, GENDERS)
		else
			L[DNA_GENDER_BLOCK] = construct_block(G_PLURAL, GENDERS)
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		if(!GLOB.hair_styles_list.len)
			init_sprite_accessory_subtypes(/datum/sprite_accessory/hair,GLOB.hair_styles_list, GLOB.hair_styles_male_list, GLOB.hair_styles_female_list)
		L[DNA_HAIR_STYLE_BLOCK] = construct_block(GLOB.hair_styles_list.Find(H.hair_style), GLOB.hair_styles_list.len)
		L[DNA_HAIR_COLOR_BLOCK] = sanitize_hexcolor(H.hair_color, include_crunch = FALSE)
		if(!GLOB.facial_hair_styles_list.len)
			init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hair_styles_list, GLOB.facial_hair_styles_male_list, GLOB.facial_hair_styles_female_list)
		L[DNA_FACIAL_HAIR_STYLE_BLOCK] = construct_block(GLOB.facial_hair_styles_list.Find(H.facial_hair_style), GLOB.facial_hair_styles_list.len)
		L[DNA_FACIAL_HAIR_COLOR_BLOCK] = sanitize_hexcolor(H.facial_hair_color, include_crunch = FALSE)
		L[DNA_SKIN_TONE_BLOCK] = construct_block(GLOB.skin_tones.Find(H.skin_tone), GLOB.skin_tones.len)
		L[DNA_EYE_COLOR_BLOCK] = sanitize_hexcolor(H.eye_color, include_crunch = FALSE)

	for(var/blocknum in 1 to DNA_UNI_IDENTITY_BLOCKS)
		. += L[blocknum] || random_string(GET_UI_BLOCK_LEN(blocknum), GLOB.hex_characters)

/datum/dna/proc/generate_dna_blocks()
	var/bonus
	if(species && species.inert_mutation)
		bonus = GET_INITIALIZED_MUTATION(species.inert_mutation)
	var/list/mutations_temp = GLOB.good_mutations + GLOB.bad_mutations + GLOB.not_good_mutations + bonus
	if(!LAZYLEN(mutations_temp))
		return
	mutation_index.Cut()
	default_mutation_genes.Cut()
	shuffle_inplace(mutations_temp)
	if(ismonkey(holder))
		mutations |= new RACEMUT(MUT_NORMAL)
		mutation_index[RACEMUT] = GET_SEQUENCE(RACEMUT)
	else
		mutation_index[RACEMUT] = create_sequence(RACEMUT, FALSE)
	default_mutation_genes[RACEMUT] = mutation_index[RACEMUT]
	while(mutation_index.len < DNA_MUTATION_BLOCKS) 
		var/datum/mutation/human/mutation = mutations_temp[mutation_index.len]
		var/conflict = FALSE
		for(var/conflicting_mut in mutation.conflicts)
			if(mutation_index.Find(conflicting_mut))
				conflict = TRUE //no more conflicting mutations in the same mob dna 
				mutations_temp.Cut(mutation_index.len, mutation_index.len+1)
		if(conflict)
			continue
		mutation_index[mutation.type] = create_sequence(mutation.type, FALSE, mutation.difficulty)
		default_mutation_genes[mutation.type] = mutation_index[mutation.type]
	shuffle_inplace(mutation_index)

//Used to generate original gene sequences for every mutation
/proc/generate_gene_sequence(length=4)
	var/static/list/active_sequences = list("AT","TA","GC","CG")
	var/sequence
	for(var/i in 1 to length*DNA_SEQUENCE_LENGTH)
		sequence += pick(active_sequences)
	return sequence

//Used to create a chipped gene sequence
/proc/create_sequence(mutation, active, difficulty)
	if(!difficulty)
		var/datum/mutation/human/A = GET_INITIALIZED_MUTATION(mutation) //leaves the possibility to change difficulty mid-round
		if(!A)
			return
		difficulty = A.difficulty
	difficulty += rand(-2,4)
	var/sequence = GET_SEQUENCE(mutation)
	if(active)
		return sequence
	while(difficulty)
		var/randnum = rand(1, length(sequence))
		sequence = copytext(sequence, 1, randnum) + "X" + copytext(sequence, randnum + 1)
		difficulty--
	return sequence

/datum/dna/proc/generate_unique_enzymes()
	. = ""
	if(istype(holder))
		real_name = holder.real_name
		. += md5(holder.real_name)
	else
		. += random_string(DNA_UNIQUE_ENZYMES_LEN, GLOB.hex_characters)
	return .

///Setter macro used to modify unique identity blocks.
/datum/dna/proc/set_uni_identity_block(blocknum, input)
	var/precesing_blocks = copytext(unique_identity, 1, GLOB.total_ui_len_by_block[blocknum])
	var/succeeding_blocks = blocknum < GLOB.total_ui_len_by_block.len ? copytext(unique_identity, GLOB.total_ui_len_by_block[blocknum+1]) : ""
	unique_identity = precesing_blocks + input + succeeding_blocks

///Setter macro used to modify unique features blocks.
/datum/dna/proc/set_uni_feature_block(blocknum, input)
	var/precesing_blocks = copytext(unique_features, 1, GLOB.total_uf_len_by_block[blocknum])
	var/succeeding_blocks = blocknum < GLOB.total_uf_len_by_block.len ? copytext(unique_features, GLOB.total_uf_len_by_block[blocknum+1]) : ""
	unique_features = precesing_blocks + input + succeeding_blocks

/datum/dna/proc/update_ui_block(blocknumber)
	if(!blocknumber)
		CRASH("UI block index is null")
	if(!ishuman(holder))
		CRASH("Non-human mobs shouldn't have DNA")
	var/mob/living/carbon/human/H = holder
	switch(blocknumber)
		if(DNA_HAIR_COLOR_BLOCK)
			set_uni_identity_block(blocknumber, sanitize_hexcolor(H.hair_color, include_crunch = FALSE))
		if(DNA_FACIAL_HAIR_COLOR_BLOCK)
			set_uni_identity_block(blocknumber, sanitize_hexcolor(H.facial_hair_color, include_crunch = FALSE))
		if(DNA_SKIN_TONE_BLOCK)
			set_uni_identity_block(blocknumber, construct_block(GLOB.skin_tones.Find(H.skin_tone), GLOB.skin_tones.len))
		if(DNA_EYE_COLOR_BLOCK)
			set_uni_identity_block(blocknumber, sanitize_hexcolor(H.eye_color, include_crunch = FALSE))
		if(DNA_GENDER_BLOCK)
			switch(H.gender)
				if(MALE)
					set_uni_identity_block(blocknumber, construct_block(G_MALE, GENDERS))
				if(FEMALE)
					set_uni_identity_block(blocknumber, construct_block(G_FEMALE, GENDERS))
				if(NEUTER)
					set_uni_identity_block(blocknumber, construct_block(G_NEUTER, GENDERS))
				else
					set_uni_identity_block(blocknumber, construct_block(G_PLURAL, GENDERS))
		if(DNA_FACIAL_HAIR_STYLE_BLOCK)
			set_uni_identity_block(blocknumber, construct_block(GLOB.facial_hair_styles_list.Find(H.facial_hair_style), GLOB.facial_hair_styles_list.len))
		if(DNA_HAIR_STYLE_BLOCK)
			set_uni_identity_block(blocknumber, construct_block(GLOB.hair_styles_list.Find(H.hair_style), GLOB.hair_styles_list.len))

/datum/dna/proc/update_uf_block(blocknumber)
	if(!blocknumber)
		CRASH("UF block index is null")
	if(!ishuman(holder))
		CRASH("Non-human mobs shouldn't have DNA")

//Please use add_mutation or activate_mutation instead
/datum/dna/proc/force_give(datum/mutation/human/HM)
	if(holder && HM)
		if(HM.class == MUT_NORMAL)
			set_se(1, HM)
		. = HM.on_acquiring(holder)
		if(.)
			qdel(HM)
		update_instability()

//Use remove_mutation instead
/datum/dna/proc/force_lose(datum/mutation/human/HM)
	if(holder && (HM in mutations))
		set_se(0, HM)
		. = HM.on_losing(holder)
		update_instability(FALSE)
		return

/datum/dna/proc/is_same_as(datum/dna/D)
	if(unique_identity == D.unique_identity && mutation_index == D.mutation_index && real_name == D.real_name)
		if(species.type == D.species.type && features == D.features && blood_type == D.blood_type)
			return 1
	return 0

/datum/dna/proc/update_instability(alert=TRUE)
	stability = 100
	for(var/datum/mutation/human/M in mutations)
		if(M.class == MUT_EXTRA)
			stability -= M.instability * GET_MUTATION_STABILIZER(M)
	if(holder)
		var/message
		if(alert)
			switch(stability)
				if(70 to 90)
					message = span_warning("You shiver.")
				if(60 to 69)
					message = span_warning("You feel cold.")
				if(40 to 59)
					message = span_warning("You feel sick.")
				if(20 to 39)
					message = span_warning("It feels like your skin is moving.")
				if(1 to 19)
					message = span_warning("You can feel your cells burning.")
				if(-INFINITY to 0)
					message = span_boldwarning("You can feel your DNA exploding, we need to do something fast!")
		if(stability <= 0)
			holder.apply_status_effect(STATUS_EFFECT_DNA_MELT)
		if(message)
			to_chat(holder, message)

//used to update dna UI, UE, and dna.real_name.
/datum/dna/proc/update_dna_identity()
	unique_identity = generate_unique_identity()
	unique_enzymes = generate_unique_enzymes()

/datum/dna/proc/initialize_dna(newblood_type, skip_index = FALSE)
	if(newblood_type)
		blood_type = newblood_type
	unique_enzymes = generate_unique_enzymes()
	unique_identity = generate_unique_identity()
	if(!skip_index) //I hate this
		generate_dna_blocks()


/datum/dna/stored //subtype used by brain mob's stored_dna

/datum/dna/stored/add_mutation(mutation_name) //no mutation changes on stored dna.
	return

/datum/dna/stored/remove_mutation(mutation_name)
	return

/datum/dna/stored/check_mutation(mutation_name)
	return

/datum/dna/stored/remove_all_mutations(list/classes, mutadone = FALSE)
	return

/datum/dna/stored/remove_mutation_group(list/group)
	return

/////////////////////////// DNA MOB-PROCS //////////////////////

/mob/proc/set_species(datum/species/mrace, icon_update = 1)
	return

/mob/living/brain/set_species(datum/species/mrace, icon_update = 1)
	if(mrace)
		if(ispath(mrace))
			stored_dna.species = new mrace()
		else
			stored_dna.species = mrace //not calling any species update procs since we're a brain, not a monkey/human


/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	if(HAS_TRAIT(src, TRAIT_SPECIESLOCK))//can't swap species
		return
	if(mrace && has_dna())
		var/datum/species/new_race
		if(ispath(mrace))
			new_race = new mrace
		else if(istype(mrace))
			new_race = mrace
		else
			return
		deathsound = new_race.deathsound
		dna.species.on_species_loss(src, new_race, pref_load)
		var/datum/species/old_species = dna.species
		dna.species = new_race
		dna.species.on_species_gain(src, old_species, pref_load)
		if(ishuman(src))
			qdel(language_holder)
			var/species_holder = initial(mrace.species_language_holder)
			language_holder = new species_holder(src)
		update_atom_languages()

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	..()
	if(icon_update)
		update_body()
		update_hair()
		update_body_parts()
		update_mutations_overlay()// no lizard with human hulk overlay please.


/mob/proc/has_dna()
	return FALSE

/mob/living/carbon/has_dna()
	return dna


/// Sets the DNA of the mob to the given DNA.
/mob/living/carbon/human/proc/hardset_dna(unique_identity, list/mutation_index, list/default_mutation_genes, newreal_name, newblood_type, datum/species/mrace, newfeatures, list/mutations, force_transfer_mutations)
//Do not use force_transfer_mutations for stuff like cloners without some precautions, otherwise some conditional mutations could break (timers, drill hat etc)
	if(mrace)
		var/datum/species/newrace = new mrace.type
		newrace.copy_properties_from(mrace)
		set_species(newrace, icon_update = 0)

	if(newreal_name)
		dna.real_name = newreal_name
		dna.generate_unique_enzymes()

	if(newblood_type)
		dna.blood_type = newblood_type

	if(unique_identity)
		dna.unique_identity = unique_identity
		updateappearance(icon_update = 0)
	
	if(newfeatures)
		dna.features = newfeatures

	if(LAZYLEN(mutation_index))
		dna.mutation_index = mutation_index.Copy()
		if(LAZYLEN(default_mutation_genes))
			dna.default_mutation_genes = default_mutation_genes.Copy()
		else
			dna.default_mutation_genes = mutation_index.Copy()
		domutcheck()

	if(mrace || newfeatures || unique_identity)
		update_body()
		update_hair()
		update_mutations_overlay()

	if(LAZYLEN(mutations) && force_transfer_mutations)
		for(var/datum/mutation/human/mutation as anything in mutations)
			dna.force_give(new mutation.type(mutation.class, copymut = mutation)) //using force_give since it may include exotic mutations that otherwise won't be handled properly

/mob/living/carbon/proc/create_dna()
	dna = new /datum/dna(src)
	if(!dna.species)
		var/rando_race = pick(GLOB.roundstart_races)
		dna.species = new rando_race()

//proc used to update the mob's appearance after its dna UI has been changed
/mob/living/carbon/proc/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	if(!has_dna())
		return

	switch(deconstruct_block(get_uni_identity_block(dna.unique_identity, DNA_GENDER_BLOCK), GENDERS))
		if(G_MALE)
			gender = MALE
		if(G_FEMALE)
			gender = FEMALE
		if(G_NEUTER)
			gender = NEUTER
		else
			gender = PLURAL

/mob/living/carbon/human/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	..()
	var/structure = dna.unique_identity
	hair_color = sanitize_hexcolor(get_uni_identity_block(structure, DNA_HAIR_COLOR_BLOCK))
	facial_hair_color = sanitize_hexcolor(get_uni_identity_block(structure, DNA_FACIAL_HAIR_COLOR_BLOCK))
	skin_tone = GLOB.skin_tones[deconstruct_block(get_uni_identity_block(structure, DNA_SKIN_TONE_BLOCK), GLOB.skin_tones.len)]
	eye_color = sanitize_hexcolor(get_uni_identity_block(structure, DNA_EYE_COLOR_BLOCK))
	facial_hair_style = GLOB.facial_hair_styles_list[deconstruct_block(get_uni_identity_block(structure, DNA_FACIAL_HAIR_STYLE_BLOCK), GLOB.facial_hair_styles_list.len)]
	if(HAS_TRAIT(src, TRAIT_BALD))
		hair_style = "Bald"	
	else
		hair_style = GLOB.hair_styles_list[deconstruct_block(get_uni_identity_block(structure, DNA_HAIR_STYLE_BLOCK), GLOB.hair_styles_list.len)]

	if(icon_update)
		dna.species.handle_body(src) // We want 'update_body_parts()' to be called only if mutcolor_update is TRUE, so no 'update_body()' here.
		update_hair()
		if(mutcolor_update)
			update_body_parts()
		if(mutations_overlay_update)
			update_mutations_overlay()


/mob/proc/domutcheck()
	return

/mob/living/carbon/domutcheck()
	if(!has_dna())
		return

	for(var/mutation in dna.mutation_index)
		if(ismob(dna.check_block(mutation)))
			return //we got monkeyized/humanized, this mob will be deleted, no need to continue.

	update_mutations_overlay()

/datum/dna/proc/check_block(mutation)
	var/datum/mutation/human/HM = get_mutation(mutation)
	if(check_block_string(mutation))
		if(!HM)
			. = add_mutation(mutation, MUT_NORMAL)
		return
	return force_lose(HM)

//Return the active mutation of a type if there is one
/datum/dna/proc/get_mutation(A)
	for(var/datum/mutation/human/HM in mutations)
		if(istype(HM, A))
			return HM

/datum/dna/proc/check_block_string(mutation)
	if((LAZYLEN(mutation_index) > DNA_MUTATION_BLOCKS) || !(mutation in mutation_index))
		return 0
	return is_gene_active(mutation)

/datum/dna/proc/is_gene_active(mutation)
	return (mutation_index[mutation] == GET_SEQUENCE(mutation))

/datum/dna/proc/set_se(on=TRUE, datum/mutation/human/HM)
	if(!HM || !(HM.type in mutation_index) || (LAZYLEN(mutation_index) < DNA_MUTATION_BLOCKS))
		return
	. = TRUE
	if(on)
		mutation_index[HM.type] = GET_SEQUENCE(HM.type)
		default_mutation_genes[HM.type] = mutation_index[HM.type]
	else if(GET_SEQUENCE(HM.type) == mutation_index[HM.type])
		mutation_index[HM.type] = create_sequence(HM.type, FALSE, HM.difficulty)
		default_mutation_genes[HM.type] = mutation_index[HM.type]

/datum/dna/proc/activate_mutation(mutation) //note that this returns a boolean and not a new mob
	if(!mutation)
		return FALSE
	var/mutation_type = mutation
	if(istype(mutation, /datum/mutation/human))
		var/datum/mutation/human/M = mutation
		mutation_type = M.type
	if(!mutation_in_sequence(mutation_type)) //cant activate what we dont have, use add_mutation
		return FALSE
	add_mutation(mutation, MUT_NORMAL)
	return TRUE

/////////////////////////// DNA HELPER-PROCS //////////////////////////////

/datum/dna/proc/mutation_in_sequence(mutation)
	if(!mutation)
		return
	if(istype(mutation, /datum/mutation/human))
		var/datum/mutation/human/HM = mutation
		if(HM.type in mutation_index)
			return TRUE
	else if(mutation in mutation_index)
		return TRUE


/mob/living/carbon/proc/random_mutate(list/candidates, difficulty = 2)
	if(!has_dna())
		CRASH("[src] does not have DNA")
	var/mutation = pick(candidates)
	. = dna.add_mutation(mutation)

/mob/living/carbon/proc/easy_random_mutate(quality = POSITIVE + NEGATIVE + MINOR_NEGATIVE, scrambled = TRUE, sequence = TRUE, exclude_monkey = TRUE)
	if(!has_dna())
		CRASH("[src] does not have DNA")
	var/list/mutations = list()
	if(quality & POSITIVE)
		mutations += GLOB.good_mutations
	if(quality & NEGATIVE)
		mutations += GLOB.bad_mutations
	if(quality & MINOR_NEGATIVE)
		mutations += GLOB.not_good_mutations
	var/list/possible = list()
	for(var/datum/mutation/human/A in mutations)
		if((!sequence || dna.mutation_in_sequence(A.type)) && !dna.get_mutation(A.type))
			possible += A.type
	if(exclude_monkey)
		possible.Remove(RACEMUT)
	if(LAZYLEN(possible))
		var/mutation = pick(possible)
		. = dna.activate_mutation(mutation)
		if(scrambled)
			var/datum/mutation/human/HM = dna.get_mutation(mutation)
			if(HM)
				HM.scrambled = TRUE
		return TRUE

/mob/living/carbon/proc/random_mutate_unique_identity()
	if(!has_dna())
		CRASH("[src] does not have DNA")
	var/num = rand(1, DNA_UNI_IDENTITY_BLOCKS)
	dna.set_uni_feature_block(num, random_string(GET_UI_BLOCK_LEN(num), GLOB.hex_characters))
	updateappearance(mutations_overlay_update=1)

/mob/living/carbon/proc/random_mutate_unique_features()
	if(!has_dna())
		CRASH("[src] does not have DNA")

/mob/living/carbon/proc/clean_dna()
	if(!has_dna())
		CRASH("[src] does not have DNA")
	dna.remove_all_mutations()

/mob/living/carbon/proc/clean_random_mutate(list/candidates, difficulty = 2)
	clean_dna()
	random_mutate(candidates, difficulty)

/proc/scramble_dna(mob/living/carbon/M, ui=FALSE, se=FALSE, uf=FALSE, probability)
	if(!M.has_dna())
		CRASH("[M] does not have DNA")
	if(se)
		for(var/i=1, i<=DNA_MUTATION_BLOCKS, i++)
			if(prob(probability))
				M.dna.generate_dna_blocks()
		M.domutcheck()
	if(ui)
		for(var/blocknum in 1 to DNA_UNI_IDENTITY_BLOCKS)
			if(prob(probability))
				M.dna.set_uni_feature_block(blocknum, random_string(GET_UI_BLOCK_LEN(blocknum), GLOB.hex_characters))
	if(ui || uf)
		M.updateappearance(mutcolor_update=uf, mutations_overlay_update=1)

//value in range 1 to values. values must be greater than 0
//all arguments assumed to be positive integers
/proc/construct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	if(value < 1)
		value = 1
	value = (value * width) - rand(1,width)
	return num2hex(value, blocksize)

//value is hex
/proc/deconstruct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	value = round(hex2num(value) / width) + 1
	if(value > values)
		value = values
	return value

/proc/get_uni_identity_block(identity, blocknum)
	return copytext(identity, GLOB.total_ui_len_by_block[blocknum], LAZYACCESS(GLOB.total_ui_len_by_block, blocknum+1))

/proc/get_uni_feature_block(features, blocknum)
	return copytext(features, GLOB.total_uf_len_by_block[blocknum], LAZYACCESS(GLOB.total_uf_len_by_block, blocknum+1))

/////////////////////////// DNA HELPER-PROCS

/mob/living/carbon/human/proc/something_horrible(ignore_stability)
	if(!has_dna()) //shouldn't ever happen anyway so it's just in really weird cases
		return
	if(!ignore_stability && (dna.stability > 0))
		return
	var/instability = -dna.stability
	dna.remove_all_mutations()
	dna.stability = 100
	if(prob(max(70-instability,0)))
		switch(rand(0,10)) //not complete and utter death
			if(0)
				monkeyize()
			if(1)
				gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic)
				new/obj/vehicle/ridden/wheelchair(get_turf(src)) //don't buckle, because I can't imagine to plethora of things to go through that could otherwise break
				to_chat(src, span_warning("My flesh turned into a wheelchair and I can't feel my legs."))
			if(2)
				corgize()
			if(3)
				to_chat(src, span_notice("Oh, I actually feel quite alright!"))
			if(4)
				to_chat(src, span_notice("Oh, I actually feel quite alright!")) //you thought
				physiology.damage_resistance = -20000
			if(5)
				to_chat(src, span_notice("Oh, I actually feel quite alright!"))
				reagents.add_reagent(/datum/reagent/aslimetoxin, 10)
			if(6)
				apply_status_effect(STATUS_EFFECT_GO_AWAY)
			if(7)
				to_chat(src, span_notice("Oh, I actually feel quite alright!"))
				ForceContractDisease(new/datum/disease/decloning()) //slow acting, non-viral clone damage based GBS
			if(8)
				var/list/elligible_organs = list()
				for(var/obj/item/organ/O in internal_organs) //make sure we dont get an implant or cavity item
					elligible_organs += O
				vomit(20, TRUE)
				if(elligible_organs.len)
					var/obj/item/organ/O = pick(elligible_organs)
					O.Remove(src)
					visible_message(span_danger("[src] vomits up their [O.name]!"), "<span class='danger'>You vomit up your [O.name]") //no "vomit up your the heart"
					O.forceMove(drop_location())
					if(prob(20))
						O.animate_atom_living()
			if(9 to 10)
				ForceContractDisease(new/datum/disease/gastrolosis())
				to_chat(src, span_notice("Oh, I actually feel quite alright!"))
	else
		switch(rand(0,5))
			if(0)
				gib()
			if(1)
				dust()

			if(2)
				death()
				petrify(INFINITY)
			if(3)
				if(prob(95))
					var/obj/item/bodypart/BP = get_bodypart(pick(BODY_ZONE_CHEST,BODY_ZONE_HEAD))
					if(BP)
						BP.dismember()
					else
						gib()
				else
					set_species(/datum/species/dullahan)
			if(4)
				visible_message(span_warning("[src]'s skin melts off!"), span_boldwarning("Your skin melts off!"))
				spawn_gibs()
				set_species(/datum/species/skeleton)
				if(prob(90))
					addtimer(CALLBACK(src, PROC_REF(death)), 30)
					if(mind)
						mind.hasSoul = FALSE
			if(5)
				to_chat(src, span_phobia("LOOK UP!"))
				addtimer(CALLBACK(src, PROC_REF(something_horrible_mindmelt)), 30)


/mob/living/carbon/human/proc/something_horrible_mindmelt()
	if(!HAS_TRAIT(src, TRAIT_BLIND))
		var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes) in internal_organs
		if(!eyes)
			return
		eyes.Remove(src)
		qdel(eyes)
		visible_message(span_notice("[src] looks up and their eyes melt away!"), "<span class>='userdanger'>I understand now.</span>")
		addtimer(CALLBACK(src, PROC_REF(adjustOrganLoss), ORGAN_SLOT_BRAIN, 200), 20)
