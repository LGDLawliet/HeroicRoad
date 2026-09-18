heroTalent_npc_dota_hero_life_stealer = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_life_stealer", "heroTalent/heroTalent_npc_dota_hero_life_stealer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_life_stealer_effect", "heroTalent/heroTalent_npc_dota_hero_life_stealer", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_life_stealer:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_life_stealer"
end

modifier_heroTalent_npc_dota_hero_life_stealer = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_life_stealer:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.speed = self.ability:GetSpecialValueFor("speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.interval_min = self.ability:GetSpecialValueFor("interval_min")
	self.mrs_need_max = self.ability:GetSpecialValueFor("mrs_need_max")

	self.talent_gain = self.ability:GetTalentGain(0.5)
	self.speed_t = self.speed*self.talent_gain

	if IsServer() then
		local first_delay = self:CalculateNextInterval()
		self:StartIntervalThink(first_delay)
	end
end

function modifier_heroTalent_npc_dota_hero_life_stealer:CalculateNextInterval()
    local current_mrs = self.parent:Script_GetMagicalArmorValue(true, self.ability)* 100
    
    local ratio = 0
    if self.mrs_need_max > 0 then
        ratio = current_mrs / self.mrs_need_max
    end
    ratio = math.min(1, math.max(0, ratio))
    local current_interval = self.interval - ((self.interval - self.interval_min) * ratio)

    return current_interval
end

function modifier_heroTalent_npc_dota_hero_life_stealer:OnIntervalThink()
	if not self.parent:IsAlive() then return end
	local mrs = self.parent:Script_GetMagicalArmorValue(true, self.ability)
	if mrs > 0 then
		mrs = mrs*100
	end

	self.talent_gain = self.ability:GetTalentGain(0.5)
	self.speed_t = self.speed*self.talent_gain

	self.caster:EmitSoundParams( "Hero_LifeStealer.Rage",0, 0.25, 0)
	self.caster:Purge(false, true, false, true, true)
	self.caster:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_life_stealer_effect")
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_npc_dota_hero_life_stealer_effect", {
		duration = self.duration,
		speed = self.speed_t
	})

	local next_delay = self:CalculateNextInterval()
	print(self.parent:GetAbsOrigin().x, self.parent:GetAbsOrigin().y, self.parent:GetAbsOrigin().z)
    self:StartIntervalThink(next_delay)
end

function modifier_heroTalent_npc_dota_hero_life_stealer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_heroTalent_npc_dota_hero_life_stealer:OnTooltip()
    self.talent_gain = self.ability:GetTalentGain(0.5)
	self.speed_t = self.speed*self.talent_gain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.speed_t
    elseif self._tooltip == 2 then
        return self:CalculateNextInterval()
    end
end

----
modifier_heroTalent_npc_dota_hero_life_stealer_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_life_stealer_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

function modifier_heroTalent_npc_dota_hero_life_stealer_effect:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if IsServer() then
		self:SetStackCount(kv.speed)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

function modifier_heroTalent_npc_dota_hero_life_stealer_effect:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end
	return state
end

function modifier_heroTalent_npc_dota_hero_life_stealer_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_life_stealer_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end