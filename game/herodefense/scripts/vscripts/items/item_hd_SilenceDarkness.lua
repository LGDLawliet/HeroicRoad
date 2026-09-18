item_hd_SilenceDarkness = class({})
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_arua", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_arua_effect", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_SilenceDarkness", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_SilenceDarkness_active", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_effect", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_effect2", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_active_standby", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_debuff", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_SilenceDarkness_thinker", "items/item_hd_SilenceDarkness", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_SilenceDarkness:GetIntrinsicModifierName()
	return "modifier_item_hd_SilenceDarkness"
end



function item_hd_SilenceDarkness:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if  _G.GAME_CHANGING_TIME_OF_DAY or not Game_State:IsInBattle()  then
		return UF_FAIL_CUSTOM
	end
	if time<0.25 or time>0.75 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_hd_SilenceDarkness:GetCustomCastError()
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if _G.GAME_CHANGING_TIME_OF_DAY then
		return "#dota_hud_still_chaghing"
	end
	if not Game_State:IsInBattle()  then
		return "dota_hud_not_in_battle"
	end
	if time<0.25 or time>0.75 then
		return "dota_hud_still_night"
	end
	return ""
end


function item_hd_SilenceDarkness:OnSpellStart()

	local caster    =   self:GetCaster()
	-- local target = self:GetCursorTarget()
	-- if target:TriggerSpellAbsorb(self) then	return 	end
	-- caster:EmitSound("Hero_Silencer.Curse")
	-- self:StartCooldown(5)
	-- local modifier = caster:FindAllModifiersByName("modifier_item_hd_SilenceDarkness_active")
	-- if #modifier>0 then
	-- 	modifier[1]:Destroy()
	-- 	return
	-- end

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	-- target:AddNewModifier(caster, self, "modifier_item_hd_SilenceDarkness_active", {duration = 5})
	-- print(GameRules:GetTimeOfDay())

	local time = GameRules:GetTimeOfDay() --记录当前时间
	GameRules:SetTimeOfDay(0.75)  --强制黑夜
	caster:AddNewModifier(caster, self, "modifier_item_hd_SilenceDarkness_active", {duration = 10})
	_G.GAME_CHANGING_TIME_OF_DAY = true
	Timers:CreateTimer(10, function()
		if _G.GAME_CHANGING_NIGHT_WORLD_RULE then  --返回强制黑夜关卡
			GameRules:SetTimeOfDay(-1)
		else  --说明当前不是强制黑夜关卡了 那么返回记录的过去时间
			GameRules:SetTimeOfDay(time)
		end
		_G.GAME_CHANGING_TIME_OF_DAY = false

	end)
end


-- modifier_item_hd_SilenceDarkness_arua = class({})

-- function modifier_item_hd_SilenceDarkness_arua:IsHidden() return true end
-- function modifier_item_hd_SilenceDarkness_arua:IsAura() return true end
-- function modifier_item_hd_SilenceDarkness_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_SilenceDarkness_arua:GetModifierAura() return "modifier_item_hd_SilenceDarkness_arua_effect" end
-- function modifier_item_hd_SilenceDarkness_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_SilenceDarkness_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_SilenceDarkness_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_SilenceDarkness_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_SilenceDarkness = advanced_modifier({})

function modifier_item_hd_SilenceDarkness:IsDebuff() return false end
function modifier_item_hd_SilenceDarkness:IsHidden() return true end
function modifier_item_hd_SilenceDarkness:IsPurgable() return false end
-- function modifier_item_hd_SilenceDarkness:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_SilenceDarkness:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_item_hd_SilenceDarkness:IsAura() return true end
-- function modifier_item_hd_SilenceDarkness:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_SilenceDarkness:GetModifierAura() return "modifier_item_hd_SilenceDarkness_active" end
-- function modifier_item_hd_SilenceDarkness:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_SilenceDarkness:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_SilenceDarkness:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_item_hd_SilenceDarkness:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_item_hd_SilenceDarkness:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end


function modifier_item_hd_SilenceDarkness:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
 
    local parent = self:GetParent()


	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.BONUS_NIGHT_VISION = self.ability:GetSpecialValueFor("BONUS_NIGHT_VISION")


    if IsServer() then

	end
end



function modifier_item_hd_SilenceDarkness:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
	}
end


function modifier_item_hd_SilenceDarkness:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end


-- advanced_modifier
function modifier_item_hd_SilenceDarkness:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION


    }
end


function modifier_item_hd_SilenceDarkness:Advanced_GetBonusNightVision()return  self.BONUS_NIGHT_VISION end




modifier_item_hd_SilenceDarkness_active = class({})

function modifier_item_hd_SilenceDarkness_active:IsDebuff() return false end
function modifier_item_hd_SilenceDarkness_active:IsHidden() return false end
function modifier_item_hd_SilenceDarkness_active:IsPurgable() return false end
function modifier_item_hd_SilenceDarkness_active:GetTexture()return "item_SilenceDarkness" end
