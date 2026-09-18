heroTalent_npc_dota_hero_omniknight = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_tooltip", "heroTalent/heroTalent_npc_dota_hero_omniknight", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight", "heroTalent/heroTalent_npc_dota_hero_omniknight", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_shield", "heroTalent/heroTalent_npc_dota_hero_omniknight", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_omniknight:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_recast_marker.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_immortal_cast.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/omniknight_1/cast_effect.vpcf", context )
end

function heroTalent_npc_dota_hero_omniknight:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_omniknight_tooltip"
end

function heroTalent_npc_dota_hero_omniknight:OnSpellStart()
	local caster = self:GetCaster()

    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
    local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
    EmitSoundOn("Hero_Omniknight.Projection", caster)


    local heroes = GetAllRealHeroes()
    local duration = self:GetSpecialValueFor("duration")*caster:GetModifierDurationGainIndex(0.2)
    local talent_gain1 = self:GetTalentGain(0.8)
    local talent_gain2 = self:GetTalentGain(0.45)

    local interval = math.max(self:GetSpecialValueFor("interval")/talent_gain1, 0.2)
    local damage = self:GetSpecialValueFor("damage")*talent_gain2

    for _,hero in pairs(heroes) do
        if hero:IsAlive() then
            hero:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_omniknight")
            hero:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_omniknight", {
                duration = duration,
                interval = interval,
                damage = damage,
            })
        end
    end
end


modifier_heroTalent_npc_dota_hero_omniknight_tooltip = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:OnCreated(kv)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.interval = self.ability:GetSpecialValueFor("interval")

end
function modifier_heroTalent_npc_dota_hero_omniknight_tooltip:OnTooltip()
    self.talent_gain1 = self.ability:GetTalentGain(0.8)
    self.talent_gain2 = self.ability:GetTalentGain(0.45)
    self.damage_t = self.damage*self.talent_gain2
    self.interval_t = math.max(self.interval/self.talent_gain1, 0.3)    

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.damage_t
    elseif self._tooltip == 2 then
        return self.interval_t
    end
end


modifier_heroTalent_npc_dota_hero_omniknight = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_omniknight:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_omniknight:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_purification_recast_marker.vpcf"
end
function modifier_heroTalent_npc_dota_hero_omniknight:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end
function modifier_heroTalent_npc_dota_hero_omniknight:OnCreated(kv)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")*0.01

    if IsServer() then
        self.duration = self:GetDuration()
        self.parent:Purge(false, true, false, true, true)
        self.interval = kv.interval
        self.damage = kv.damage
        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()


            self.particle_cast = "particles/rebuild/talent/omniknight_1/cast_effect.vpcf"
            self.particle_cast_fx = ParticleManager:CreateParticle(self.particle_cast, PATTACH_ABSORIGIN, self.caster)
            ParticleManager:SetParticleControl(self.particle_cast_fx, 0, self.caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(self.particle_cast_fx, 1, self.parent:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.particle_cast_fx)

    end
end

function modifier_heroTalent_npc_dota_hero_omniknight:OnIntervalThink()
    if self.parent:IsAlive() then
        self:ApplyEffect(self.radius)
    end
end

--radius
function modifier_heroTalent_npc_dota_hero_omniknight:ApplyEffect(radius)
	if not IsServer() then return end
    
    
	local particle_aoe = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf"
	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle_aoe_fx, 3, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)   
    self.parent:EmitSoundParams("Hero_Omniknight.Purification", 0, 0.3, 0) 

    self.parent:Purge(false, true, false, false, false)
    local damage = self.damage*self.caster:GetStrength() + self.bonus_damage*(self.parent:GetMaxHealth() - self.parent:GetHealth())
    local heal = damage

    local current_hp = self.parent:GetHealth()
    local healing = HealWithGain(heal, self.caster,self.parent, self.ability) --实际治疗量
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
    local after_hp = self.parent:GetHealth()
    local actual_revice = after_hp - current_hp --实际回复的量
    local overflow_healing = healing - actual_revice --溢出治疗量
    if overflow_healing > 0 then
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_npc_dota_hero_omniknight_shield", {
            duration = self.duration,
            stack = overflow_healing,
        })
    end


    self.damagetable = {
        victim = self.parent,
        attacker = self.caster, 
        damage_type = self.ability:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self.ability,
        hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
    }

    local enemies = FindUnitsInRadius(
        self.caster:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    if #enemies <= 0 then return end

    self.damagetable.damage = damage
    for i,enemy in pairs(enemies) do
		
		enemy:ApplyMergeDamage(self.damagetable)  

        local particle_hit = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
        local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(300, 0, 0))
        ParticleManager:ReleaseParticleIndex(particle_hit_fx)
	end        
end


--epic10护盾
modifier_heroTalent_npc_dota_hero_omniknight_shield = modifier_heroTalent_npc_dota_hero_omniknight_shield or advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_omniknight_shield:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_shield:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_shield:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_shield:OnCreated(keys)
	self.shield = 0
	if IsServer() then
		self:AddStackDuration(keys.stack, self:GetRemainingTime(), self:GetCaster():GetStrength()*70)
		self.shield = self:GetStackCount()

		self:GetParent():EmitSound("Hero_Crystal.CrystalClone.Cast")
	end
end

function modifier_heroTalent_npc_dota_hero_omniknight_shield:OnRefresh(keys)
	if IsServer() then
		self:AddStackDuration(keys.stack, self:GetRemainingTime(), self:GetCaster():GetStrength()*70)
		self.shield = self:GetStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_omniknight_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = { nil, self:GetParent() },
	}
end

function modifier_heroTalent_npc_dota_hero_omniknight_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then return self:GetStackCount() end
    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
        self:SafeDestroy()
    else
        self:RemoveStackDuration(math.floor(math.max(0, keys.damage)))
        stack = keys.damage
    end
    return stack
end