item_chaotic_chipped_vest = class({})

LinkLuaModifier("modifier_item_chaotic_chipped_vest", "items/item_chaotic_chipped_vest", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_chipped_vest:GetIntrinsicModifierName()
	return "modifier_item_chaotic_chipped_vest"
end


modifier_item_chaotic_chipped_vest = advanced_modifier({})

function modifier_item_chaotic_chipped_vest:IsDebuff() return false end
function modifier_item_chaotic_chipped_vest:IsHidden() return true end
function modifier_item_chaotic_chipped_vest:IsPurgable() return false end

function modifier_item_chaotic_chipped_vest:OnCreated(keys)
	self.ability = self:GetAbility()
	self.back = self.ability:GetSpecialValueFor("back")
end



function modifier_item_chaotic_chipped_vest:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}                      --攻击事件

	}
end


function modifier_item_chaotic_chipped_vest:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		if keys.unit:GetTeamNumber()==keys.attacker:GetTeamNumber() then
			return
		end
		ApplyDamage({victim = keys.attacker, attacker = keys.unit, damage = self.back, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
	end
end




