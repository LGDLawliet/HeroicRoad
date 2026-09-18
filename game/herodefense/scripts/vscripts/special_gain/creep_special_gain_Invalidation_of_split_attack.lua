creep_special_gain_Invalidation_of_split_attack = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_split_attack_arua", "skills/creep_special_gain_Invalidation_of_split_attack", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_split_attack_arua_effect", "skills/creep_special_gain_Invalidation_of_split_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_split_attack", "special_gain/creep_special_gain_Invalidation_of_split_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_split_attack_active", "special_gain/creep_special_gain_Invalidation_of_split_attack", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Invalidation_of_split_attack:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Invalidation_of_split_attack"
end


modifier_creep_special_gain_Invalidation_of_split_attack = class({})




function modifier_creep_special_gain_Invalidation_of_split_attack:IsHidden() 
	return false
end
function modifier_creep_special_gain_Invalidation_of_split_attack:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_split_attack:IsDebuff() return false end
function modifier_creep_special_gain_Invalidation_of_split_attack:GetEffectName() return "particles/new_effect/new_effect/invalidation_of_split_attack.vpcf" end
function modifier_creep_special_gain_Invalidation_of_split_attack:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Invalidation_of_split_attack:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_creep_special_gain_Invalidation_of_split_attack:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit==self:GetParent() then
			if not keys.attacker then
				return
			end
			if self:GetParent():PassivesDisabled() then
				return
			end
			if keys.attacker:IsRangedAttacker() then
				if not keys.attacker:IsMagicImmune() and CalculateDistance(keys.attacker,keys.unit)<=400 then
					local ModifierStatusNegativeGain = keys.unit:GetModifierStatusNegativeGainIndex(1)
					local StatusResistance = keys.attacker:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					keys.attacker:AddNewModifier(keys.unit, self:GetAbility(), "modifier_creep_special_gain_Invalidation_of_split_attack_active", {duration = 0.5*StatusResistance})
				end
			end

		end
		
	end
end





modifier_creep_special_gain_Invalidation_of_split_attack_active = class({})

function modifier_creep_special_gain_Invalidation_of_split_attack_active:IsDebuff() return true end
function modifier_creep_special_gain_Invalidation_of_split_attack_active:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_of_split_attack_active:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_split_attack_active:IsPurgeException() return true end
-- function modifier_creep_special_gain_Invalidation_of_split_attack_active:GetEffectName()	return "particles/dire_fx/dire_tower_decay.vpcf" end
-- function modifier_creep_special_gain_Invalidation_of_split_attack_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Invalidation_of_split_attack_active:OnCreated( kv )
	if IsServer() then
		local modifier_keys = {
			duration = -1,
			iSpecialAttack = 0,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 1,
	
		}
		self.attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
	end
end


function modifier_creep_special_gain_Invalidation_of_split_attack_active:OnDestroy( kv )
	if IsServer() then
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	end
end

