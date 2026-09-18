item_hd_arcane_boots = class({})

LinkLuaModifier("modifier_item_hd_arcane_boots", "items/item_hd_arcane_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcane_boots_active", "items/item_hd_arcane_boots", LUA_MODIFIER_MOTION_NONE)

function item_hd_arcane_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_boots"
end

function item_hd_arcane_boots:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

modifier_item_hd_arcane_boots = advanced_modifier({})

function modifier_item_hd_arcane_boots:IsDebuff() return false end
function modifier_item_hd_arcane_boots:IsHidden() return true end
function modifier_item_hd_arcane_boots:IsPurgable() 		return false end
function modifier_item_hd_arcane_boots:IsPurgeException() 	return false end
function modifier_item_hd_arcane_boots:RemoveOnDeath()  return false end


function modifier_item_hd_arcane_boots:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.mana = self.ability:GetSpecialValueFor("mana")
	self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
		self:StartIntervalThink(0.1)
	end

end
function modifier_item_hd_arcane_boots:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() and Game_State:IsInBattle() then
		if not self:GetParent():IsAlive() then
			return
		end
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
		 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
		self:GetParent():EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
		for _, unit in pairs(units) do

			if unit:IsRealHero() then
				unit:GiveMana(self.mana)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, self.mana, nil)
				unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_arcane_boots_active", {duration = self.duration})
				self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.particle)
			end

		end           
		self:GetAbility():UseResources(true, true, true,true)
	end
end


function modifier_item_hd_arcane_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end
function modifier_item_hd_arcane_boots:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_MANA_BONUS,                     --魔法值
	}
end

function modifier_item_hd_arcane_boots:AdvancedGetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_arcane_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end




modifier_item_hd_arcane_boots_active = advanced_modifier({})

function modifier_item_hd_arcane_boots_active:IsDebuff() return false end
function modifier_item_hd_arcane_boots_active:IsHidden() return true end
function modifier_item_hd_arcane_boots_active:IsPurgable() 		return false end
function modifier_item_hd_arcane_boots_active:IsPurgeException() 	return false end
function modifier_item_hd_arcane_boots_active:RemoveOnDeath()  return false end


function modifier_item_hd_arcane_boots_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")
end
function modifier_item_hd_arcane_boots_active:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")
end
function modifier_item_hd_arcane_boots_active:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,                     --魔法值
	}
end
function modifier_item_hd_arcane_boots_active:Advanced_GetModifierSpellAmplifyBonus()return self.active end