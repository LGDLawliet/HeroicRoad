
chaotic_savage_roar = class({})
LinkLuaModifier("modifier_chaotic_savage_roar", "chaotic_spell/class_4/chaotic_savage_roar", LUA_MODIFIER_MOTION_NONE)


function chaotic_savage_roar:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_savage_roar/effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_savage_roar/effect_hit/effect_hit.vpcf", context )


	
end


function chaotic_savage_roar:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	-- local target = self:GetCursorTarget() 
	local sound_cast = "Hero_LoneDruid.SavageRoar.Cast"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(caster)
	if self:GetRuneType()==1 then
		local radius = self:GetSpecialValueFor("rune_1_radius")
		local rune_1_duration = self:GetSpecialValueFor("rune_1_duration")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		for _, unit in ipairs(enemies) do
			local StatusResistance = unit:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
			unit:AddNewModifier(caster, self, "modifier_stunned", {duration = rune_1_duration*StatusResistance})
		end




		
		
	end
end

function chaotic_savage_roar:ApplyModifier(target)
	local particle_cast = "particles/rebuild/chaotic_era/chaotic_savage_roar/effect/effect.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	DestroyParticleByDelay(particle_cast_fx,1.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_savage_roar", {duration =  self:GetSpecialValueFor("duration")*gain})


	

end


modifier_chaotic_savage_roar = advanced_modifier({})

function modifier_chaotic_savage_roar:IsHidden() return false end
function modifier_chaotic_savage_roar:IsPurgable() return true end
function modifier_chaotic_savage_roar:IsDebuff() return false end
function modifier_chaotic_savage_roar:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.bonus_damage_percentage = ability:GetSpecialValueFor("bonus_damage_percentage")

	if IsServer() then
		self.record = {}
		-- local ability = self:GetAbility()
		self.attack_require = ability:GetSpecialValueFor("attack_require")
		self.heavy_attack_damage = ability:GetSpecialValueFor("heavy_attack_damage")

	end
end




function modifier_chaotic_savage_roar:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
		-- MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end


function modifier_chaotic_savage_roar:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,--攻击力
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,--攻击力百分比  （基于基础攻击力）
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = {self:GetParent(),nil},
    }
end


function modifier_chaotic_savage_roar:Advanced_GetModifierPreAttack_BonusDamage(keys)
	return self.bonus_damage
end


function modifier_chaotic_savage_roar:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
	return self.bonus_damage_percentage
end



function modifier_chaotic_savage_roar:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	self:IncrementStackCount()



end

function modifier_chaotic_savage_roar:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if self:GetStackCount()>=self.attack_require then
			if  keys.record and keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
				-- self.record[keys.record] = true
				self:SetStackCount(0)
				local target = keys.target
				-- print("check")
				local particle_cast = "particles/rebuild/chaotic_era/chaotic_savage_roar/effect_hit/effect_hit.vpcf"
				local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
				DestroyParticleByDelay(particle_cast_fx,1.5)
				return self.heavy_attack_damage
			end
		end
	end

end


-- function modifier_chaotic_savage_roar:OnAttackRecordDestroy(keys)
-- 	if self.record[keys.record] then
-- 		print("1111aaa")
--         self.record[keys.record] = nil
--     end
-- end


function modifier_chaotic_savage_roar:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
end
