item_hd_yulsarias_mantle = class({})
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_arua", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_arua_effect", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_mantle", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_mantle_active", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_mantle_effect", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_effect2", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_active_standby", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_debuff", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_mantle_thinker", "items/item_hd_yulsarias_mantle", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_yulsarias_mantle:GetIntrinsicModifierName()
	return "modifier_item_hd_yulsarias_mantle"
end





modifier_item_hd_yulsarias_mantle = class({})

function modifier_item_hd_yulsarias_mantle:IsDebuff() return false end
function modifier_item_hd_yulsarias_mantle:IsHidden() return true end
function modifier_item_hd_yulsarias_mantle:IsPurgable() return false end
-- function modifier_item_hd_yulsarias_mantle:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_yulsarias_mantle:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_yulsarias_mantle:IsAura() return true end
function modifier_item_hd_yulsarias_mantle:GetAuraDuration() return 0.5 end
function modifier_item_hd_yulsarias_mantle:GetModifierAura() return "modifier_item_hd_yulsarias_mantle_active" end
function modifier_item_hd_yulsarias_mantle:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_yulsarias_mantle:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_yulsarias_mantle:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_yulsarias_mantle:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_item_hd_yulsarias_mantle:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end


function modifier_item_hd_yulsarias_mantle:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	
end



function modifier_item_hd_yulsarias_mantle:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		
		

	}
end



function modifier_item_hd_yulsarias_mantle:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_yulsarias_mantle:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_yulsarias_mantle:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end



modifier_item_hd_yulsarias_mantle_active = class({})

function modifier_item_hd_yulsarias_mantle_active:IsDebuff() return true end
function modifier_item_hd_yulsarias_mantle_active:IsHidden() return false end
function modifier_item_hd_yulsarias_mantle_active:IsPurgable() return false end
function modifier_item_hd_yulsarias_mantle_active:GetTexture()return "item_yulsarias_mantle" end
function modifier_item_hd_yulsarias_mantle_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_yulsarias_mantle_active:OnCreated(table)
	if IsServer() then
		self:SetStackCount(3)
		self:StartIntervalThink(1)
	end
end


function modifier_item_hd_yulsarias_mantle_active:OnIntervalThink(table)
	if IsServer() then
		local stack = self:GetStackCount()
		if self:GetCaster():GetRandomEffect(stack,INT_TYPE,1) >=RandomInt(1, 100) then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_yulsarias_mantle_effect", {duration = 2})
			self:SetStackCount(3)
			return
		end
		self:SetStackCount(stack+3)
	end
end



modifier_item_hd_yulsarias_mantle_effect = advanced_modifier({})

function modifier_item_hd_yulsarias_mantle_effect:IsDebuff() return true end
function modifier_item_hd_yulsarias_mantle_effect:IsHidden() return false end
function modifier_item_hd_yulsarias_mantle_effect:IsPurgable() return true end
-- function modifier_item_hd_yulsarias_mantle_effect:IsPurgeException() return true end
function modifier_item_hd_yulsarias_mantle_effect:GetTexture()return "item_yulsarias_mantle" end
function modifier_item_hd_yulsarias_mantle_effect:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_item_hd_yulsarias_mantle_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_yulsarias_mantle_effect:Advanced_GetModifierIncomingDamage_Percentage()	return 30 end

function modifier_item_hd_yulsarias_mantle_effect:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end


function modifier_item_hd_yulsarias_mantle_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
