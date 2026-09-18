heroTalent_npc_dota_hero_huskar = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_huskar", "heroTalent/heroTalent_npc_dota_hero_huskar", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_huskar:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_huskar:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_huskar:IsStealable() 				return true end
function heroTalent_npc_dota_hero_huskar:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_huskar:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_huskar" end


modifier_heroTalent_npc_dota_hero_huskar = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_huskar:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_huskar:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_huskar:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_huskar:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_huskar:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_huskar:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end

function modifier_heroTalent_npc_dota_hero_huskar:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_heroTalent_npc_dota_hero_huskar:AdvancedGetModifierConstantHealthRegen() 
    local regen = self.agi_regen*self:GetParent():GetAgility() + self.str_regen*self:GetParent():GetStrength() + self.int_regen*self:GetParent():GetIntellect(false)
    if self:GetParent():GetHealthPercent() < 50 then
        regen = self.index*regen
    end
    return regen 
end

function modifier_heroTalent_npc_dota_hero_huskar:OnCreated(keys)
    self.str_regen = self:GetAbility():GetSpecialValueFor("str_regen")
    self.agi_regen = self:GetAbility():GetSpecialValueFor("agi_regen")
    self.int_regen = self:GetAbility():GetSpecialValueFor("int_regen")
    self.index = self:GetAbility():GetSpecialValueFor("index")*0.01 + 1
end
