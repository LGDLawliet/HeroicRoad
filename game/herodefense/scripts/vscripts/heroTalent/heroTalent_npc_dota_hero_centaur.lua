heroTalent_npc_dota_hero_centaur = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_centaur", "heroTalent/heroTalent_npc_dota_hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_centaur_effect", "heroTalent/heroTalent_npc_dota_hero_centaur", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_centaur:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_centaur" end
function heroTalent_npc_dota_hero_centaur:GetCastRange()
    local caster = self:GetCaster()
    return self:GetSpecialValueFor("aura_radius")- caster:GetCastRangeBonus()
end

---------------
modifier_heroTalent_npc_dota_hero_centaur = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_centaur:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_centaur:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_centaur:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_centaur:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_centaur:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_centaur:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.str = self.ability:GetSpecialValueFor("str")
    self.radius = self.ability:GetSpecialValueFor("aura_radius")
    self.aura_str = self.ability:GetSpecialValueFor("aura_str")

	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_str_t = self.aura_str * self.talentgain

    if IsServer() then
        self:StartIntervalThink(2)
        self:OnIntervalThink()
    end
end

function modifier_heroTalent_npc_dota_hero_centaur:OnIntervalThink()
    self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_str_t = self.aura_str * self.talentgain

    self.final_aura_str = self.aura_str_t*self.parent:GetLevel()
    if self.parent:IsAlive() then
        local heroes = GetAllRealHeroes()
        for _, hero in pairs(heroes) do
            if hero:IsAlive() and CalculateDistance(self.parent, hero) <= self.radius then
                local buff = hero:FindModifierByName("modifier_heroTalent_npc_dota_hero_centaur_effect")
                if buff then
                    buff:SetStackCount(self.final_aura_str)
                    buff:SetDuration(2, true)
                else
                    local newbuff = hero:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_centaur_effect", {duration = 2})
                    newbuff:SetStackCount(self.final_aura_str)
                end
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_centaur:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL,
    }
end
function modifier_heroTalent_npc_dota_hero_centaur:Advanced_GetModifierBonusSTR_PerLevel()
    return self.str
end
function modifier_heroTalent_npc_dota_hero_centaur:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_centaur:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(1.2)
	self.aura_str_t = self.aura_str * self.talentgain

	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self.aura_str_t*self.parent:GetLevel()
    end
end
----------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_centaur_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_centaur_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_centaur_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_centaur_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_centaur_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_centaur_effect:Advanced_GetModifierBonusStats_Strength()		return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_centaur_effect:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_centaur_effect:OnTooltip()
	return self:GetStackCount()
end