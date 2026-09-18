
require("internal/timers")
Middle_Lightning_Bolt = class({})

function Middle_Lightning_Bolt:GetAOERadius()
	return self:GetSpecialValueFor("spread_aoe")	 
end

function Middle_Lightning_Bolt:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")

	return true
end

function Middle_Lightning_Bolt:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target 		= self:GetCursorTarget()
		local target_point 	= self:GetCursorPosition()

		if target:TriggerSpellAbsorb(self) then
			return
		end

		-- local movement_speed 	= 10
		-- local turn_rate 	 	= 1


		-- CustomNetTables:SetTableValue(
		-- "player_table", 
		-- tostring(self:GetCaster():GetPlayerOwnerID()), 
		-- { 	
		-- 	reduced_magic_resistance 	= reduced_magic_resistance,
		-- 	movement_speed 				= movement_speed,
		-- 	turn_rate 					= turn_rate
		-- })
		Middle_Lightning_Bolt:CastLightningBolt(caster, self, target, target_point)
	end
end

function Middle_Lightning_Bolt:CastLightningBolt(caster, ability, target, target_point, nimbus)
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




		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
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

		local target_flags = DOTA_UNIT_TARGET_FLAG_NONE



			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				target_flags, 
				FIND_FARTHEST, 
				false
			)
			if #nearby_enemy_units == 0 then
				return
			end
			local index = 0
			for _, unit in ipairs(nearby_enemy_units) do
				if unit~=target then
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, unit)
					local pos = unit:GetAbsOrigin()
					  ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
					ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
					ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
					ParticleManager:ReleaseParticleIndex(particle)
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
					index = index +1
					if index>=2 then
						break
					end
				end
				
			end




		-- --林肯阻挡
		-- if not nimbus and target then
		-- 	-- If the target possesses a ready Linken's Sphere, do nothing
		-- 	if target:GetTeam() ~= caster:GetTeam() then
		-- 		if target:TriggerSpellAbsorb(ability) then
		-- 			return nil
		-- 		end
		-- 	end
		-- end
		-- 创建马甲单位

		CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = sight_duration,stack=true_sight_radius},  Vector(target_point.x, target_point.y, 0), caster:GetTeamNumber(), false)


	end
end


