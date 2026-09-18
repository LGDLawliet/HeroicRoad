local cook = {
	level1 = {
		"item_hd_cook_royal_jelly",
		"item_hd_cook_tango_single",
		"item_hd_cook_Mango",
		"item_hd_cook_faerie_fire",
		"item_hd_cook_Chocolates",
		"item_hd_cook_Mashed_Potato",
		"item_hd_cook_green",


	},
	level2 = {
		"item_hd_cook_tango",
		"item_hd_cook_greater_mango",
		"item_hd_cook_Roasted_tuna",
		"item_hd_cook_green_2",
		"item_hd_cook_Baked_sweet_potato",
		"item_hd_cook_Unknown_cuisine",
		"item_hd_cook_egg",
		"item_hd_cook_Delicious_meat",

		 

	},
	level3 = {
		"item_hd_cook_cheese",
		"item_hd_cook_greater_faerie_fire",
		"item_hd_cook_egg_2",
		"item_hd_cook_lobster",
		"item_hd_cook_Delicious_meat_2",
		"item_hd_cook_green_3",
		"item_hd_cook_meat_3",
		"item_hd_cook_bard_meat_3",
		"item_hd_cook_Meat_of_sea_dragon",

		
		

	},


}



function GiveRandomLevel(level)
    local bonus_level = level
    local random_index = RandomInt(1, 1000)
    local now_index = 0
	-- DeepPrint(level)


    for i = 1, #bonus_level-1, 1 do
        now_index = now_index+bonus_level[i]
        if now_index>=random_index and random_index<=now_index+bonus_level[i+1] then
            return i
        end
    end
	return 1
    
end




------------------------------低阶做菜------------------------------------------


Primary_cook = class({})

