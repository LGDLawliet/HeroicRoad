item_hd_invis_sword = class({})
-- LinkLuaModifier("modifier_item_hd_invis_sword_arua", "items/item_hd_invis_sword", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_invis_sword_arua_effect", "items/item_hd_invis_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_invis_sword", "items/item_hd_invis_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_invis_sword_active", "items/item_hd_invis_sword", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_invis_sword:GetIntrinsicModifierName()
	return "modifier_item_hd_invis_sword"
end


function item_hd_invis_sword:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)
	local duration = caster:IsInNightTime() and self:GetSpecialValueFor("invisible_duration_night") or self:GetSpecialValueFor("invisible_duration")
	Timers:CreateTimer(0.3, function()

		local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

		caster:AddNewModifier(caster, self, "modifier_item_hd_invis_sword_active", {duration = duration})
	end)
end

---------------------------------------------------------------------------------

modifier_item_hd_invis_sword = advanced_modifier({})

function modifier_item_hd_invis_sword:IsDebuff() return false end
function modifier_item_hd_invis_sword:IsHidden() return true end
function modifier_item_hd_invis_sword:IsPurgable() return false end


function modifier_item_hd_invis_sword:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")

    if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_item_hd_invis_sword:OnIntervalThink()

	if self:GetParent():IsInNightTime() then
		self:SetStackCount(2)
	else
		self:SetStackCount(1)
	end
	self:SetHasCustomTransmitterData(true)

end

function modifier_item_hd_invis_sword:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,          
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,          
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          
	}
end
function modifier_item_hd_invis_sword:DeclareFunctions()
	return {
  
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
	}
end


function modifier_item_hd_invis_sword:Advanced_GetModifierBonusStats_Strength()	return self.bonus_atb*self:GetStackCount() end
function modifier_item_hd_invis_sword:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_atb*self:GetStackCount() end
function modifier_item_hd_invis_sword:Advanced_GetModifierBonusStats_Agility()	return self.bonus_atb*self:GetStackCount() end
function modifier_item_hd_invis_sword:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end

-----------------------------------------------------------------------------------------------------------------------------------------

modifier_item_hd_invis_sword_active = advanced_modifier({})

function modifier_item_hd_invis_sword_active:IsDebuff() return false end
function modifier_item_hd_invis_sword_active:IsHidden() return false end
function modifier_item_hd_invis_sword_active:IsPurgable() return false end
function modifier_item_hd_invis_sword_active:GetTexture()return "item_invis_sword" end

function modifier_item_hd_invis_sword_active:OnCreated(table)
	if IsServer() then
		self.bonus_attack_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("break_damage")
	end
end



function modifier_item_hd_invis_sword_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end
function modifier_item_hd_invis_sword_active:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end

function modifier_item_hd_invis_sword_active:GetModifierInvisibilityLevel()return 1 end

function modifier_item_hd_invis_sword_active:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_item_hd_invis_sword_active:GetModifierPreAttack_BonusDamagePostCrit(params) return self.bonus_attack_damage end
function modifier_item_hd_invis_sword_active:GetModifierMoveSpeedBonus_Percentage()		return self:GetAbility():GetSpecialValueFor("move_active")	end


function modifier_item_hd_invis_sword_active:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:SafeDestroy()
		end
	end
end

function modifier_item_hd_invis_sword_active:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		if keys.unit == parent then
			self:SafeDestroy()
		end
	end
end

