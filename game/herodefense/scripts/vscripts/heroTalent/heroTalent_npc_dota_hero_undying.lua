heroTalent_npc_dota_hero_undying = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying", "heroTalent/heroTalent_npc_dota_hero_undying", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_effect", "heroTalent/heroTalent_npc_dota_hero_undying", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_noeffect", "heroTalent/heroTalent_npc_dota_hero_undying", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_undying:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_undying"
end



modifier_heroTalent_npc_dota_hero_undying = class({})

function modifier_heroTalent_npc_dota_hero_undying:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_undying:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_undying:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_undying:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_undying:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.ori_need = self:GetAbility():GetSpecialValueFor("ori_need")
		self:StartIntervalThink(0.5)	
	end
end


function modifier_heroTalent_npc_dota_hero_undying:OnIntervalThink()
	local unit = self:GetParent()
	local need = self.ori_need
	if unit:GetHealthPercent() >=  need then
		unit:AddNewModifier(unit, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_undying_effect", {duration = 0.75})
	else
		unit:AddNewModifier(unit, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_undying_noeffect", {duration = 0.75})
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_undying_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_undying_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_undying_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_undying_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_undying_effect:GetEffectName() return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf" end
function modifier_heroTalent_npc_dota_hero_undying_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_heroTalent_npc_dota_hero_undying_effect:OnCreated(keys)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Undying.FleshGolem.Cast")
		self:GetParent():StartGesture(ACT_DOTA_SPAWN)

		self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
		self.status = self:GetAbility():GetSpecialValueFor("status")
		self.armor = self:GetAbility():GetSpecialValueFor("armor")
	end
end

function modifier_heroTalent_npc_dota_hero_undying_effect:OnRefresh(keys)
	if IsServer() then
		self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
		self.status = self:GetAbility():GetSpecialValueFor("status")
		self.armor = self:GetAbility():GetSpecialValueFor("armor")
	end
end


function modifier_heroTalent_npc_dota_hero_undying_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_MODEL_CHANGE

	}
end

function modifier_heroTalent_npc_dota_hero_undying_effect:GetModifierMagicalResistanceBonus() 
	--return self.magic_resist
	return 30
end

function modifier_heroTalent_npc_dota_hero_undying_effect:GetModifierModelChange() return "models/items/undying/flesh_golem/spring2021_bristleback_paganism_pope_golem/spring2021_bristleback_paganism_pope_golem.vmdl" end


function modifier_heroTalent_npc_dota_hero_undying_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_heroTalent_npc_dota_hero_undying_effect:Advanced_GetModifierPhysicalArmorBonus()
    --return self.armor
	return 15

end



function modifier_heroTalent_npc_dota_hero_undying_effect:Advanced_GetModifier_StatusResistance(keys)
	--return self.status
	return 30
end

-------------------------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_undying_noeffect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_undying_noeffect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_undying_noeffect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_undying_noeffect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying_noeffect:IsPurgeException() return false end


function modifier_heroTalent_npc_dota_hero_undying_noeffect:OnCreated(keys)
	if IsClient() then
		return
	end
	self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")

end


function modifier_heroTalent_npc_dota_hero_undying_noeffect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_undying_noeffect:AdvancedGetModifierConstantHealthRegenPercentage()
    return self.hp_regen
end