LinkLuaModifier("modifier_Primary_cook", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cooking", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)


function Primary_cook:IsHiddenWhenStolen() 		return false end
function Primary_cook:IsRefreshable() 			return true end
function Primary_cook:IsStealable() 				return true end
function Primary_cook:IsNetherWardStealable()		return true end
function Primary_cook:GetIntrinsicModifierName() return "modifier_Primary_cook" end

function Primary_cook:CastFilterResult()
	if IsServer() then
		if self:GetCaster():GetModifierStackCount("modifier_Primary_cook", self:GetCaster())<=0 then
			self.error = "dota_hud_not_enough_energy"
			return UF_FAIL_CUSTOM
		end
		if not Game_State:IsInBattle()  then
			self.error = "dota_hud_not_in_battle"
			return UF_FAIL_CUSTOM
		end
	end
end
function Primary_cook:GetCustomCastError()
	return self.error
end


function Primary_cook:OnSpellStart()
	self.caster = self:GetCaster()
	local caster = self.caster
	local duration = self:GetChannelTime()-0.5
	self.cooking = caster:AddNewModifier(caster, self, "modifier_cooking", {duration = duration})
	local modifier = self:GetCaster():FindModifierByName("modifier_Primary_cook")
	if modifier then
		modifier:DecrementStackCount()
	end
--    self:GetBonus()
--	self:GetCaster():ModifyGoldFiltered(-2000,true,DOTA_ModifyGold_PurchaseItem  )  --原效果：花费金币做菜
end

function Primary_cook:OnChannelFinish()
	if self:GetCaster():FindModifierByName("modifier_cooking")	then 
		self:StartCooldown(40)
		self.cooking:SetDuration( 0, true )
		self.cooking = nil
	else
		self:GetBonus()
	end
	
end
function Primary_cook:GetBonus()
	local level1 = self:GetSpecialValueFor("level1")*10
	local level2 = self:GetSpecialValueFor("level2")*10
	local level3 = self:GetSpecialValueFor("level3")*10

	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_magnataur_4")
	if ability then
		level3 = math.min(level3 * 2,900)
		level2 = level2 - level3
	end
	local level4 = 0
	local level = {
		level1,
		level2,
		level3,
		level4,
	}
	local string = "level"..GiveRandomLevel(level)
	local cookClass = cook[string]
    self:GetCaster():AddItemByName(cookClass[RandomInt(1, #cookClass)])
end

modifier_Primary_cook = advanced_modifier({})

function modifier_Primary_cook:IsDebuff()			return false end
function modifier_Primary_cook:IsHidden() 			return false end
function modifier_Primary_cook:IsPurgable() 		    return false end
function modifier_Primary_cook:IsPurgeException() return false end
function modifier_Primary_cook:RemoveOnDeath() return false end
function modifier_Primary_cook:OnWaveEnd(table)
	self:GetAbility():GetBonus()
end
function modifier_Primary_cook:OnWaveStart()
	
	if self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_life_stealer") or self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_phoenix_3")	then
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count")*0.5)
	else
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count"))
	end
end
function modifier_Primary_cook:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end





----------------------中阶做菜----------------------------------------------------------------------

Middle_cook = class({})

LinkLuaModifier("modifier_Middle_cook", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cooking", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)


function Middle_cook:IsHiddenWhenStolen() 		return false end
function Middle_cook:IsRefreshable() 			return true end
function Middle_cook:IsStealable() 				return true end
function Middle_cook:IsNetherWardStealable()		return true end
function Middle_cook:GetIntrinsicModifierName() return "modifier_Middle_cook" end

function Middle_cook:CastFilterResult()
	if IsServer() then
		if self:GetCaster():GetModifierStackCount("modifier_Middle_cook", self:GetCaster())<=0 then
			self.error = "dota_hud_not_enough_energy"
			return UF_FAIL_CUSTOM
		end
		if not Game_State:IsInBattle()  then
			self.error = "dota_hud_not_in_battle"
			return UF_FAIL_CUSTOM
		end
	end
end
function Middle_cook:GetCustomCastError()
	return self.error
end

function Middle_cook:OnSpellStart()
	self.caster = self:GetCaster()
	local caster = self.caster
	
	local duration = self:GetChannelTime()-0.5
	self.cooking = caster:AddNewModifier(caster, self, "modifier_cooking", {duration = duration})
	local modifier = self:GetCaster():FindModifierByName("modifier_Middle_cook")
	if modifier then
		modifier:DecrementStackCount()
	end
--    self:GetBonus()
--	self:GetCaster():ModifyGoldFiltered(-2000,true,DOTA_ModifyGold_PurchaseItem  )  --原效果：花费金币做菜
end

function Middle_cook:OnChannelFinish()
	if self:GetCaster():FindModifierByName("modifier_cooking")	then 
		self:StartCooldown(40)
		self.cooking:SetDuration( 0, true )
		self.cooking = nil
	else
		self:GetBonus()
	end
	
end
function Middle_cook:GetBonus()
	local level1 = self:GetSpecialValueFor("level1")*10
	local level2 = self:GetSpecialValueFor("level2")*10
	local level3 = self:GetSpecialValueFor("level3")*10
	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_magnataur_4")
--	local chance  = self:GetSpecialValueFor("okawari")
	if ability then
		level3 = math.min(level3 * 2,900)
		level2 = level2 - level3
	end
	local level4 = 0
	local level = {
		level1,
		level2,
		level3,
		level4,
	}
	local string = "level"..GiveRandomLevel(level)
	local cookClass = cook[string]
	local itemName = cookClass[RandomInt(1, #cookClass)]
    self:GetCaster():AddItemByName(itemName)
	--if chance>=RandomInt(1, 100) then
	--	self:GetCaster():AddItemByName(itemName)
	--end
end


modifier_Middle_cook = advanced_modifier({})

function modifier_Middle_cook:IsDebuff()			return false end
function modifier_Middle_cook:IsHidden() 			return false end
function modifier_Middle_cook:IsPurgable() 		    return false end
function modifier_Middle_cook:IsPurgeException() return false end
function modifier_Middle_cook:RemoveOnDeath() return false end
function modifier_Middle_cook:OnWaveEnd(table)
	
	self:GetAbility():GetBonus()

end
function modifier_Middle_cook:OnWaveStart(table)
	
	if self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_life_stealer") or self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_phoenix_3")	then
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count")*0.5)
	else
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count"))
	end
end
function modifier_Middle_cook:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end


----------------------高阶做菜----------------------------------------------------------------------


Advanced_cook = advanced_modifier({})

LinkLuaModifier("modifier_Advanced_cook", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cooking", "skills/Primary_cook", LUA_MODIFIER_MOTION_NONE)



function Advanced_cook:CheckKV(key)
	local table = {
		level2 = -1.2,
		level3 = 1.2,

	}
	local value = table[key] or -1
	return value

end

function Advanced_cook:IsHiddenWhenStolen() 		return false end
function Advanced_cook:IsRefreshable() 			return true end
function Advanced_cook:IsStealable() 				return true end
function Advanced_cook:IsNetherWardStealable()		return true end
function Advanced_cook:GetIntrinsicModifierName() return "modifier_Advanced_cook" end
function Advanced_cook:CastFilterResult()
	if IsServer() then
		if self:GetCaster():GetModifierStackCount("modifier_Advanced_cook", self:GetCaster())<=0 then
			self.error = "dota_hud_not_enough_energy"
			return UF_FAIL_CUSTOM
		end
		if not Game_State:IsInBattle()  then
			self.error = "dota_hud_not_in_battle"
			return UF_FAIL_CUSTOM
		end
	end
end
function Advanced_cook:GetCustomCastError()
	return self.error
end

function Advanced_cook:UnlockFirstCore(key)
	return true
end
function Advanced_cook:UnlockSecondCore(key)
	return true
end
function Advanced_cook:UnlockThirdCore(key)
	return true
end
--原20：变为主动做菜技能。
--function Advanced_cook:GetBehavior()
--	if self:GetSpecialValueFor("advanced_level")>=20 then
--		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
--	end
--	return DOTA_ABILITY_BEHAVIOR_PASSIVE
--end
--原20:2000块钱做一次菜
--function Advanced_cook:CastFilterResult( vLoc )
	-- check nohammer
--	if IsServer() then
--		if self:GetCaster():GetGold()<2000 then
--			return UF_FAIL_CUSTOM
--		end
	

--		return UF_SUCCESS
--	end
	
--end
--原20:2000块钱做一次菜
--function Advanced_cook:GetCustomCastError( vLoc )
	-- check nohammer
--	if IsServer() then
--		if self:GetCaster():GetGold()<2000 then
--			-- return "#dota_hud_error_nohammer"
--			return "#dota_hud_greevils_not_enough_gold"
--		end
--		
---
--		return ""
--	end

--end



function Advanced_cook:OnSpellStart()
	self.caster = self:GetCaster()
	local caster = self.caster
	local duration = self:GetChannelTime()-0.5
	self.cooking = caster:AddNewModifier(caster, self, "modifier_cooking", {duration = duration})
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_cook")
	if modifier then
		modifier:DecrementStackCount()
	end
--    self:GetBonus()
--	self:GetCaster():ModifyGoldFiltered(-2000,true,DOTA_ModifyGold_PurchaseItem  )  --原效果：花费金币做菜
end

function Advanced_cook:OnChannelFinish()
	if self:GetCaster():FindModifierByName("modifier_cooking")	then 
		self:StartCooldown(40)
		self.cooking:SetDuration( 0, true )
		self.cooking = nil
	else
		self:GetBonus()
	end

end
function Advanced_cook:GetBonus()

	local level1 = self:GetSpecialValueFor("level1")*10
	local level2 = self:GetSpecialValueFor("level2")*10
	local level3 = self:GetSpecialValueFor("level3")*10
	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_magnataur_4")
	local caster = self:GetCaster()
	--local chance  = self:GetSpecialValueFor("okawari")
	local HQ_chance = self:GetSpecialValueFor("HQ_chance")
	local ultra_chance = self:GetSpecialValueFor("ultra_chance")
	if ability then
		level3 = math.max(level3 * 2,999)
		level2 = math.max(level2 - level3,0)
	end
	local level4 = 0
	local level = {
		level1,
		level2,
		level3,
		level4,
	}
	local randomLevel = GiveRandomLevel(level)
	local string = "level"..GiveRandomLevel(level)
	local cookClass = cook[string]
	local itemName = cookClass[RandomInt(1, #cookClass)]
	if self.advanced_level>=10 and self.advanced_level < 20 then
		HQ_chance = 75
	end
	if self.advanced_level>=20 then
		HQ_chance = 100
	end
	if HQ_chance >= RandomInt(1, 100) then
		self:GetCaster():AddItemByName(itemName.."_clone")
	else
		self:GetCaster():AddItemByName(itemName)
	end

	--if self.advanced_level>=10 and super_chance >= RandomInt(1, 100) then
	--	self:GetCaster():AddItemByName(itemName.."_clone")
	--else
	--	self:GetCaster():AddItemByName(itemName)
	--end
	--if self.advanced_level>=5 then
	--	chance = 20
	--end

	--if chance>=RandomInt(1, 100) then
	--	if HQ_chance >= RandomInt(1, 100) then
	--		self:GetCaster():AddItemByName(itemName.."_clone")
	--	else
	--		self:GetCaster():AddItemByName(itemName)
	--	end
	--end

	if self.unlock3 then
		ultra_chance = 100
	end
	if self.advanced_level>=15 and ultra_chance >= RandomInt(1, 100) then
		self:GetCaster():AddItemByName("item_hd_cook_apex")
	end

	if self.unlock1 then
		self:GetCaster():AddItemByName("item_hd_gifte_of_fate")
	end
	if self.unlock2 then
		self:GetCaster():AddItemByName("item_hd_gifte_of_power")
	end

end



modifier_Advanced_cook = advanced_modifier({})

function modifier_Advanced_cook:IsDebuff()			return false end
function modifier_Advanced_cook:IsHidden() 			return false end
function modifier_Advanced_cook:IsPurgable() 		    return false end
function modifier_Advanced_cook:IsPurgeException() return false end
function modifier_Advanced_cook:RemoveOnDeath() return false end
function modifier_Advanced_cook:OnWaveEnd(table)
	
	self:GetAbility():GetBonus()

end
function modifier_Advanced_cook:OnWaveStart(table)
	
	if self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_life_stealer") or self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_phoenix_3")	then
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count")*0.5)
	else
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("cook_count"))
	end
end
function modifier_Advanced_cook:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

----------------------------------------------------------------------------------------------
modifier_cooking = advanced_modifier({})

function modifier_cooking:IsDebuff()			return false end
function modifier_cooking:IsHidden() 			return false end
function modifier_cooking:IsPurgable() 		return false end
function modifier_cooking:IsPurgeException() 	return false end
function modifier_cooking:OnCreated()
	self.caster = self:GetCaster()
	local caster = self.caster
	self:StartIntervalThink(0.1)
end

function modifier_cooking:OnIntervalThink()
    self:SetStackCount(1)
end

function modifier_cooking:CheckState()
    local state = {}
    if self:GetStackCount()==1 then
        state = 
        {
            [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        }
    end
	return state
end

function modifier_cooking:DeclareFunctions() return   {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_cooking:ADDeclareFunctions() return   {advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,} end
function modifier_cooking:GetModifierMagicalResistanceBonus()return 90 end
function modifier_cooking:Advanced_GetModifierPhysicalArmorBonus()return 100 end

function modifier_cooking:OnTakeDamage(keys)
	self.caster = self:GetCaster()
	local caster = self.caster
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if not keys.attacker then
		return
	end
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { duration = 0.1})
end
-----------------------------------------------------------------------------------------------
