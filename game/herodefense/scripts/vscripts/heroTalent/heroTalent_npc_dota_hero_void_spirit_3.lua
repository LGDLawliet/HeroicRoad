LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_void_spirit_3", "heroTalent/heroTalent_npc_dota_hero_void_spirit_3", LUA_MODIFIER_MOTION_NONE )


heroTalent_npc_dota_hero_void_spirit_3 = class({})

function heroTalent_npc_dota_hero_void_spirit_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_void_spirit_3"
end
--------------------
modifier_heroTalent_npc_dota_hero_void_spirit_3 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_void_spirit_3:RemoveOnDeath()return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_3:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_3:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:OnCreated(table)
    self.hp = self:GetAbility():GetSpecialValueFor("hp")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
    if IsServer() then 
        self:StartIntervalThink(1)
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:OnIntervalThink()
    self.bonus_hp = self:GetParent():GetStrength()*self.hp
    self.bonus_attack_speed = self:GetParent():GetAgility()*self.attack_speed
    self.bonus_spell_amp = self:GetParent():GetIntellect(false)*self.spell_amp
end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_heroTalent_npc_dota_hero_void_spirit_3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:OnTooltip()

        self._tooltip = (self._tooltip or 0) % 3 + 1
        if self._tooltip == 1 then
            return  self:AdvancedGetModifierHealthBonus()
        elseif self._tooltip == 2 then
            return self:GetModifierAttackSpeedBonus_Constant()
        elseif self._tooltip == 3 then
            return self:Advanced_GetModifierSpellAmplifyBonus()
        end

end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:AdvancedGetModifierHealthBonus()
    return self:GetParent():GetStrength()*self.hp
end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:GetModifierAttackSpeedBonus_Constant()
    return self:GetParent():GetAgility()*self.attack_speed
end

function modifier_heroTalent_npc_dota_hero_void_spirit_3:Advanced_GetModifierSpellAmplifyBonus()
    return self:GetParent():GetIntellect(false)*self.spell_amp
end
