LinkLuaModifier( "modifier_item_set_storm_boot", "items/item_set_storm_boot.lua", LUA_MODIFIER_MOTION_NONE )


item_set_storm_boot = class({})

function item_set_storm_boot:GetIntrinsicModifierName()
    return "modifier_item_set_storm_boot"
end
---------------------------------------
modifier_item_set_storm_boot = advanced_modifier({})

function modifier_item_set_storm_boot:IsDebuff()return false end
function modifier_item_set_storm_boot:IsHidden()return true end
function modifier_item_set_storm_boot:IsPurgable()return false end
function modifier_item_set_storm_boot:RemoveOnDeath()return false end
function modifier_item_set_storm_boot:DestroyOnExpire()	return false end

function modifier_item_set_storm_boot:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.active_move = self:GetAbility():GetSpecialValueFor("active_move")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(0.5)
    end
end

function modifier_item_set_storm_boot:OnIntervalThink()
    self:SetStackCount(math.max(self:GetStackCount()-5,0))
end

function modifier_item_set_storm_boot:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_set_storm_boot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_item_set_storm_boot:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_item_set_storm_boot:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move
end

function modifier_item_set_storm_boot:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp
end

function modifier_item_set_storm_boot:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
    local modifier = keys.unit:FindModifierByName("modifier_item_set_storm_active")
    if not modifier then
        return
    end
	self:SetStackCount(self.active_move)
end
