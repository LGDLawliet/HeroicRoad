heroTalent_npc_dota_hero_death_prophet = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_death_prophet", "heroTalent/heroTalent_npc_dota_hero_death_prophet", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_death_prophet_debuff", "heroTalent/heroTalent_npc_dota_hero_death_prophet", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_death_prophet_health", "heroTalent/heroTalent_npc_dota_hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_death_prophet:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_death_prophet:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_death_prophet:IsStealable() 				return true end
function heroTalent_npc_dota_hero_death_prophet:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_death_prophet:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_death_prophet" end


modifier_heroTalent_npc_dota_hero_death_prophet = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_death_prophet:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_death_prophet:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_death_prophet:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_death_prophet:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_death_prophet:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_death_prophet:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end
function modifier_heroTalent_npc_dota_hero_death_prophet:Advanced_GetModifierSpellAmplifyBonus() return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_death_prophet:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then

        local bonus = math.min(self:GetAbility():GetSpecialValueFor("max_bonus"),self:GetStackCount()+self:GetAbility():GetSpecialValueFor("bonus_per_death"))
        if bonus>self:GetStackCount() then
            self:SetStackCount(bonus)
        end
        
        local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_ti9.vpcf", PATTACH_ABSORIGIN,  keys.unit)
        local pos =  keys.unit:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(300,0,0))

        ParticleManager:ReleaseParticleIndex(particle_cast_fx)
        keys.unit:EmitSound("Hero_DeathProphet.Silence")
    end
end
function modifier_heroTalent_npc_dota_hero_death_prophet:AdvancedOnDeathAgain(keys)
    if not IsServer() then
        return
    end
    local max_bonus = math.min(self:GetAbility():GetSpecialValueFor("max_bonus") *keys.mul_index,self:GetAbility():GetSpecialValueFor("falase_death_max_bonus"))
    local bonus = math.min(max_bonus,self:GetStackCount()+self:GetAbility():GetSpecialValueFor("bonus_per_death")*keys.mul_index)
    if bonus>self:GetStackCount() then
        self:SetStackCount(bonus)
    end

    local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_ti9.vpcf", PATTACH_ABSORIGIN,  keys.unit)
    local pos =  keys.unit:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
    ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(300,0,0))

    ParticleManager:ReleaseParticleIndex(particle_cast_fx)
    keys.unit:EmitSound("Hero_DeathProphet.Silence")
end


function modifier_heroTalent_npc_dota_hero_death_prophet:OnWaveStart()
    self:SetStackCount(self:GetStackCount()*(1-self:GetAbility():GetSpecialValueFor("lose_effect")*0.01))
end

function modifier_heroTalent_npc_dota_hero_death_prophet:OnWaveEnd()
    -- self:SetStackCount(0)
end

function modifier_heroTalent_npc_dota_hero_death_prophet:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

