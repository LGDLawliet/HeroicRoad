LinkLuaModifier("modifier_item_hd_stormcrafter_active", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)

Primary_Thundergods_Wrath = class({})

function Primary_Thundergods_Wrath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath")

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	return true
end

function Primary_Thundergods_Wrath:GetAOERadius()
	return 1500
end

function Primary_Thundergods_Wrath:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end

function Primary_Thundergods_Wrath:OnSpellStart() 
	if IsServer() then
		local ability 				= self
		local caster 				= self:GetCaster()
		local position 				= self:GetCaster():GetAbsOrigin()	
		CreateModifierThinker(caster, self, "modifier_true_sight_dummy", {duration = 4,stack=700},  position, caster:GetTeamNumber(), false)
		local stunduration = ability:GetSpecialValueFor("stun_duration")
		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end
		-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			position , 
			nil, 
			ability:GetSpecialValueFor("radius"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST, 
			false
		)
		local i = 0
		local damage = ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
	
		if #nearby_enemy_units ~= 0 then
			local unit = caster
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
			ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
			ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			ParticleManager:ReleaseParticleIndex(particle)
			
			local totalDamage = 0
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			--命石：雷神之怒，雷暴
			local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_stormcrafter")
			if equip_sp then
				damage = (ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)) * (1-equip_sp:GetAbility():GetSpecialValueFor("damage_down")*0.01)
				local equip_sp_active = self:GetCaster():FindModifierByName("modifier_item_hd_stormcrafter_active")
				if not equip_sp_active then
					self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_hd_stormcrafter_active",{duration = equip_sp:GetAbility():GetSpecialValueFor("storm_duration")})
				end
			end

			for _, unit in pairs(nearby_enemy_units) do
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
				local pos = unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
				ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
				ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
				ParticleManager:ReleaseParticleIndex(particle)
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stunduration * StatusResistance})
				unit:EmitSound("Hero_Zuus.GodsWrath.Target")
	
	
				local damage_table 			= {}
				damage_table.attacker 		= caster
				damage_table.ability 		= ability
				damage_table.damage_type 	= ability:GetAbilityDamageType() 
				damage_table.damage			= damage
				damage_table.victim 		= unit
				damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
				local damage = ApplyDamage(damage_table)
				i=i+1
				totalDamage = totalDamage + damage
				if i>=20 then
					break
				end
			end
		end
	end
end

