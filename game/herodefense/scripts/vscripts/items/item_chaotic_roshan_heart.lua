LinkLuaModifier("modifier_item_chaotic_roshan_heart", "items/item_chaotic_roshan_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_heart_aura", "items/item_chaotic_roshan_heart", LUA_MODIFIER_MOTION_NONE)

item_chaotic_roshan_heart = class({})

function item_chaotic_roshan_heart:GetIntrinsicModifierName()
    return "modifier_item_chaotic_roshan_heart"
end

function item_chaotic_roshan_heart:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", context)
    PrecacheResource("particle", "particles/prime/hero_spawn_hero_level_6.vpcf", context )
end
function item_chaotic_roshan_heart:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end
function item_chaotic_roshan_heart:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end
function item_chaotic_roshan_heart:OnToggle()
	if not IsServer() then return end
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName("modifier_item_chaotic_roshan_heart_aura")
    if modifier then
        modifier:Destroy()
    else
        caster:AddNewModifier(caster, self, "modifier_item_chaotic_roshan_heart_aura", {})
    end
end
-----------------------------------------------------------------
modifier_item_chaotic_roshan_heart = advanced_modifier({})

function modifier_item_chaotic_roshan_heart:IsDebuff() return false end
function modifier_item_chaotic_roshan_heart:IsHidden() return false end
function modifier_item_chaotic_roshan_heart:IsPurgable() return false end
function modifier_item_chaotic_roshan_heart:RemoveOnDeath() return false end
function modifier_item_chaotic_roshan_heart:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_item_chaotic_roshan_heart:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
    self.bonus_all_attribute = self.ability:GetSpecialValueFor("bonus_all_attribute")
    self.revive_charges = self.ability:GetSpecialValueFor("stack")
    self.health_per_revive = self.ability:GetSpecialValueFor("health")
    self.health_max = self.ability:GetSpecialValueFor("health_max")
    self.caster.now_reincarnation = "modifier_item_chaotic_roshan_heart"  --设置当前的重生名
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	self.reincarnate_delay = 3

    if not self.ability.check then
        self.ability.check = true
        self:SetStackCount(0)
    end
end

function modifier_item_chaotic_roshan_heart:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_RESPAWN, -- 新增监听复活
    }
end

function modifier_item_chaotic_roshan_heart:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:AdvancedGetModifierHealthBonus()
	end
end

function modifier_item_chaotic_roshan_heart:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
    }
end

function modifier_item_chaotic_roshan_heart:AdvancedGetModifierHealthBonus()
    local extra_health = self:GetStackCount() * self.health_per_revive
    return self.bonus_health + math.min(extra_health, self.health_max)
end

function modifier_item_chaotic_roshan_heart:Advanced_GetModifierBonusStats_Strength()
    return self.bonus_all_attribute
end
function modifier_item_chaotic_roshan_heart:Advanced_GetModifierBonusStats_Agility()
    return self.bonus_all_attribute
end
function modifier_item_chaotic_roshan_heart:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_all_attribute
end

function modifier_item_chaotic_roshan_heart:AdvancedGetModifierReincarnate(keys)
	if not IsServer() then return end
	if self.ability:GetCurrentCharges() >= 1 then
		local data = {
			modifier = self,
			time = self.reincarnate_delay,
			priority = 10,
			invulnerable_time = 1,
		}
		self.ability:SetCurrentCharges(math.max(self.ability:GetCurrentCharges()-1, 0))
		return data
	end
	return nil
end
function modifier_item_chaotic_roshan_heart:OnReincarnateTrigger(keys)
	local unit = keys.unit
	self.ability:UseResources(false, false, true,true)
	local particle_death_fx = ParticleManager:CreateParticle(self.particle_death, PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
	ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_death_fx)

	local table = {
		mulEffect = true,
		multiTrigger = true,
		unit = self.parent,
		modifier = self,
		ability = self.ability
	}
	FireDeathAgainEvent(table)
end
function modifier_item_chaotic_roshan_heart:OnRespawn(keys)
    if not IsServer() then return end
    local unit = keys.unit

    if unit == self.parent then
        self:SetStackCount(self:GetStackCount()+1)
    end
end
-----------------------------------------------------------------
modifier_item_chaotic_roshan_heart_aura = advanced_modifier({})

function modifier_item_chaotic_roshan_heart_aura:IsDebuff() return false end
function modifier_item_chaotic_roshan_heart_aura:IsHidden() return false end
function modifier_item_chaotic_roshan_heart_aura:IsPurgable() return false end
function modifier_item_chaotic_roshan_heart_aura:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.hp_regen_percent = self.ability:GetSpecialValueFor("hp_regen")*0.01
    self.radius = self.ability:GetSpecialValueFor("radius")
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
        EmitSoundOn("hd_potion_revive_active", self.parent)   
        local particle_cast = "particles/prime/hero_spawn_hero_level_6.vpcf"
        local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "" , self.parent:GetOrigin(), true )
        DestroyParticleByDelay(particle_cast_fx,9.5)
    end
end

function modifier_item_chaotic_roshan_heart_aura:OnIntervalThink()
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER,false) 
    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_roshan_heart_aura_effect", {duration = 1})
    end
end

function modifier_item_chaotic_roshan_heart_aura:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_roshan_heart_aura:AdvancedGetModifierConstantHealthRegen()
    local parent = self:GetParent()
    local missing_health = (parent:GetMaxHealth() - parent:GetHealth())
    return self.hp_regen_percent * missing_health
end

-----------------------------------------------------------------
modifier_item_chaotic_roshan_heart_aura_effect = advanced_modifier({})

function modifier_item_chaotic_roshan_heart_aura_effect:IsDebuff() return true end
function modifier_item_chaotic_roshan_heart_aura_effect:IsHidden() return true end
function modifier_item_chaotic_roshan_heart_aura_effect:IsPurgable() return false end

function modifier_item_chaotic_roshan_heart_aura_effect:OnCreated(keys)
    if not IsServer() then return end
    self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if not self.caster:IsAttackImmune() and not self.caster:IsInvulnerable() and not self.parent:ImmuneForceAttack() then
		self.parent:SetForceAttackTarget( self.caster ) 
		self.parent:MoveToTargetToAttack( self.caster )
	end
end
function modifier_item_chaotic_roshan_heart_aura_effect:OnDestroy()
	if not IsServer() then return end
	self.parent:SetForceAttackTarget( nil )
	self.parent:Stop()
end
-----------------------------------------------------------------
