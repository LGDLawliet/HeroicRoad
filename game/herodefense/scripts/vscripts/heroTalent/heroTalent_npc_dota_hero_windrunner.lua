LinkLuaModifier("modifier_heroTalent_npc_dota_hero_windrunner", "heroTalent/heroTalent_npc_dota_hero_windrunner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_windrunner_active", "heroTalent/heroTalent_npc_dota_hero_windrunner.lua", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_windrunner = class({})

function heroTalent_npc_dota_hero_windrunner:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_windrunner"
end

function heroTalent_npc_dota_hero_windrunner:Precache(context)
    PrecacheResource("particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf", context)
end

--------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_windrunner = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_windrunner:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_windrunner:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_windrunner:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_windrunner:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_windrunner:OnCreated(params)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.level_req = self.ability:GetSpecialValueFor("level")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.move_min = self.ability:GetSpecialValueFor("move_min")
    self.move_attack = self.ability:GetSpecialValueFor("move_attack")
    self.move_attack_speed = self.ability:GetSpecialValueFor("move_attack_speed")

	self.talentgain_1 = self.ability:GetTalentGain(0.3)
	self.talentgain_2 = self.ability:GetTalentGain(0.7)
	self.move_min_t = self.move_min*self.talentgain_1
	self.move_attack_t = self.move_attack*self.talentgain_2
	self.move_attack_speed_t = self.move_attack_speed*self.talentgain_1

    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_heroTalent_npc_dota_hero_windrunner:OnIntervalThink()
	local active_modifier_name = "modifier_heroTalent_npc_dota_hero_windrunner_active"

    if self.parent:GetLevel() >= self.level_req then
		local modifier = self.parent:FindModifierByName(active_modifier_name)
        if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(1.5, true)
		else
			self.parent:AddNewModifier(self.parent, self.ability, active_modifier_name, {duration = 1.5})
		end
		return
    end

    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    if (#enemies and #enemies == 0) then
		local modifier = self.parent:FindModifierByName(active_modifier_name)
        if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(1.5, true)
		else
			self.parent:AddNewModifier(self.parent, self.ability, active_modifier_name, {duration = 1.5})
		end
    end
end

function modifier_heroTalent_npc_dota_hero_windrunner:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
        MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }
end

function modifier_heroTalent_npc_dota_hero_windrunner:GetModifierMoveSpeed_AbsoluteMin()
	self.talentgain_1 = self.ability:GetTalentGain(0.3)
	self.move_min_t = self.move_min*self.talentgain_1
    return self.move_min_t
end
function modifier_heroTalent_npc_dota_hero_windrunner:GetModifierIgnoreMovespeedLimit()
	return	1
end
function modifier_heroTalent_npc_dota_hero_windrunner:OnTooltip()
	self.talentgain_1 = self.ability:GetTalentGain(0.3)
	self.talentgain_2 = self.ability:GetTalentGain(0.7)
	self.move_min_t = self.move_min*self.talentgain_1
	self.move_attack_t = self.move_attack*self.talentgain_2
	self.move_attack_speed_t = self.move_attack_speed*self.talentgain_1

	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self.move_min_t
	end
	if self._tooltip == 2 then
		return self.parent:GetLevel() * self.move_attack_t
	end
	if self._tooltip == 3 then
		return self.parent:GetLevel() * self.move_attack_speed_t
	end
end

--------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_windrunner_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_windrunner_active:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_windrunner_active:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_windrunner_active:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_windrunner_active:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_windrunner_active:GetEffectName() return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_windrunner_active:OnCreated(params)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.move_attack = self.ability:GetSpecialValueFor("move_attack")*0.01
    self.move_attack_speed = self.ability:GetSpecialValueFor("move_attack_speed")*0.01

	self.talentgain_1 = self.ability:GetTalentGain(0.3)
	self.talentgain_2 = self.ability:GetTalentGain(0.7)
	self.move_attack_t = self.move_attack*self.talentgain_2
	self.move_attack_speed_t = self.move_attack_speed*self.talentgain_1
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:OnRefresh(params)
    self.move_attack = self.ability:GetSpecialValueFor("move_attack")*0.01
    self.move_attack_speed = self.ability:GetSpecialValueFor("move_attack_speed")*0.01

	self.talentgain_1 = self.ability:GetTalentGain(0.3)
	self.talentgain_2 = self.ability:GetTalentGain(0.7)
	self.move_attack_t = self.move_attack*self.talentgain_2
	self.move_attack_speed_t = self.move_attack_speed*self.talentgain_1
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_windrunner_active:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:Advanced_GetModifierBaseAttack_BonusDamage()
    return self.parent:GetLevel()*self.parent:GetIdealSpeed()*self.move_attack_t
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:GetModifierAttackSpeedBonus_Constant()
    return self.parent:GetLevel()*self.parent:GetIdealSpeed()*self.move_attack_speed_t
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:GetModifierProjectileSpeedBonus()
    return 10000
end

function modifier_heroTalent_npc_dota_hero_windrunner_active:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBaseAttack_BonusDamage()
	end
	if self._tooltip == 2 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
end
