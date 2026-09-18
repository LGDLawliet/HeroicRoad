LinkLuaModifier("modifier_heroTalent_npc_dota_hero_jakiro_3", "heroTalent/heroTalent_npc_dota_hero_jakiro_3.lua", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_jakiro_3 = class({})

function heroTalent_npc_dota_hero_jakiro_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_jakiro_3"
end

-- 主被动管理modifier
modifier_heroTalent_npc_dota_hero_jakiro_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_jakiro_3:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_3:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_3:DestroyOnExpire() return false end

function modifier_heroTalent_npc_dota_hero_jakiro_3:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
    self.burning = self.ability:GetSpecialValueFor("burning")
    self.base_burning = self.ability:GetSpecialValueFor("base_burning")
    self.level = self.ability:GetSpecialValueFor("level")
    self.base_freezing = self.ability:GetSpecialValueFor("base_freezing")
    self.freezing = self.ability:GetSpecialValueFor("freezing")

    self.talentgain = self.ability:GetTalentGain(0.8)
	self.burning_t = self.burning*self.talentgain
	self.freezing_t = self.freezing*self.talentgain

    self:SetStackCount(0)
end

function modifier_heroTalent_npc_dota_hero_jakiro_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_jakiro_3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_heroTalent_npc_dota_hero_jakiro_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if IsServer() then
        if keys.damage_category and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
            return -200
        end
    end
end
function modifier_heroTalent_npc_dota_hero_jakiro_3:Advanced_GetModifierAttackSpeedPercentage()
    return self.attack_speed
end
function modifier_heroTalent_npc_dota_hero_jakiro_3:OnTooltip()
    self.talentgain = self.ability:GetTalentGain(0.8)
	self.burning_t = self.burning*self.talentgain
	self.freezing_t = self.freezing*self.talentgain

    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.parent:GetLevel()*self.burning_t
    end
    if self._tooltip == 2 then
        return self.parent:GetLevel()*self.freezing_t
    end
end

function modifier_heroTalent_npc_dota_hero_jakiro_3:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
    if not attacker or attacker ~= self.parent then return end
    if not target or not target:IsAlive() then return end

    self.talentgain = self.ability:GetTalentGain(0.8)
	if self:GetStackCount() == 0 then
		self:SetStackCount(1)
        self.burning_t = self.burning*self.talentgain
        local burning = attacker:GetLevel()*self.burning_t*attacker:HDGetPrimaryStatValue() + self.base_burning

        target:Burning(attacker, self.ability, burning)
    else
        self:SetStackCount(0)
        self.freezing_t = self.freezing*self.talentgain
        local freezing = attacker:GetLevel()*self.freezing_t*attacker:HDGetPrimaryStatValue() + self.base_freezing

        target:Freezing(attacker, self.ability, freezing)
    end
end