LinkLuaModifier( "modifier_item_chaotic_class_range_phy", "items/item_chaotic_class_range_phy.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_range_phy_active", "items/item_chaotic_class_range_phy.lua", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_range_phy = class({})

function item_chaotic_class_range_phy:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_range_phy")
    if item ~=nil then
		local modifier = caster:FindModifierByName("modifier_item_chaotic_class_range_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_melee_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_summon")
		or caster:FindModifierByName("modifier_item_chaotic_class_ass")

		if modifier then
			modifier:Destroy()
		end
        caster:AddNewModifier(caster, nil, "modifier_item_chaotic_class_range_phy", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_range_phy = advanced_modifier({})

function modifier_item_chaotic_class_range_phy:IsDebuff()return false end
function modifier_item_chaotic_class_range_phy:IsHidden()return false end
function modifier_item_chaotic_class_range_phy:IsPurgable()return false end
function modifier_item_chaotic_class_range_phy:RemoveOnDeath()return false end
function modifier_item_chaotic_class_range_phy:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_range_phy:GetTexture()	return "item_rapier" end

function modifier_item_chaotic_class_range_phy:OnCreated(params)
	self.outgoing = 1
	self.parent = self:GetParent()
end

function modifier_item_chaotic_class_range_phy:ADDeclareFunctions()
	return {
		--MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_item_chaotic_class_range_phy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_range_phy:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	local attack = self.parent:GetLevel()*self.outgoing
	return attack
end

function modifier_item_chaotic_class_range_phy:OnTooltip()
	return self.parent:GetLevel()*self.outgoing
end

-- function modifier_item_chaotic_class_range_phy:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 	}
-- end

-- function modifier_item_chaotic_class_range_phy:GetModifierAttackSpeedBonus_Constant()
-- 	local speed = self:GetParent():Script_GetAttackRange()*self.range_to_speed
-- 	return speed
-- end

-- function modifier_item_chaotic_class_range_phy:GetModifierMoveSpeedBonus_Constant()
-- 	local speed = self:GetParent():Script_GetAttackRange()*self.range_to_speed
-- 	return speed
-- end

-- function modifier_item_chaotic_class_range_phy:OnAttack(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if keys.attacker ~= self:GetParent() then
-- 		return
-- 	end
-- 	if self:GetRemainingTime() > 0 then
-- 		return
-- 	end
-- 	local range = CalculateDistance(keys.attacker,keys.target)
-- 	local line = self.range_line * keys.attacker:Script_GetAttackRange()
-- 	local time = self.active_duration *self:GetParent():GetLevel()

-- 	if range < line then
-- 		return
-- 	end
-- 	self:SetDuration(self.interval, true)
-- 	keys.attacker:AddNewModifier(keys.attacker,nil,"modifier_item_chaotic_class_range_phy_active",{duration = time})
-- end

---------------------

modifier_item_chaotic_class_range_phy_active = advanced_modifier({})

function modifier_item_chaotic_class_range_phy_active:IsDebuff()return false end
function modifier_item_chaotic_class_range_phy_active:IsHidden()return false end
function modifier_item_chaotic_class_range_phy_active:IsPurgable()return false end
function modifier_item_chaotic_class_range_phy_active:RemoveOnDeath()return false end
function modifier_item_chaotic_class_range_phy_active:GetTexture()	return "item_dragon_lance" end

function modifier_item_chaotic_class_range_phy_active:OnCreated(params)
	self.active_attack = 10
end

function modifier_item_chaotic_class_range_phy_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_item_chaotic_class_range_phy_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_range_phy_active:Advanced_GetModifierPreAttack_BonusDamage()
	local attack = self:GetParent():GetLevel()*self.active_attack
	return attack
end

function modifier_item_chaotic_class_range_phy_active:OnTooltip()
	return self:GetParent():GetLevel()*self.active_attack
end