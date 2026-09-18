heroTalent_npc_dota_hero_visage_3 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_visage_3", "heroTalent/heroTalent_npc_dota_hero_visage_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_visage_3_debuff", "heroTalent/heroTalent_npc_dota_hero_visage_3", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_visage_3:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf", context)
end

function heroTalent_npc_dota_hero_visage_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_visage_3"
end

modifier_heroTalent_npc_dota_hero_visage_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_visage_3:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_visage_3:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_visage_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_visage_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_visage_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_visage_3:OnCreated()
    self.ability = self:GetAbility()
    self.interval = self.ability:GetSpecialValueFor("interval")
    self.max_stack = self.ability:GetSpecialValueFor("max_stack")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.line = self.ability:GetSpecialValueFor("line")*0.01
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.radius = self.ability:GetSpecialValueFor("radius")

    self.talentgain = self.ability:GetTalentGain(0.5)
    self.interval_t = self.interval/self.talentgain
    self.duration_t = self.duration*self.talentgain

    if not IsServer() then return end
    self:SetStackCount(0)
    self.damage_taken = 0
    self.time = 0
    self:StartIntervalThink(1)
end

function modifier_heroTalent_npc_dota_hero_visage_3:OnIntervalThink()
    self.time = self.time + 1
    self.talentgain = self.ability:GetTalentGain(0.5)
    self.interval_t = self.interval/self.talentgain
    self.duration_t = self.duration*self.talentgain

    if self.time >= self.interval_t then
        self.time = 0
        self:SetStackCount(math.min(self:GetStackCount()+1, self.max_stack))
    end
end

function modifier_heroTalent_npc_dota_hero_visage_3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()}
    }
end

function modifier_heroTalent_npc_dota_hero_visage_3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_visage_3:Advanced_GetModifierIncomingDamage_Percentage(keys)
    return -self:GetStackCount() * self.incoming
end

function modifier_heroTalent_npc_dota_hero_visage_3:OnTakeDamage(keys)
    if not IsServer() then return end
    local unit = keys.unit
    local attacker = keys.attacker
    local caster = self:GetCaster()
    if unit ~= caster then return end
    if not IsEnemy(unit,attacker) then return end
    
    self.damage_taken = self.damage_taken + keys.damage
    local threshold = caster:GetMaxHealth() * self.line
    
    if self.damage_taken >= threshold then
        self.damage_taken = 0
        if self:GetStackCount() > 0 then
            self:SetStackCount(math.max(self:GetStackCount()-1,0))
            self:TriggerPetrify()
        end
    end
end

function modifier_heroTalent_npc_dota_hero_visage_3:TriggerPetrify()
    local caster = self:GetParent()
    local radius = self.radius
    local duration = self.duration_t
    
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    
    for _, unit in pairs(units) do
        unit:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_visage_3_debuff", {duration = duration})
    end
end

function modifier_heroTalent_npc_dota_hero_visage_3:OnTooltip()
    self.talentgain = self.ability:GetTalentGain(0.5)
    self.interval_t = self.interval/self.talentgain
    self.duration_t = self.duration*self.talentgain

    self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self:GetStackCount()*self.incoming
	end
	if self._tooltip == 2 then
		return  self.interval_t
	end
	if self._tooltip == 3 then
		return  self.duration_t
	end
end

modifier_heroTalent_npc_dota_hero_visage_3_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_visage_3_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_visage_3_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_visage_3_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_visage_3_debuff:IsPurgeException() return false end

function modifier_heroTalent_npc_dota_hero_visage_3_debuff:GetEffectName()
    return "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_visage_3_debuff:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
end

function modifier_heroTalent_npc_dota_hero_visage_3_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_heroTalent_npc_dota_hero_visage_3_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -200
end
