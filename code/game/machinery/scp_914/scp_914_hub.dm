//////////////////////////////////////////
//				SCP 914					//
//										//
//	This functions similarly to a mind	//
//  machine device, but with only one   //
//  usable pod. Info of how it works is //
//  at http://www.scp-wiki.net/scp-914	//
//                                      //
//////////////////////////////////////////

/obj/machinery/scp_914
	name = "\improper strange machine"
	icon = 'icons/obj/mind_machine.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 2000
	light_power_on = 1
	machine_flags = FIXED2WORK | WRENCHMOVE
	mech_flags = MECH_SCAN_FAIL

#define STATE_COARSE "Coarse"
#define STATE_ROUGH "Rough"
#define STATE_EQUAL "1:1"
#define STATE_FINE "Fine"
#define STATE_VFINE "Very Fine"

/obj/machinery/scp_914/hub
	name = "\improper strange machine hub"
	icon_state = "mind_hub"
	desc = "A strange large clockwork device consisting of screw drives, belts, pulleys, gears, springs and other clockwork. It contains a copper panel with a large knob with a small arrow attached to the front, and a keyhole below to activate it."
	var/atom/movable/intakeItem = null
	var/atom/movable/outputItem = null
	var/outputAmount = 1
	var/obj/machinery/scp_914/pod/intake/intakePod
	var/obj/machinery/scp_914/pod/output/outputPod
	var/podsConnected = FALSE
	var/lockedPods = FALSE
	var/currentlyProcessing = FALSE
	var/itemProgress = 0
	var/processType = STATE_EQUAL

/obj/machinery/scp_914/hub/New()
	..()
	findConnections()

/obj/machinery/scp_914/hub/proc/findConnections() //Finds and links the hub with the pods on either side
	intakePod = findIntakePod()
	if(intakePod)
		intakePod.connectedHub = src
		intakePod.podNumber = 1
	outputPod = findOutputPod()
	if(outputPod)
		outputPod.connectedHub = src
		outputPod.podNumber = 2
	if ((intakePod) && (outputPod))
		podsConnected = TRUE

/obj/machinery/scp_914/hub/proc/findIntakePod()
	for(var/obj/machinery/scp_914/pod/intake/CO in orange(1,src))
		if(CO != outputPod && CO.anchored)
			return CO

/obj/machinery/scp_914/hub/proc/findOutputPod()
	for(var/obj/machinery/scp_914/pod/output/CT in orange(1,src))
		if(CT != intakePod && CT.anchored)
			return CT

/obj/machinery/scp_914/hub/attack_hand(mob/user)
	if(!podsConnected || !intakePod || !outputPod)
		resetConnections(user)
	if(!currentlyProcessing)
		if(!intakePod.Adjacent(src) || !outputPod.Adjacent(src))
			resetConnections(user)
	if(!podsConnected)
		to_chat(user, "<span class='notice'>Pod connection error.</span>")
		return	//No UI without pods
	user.set_machine(src)

	var/dat = {"<center><p>Current Item: [intakeItem != null ? intakeItem : "None"]</p><br><p>Item setting: <a href='?src=\ref[src];decrement=1'>-</a> [processType] <a href='?src=\ref[src];increment=1'>+</a></p><br><p><a href='?src=\ref[src];activate=1'>Activate [src]</a></p><br><p><a href='?src=\ref[src];lockpods=1'>[lockedPods ? "Lock" : "Unlock"] the [src]</a></p>"}
	user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=scp914;size=350x300")
	//onclose(user, "scp914")

/obj/machinery/scp_914/hub/proc/resetConnections(mob/user)
		to_chat(user, "<span class='notice'>Establishing pod connections.</span>")
		podsConnected = FALSE
		intakePod = FALSE
		outputPod = FALSE
		findConnections()

/obj/machinery/scp_914/hub/Topic(href, href_list)
	if(..())
		return
	if(!intakePod.Adjacent(src) || !outputPod.Adjacent(src) || !intakePod.anchored || !outputPod.anchored || currentlyProcessing)
		return

	if(href_list["activate"] && intakeItem && lockedPods)
		processItem()
		return

	if(href_list["lockpods"])
		lockPods()
		return

	if(href_list["decrement"])
		decrementType()
		return

	if(href_list["increment"])
		incrementType()
		return

/obj/machinery/scp_914/hub/proc/decrementType()
    switch(processType)
        if(STATE_VFINE)
            processType = STATE_FINE
        if(STATE_FINE)
            processType = STATE_EQUAL
        if(STATE_EQUAL)
            processType = STATE_ROUGH
        if(STATE_ROUGH)
            processType = STATE_COARSE

/obj/machinery/scp_914/hub/proc/incrementType()
    switch(processType)
        if(STATE_COARSE)
            processType = STATE_ROUGH
        if(STATE_ROUGH)
            processType = STATE_EQUAL
        if(STATE_EQUAL)
            processType = STATE_FINE
        if(STATE_FINE)
            processType = STATE_VFINE

/obj/machinery/scp_914/hub/proc/lockPods()
	lockedPods = TRUE
	playsound(intakePod, 'sound/machines/poddoor.ogg', 55, 1)
	playsound(outputPod, 'sound/machines/poddoor.ogg', 55, 1)
	flick("mind_pod_closing",intakePod)
	intakePod.icon_state = "mind_pod_closed"
	flick("mind_pod_closing",outputPod)
	outputPod.icon_state = "mind_pod_closed"

/obj/machinery/scp_914/hub/proc/unlockPods()
	intakePod.icon_state = "mind_pod_open"
	outputPod.icon_state = "mind_pod_open"
	playsound(outputPod, 'sound/machines/door_unbolt.ogg', 35, 1)
	playsound(intakePod, 'sound/machines/door_unbolt.ogg', 35, 1)
	flick("mind_pod_opening", intakePod)
	flick("mind_pod_opening", outputPod)
	lockedPods = FALSE

/obj/machinery/scp_914/hub/proc/ejectPods()
	intakePod.go_out()
	outputPod.go_out()

/obj/machinery/scp_914/hub/proc/processItem()
	if(!lockedPods)
		return
	currentlyProcessing = TRUE
	playsound(intakePod, 'sound/effects/sparks4.ogg', 80, 1)
	playsound(outputPod, 'sound/effects/sparks4.ogg', 80, 1)
	icon_state = "mind_hub_active"
	intakePod.icon_state = "mind_pod_active"
	outputPod.icon_state = "mind_pod_active"
	intakePod.currentItem.forceMove(src)
	if (ishuman(intakeItem))
		var/mob/living/carbon/human/H = intakeItem
		H.reset_view()
		//TODO: Turn off suit sensors and GPSes, like in SCP
	sleep(10 SECONDS)
	convertItem()
	outputPod.currentItem = outputItem
	intakePod.currentItem = null
	unlockPods()
	ejectPods()

/obj/machinery/scp_914/hub/Destroy()
	if(intakePod)
		intakePod.connectedHub = null
		intakePod.podNumber = 0
		intakePod = null
	if(outputPod)
		outputPod.connectedHub = null
		outputPod.podNumber = 0
		outputPod = null
	. = ..()