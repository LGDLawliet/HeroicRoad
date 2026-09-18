item_hd_chipped_vest = class({})

LinkLuaModifier("modifier_item_hd_chipped_vest", "items/item_hd_chipped_vest", LUA_MODIFIER_MOTION_NONE)

function item_hd_chipped_vest:GetIntrinsicModifierName()
	return "modifier_item_hd_chipped_vest"
end


modifier_item_hd_chipped_vest = class({})

function modifier_item_hd_chipped_vest:IsDebuff() return false end
function modifier_item_hd_chipped_vest:IsHidden() return true end
function modifier_item_hd_chipped_vest:IsPurgable() return false end

function modifier_item_hd_chipped_vest:OnCreated(keys)
	self.ability = self:GetAbility()
	self.damage = self.ability:GetSpecialValueFor("damage")
	self:StartIntervalThink(1)
end

function modifier_item_hd_chipped_vest:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_return") or self:GetCaster():FindAbilityByName("Middle_return") or self:GetCaster():FindAbilityByName("Advanced_return") then
		self.damage = self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("damage_extra")
	else
		self.damage = self.ability:GetSpecialValueFor("damage")
	end
end

function modifier_item_hd_chipped_vest:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE                        --攻击事件

	}
end


function modifier_item_hd_chipped_vest:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and self:GetAbility():IsCooldownReady() then
		if keys.unit:GetTeamNumber()==keys.attacker:GetTeamNumber() then
			return
		end
		self:GetAbility():UseResources(true, true, true,true)
		ApplyDamage({
			victim = keys.attacker, 
			attacker = keys.unit, 
			damage = self.damage, 
			damage_type = DAMAGE_TYPE_PHYSICAL, 
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT,
		})
	end
end




