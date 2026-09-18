item_hd_imp_claw = class({})
-- LinkLuaModifier("modifier_item_hd_imp_claw_arua", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_imp_claw_arua_effect", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_imp_claw", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_imp_claw_active", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_imp_claw_active_standby", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_imp_claw_active_debuff", "items/item_hd_imp_claw", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_imp_claw:GetIntrinsicModifierName()
	return "modifier_item_hd_imp_claw"
end



modifier_item_hd_imp_claw = advanced_modifier({})

function modifier_item_hd_imp_claw:IsDebuff() return false end
function modifier_item_hd_imp_claw:IsHidden() return true end
function modifier_item_hd_imp_claw:IsPurgable() return false end
function modifier_item_hd_imp_claw:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.cri = self.ability:GetSpecialValueFor("cri")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.crit = {}
end
function modifier_item_hd_imp_claw:OnDestroy() self.crit = nil end
function modifier_item_hd_imp_claw:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	  	MODIFIER_EVENT_ON_ATTACK_FAIL
	} 
end
function modifier_item_hd_imp_claw:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_imp_claw:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
    }
end

function modifier_item_hd_imp_claw:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
		local pct = self.chance
		if pct >= RandomInt(1,100) or self:GetAbility():IsCooldownReady() then
			self.crit[keys.record] = true
            self:GetAbility():UseResources(true, true, true, true)
			return  self.cri
		else		
			return 0
		end
	end
end

function modifier_item_hd_imp_claw:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_item_hd_imp_claw:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent()or not keys.target:IsAlive() then
		return
	end
	self.crit[keys.record] = nil
end