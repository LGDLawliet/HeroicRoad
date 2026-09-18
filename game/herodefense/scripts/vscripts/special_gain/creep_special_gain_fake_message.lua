creep_special_gain_fake_message = class({})
-- LinkLuaModifier("modifier_creep_special_gain_fake_message_arua", "skills/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_fake_message_arua_effect", "skills/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_fake_message", "special_gain/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_fake_message_active", "special_gain/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_fake_message_pre", "special_gain/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_fake_message_on", "special_gain/creep_special_gain_fake_message", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
require('internal/timers')   --计时器功能
function creep_special_gain_fake_message:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_fake_message"
end


modifier_creep_special_gain_fake_message = class({})




function modifier_creep_special_gain_fake_message:IsHidden() 
	return false
end
function modifier_creep_special_gain_fake_message:IsPurgable() return false end
function modifier_creep_special_gain_fake_message:IsDebuff() return false end
-- function modifier_creep_special_gain_fake_message:GetEffectName() return "particles/new_effect/new_effect/invalidation_magic.vpcf" end
-- function modifier_creep_special_gain_fake_message:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_fake_message:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(15)
	end
end
function modifier_creep_special_gain_fake_message:OnIntervalThink()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	parent:AddNewModifier(parent, ability, "modifier_creep_special_gain_fake_message_pre", {duration = 2})
	
	Timers:CreateTimer(2, function()
		if parent and not parent:IsNull() and ability and not ability:IsNull() then
			parent:AddNewModifier(parent, ability, "modifier_creep_special_gain_fake_message_on", {duration = 1})
		end
		
	end)
end



modifier_creep_special_gain_fake_message_pre = class({})

function modifier_creep_special_gain_fake_message_pre:IsDebuff() return false end
function modifier_creep_special_gain_fake_message_pre:IsHidden() return false end
function modifier_creep_special_gain_fake_message_pre:IsPurgable() return false end
function modifier_creep_special_gain_fake_message_pre:OnCreated(keys)
	if IsServer() then
		self.parent = self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/fake_message.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)
	end
end




modifier_creep_special_gain_fake_message_on = class({})

function modifier_creep_special_gain_fake_message_on:IsHidden() 	return false end
function modifier_creep_special_gain_fake_message_on:IsPurgable() return false end
function modifier_creep_special_gain_fake_message_on:IsDebuff() return false end
function modifier_creep_special_gain_fake_message_on:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_creep_special_gain_fake_message_on:OnAttackLanded(keys)
	if IsServer() then

		if keys.target == self:GetParent()then
			if keys.attacker:IsMagicImmune() then
				return
			end
			local ModifierStatusNegativeGain = keys.target:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = keys.attacker:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			keys.attacker:AddNewModifier(keys.target, self:GetAbility(), "modifier_creep_special_gain_fake_message_active", {duration = 5*StatusResistance})

		end
	end
end






modifier_creep_special_gain_fake_message_active = class({})

function modifier_creep_special_gain_fake_message_active:IsDebuff() return true end
function modifier_creep_special_gain_fake_message_active:IsHidden() return false end
function modifier_creep_special_gain_fake_message_active:IsPurgable() return false end
function modifier_creep_special_gain_fake_message_active:IsPurgeException() return true end
function modifier_creep_special_gain_fake_message_active:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	


	return state
end