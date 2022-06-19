///Gives, runs then removes all brain traumas to see if any has bad qdels
/datum/unit_test/brain_traumas/Run()
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human)

	for(var/datum/brain_trauma/traumas as anything in subtypesof(/datum/brain_trauma))
		victim.gain_trauma(traumas)
		TEST_ASSERT(victim.has_trauma_type(traumas), "Victim recieved [traumas] but doesn't have it.")

		traumas.on_life()

		victim.cure_trauma_type(traumas)
		TEST_ASSERT(!victim.has_trauma_type(traumas), "Victim was cleared of [traumas] but still has it.")
