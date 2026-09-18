heroTalent_npc_dota_hero_vengefulspirit = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_vengefulspirit", "heroTalent/heroTalent_npc_dota_hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_vengefulspirit_effect", "heroTalent/heroTalent_npc_dota_hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_vengefulspirit_active", "heroTalent/heroTalent_npc_dota_hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_vengefulspirit:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_vengefulspirit:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_vengefulspirit:IsStealable() 				return true end
function heroTalent_npc_dota_hero_vengefulspirit:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_vengefulspirit:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_vengefulspirit" end


modifier_heroTalent_npc_dota_hero_vengefulspirit = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_vengefulspirit:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_vengefulspirit:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:OnCreated()
    self.creep = self:GetAbility():GetSpecialValueFor("creep")
    self.hero = self:GetAbility():GetSpecialValueFor("hero")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_heroTalent_npc_dota_hero_vengefulspirit:ADDeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
    } 
end

function modifier_heroTalent_npc_dota_hero_vengefulspirit:OnDeath(keys)
    if not IsServer() then
        return
    end
    if not self:GetParent():IsRealHero() then
		return false
	end
    if not keys.attacker then
        return
    end
    if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        local target = keys.attacker
        local stack = self.creep
        if keys.unit:IsRealHero() then
            stack = self.hero
        end
        local caster = self:GetParent()
        local ability =self:GetAbility()
     
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
        target:AddNewModifier( caster,ability,"modifier_heroTalent_npc_dota_hero_vengefulspirit_effect", {stack=stack})
        self:GetCaster():AddNewModifier( caster,ability,"modifier_heroTalent_npc_dota_hero_vengefulspirit_active", {stack=stack,duration = self.duration})
    end
end

function modifier_heroTalent_npc_dota_hero_vengefulspirit:AdvancedOnDeathAgain(keys)
        local stack = self.hero
        local stack = stack * keys.mul_index
        local caster = self:GetParent()
        local ability =self:GetAbility()
        self:GetCaster():AddNewModifier( caster,ability,"modifier_heroTalent_npc_dota_hero_vengefulspirit_active", {stack=stack,duration = self.duration,mul_index = keys.mul_index})
end



---------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_vengefulspirit_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:IsDebuff()			return true end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(math.min(keys.stack,self:GetAbility():GetSpecialValueFor("max")))     
    end
end

function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(math.min(self:GetStackCount()+keys.stack,self:GetAbility():GetSpecialValueFor("max")))     
    end
end


function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:Advanced_GetModifierIncomingDamage_Percentage( params ) return self:GetStackCount() end


function modifier_heroTalent_npc_dota_hero_vengefulspirit_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
---------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_vengefulspirit_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:OnCreated(keys)
    if IsServer() then
        local mul = keys.mul_index or 1
        self:SetStackCount(math.min(keys.stack,math.floor(self:GetAbility():GetSpecialValueFor("max") * mul)))     
    end
end

function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:OnRefresh(keys)
    if IsServer() then
        local mul = keys.mul_index or 1
        self:SetStackCount(math.min(self:GetStackCount()+keys.stack,math.floor(self:GetAbility():GetSpecialValueFor("max") * mul)))     
    end
end


function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:Advanced_GetModifierBonusStats_Strength() return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:Advanced_GetModifierBonusStats_Agility() return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:Advanced_GetModifierBonusStats_Intellect() return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_vengefulspirit_active:ADDeclareFunctions()
	local funcs = 
    {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
	return funcs
end

