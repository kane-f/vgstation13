
/datum/artifact_effect/gasoxy
	effecttype = "gas"
	valid_style_types = list(ARTIFACT_STYLE_ANOMALY, ARTIFACT_STYLE_MARTIAN)
	effect = list(ARTIFACT_EFFECT_TOUCH, ARTIFACT_EFFECT_AURA)
	var/max_pressure
	copy_for_battery = list("max_pressure")
	var/effect_gas = null

/datum/artifact_effect/gasoxy/New()
	..()
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)
	effect_gas = pick(GAS_NITROGEN, GAS_OXYGEN, GAS_CARBON, GAS_PLASMA, GAS_SLEEPING)


/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/user)
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.adjust_gas(effect_gas, rand(2,15))

/datum/artifact_effect/gasoxy/DoEffectAura()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.pressure < max_pressure)
			env.adjust_gas(effect_gas, pick(0, 0, 0.1, rand()))
