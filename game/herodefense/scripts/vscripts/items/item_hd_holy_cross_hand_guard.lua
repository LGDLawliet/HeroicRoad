item_hd_holy_cross_hand_guard = class({})
-- LinkLuaModifier("modifier_item_hd_holy_cross_hand_guard_arua", "items/item_hd_holy_cross_hand_guard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_holy_cross_hand_guard_arua_effect", "items/item_hd_holy_cross_hand_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_cross_hand_guard", "items/item_hd_holy_cross_hand_guard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_holy_cross_hand_guard_active", "items/item_hd_holy_cross_hand_guard", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_holy_cross_hand_guard:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_cross_hand_guard"
end




modifier_item_hd_holy_cross_hand_guard = advanced_modifier({})

function modifier_item_hd_holy_cross_hand_guard:IsDebuff() return false end
function modifier_item_hd_holy_cross_hand_guard:IsHidden() return true end
function modifier_item_hd_holy_cross_hand_guard:IsPurgable() return false end

function modifier_item_hd_holy_cross_hand_guard:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	

    if IsServer() then
		self:StartIntervalThink(0.2)

	end
end

function modifier_item_hd_holy_cross_hand_guard:OnIntervalThink()
	if IsServer() then

		local ability = self:GetAbility()
	   if self:GetStackCount()>=self:GetParent():GetStrength()*5 and ability:IsCooldownReady()  then
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for _, unit in pairs(units) do
			if unit:GetHealthPercent()<95 then
				unit:EmitSound("Hero_Omniknight.HammerOfPurity.Crit")
				self.particle = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_WORLDORIGIN, unit)
				ParticleManager:SetParticleControl(self.particle, 0, unit:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.particle)
				HealWithGain(self:GetStackCount(),self:GetParent(),unit,ability,DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEAL+DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEALRECEIVE)
				-- :UseResources(true, true, true, true)
				ability:StartCooldown(1)
				self:SetStackCount(0)
				return

				
			end
			   
		   end
		
	   end
	end
end

function modifier_item_hd_holy_cross_hand_guard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end


function modifier_item_hd_holy_cross_hand_guard:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_holy_cross_hand_guard:OnCustomModifierFunction_Heal(keys)
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		-- print("--------")
		-- print("heal someone with "..keys.heal)
		if keys.heal<100 then
			return
		end
		local heal = keys.heal *0.2
		heal = heal - heal%1
		self:SetStackCount(self:GetStackCount()+heal)


	end
end

-- advanced_modifier
function modifier_item_hd_holy_cross_hand_guard:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_holy_cross_hand_guard:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end

function modifier_item_hd_holy_cross_hand_guard:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
