item_hd_hunters_hoard = class({})
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_arua", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_arua_effect", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_hunters_hoard", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_hunters_hoard_active", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_effect", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_effect2", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_active_standby", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_debuff", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_hunters_hoard_thinker", "items/item_hd_hunters_hoard", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_hunters_hoard:GetIntrinsicModifierName()
	return "modifier_item_hd_hunters_hoard"
end




modifier_item_hd_hunters_hoard = class({})

function modifier_item_hd_hunters_hoard:IsDebuff() return false end
function modifier_item_hd_hunters_hoard:IsHidden() return true end
function modifier_item_hd_hunters_hoard:IsPurgable() return false end


function modifier_item_hd_hunters_hoard:OnCreated(keys)
    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_hunters_hoard:OnIntervalThink()
	if IsServer() then
	   if self:GetAbility():IsCooldownReady() then
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	   	if #units>0 then
		   	units[1]:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_hunters_hoard_active", {duration = 20})
			   self:GetAbility():UseResources(true, true, true,true)
	   	end
	   end

	end
end


modifier_item_hd_hunters_hoard_active = advanced_modifier({})

function modifier_item_hd_hunters_hoard_active:IsDebuff() return true end
function modifier_item_hd_hunters_hoard_active:IsHidden() return false end
function modifier_item_hd_hunters_hoard_active:IsPurgable() return false end
function modifier_item_hd_hunters_hoard_active:IsPurgeException() return true end
function modifier_item_hd_hunters_hoard_active:GetTexture()return "item_Siltbreaker_Gold_Bag_icon3" end
function modifier_item_hd_hunters_hoard_active:GetEffectName() return "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail.vpcf" end
function modifier_item_hd_hunters_hoard_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_hunters_hoard_active:OnCreated(table)
	if IsServer() then
		local gain = self:GetCaster():GetGold()/1000
		gain = gain-gain%1
		gain = math.min(gain,50)
		self:SetStackCount(gain)
	end
end
function modifier_item_hd_hunters_hoard_active:OnRefresh(table)
	if IsServer() then
		local gain = self:GetCaster():GetGold()/1000
		gain = gain-gain%1
		self:SetStackCount(gain)
	end
end


function modifier_item_hd_hunters_hoard_active:Advanced_GetModifierIncomingDamage_Percentage()return self:GetStackCount() end
function modifier_item_hd_hunters_hoard_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


