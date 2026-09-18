heroTalent_npc_dota_hero_silencer_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer_3", "heroTalent/heroTalent_npc_dota_hero_silencer_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer_3_debuff", "heroTalent/heroTalent_npc_dota_hero_silencer_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_silencer_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_silencer_3"
end
function heroTalent_npc_dota_hero_silencer_3:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

modifier_heroTalent_npc_dota_hero_silencer_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_silencer_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_silencer_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_silencer_3:GetPriority() return 500 end
function modifier_heroTalent_npc_dota_hero_silencer_3:OnCreated(table)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

	self.radius = self.ability:GetSpecialValueFor("radius")
	self.line = self.ability:GetSpecialValueFor("line")
    self.level = self.ability:GetSpecialValueFor("level")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.max = self.ability:GetSpecialValueFor("max")

    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.8)
    self.max_t = self.max*self.talentgain1
    self.incoming_t = self.incoming*self.talentgain2
end
function modifier_heroTalent_npc_dota_hero_silencer_3:CheckState()
    if self:GetParent():GetLevel() >= self.level then
        return{
            [MODIFIER_STATE_SILENCED] = false
        }
    else
        return
    end
end

function modifier_heroTalent_npc_dota_hero_silencer_3:DeclareFunctions()
	return{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_silencer_3:OnTooltip()
    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.8)
    self.max_t = self.max*self.talentgain1
    self.incoming_t = self.incoming*self.talentgain2
	
    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.max_t
    end
    if self._tooltip == 2 then
        return self.incoming_t
    end
end

function modifier_heroTalent_npc_dota_hero_silencer_3:OnAbilityExecuted(keys)
    if not IsServer() then return end
    local ability = keys.ability
    local unit = keys.unit
    local distance = CalculateDistance(unit, self.parent)

    if ability:GetCooldown(keys.ability:GetLevel()) < self.line then return end--冷却时间不低于
    if distance > self.radius+50 or IsEnemy(unit, self.parent) or not unit:IsRealHero() then return end--友军英雄放，并且在自身周围

    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.8)
    self.max_t = self.max*self.talentgain1
    self.incoming_t = self.incoming*self.talentgain2

    local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i,enemy in pairs(enemies) do
        local StatusResistance = enemy:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
        local duration = self.duration*StatusResistance
        enemy:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_silencer_3_debuff", {duration = duration, incoming = self.incoming_t*10})

        if i >= self.max_t then
            break
        end
    end
end

--
modifier_heroTalent_npc_dota_hero_silencer_3_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:OnCreated(keys)
    if IsServer() then
        self.incoming = keys.incoming
        self:SetStackCount(self.incoming)
    end
end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:GetStackCount()*0.1
    end
end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not self:GetAbility() then return end
    if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
        return self:GetStackCount()*0.1
    end
end
function modifier_heroTalent_npc_dota_hero_silencer_3_debuff:CheckState()
    return{
        [MODIFIER_STATE_SILENCED] = true
    }
end
