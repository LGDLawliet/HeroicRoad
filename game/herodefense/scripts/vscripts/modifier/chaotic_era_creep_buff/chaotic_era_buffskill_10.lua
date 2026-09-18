chaotic_era_buffskill_10 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_10", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_10_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_10_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_10", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_10:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_10"
end

modifier_chaotic_era_buffskill_10 = advanced_modifier({})

function modifier_chaotic_era_buffskill_10:IsDebuff() return false end
function modifier_chaotic_era_buffskill_10:IsHidden() return false end
function modifier_chaotic_era_buffskill_10:IsPurgable() return false end

function modifier_chaotic_era_buffskill_10:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.duration = self.ability:GetSpecialValueFor("duration")
	if IsServer() then 
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_era_buffskill_10:OnIntervalThink(keys)
    if self.parent:IsAlive() then
		if self.parent:HasModifier("modifier_chaotic_era_buffskill_10_buff") then
			return 
		end
		local random = math.random
		if self.chance >= random(1,100) then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_era_buffskill_10_buff", {duration = self.duration})
		end
	end
end

modifier_chaotic_era_buffskill_10_buff = advanced_modifier({})

function modifier_chaotic_era_buffskill_10_buff:IsDebuff() return false end
function modifier_chaotic_era_buffskill_10_buff:IsHidden() return false end
function modifier_chaotic_era_buffskill_10_buff:IsPurgable() return false end
function modifier_chaotic_era_buffskill_10_buff:GetEffectName() return "particles/econ/items/broodmother/brood_ti9/brood_ti9_legs_ambient.vpcf" end
function modifier_chaotic_era_buffskill_10_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_10_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.speed_min = self.ability:GetSpecialValueFor("speed_min")
end

function modifier_chaotic_era_buffskill_10_buff:CheckState()
	return{
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_chaotic_era_buffskill_10_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_chaotic_era_buffskill_10_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}
	return funcs
end


function modifier_chaotic_era_buffskill_10_buff:Advanced_GetModifier_FlyingPathing()	
	return 1
end

function modifier_chaotic_era_buffskill_10_buff:GetModifierMoveSpeed_AbsoluteMin()
    return self.speed_min
end

