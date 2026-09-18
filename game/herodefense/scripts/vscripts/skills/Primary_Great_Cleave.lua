Primary_Great_Cleave = class({})

LinkLuaModifier("modifier_Primary_Great_Cleave_passive", "skills/Primary_Great_Cleave", LUA_MODIFIER_MOTION_NONE)

function Primary_Great_Cleave:IsHiddenWhenStolen() 	return false end
function Primary_Great_Cleave:IsRefreshable() 		return true end
function Primary_Great_Cleave:IsStealable() 			return true end
function Primary_Great_Cleave:IsNetherWardStealable()	return true end
function Primary_Great_Cleave:GetIntrinsicModifierName() return "modifier_Primary_Great_Cleave_passive" end


modifier_Primary_Great_Cleave_passive = advanced_modifier({})

function modifier_Primary_Great_Cleave_passive:IsDebuff()			return false end
function modifier_Primary_Great_Cleave_passive:IsHidden() 			return true end
function modifier_Primary_Great_Cleave_passive:IsPurgable() 		return false end
function modifier_Primary_Great_Cleave_passive:IsPurgeException() 	return false end
function modifier_Primary_Great_Cleave_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_Primary_Great_Cleave_passive:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.start_width = self.ability:GetSpecialValueFor("cleave_starting_width")
	self.end_width = self.ability:GetSpecialValueFor("cleave_ending_width")
	self.distance = self.ability:GetSpecialValueFor("cleave_distance")
	self.cleave = self.ability:GetSpecialValueFor("cleave_pct")*0.01
end
function modifier_Primary_Great_Cleave_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	local attacker = keys.attacker
	local caster =  self:GetCaster()
	local ability = self:GetAbility()
	if attacker:IsDisableCleave() then
		return
	end
	if attacker:IsRangedAttacker()then
		return
	end

	if attacker ~= caster or target:IsBuilding() or target:IsOther() or caster:PassivesDisabled() or not target:IsAlive() then
		return
	end
	local dmg = keys.damage * self.cleave
	local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
	DoIMBACleaveAttack(caster, target, ability, dmg, self.start_width,self.end_width, self.distance, pfx)
			
end
