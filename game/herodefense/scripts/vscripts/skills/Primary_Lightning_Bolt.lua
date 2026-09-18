
require("internal/timers")
Primary_Lightning_Bolt = class({})



function Primary_Lightning_Bolt:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")

	return true
end

function Primary_Lightning_Bolt:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target 		= self:GetCursorTarget()
		local target_point 	= self:GetCursorPosition()

		if target:TriggerSpellAbsorb(self) then
			return
		end

		Primary_Lightning_Bolt:CastLightningBolt(caster, self, target, target_point)
	end
end

function Primary_Lightning_Bolt:CastLightningBolt(caster, ability, target, target_point, nimbus)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")

		local z_pos 				= 2000

		if nimbus then
			nimbus:EmitSound("Hero_Zuus.LightningBolt")
		else
			caster:EmitSound("Hero_Zuus.LightningBolt")
		end
		if target == nil then
			return
		end

		target_point = target:GetAbsOrigin()
		local damage = ability:GetSpecialValueFor("basic_damage") +ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
		local unit = target




		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, unit)
		-- local pos = unit:GetAbsOrigin()
		-- ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
		-- ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
		-- ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		-- ParticleManager:DestroyParticle(effect_cast, false)
		ParticleManager:ReleaseParticleIndex( particle )
		





		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * StatusResistance})
		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= damage 
		damage_table.victim 		= unit
		damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		ApplyDamage(damage_table)





		CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = sight_duration,stack=true_sight_radius},  Vector(target_point.x, target_point.y, 0), caster:GetTeamNumber(), false)



	end
end

