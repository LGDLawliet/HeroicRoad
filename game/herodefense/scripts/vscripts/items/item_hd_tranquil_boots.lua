item_hd_tranquil_boots = class({})

LinkLuaModifier("modifier_item_hd_tranquil_boots", "items/item_hd_tranquil_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tranquil_boots_active", "items/item_hd_tranquil_boots", LUA_MODIFIER_MOTION_NONE)

function item_hd_tranquil_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_tranquil_boots"
end


modifier_item_hd_tranquil_boots = advanced_modifier({})

function modifier_item_hd_tranquil_boots:IsDebuff() return false end
function modifier_item_hd_tranquil_boots:IsHidden() return true end
function modifier_item_hd_tranquil_boots:IsPurgable() return false end
function modifier_item_hd_tranquil_boots:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.duration = self.ability:GetSpecialValueFor("duration")
end


function modifier_item_hd_tranquil_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end

function modifier_item_hd_tranquil_boots:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}

    }
end

function modifier_item_hd_tranquil_boots:CheckState()
	if not IsServer() then
		return
	end
	
	if not self:GetParent():FindModifierByName("modifier_item_hd_tranquil_boots_active") then
		return{
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		}
	else
		return
	end
end

function modifier_item_hd_tranquil_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_tranquil_boots:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_amp end


function modifier_item_hd_tranquil_boots:OnTakeDamage(params)
	if IsServer() then
		if params.unit:GetTeamNumber()== params.attacker:GetTeamNumber() then
			return
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_tranquil_boots_active", {duration = self.duration})
		end
	end
end

------

modifier_item_hd_tranquil_boots_active = advanced_modifier({})

function modifier_item_hd_tranquil_boots_active:IsDebuff() return false end
function modifier_item_hd_tranquil_boots_active:IsHidden() return false end
function modifier_item_hd_tranquil_boots_active:IsPurgable() return false end

function modifier_item_hd_tranquil_boots_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")    
end
function modifier_item_hd_tranquil_boots_active:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")    
end

function modifier_item_hd_tranquil_boots_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end

function modifier_item_hd_tranquil_boots_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,

    }
end

function modifier_item_hd_tranquil_boots_active:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_tranquil_boots_active:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_amp end
