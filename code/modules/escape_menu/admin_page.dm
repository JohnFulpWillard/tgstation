/datum/escape_menu/proc/show_admin_page()
	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/lobby_button/small(
			null,
			/* hud_owner = */ null,
			/* button_text = */ "Back",
			/* tooltip_text = */ null,
			/* pixel_offset = */ list(-260, 190),
			CALLBACK(src, PROC_REF(open_home_page)),
			/* button_overlay = */ "back",
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/text/clickable(
			null,
			/* hud_owner = */ null,
			/* escape_menu = */ src,
			/* button_text = */ "Create Ticket",
			/* offset = */ list(-136, -260),
			/* font_size = */ 24,
			/* on_click_callback = */ CALLBACK(src, PROC_REF(create_ticket)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/text/clickable/admin_ticket_notification(
			null,
			/* hud_owner = */ null,
			/* escape_menu = */ src,
			/* button_text = */ "View Last Ticket",
			/* offset = */ list(-171, -262),
			/* font_size = */ 24,
			/* on_click_callback = */ CALLBACK(src, PROC_REF(view_latest_ticket)),
		)
	)
	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/text/clickable(
			null,
			/* hud_owner = */ null,
			/* escape_menu = */ src,
			/* button_text = */ "Admin Notices",
			/* offset = */ list(-206, -260),
			/* font_size = */ 24,
			/* on_click_callback = */ CALLBACK(src, PROC_REF(admin_notice)),
		)
	)

	if(CONFIG_GET(flag/see_own_notes))
		page_holder.give_screen_object(
			new /atom/movable/screen/escape_menu/text/clickable(
				null,
				/* hud_owner = */ null,
				/* escape_menu = */ src,
				/* button_text = */ "Admin Remarks",
				/* offset = */ list(-241, -260),
				/* font_size = */ 24,
				/* on_click_callback = */ CALLBACK(src, PROC_REF(see_remarks)),
			)
		)

/datum/escape_menu/proc/create_ticket()
	if(!(/client/verb/adminhelp in client?.verbs))
		return
	client?.adminhelp()
	qdel(src)

/datum/escape_menu/proc/view_latest_ticket()
	client?.view_latest_ticket()
	qdel(src)

/datum/escape_menu/proc/admin_notice()
	client?.admin_notice()
	qdel(src)

/datum/escape_menu/proc/see_remarks()
	client?.self_notes()
	qdel(src)
