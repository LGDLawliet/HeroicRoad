item_hd_lotus_orb = class({})
LinkLuaModifier("modifier_item_hd_lotus_orb", "items/item_hd_lotus_orb", LUA_MODIFIER_MOTION_NONE)

function item_hd_lotus_orb:GetIntrinsicModifierName()
	return "modifier_item_hd_lotus_orb"
end

function item_hd_lotus_orb:OnSpellStart()
	local target = self:GetCaster()
	local equip = self
	local cost = self:GetSpecialValueFor("upgrade_cost")
	local max_lvl = self:GetSpecialValueFor("max_lvl")
	
	if self:GetCaster():GetGold() < cost then return end
	EquipUpgrade(target,equip,cost,max_lvl)
end

modifier_item_hd_lotus_orb = advanced_modifier({})

function modifier_item_hd_lotus_orb:IsDebuff() return false end
function modifier_item_hd_lotus_orb:IsHidden() return true end
function modifier_item_hd_lotus_orb:IsPurgable() return false end
function modifier_item_hd_lotus_orb:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.profic = self.ability:GetSpecialValueFor("profic")
    self.spell_resist = self.ability:GetSpecialValueFor("spell_resist")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
end
function modifier_item_hd_lotus_orb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_hd_lotus_orb:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_item_hd_lotus_orb:GetModifierMagicalResistanceBonus() 	return self.spell_resist end
function modifier_item_hd_lotus_orb:Advanced_GetModifier_TalentEffectGain() return self.profic end
function modifier_item_hd_lotus_orb:Advanced_GetModifierIncomingDamage_Percentage(keys) 
    if IsServer() then
        if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
            return -self.incoming
        end
    end
end
