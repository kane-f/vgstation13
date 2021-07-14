/datum/wires/turret
	holder_type = /obj/machinery/turret
	wire_count = 5
    var/lethal = 0

/datum/wires/turret/New()
	wire_names=list(
		"[TURRET_POPUP]" 	= "Pop-Up",
		"[TURRET_SHOOT]" 	= "Shoot",
		"[TURRET_POWER]" 	= "Power",
		"[TURRET_LETHAL]" 	= "Lethals"
	)
	..()

var/const/TURRET_POPUP = 1 // Whether the turret is popped up or not
var/const/TURRET_SHOOT = 2 // Whether the turret is firing
var/const/TURRET_POWER = 4 // Whether the turret has power
var/const/TURRET_LETHAL = 8 // Whether the turret is on lethal mode (if possible)

/datum/wires/turret/CanUse(var/mob/living/L)
	if(!..())
		return 0
	var/obj/machinery/turret/T = holder
	if(T.panel_open)
		return 1
	return 0

/datum/wires/turret/GetInteractWindow()
	var/obj/machinery/media/transmitter/broadcast/T = holder
	. += ..()
	. += {"<BR>TThe inner gun lights are [[IsIndexCut(TURRET_POWER) ? "off" : [[IsIndexCut(TURRET_LETHAL) ? "on" : "glowing red"]].<BR>
	A red light is [[IsIndexCut(TURRET_POPUP) ? "off" : [[IsIndexCut(TURRET_SHOOT) ? "on" : "blinking"]].<BR>"}


/datum/wires/turret/UpdateCut(var/index, var/mended, var/mob/user)
	var/obj/machinery/turret/T = holder
	..()
	var/obj/I = user.get_active_hand()
	switch(index)
		if(TURRET_POWER)
			T.power_change()
			T.shock(user, 50, get_conductivity(I))
        if(TURRET_POPUP)
            if(mended)
                T.popUp()
            else
                T.popDown()
        if(TURRET_SHOOT)
            if(mended)
                T.setState(1,lethal)
            else
                T.setState(0,lethal)
        if(TURRET_LETHAL)
            if(mended)
                lethal = 0
                T.setState(T.enabled,lethal)
            else
                lethal = 1
                T.setState(T.enabled,lethal)

/datum/wires/turret/UpdatePulsed(var/index)
	var/obj/machinery/turret/T = holder
	..()
	switch(index)
		if(TURRET_POWER)
			T.power_change()
			T.shock(user, 50, get_conductivity(I))
        if(TURRET_POPUP)
            if(!T.raised)
                T.popUp()
            else
                T.popDown()
        if(TURRET_SHOOT)
            if(T.raised && T.enabled && T.check_target(user))
                T.shootAt(user)
        if(TURRET_LETHAL)
            lethal = !lethal
            T.setState(T.enabled,lethal)