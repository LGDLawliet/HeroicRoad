heroTalent_npc_dota_hero_leshrac = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_leshrac", "heroTalent/heroTalent_npc_dota_hero_leshrac", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_leshrac_effect", "heroTalent/heroTalent_npc_dota_hero_leshrac", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_leshrac:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_leshrac"
end


modifier_heroTalent_npc_dota_hero_leshrac = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_leshrac:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_leshrac:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_leshrac:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_leshrac:OnCreated()
	self.ability = self:GetAbility()
    self.trigger_hp_threshold = self.ability:GetSpecialValueFor("line")*0.01
    self.trigger_chance = self.ability:GetSpecialValueFor("chance")
    self.enhanced_interval = self.ability:GetSpecialValueFor("interval")
    self.enhanced_radius = self.ability:GetSpecialValueFor("index")*0.01
    self.normal_radius = self.ability:GetSpecialValueFor("radius")
    self.stun_duration = self.ability:GetSpecialValueFor("stun")
    self.hp_removal = self.ability:GetSpecialValueFor("hpcut")*0.01

    self.limit = 1200
	self.index = 220

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.trigger_chance_t = self.trigger_chance*self.talentgain
	self.enhanced_radius_t = self.enhanced_radius*self.talentgain
	self.hp_removal_t = self.hp_removal*self.talentgain
    
	if IsServer() then
    	self:StartIntervalThink(self.enhanced_interval)
	end
end

function modifier_heroTalent_npc_dota_hero_leshrac:OnIntervalThink()
    local parent = self:GetParent()
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.trigger_chance_t = self.trigger_chance*self.talentgain
	self.enhanced_radius_t = self.enhanced_radius*self.talentgain
	self.hp_removal_t = self.hp_removal*self.talentgain

	if parent:IsAlive() then
    	self:CreateEarthShock(parent:GetAbsOrigin(), self.enhanced_radius_t)
	end
end

function modifier_heroTalent_npc_dota_hero_leshrac:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end

function modifier_heroTalent_npc_dota_hero_leshrac:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_leshrac:OnTooltip(keys)
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.trigger_chance_t = self.trigger_chance*self.talentgain
	self.enhanced_radius_t = self.enhanced_radius*self.talentgain
	self.hp_removal_t = self.hp_removal*self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.trigger_chance_t
	end
	if self._tooltip == 2 then
		return  self.enhanced_radius_t*self.normal_radius
	end
	if self._tooltip == 3 then
		return  self.hp_removal_t*100
	end
end

function modifier_heroTalent_npc_dota_hero_leshrac:OnTakeDamage(keys)
    if not IsServer() then return end
    
    local attacker = keys.attacker
    local unit = keys.unit
    local damage = keys.damage
	local random = math.random
    
    if attacker ~= self:GetParent() then return end
	if not IsEnemy(attacker, unit) then return end
	if not self.ability:IsCooldownReady() then return end
    local damage_line = unit:GetMaxHealth()*self.trigger_hp_threshold
	if damage < damage_line then return end
	
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.trigger_chance_t = self.trigger_chance*self.talentgain
	self.enhanced_radius_t = self.enhanced_radius*self.talentgain
	self.hp_removal_t = self.hp_removal*self.talentgain
    
	if self.trigger_chance_t >= random(1,100) then
        self:CreateEarthShock(unit:GetAbsOrigin(), 1)
		self.ability:UseResources(true, true, true, true)
    end
end

function modifier_heroTalent_npc_dota_hero_leshrac:CreateEarthShock(position, radius_index)
    local parent = self:GetParent()
	local radius = self.normal_radius*radius_index
    
    local particle = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff/leshrac_split_tormented.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, position)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)
	parent:EmitSoundParams("Hero_Leshrac.Split_Earth", 0, 0.4, 0)
    
    local units = FindUnitsInRadius(
        parent:GetTeamNumber(),
        position,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    
    for _, unit in pairs(units) do
        unit:AddNewModifier(parent, self.ability, "modifier_stunned", {duration = self.stun_duration})
        
        local hp_removal = unit:GetHealth() * self.hp_removal_t

        local keys = {
            origin = hp_removal,
            limit = self.limit*parent:GetIntellect(false),
            index = self.index
		}
		hp_removal = SqrtPercentage(keys)

        unit:ModifyHealth(unit:GetHealth() - hp_removal, self.ability, false, 0)
    end
end
