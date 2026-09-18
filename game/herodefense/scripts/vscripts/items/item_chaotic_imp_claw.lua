LinkLuaModifier("modifier_item_chaotic_imp_claw", "items/item_chaotic_imp_claw.lua", LUA_MODIFIER_MOTION_NONE)


item_chaotic_imp_claw = class({})

function item_chaotic_imp_claw:GetIntrinsicModifierName()
    return "modifier_item_chaotic_imp_claw"
end

modifier_item_chaotic_imp_claw = advanced_modifier({})

function modifier_item_chaotic_imp_claw:IsHidden() return true end
function modifier_item_chaotic_imp_claw:IsPurgable() return false end
function modifier_item_chaotic_imp_claw:RemoveOnDeath() return false end
function modifier_item_chaotic_imp_claw:OnCreated(table)
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    self.cri = self:GetAbility():GetSpecialValueFor("crit")
    
    self.crit = {}
end
function modifier_item_chaotic_imp_claw:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
    }
end

function modifier_item_chaotic_imp_claw:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
        local random = math.random
		if self.chance >= random(1,100) then
			self.crit[keys.record] = true
			return  self.cri
		else		
			return 0
		end
	end
end

function modifier_item_chaotic_imp_claw:OnAttackFail(keys) self.crit[keys.record] = nil end

function modifier_item_chaotic_imp_claw:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent()or not keys.target:IsAlive() then
		return
	end
	self.crit[keys.record] = nil
end