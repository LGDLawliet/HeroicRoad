item_hd_shield_of_lackeys = class({})

LinkLuaModifier("modifier_item_hd_shield_of_lackeys", "items/item_hd_shield_of_lackeys", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shield_of_lackeys_active", "items/item_hd_shield_of_lackeys", LUA_MODIFIER_MOTION_NONE)

function item_hd_shield_of_lackeys:GetIntrinsicModifierName()
	return "modifier_item_hd_shield_of_lackeys"
end
function item_hd_shield_of_lackeys:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_item_hd_shield_of_lackeys = advanced_modifier({})

function modifier_item_hd_shield_of_lackeys:IsDebuff() return false end
function modifier_item_hd_shield_of_lackeys:IsHidden() return true end
function modifier_item_hd_shield_of_lackeys:IsPurgable() return false end

function modifier_item_hd_shield_of_lackeys:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.max = self.ability:GetSpecialValueFor("max")
    self.duration = self.ability:GetSpecialValueFor("duration")
end
function modifier_item_hd_shield_of_lackeys:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
function modifier_item_hd_shield_of_lackeys:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_shield_of_lackeys:OnWaveStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
   	--self:GetParent():EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
   	for i, unit in pairs(units) do
		if unit ~= caster then
           unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_shield_of_lackeys_active", {duration = self.duration})
	   	    if i >= self.max then
			    break
		    end
		end
   	end
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_shield_of_lackeys_active", {duration = self.duration})
end

modifier_item_hd_shield_of_lackeys_active = advanced_modifier({})

function modifier_item_hd_shield_of_lackeys_active:IsDebuff() return false end
function modifier_item_hd_shield_of_lackeys_active:IsHidden() return false end
function modifier_item_hd_shield_of_lackeys_active:IsPurgable() return false end
function modifier_item_hd_shield_of_lackeys_active:GetTexture()return "item_shield_of_lackeys" end
function modifier_item_hd_shield_of_lackeys_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_shield_of_lackeys_active:OnCreated()
    self.armor = self:GetAbility():GetSpecialValueFor("armor")
    if IsServer() then
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end
function modifier_item_hd_shield_of_lackeys_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shield_of_lackeys_active:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then self:Destroy() return end
    return self.armor
end
function modifier_item_hd_shield_of_lackeys_active:AddCustomTransmitterData( )
	return
	{
		armor = self.armor,
	}
end

function modifier_item_hd_shield_of_lackeys_active:HandleCustomTransmitterData( data )
	self.armor = data.armor
end
