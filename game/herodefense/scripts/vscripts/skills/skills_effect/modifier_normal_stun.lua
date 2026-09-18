
modifier_normal_stun = class({})

function modifier_normal_stun:IsDebuff()			return true end
function modifier_normal_stun:IsHidden() 			return false end
function modifier_normal_stun:IsPurgable() 		return true end
function modifier_normal_stun:IsPurgeException() 	return true end
function modifier_normal_stun:IsStunDebuff() return true end
function modifier_normal_stun:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_normal_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_normal_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_normal_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_normal_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end



-- function modifier_normal_stun:OnCreated(kv)
-- 	if IsServer() then
--         local StatusResistance = 1 - self:GetParent():GetStatusResistance()
-- 	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
-- 	end
-- end

-- function modifier_normal_stun:OnRefresh(kv)
-- 	if IsServer() then
-- 		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
-- 	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
-- 	end
-- end
