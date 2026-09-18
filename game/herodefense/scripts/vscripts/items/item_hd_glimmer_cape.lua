item_hd_glimmer_cape = class({})
-- LinkLuaModifier("modifier_item_hd_glimmer_cape_arua", "items/item_hd_glimmer_cape", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_glimmer_cape_arua_effect", "items/item_hd_glimmer_cape", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_glimmer_cape", "items/item_hd_glimmer_cape", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_glimmer_cape_active", "items/item_hd_glimmer_cape", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_glimmer_cape:GetIntrinsicModifierName()
	return "modifier_item_hd_glimmer_cape"
end






-- modifier_item_hd_glimmer_cape_arua = class({})

-- function modifier_item_hd_glimmer_cape_arua:IsHidden() return true end
-- function modifier_item_hd_glimmer_cape_arua:IsAura() return true end
-- function modifier_item_hd_glimmer_cape_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_glimmer_cape_arua:GetModifierAura() return "modifier_item_hd_glimmer_cape_arua_effect" end
-- function modifier_item_hd_glimmer_cape_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_glimmer_cape_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_glimmer_cape_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_glimmer_cape_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_glimmer_cape = class({})

function modifier_item_hd_glimmer_cape:IsDebuff() return false end
function modifier_item_hd_glimmer_cape:IsHidden() return true end
function modifier_item_hd_glimmer_cape:IsPurgable() return false end
-- function modifier_item_hd_glimmer_cape:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_glimmer_cape:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_glimmer_cape:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	-- self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_glimmer_cape_active", {})
		self:StartIntervalThink(0.5)


	end
end
function modifier_item_hd_glimmer_cape:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsInNightTime() then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end
		-- self:SetHasCustomTransmitterData(true)
	end
end



function modifier_item_hd_glimmer_cape:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
		
		MODIFIER_PROPERTY_EVASION_CONSTANT,               --闪避
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE,                     --受到伤害事件

	}
end


function modifier_item_hd_glimmer_cape:GetModifierBonusStats_Strength()	return self.bonus_str*self:GetStackCount() end
function modifier_item_hd_glimmer_cape:GetModifierBonusStats_Intellect()	return self.bonus_int*self:GetStackCount() end
function modifier_item_hd_glimmer_cape:GetModifierBonusStats_Agility()	return self.bonus_agi*self:GetStackCount() end

function modifier_item_hd_glimmer_cape:GetModifierMagicalResistanceBonus() 
	if self:GetStackCount()==1 then
		return self.bonus_magic_resistance
	else
		return self.bonus_magic_resistance+15
	end
end

function modifier_item_hd_glimmer_cape:GetModifierEvasion_Constant() return self:GetStackCount()==2 and self.bonus_evasion or 0 end

function modifier_item_hd_glimmer_cape:OnTakeDamage(keys)
    if IsServer() then   
		if keys.unit == self:GetParent() and keys.damage >50 and self:GetAbility():IsCooldownReady() and self:GetParent():IsInNightTime() then
			-- print("damage")
			self:GetAbility():UseResources(true, true, true,true)
			self.modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_glimmer_cape_active", {duration = 2.5})
		end

    end 
end



-- function modifier_item_hd_glimmer_cape:GetModifierIncomingDamage_Percentage(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	local parent = self:GetParent()
-- 	if keys.damage >=  parent:GetHealth()*0.5 then
-- 		self:Destroy()
-- 		return 0
-- 	end
-- 	return -1000
-- end

modifier_item_hd_glimmer_cape_active = advanced_modifier({})

function modifier_item_hd_glimmer_cape_active:IsDebuff() return false end
function modifier_item_hd_glimmer_cape_active:IsHidden() return false end
function modifier_item_hd_glimmer_cape_active:IsPurgable() return false end
function modifier_item_hd_glimmer_cape_active:GetTexture()return "item_glimmer_cape" end
function modifier_item_hd_glimmer_cape_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end


function modifier_item_hd_glimmer_cape_active:GetModifierInvisibilityLevel()return 1 end
function modifier_item_hd_glimmer_cape_active:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_item_hd_glimmer_cape_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -40
end


function modifier_item_hd_glimmer_cape_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
