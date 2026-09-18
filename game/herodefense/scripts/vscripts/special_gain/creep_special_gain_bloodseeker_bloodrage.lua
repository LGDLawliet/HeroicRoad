creep_special_gain_bloodseeker_bloodrage = class({})

LinkLuaModifier("modifier_creep_special_gain_bloodseeker_bloodrage", "special_gain/creep_special_gain_bloodseeker_bloodrage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_bloodseeker_bloodrage_ready", "special_gain/creep_special_gain_bloodseeker_bloodrage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_bloodseeker_bloodrage_active", "special_gain/creep_special_gain_bloodseeker_bloodrage", LUA_MODIFIER_MOTION_NONE)


function creep_special_gain_bloodseeker_bloodrage:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_bloodseeker_bloodrage"
end

------------------------------------------------------------------------------------------
modifier_creep_special_gain_bloodseeker_bloodrage = advanced_modifier({})

function modifier_creep_special_gain_bloodseeker_bloodrage:IsHidden() return false end
function modifier_creep_special_gain_bloodseeker_bloodrage:IsPurgable() return false end
function modifier_creep_special_gain_bloodseeker_bloodrage:IsDebuff() return false end
function modifier_creep_special_gain_bloodseeker_bloodrage:GetEffectName() return "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf" end
function modifier_creep_special_gain_bloodseeker_bloodrage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creep_special_gain_bloodseeker_bloodrage:OnCreated()
	self.active_duration = self:GetAbility():GetSpecialValueFor("active_duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_creep_special_gain_bloodseeker_bloodrage:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_creep_special_gain_bloodseeker_bloodrage:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    if keys.attacker == self:GetParent() and ability:IsCooldownReady() then
		if keys.target:IsMagicImmune() then
			self.duration = 0.5*self.duration
		end
		local modifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(0.5)
        local statusResistance = keys.target:GetHDStatusResistanceIndex(0.8) * modifierStatusNegativeGain

		ability:UseResources(true, true, true, true)


		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			local modifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(0.5)
        	local statusResistance = unit:GetHDStatusResistanceIndex(0.8) * modifierStatusNegativeGain
			unit:AddNewModifier(keys.attacker, self:GetAbility(),"modifier_creep_special_gain_bloodseeker_bloodrage_active", {duration = self.active_duration*statusResistance})
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, keys.target)
		ParticleManager:ReleaseParticleIndex(pfx)
    end
end
-----------------
modifier_creep_special_gain_bloodseeker_bloodrage_ready = advanced_modifier({})

function modifier_creep_special_gain_bloodseeker_bloodrage_ready:IsDebuff() return true end
function modifier_creep_special_gain_bloodseeker_bloodrage_ready:IsHidden() return false end
function modifier_creep_special_gain_bloodseeker_bloodrage_ready:IsPurgable() return true end
function modifier_creep_special_gain_bloodseeker_bloodrage_ready:IsPurgeException() return true end

function modifier_creep_special_gain_bloodseeker_bloodrage_ready:OnCreated()
	if not IsServer() then
		return
	end
	self.active_duration = self:GetAbility():GetSpecialValueFor("active_duration")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if self:GetCaster():PassivesDisabled() then
		self.duration = 2*self.duration
	end

	self:GetParent():GameTimer(self.duration , function ()
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			unit:AddNewModifier(self:GetParent(), self:GetAbility(),"modifier_creep_special_gain_bloodseeker_bloodrage_active", {duration = self.active_duration})
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end
---------------------
modifier_creep_special_gain_bloodseeker_bloodrage_active = advanced_modifier({})

function modifier_creep_special_gain_bloodseeker_bloodrage_active:IsDebuff() return true end
function modifier_creep_special_gain_bloodseeker_bloodrage_active:IsHidden() return false end
function modifier_creep_special_gain_bloodseeker_bloodrage_active:IsPurgable() return true end
function modifier_creep_special_gain_bloodseeker_bloodrage_active:IsPurgeException() return true end


function modifier_creep_special_gain_bloodseeker_bloodrage_active:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
	return state
end