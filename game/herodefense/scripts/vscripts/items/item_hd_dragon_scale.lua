item_hd_dragon_scale = class({})

LinkLuaModifier("modifier_item_hd_dragon_scale", "items/item_hd_dragon_scale", LUA_MODIFIER_MOTION_NONE)

function item_hd_dragon_scale:GetIntrinsicModifierName()
	return "modifier_item_hd_dragon_scale"
end
function item_hd_dragon_scale:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end



modifier_item_hd_dragon_scale = advanced_modifier({})

function modifier_item_hd_dragon_scale:IsDebuff() return false end
function modifier_item_hd_dragon_scale:IsHidden() return true end
function modifier_item_hd_dragon_scale:IsPurgable() return false end

function modifier_item_hd_dragon_scale:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_item_hd_dragon_scale:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetAbility():IsCooldownReady() then
			
			local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
			)

			for _, enemy in pairs(enemies) do
				local damageTable = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self:GetCaster():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("active")*0.01,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
					ability = nil, --Optional.
					}
				ApplyDamage(damageTable)
				self:GetAbility():UseResources(true, true, true, true)

			end
		end
	end
end

function modifier_item_hd_dragon_scale:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
    }
end
function modifier_item_hd_dragon_scale:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_dragon_scale:AdvancedGetModifierHealthBonus()	
	return self.bonus_health
end




