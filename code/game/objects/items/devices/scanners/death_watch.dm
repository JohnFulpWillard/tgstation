/**
 * Death Watch
 *
 * When used on a dissected character, will print a photo showing their moment of death.
 * Photo is black & white w/ no description, in attempts to obfuscate information without making it totally worthless.
 */
/obj/item/death_watch
	name = "memento mortem"
	desc = "\"Remember Death\", when used on a dissected corpse, will go as far back as possible and show their last moments of life."
	icon = 'icons/obj/devices/watch.dmi'
	icon_state = "deathwatch"
	inhand_icon_state = "deathwatch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT)

/obj/item/death_watch/attack(mob/living/target_mob, mob/living/user, params)
	. = ..()
	if(target_mob.stat != DEAD)
		target_mob.balloon_alert(user, "target not dead!")
		return
	if(isnull(target_mob.death_photo))
		target_mob.balloon_alert(user, "records gone!")
		return
	if(!HAS_TRAIT(target_mob, TRAIT_DISSECTED))
		target_mob.balloon_alert(user, "target must be dissected!")
		return
	print_death_photo(target_mob, user)

///Prints the dead person's death photo and puts it in the user's hand, if there is one.
/obj/item/death_watch/proc/print_death_photo(mob/living/dead_person, mob/living/user)
	var/obj/item/photo/death_photo = new(drop_location(), dead_person.death_photo, TRUE, FALSE, FALSE)
	QDEL_NULL(dead_person.death_photo)
	if(user)
		dead_person.balloon_alert(user, "photo printed")
		user.playsound_local(src, 'sound/machines/radar-ping.ogg', 30)
		user.put_in_hands(death_photo)
