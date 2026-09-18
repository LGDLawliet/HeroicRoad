
chaotic_ruby_reverse_radiation = class({})
LinkLuaModifier("modifier_chaotic_ruby_reverse_radiation", "chaotic_spell/class_7/chaotic_ruby_reverse_radiation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_ruby_reverse_radiation_advanced_debuff", "chaotic_spell/class_7/chaotic_ruby_reverse_radiation", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_ruby_reverse_radiation_advanced_buff", "chaotic_spell/class_7/chaotic_ruby_reverse_radiation", LUA_MODIFIER_MOTION_NONE)


function chaotic_ruby_reverse_radiation:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ruby_reverse_radiation/main_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_jump_armor_debuff.vpcf", context )
end

function chaotic_ruby_reverse_radiation:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_ruby_reverse_radiation:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function chaotic_ruby_reverse_radiation:GetCustomCastErrorTarget(target)
	return self.error
end

function chaotic_ruby_reverse_radiation:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if self:GetRuneType()==1 then
			-- print("22222222")
			if target:GetTeamNumber()==caster:GetTeamNumber() then
				return UF_SUCCESS
			end
		else
			if target:GetTeamNumber()==caster:GetTeamNumber() then
				return UF_FAIL_FRIENDLY 
			end
		end


		local result = self.BaseClass.CastFilterResultTarget(self,target)
		return result or UF_SUCCESS
	end
end







function chaotic_ruby_reverse_radiation:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	if not IsEnemy(target,caster) then
		local duration = self:GetSpecialValueFor("advanced_duration") * self:GetSpecialValueFor("rune_1_bonus")
		self:ApplyModifier_Friendly(target,duration)
		local count = self:GetSpecialValueFor("count")-1
		if caster:HasModifier("modifier_chaotic_summon_chaotic_executive_buff") then
			return
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(enemies) do
			if not unit:HasModifier("modifier_chaotic_ruby_reverse_radiation_advanced_buff") then
				count = count - 1
				self:ApplyModifier_Friendly(unit,duration)
				if count<=0 then
					break
				end
			end
		end
		return

	end

	self:ApplyModifier(target)
	local count = self:GetSpecialValueFor("count")-1
	-- if caster:HasModifier("modifier_chaotic_summon_chaotic_executive_buff") then
	-- 	return
	-- end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in ipairs(enemies) do
			count = count - 1
			self:ApplyModifier(unit)
			if count<=0 then
				break
			end
	end
end

function chaotic_ruby_reverse_radiation:ApplyModifier(target)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
	local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
	local burning = self:GetSpecialValueFor("burning")*caster:HDGetPrimaryStatValue()
	local advanced_duration = self:GetSpecialValueFor("advanced_duration")

	if self:GetRuneType()==2 then
		burning = burning*(1+self:GetSpecialValueFor("rune_2_bonus")*0.01)
		if target:HasModifier("modifier_hd_burning") then
			burning = burning*(1+self:GetSpecialValueFor("rune_2_bonus_2")*0.01)
		end
	end
	if self:GetRuneType()==3 then
		advanced_duration = advanced_duration - self:GetSpecialValueFor("rune_3_duration")
	end
	target:Burning(caster, self, burning)
	target:AddNewModifier(caster, self, "modifier_chaotic_ruby_reverse_radiation", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
	target:AddNewModifier(caster, self, "modifier_chaotic_ruby_reverse_radiation_advanced_debuff", {duration = advanced_duration*StatusResistance})


	EmitSoundOn("chaotic_ruby_reverse_radiation_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ruby_reverse_radiation/main_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	local dis = CalculateDistance(target,caster)
	local dir = CalculateDirection(target,caster)
	local randomRange = math.min(dis*0.1,450)
	ParticleManager:SetParticleControl(head_particle, 6, caster:GetAbsOrigin()+dir*dis*0.35 + RandomVector(randomRange) )
	ParticleManager:SetParticleControl(head_particle, 10, caster:GetAbsOrigin()+dir*dis*0.7 + RandomVector(randomRange) )


	ParticleManager:ReleaseParticleIndex(head_particle)
end

function chaotic_ruby_reverse_radiation:ApplyModifier_Friendly(target,duration)
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_ruby_reverse_radiation_advanced_buff", {duration = duration*gain})

	EmitSoundOn("chaotic_ruby_reverse_radiation_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ruby_reverse_radiation/main_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	local dis = CalculateDistance(target,caster)
	local dir = CalculateDirection(target,caster)
	local randomRange = math.min(dis*0.1,450)
	ParticleManager:SetParticleControl(head_particle, 6, caster:GetAbsOrigin()+dir*dis*0.35 + RandomVector(randomRange) )
	ParticleManager:SetParticleControl(head_particle, 10, caster:GetAbsOrigin()+dir*dis*0.7 + RandomVector(randomRange) )


	ParticleManager:ReleaseParticleIndex(head_particle)
end

---------

modifier_chaotic_ruby_reverse_radiation = modifier_chaotic_ruby_reverse_radiation or advanced_modifier({})
function modifier_chaotic_ruby_reverse_radiation:IsHidden()	return false end
function modifier_chaotic_ruby_reverse_radiation:IsDebuff()	return true end
function modifier_chaotic_ruby_reverse_radiation:IsStunDebuff()	return false end
function modifier_chaotic_ruby_reverse_radiation:IsPurgable()	return true end

function modifier_chaotic_ruby_reverse_radiation:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
	}
end


function modifier_chaotic_ruby_reverse_radiation:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return 1
end
function modifier_chaotic_ruby_reverse_radiation:GetEffectName() return "particles/units/heroes/hero_monkey_king/monkey_king_jump_armor_debuff.vpcf" end
function modifier_chaotic_ruby_reverse_radiation:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
-----------

modifier_chaotic_ruby_reverse_radiation_advanced_debuff = modifier_chaotic_ruby_reverse_radiation_advanced_debuff or advanced_modifier({})
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:IsHidden()	return false end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:IsDebuff()	return true end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:IsStunDebuff()	return true end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:IsPurgable()	return true end

function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:OnCreated( kv )
	local gain = self:GetAbility():GetEffectGain()
	self.magical_res_reduction = -self:GetAbility():GetSpecialValueFor("magical_res_reduction")*gain
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor("armor_reduction")*gain
end

function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:CheckState()
	if self:GetAbility():GetRuneType()==3 then
		return{
			[MODIFIER_STATE_PASSIVES_DISABLED] = true
		}
	end
end
function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:Advanced_GetModifierPhysicalArmorBonus(keys)
	if not self:GetAbility() then self:Destroy() return end
	return self.armor_reduction
end

function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then self:Destroy() return end
	return self.magical_res_reduction 
end

function modifier_chaotic_ruby_reverse_radiation_advanced_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 2 then
		return self:GetModifierMagicalResistanceBonus()
	end
end







modifier_chaotic_ruby_reverse_radiation_advanced_buff = modifier_chaotic_ruby_reverse_radiation_advanced_buff or advanced_modifier({})
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:IsHidden()	return false end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:IsDebuff()	return false end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:IsStunDebuff()	return true end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:IsPurgable()	return true end

function modifier_chaotic_ruby_reverse_radiation_advanced_buff:OnCreated( kv )
	

	self.magical_res_reduction = self:GetAbility():GetSpecialValueFor("magical_res_reduction")
	self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_chaotic_ruby_reverse_radiation_advanced_buff:Advanced_GetModifierPhysicalArmorBonus(keys)
	return self.armor_reduction
end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_ruby_reverse_radiation_advanced_buff:GetModifierMagicalResistanceBonus()	return self.magical_res_reduction end

function modifier_chaotic_ruby_reverse_radiation_advanced_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 2 then
		return self:GetModifierMagicalResistanceBonus()
	end
end