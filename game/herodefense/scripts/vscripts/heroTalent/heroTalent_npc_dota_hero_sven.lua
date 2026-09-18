heroTalent_npc_dota_hero_sven = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sven", "heroTalent/heroTalent_npc_dota_hero_sven", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_sven:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sven"
end

function heroTalent_npc_dota_hero_sven:OnCustomDataSettlement()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_sven")
	if modifier then
		modifier:OnCustomDataSettlement()
	end
end


modifier_heroTalent_npc_dota_hero_sven = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_sven:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_sven:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sven:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sven:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sven:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_sven:OnCreated(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.str_attack = self.ability:GetSpecialValueFor("str_attack")
	self.stack = self.ability:GetSpecialValueFor("stack")
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
	
	self.talentgain = self.ability:GetTalentGain(0.45)
	self.str_attack_t = self.str_attack*self.talentgain
	self.radius_t = self.radius*self.talentgain
	self.heal_t = self.heal*self.talentgain

	self.attack = 0
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local unit = self:GetCaster()
        if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())),"lonely_hero_1") then
			self.str_attack = self.str_attack + 0.1
		end
		self.customData_timer = 0 --用于计数多人的次数
		self:StartIntervalThink(0.5)
	end
end

function modifier_heroTalent_npc_dota_hero_sven:OnIntervalThink()
	local caster = self:GetParent()
	self.talentgain = self.ability:GetTalentGain(0.45)
	self.str_attack_t = self.str_attack*self.talentgain

	self:SetStackCount(self.str_attack_t*caster:GetStrength())

	-- 成就部分：为了看周围是否有友军
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	if #units<=1 then
		self.customData_timer = self.customData_timer +0.5
	end
end

function modifier_heroTalent_npc_dota_hero_sven:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	if attacker ~= self.parent then return end

	self.attack = math.min(self.attack + 1, self.stack)
	if self.attack >= self.stack then
		self.attack = 0
		self:GodsMoan(attacker)
	end
end

function modifier_heroTalent_npc_dota_hero_sven:GodsMoan(unit)
	if not IsServer() then return end
	if not unit then return end
	local caster = self:GetCaster()

	self.talentgain = self.ability:GetTalentGain(0.45)
	self.radius_t = self.radius*self.talentgain
	self.heal_t = self.heal*self.talentgain

	local heal = (unit:GetMaxHealth()-unit:GetHealth())*self.heal_t
	unit:Heal(heal, self.ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, heal, nil)

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.3)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius_t, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.8)*ModifierStatusNegativeGain
		local duration = self.duration*StatusResistance
		enemy:AddNewModifier(caster, self.ability, "modifier_stunned", {duration = duration})
	end

	local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
	local sound_name = "Hero_Sven.WarCry"
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	unit:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(pfx, 2, unit, PATTACH_POINT_FOLLOW, "attach_head", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end
function modifier_heroTalent_npc_dota_hero_sven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_sven:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.45)
	self.str_attack_t = self.str_attack*self.talentgain
	self.radius_t = self.radius*self.talentgain
	self.heal_t = self.heal*self.talentgain

	self._tooltip = (self._tooltip or 0) % 4 + 1
    if self._tooltip == 1 then
        return self.str_attack_t
	elseif self._tooltip == 2 then
        return (self.radius_t)
	elseif self._tooltip == 3 then
        return (self.heal_t*100)
	elseif self._tooltip == 4 then
        return self:GetStackCount()
	end
end
function modifier_heroTalent_npc_dota_hero_sven:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
	}
end
function modifier_heroTalent_npc_dota_hero_sven:Advanced_GetModifierBaseAttack_BonusDamage()
  	return	self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_sven:OnCustomDataSettlement()		
	local gameTime = GameRules:GetGameTime()

	local index = self.customData_timer/gameTime
	if index>=0.5 then
		local modifier = self:GetCaster():FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:SvenTalent1()
		end
	end
end

