LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slardar_4", "heroTalent/heroTalent_npc_dota_hero_slardar_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slardar_4_debuff", "heroTalent/heroTalent_npc_dota_hero_slardar_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slardar_4_damage", "heroTalent/heroTalent_npc_dota_hero_slardar_4.lua", LUA_MODIFIER_MOTION_NONE)
heroTalent_npc_dota_hero_slardar_4 = class({})

function heroTalent_npc_dota_hero_slardar_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_slardar_4"
end

function heroTalent_npc_dota_hero_slardar_4:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
end

-- 主被动管理modifier
modifier_heroTalent_npc_dota_hero_slardar_4 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_slardar_4:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4:DestroyOnExpire() return false end

function modifier_heroTalent_npc_dota_hero_slardar_4:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.attack = self.ability:GetSpecialValueFor("attack")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.attack_max = self.ability:GetSpecialValueFor("attack_max")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.level = self.ability:GetSpecialValueFor("level")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")

    self.talentgain = self.ability:GetTalentGain(0.7)
	self.damage_t = self.damage*self.talentgain
	self.bonus_damage_t = self.bonus_damage*self.talentgain
    
    self.current_attack_bonus = 0
    self:SetStackCount(self.current_attack_bonus)
    self.last_growth_time = 0
end

function modifier_heroTalent_npc_dota_hero_slardar_4:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_slardar_4:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp
    }
end
function modifier_heroTalent_npc_dota_hero_slardar_4:Advanced_GetModifier_PhysicalCriticalAmp()
    return -100000
end
function modifier_heroTalent_npc_dota_hero_slardar_4:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_slardar_4:OnTooltip()
    self.talentgain = self.ability:GetTalentGain(0.7)
	self.damage_t = self.damage*self.talentgain
	self.bonus_damage_t = self.bonus_damage*self.talentgain

    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.parent:GetLevel()*self.bonus_damage_t + self.damage_t
    end
    if self._tooltip == 2 then
        return self:GetStackCount()
    end
end

function modifier_heroTalent_npc_dota_hero_slardar_4:AdvancedOnCriticalStrikeTrigger(keys)
    if not IsServer() then return end
    self:TriggerHeavySlam()
    
    local current_time = GameRules:GetGameTime()
    if current_time - self.last_growth_time < self.cd then return end
    if self.current_attack_bonus < self.attack_max then
        self.current_attack_bonus = math.min(self.current_attack_bonus + self.attack, self.attack_max)
        self:SetStackCount(self.current_attack_bonus)
        self.last_growth_time = current_time
    end
end

function modifier_heroTalent_npc_dota_hero_slardar_4:TriggerHeavySlam()
    if not IsServer() then return end
    
    local parent_pos = self.parent:GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        parent_pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    self.talentgain = self.ability:GetTalentGain(0.7)
	self.damage_t = self.damage*self.talentgain
	self.bonus_damage_t = self.bonus_damage*self.talentgain
    local armor_reduction = self.parent:GetLevel() >= self.level and self.armor or 0
    local incoming_damage = self.parent:GetLevel() >= self.level and self.incoming or 0

    local total_damage = self.parent:GetAverageTrueAttackDamage(nil)*(self.damage_t + self.bonus_damage_t*self.parent:GetLevel())
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_slardar_4_damage", {stack = total_damage})
        self:PlayEffects(enemy)
        if enemy:IsAlive() then 
            local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
            local StatusResistance = enemy:GetHDStatusResistanceIndex(0.75)*ModifierStatusNegativeGain
            enemy:AddNewModifier(self.parent,self.ability,"modifier_heroTalent_npc_dota_hero_slardar_4_debuff",{duration = self.duration*StatusResistance, armor_reduction = armor_reduction, incoming_damage = incoming_damage})
        end
    end
    
    EmitSoundOn("Hero_Slardar.Slithereen_Crush",self.parent)	
    local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(self.radius,0,0))
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
end

function modifier_heroTalent_npc_dota_hero_slardar_4:PlayEffects(target)
	if not IsServer() then return end
    if not target then return end
	
	local particle_cast_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx2, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx2)
end
-----------
modifier_heroTalent_npc_dota_hero_slardar_4_damage = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_slardar_4_damage:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_slardar_4_damage:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_slardar_4_damage:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4_damage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.2)
	end
end

function modifier_heroTalent_npc_dota_hero_slardar_4_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end
function modifier_heroTalent_npc_dota_hero_slardar_4_damage:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
	}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end
-- 沉重碎击debuff
modifier_heroTalent_npc_dota_hero_slardar_4_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:IsPurgable() return true end
function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")
    if IsServer() then
        self.armor_reduction = keys.armor_reduction
        self.incoming_damage = keys.incoming_damage
        self:SetHasCustomTransmitterData(true)
    end
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:Advanced_GetModifierAttackSpeedPercentage()
    return -self.attack_slow
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self.armor_reduction
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
            return self.incoming_damage
        end
    end
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:AddCustomTransmitterData()
    return {
        armor_reduction = self.armor_reduction,
    }
end

function modifier_heroTalent_npc_dota_hero_slardar_4_debuff:HandleCustomTransmitterData(data)
    self.armor_reduction = data.armor_reduction
end 