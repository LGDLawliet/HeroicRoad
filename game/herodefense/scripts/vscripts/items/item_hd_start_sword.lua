item_hd_start_sword = class({})
-- LinkLuaModifier("modifier_item_hd_start_sword_arua", "items/item_hd_start_sword", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_start_sword_arua_effect", "items/item_hd_start_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_start_sword", "items/item_hd_start_sword", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_start_sword:GetIntrinsicModifierName()
	return "modifier_item_hd_start_sword"
end



modifier_item_hd_start_sword = advanced_modifier({})

function modifier_item_hd_start_sword:IsDebuff() return false end
function modifier_item_hd_start_sword:IsHidden() return true end
function modifier_item_hd_start_sword:IsPurgable() return false end
function modifier_item_hd_start_sword:IsPurgeException() return false end
function modifier_item_hd_start_sword:RemoveOnDeath() return false end

function modifier_item_hd_start_sword:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		local parent = self:GetParent()
		if parent.start_sword then
			self:SetStackCount(parent.start_sword)
		end
	end
end


function modifier_item_hd_start_sword:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}

	return funcs
end


function modifier_item_hd_start_sword:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage+self:GetStackCount()*2
end


function modifier_item_hd_start_sword:OnWaveEnd()
	self:SetStackCount(math.min(self:GetStackCount()+1,5))
	return 1
end
function modifier_item_hd_start_sword:OnDestroy()
	self:GetParent().start_sword = self:GetStackCount()
end

function modifier_item_hd_start_sword:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end
