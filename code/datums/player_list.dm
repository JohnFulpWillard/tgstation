/datum/player_list/ui_state()
	return GLOB.always_state

/datum/player_list/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PlayerList", "Player List")
		ui.open()

/datum/player_list/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("feedback_link")
			var/feedback_url = params["link"]
			DIRECT_OUTPUT(user, link(feedback_url))
			return TRUE
		if("ignore")
			var/ckey = params["name"]
			if(ckey in user.client?.prefs.ignoring)
				user.client?.prefs.ignoring.Remove(ckey)
			else
				user.client?.prefs.ignoring.Add(ckey)
			user.client?.prefs.save_preferences()
			update_static_data(user)
			return TRUE

/datum/player_list/ui_static_data(mob/user)
	var/list/data = list()

	data["admin"] = list()
	for(var/client/admin as anything in GLOB.admins - user.client)
		if(admin.is_afk() || !isnull(admin.holder.fakekey))
			continue
		data["admin"] = list(list(
			"name" = admin.ckey,
			"feedback_link" = "https://www.youtube.com/watch?v=olkgI3CPsk4",// admin.holder.feedback_link(),
			"rank" = admin.holder.rank_names(),
			"ignored" = !!(admin.ckey in user.client?.prefs.ignoring),
		))

	data["player"] = list()
	for(var/client/player as anything in GLOB.clients - GLOB.admins - user.client)
		data["player"] += list(list(
			"name" = player.ckey,
			"ignored" = !!(player.ckey in user.client?.prefs.ignoring),
		))

	return data
