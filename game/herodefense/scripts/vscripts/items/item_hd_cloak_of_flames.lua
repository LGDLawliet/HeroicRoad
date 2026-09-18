item_hd_cloak_of_flames = class({})

LinkLuaModifier("modifier_item_hd_cloak_of_flames", "items/item_hd_cloak_of_flames", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_cloak_of_flames_active", "items/item_hd_cloak_of_flames", LUA_MODIFIER_MOTION_NONE)

function item_hd_cloak_of_flames:GetIntrinsicModifierName()
	return "modifier_item_hd_cloak_of_flames"
end

function item_hd_cloak_of_flames:OnSpellStart()
	local caster    =   self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_hd_cloak_of_flames_active", {duration = duration})
end
------------------------------------------------------------------------
modifier_item_hd_cloak_of_flames = advanced_modifier({})

function modifier_item_hd_cloak_of_flames:IsDebuff() return false end
function modifier_item_hd_cloak_of_flames:IsHidden() return true end
function modifier_item_hd_cloak_of_flames:IsPurgable() return false end

function modifier_item_hd_cloak_of_flames:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
end

function modifier_item_hd_cloak_of_flames:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end

function modifier_item_hd_cloak_of_flames:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end

function modifier_item_hd_cloak_of_flames:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_cloak_of_flames:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
--------------------------------------------------------------------------

modifier_item_hd_cloak_of_flames_active = advanced_modifier({})

function modifier_item_hd_cloak_of_flames_active:IsDebuff() return false end
function modifier_item_hd_cloak_of_flames_active:IsHidden() return false end
function modifier_item_hd_cloak_of_flames_active:IsPurgable() return true end
function modifier_item_hd_cloak_of_flames_active:GetTexture()return "item_cloak_of_flames" end
function modifier_item_hd_cloak_of_flames_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_cloak_of_flames_active:GetEffectName()	return "particles/new_effect/new_effect/new_big_huskar_burning_spear_debuff.vpcf" end
function modifier_item_hd_cloak_of_flames_active:OnCreated(keys)
    local parent = self:GetParent()
	self.index = self:GetAbility():GetSpecialValueFor("damage")*0.01
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	if IsServer() then
		self.damage = parent:GetMaxHealth()*self.index
		self:StartIntervalThink(self.interval)
	end
end

function modifier_item_hd_cloak_of_flames_active:OnRefresh(keys)
    local parent = self:GetParent()
	self.index = self:GetAbility():GetSpecialValueFor("damage")*0.01
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	if IsServer() then
		self.damage = parent:GetMaxHealth()*self.index
	end
end

function modifier_item_hd_cloak_of_flames_active:OnIntervalThink()
	if IsServer() then

		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		for i, unit in pairs(units) do
			-- print(i)
			local damageTable = {
				victim = unit,
				attacker = self:GetParent(),
				damage = self.damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = self:GetAbility(),
				hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
				}
			local applydamage = ApplyDamage(damageTable)
			if i>=self.max then
				break
			end
		end

		
	end
end

function modifier_item_hd_cloak_of_flames_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self.incoming
end

function modifier_item_hd_cloak_of_flames_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
