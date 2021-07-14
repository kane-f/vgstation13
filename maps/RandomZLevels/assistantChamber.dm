/obj/machinery/turret/angry
    name = "Angry Turret"

/obj/machinery/turret/angry/update_contents()
    if(!installed)
        installed = /obj/item/weapon/gun/energy/laser
    if(!wires.assemblies["[TURRET_POPUP]"])
		var/obj/item/device/assembly/prox_sensor/PS = new
		wires.Attach("[TURRET_POPUP]",PS)
	if(!wires.assemblies["[TURRET_SHOOT]"])
		var/obj/item/device/assembly/prox_sensor/PS = new
		wires.Attach("[TURRET_SHOOT]",PS)