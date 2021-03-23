//////////////////////////////////////////
//				SCP 914					//
//										//
//	This functions similarly to a mind	//
//  machine device, but with only one   //
//  usable pod. Info of how it works is //
//  at http://www.scp-wiki.net/scp-914	//
//                                      //
//////////////////////////////////////////

/obj/machinery/scp_914/pod
	name = "\improper strange machine pod"
	icon_state = "mind_pod_open"
	desc = "A large booth connected via copper tubes to the main body next to it."
	var/podNumber = 0
	var/obj/machinery/scp_914/hub/connectedHub
	var/atom/movable/currentItem = null

/obj/machinery/scp_914/pod/Destroy()
	go_out()
	if(connectedHub)
		connectedHub.podsConnected = FALSE
		switch(podNumber)
			if(1)
				connectedHub.intakePod = null
			if(2)
				connectedHub.outputPod = null
	..()

/obj/machinery/scp_914/pod/proc/go_out(var/exit = src.loc, var/mob/ejector)
	if(!currentItem)
		for(var/atom/movable/M in contents)
			M.forceMove(get_turf(src))
		return 0
	if(!currentItem.gcDestroyed)
		currentItem.forceMove(exit)
		//currentItem.reset_view()
	currentItem = null

/obj/machinery/scp_914/pod/intake
	name = "Intake"
	desc = "A large booth connected via copper tubes to the main body next to it. This one is labelled \"Intake\"."

/obj/machinery/scp_914/pod/intake/MouseDropTo(atom/movable/O, mob/user)
	if(connectedHub.lockedPods)
		to_chat(user, "<span class='notice'>The pod is locked tight!</span>")
		return
	if(!isturf(O.loc) || !isturf(user.loc) || !user.Adjacent(O))
		return
	if(user.incapacitated() || user.lying)
		return
	if(!Adjacent(user) || !user.Adjacent(src) || user.contents.Find(src))
		return
	if(O.anchored)
		return
	if(!ishigherbeing(user) && !isrobot(user))
		return
	if(currentItem)
		to_chat(user, "<span class='notice'>The pod is already occupied!</span>")
		return
	if(!istype(O))
		return
	if(O == user)
		visible_message("<span class='notice'>[user] climbs into \the [src].</span>")
	else
		visible_message("<span class='notice'>[user] puts [O.name] into \the [src].</span>")
	if(user.pulling == 0)
		user.stop_pulling()
	put_in(0)

/obj/machinery/scp_914/pod/intake/MouseDropFrom(over_object, src_location, var/turf/over_location, src_control, over_control, params)
	if(connectedHub.lockedPods)
		to_chat(usr, "<span class='notice'>The pod is locked tight!</span>")
		return
	if(!ishigherbeing(usr) && !isrobot(usr) || usr.incapacitated() || usr.lying)
		return
	if(!currentItem)
		to_chat(usr, "<span class='warning'>\The [src] is unoccupied!</span>")
		return
	over_location = get_turf(over_location)
	if(!istype(over_location) || over_location.density)
		return
	if(!Adjacent(over_location) || !Adjacent(usr) || !usr.Adjacent(over_location))
		return
	for(var/atom/movable/A in over_location.contents)
		if(A.density)
			if((A == src))
				continue
			return
	if(currentItem == usr)
		visible_message("<span class='notice'>[usr] climbs out of the \the [src]</span>")
	else
		visible_message("<span class='notice'>[usr] pulls [currentItem.name] out of \the [src].</span>")
	go_out(over_location, ejector = usr)

/obj/machinery/scp_914/pod/intake/proc/put_in(var/atom/movable/A)
	A.forceMove(src)
	//A.reset_view()
	src.currentItem = A
	connectedHub.intakeItem = A

/obj/machinery/scp_914/pod/intake/go_out(var/exit = src.loc, var/mob/ejector)
	..()
	connectedHub.intakeItem = null

/obj/machinery/scp_914/pod/output
	name = "Output"
	desc = "A large booth connected via copper tubes to the main body next to it. This one is labelled \"Output\"."

/obj/machinery/scp_914/pod/output/go_out(var/exit = src.loc, var/mob/ejector)
	..()
	// Handle this after ejection
	switch(connectedHub.processType)
		if(STATE_COARSE)
			// Gib living things
			if (istype(connectedHub.outputItem, /mob))
				var/mob/M = connectedHub,outputItem
				M.gib()
			if(istype(iconnectedHub.outputItem,/obj/machinery))
				var/object/machinery/MC = connectedHub.outputItem
				MC.spillContents()
				qdel(MC)
				new /obj/item/stack/sheet/metal(src.loc)
		if(STATE_ROUGH)
			if(istype(iconnectedHub.outputItem,/obj/machinery))
				var/object/machinery/MC = connectedHub.outputItem
				MC.dropFrame()
				MC.spillContents()
	connectedHub.outputItem = null