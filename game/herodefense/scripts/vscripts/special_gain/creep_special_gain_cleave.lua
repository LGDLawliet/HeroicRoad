creep_special_gain_cleave = class({})
-- LinkLuaModifier("modifier_creep_special_gain_cleave_arua", "skills/creep_special_gain_cleave", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_cleave_arua_effect", "skills/creep_special_gain_cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_cleave", "special_gain/creep_special_gain_cleave", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_cleave:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_cleave"
end


modifier_creep_special_gain_cleave = class({})




function modifier_creep_special_gain_cleave:IsDebuff()			return false end
function modifier_creep_special_gain_cleave:IsHidden() 			return false end
function modifier_creep_special_gain_cleave:IsPurgable() 		return false end
function modifier_creep_special_gain_cleave:IsPurgeException() 	return false end
function modifier_creep_special_gain_cleave:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_creep_special_gain_cleave:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local caster =  self:GetCaster()
	local ability = self:GetAbility()

	-- if keys.attacker:IsRangedAttacker()then
	-- 	return
	-- end

	if keys.attacker ~= caster or keys.target:IsBuilding() or keys.target:IsOther() or caster:PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.attacker:IsDisableCleave() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
	local dmg = keys.damage * 0.5 
		local pfx = "particles/units/heroes/hero_sven/sven_spell_great_cleave_crit.vpcf"
		DoIMBACleaveAttack(caster, keys.target, ability, dmg, 
			150,
			500, 
			700, pfx)
end




