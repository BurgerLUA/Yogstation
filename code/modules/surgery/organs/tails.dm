// Note: tails only work in humans. They use human-specific parameters and rely on human code for displaying.

/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	visual = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	process_flags = ORGANIC | SYNTHETIC // pretty much entirely cosmetic, if someone wants to make crimes against nature then sure
	var/tail_type = "None"

/obj/item/organ/tail/Remove(mob/living/carbon/human/H, special = 0)
	..()
	if(H && H.dna && H.dna.species)
		H.dna.species.stop_wagging_tail(H)

/obj/item/organ/tail/get_availability(datum/species/species)
	return (HAS_TAIL in species.species_traits)

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "A severed cat tail. Who's wagging now?"
	tail_type = "Cat"

/obj/item/organ/tail/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!("tail_human" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "tail_human"
			H.dna.features["tail_human"] = tail_type
			H.update_body()

/obj/item/organ/tail/cat/Remove(mob/living/carbon/human/H, special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_human"
		color = H.hair_color
		H.update_body()

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	icon_state = "severedlizardtail" //yogs - so the tail uses the correct sprites
	color = "#116611"
	tail_type = "Smooth"
	var/spines = "None"

/obj/item/organ/tail/lizard/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		// Checks here are necessary so it wouldn't overwrite the tail of a lizard it spawned in
		if(!("tail_lizard" in H.dna.species.mutant_bodyparts))
			H.dna.features["tail_lizard"] = tail_type
			H.dna.species.mutant_bodyparts |= "tail_lizard"

		if(!("spines" in H.dna.species.mutant_bodyparts))
			H.dna.features["spines"] = spines
			H.dna.species.mutant_bodyparts |= "spines"
		H.update_body()

/obj/item/organ/tail/lizard/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_lizard"
		H.dna.species.mutant_bodyparts -= "spines"
		color = "#" + H.dna.features["mcolor"]
		tail_type = H.dna.features["tail_lizard"]
		spines = H.dna.features["spines"]
		H.update_body()

/obj/item/organ/tail/lizard/fake
	name = "fabricated lizard tail"
	desc = "A fabricated severed lizard tail. This one's made of synthflesh. Probably not usable for lizard wine."

/obj/item/organ/tail/polysmorph
	name = "polysmorph tail"
	desc = "A severed polysmorph tail."
	icon_state = "severedpolytail" //yogs - so the tail uses the correct sprites
	tail_type = "Polys"

/obj/item/organ/tail/polysmorph/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = FALSE)
	..()
	if(istype(H))
		if(!("tail_polysmorph" in H.dna.species.mutant_bodyparts))
			H.dna.features["tail_polysmorph"] = tail_type
			H.dna.species.mutant_bodyparts |= "tail_polysmorph"
		H.update_body()

/obj/item/organ/tail/polysmorph/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_polysmorph"
		tail_type = H.dna.features["tail_polysmorph"]
		H.update_body()
