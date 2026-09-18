item_hd_god_slaying_emperor_blade = class({})

LinkLuaModifier("modifier_item_hd_god_slaying_emperor_blade", "items/item_hd_god_slaying_emperor_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_god_slaying_emperor_blade_active", "items/item_hd_god_slaying_emperor_blade", LUA_MODIFIER_MOTION_NONE)


function item_hd_god_slaying_emperor_blade:GetIntrinsicModifierName()
	return "modifier_item_hd_god_slaying_emperor_blade"
end




modifier_item_hd_god_slaying_emperor_blade = class({})

function modifier_item_hd_god_slaying_emperor_blade:IsDebuff() return false end
function modifier_item_hd_god_slaying_emperor_blade:IsHidden() return true end
function modifier_item_hd_god_slaying_emperor_blade:IsPurgable() return false end
function modifier_item_hd_god_slaying_emperor_blade:IsPurgeException() return false end
function modifier_item_hd_god_slaying_emperor_blade:RemoveOnDeath() return false end


function modifier_item_hd_god_slaying_emperor_blade:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end

function modifier_item_hd_god_slaying_emperor_blade:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算


	}
end

function modifier_item_hd_god_slaying_emperor_blade:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_item_hd_god_slaying_emperor_blade:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_god_slaying_emperor_blade_active", {duration = 0.1})
		end
	end
end


function modifier_item_hd_god_slaying_emperor_blade:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindAllModifiersByName("modifier_item_hd_god_slaying_emperor_blade_active")
			if #modifier>0 then
				modifier[1]:SafeDestroy()
			end
		end
	end
end




modifier_item_hd_god_slaying_emperor_blade_active = advanced_modifier({})

function modifier_item_hd_god_slaying_emperor_blade_active:IsDebuff() return true end
function modifier_item_hd_god_slaying_emperor_blade_active:IsHidden() return true end
function modifier_item_hd_god_slaying_emperor_blade_active:IsPurgable() return false end
function modifier_item_hd_god_slaying_emperor_blade_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_god_slaying_emperor_blade_active:OnCreated()
	if IsServer() then
		local armor = self:GetParent():GetPhysicalArmorValue(false)
		if armor>0 then
			self.reduce = -armor *0.4
		end
	end
end


function modifier_item_hd_god_slaying_emperor_blade_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_god_slaying_emperor_blade_active:Advanced_GetModifierPhysicalArmorBonus()
    return self.reduce or 0
end