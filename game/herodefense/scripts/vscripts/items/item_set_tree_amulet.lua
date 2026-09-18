item_set_tree_amulet = class({})
LinkLuaModifier("modifier_item_set_tree_amulet", "items/item_set_tree_amulet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_tree_amulet_active", "items/item_set_tree_amulet", LUA_MODIFIER_MOTION_NONE)

function item_set_tree_amulet:GetIntrinsicModifierName()
	return "modifier_item_set_tree_amulet"
end

function item_set_tree_amulet:CastFilterResult()
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if  _G.GAME_CHANGING_TIME_OF_DAY  then
		return UF_FAIL_CUSTOM
	end
	if time>=0.25 and time <=0.75 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_set_tree_amulet:GetCustomCastError()
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if _G.GAME_CHANGING_TIME_OF_DAY then
		return "dota_hud_still_chaghing"
	end
	if time>=0.25 and time <=0.75 then
		return "dota_hud_still_day"
	end
	return ""
end


function item_set_tree_amulet:OnSpellStart()

	local caster    =   self:GetCaster()
	local time = GameRules:GetTimeOfDay() --记录当前时间
	GameRules:SetTimeOfDay(0.25)  --强制白天

    self.day_duration = self:GetSpecialValueFor("day_duration")
	caster:AddNewModifier(caster, self, "modifier_item_set_tree_amulet_active", {duration = self.day_duration})
	_G.GAME_CHANGING_TIME_OF_DAY = true
	caster:GameTimer(self.day_duration, function()
		if _G.GAME_CHANGING_NIGHT_WORLD_RULE then  --返回强制黑夜关卡
			GameRules:SetTimeOfDay(-1)
		else  --说明当前不是强制黑夜关卡了 那么返回记录的过去时间
			GameRules:SetTimeOfDay(time)
		end
		_G.GAME_CHANGING_TIME_OF_DAY = false
	end)
end


modifier_item_set_tree_amulet = advanced_modifier({})

function modifier_item_set_tree_amulet:IsDebuff() return false end
function modifier_item_set_tree_amulet:IsHidden() return true end
function modifier_item_set_tree_amulet:IsPurgable() return false end

function modifier_item_set_tree_amulet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
	self.bonus_hp_pct = self.ability:GetSpecialValueFor("bonus_hp_pct")
end

function modifier_item_set_tree_amulet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }
end

function modifier_item_set_tree_amulet:AdvancedGetModifierHealthBonus()	return self.bonus_hp end
function modifier_item_set_tree_amulet:AdvancedGetModifierExtraHealthPercentage()  return self.bonus_hp_pct  end


-------------------------
modifier_item_set_tree_amulet_active = class({})
function modifier_item_set_tree_amulet_active:IsDebuff() return false end
function modifier_item_set_tree_amulet_active:IsHidden() return true end
function modifier_item_set_tree_amulet_active:IsPurgable() return false end


