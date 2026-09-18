Middle_fates_edict = class({})

--------------------------------------------------------------------------------
-- Ability Start

LinkLuaModifier("modifier_Middle_fates_edict_buff", "skills/Middle_fates_edict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_fates_edict_debuff", "skills/Middle_fates_edict", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能



function Middle_fates_edict:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end
	end
	local duration = self:GetSpecialValueFor("duration")

	if target:GetTeamNumber()==caster:GetTeamNumber() then

		local StatusResistance = target:GetHDStatusResistanceIndex(1)
		local gain = caster:GetModifierDurationGainIndex(0.5)

		target:AddNewModifier(caster, self, "modifier_Middle_fates_edict_buff", {duration = duration*gain})
		target:AddNewModifier(caster, self, "modifier_Middle_fates_edict_debuff", {duration = duration*StatusResistance})
		target:Purge(false, true, false, true, true) --可移除眩晕的强驱散

	else
		-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.7)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain

		target:AddNewModifier(caster, self, "modifier_Middle_fates_edict_buff", {duration = duration})
		target:AddNewModifier(caster, self, "modifier_Middle_fates_edict_debuff", {duration = duration*StatusResistance})

	end

	target:EmitSound("Hero_Oracle.FatesEdict.Cast")
	

end



modifier_Middle_fates_edict_buff = advanced_modifier({})

function modifier_Middle_fates_edict_buff:IsDebuff() return false end
function modifier_Middle_fates_edict_buff:IsHidden() return false end
function modifier_Middle_fates_edict_buff:IsPurgable() return true end
function modifier_Middle_fates_edict_buff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
function modifier_Middle_fates_edict_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_fates_edict_buff:OnCreated(table)
	self.SPELL_AMPLIFY_PERCENTAGE = 0
	self.bonus_damage = 0
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.SPELL_AMPLIFY_PERCENTAGE = 35
		self.bonus_damage = 120
	end
end
function modifier_Middle_fates_edict_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end


function modifier_Middle_fates_edict_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Middle_fates_edict_buff:GetModifierMagicalResistanceBonus() return 100 end
function modifier_Middle_fates_edict_buff:Advanced_GetModifierSpellAmplifyBonus() return self.SPELL_AMPLIFY_PERCENTAGE end
function modifier_Middle_fates_edict_buff:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end


modifier_Middle_fates_edict_debuff = class({})

function modifier_Middle_fates_edict_debuff:IsDebuff() return true end
function modifier_Middle_fates_edict_debuff:IsHidden() return false end
function modifier_Middle_fates_edict_debuff:IsPurgable() return true end

function modifier_Middle_fates_edict_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end