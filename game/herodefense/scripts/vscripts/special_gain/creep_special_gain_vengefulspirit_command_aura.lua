creep_special_gain_vengefulspirit_command_aura = class({})

LinkLuaModifier("modifier_creep_special_gain_vengefulspirit_command_aura", "special_gain/creep_special_gain_vengefulspirit_command_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_vengefulspirit_command_aura_active", "special_gain/creep_special_gain_vengefulspirit_command_aura", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_vengefulspirit_command_aura:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_vengefulspirit_command_aura"
end

-- Item Passive
-- require('internal/timers')   --计时器功能

modifier_creep_special_gain_vengefulspirit_command_aura = advanced_modifier({})

function modifier_creep_special_gain_vengefulspirit_command_aura:IsHidden() return false end
function modifier_creep_special_gain_vengefulspirit_command_aura:IsPurgable() return false end
function modifier_creep_special_gain_vengefulspirit_command_aura:IsDebuff() return false end
function modifier_creep_special_gain_vengefulspirit_command_aura:GetEffectName() return "particles/units/heroes/hero_vengeful/vengeful_venge_aura_cast.vpcf" end
function modifier_creep_special_gain_vengefulspirit_command_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_vengefulspirit_command_aura:OnCreated()
	self.hp_damage = self:GetAbility():GetSpecialValueFor("hp_damage")*0.01
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_creep_special_gain_vengefulspirit_command_aura:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_creep_special_gain_vengefulspirit_command_aura:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
		local target = keys.attacker
		if not target then
			return
		end
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		if parent:PassivesDisabled() then
			self.duration = 0.5*self.duration
		end
		local modifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(0.5)
        local statusResistance = keys.attacker:GetHDStatusResistanceIndex(1.1) * modifierStatusNegativeGain

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		keys.attacker:GameTimer(0.2, function()
			local damage = target:GetHealth()*self.hp_damage
			ApplyDamage({victim = target, attacker = parent, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY,})
			target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
			target:AddNewModifier(parent, self:GetAbility(), "modifier_creep_special_gain_vengefulspirit_command_aura_active", {duration = self.duration*statusResistance})
		end)
    end
end



--------------------------------

modifier_creep_special_gain_vengefulspirit_command_aura_active = advanced_modifier({})

function modifier_creep_special_gain_vengefulspirit_command_aura_active:IsHidden() return false end
function modifier_creep_special_gain_vengefulspirit_command_aura_active:IsPurgable() return true end
function modifier_creep_special_gain_vengefulspirit_command_aura_active:IsDebuff() return true end
function modifier_creep_special_gain_vengefulspirit_command_aura_active:IsPurgeException() return true end
function modifier_creep_special_gain_vengefulspirit_command_aura_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end
function modifier_creep_special_gain_vengefulspirit_command_aura_active:GetDisableHealing()
	return 1
end