heroTalent_npc_dota_hero_drow_ranger = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_drow_ranger", "heroTalent/heroTalent_npc_dota_hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_drow_ranger_effect", "heroTalent/heroTalent_npc_dota_hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_drow_ranger:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_drow_ranger" end
function heroTalent_npc_dota_hero_drow_ranger:GetCastRange()
    local caster = self:GetCaster()
    return self:GetSpecialValueFor("aura_radius")- caster:GetCastRangeBonus()
end

---------------
modifier_heroTalent_npc_dota_hero_drow_ranger = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_drow_ranger:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_drow_ranger:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.agi = self.ability:GetSpecialValueFor("agi")
    self.radius = self.ability:GetSpecialValueFor("aura_radius")
    self.aura_agi = self.ability:GetSpecialValueFor("aura_agi")

	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_agi_t = self.aura_agi * self.talentgain

    if IsServer() then
        self:StartIntervalThink(2)
        self:OnIntervalThink()
    end
end

function modifier_heroTalent_npc_dota_hero_drow_ranger:OnIntervalThink()
    self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_agi_t = self.aura_agi * self.talentgain

    self.final_aura_agi = self.aura_agi_t*self.parent:GetLevel()
    if self.parent:IsAlive() then
        local heroes = GetAllRealHeroes()
        for _, hero in pairs(heroes) do
            if hero:IsAlive() and CalculateDistance(self.parent, hero) <= self.radius then
                local buff = hero:FindModifierByName("modifier_heroTalent_npc_dota_hero_drow_ranger_effect")
                if buff then
                    buff:SetStackCount(self.final_aura_agi)
                    buff:SetDuration(2, true)
                else
                    local newbuff = hero:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_drow_ranger_effect", {duration = 2})
                    newbuff:SetStackCount(self.final_aura_agi)
                end
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_drow_ranger:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BONUS_AGI_PER_LEVEL,
    }
end
function modifier_heroTalent_npc_dota_hero_drow_ranger:Advanced_GetModifierBonusAGI_PerLevel()
    return self.agi
end
function modifier_heroTalent_npc_dota_hero_drow_ranger:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_drow_ranger:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_agi_t = self.aura_agi * self.talentgain

	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self.aura_agi_t*self.parent:GetLevel()
    end
end
----------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_drow_ranger_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:Advanced_GetModifierBonusStats_Agility()		return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_effect:OnTooltip()
	return self:GetStackCount()
end