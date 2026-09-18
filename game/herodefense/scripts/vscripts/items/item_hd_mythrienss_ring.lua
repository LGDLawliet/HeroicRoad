item_hd_mythrienss_ring = item_hd_mythrienss_ring or class({})

LinkLuaModifier("modifier_item_hd_mythrienss_ring", "items/item_hd_mythrienss_ring", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_mythrienss_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_mythrienss_ring"
end

modifier_item_hd_mythrienss_ring = modifier_item_hd_mythrienss_ring or advanced_modifier({})

function modifier_item_hd_mythrienss_ring:IsDebuff() return false end
function modifier_item_hd_mythrienss_ring:IsHidden() return true end
function modifier_item_hd_mythrienss_ring:IsPurgable() return false end
function modifier_item_hd_mythrienss_ring:IsPurgeException() return false end
function modifier_item_hd_mythrienss_ring:RemoveOnDeath() return false end
function modifier_item_hd_mythrienss_ring:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		-- self:StartIntervalThink(1)
	end
end

function modifier_item_hd_mythrienss_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,   
	}
end
function modifier_item_hd_mythrienss_ring:GetModifierBonusStats_Strength()return self.bonus_str end
-- function modifier_item_hd_mythrienss_ring:GetPriority() return 5 end
-- function modifier_item_hd_mythrienss_ring:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_BLOCK_DISABLED]=false,

-- 	}
	

-- 	return state
-- end

function modifier_item_hd_mythrienss_ring:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE
	}
end


function modifier_item_hd_mythrienss_ring:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return -1000
end
