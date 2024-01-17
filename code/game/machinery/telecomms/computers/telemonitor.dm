///Main Menu screen page.
#define MAIN_VIEW 0
///Machine view screen page.
#define MACHINE_VIEW 1
///Character limit on how long a network ID can be.
#define MAX_NETWORK_ID_LENGTH 15

/*
 * Telecomms monitor tracks the overall trafficing of a telecommunications network
 * and displays a heirarchy of linked machines.
 */
/obj/machinery/computer/telecomms/monitor
	name = "telecommunications monitoring console"
	icon_screen = "comm_monitor"
	desc = "Monitors the details of the telecommunications network it's synced with."
	circuit = /obj/item/circuitboard/computer/comm_monitor

	/// Current screen the user is viewing
	var/screen = MAIN_VIEW
	/// List of weakrefs of the machines the computer can monitor.
	var/list/datum/weakref/machine_list = list()
	/// Weakref of the currently selected tcomms machine we're monitoring.
	var/datum/weakref/selected_machine_ref
	/// The network to probe
	var/network = "NULL"
	/// Error message to show
	var/error_message = ""

/obj/machinery/computer/telecomms/monitor/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TelecommsMonitor", name)
		ui.open()

/obj/machinery/computer/telecomms/monitor/ui_data(mob/user)
	var/list/data = list(
		"screen" = screen,
		"network" = network,
		"error_message" = error_message,
	)

	switch(screen)
		if(MAIN_VIEW)
			var/list/found_machinery = list()
			for(var/datum/weakref/tcomms_ref in machine_list)
				var/obj/machinery/telecomms/telecomms = tcomms_ref.resolve()
				if(!telecomms)
					machine_list -= tcomms_ref
					continue
				found_machinery += list(list(
					"ref" = REF(telecomms),
					"name" = telecomms.name,
					"id" = telecomms.id,
				))
			data["machinery"] = found_machinery
		if(MACHINE_VIEW)
			// Send selected machinery data
			var/list/machine_out = list()
			var/obj/machinery/telecomms/selected = selected_machine_ref.resolve()
			if(selected)
				machine_out["name"] = selected.name
				// Get the linked machinery
				var/list/linked_machinery = list()
				for(var/obj/machinery/telecomms/linked_telecomm_machine in selected.links)
					linked_machinery += list(list(
						"ref" = REF(linked_telecomm_machine.id),
						"name" = linked_telecomm_machine.name,
						"id" = linked_telecomm_machine.id,
					))
				machine_out["linked_machinery"] = linked_machinery
				data["machine"] = machine_out
	return data

/obj/machinery/computer/telecomms/monitor/ui_act(action, params)
	. = ..()
	if(.)
		return .

	error_message = ""

	switch(action)
		// Scan for a network
		if("probe_network")
			var/new_network = params["network_id"]

			if(length(new_network) > MAX_NETWORK_ID_LENGTH)
				error_message = "OPERATION FAILED: NETWORK ID TOO LONG."
				return TRUE

			list_clear_empty_weakrefs(machine_list)

			if(machine_list.len > 0)
				error_message = "OPERATION FAILED: CANNOT PROBE WHEN BUFFER FULL."
				return TRUE

			network = new_network

			for(var/obj/machinery/telecomms/telecomm_machines in urange(25, src))
				if(telecomm_machines.network == network)
					machine_list += WEAKREF(telecomm_machines)
			if(!length(machine_list))
				error_message = "OPERATION FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN [network]."
				return TRUE
			error_message = "[machine_list.len] ENTITIES LOCATED & BUFFERED";
			return TRUE
		if("flush_buffer")
			machine_list = list()
			network = ""
			return TRUE
		if("view_machine")
			for(var/datum/weakref/tcomms_ref in machine_list)
				var/obj/machinery/telecomms/tcomms = tcomms_ref.resolve()
				if(!tcomms)
					machine_list -= tcomms_ref
					continue
				if(tcomms.id == params["id"])
					selected_machine_ref = tcomms_ref
			if(!selected_machine_ref)
				error_message = "OPERATION FAILED: UNABLE TO LOCATE MACHINERY."
			screen = MACHINE_VIEW
			return TRUE
		if("return_home")
			selected_machine_ref = null
			screen = MAIN_VIEW
			return TRUE
	return TRUE

#undef MAIN_VIEW
#undef MACHINE_VIEW
#undef MAX_NETWORK_ID_LENGTH
