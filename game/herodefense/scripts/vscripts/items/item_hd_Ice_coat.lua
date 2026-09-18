item_hd_Ice_coat = class({})

LinkLuaModifier("modifier_item_hd_Ice_coat", "items/item_hd_Ice_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Ice_coat_effect", "items/item_hd_Ice_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Ice_coat_debuff", "items/item_hd_Ice_coat", LUA_MODIFIER_MOTION_NONE)


function item_hd_Ice_coat:GetIntrinsicModifierName()
	return "modifier_item_hd_Ice_coat"
end


modifier_item_hd_Ice_coat = advanced_modifier({})

function modifier_item_hd_Ice_coat:IsDebuff() return false end
function modifier_item_hd_Ice_coat:IsHidden() return true end
function modifier_item_hd_Ice_coat:IsPurgable() return false end

function modifier_item_hd_Ice_coat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.limit = self.ability:GetSpecialValueFor("limit")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_Ice_coat:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady() and Game_State:IsInBattle() then
			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  		DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)  

			local limit = 1
		   for _, unit in pairs(units) do
				self:GetAbility():UseResources(true, true, true, true)
				unit:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_Ice_coat_effect", {duration = self.duration})
				limit = limit + 1
				if limit > self.limit then
					break
				end
			   
		   end
		end			
		--self:SetHasCustomTransmitterData(true)
	end
end

function modifier_item_hd_Ice_coat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_Ice_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
-----------------------------------------------------------------------------------------------------------------------
modifier_item_hd_Ice_coat_effect = advanced_modifier({})

function modifier_item_hd_Ice_coat_effect:IsDebuff()			return false end
function modifier_item_hd_Ice_coat_effect:IsHidden() 			return false end
function modifier_item_hd_Ice_coat_effect:IsPurgable() 			return true end
function modifier_item_hd_Ice_coat_effect:IsPurgeException() 	return true end
function modifier_item_hd_Ice_coat_effect:GetEffectName() return "particles/new_effect/new_effect/ogre_magi_blue_shield_bubble.vpcf" end
function modifier_item_hd_Ice_coat_effect:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_Ice_coat_effect:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("active_armor")
	self.bonus_damage =  -self:GetAbility():GetSpecialValueFor("active_incoming")
end
function modifier_item_hd_Ice_coat_effect:GetTexture()
    return "item_Ice_coat"
end

function modifier_item_hd_Ice_coat_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_item_hd_Ice_coat_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_Ice_coat_effect:Advanced_GetModifierIncomingDamage_Percentage()
    return self.bonus_damage
end
