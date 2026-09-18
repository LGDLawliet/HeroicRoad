item_hd_sparkle = class({})
-- LinkLuaModifier("modifier_item_hd_sparkle_arua", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_arua_effect", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sparkle", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sparkle_active", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_effect", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_effect2", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_active_standby", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_debuff", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sparkle_thinker", "items/item_hd_sparkle", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_sparkle:GetIntrinsicModifierName()
	return "modifier_item_hd_sparkle"
end



function item_hd_sparkle:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if  _G.GAME_CHANGING_TIME_OF_DAY or not Game_State:IsInBattle()  then
		return UF_FAIL_CUSTOM
	end
	if time>=0.25 and time <=0.75 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_hd_sparkle:GetCustomCastError()
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if _G.GAME_CHANGING_TIME_OF_DAY then
		return "dota_hud_still_chaghing"
	end
	if not Game_State:IsInBattle() then
		return "dota_hud_not_in_battle"
	end
	if time>=0.25 and time <=0.75 then
		return "dota_hud_still_day"
	end
	return ""
end


function item_hd_sparkle:OnSpellStart()

	local caster    =   self:GetCaster()
	-- local target = self:GetCursorTarget()
	-- if target:TriggerSpellAbsorb(self) then	return 	end
	-- caster:EmitSound("Hero_Silencer.Curse")
	-- self:StartCooldown(5)
	-- local modifier = caster:FindAllModifiersByName("modifier_item_hd_sparkle_active")
	-- if #modifier>0 then
	-- 	modifier[1]:Destroy()
	-- 	return
	-- end

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	-- target:AddNewModifier(caster, self, "modifier_item_hd_sparkle_active", {duration = 5})
	-- print(GameRules:GetTimeOfDay())

	local time = GameRules:GetTimeOfDay() --记录当前时间
	GameRules:SetTimeOfDay(0.25)  --强制白天
	caster:AddNewModifier(caster, self, "modifier_item_hd_sparkle_active", {duration = 10})
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


-- modifier_item_hd_sparkle_arua = class({})

-- function modifier_item_hd_sparkle_arua:IsHidden() return true end
-- function modifier_item_hd_sparkle_arua:IsAura() return true end
-- function modifier_item_hd_sparkle_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_sparkle_arua:GetModifierAura() return "modifier_item_hd_sparkle_arua_effect" end
-- function modifier_item_hd_sparkle_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_sparkle_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_sparkle_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_sparkle_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_sparkle = advanced_modifier({})

function modifier_item_hd_sparkle:IsDebuff() return false end
function modifier_item_hd_sparkle:IsHidden() return true end
function modifier_item_hd_sparkle:IsPurgable() return false end


function modifier_item_hd_sparkle:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
 
    local parent = self:GetParent()
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.BONUS_DAY_VISION = self.ability:GetSpecialValueFor("BONUS_DAY_VISION")

end




function modifier_item_hd_sparkle:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_sparkle:Advanced_GetBonusDayVision()   return self.BONUS_DAY_VISION  end

function modifier_item_hd_sparkle:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_BONUS_DAY_VISION


    }
end







modifier_item_hd_sparkle_active = class({})

function modifier_item_hd_sparkle_active:IsDebuff() return false end
function modifier_item_hd_sparkle_active:IsHidden() return false end
function modifier_item_hd_sparkle_active:IsPurgable() return false end
function modifier_item_hd_sparkle_active:GetTexture()return "item_sparkle" end

