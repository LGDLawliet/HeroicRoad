item_hd_assassin_veil = class({})

LinkLuaModifier("modifier_item_hd_assassin_veil", "items/item_hd_assassin_veil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_assassin_veil_active", "items/item_hd_assassin_veil", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_assassin_veil:GetIntrinsicModifierName()
	return "modifier_item_hd_assassin_veil"
end


modifier_item_hd_assassin_veil = class({})

function modifier_item_hd_assassin_veil:IsDebuff() return false end
function modifier_item_hd_assassin_veil:IsHidden() return true end
function modifier_item_hd_assassin_veil:IsPurgable() return false end
function modifier_item_hd_assassin_veil:IsPurgeException() return false end
function modifier_item_hd_assassin_veil:RemoveOnDeath() return false end
function modifier_item_hd_assassin_veil:DestroyOnExpire() return false end
function modifier_item_hd_assassin_veil:OnCreated(keys)
	self.bonus_damage =  self:GetAbility():GetSpecialValueFor("bonus_damage")
	
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_item_hd_assassin_veil:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,     
		MODIFIER_EVENT_ON_ATTACK_LANDED 

	}
end
function modifier_item_hd_assassin_veil:GetModifierPreAttack_BonusDamage()return self.bonus_damage end

function modifier_item_hd_assassin_veil:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_hd_assassin_veil_active") and parent:IsAlive() then
			parent:AddNewModifier(parent, ability, "modifier_item_hd_assassin_veil_active", {})
		end
	end
end	
function modifier_item_hd_assassin_veil:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_hd_assassin_veil_active")
	end
end


function modifier_item_hd_assassin_veil:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		local cooldown = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cooldown*0.95)
		return
	end
	
end



modifier_item_hd_assassin_veil_active = advanced_modifier({})

function modifier_item_hd_assassin_veil_active:IsDebuff() return false end
function modifier_item_hd_assassin_veil_active:IsHidden() return false end
function modifier_item_hd_assassin_veil_active:IsPurgable() return false end
function modifier_item_hd_assassin_veil_active:IsPurgeException() return false end
function modifier_item_hd_assassin_veil_active:RemoveOnDeath() return false end
function modifier_item_hd_assassin_veil_active:GetTexture() return "item_assassin_veil" end

function modifier_item_hd_assassin_veil_active:OnDestroy(keys)
	if IsServer() then
		self:GetAbility():StartCooldown(5)
	end
end


-- advanced_modifier
function modifier_item_hd_assassin_veil_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
		MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER = {self:GetParent(),nil},
    }
end
function modifier_item_hd_assassin_veil_active:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return 100
end

function modifier_item_hd_assassin_veil_active:AdvancedOnCriticalStrikeTrigger(keys)

	if IsServer() then
		-- local unit =  keys.unit
		if keys.attacker==self:GetParent() then
			self:SetDuration(0.01, true)
		end

	end
end






