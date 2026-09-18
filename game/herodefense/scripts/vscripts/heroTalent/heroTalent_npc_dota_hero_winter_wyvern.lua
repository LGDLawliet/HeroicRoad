heroTalent_npc_dota_hero_winter_wyvern = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_winter_wyvern", "heroTalent/heroTalent_npc_dota_hero_winter_wyvern", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_winter_wyvern_effect", "heroTalent/heroTalent_npc_dota_hero_winter_wyvern", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_winter_wyvern:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_winter_wyvern" end
function heroTalent_npc_dota_hero_winter_wyvern:GetCastRange()
    local caster = self:GetCaster()
    return self:GetSpecialValueFor("aura_radius")- caster:GetCastRangeBonus()
end

---------------
modifier_heroTalent_npc_dota_hero_winter_wyvern = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_winter_wyvern:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_winter_wyvern:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.int = self.ability:GetSpecialValueFor("int")
    self.radius = self.ability:GetSpecialValueFor("aura_radius")
    self.aura_int = self.ability:GetSpecialValueFor("aura_int")

	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_int_t = self.aura_int * self.talentgain

    if IsServer() then
        self:StartIntervalThink(2)
        self:OnIntervalThink()
    end
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern:OnIntervalThink()
    self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_int_t = self.aura_int * self.talentgain

    self.final_aura_int = self.aura_int_t*self.parent:GetLevel()
    if self.parent:IsAlive() then
        local heroes = GetAllRealHeroes()
        for _, hero in pairs(heroes) do
            if hero:IsAlive() and CalculateDistance(self.parent, hero) <= self.radius then
                local buff = hero:FindModifierByName("modifier_heroTalent_npc_dota_hero_winter_wyvern_effect")
                if buff then
                    buff:SetStackCount(self.final_aura_int)
                    buff:SetDuration(2, true)
                else
                    local newbuff = hero:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_winter_wyvern_effect", {duration = 2})
                    newbuff:SetStackCount(self.final_aura_int)
                end
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BONUS_INT_PER_LEVEL,
    }
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:Advanced_GetModifierBonusINT_PerLevel()
    return self.int
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_int_t = self.aura_int * self.talentgain

	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self.aura_int_t*self.parent:GetLevel()
    end
end
----------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_winter_wyvern_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:Advanced_GetModifierBonusStats_Intellect()		return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_effect:OnTooltip()
	return self:GetStackCount()
end