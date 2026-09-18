LinkLuaModifier( "modifier_chaotic_blade_of_backstab", "chaotic_spell/class_2/chaotic_blade_of_backstab.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_blade_of_backstab_armor_reduction", "chaotic_spell/class_2/chaotic_blade_of_backstab.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_blade_of_backstab = class({})

function chaotic_blade_of_backstab:GetIntrinsicModifierName()
	return "modifier_chaotic_blade_of_backstab"
end

---------------------------------------------------------------------

modifier_chaotic_blade_of_backstab = advanced_modifier({})
function modifier_chaotic_blade_of_backstab:IsHidden() return true end
function modifier_chaotic_blade_of_backstab:IsPurgable() return false end


function modifier_chaotic_blade_of_backstab:OnCreated(params)
	self.cd = self:GetAbility():GetSpecialValueFor("cd")
end

function modifier_chaotic_blade_of_backstab:OnRefresh(params)
	self.cd = self:GetAbility():GetSpecialValueFor("cd")
end


function modifier_chaotic_blade_of_backstab:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_chaotic_blade_of_backstab:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_chaotic_blade_of_backstab:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			local backstab_modifier = self:GetParent():FindModifierByName("modifier_hd_backstab")
			if backstab_modifier then
				backstab_modifier:AlwaysBackstab(1) -- Call the method to enable always backstab for 5 seconds
			else
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hd_backstab", {})
			end

			params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_blade_of_backstab_armor_reduction", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			self:GetAbility():StartCooldown(self.cd)
		end
	end
end




modifier_chaotic_blade_of_backstab_armor_reduction = advanced_modifier({})

function modifier_chaotic_blade_of_backstab_armor_reduction:IsDebuff() return true end
function modifier_chaotic_blade_of_backstab_armor_reduction:IsPurgable() return false end

function modifier_chaotic_blade_of_backstab_armor_reduction:OnCreated(params)
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end
function modifier_chaotic_blade_of_backstab_armor_reduction:OnRefresh(params)
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_chaotic_blade_of_backstab_armor_reduction:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_chaotic_blade_of_backstab_armor_reduction:Advanced_GetModifierPhysicalArmorBonus()
    return -self.armor_reduction
end

