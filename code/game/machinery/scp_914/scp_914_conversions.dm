// This function is where the real fun happens
/obj/machinery/scp_914/hub/proc/convertItem()
    // Reset variables
    outputItem = null
    outputAmount = 1
    switch(processType)
        if(STATE_COARSE)
            // If input item is humanoid
            if(ishuman(intakeItem))
                var/mob/living/carbon/human/H = intakeItem
                outputItem = H
            if(istype(intakeItem,/obj/item/stack/sheet/metal))
                outputItem = new /obj/item/stack/ore/iron
            if(istype(intakeItem,/obj/item/stack/sheet/mineral/plasma))
                outputItem = new /obj/item/stack/ore/plasma
            if(istype(intakeItem,/obj/item/stack/sheet/glass))
                outputItem = new /obj/item/stack/ore/glass
            if(istype(intakeItem,/obj/item/stack/sheet/mineral/gold))
                outputItem = new /obj/item/stack/ore/gold
            if(istype(intakeItem,/obj/item/stack/sheet/mineral/silver))
                outputItem = new /obj/item/stack/ore/silver
        if(STATE_ROUGH)
            // If input item is humanoid
            if(ishuman(intakeItem))
                var/mob/living/carbon/human/H = intakeItem
                // Scramble UI+UE
                scramble(1,H,100)
                // Seriously damage them
                H.adjustBruteLoss(100)
                H.adjustFireLoss(100)

                outputItem = H
            if(istype(intakeItem,/obj/item/stack/sheet/metal))
                outputItem = new /obj/item/stack/rods
        if(STATE_EQUAL)
            // If input item is humanoid
            if(ishuman(intakeItem))
                var/mob/living/carbon/human/H = intakeItem
                // Scramble UI+UE
                scramble(1,H,100)
                outputItem = H
                return
            // In other cases, item comes out the same, but reinstated
            outputItem = new intakeItem.type
        if(STATE_FINE)
            // If input item is humanoid
            if(ishuman(intakeItem))
                var/mob/living/carbon/human/H = intakeItem
                // Partially heal
                H.adjustBruteLoss(-H.getBruteLoss())
                H.adjustFireLoss(-H.getFireLoss())
                // Scramble UI+UE
                scramble(1,H,100)
                // Activate powers
                H.dna.SetSEState(XRAYBLOCK,1)
                H.dna.SetSEState(TELEBLOCK,1)
                H.dna.SetSEState(HULKBLOCK,1)
                H.dna.SetSEState(INCREASERUNBLOCK,1)
                H.dna.SetSEState(SMALLSIZEBLOCK,1)
                H.dna.SetSEState(COLDBLOCK,1)
                H.dna.SetSEState(NOBREATHBLOCK,1)
                H.dna.SetSEState(FIREBLOCK,1)
                genemutcheck(H,XRAYBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,TELEBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,HULKBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,INCREASERUNBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,SMALLSIZEBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,COLDBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,NOBREATHBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,FIREBLOCK,null,MUTCHK_FORCED)
                H.update_mutations()

                outputItem = H
            if(istype(intakeItem,/obj/item/stack/sheet/metal))
                outputItem = new /obj/item/stack/sheet/plasteel
			if(istype(intakeItem,/obj/item/stack/ore/iron))
                outputItem = new /obj/item/stack/sheet/metal
            if(istype(intakeItem,/obj/item/stack/ore/plasma))
                outputItem = new /obj/item/stack/sheet/mineral/plasma)
            if(istype(intakeItem,/obj/item/stack/ore/glass))
                outputItem = new /obj/item/stack/sheet/glass
            if(istype(intakeItem,/obj/item/stack/ore/gold))
                outputItem = new /obj/item/stack/sheet/mineral/gold
            if(istype(intakeItem,/obj/item/stack/ore/silver))
                outputItem = new /obj/item/stack/sheet/mineral/silver
        if(STATE_VFINE)
            // If input item is humanoid
            if(ishuman(intakeItem))
                var/mob/living/carbon/human/H = intakeItem
                // Call hivelord core esque rejeuvenate
                H.revive()
                // Scramble UI+UE
                scramble(1,H,100)
                // Activate powers
                H.dna.SetSEState(XRAYBLOCK,1)
                H.dna.SetSEState(TELEBLOCK,1)
                H.dna.SetSEState(INCREASERUNBLOCK,1)
                H.dna.SetSEState(SMALLSIZEBLOCK,1)
                H.dna.SetSEState(COLDBLOCK,1)
                H.dna.SetSEState(NOBREATHBLOCK,1)
                H.dna.SetSEState(FIREBLOCK,1)
                genemutcheck(H,XRAYBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,TELEBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,INCREASERUNBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,SMALLSIZEBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,COLDBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,NOBREATHBLOCK,null,MUTCHK_FORCED)
                genemutcheck(H,FIREBLOCK,null,MUTCHK_FORCED)
                H.update_mutations()
                // Add spells
                // TODO: pick 6 or so spells at random and give them

                // Add creatine so the player "dissolves" after a while, like in the SCP
                H.reagents.add_reagent(CREATINE, 30)
                // Finally, make survivor antag role, to emulate effects of attacking people like in the SCP
                if(H.mind && !isantagbanned(H))
                    for(var/datum/role/R in H.mind.antag_roles)
                        // If already in a faction, don't give this role
                        if(R.faction)
                            outputItem = H
                            return
                    var/datum/role/survivor/newSurvivor = new
                    newSurvivor.AssignToRole(H.mind,1)
                    newSurvivor.OnPostSetup()
                    newSurvivor.Greet()
                    newSurvivor.ForgeObjectives()
                    newSurvivor.AnnounceObjectives()
                outputItem = H
    // Failsafe in case nothing is set
    if (!outputItem)
        outputItem = intakeItem