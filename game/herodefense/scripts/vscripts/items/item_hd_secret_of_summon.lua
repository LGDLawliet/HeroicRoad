item_hd_secret_of_summon = class({})
-- LinkLuaModifier("modifier_item_hd_secret_of_summon_arua", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_summon_arua_effect", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_secret_of_summon", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_secret_of_summon_active", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_summon_active_effect", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_secret_of_summon_active_standby", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_summon_active_debuff", "items/item_hd_secret_of_summon", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_secret_of_summon:GetIntrinsicModifierName()
	return "modifier_item_hd_secret_of_summon"
end



-- function item_hd_secret_of_summon:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_secret_of_summon_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_secret_of_summon_arua = class({})

-- function modifier_item_hd_secret_of_summon_arua:IsHidden() return true end
-- function modifier_item_hd_secret_of_summon_arua:IsAura() return true end
-- function modifier_item_hd_secret_of_summon_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_secret_of_summon_arua:GetModifierAura() return "modifier_item_hd_secret_of_summon_arua_effect" end
-- function modifier_item_hd_secret_of_summon_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_secret_of_summon_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_secret_of_summon_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_secret_of_summon_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_secret_of_summon = advanced_modifier({})

function modifier_item_hd_secret_of_summon:IsDebuff() return false end
function modifier_item_hd_secret_of_summon:IsHidden() return true end
function modifier_item_hd_secret_of_summon:IsPurgable() return false end



function modifier_item_hd_secret_of_summon:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()

	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")

end



function modifier_item_hd_secret_of_summon:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
		

	}
end


function modifier_item_hd_secret_of_summon:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_secret_of_summon:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_secret_of_summon:GetModifierBaseDamageOutgoing_Percentage() return self:GetStackCount()==1 and self.bonus_damage_per or 0 end


function modifier_item_hd_secret_of_summon:OnAbilityFullyCast(keys)

	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
			return
		end
	
		if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
			return 
		end
		if self:GetCaster():GetRandomEffect(25,INT_TYPE,1) >=RandomInt(1, 100) then
			return
		end
		if keys.unit:HasModifier("modifier_item_hd_secret_of_summon_active") then
			return
		end

		keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_item_hd_secret_of_summon_active",{duration = 50})	
	
	
		
	end
end


-- advanced_modifier
function modifier_item_hd_secret_of_summon:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_secret_of_summon:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end





modifier_item_hd_secret_of_summon_active = advanced_modifier({})

function modifier_item_hd_secret_of_summon_active:IsDebuff() return false end
function modifier_item_hd_secret_of_summon_active:IsHidden() return true end
function modifier_item_hd_secret_of_summon_active:IsPurgable() return false end



function modifier_item_hd_secret_of_summon_active:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
    if IsServer() then

	end
end


function modifier_item_hd_secret_of_summon_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
	

	}
end
function modifier_item_hd_secret_of_summon_active:OnAbilityFullyCast(keys)
	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 2 then
			return
		end
		if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
			return 
		end

		if (100-self:GetCaster():GetRandomEffect(25,INT_TYPE,1))>=RandomInt(1, 100) then
			self:SafeDestroy()	
		end
	
	
		
	end
end


-- advanced_modifier
function modifier_item_hd_secret_of_summon_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_secret_of_summon_active:Advanced_GetModifier_Summon_Intensity(keys)
	return 25
end
