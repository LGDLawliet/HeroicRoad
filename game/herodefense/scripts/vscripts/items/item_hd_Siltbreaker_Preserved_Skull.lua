item_hd_Siltbreaker_Preserved_Skull = class({})
LinkLuaModifier("modifier_item_hd_Siltbreaker_Preserved_Skull", "items/item_hd_Siltbreaker_Preserved_Skull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Preserved_Skull_active", "items/item_hd_Siltbreaker_Preserved_Skull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Preserved_Skull_debuff", "items/item_hd_Siltbreaker_Preserved_Skull", LUA_MODIFIER_MOTION_NONE)


function item_hd_Siltbreaker_Preserved_Skull:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Preserved_Skull"
end
function item_hd_Siltbreaker_Preserved_Skull:GetCastRange()
	return self:GetSpecialValueFor("aura_radius") - self:GetCaster():GetCastRangeBonus()
end

modifier_item_hd_Siltbreaker_Preserved_Skull = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Preserved_Skull:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Preserved_Skull:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Preserved_Skull:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Preserved_Skull:IsAura() return true end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetAuraDuration() return 0.5 end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetModifierAura() return "modifier_item_hd_Siltbreaker_Preserved_Skull_active" end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_Siltbreaker_Preserved_Skull:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end


function modifier_item_hd_Siltbreaker_Preserved_Skull:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
end

function modifier_item_hd_Siltbreaker_Preserved_Skull:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
	}
end

function modifier_item_hd_Siltbreaker_Preserved_Skull:AdvancedGetModifierManaBonus()	return self.bonus_mana end

function modifier_item_hd_Siltbreaker_Preserved_Skull:Sphit(unit)
	if not IsServer() then
		return
	end
	local p_poison = self:GetCaster():FindAbilityByName("Primary_Poison_Touch")
	local m_poison = self:GetCaster():FindAbilityByName("Middle_Poison_Touch")
	local a_poison = self:GetCaster():FindAbilityByName("Advanced_Poison_Touch")
	local victim = unit
	if p_poison then
		victim:AddNewModifier(self:GetCaster(), p_poison, "modifier_Primary_Poison_Touch_slow", {duration = p_poison:GetSpecialValueFor("duration")})
	end
	if m_poison then
		victim:AddNewModifier(self:GetCaster(), m_poison, "modifier_Middle_Poison_Touch_slow", {duration = m_poison:GetSpecialValueFor("duration")})
	end
	if a_poison then
		victim:AddNewModifier(self:GetCaster(), a_poison, "modifier_Advanced_Poison_Touch_slow", {duration = a_poison:GetSpecialValueFor("duration")})
	end

end

--------------------------------------------------------
modifier_item_hd_Siltbreaker_Preserved_Skull_active = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Preserved_Skull_active:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Preserved_Skull_active:IsHidden() return false end
function modifier_item_hd_Siltbreaker_Preserved_Skull_active:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Preserved_Skull_active:GetTexture()return "item_Siltbreaker_Preserved_Skull" end
function modifier_item_hd_Siltbreaker_Preserved_Skull_active:OnCreated()
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
end

function modifier_item_hd_Siltbreaker_Preserved_Skull_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end

function modifier_item_hd_Siltbreaker_Preserved_Skull_active:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown
end
