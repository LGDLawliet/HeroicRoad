heroTalent_npc_dota_hero_clinkz = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_clinkz", "heroTalent/heroTalent_npc_dota_hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_clinkz_damage", "heroTalent/heroTalent_npc_dota_hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_clinkz_health", "heroTalent/heroTalent_npc_dota_hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_clinkz:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_clinkz:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_clinkz:IsStealable() 				return true end
function heroTalent_npc_dota_hero_clinkz:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_clinkz:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_clinkz" end


modifier_heroTalent_npc_dota_hero_clinkz = class({})

function modifier_heroTalent_npc_dota_hero_clinkz:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_clinkz:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_clinkz:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_clinkz:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_clinkz:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_clinkz:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end

function modifier_heroTalent_npc_dota_hero_clinkz:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_heroTalent_npc_dota_hero_clinkz:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.attacker == self:GetParent() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        local pos = keys.unit:GetAbsOrigin()
        local caster = self:GetParent()
        local ability =self:GetAbility()
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
        ParticleManager:SetParticleControl( effect_cast, 0, pos )
        ParticleManager:SetParticleControl( effect_cast, 1, pos)
        ParticleManager:SetParticleControl( effect_cast, 5, pos)
        caster:EmitSound("Hero_Clinkz.DeathPact")
        ParticleManager:ReleaseParticleIndex( effect_cast )
        local stack = keys.unit:GetDamageMax()*0.1
	
        caster:AddNewModifier( caster,ability,"modifier_heroTalent_npc_dota_hero_clinkz_damage", {stack=stack})
        local stack = keys.unit:GetMaxHealth()*0.05
        caster:AddNewModifier( caster,ability,"modifier_heroTalent_npc_dota_hero_clinkz_health", {stack=stack})

    end
end






modifier_heroTalent_npc_dota_hero_clinkz_damage = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_clinkz_damage:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:OnCreated(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax(),2000)
        self:SetStackCount(math.min(keys.stack,max_stack))     
        self:StartIntervalThink(0.5)
    end
end

function modifier_heroTalent_npc_dota_hero_clinkz_damage:OnRefresh(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax(),2000)
        self:SetStackCount(math.min(self:GetStackCount()+keys.stack,max_stack))     
    end
end

function modifier_heroTalent_npc_dota_hero_clinkz_damage:OnIntervalThink()
    local max_stack = math.min(self:GetParent():GetDamageMax(),2000)
    self:SetStackCount(math.min(self:GetStackCount(),max_stack))   
end

function modifier_heroTalent_npc_dota_hero_clinkz_damage:DeclareFunctions() return {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
} end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:GetModifierPreAttack_BonusDamage( params ) return self:GetStackCount() end


function modifier_heroTalent_npc_dota_hero_clinkz_damage:OnWaveEnd()
    self:SafeDestroy()
    return 1
end

function modifier_heroTalent_npc_dota_hero_clinkz_damage:OnWaveStart()
    self:SafeDestroy()
    return 1
end
function modifier_heroTalent_npc_dota_hero_clinkz_damage:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end





modifier_heroTalent_npc_dota_hero_clinkz_health = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_clinkz_health:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_clinkz_health:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_clinkz_health:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_clinkz_health:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_clinkz_health:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_clinkz_health:OnCreated(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax(),2000)*5
        self:SetStackCount(math.min(keys.stack,max_stack))     
        self:StartIntervalThink(0.5)
    end
end

function modifier_heroTalent_npc_dota_hero_clinkz_health:OnRefresh(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax(),2000)*5
        self:SetStackCount(math.min(self:GetStackCount()+keys.stack,max_stack))     
    end
end

function modifier_heroTalent_npc_dota_hero_clinkz_health:OnIntervalThink()
    local max_stack = math.min(self:GetParent():GetDamageMax(),2000)*5
    self:SetStackCount(math.min(self:GetStackCount(),max_stack))   
end

function modifier_heroTalent_npc_dota_hero_clinkz_health:DeclareFunctions() return {
	MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
} end
function modifier_heroTalent_npc_dota_hero_clinkz_health:GetModifierExtraHealthBonus( params ) return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_clinkz_health:OnWaveEnd()
    self:SafeDestroy()
    return 1
end

function modifier_heroTalent_npc_dota_hero_clinkz_health:OnWaveStart()
    self:SafeDestroy()
    return 1
end

function modifier_heroTalent_npc_dota_hero_clinkz_health:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

