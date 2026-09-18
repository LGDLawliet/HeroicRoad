item_hd_arcane_boots_2 = class({})

LinkLuaModifier("modifier_item_hd_arcane_boots_2", "items/item_hd_arcane_boots_2", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function item_hd_arcane_boots_2:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_boots_2"
end


modifier_item_hd_arcane_boots_2 = advanced_modifier({})

function modifier_item_hd_arcane_boots_2:IsDebuff() return false end
function modifier_item_hd_arcane_boots_2:IsHidden() return true end
function modifier_item_hd_arcane_boots_2:IsPurgable() 		return false end
function modifier_item_hd_arcane_boots_2:IsPurgeException() 	return false end
function modifier_item_hd_arcane_boots_2:RemoveOnDeath()  return false end
function modifier_item_hd_arcane_boots_2:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    if IsServer() then
		self:StartIntervalThink(0.1)
	end

end

function modifier_item_hd_arcane_boots_2:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then

		self:GetAbility():UseResources(true, true, true,true)
		self:GetAbility():StartCooldown(10)

		local caster = self:GetParent()
		if not caster:IsAlive() then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  800,
		 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local amount = 0  
		caster:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")

		for _, unit in pairs(units) do
			local healing =  HealWithGain(300+unit:GetHealth()*0.2,caster,unit,self:GetAbility())
			Timers:CreateTimer(0.5, function()
				if unit and not unit:IsNull() then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				end

			end)
			unit:GiveMana(150)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, 150, nil)
			self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)
			amount = amount + 1
			if amount>7 then
				break
			end
		end           
		
	end
end


function modifier_item_hd_arcane_boots_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                   --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                     --魔法值
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度


	}
end

function modifier_item_hd_arcane_boots_2:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_arcane_boots_2:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_arcane_boots_2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

function modifier_item_hd_arcane_boots_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_arcane_boots_2:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end