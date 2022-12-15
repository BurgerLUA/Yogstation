GLOBAL_VAR_INIT(curse_of_madness_triggered, FALSE)
GLOBAL_VAR_INIT(curse_of_madness_trauma, FALSE)


GLOBAL_LIST_INIT(curse_of_madness_traumas, list(
	/datum/brain_trauma/magic/antimagic, //Immune to magic.
	/datum/brain_trauma/mild/hallucinations, //Hallucinate.
	/datum/brain_trauma/mild/healthy, //Can't feel pain.
	/datum/brain_trauma/special/bluespace_prophet, //Teleport through portals.
	/datum/brain_trauma/special/psychotic_brawling, //Randomized melee damage.
	/datum/brain_trauma/special/tenacity, //No softcrit or hardcrit.
	/datum/brain_trauma/special/death_whispers	//Can hear deadchat sometimes.
))


/proc/curse_of_madness(mob/user, message, /datum/brain_trauma/selected_trauma)
	if(user) //in this case either someone holding a spellbook or a badmin
		to_chat(user, span_warning("You sent a curse of madness with the message \"[message]\"!"))
		message_admins("[ADMIN_LOOKUPFLW(user)] sent a curse of madness with the message \"[message]\"!")
		log_game("[key_name(user)] sent a curse of madness with the message \"[message]\"!")

	GLOB.curse_of_madness_triggered = message // So latejoiners are also afflicted.
	GLOB.curse_of_madness_trauma = selected_trauma

	deadchat_broadcast("A [span_name("Curse of Madness")] has stricken the station, shattering their minds with the awful secret: \"<span class='big hypnophrase'>[message]</span>\"")

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		var/turf/T = get_turf(H)
		if(T && !is_station_level(T.z))
			continue
		if(H.anti_magic_check(TRUE, FALSE, TRUE))
			to_chat(H, span_notice("You have a strange feeling for a moment, but then it passes."))
			continue
		give_madness(H, message)

/proc/give_madness(mob/living/carbon/human/H, message)
	H.playsound_local(H,'sound/magic/curse.ogg',40,1)
	to_chat(H, "<span class='reallybig hypnophrase'>[message]</span>")
	to_chat(H, span_warning("Your mind shatters!"))
	curse_of_madness_traumas