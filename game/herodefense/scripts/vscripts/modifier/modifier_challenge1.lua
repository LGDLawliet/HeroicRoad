LinkLuaModifier("modifier_ChallengeInfo_002_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_003_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_004_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_005_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_006_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_007_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_009_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_010_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_010_debuff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_011_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_012_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_012_buff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_013_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_014_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_014_debuff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_020_buff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_020_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_021_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_022_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_023_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_024_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_024_debuff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_025_debuff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_025_debuff2", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_025_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_026_damage", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_026_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_029_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_029_buff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_ChallengeInfo_030_self_buff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_030_enemy_buff", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_030_bonus", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_030_effect", "modifier/modifier_challenge1", LUA_MODIFIER_MOTION_NONE)




function GetGoldBonus(name,unit)
	local bonus = challenge:GetChallengeInfo(name).bonus
	-- print("原本奖励="..bonus)
	bonus = bonus * _G.GAME_Challenge_gold_bonus_index
	local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_bounty_hunter_2")
	if modifier then
		bonus = bonus * modifier:GetBonusIndex()
	end
	-- print("现在奖励="..bonus)
	return bonus
end

---------------------------------苦难1
modifier_ChallengeInfo_001_1 = advanced_modifier({})


function modifier_ChallengeInfo_001_1:IsHidden()return false end
function modifier_ChallengeInfo_001_1:IsDebuff()return true end
function modifier_ChallengeInfo_001_1:IsPurgable()return false end
function modifier_ChallengeInfo_001_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_001_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_001_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_ChallengeInfo_001_1:GetTexture() return "modifier_illusion" end
-- function modifier_ChallengeInfo_001_1:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end

-- function modifier_ChallengeInfo_001_1:GetModifierTotalDamageOutgoing_Percentage()	return -15 end

-- advanced_modifier
function modifier_ChallengeInfo_001_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_001_1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -15
end


function modifier_ChallengeInfo_001_1:WaveEndGOLDBONUS()

    return 1.15
end

function modifier_ChallengeInfo_001_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励


	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
    return 1
end


modifier_ChallengeInfo_001_2 = advanced_modifier({})


function modifier_ChallengeInfo_001_2:IsHidden()return false end
function modifier_ChallengeInfo_001_2:IsDebuff()return true end
function modifier_ChallengeInfo_001_2:IsPurgable()return false end
function modifier_ChallengeInfo_001_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_001_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_001_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_001_2:GetTexture() return "modifier_illusion" end
-- function modifier_ChallengeInfo_001_2:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end

-- function modifier_ChallengeInfo_001_2:GetModifierTotalDamageOutgoing_Percentage()	return -23 end
function modifier_ChallengeInfo_001_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_001_2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -23
end

function modifier_ChallengeInfo_001_2:WaveEndGOLDBONUS()

    return 1.25
end
function modifier_ChallengeInfo_001_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
    return 1
end

modifier_ChallengeInfo_001_3 = advanced_modifier({})


function modifier_ChallengeInfo_001_3:IsHidden()return false end
function modifier_ChallengeInfo_001_3:IsDebuff()return true end
function modifier_ChallengeInfo_001_3:IsPurgable()return false end
function modifier_ChallengeInfo_001_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_001_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_001_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_001_3:GetTexture() return "modifier_illusion" end
-- function modifier_ChallengeInfo_001_3:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end

-- function modifier_ChallengeInfo_001_3:GetModifierTotalDamageOutgoing_Percentage()	return -35 end

function modifier_ChallengeInfo_001_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_001_3:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -35
end


function modifier_ChallengeInfo_001_3:WaveEndGOLDBONUS()

    return 1.4
end
function modifier_ChallengeInfo_001_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
    return 1
end
modifier_ChallengeInfo_001_4 = advanced_modifier({})


function modifier_ChallengeInfo_001_4:IsHidden()return false end
function modifier_ChallengeInfo_001_4:IsDebuff()return true end
function modifier_ChallengeInfo_001_4:IsPurgable()return false end
function modifier_ChallengeInfo_001_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_001_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_001_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_001_4:GetTexture() return "modifier_illusion" end
-- function modifier_ChallengeInfo_001_4:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end

-- function modifier_ChallengeInfo_001_4:GetModifierTotalDamageOutgoing_Percentage()	return -55 end
function modifier_ChallengeInfo_001_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_001_4:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -55
end
function modifier_ChallengeInfo_001_4:WaveEndGOLDBONUS()
    return 1.7
end
function modifier_ChallengeInfo_001_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
    return 1
end
modifier_ChallengeInfo_001_5 = advanced_modifier({})


function modifier_ChallengeInfo_001_5:IsHidden()return false end
function modifier_ChallengeInfo_001_5:IsDebuff()return true end
function modifier_ChallengeInfo_001_5:IsPurgable()return false end
function modifier_ChallengeInfo_001_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_001_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_001_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_001_5:GetTexture() return "modifier_illusion" end
-- function modifier_ChallengeInfo_001_5:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end

-- function modifier_ChallengeInfo_001_5:GetModifierTotalDamageOutgoing_Percentage()	return -80 end
function modifier_ChallengeInfo_001_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_001_5:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -80
end


function modifier_ChallengeInfo_001_5:WaveEndGOLDBONUS()
    return 2.2
end
function modifier_ChallengeInfo_001_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
    return 1
end

---------------------------------苦难2

modifier_ChallengeInfo_002_1 = advanced_modifier({})


function modifier_ChallengeInfo_002_1:IsHidden()return false end
function modifier_ChallengeInfo_002_1:IsDebuff()return true end
function modifier_ChallengeInfo_002_1:IsPurgable()return false end
function modifier_ChallengeInfo_002_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_1:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_002_effect", {stack = 1})
	end
    return 1
end


function modifier_ChallengeInfo_002_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}
end

function modifier_ChallengeInfo_002_1:OnWaveStart()
	if not IsServer() then
		return
	end
	local hp = self:GetParent():GetMaxHealth()*0.8
	self:GetParent():SetHealth(hp)
end
function modifier_ChallengeInfo_002_1:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local hp_after = self:GetParent():GetHealth()*0.98
	self:GetParent():SetHealth(hp_after)
end

modifier_ChallengeInfo_002_2 = advanced_modifier({})


function modifier_ChallengeInfo_002_2:IsHidden()return false end
function modifier_ChallengeInfo_002_2:IsDebuff()return true end
function modifier_ChallengeInfo_002_2:IsPurgable()return false end
function modifier_ChallengeInfo_002_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_2:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		local ability = hero:FindAbilityByName("Default_Move")
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_002_effect", {stack = 2})
	end
    return 1
end


function modifier_ChallengeInfo_002_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}
end

function modifier_ChallengeInfo_002_2:OnWaveStart()
	if not IsServer() then
		return
	end
	local hp = self:GetParent():GetMaxHealth()*0.6
	self:GetParent():SetHealth(hp)
end
function modifier_ChallengeInfo_002_2:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local hp_after = self:GetParent():GetHealth()*0.97
	self:GetParent():SetHealth(hp_after)
end


modifier_ChallengeInfo_002_3 = advanced_modifier({})


function modifier_ChallengeInfo_002_3:IsHidden()return false end
function modifier_ChallengeInfo_002_3:IsDebuff()return true end
function modifier_ChallengeInfo_002_3:IsPurgable()return false end
function modifier_ChallengeInfo_002_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_3:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_002_effect", {stack = 3})
	end
    return 1
end


function modifier_ChallengeInfo_002_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}
end

function modifier_ChallengeInfo_002_3:OnWaveStart()
	if not IsServer() then
		return
	end
	local hp = self:GetParent():GetMaxHealth()*0.4
	self:GetParent():SetHealth(hp)
end
function modifier_ChallengeInfo_002_3:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local hp_after = self:GetParent():GetHealth()*0.96
	self:GetParent():SetHealth(hp_after)
end


modifier_ChallengeInfo_002_4 = advanced_modifier({})


function modifier_ChallengeInfo_002_4:IsHidden()return false end
function modifier_ChallengeInfo_002_4:IsDebuff()return true end
function modifier_ChallengeInfo_002_4:IsPurgable()return false end
function modifier_ChallengeInfo_002_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_4:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_002_effect", {stack = 4})
	end
    return 1
end


function modifier_ChallengeInfo_002_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}
end

function modifier_ChallengeInfo_002_4:OnWaveStart()
	if not IsServer() then
		return
	end
	local hp = self:GetParent():GetMaxHealth()*0.2
	self:GetParent():SetHealth(hp)
end
function modifier_ChallengeInfo_002_4:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local hp_after = self:GetParent():GetHealth()*0.95
	self:GetParent():SetHealth(hp_after)
end


modifier_ChallengeInfo_002_5 = advanced_modifier({})


function modifier_ChallengeInfo_002_5:IsHidden()return false end
function modifier_ChallengeInfo_002_5:IsDebuff()return true end
function modifier_ChallengeInfo_002_5:IsPurgable()return false end
function modifier_ChallengeInfo_002_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_5:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_002_effect", {stack = 6})
	end
    return 1
end

function modifier_ChallengeInfo_002_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}
end

function modifier_ChallengeInfo_002_5:OnWaveStart()
	if not IsServer() then
		return
	end
	local hp = self:GetParent():GetMaxHealth()*0.01
	self:GetParent():SetHealth(hp)
end
function modifier_ChallengeInfo_002_5:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local hp_after = self:GetParent():GetHealth()*0.92
	self:GetParent():SetHealth(hp_after)
end



modifier_ChallengeInfo_002_effect = advanced_modifier({})


function modifier_ChallengeInfo_002_effect:IsHidden()return true end
function modifier_ChallengeInfo_002_effect:IsDebuff()return false end
function modifier_ChallengeInfo_002_effect:IsPurgable()return false end
function modifier_ChallengeInfo_002_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_002_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_002_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_002_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_002_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_002_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_002_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
function modifier_ChallengeInfo_002_effect:AdvancedGetModifierExtraHealthPercentage()	return self:GetStackCount() end



---------------------------------苦难3
modifier_ChallengeInfo_003_1 = advanced_modifier({})
function modifier_ChallengeInfo_003_1:IsHidden()return false end
function modifier_ChallengeInfo_003_1:IsDebuff()return true end
function modifier_ChallengeInfo_003_1:IsPurgable()return false end
function modifier_ChallengeInfo_003_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_1:GetTexture() return "warlock_upheaval" end
function modifier_ChallengeInfo_003_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_003_effect", {stack = 5})
	end
    return 1
end
function modifier_ChallengeInfo_003_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_ChallengeInfo_003_1:GetModifierMoveSpeedBonus_Percentage()	return -15 end

modifier_ChallengeInfo_003_2 = advanced_modifier({})
function modifier_ChallengeInfo_003_2:IsHidden()return false end
function modifier_ChallengeInfo_003_2:IsDebuff()return true end
function modifier_ChallengeInfo_003_2:IsPurgable()return false end
function modifier_ChallengeInfo_003_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_2:GetTexture() return "warlock_upheaval" end
function modifier_ChallengeInfo_003_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_003_effect", {stack = 8})
	end
    return 1
end
function modifier_ChallengeInfo_003_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_ChallengeInfo_003_2:GetModifierMoveSpeedBonus_Percentage()	return -25 end


modifier_ChallengeInfo_003_3 = advanced_modifier({})
function modifier_ChallengeInfo_003_3:IsHidden()return false end
function modifier_ChallengeInfo_003_3:IsDebuff()return true end
function modifier_ChallengeInfo_003_3:IsPurgable()return false end
function modifier_ChallengeInfo_003_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_3:GetTexture() return "warlock_upheaval" end
function modifier_ChallengeInfo_003_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_003_effect", {stack = 11})
	end
    return 1
end
function modifier_ChallengeInfo_003_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_ChallengeInfo_003_3:GetModifierMoveSpeedBonus_Percentage()	return -50 end


modifier_ChallengeInfo_003_4 = advanced_modifier({})
function modifier_ChallengeInfo_003_4:IsHidden()return false end
function modifier_ChallengeInfo_003_4:IsDebuff()return true end
function modifier_ChallengeInfo_003_4:IsPurgable()return false end
function modifier_ChallengeInfo_003_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_4:GetTexture() return "warlock_upheaval" end
function modifier_ChallengeInfo_003_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_003_effect", {stack = 15})
	end
    return 1
end
function modifier_ChallengeInfo_003_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_ChallengeInfo_003_4:GetModifierMoveSpeedBonus_Percentage()	return -70 end


modifier_ChallengeInfo_003_5 = advanced_modifier({})
function modifier_ChallengeInfo_003_5:IsHidden()return false end
function modifier_ChallengeInfo_003_5:IsDebuff()return true end
function modifier_ChallengeInfo_003_5:IsPurgable()return false end
function modifier_ChallengeInfo_003_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_5:GetTexture() return "warlock_upheaval" end
function modifier_ChallengeInfo_003_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_003_effect", {stack = 20})
	end
    return 1
end
function modifier_ChallengeInfo_003_5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_ChallengeInfo_003_5:GetModifierMoveSpeedBonus_Percentage()	return -999 end




modifier_ChallengeInfo_003_effect = advanced_modifier({})


function modifier_ChallengeInfo_003_effect:IsHidden()return true end
function modifier_ChallengeInfo_003_effect:IsDebuff()return false end
function modifier_ChallengeInfo_003_effect:IsPurgable()return false end
function modifier_ChallengeInfo_003_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_003_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_003_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_003_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_003_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_003_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_003_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,  

	}
end

function modifier_ChallengeInfo_003_effect:GetModifierMoveSpeedBonus_Constant()	return self:GetStackCount() end
---------------------------------苦难4
modifier_ChallengeInfo_004_1 = advanced_modifier({})
function modifier_ChallengeInfo_004_1:IsHidden()return false end
function modifier_ChallengeInfo_004_1:IsDebuff()return true end
function modifier_ChallengeInfo_004_1:IsPurgable()return false end
function modifier_ChallengeInfo_004_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_1:GetTexture() return "undying/undying_fall20_immortal_ability_icon/undying_fall20_immortal_soul_rip" end
function modifier_ChallengeInfo_004_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +2*self:GetStackCount()
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_004_effect", {stack = 1*self:GetStackCount()})
	end
    return 1
end
function modifier_ChallengeInfo_004_1:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
		local parent = self:GetParent()

		
	end
end
function modifier_ChallengeInfo_004_1:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
		local parent = self:GetParent()
	end
end


-- advanced_modifier
function modifier_ChallengeInfo_004_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity

    }
end
function modifier_ChallengeInfo_004_1:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -10*self:GetStackCount()
end


function modifier_ChallengeInfo_004_1:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -10*self:GetStackCount()
end





modifier_ChallengeInfo_004_2 = advanced_modifier({})
function modifier_ChallengeInfo_004_2:IsHidden()return false end
function modifier_ChallengeInfo_004_2:IsDebuff()return true end
function modifier_ChallengeInfo_004_2:IsPurgable()return false end
function modifier_ChallengeInfo_004_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_2:GetTexture() return "undying/undying_fall20_immortal_ability_icon/undying_fall20_immortal_soul_rip" end
function modifier_ChallengeInfo_004_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +3*self:GetStackCount()
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_004_effect", {stack = 2*self:GetStackCount()})
	end
    return 1
end
function modifier_ChallengeInfo_004_2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
		
	end
end
function modifier_ChallengeInfo_004_2:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

-- advanced_modifier
function modifier_ChallengeInfo_004_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity
    }
end
function modifier_ChallengeInfo_004_2:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -20*self:GetStackCount()
end

function modifier_ChallengeInfo_004_2:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -20*self:GetStackCount()
end




modifier_ChallengeInfo_004_3 = advanced_modifier({})
function modifier_ChallengeInfo_004_3:IsHidden()return false end
function modifier_ChallengeInfo_004_3:IsDebuff()return true end
function modifier_ChallengeInfo_004_3:IsPurgable()return false end
function modifier_ChallengeInfo_004_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_3:GetTexture() return "undying/undying_fall20_immortal_ability_icon/undying_fall20_immortal_soul_rip" end
function modifier_ChallengeInfo_004_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +4*self:GetStackCount()
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_004_effect", {stack = 3*self:GetStackCount()})
	end
    return 1
end
function modifier_ChallengeInfo_004_3:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
		local parent = self:GetParent()
		
	end
end
function modifier_ChallengeInfo_004_3:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
		local parent = self:GetParent()

	end
end


-- advanced_modifier
function modifier_ChallengeInfo_004_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity
    }
end
function modifier_ChallengeInfo_004_3:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -30*self:GetStackCount()
end
function modifier_ChallengeInfo_004_3:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -30*self:GetStackCount()
end




modifier_ChallengeInfo_004_4 = advanced_modifier({})
function modifier_ChallengeInfo_004_4:IsHidden()return false end
function modifier_ChallengeInfo_004_4:IsDebuff()return true end
function modifier_ChallengeInfo_004_4:IsPurgable()return false end
function modifier_ChallengeInfo_004_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_4:GetTexture() return "undying/undying_fall20_immortal_ability_icon/undying_fall20_immortal_soul_rip" end
function modifier_ChallengeInfo_004_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +7*self:GetStackCount()
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_004_effect", {stack = 5*self:GetStackCount()})
	end
    return 1
end
function modifier_ChallengeInfo_004_4:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
		local parent = self:GetParent()

		
	end
end
function modifier_ChallengeInfo_004_4:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

-- advanced_modifier
function modifier_ChallengeInfo_004_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity
    }
end
function modifier_ChallengeInfo_004_4:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -50*self:GetStackCount()
end

function modifier_ChallengeInfo_004_4:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -50*self:GetStackCount()
end

modifier_ChallengeInfo_004_5 = advanced_modifier({})
function modifier_ChallengeInfo_004_5:IsHidden()return false end
function modifier_ChallengeInfo_004_5:IsDebuff()return true end
function modifier_ChallengeInfo_004_5:IsPurgable()return false end
function modifier_ChallengeInfo_004_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_5:GetTexture() return "undying/undying_fall20_immortal_ability_icon/undying_fall20_immortal_soul_rip" end
function modifier_ChallengeInfo_004_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12*self:GetStackCount()
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_004_effect", {stack = 8*self:GetStackCount()})
	end
    return 1
end
function modifier_ChallengeInfo_004_5:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
		
	end
end
function modifier_ChallengeInfo_004_5:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_ChallengeInfo_004_5:AdvancedGetModifierConstantHealthRegenAmpPercentage()	return -20*self:GetStackCount() end



-- advanced_modifier
function modifier_ChallengeInfo_004_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE
    }
end
function modifier_ChallengeInfo_004_5:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -90*self:GetStackCount()
end


function modifier_ChallengeInfo_004_5:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -90*self:GetStackCount()
end

modifier_ChallengeInfo_004_effect = advanced_modifier({})


function modifier_ChallengeInfo_004_effect:IsHidden()return true end
function modifier_ChallengeInfo_004_effect:IsDebuff()return false end
function modifier_ChallengeInfo_004_effect:IsPurgable()return false end
function modifier_ChallengeInfo_004_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_004_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_004_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_004_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_004_effect:OnCreated(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_004_effect:OnRefresh(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end
-- advanced_modifier
function modifier_ChallengeInfo_004_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity
    }
end
function modifier_ChallengeInfo_004_effect:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self:GetStackCount()
end

function modifier_ChallengeInfo_004_effect:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self:GetStackCount()
end


---------------------------------苦难5

modifier_ChallengeInfo_005_1 = advanced_modifier({})
function modifier_ChallengeInfo_005_1:IsHidden()return false end
function modifier_ChallengeInfo_005_1:IsDebuff()return true end
function modifier_ChallengeInfo_005_1:IsPurgable()return false end
function modifier_ChallengeInfo_005_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_1:GetTexture() return "antimage/immortal/antimage_blink" end
function modifier_ChallengeInfo_005_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_005_effect", {stack = 1})
	end
    return 1
end
function modifier_ChallengeInfo_005_1:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetMana(parent:GetMaxMana()*0.85)
	end
end


modifier_ChallengeInfo_005_2 = advanced_modifier({})
function modifier_ChallengeInfo_005_2:IsHidden()return false end
function modifier_ChallengeInfo_005_2:IsDebuff()return true end
function modifier_ChallengeInfo_005_2:IsPurgable()return false end
function modifier_ChallengeInfo_005_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_2:GetTexture() return "antimage/immortal/antimage_blink" end
function modifier_ChallengeInfo_005_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_005_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_005_2:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetMana(parent:GetMaxMana()*0.6)
	end
end


modifier_ChallengeInfo_005_3 = advanced_modifier({})
function modifier_ChallengeInfo_005_3:IsHidden()return false end
function modifier_ChallengeInfo_005_3:IsDebuff()return true end
function modifier_ChallengeInfo_005_3:IsPurgable()return false end
function modifier_ChallengeInfo_005_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_3:GetTexture() return "antimage/immortal/antimage_blink" end
function modifier_ChallengeInfo_005_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_005_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_005_3:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetMana(parent:GetMaxMana()*0.35)
	end
end


modifier_ChallengeInfo_005_4 = advanced_modifier({})
function modifier_ChallengeInfo_005_4:IsHidden()return false end
function modifier_ChallengeInfo_005_4:IsDebuff()return true end
function modifier_ChallengeInfo_005_4:IsPurgable()return false end
function modifier_ChallengeInfo_005_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_4:GetTexture() return "antimage/immortal/antimage_blink" end
function modifier_ChallengeInfo_005_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_005_effect", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_005_4:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetMana(parent:GetMaxMana()*0.1)
	end
end


modifier_ChallengeInfo_005_5 = advanced_modifier({})
function modifier_ChallengeInfo_005_5:IsHidden()return false end
function modifier_ChallengeInfo_005_5:IsDebuff()return true end
function modifier_ChallengeInfo_005_5:IsPurgable()return false end
function modifier_ChallengeInfo_005_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_5:GetTexture() return "antimage/immortal/antimage_blink" end

function modifier_ChallengeInfo_005_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_005_effect", {stack = 6})
	end
    return 1
end
function modifier_ChallengeInfo_005_5:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetMana(0)
	end
end

function modifier_ChallengeInfo_005_5:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end



function modifier_ChallengeInfo_005_5:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return -90
end



modifier_ChallengeInfo_005_effect = advanced_modifier({})


function modifier_ChallengeInfo_005_effect:IsHidden()return true end
function modifier_ChallengeInfo_005_effect:IsDebuff()return false end
function modifier_ChallengeInfo_005_effect:IsPurgable()return false end
function modifier_ChallengeInfo_005_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_005_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_005_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_005_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_005_effect:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_005_effect:OnRefresh(keys)
	if IsServer() then

		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end

function modifier_ChallengeInfo_005_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值


	}
end


function modifier_ChallengeInfo_005_effect:GetModifierManaBonus()	return 100*self:GetStackCount() end



---------------------------------苦难6

modifier_ChallengeInfo_006_1 = advanced_modifier({})
function modifier_ChallengeInfo_006_1:IsHidden()return false end
function modifier_ChallengeInfo_006_1:IsDebuff()return true end
function modifier_ChallengeInfo_006_1:IsPurgable()return false end
function modifier_ChallengeInfo_006_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_1:GetTexture() return "puck_dream_coil" end
function modifier_ChallengeInfo_006_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_006_effect", {stack = 1})
	end
    return 1
end
function modifier_ChallengeInfo_006_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_ChallengeInfo_006_1:Advanced_GetModifierSpellAmplifyBonus()	return -15 end


modifier_ChallengeInfo_006_2 = advanced_modifier({})
function modifier_ChallengeInfo_006_2:IsHidden()return false end
function modifier_ChallengeInfo_006_2:IsDebuff()return true end
function modifier_ChallengeInfo_006_2:IsPurgable()return false end
function modifier_ChallengeInfo_006_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_2:GetTexture() return "puck_dream_coil" end
function modifier_ChallengeInfo_006_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_006_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_006_2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,         --技能伤害


	}
end

function modifier_ChallengeInfo_006_2:Advanced_GetModifierSpellAmplifyBonus()	return -35 end



modifier_ChallengeInfo_006_3 = advanced_modifier({})
function modifier_ChallengeInfo_006_3:IsHidden()return false end
function modifier_ChallengeInfo_006_3:IsDebuff()return true end
function modifier_ChallengeInfo_006_3:IsPurgable()return false end
function modifier_ChallengeInfo_006_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_3:GetTexture() return "puck_dream_coil" end
function modifier_ChallengeInfo_006_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_006_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_006_3:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,         --技能伤害


	}
end

function modifier_ChallengeInfo_006_3:Advanced_GetModifierSpellAmplifyBonus()	return -65 end



modifier_ChallengeInfo_006_4 = advanced_modifier({})
function modifier_ChallengeInfo_006_4:IsHidden()return false end
function modifier_ChallengeInfo_006_4:IsDebuff()return true end
function modifier_ChallengeInfo_006_4:IsPurgable()return false end
function modifier_ChallengeInfo_006_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_4:GetTexture() return "puck_dream_coil" end
function modifier_ChallengeInfo_006_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_006_effect", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_006_4:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,         --技能伤害


	}
end

function modifier_ChallengeInfo_006_4:Advanced_GetModifierSpellAmplifyBonus()	return -90 end


modifier_ChallengeInfo_006_5 = advanced_modifier({})
function modifier_ChallengeInfo_006_5:IsHidden()return false end
function modifier_ChallengeInfo_006_5:IsDebuff()return true end
function modifier_ChallengeInfo_006_5:IsPurgable()return false end
function modifier_ChallengeInfo_006_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_5:GetTexture() return "puck_dream_coil" end
function modifier_ChallengeInfo_006_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_006_effect", {stack = 7})
	end
    return 1
end
function modifier_ChallengeInfo_006_5:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,         --技能伤害


	}
end

function modifier_ChallengeInfo_006_5:Advanced_GetModifierSpellAmplifyBonus()	return -200 end




modifier_ChallengeInfo_006_effect = advanced_modifier({})


function modifier_ChallengeInfo_006_effect:IsHidden()return true end
function modifier_ChallengeInfo_006_effect:IsDebuff()return false end
function modifier_ChallengeInfo_006_effect:IsPurgable()return false end
function modifier_ChallengeInfo_006_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_006_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_006_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_006_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_006_effect:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_006_effect:OnRefresh(keys)
	if IsServer() then

		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end

function modifier_ChallengeInfo_006_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,         --技能伤害


	}
end

function modifier_ChallengeInfo_006_effect:Advanced_GetModifierSpellAmplifyBonus()	return self:GetStackCount() end


---------------------------------苦难7


modifier_ChallengeInfo_007_1 = advanced_modifier({})
function modifier_ChallengeInfo_007_1:IsHidden()return false end
function modifier_ChallengeInfo_007_1:IsDebuff()return true end
function modifier_ChallengeInfo_007_1:IsPurgable()return false end
function modifier_ChallengeInfo_007_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_1:GetTexture() return "juggernaut/fortunes_tout/juggernaut_healing_ward" end
function modifier_ChallengeInfo_007_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_007_effect", {stack = 2})
	end
    return 1
end

-- advanced_modifier
function modifier_ChallengeInfo_007_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_1:Advanced_GetModifierHealAMP_Percentage(keys)
	return -10 
end





modifier_ChallengeInfo_007_2 = advanced_modifier({})
function modifier_ChallengeInfo_007_2:IsHidden()return false end
function modifier_ChallengeInfo_007_2:IsDebuff()return true end
function modifier_ChallengeInfo_007_2:IsPurgable()return false end
function modifier_ChallengeInfo_007_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_2:GetTexture() return "juggernaut/fortunes_tout/juggernaut_healing_ward" end
function modifier_ChallengeInfo_007_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_007_effect", {stack = 3})
	end
    return 1
end


function modifier_ChallengeInfo_007_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_2:Advanced_GetModifierHealAMP_Percentage(keys)
	return -35 
end




modifier_ChallengeInfo_007_3 = advanced_modifier({})
function modifier_ChallengeInfo_007_3:IsHidden()return false end
function modifier_ChallengeInfo_007_3:IsDebuff()return true end
function modifier_ChallengeInfo_007_3:IsPurgable()return false end
function modifier_ChallengeInfo_007_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_3:GetTexture() return "juggernaut/fortunes_tout/juggernaut_healing_ward" end
function modifier_ChallengeInfo_007_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_007_effect", {stack = 5})
	end
    return 1
end



-- advanced_modifier
function modifier_ChallengeInfo_007_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_3:Advanced_GetModifierHealAMP_Percentage(keys)
	return -60 
end




modifier_ChallengeInfo_007_4 = advanced_modifier({})
function modifier_ChallengeInfo_007_4:IsHidden()return false end
function modifier_ChallengeInfo_007_4:IsDebuff()return true end
function modifier_ChallengeInfo_007_4:IsPurgable()return false end
function modifier_ChallengeInfo_007_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_4:GetTexture() return "juggernaut/fortunes_tout/juggernaut_healing_ward" end
function modifier_ChallengeInfo_007_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_007_effect", {stack = 7})
	end
    return 1
end

-- advanced_modifier
function modifier_ChallengeInfo_007_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_4:Advanced_GetModifierHealAMP_Percentage(keys)
	return -85 
end


modifier_ChallengeInfo_007_5 = advanced_modifier({})
function modifier_ChallengeInfo_007_5:IsHidden()return false end
function modifier_ChallengeInfo_007_5:IsDebuff()return true end
function modifier_ChallengeInfo_007_5:IsPurgable()return false end
function modifier_ChallengeInfo_007_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_5:GetTexture() return "juggernaut/fortunes_tout/juggernaut_healing_ward" end
function modifier_ChallengeInfo_007_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_007_effect", {stack = 10})
	end
    return 1
end

-- advanced_modifier
function modifier_ChallengeInfo_007_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_5:Advanced_GetModifierHealAMP_Percentage(keys)
	return -200 
end


modifier_ChallengeInfo_007_effect = advanced_modifier({})


function modifier_ChallengeInfo_007_effect:IsHidden()return true end
function modifier_ChallengeInfo_007_effect:IsDebuff()return false end
function modifier_ChallengeInfo_007_effect:IsPurgable()return false end
function modifier_ChallengeInfo_007_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_007_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_007_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_007_effect:GetTexture() return "necrolyte_heartstopper_aura" end


function modifier_ChallengeInfo_007_effect:OnCreated(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_007_effect:OnRefresh(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end
-- advanced_modifier
function modifier_ChallengeInfo_007_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_007_effect:Advanced_GetModifierHealAMP_Percentage(keys)
	return self:GetStackCount() 
end



---------------------------------苦难8
modifier_ChallengeInfo_008_1 = advanced_modifier({})
function modifier_ChallengeInfo_008_1:IsHidden()return false end
function modifier_ChallengeInfo_008_1:IsDebuff()return true end
function modifier_ChallengeInfo_008_1:IsPurgable()return false end
function modifier_ChallengeInfo_008_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_008_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_008_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_008_1:GetTexture() return "abyssal_underlord/ti8_immortal_weapon/abyssal_underlord_pit_of_malice_immortal_crimson" end
function modifier_ChallengeInfo_008_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5*self:GetStackCount()
		hero.Bonus_gold = hero.Bonus_gold+15*self:GetStackCount()
	end
    return 1
end

function modifier_ChallengeInfo_008_1:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)	
	end
end
function modifier_ChallengeInfo_008_1:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()

	end
end



function modifier_ChallengeInfo_008_1:Advanced_GetModifierIncomingDamage_Percentage()	return 15*self:GetStackCount() end

function modifier_ChallengeInfo_008_1:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end






modifier_ChallengeInfo_008_2 = advanced_modifier({})
function modifier_ChallengeInfo_008_2:IsHidden()return false end
function modifier_ChallengeInfo_008_2:IsDebuff()return true end
function modifier_ChallengeInfo_008_2:IsPurgable()return false end
function modifier_ChallengeInfo_008_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_008_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_008_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_008_2:GetTexture() return "abyssal_underlord/ti8_immortal_weapon/abyssal_underlord_pit_of_malice_immortal_crimson" end
function modifier_ChallengeInfo_008_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10*self:GetStackCount()
		hero.Bonus_gold = hero.Bonus_gold+60*self:GetStackCount()
	end
    return 1
end

function modifier_ChallengeInfo_008_2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)	
	end
end
function modifier_ChallengeInfo_008_2:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()

	end
end


function modifier_ChallengeInfo_008_2:Advanced_GetModifierIncomingDamage_Percentage()	return 35*self:GetStackCount() end



function modifier_ChallengeInfo_008_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_ChallengeInfo_008_3 = advanced_modifier({})
function modifier_ChallengeInfo_008_3:IsHidden()return false end
function modifier_ChallengeInfo_008_3:IsDebuff()return true end
function modifier_ChallengeInfo_008_3:IsPurgable()return false end
function modifier_ChallengeInfo_008_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_008_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_008_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_008_3:GetTexture() return "abyssal_underlord/ti8_immortal_weapon/abyssal_underlord_pit_of_malice_immortal_crimson" end
function modifier_ChallengeInfo_008_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15*self:GetStackCount()
		hero.Bonus_gold = hero.Bonus_gold+100*self:GetStackCount()
	end
    return 1
end

function modifier_ChallengeInfo_008_3:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)	
	end
end
function modifier_ChallengeInfo_008_3:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()

	end
end


function modifier_ChallengeInfo_008_3:Advanced_GetModifierIncomingDamage_Percentage()	return 60*self:GetStackCount() end


function modifier_ChallengeInfo_008_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


modifier_ChallengeInfo_008_4 = advanced_modifier({})
function modifier_ChallengeInfo_008_4:IsHidden()return false end
function modifier_ChallengeInfo_008_4:IsDebuff()return true end
function modifier_ChallengeInfo_008_4:IsPurgable()return false end
function modifier_ChallengeInfo_008_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_008_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_008_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_008_4:GetTexture() return "abyssal_underlord/ti8_immortal_weapon/abyssal_underlord_pit_of_malice_immortal_crimson" end
function modifier_ChallengeInfo_008_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25*self:GetStackCount()
		hero.Bonus_gold = hero.Bonus_gold+150*self:GetStackCount()
	end
    return 1
end

function modifier_ChallengeInfo_008_4:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)	
	end
end
function modifier_ChallengeInfo_008_4:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()

	end
end


function modifier_ChallengeInfo_008_4:Advanced_GetModifierIncomingDamage_Percentage()	return 90*self:GetStackCount() end


function modifier_ChallengeInfo_008_4:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_ChallengeInfo_008_5 = advanced_modifier({})
function modifier_ChallengeInfo_008_5:IsHidden()return false end
function modifier_ChallengeInfo_008_5:IsDebuff()return true end
function modifier_ChallengeInfo_008_5:IsPurgable()return false end
function modifier_ChallengeInfo_008_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_008_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_008_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_008_5:GetTexture() return "abyssal_underlord/ti8_immortal_weapon/abyssal_underlord_pit_of_malice_immortal_crimson" end
function modifier_ChallengeInfo_008_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())*self:GetStackCount()
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40*self:GetStackCount()
		hero.Bonus_gold = hero.Bonus_gold+250*self:GetStackCount()
	end
    return 1
end

function modifier_ChallengeInfo_008_5:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)	
	end
end
function modifier_ChallengeInfo_008_5:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()

	end
end

function modifier_ChallengeInfo_008_5:Advanced_GetModifierIncomingDamage_Percentage()	return 150*self:GetStackCount() end


function modifier_ChallengeInfo_008_5:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end






---------------------------------苦难9
modifier_ChallengeInfo_009_1 = advanced_modifier({})
function modifier_ChallengeInfo_009_1:IsHidden()return false end
function modifier_ChallengeInfo_009_1:IsDebuff()return true end
function modifier_ChallengeInfo_009_1:IsPurgable()return false end
function modifier_ChallengeInfo_009_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_009_1:GetTexture() return "earth_spirit_stone_caller" end
function modifier_ChallengeInfo_009_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_009_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_009_1:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		local index = -0.1

		self.bonusa = index* self.caster:GetAgility()
		self.bonusi = index*self.caster:GetIntellect(false)
		self.bonuss = index*self.caster:GetStrength()
	end
end
function modifier_ChallengeInfo_009_1:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_1:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_ChallengeInfo_009_1:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_ChallengeInfo_009_1:GetModifierBonusStats_Strength()  return self.bonuss end



modifier_ChallengeInfo_009_2 = advanced_modifier({})
function modifier_ChallengeInfo_009_2:IsHidden()return false end
function modifier_ChallengeInfo_009_2:IsDebuff()return true end
function modifier_ChallengeInfo_009_2:IsPurgable()return false end
function modifier_ChallengeInfo_009_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_009_2:GetTexture() return "earth_spirit_stone_caller" end
function modifier_ChallengeInfo_009_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_009_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_009_2:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		local index = -0.2

		self.bonusa = index* self.caster:GetAgility()
		self.bonusi = index*self.caster:GetIntellect(false)
		self.bonuss = index*self.caster:GetStrength()
	end
end
function modifier_ChallengeInfo_009_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_2:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_ChallengeInfo_009_2:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_ChallengeInfo_009_2:GetModifierBonusStats_Strength()  return self.bonuss end


modifier_ChallengeInfo_009_3 = advanced_modifier({})
function modifier_ChallengeInfo_009_3:IsHidden()return false end
function modifier_ChallengeInfo_009_3:IsDebuff()return true end
function modifier_ChallengeInfo_009_3:IsPurgable()return false end
function modifier_ChallengeInfo_009_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_009_3:GetTexture() return "earth_spirit_stone_caller" end
function modifier_ChallengeInfo_009_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_009_effect", {stack = 5})
	end
    return 1
end
function modifier_ChallengeInfo_009_3:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		local index = -0.4

		self.bonusa = index* self.caster:GetAgility()
		self.bonusi = index*self.caster:GetIntellect(false)
		self.bonuss = index*self.caster:GetStrength()
	end
end
function modifier_ChallengeInfo_009_3:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_3:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_ChallengeInfo_009_3:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_ChallengeInfo_009_3:GetModifierBonusStats_Strength()  return self.bonuss end


modifier_ChallengeInfo_009_4 = advanced_modifier({})
function modifier_ChallengeInfo_009_4:IsHidden()return false end
function modifier_ChallengeInfo_009_4:IsDebuff()return true end
function modifier_ChallengeInfo_009_4:IsPurgable()return false end
function modifier_ChallengeInfo_009_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_009_4:GetTexture() return "earth_spirit_stone_caller" end
function modifier_ChallengeInfo_009_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_009_effect", {stack = 7})
	end
    return 1
end
function modifier_ChallengeInfo_009_4:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		local index = -0.6

		self.bonusa = index* self.caster:GetAgility()
		self.bonusi = index*self.caster:GetIntellect(false)
		self.bonuss = index*self.caster:GetStrength()
	end
end
function modifier_ChallengeInfo_009_4:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_4:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_ChallengeInfo_009_4:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_ChallengeInfo_009_4:GetModifierBonusStats_Strength()  return self.bonuss end



modifier_ChallengeInfo_009_5 = advanced_modifier({})
function modifier_ChallengeInfo_009_5:IsHidden()return false end
function modifier_ChallengeInfo_009_5:IsDebuff()return true end
function modifier_ChallengeInfo_009_5:IsPurgable()return false end
function modifier_ChallengeInfo_009_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_009_5:GetTexture() return "earth_spirit_stone_caller" end
function modifier_ChallengeInfo_009_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_009_effect", {stack = 10})
	end
    return 1
end
function modifier_ChallengeInfo_009_5:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		local index = -0.8

		self.bonusa = index* self.caster:GetAgility()
		self.bonusi = index*self.caster:GetIntellect(false)
		self.bonuss = index*self.caster:GetStrength()
	end
end
function modifier_ChallengeInfo_009_5:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_5:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_ChallengeInfo_009_5:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_ChallengeInfo_009_5:GetModifierBonusStats_Strength()  return self.bonuss end




modifier_ChallengeInfo_009_effect = advanced_modifier({})
function modifier_ChallengeInfo_009_effect:IsHidden()return true end
function modifier_ChallengeInfo_009_effect:IsDebuff()return false end
function modifier_ChallengeInfo_009_effect:IsPurgable()return false end
function modifier_ChallengeInfo_009_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_009_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_009_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_009_effect:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_009_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_009_effect:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_009_effect:GetModifierBonusStats_Agility()   return self:GetStackCount() end
function modifier_ChallengeInfo_009_effect:GetModifierBonusStats_Intellect() return self:GetStackCount() end
function modifier_ChallengeInfo_009_effect:GetModifierBonusStats_Strength()  return self:GetStackCount() end



---------------------------------苦难10
modifier_ChallengeInfo_010_1 = advanced_modifier({})
function modifier_ChallengeInfo_010_1:IsHidden()return false end
function modifier_ChallengeInfo_010_1:IsDebuff()return true end
function modifier_ChallengeInfo_010_1:IsPurgable()return false end
function modifier_ChallengeInfo_010_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_010_1:GetTexture() return "life_stealer_control" end
function modifier_ChallengeInfo_010_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_010_1:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_ChallengeInfo_010_1:OnIntervalThink()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_debuff", {duration = 2})
end


modifier_ChallengeInfo_010_2 = advanced_modifier({})
function modifier_ChallengeInfo_010_2:IsHidden()return false end
function modifier_ChallengeInfo_010_2:IsDebuff()return true end
function modifier_ChallengeInfo_010_2:IsPurgable()return false end
function modifier_ChallengeInfo_010_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_010_2:GetTexture() return "life_stealer_control" end
function modifier_ChallengeInfo_010_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_010_2:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_ChallengeInfo_010_2:OnIntervalThink()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_debuff", {duration = 3})
end



modifier_ChallengeInfo_010_3 = advanced_modifier({})
function modifier_ChallengeInfo_010_3:IsHidden()return false end
function modifier_ChallengeInfo_010_3:IsDebuff()return true end
function modifier_ChallengeInfo_010_3:IsPurgable()return false end
function modifier_ChallengeInfo_010_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_010_3:GetTexture() return "life_stealer_control" end
function modifier_ChallengeInfo_010_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_effect", {stack = 5})
	end
    return 1
end
function modifier_ChallengeInfo_010_3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_ChallengeInfo_010_3:OnIntervalThink()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_debuff", {duration = 4})
end


modifier_ChallengeInfo_010_4 = advanced_modifier({})
function modifier_ChallengeInfo_010_4:IsHidden()return false end
function modifier_ChallengeInfo_010_4:IsDebuff()return true end
function modifier_ChallengeInfo_010_4:IsPurgable()return false end
function modifier_ChallengeInfo_010_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_010_4:GetTexture() return "life_stealer_control" end
function modifier_ChallengeInfo_010_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_effect", {stack = 7})
	end
    return 1
end
function modifier_ChallengeInfo_010_4:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_ChallengeInfo_010_4:OnIntervalThink()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_debuff", {duration = 7})
end


modifier_ChallengeInfo_010_5 = advanced_modifier({})
function modifier_ChallengeInfo_010_5:IsHidden()return false end
function modifier_ChallengeInfo_010_5:IsDebuff()return true end
function modifier_ChallengeInfo_010_5:IsPurgable()return false end
function modifier_ChallengeInfo_010_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_010_5:GetTexture() return "life_stealer_control" end
function modifier_ChallengeInfo_010_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_effect", {stack = 10})
	end
    return 1
end
function modifier_ChallengeInfo_010_5:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_010_5:OnIntervalThink()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_010_debuff", {duration = 2})
end



modifier_ChallengeInfo_010_effect = advanced_modifier({})


function modifier_ChallengeInfo_010_effect:IsHidden()return true end
function modifier_ChallengeInfo_010_effect:IsDebuff()return false end
function modifier_ChallengeInfo_010_effect:IsPurgable()return false end
function modifier_ChallengeInfo_010_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_010_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_010_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_010_effect:OnCreated(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_010_effect:OnRefresh(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end

-- advanced_modifier
function modifier_ChallengeInfo_010_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain
    }
end
function modifier_ChallengeInfo_010_effect:Advanced_GetModifier_DurationGain(keys)
	return self:GetStackCount()
end



function modifier_ChallengeInfo_010_effect:Advanced_GetModifier_NegativeDurationGain(keys)
	return self:GetStackCount()
end



modifier_ChallengeInfo_010_debuff = advanced_modifier({})

function modifier_ChallengeInfo_010_debuff:IsDebuff() return true end
function modifier_ChallengeInfo_010_debuff:IsHidden() return false end
function modifier_ChallengeInfo_010_debuff:IsPurgable() return false end
function modifier_ChallengeInfo_010_debuff:IsPurgeException() return false end
function modifier_ChallengeInfo_010_debuff:GetTexture()return "life_stealer_control" end
function modifier_ChallengeInfo_010_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_ChallengeInfo_010_debuff:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_ChallengeInfo_010_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,

}
	return state
end





---------------------------------苦难11
modifier_ChallengeInfo_011_1 = advanced_modifier({})
function modifier_ChallengeInfo_011_1:IsHidden()return false end
function modifier_ChallengeInfo_011_1:IsDebuff()return true end
function modifier_ChallengeInfo_011_1:IsPurgable()return false end
function modifier_ChallengeInfo_011_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_1:GetTexture() return "centaur_khan_endurance_aura" end
function modifier_ChallengeInfo_011_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_011_effect", {stack = 4})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
    return 1
end
function modifier_ChallengeInfo_011_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_011_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_011_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.1)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.1)
	end
end



modifier_ChallengeInfo_011_2 = advanced_modifier({})
function modifier_ChallengeInfo_011_2:IsHidden()return false end
function modifier_ChallengeInfo_011_2:IsDebuff()return true end
function modifier_ChallengeInfo_011_2:IsPurgable()return false end
function modifier_ChallengeInfo_011_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_2:GetTexture() return "centaur_khan_endurance_aura" end
function modifier_ChallengeInfo_011_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_011_effect", {stack = 7})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
    return 1
end
function modifier_ChallengeInfo_011_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_011_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_011_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.3)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.3)
	end
end


modifier_ChallengeInfo_011_3 = advanced_modifier({})
function modifier_ChallengeInfo_011_3:IsHidden()return false end
function modifier_ChallengeInfo_011_3:IsDebuff()return true end
function modifier_ChallengeInfo_011_3:IsPurgable()return false end
function modifier_ChallengeInfo_011_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_3:GetTexture() return "centaur_khan_endurance_aura" end
function modifier_ChallengeInfo_011_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_011_effect", {stack = 10})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
    return 1
end
function modifier_ChallengeInfo_011_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_011_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_011_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.45)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.45)
	end
end


modifier_ChallengeInfo_011_4 = advanced_modifier({})
function modifier_ChallengeInfo_011_4:IsHidden()return false end
function modifier_ChallengeInfo_011_4:IsDebuff()return true end
function modifier_ChallengeInfo_011_4:IsPurgable()return false end
function modifier_ChallengeInfo_011_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_4:GetTexture() return "centaur_khan_endurance_aura" end
function modifier_ChallengeInfo_011_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_011_effect", {stack = 15})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
    return 1
end
function modifier_ChallengeInfo_011_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_011_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_011_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.8)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.8)
	end
end


modifier_ChallengeInfo_011_5 = advanced_modifier({})
function modifier_ChallengeInfo_011_5:IsHidden()return false end
function modifier_ChallengeInfo_011_5:IsDebuff()return true end
function modifier_ChallengeInfo_011_5:IsPurgable()return false end
function modifier_ChallengeInfo_011_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_5:GetTexture() return "centaur_khan_endurance_aura" end
function modifier_ChallengeInfo_011_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_011_effect", {stack = 21})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
    return 1
end
function modifier_ChallengeInfo_011_5:OnCreated()
	if IsServer() then

		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_011_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_011_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:SetBaseDamageMax(unit:GetBaseDamageMax()*2.5)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin()*2.5)
	end
end



modifier_ChallengeInfo_011_effect = advanced_modifier({})

function modifier_ChallengeInfo_011_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_011_effect:IsHidden() 			return true end
function modifier_ChallengeInfo_011_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_011_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_011_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_011_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_011_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_011_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_011_effect:DeclareFunctions() return 
    {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	} 
end

	-- self.advanced_level

function modifier_ChallengeInfo_011_effect:GetModifierBaseAttack_BonusDamage() 
	local damage = self:GetStackCount()
	if self:GetParent():HasModifier("modifier_Advanced_shapeshift_unloock3") then
		damage = damage *3
	end

    return damage
end




---------------------------------苦难12
modifier_ChallengeInfo_012_1 = advanced_modifier({})
function modifier_ChallengeInfo_012_1:IsHidden()return false end
function modifier_ChallengeInfo_012_1:IsDebuff()return true end
function modifier_ChallengeInfo_012_1:IsPurgable()return false end
function modifier_ChallengeInfo_012_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_1:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_012_buff", {stack = 7})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
    return 1
end
function modifier_ChallengeInfo_012_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_012_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_012_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_012_effect", {stack = 10})
		end
	end
end






modifier_ChallengeInfo_012_2 = advanced_modifier({})
function modifier_ChallengeInfo_012_2:IsHidden()return false end
function modifier_ChallengeInfo_012_2:IsDebuff()return true end
function modifier_ChallengeInfo_012_2:IsPurgable()return false end
function modifier_ChallengeInfo_012_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_2:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		-- _G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +0.5
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_012_buff", {stack = 12})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
    return 1
end
function modifier_ChallengeInfo_012_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_012_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_012_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_012_effect", {stack = 20})
		end
	end
end


modifier_ChallengeInfo_012_3 = advanced_modifier({})
function modifier_ChallengeInfo_012_3:IsHidden()return false end
function modifier_ChallengeInfo_012_3:IsDebuff()return true end
function modifier_ChallengeInfo_012_3:IsPurgable()return false end
function modifier_ChallengeInfo_012_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_3:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		-- _G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +0.8
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_012_buff", {stack = 15})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
    return 1
end
function modifier_ChallengeInfo_012_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_012_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_012_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_012_effect", {stack = 40})
		end
	end
end


modifier_ChallengeInfo_012_4 = advanced_modifier({})
function modifier_ChallengeInfo_012_4:IsHidden()return false end
function modifier_ChallengeInfo_012_4:IsDebuff()return true end
function modifier_ChallengeInfo_012_4:IsPurgable()return false end
function modifier_ChallengeInfo_012_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_4:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		-- _G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_012_buff", {stack = 22})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
    return 1
end
function modifier_ChallengeInfo_012_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_012_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_012_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_012_effect", {stack = 70})
		end
	end
end



modifier_ChallengeInfo_012_5 = advanced_modifier({})
function modifier_ChallengeInfo_012_5:IsHidden()return false end
function modifier_ChallengeInfo_012_5:IsDebuff()return true end
function modifier_ChallengeInfo_012_5:IsPurgable()return false end
function modifier_ChallengeInfo_012_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_5:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		-- _G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.5
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_012_buff", {stack = 30})
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
    return 1
end
function modifier_ChallengeInfo_012_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_012_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_012_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_012_effect", {stack = 120})
		end
	end
end




modifier_ChallengeInfo_012_effect = advanced_modifier({})

function modifier_ChallengeInfo_012_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_012_effect:IsHidden() 			return false end
function modifier_ChallengeInfo_012_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_012_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_effect:GetTexture() return "alchemist_chemical_rage" end
function modifier_ChallengeInfo_012_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_012_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end



function modifier_ChallengeInfo_012_effect:Advanced_GetModifierAttackSpeedPercentage() 
    return self:GetStackCount()
end
function modifier_ChallengeInfo_012_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end




modifier_ChallengeInfo_012_buff = advanced_modifier({})

function modifier_ChallengeInfo_012_buff:IsDebuff()			return false end
function modifier_ChallengeInfo_012_buff:IsHidden() 			return true end
function modifier_ChallengeInfo_012_buff:IsPurgable() 		    return false end
function modifier_ChallengeInfo_012_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_012_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_012_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_012_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_012_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_012_buff:DeclareFunctions() return 
    {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度,
	} 
end



function modifier_ChallengeInfo_012_buff:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()
end


---------------------------------苦难13

modifier_ChallengeInfo_013_1 = advanced_modifier({})
function modifier_ChallengeInfo_013_1:IsHidden()return false end
function modifier_ChallengeInfo_013_1:IsDebuff()return true end
function modifier_ChallengeInfo_013_1:IsPurgable()return false end
function modifier_ChallengeInfo_013_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_013_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_013_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_1:GetTexture() return "techies_remote_mines_self_detonate" end
function modifier_ChallengeInfo_013_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		hero:AddItemByName("item_hd_Treasure1")
	end
    return 1
end
function modifier_ChallengeInfo_013_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_013_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_013_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_013_effect", {stack = 10})
		end
	end
end


modifier_ChallengeInfo_013_2 = advanced_modifier({})
function modifier_ChallengeInfo_013_2:IsHidden()return false end
function modifier_ChallengeInfo_013_2:IsDebuff()return true end
function modifier_ChallengeInfo_013_2:IsPurgable()return false end
function modifier_ChallengeInfo_013_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_013_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_013_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_2:GetTexture() return "techies_remote_mines_self_detonate" end
function modifier_ChallengeInfo_013_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		if RandomInt(1, 2)==1 then
			hero:AddItemByName("item_hd_Treasure1")
		else
			hero:AddItemByName("item_hd_Treasure2")
		end
	end
    return 1
end
function modifier_ChallengeInfo_013_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_013_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_013_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_013_effect", {stack = 20})
		end
	end
end



modifier_ChallengeInfo_013_3 = advanced_modifier({})
function modifier_ChallengeInfo_013_3:IsHidden()return false end
function modifier_ChallengeInfo_013_3:IsDebuff()return true end
function modifier_ChallengeInfo_013_3:IsPurgable()return false end
function modifier_ChallengeInfo_013_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_013_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_013_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_3:GetTexture() return "techies_remote_mines_self_detonate" end
function modifier_ChallengeInfo_013_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		if RandomInt(1, 2)==1 then
			hero:AddItemByName("item_hd_Treasure2")
		else
			hero:AddItemByName("item_hd_Treasure3")
		end
	end
    return 1
end
function modifier_ChallengeInfo_013_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_013_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_013_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_013_effect", {stack = 50})
		end
	end
end


modifier_ChallengeInfo_013_4 = advanced_modifier({})
function modifier_ChallengeInfo_013_4:IsHidden()return false end
function modifier_ChallengeInfo_013_4:IsDebuff()return true end
function modifier_ChallengeInfo_013_4:IsPurgable()return false end
function modifier_ChallengeInfo_013_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_013_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_013_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_4:GetTexture() return "techies_remote_mines_self_detonate" end
function modifier_ChallengeInfo_013_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		hero:AddItemByName("item_hd_Treasure3")
	end
    return 1
end
function modifier_ChallengeInfo_013_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_013_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_013_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_013_effect", {stack = 80})
		end
	end
end


modifier_ChallengeInfo_013_5 = advanced_modifier({})
function modifier_ChallengeInfo_013_5:IsHidden()return false end
function modifier_ChallengeInfo_013_5:IsDebuff()return true end
function modifier_ChallengeInfo_013_5:IsPurgable()return false end
function modifier_ChallengeInfo_013_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_013_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_013_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_5:GetTexture() return "techies_remote_mines_self_detonate" end
function modifier_ChallengeInfo_013_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		hero:AddItemByName("item_hd_Treasure4")
	end
    return 1
end
function modifier_ChallengeInfo_013_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_013_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_013_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_013_effect", {stack = 120})
		end
	end
end



modifier_ChallengeInfo_013_effect = advanced_modifier({})

function modifier_ChallengeInfo_013_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_013_effect:IsHidden() 			return false end
function modifier_ChallengeInfo_013_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_013_effect:IsPurgeException() 	return false end
-- function modifier_ChallengeInfo_013_effect:RemoveOnDeath() return false end
-- function modifier_ChallengeInfo_013_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_013_effect:OnCreated(keys)
	if IsServer() then
		self.stack = keys.stack
		-- self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_013_effect:OnRefresh(keys)
	if IsServer() then
		self.stack = self.stack+ keys.stack
		-- self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_013_effect:OnDestroy()
    if not IsServer() then
        return
    end
	local unit = self:GetParent()
	if unit:IsNull() then
		return
	end
	if unit:IsInvulnerable() then
		return
	end
	local pos = unit:GetAbsOrigin()
	local health = unit:GetMaxHealth()
	local class_name = unit:GetClassname()
	local unit_name = unit:GetUnitName()
	if  unit_name=="npc_attack_unit" or class_name=="npc_dota_thinker" or class_name=="npc_dota_base" then
		return
	end
	local pos = unit:GetAbsOrigin()
	local health = unit:GetMaxHealth()
	if health<=50 then
		return
	end
	if unit:GetUnitName()=="npc_dota_thinker" then
		return
	end
	local stack = self.stack
	Timers:CreateTimer(3, function()
		if not unit or unit:IsNull() then
			return
		end
		unit:EmitSound("Hero_OgreMagi.Fireblast.Target")
		-- local pfx_aoe = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
		local pfx_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, nil)
		

		
		ParticleManager:SetParticleControl(pfx_aoe, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx_aoe)

		local damage = health*stack*0.01

		local units = FindUnitsInRadius(unit:GetTeamNumber(), pos, nil,420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		
		local damagetable = {
			attacker = unit,
			ability = nil,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
	
		for i=1, #units do
			damagetable.victim = units[i]
			ApplyDamage(damagetable)
		end

	end)
end


---------------------------------苦难14

modifier_ChallengeInfo_014_1 = advanced_modifier({})
function modifier_ChallengeInfo_014_1:IsHidden()return false end
function modifier_ChallengeInfo_014_1:IsDebuff()return true end
function modifier_ChallengeInfo_014_1:IsPurgable()return false end
function modifier_ChallengeInfo_014_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_1:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then

		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_014_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_014_1:OnCreated()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		for _, unit in ipairs(heroes) do
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_014_debuff", {stack = 10})
		end

	end
end


modifier_ChallengeInfo_014_2 = advanced_modifier({})
function modifier_ChallengeInfo_014_2:IsHidden()return false end
function modifier_ChallengeInfo_014_2:IsDebuff()return true end
function modifier_ChallengeInfo_014_2:IsPurgable()return false end
function modifier_ChallengeInfo_014_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_2:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_014_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_014_2:OnCreated()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		for _, unit in ipairs(heroes) do
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_014_debuff", {stack =20})
		end

	end
end


modifier_ChallengeInfo_014_3 = advanced_modifier({})
function modifier_ChallengeInfo_014_3:IsHidden()return false end
function modifier_ChallengeInfo_014_3:IsDebuff()return true end
function modifier_ChallengeInfo_014_3:IsPurgable()return false end
function modifier_ChallengeInfo_014_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_3:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_014_effect", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_014_3:OnCreated()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		for _, unit in ipairs(heroes) do
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_014_debuff", {stack = 30})
		end

	end
end



modifier_ChallengeInfo_014_4 = advanced_modifier({})
function modifier_ChallengeInfo_014_4:IsHidden()return false end
function modifier_ChallengeInfo_014_4:IsDebuff()return true end
function modifier_ChallengeInfo_014_4:IsPurgable()return false end
function modifier_ChallengeInfo_014_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_4:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_014_effect", {stack = 5})
	end
    return 1
end
function modifier_ChallengeInfo_014_4:OnCreated()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		for _, unit in ipairs(heroes) do

			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_014_debuff", {stack = 40})
		end

	end
end


modifier_ChallengeInfo_014_5 = advanced_modifier({})
function modifier_ChallengeInfo_014_5:IsHidden()return false end
function modifier_ChallengeInfo_014_5:IsDebuff()return true end
function modifier_ChallengeInfo_014_5:IsPurgable()return false end
function modifier_ChallengeInfo_014_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_5:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_014_effect", {stack = 8})
	end
    return 1
end
function modifier_ChallengeInfo_014_5:OnCreated()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		for _, unit in ipairs(heroes) do
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_014_debuff", {stack = 60})
		end

	end
end


modifier_ChallengeInfo_014_effect = advanced_modifier({})


function modifier_ChallengeInfo_014_effect:IsHidden()return true end
function modifier_ChallengeInfo_014_effect:IsDebuff()return false end
function modifier_ChallengeInfo_014_effect:IsPurgable()return false end
function modifier_ChallengeInfo_014_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_effect:GetTexture() return "necrolyte_heartstopper_aura" end

function modifier_ChallengeInfo_014_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_014_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_014_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_ChallengeInfo_014_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetStackCount()
end




modifier_ChallengeInfo_014_debuff = advanced_modifier({})

function modifier_ChallengeInfo_014_debuff:IsDebuff()			return true end
function modifier_ChallengeInfo_014_debuff:IsHidden() 			return false end
function modifier_ChallengeInfo_014_debuff:IsPurgable() 		    return false end
function modifier_ChallengeInfo_014_debuff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_014_debuff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_014_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_014_debuff:GetTexture() return "necrolyte/necro_ti7_immortal/necrolyte_reapers_scythe" end
function modifier_ChallengeInfo_014_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_014_debuff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end
function modifier_ChallengeInfo_014_debuff:OnWaveEnd()
    self:SafeDestroy()
    return 1
end
function modifier_ChallengeInfo_014_debuff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
		MODIFIER_EVENT_ON_Wave_End = {},
	}
end



function modifier_ChallengeInfo_014_debuff:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		local health = target:GetMaxHealth()
		if health<=50 then
			return
		end

		target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
		local modifier = self
		Timers:CreateTimer(1.5, function()
			if not modifier or modifier:IsNull() then
				return
			end

			local health = attacker:GetMaxHealth()- attacker:GetHealth()
			local damage = health*self:GetStackCount()*0.01
	
			
			local damagetable = {
				attacker = keys.unit,
				victim = attacker,
				ability = nil,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
		
			ApplyDamage(damagetable)

		end)
    end
end




------------------------苦难15

modifier_ChallengeInfo_015_1 = advanced_modifier({})
function modifier_ChallengeInfo_015_1:IsHidden()return false end
function modifier_ChallengeInfo_015_1:IsDebuff()return true end
function modifier_ChallengeInfo_015_1:IsPurgable()return false end
function modifier_ChallengeInfo_015_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_015_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_015_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_015_1:GetTexture() return "nevermore_dark_lord" end
function modifier_ChallengeInfo_015_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_015_1:WaveEndGOLDBONUS2()
    return 600
end
function modifier_ChallengeInfo_015_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_001",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_015_2 = advanced_modifier({})
function modifier_ChallengeInfo_015_2:IsHidden()return false end
function modifier_ChallengeInfo_015_2:IsDebuff()return true end
function modifier_ChallengeInfo_015_2:IsPurgable()return false end
function modifier_ChallengeInfo_015_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_015_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_015_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_015_2:GetTexture() return "nevermore_dark_lord" end
function modifier_ChallengeInfo_015_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_015_2:WaveEndGOLDBONUS2()
    return 960
end
function modifier_ChallengeInfo_015_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_001",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_015_3 = advanced_modifier({})
function modifier_ChallengeInfo_015_3:IsHidden()return false end
function modifier_ChallengeInfo_015_3:IsDebuff()return true end
function modifier_ChallengeInfo_015_3:IsPurgable()return false end
function modifier_ChallengeInfo_015_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_015_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_015_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_015_3:GetTexture() return "nevermore_dark_lord" end
function modifier_ChallengeInfo_015_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_015_3:WaveEndGOLDBONUS2()
    return 1440
end
function modifier_ChallengeInfo_015_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_001",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_015_4 = advanced_modifier({})
function modifier_ChallengeInfo_015_4:IsHidden()return false end
function modifier_ChallengeInfo_015_4:IsDebuff()return true end
function modifier_ChallengeInfo_015_4:IsPurgable()return false end
function modifier_ChallengeInfo_015_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_015_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_015_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_015_4:GetTexture() return "nevermore_dark_lord" end
function modifier_ChallengeInfo_015_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_015_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_015_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_001",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_015_5 = advanced_modifier({})
function modifier_ChallengeInfo_015_5:IsHidden()return false end
function modifier_ChallengeInfo_015_5:IsDebuff()return true end
function modifier_ChallengeInfo_015_5:IsPurgable()return false end
function modifier_ChallengeInfo_015_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_015_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_015_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_015_5:GetTexture() return "nevermore_dark_lord" end
function modifier_ChallengeInfo_015_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_015_5:WaveEndGOLDBONUS2()
    return 2400
end

function modifier_ChallengeInfo_015_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_001",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




------------------------苦难16

modifier_ChallengeInfo_016_1 = advanced_modifier({})
function modifier_ChallengeInfo_016_1:IsHidden()return false end
function modifier_ChallengeInfo_016_1:IsDebuff()return true end
function modifier_ChallengeInfo_016_1:IsPurgable()return false end
function modifier_ChallengeInfo_016_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_016_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_016_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_016_1:GetTexture() return "slark_shadow_dance" end
function modifier_ChallengeInfo_016_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_016_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_016_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_002",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_016_2 = advanced_modifier({})
function modifier_ChallengeInfo_016_2:IsHidden()return false end
function modifier_ChallengeInfo_016_2:IsDebuff()return true end
function modifier_ChallengeInfo_016_2:IsPurgable()return false end
function modifier_ChallengeInfo_016_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_016_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_016_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_016_2:GetTexture() return "slark_shadow_dance" end
function modifier_ChallengeInfo_016_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_016_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_016_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_002",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_016_3 = advanced_modifier({})
function modifier_ChallengeInfo_016_3:IsHidden()return false end
function modifier_ChallengeInfo_016_3:IsDebuff()return true end
function modifier_ChallengeInfo_016_3:IsPurgable()return false end
function modifier_ChallengeInfo_016_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_016_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_016_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_016_3:GetTexture() return "slark_shadow_dance" end
function modifier_ChallengeInfo_016_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_016_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_016_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_002",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_016_4 = advanced_modifier({})
function modifier_ChallengeInfo_016_4:IsHidden()return false end
function modifier_ChallengeInfo_016_4:IsDebuff()return true end
function modifier_ChallengeInfo_016_4:IsPurgable()return false end
function modifier_ChallengeInfo_016_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_016_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_016_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_016_4:GetTexture() return "slark_shadow_dance" end
function modifier_ChallengeInfo_016_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_016_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_016_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_002",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_016_5 = advanced_modifier({})
function modifier_ChallengeInfo_016_5:IsHidden()return false end
function modifier_ChallengeInfo_016_5:IsDebuff()return true end
function modifier_ChallengeInfo_016_5:IsPurgable()return false end
function modifier_ChallengeInfo_016_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_016_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_016_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_016_5:GetTexture() return "slark_shadow_dance" end
function modifier_ChallengeInfo_016_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_016_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_016_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_002",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end





------------------------苦难17

modifier_ChallengeInfo_017_1 = advanced_modifier({})
function modifier_ChallengeInfo_017_1:IsHidden()return false end
function modifier_ChallengeInfo_017_1:IsDebuff()return true end
function modifier_ChallengeInfo_017_1:IsPurgable()return false end
function modifier_ChallengeInfo_017_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_017_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_017_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_017_1:GetTexture() return "enigma_malefice" end
function modifier_ChallengeInfo_017_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_017_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_017_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_003",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_017_2 = advanced_modifier({})
function modifier_ChallengeInfo_017_2:IsHidden()return false end
function modifier_ChallengeInfo_017_2:IsDebuff()return true end
function modifier_ChallengeInfo_017_2:IsPurgable()return false end
function modifier_ChallengeInfo_017_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_017_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_017_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_017_2:GetTexture() return "enigma_malefice" end
function modifier_ChallengeInfo_017_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_017_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_017_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_003",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_017_3 = advanced_modifier({})
function modifier_ChallengeInfo_017_3:IsHidden()return false end
function modifier_ChallengeInfo_017_3:IsDebuff()return true end
function modifier_ChallengeInfo_017_3:IsPurgable()return false end
function modifier_ChallengeInfo_017_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_017_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_017_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_017_3:GetTexture() return "enigma_malefice" end
function modifier_ChallengeInfo_017_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_017_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_017_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_003",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_017_4 = advanced_modifier({})
function modifier_ChallengeInfo_017_4:IsHidden()return false end
function modifier_ChallengeInfo_017_4:IsDebuff()return true end
function modifier_ChallengeInfo_017_4:IsPurgable()return false end
function modifier_ChallengeInfo_017_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_017_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_017_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_017_4:GetTexture() return "enigma_malefice" end
function modifier_ChallengeInfo_017_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_017_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_017_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_003",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_017_5 = advanced_modifier({})
function modifier_ChallengeInfo_017_5:IsHidden()return false end
function modifier_ChallengeInfo_017_5:IsDebuff()return true end
function modifier_ChallengeInfo_017_5:IsPurgable()return false end
function modifier_ChallengeInfo_017_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_017_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_017_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_017_5:GetTexture() return "enigma_malefice" end
function modifier_ChallengeInfo_017_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_017_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_017_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_003",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end






------------------------苦难18

modifier_ChallengeInfo_018_1 = advanced_modifier({})
function modifier_ChallengeInfo_018_1:IsHidden()return false end
function modifier_ChallengeInfo_018_1:IsDebuff()return true end
function modifier_ChallengeInfo_018_1:IsPurgable()return false end
function modifier_ChallengeInfo_018_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_018_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_018_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_018_1:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_ChallengeInfo_018_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_018_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_018_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_004",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_018_2 = advanced_modifier({})
function modifier_ChallengeInfo_018_2:IsHidden()return false end
function modifier_ChallengeInfo_018_2:IsDebuff()return true end
function modifier_ChallengeInfo_018_2:IsPurgable()return false end
function modifier_ChallengeInfo_018_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_018_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_018_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_018_2:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_ChallengeInfo_018_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_018_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_018_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_004",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_018_3 = advanced_modifier({})
function modifier_ChallengeInfo_018_3:IsHidden()return false end
function modifier_ChallengeInfo_018_3:IsDebuff()return true end
function modifier_ChallengeInfo_018_3:IsPurgable()return false end
function modifier_ChallengeInfo_018_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_018_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_018_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_018_3:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_ChallengeInfo_018_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_018_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_018_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_004",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_018_4 = advanced_modifier({})
function modifier_ChallengeInfo_018_4:IsHidden()return false end
function modifier_ChallengeInfo_018_4:IsDebuff()return true end
function modifier_ChallengeInfo_018_4:IsPurgable()return false end
function modifier_ChallengeInfo_018_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_018_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_018_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_018_4:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_ChallengeInfo_018_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_018_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_018_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_004",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_018_5 = advanced_modifier({})
function modifier_ChallengeInfo_018_5:IsHidden()return false end
function modifier_ChallengeInfo_018_5:IsDebuff()return true end
function modifier_ChallengeInfo_018_5:IsPurgable()return false end
function modifier_ChallengeInfo_018_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_018_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_018_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_018_5:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_ChallengeInfo_018_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_018_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_018_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_004",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



------------------------苦难19

modifier_ChallengeInfo_019_1 = advanced_modifier({})
function modifier_ChallengeInfo_019_1:IsHidden()return false end
function modifier_ChallengeInfo_019_1:IsDebuff()return true end
function modifier_ChallengeInfo_019_1:IsPurgable()return false end
function modifier_ChallengeInfo_019_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_019_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_019_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_019_1:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_frozen_sigil" end
function modifier_ChallengeInfo_019_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_019_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_019_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_005",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_019_2 = advanced_modifier({})
function modifier_ChallengeInfo_019_2:IsHidden()return false end
function modifier_ChallengeInfo_019_2:IsDebuff()return true end
function modifier_ChallengeInfo_019_2:IsPurgable()return false end
function modifier_ChallengeInfo_019_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_019_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_019_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_019_2:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_frozen_sigil" end
function modifier_ChallengeInfo_019_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_019_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_019_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_005",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_019_3 = advanced_modifier({})
function modifier_ChallengeInfo_019_3:IsHidden()return false end
function modifier_ChallengeInfo_019_3:IsDebuff()return true end
function modifier_ChallengeInfo_019_3:IsPurgable()return false end
function modifier_ChallengeInfo_019_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_019_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_019_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_019_3:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_frozen_sigil" end
function modifier_ChallengeInfo_019_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_019_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_019_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_005",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_019_4 = advanced_modifier({})
function modifier_ChallengeInfo_019_4:IsHidden()return false end
function modifier_ChallengeInfo_019_4:IsDebuff()return true end
function modifier_ChallengeInfo_019_4:IsPurgable()return false end
function modifier_ChallengeInfo_019_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_019_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_019_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_019_4:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_frozen_sigil" end
function modifier_ChallengeInfo_019_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_019_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_019_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_005",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_019_5 = advanced_modifier({})
function modifier_ChallengeInfo_019_5:IsHidden()return false end
function modifier_ChallengeInfo_019_5:IsDebuff()return true end
function modifier_ChallengeInfo_019_5:IsPurgable()return false end
function modifier_ChallengeInfo_019_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_019_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_019_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_019_5:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_frozen_sigil" end
function modifier_ChallengeInfo_019_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_019_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_019_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_005",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end









---------------------------------苦难20
modifier_ChallengeInfo_020_1 = advanced_modifier({})
function modifier_ChallengeInfo_020_1:IsHidden()return false end
function modifier_ChallengeInfo_020_1:IsDebuff()return true end
function modifier_ChallengeInfo_020_1:IsPurgable()return false end
function modifier_ChallengeInfo_020_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_1:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_020_buff", {stack = 20})
	end
    return 1
end
function modifier_ChallengeInfo_020_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_020_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_020_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_020_effect", {stack = 15})
		end
	end
end





modifier_ChallengeInfo_020_2 = advanced_modifier({})
function modifier_ChallengeInfo_020_2:IsHidden()return false end
function modifier_ChallengeInfo_020_2:IsDebuff()return true end
function modifier_ChallengeInfo_020_2:IsPurgable()return false end
function modifier_ChallengeInfo_020_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_2:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_020_buff", {stack = 40})
	end
    return 1
end
function modifier_ChallengeInfo_020_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_020_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_020_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_020_effect", {stack = 25})
		end
	end
end




modifier_ChallengeInfo_020_3 = advanced_modifier({})
function modifier_ChallengeInfo_020_3:IsHidden()return false end
function modifier_ChallengeInfo_020_3:IsDebuff()return true end
function modifier_ChallengeInfo_020_3:IsPurgable()return false end
function modifier_ChallengeInfo_020_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_3:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_020_buff", {stack = 100})
	end
    return 1
end
function modifier_ChallengeInfo_020_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_020_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_020_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_020_effect", {stack = 45})
		end
	end
end




modifier_ChallengeInfo_020_4 = advanced_modifier({})
function modifier_ChallengeInfo_020_4:IsHidden()return false end
function modifier_ChallengeInfo_020_4:IsDebuff()return true end
function modifier_ChallengeInfo_020_4:IsPurgable()return false end
function modifier_ChallengeInfo_020_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_4:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_020_buff", {stack = 170})
	end
    return 1
end
function modifier_ChallengeInfo_020_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_020_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_020_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_020_effect", {stack = 70})
		end
	end
end



modifier_ChallengeInfo_020_5 = advanced_modifier({})
function modifier_ChallengeInfo_020_5:IsHidden()return false end
function modifier_ChallengeInfo_020_5:IsDebuff()return true end
function modifier_ChallengeInfo_020_5:IsPurgable()return false end
function modifier_ChallengeInfo_020_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_5:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_020_buff", {stack = 300})
	end
    return 1
end
function modifier_ChallengeInfo_020_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_020_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_020_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_020_effect", {stack = 100})
		end
	end
end





modifier_ChallengeInfo_020_effect = advanced_modifier({})

function modifier_ChallengeInfo_020_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_020_effect:IsHidden() 			return false end
function modifier_ChallengeInfo_020_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_020_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_effect:GetTexture() return "greevil_natures_attendants" end
function modifier_ChallengeInfo_020_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_020_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_020_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
function modifier_ChallengeInfo_020_effect:AdvancedGetModifierExtraHealthPercentage() 
    return self:GetStackCount()
end




modifier_ChallengeInfo_020_buff = advanced_modifier({})

function modifier_ChallengeInfo_020_buff:IsDebuff()			return false end
function modifier_ChallengeInfo_020_buff:IsHidden() 			return true end
function modifier_ChallengeInfo_020_buff:IsPurgable() 		    return false end
function modifier_ChallengeInfo_020_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_020_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_020_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_020_buff:IsPurgeException() 	return false end

function modifier_ChallengeInfo_020_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_020_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_020_buff:DeclareFunctions() return 
    {MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	} 
end



function modifier_ChallengeInfo_020_buff:GetModifierHealthBonus() 
    return self:GetStackCount()
end





---------------------------苦难21

modifier_ChallengeInfo_021_1 = advanced_modifier({})
function modifier_ChallengeInfo_021_1:IsHidden()return false end
function modifier_ChallengeInfo_021_1:IsDebuff()return true end
function modifier_ChallengeInfo_021_1:IsPurgable()return false end
function modifier_ChallengeInfo_021_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_1:GetTexture() return "arc_warden_flux" end
function modifier_ChallengeInfo_021_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_021_effect", {stack = 1})
	end
    return 1
end

function modifier_ChallengeInfo_021_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_1:Advanced_GetModifier_StatusResistance(keys)
	return -15
end



modifier_ChallengeInfo_021_2 = advanced_modifier({})
function modifier_ChallengeInfo_021_2:IsHidden()return false end
function modifier_ChallengeInfo_021_2:IsDebuff()return true end
function modifier_ChallengeInfo_021_2:IsPurgable()return false end
function modifier_ChallengeInfo_021_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_2:GetTexture() return "arc_warden_flux" end
function modifier_ChallengeInfo_021_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_021_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_021_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_2:Advanced_GetModifier_StatusResistance(keys)
	return -25
end

modifier_ChallengeInfo_021_3 = advanced_modifier({})
function modifier_ChallengeInfo_021_3:IsHidden()return false end
function modifier_ChallengeInfo_021_3:IsDebuff()return true end
function modifier_ChallengeInfo_021_3:IsPurgable()return false end
function modifier_ChallengeInfo_021_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_3:GetTexture() return "arc_warden_flux" end
function modifier_ChallengeInfo_021_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_021_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_021_3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_3:Advanced_GetModifier_StatusResistance(keys)
	return -45
end

modifier_ChallengeInfo_021_4 = advanced_modifier({})
function modifier_ChallengeInfo_021_4:IsHidden()return false end
function modifier_ChallengeInfo_021_4:IsDebuff()return true end
function modifier_ChallengeInfo_021_4:IsPurgable()return false end
function modifier_ChallengeInfo_021_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_4:GetTexture() return "arc_warden_flux" end
function modifier_ChallengeInfo_021_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_021_effect", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_021_4:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_4:Advanced_GetModifier_StatusResistance(keys)
	return -80
end

modifier_ChallengeInfo_021_5 = advanced_modifier({})
function modifier_ChallengeInfo_021_5:IsHidden()return false end
function modifier_ChallengeInfo_021_5:IsDebuff()return true end
function modifier_ChallengeInfo_021_5:IsPurgable()return false end
function modifier_ChallengeInfo_021_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_5:GetTexture() return "arc_warden_flux" end
function modifier_ChallengeInfo_021_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_021_effect", {stack = 6})
	end
    return 1
end
function modifier_ChallengeInfo_021_5:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_5:Advanced_GetModifier_StatusResistance(keys)
	return -200
end



modifier_ChallengeInfo_021_effect = advanced_modifier({})

function modifier_ChallengeInfo_021_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_021_effect:IsHidden() 			return true end
function modifier_ChallengeInfo_021_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_021_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_021_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_021_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_021_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		local parent = self:GetParent()
	end
end
function modifier_ChallengeInfo_021_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
		local parent = self:GetParent()
	end
end

function modifier_ChallengeInfo_021_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_021_effect:Advanced_GetModifier_StatusResistance(keys)
	return self:GetStackCount()
end




---------------------------苦难22

modifier_ChallengeInfo_022_1 = advanced_modifier({})
function modifier_ChallengeInfo_022_1:IsHidden()return false end
function modifier_ChallengeInfo_022_1:IsDebuff()return true end
function modifier_ChallengeInfo_022_1:IsPurgable()return false end
function modifier_ChallengeInfo_022_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_1:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end
function modifier_ChallengeInfo_022_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_022_effect", {stack = 2})
	end
    return 1
end
function modifier_ChallengeInfo_022_1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

		
	end
end

function modifier_ChallengeInfo_022_1:OnIntervalThink(keys)
	local parent = self:GetParent()
	if not parent:IsMoving() then
		parent:SetHealth(parent:GetHealth()*0.98)
	end
end



modifier_ChallengeInfo_022_2 = advanced_modifier({})
function modifier_ChallengeInfo_022_2:IsHidden()return false end
function modifier_ChallengeInfo_022_2:IsDebuff()return true end
function modifier_ChallengeInfo_022_2:IsPurgable()return false end
function modifier_ChallengeInfo_022_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_2:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end
function modifier_ChallengeInfo_022_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_022_effect", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_022_2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

		
	end
end

function modifier_ChallengeInfo_022_2:OnIntervalThink(keys)
	local parent = self:GetParent()
	if not parent:IsMoving() then
		parent:SetHealth(parent:GetHealth()*0.96)
	end
end




modifier_ChallengeInfo_022_3 = advanced_modifier({})
function modifier_ChallengeInfo_022_3:IsHidden()return false end
function modifier_ChallengeInfo_022_3:IsDebuff()return true end
function modifier_ChallengeInfo_022_3:IsPurgable()return false end
function modifier_ChallengeInfo_022_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_3:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end
function modifier_ChallengeInfo_022_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_022_effect", {stack = 6})
	end
    return 1
end
function modifier_ChallengeInfo_022_3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

		
	end
end

function modifier_ChallengeInfo_022_3:OnIntervalThink(keys)
	local parent = self:GetParent()
	if not parent:IsMoving() then
		parent:SetHealth(parent:GetHealth()*0.94)
	end
end


modifier_ChallengeInfo_022_4 = advanced_modifier({})
function modifier_ChallengeInfo_022_4:IsHidden()return false end
function modifier_ChallengeInfo_022_4:IsDebuff()return true end
function modifier_ChallengeInfo_022_4:IsPurgable()return false end
function modifier_ChallengeInfo_022_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_4:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end
function modifier_ChallengeInfo_022_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_022_effect", {stack = 14})
	end
    return 1
end
function modifier_ChallengeInfo_022_4:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

		
	end
end

function modifier_ChallengeInfo_022_4:OnIntervalThink(keys)
	local parent = self:GetParent()
	if not parent:IsMoving() then
		parent:SetHealth(parent:GetHealth()*0.90)
	end
end

modifier_ChallengeInfo_022_5 = advanced_modifier({})
function modifier_ChallengeInfo_022_5:IsHidden()return false end
function modifier_ChallengeInfo_022_5:IsDebuff()return true end
function modifier_ChallengeInfo_022_5:IsPurgable()return false end
function modifier_ChallengeInfo_022_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_5:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end
function modifier_ChallengeInfo_022_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_022_effect", {stack = 25})
	end
    return 1
end
function modifier_ChallengeInfo_022_5:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

		
	end
end

function modifier_ChallengeInfo_022_5:OnIntervalThink(keys)
	local parent = self:GetParent()
	if not parent:IsMoving() then
		parent:SetHealth(parent:GetHealth()*0.82)
	end
end



modifier_ChallengeInfo_022_effect = advanced_modifier({})

function modifier_ChallengeInfo_022_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_022_effect:IsHidden() 			return true end
function modifier_ChallengeInfo_022_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_022_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_022_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_022_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_022_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_022_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_022_effect:AdvancedGetModifierConstantHealthRegen() 
    return self:GetStackCount()
end

function modifier_ChallengeInfo_022_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end




---------------------------苦难23

modifier_ChallengeInfo_023_1 = advanced_modifier({})
function modifier_ChallengeInfo_023_1:IsHidden()return false end
function modifier_ChallengeInfo_023_1:IsDebuff()return true end
function modifier_ChallengeInfo_023_1:IsPurgable()return false end
function modifier_ChallengeInfo_023_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_1:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_023_effect", {stack = 5})
	end
    return 1
end

function modifier_ChallengeInfo_023_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end





function modifier_ChallengeInfo_023_1:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	local ability = keys.ability
	Timers:CreateTimer(0.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		if cooldown>=1 then
			cooldown = cooldown*1.1
			keys.ability:StartCooldown(cooldown)
		end
	end)

end


modifier_ChallengeInfo_023_2 = advanced_modifier({})
function modifier_ChallengeInfo_023_2:IsHidden()return false end
function modifier_ChallengeInfo_023_2:IsDebuff()return true end
function modifier_ChallengeInfo_023_2:IsPurgable()return false end
function modifier_ChallengeInfo_023_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_2:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_023_effect", {stack = 8})
	end
    return 1
end

function modifier_ChallengeInfo_023_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_023_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	local ability = keys.ability
	Timers:CreateTimer(0.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		if cooldown>=1 then
			cooldown = cooldown*1.2
			keys.ability:StartCooldown(cooldown)
		end
	end)

end


modifier_ChallengeInfo_023_3 = advanced_modifier({})
function modifier_ChallengeInfo_023_3:IsHidden()return false end
function modifier_ChallengeInfo_023_3:IsDebuff()return true end
function modifier_ChallengeInfo_023_3:IsPurgable()return false end
function modifier_ChallengeInfo_023_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_3:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_023_effect", {stack = 13})
	end
    return 1
end

function modifier_ChallengeInfo_023_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_023_3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	local ability = keys.ability
	Timers:CreateTimer(0.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		if cooldown>=1 then
			cooldown = cooldown*1.5
			keys.ability:StartCooldown(cooldown)
		end
	end)

end






modifier_ChallengeInfo_023_4 = advanced_modifier({})
function modifier_ChallengeInfo_023_4:IsHidden()return false end
function modifier_ChallengeInfo_023_4:IsDebuff()return true end
function modifier_ChallengeInfo_023_4:IsPurgable()return false end
function modifier_ChallengeInfo_023_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_4:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_023_effect", {stack = 18})
	end
    return 1
end
function modifier_ChallengeInfo_023_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_023_4:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	local ability = keys.ability
	Timers:CreateTimer(0.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		if cooldown>=1 then
			cooldown = cooldown*1.8
			keys.ability:StartCooldown(cooldown)
		end
	end)

end

modifier_ChallengeInfo_023_5 = advanced_modifier({})
function modifier_ChallengeInfo_023_5:IsHidden()return false end
function modifier_ChallengeInfo_023_5:IsDebuff()return true end
function modifier_ChallengeInfo_023_5:IsPurgable()return false end
function modifier_ChallengeInfo_023_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_5:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_023_effect", {stack = 25})
	end
    return 1
end
function modifier_ChallengeInfo_023_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_023_5:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	local ability = keys.ability
	Timers:CreateTimer(0.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local cooldown = ability:GetCooldownTimeRemaining()
		if cooldown>=1 then
			cooldown = cooldown*2.5
			ability:StartCooldown(cooldown)
		end
	end)

end



modifier_ChallengeInfo_023_effect = advanced_modifier({})
function modifier_ChallengeInfo_023_effect:IsHidden()return true end
function modifier_ChallengeInfo_023_effect:IsDebuff()return false end
function modifier_ChallengeInfo_023_effect:IsPurgable()return false end
function modifier_ChallengeInfo_023_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_023_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_023_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_023_effect:GetTexture() return "faceless_void_time_dilation" end
function modifier_ChallengeInfo_023_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_023_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_023_effect:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_023_effect:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	-- if self:GetParent():PassivesDisabled() then
	-- 	return
	-- end
	if  not keys.ability:IsRefreshable() then
		return
	end
	local ability = keys.ability
	Timers:CreateTimer(1, function()
		if ability and not ability:IsNull() then
			local cooldown = ability:GetCooldownTimeRemaining()
			
			if cooldown>=1 then
				local stack = 1-(math.min(self:GetStackCount()*0.001,0.5))
				cooldown = cooldown*stack
				ability:EndCooldown()
				ability:StartCooldown(cooldown)
			end
		end
		
	end)

end





---------------------------苦难24

modifier_ChallengeInfo_024_1 = advanced_modifier({})
function modifier_ChallengeInfo_024_1:IsHidden()return false end
function modifier_ChallengeInfo_024_1:IsDebuff()return true end
function modifier_ChallengeInfo_024_1:IsPurgable()return false end
function modifier_ChallengeInfo_024_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_024_1:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_1:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_024_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_024_effect", {stack = 3})
	end
    return 1
end
function modifier_ChallengeInfo_024_1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_ChallengeInfo_024_1:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(20, true)
		parent:AddNewModifier(parent, nil, "modifier_ChallengeInfo_024_debuff", {duration = 1})
	end
end




modifier_ChallengeInfo_024_2 = advanced_modifier({})
function modifier_ChallengeInfo_024_2:IsHidden()return false end
function modifier_ChallengeInfo_024_2:IsDebuff()return true end
function modifier_ChallengeInfo_024_2:IsPurgable()return false end
function modifier_ChallengeInfo_024_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_024_2:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_2:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_024_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_024_effect", {stack = 5})
	end
    return 1
end
function modifier_ChallengeInfo_024_2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_ChallengeInfo_024_2:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(18, true)
		parent:AddNewModifier(parent, nil, "modifier_ChallengeInfo_024_debuff", {duration = 2})
	end
end




modifier_ChallengeInfo_024_3 = advanced_modifier({})
function modifier_ChallengeInfo_024_3:IsHidden()return false end
function modifier_ChallengeInfo_024_3:IsDebuff()return true end
function modifier_ChallengeInfo_024_3:IsPurgable()return false end
function modifier_ChallengeInfo_024_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_024_3:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_3:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_024_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_024_effect", {stack = 7})
	end
    return 1
end
function modifier_ChallengeInfo_024_3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_ChallengeInfo_024_3:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(15, true)
		parent:AddNewModifier(parent, nil, "modifier_ChallengeInfo_024_debuff", {duration = 3})
	end
end

modifier_ChallengeInfo_024_4 = advanced_modifier({})
function modifier_ChallengeInfo_024_4:IsHidden()return false end
function modifier_ChallengeInfo_024_4:IsDebuff()return true end
function modifier_ChallengeInfo_024_4:IsPurgable()return false end
function modifier_ChallengeInfo_024_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_024_4:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_4:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_024_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_024_effect", {stack = 10})
	end
    return 1
end
function modifier_ChallengeInfo_024_4:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_ChallengeInfo_024_4:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(10, true)
		parent:AddNewModifier(parent, nil, "modifier_ChallengeInfo_024_debuff", {duration = 3})
	end
end

modifier_ChallengeInfo_024_5 = advanced_modifier({})
function modifier_ChallengeInfo_024_5:IsHidden()return false end
function modifier_ChallengeInfo_024_5:IsDebuff()return true end
function modifier_ChallengeInfo_024_5:IsPurgable()return false end
function modifier_ChallengeInfo_024_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_024_5:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_5:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_024_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_024_effect", {stack = 15})
	end
    return 1
end
function modifier_ChallengeInfo_024_5:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_ChallengeInfo_024_5:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(9, true)
		parent:AddNewModifier(parent, nil, "modifier_ChallengeInfo_024_debuff", {duration = 4})
	end
end




modifier_ChallengeInfo_024_effect = advanced_modifier({})


function modifier_ChallengeInfo_024_effect:IsHidden()return true end
function modifier_ChallengeInfo_024_effect:IsDebuff()return false end
function modifier_ChallengeInfo_024_effect:IsPurgable()return false end
function modifier_ChallengeInfo_024_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_024_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_024_effect:OnCreated(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_024_effect:OnRefresh(keys)
	if IsServer() then
		local parent =self:GetParent()
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

-- advanced_modifier
function modifier_ChallengeInfo_024_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_ChallengeInfo_024_effect:Advanced_GetModifier_NegativeDurationGain(keys)
	return self:GetStackCount()
end



modifier_ChallengeInfo_024_debuff = advanced_modifier({})

function modifier_ChallengeInfo_024_debuff:IsDebuff()			return true end
function modifier_ChallengeInfo_024_debuff:IsHidden() 			return false end
function modifier_ChallengeInfo_024_debuff:IsPurgable() 		return false end
function modifier_ChallengeInfo_024_debuff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_024_debuff:IsStunDebuff() return true end
function modifier_ChallengeInfo_024_debuff:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_ChallengeInfo_024_debuff:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_ChallengeInfo_024_debuff:GetTexture() return "blackdeath_fleshheapicon" end
function modifier_ChallengeInfo_024_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_ChallengeInfo_024_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_ChallengeInfo_024_debuff:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end









---------------------------苦难25

modifier_ChallengeInfo_025_1 = advanced_modifier({})
function modifier_ChallengeInfo_025_1:IsHidden()return false end
function modifier_ChallengeInfo_025_1:IsDebuff()return true end
function modifier_ChallengeInfo_025_1:IsPurgable()return false end
function modifier_ChallengeInfo_025_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_1:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_1:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_025_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_025_effect", {stack = 1})
	end
    return 1
end
function modifier_ChallengeInfo_025_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_025_1:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		attacker:EmitSound("Hero_Lion.Voodoo")
		attacker:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_025_debuff", {duration = 1})
    end
end











modifier_ChallengeInfo_025_2 = advanced_modifier({})
function modifier_ChallengeInfo_025_2:IsHidden()return false end
function modifier_ChallengeInfo_025_2:IsDebuff()return true end
function modifier_ChallengeInfo_025_2:IsPurgable()return false end
function modifier_ChallengeInfo_025_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_2:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_2:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_025_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_025_effect", {stack = 15})
	end
    return 1
end
function modifier_ChallengeInfo_025_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_025_2:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		attacker:EmitSound("Hero_Lion.Voodoo")
		attacker:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_025_debuff", {duration =1.5})
    end
end



modifier_ChallengeInfo_025_3 = advanced_modifier({})
function modifier_ChallengeInfo_025_3:IsHidden()return false end
function modifier_ChallengeInfo_025_3:IsDebuff()return true end
function modifier_ChallengeInfo_025_3:IsPurgable()return false end
function modifier_ChallengeInfo_025_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_3:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_3:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_025_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_025_effect", {stack = 20})
	end
    return 1
end
function modifier_ChallengeInfo_025_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_025_3:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		attacker:EmitSound("Hero_Lion.Voodoo")
		attacker:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_025_debuff", {duration = 3})
    end
end





modifier_ChallengeInfo_025_4 = advanced_modifier({})
function modifier_ChallengeInfo_025_4:IsHidden()return false end
function modifier_ChallengeInfo_025_4:IsDebuff()return true end
function modifier_ChallengeInfo_025_4:IsPurgable()return false end
function modifier_ChallengeInfo_025_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_4:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_4:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_025_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_025_effect", {stack = 30})
	end
    return 1
end
function modifier_ChallengeInfo_025_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_025_4:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		attacker:EmitSound("Hero_Lion.Voodoo")
		attacker:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_025_debuff", {duration = 5})
    end
end



modifier_ChallengeInfo_025_5 = advanced_modifier({})
function modifier_ChallengeInfo_025_5:IsHidden()return false end
function modifier_ChallengeInfo_025_5:IsDebuff()return true end
function modifier_ChallengeInfo_025_5:IsPurgable()return false end
function modifier_ChallengeInfo_025_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_5:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_5:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_025_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_025_effect", {stack = 50})
	end
    return 1
end
function modifier_ChallengeInfo_025_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_025_5:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end
		attacker:EmitSound("Hero_Lion.Voodoo")
		attacker:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_025_debuff", {duration = 8})
    end
end



modifier_ChallengeInfo_025_effect = advanced_modifier({})
function modifier_ChallengeInfo_025_effect:IsHidden()return false end
function modifier_ChallengeInfo_025_effect:IsDebuff()return false end
function modifier_ChallengeInfo_025_effect:IsPurgable()return false end
function modifier_ChallengeInfo_025_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_025_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_025_effect:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_effect:OnCreated(keys)
	if IsServer() then
		self.stack = keys.stack
		self:SetStackCount(self.stack/10)
	end
end
function modifier_ChallengeInfo_025_effect:OnRefresh(keys)
	if IsServer() then
		self.stack = math.min(self.stack + keys.stack,500)
		self:SetStackCount(self.stack/10)
	end
end


function modifier_ChallengeInfo_025_effect:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_025_effect:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if keys.unit ~= parent  or parent:IsIllusion() then 
		return 
	end
	-- if parent:PassivesDisabled() then
	-- 	return
	-- end

	if keys.ability:GetCooldown(keys.ability:GetLevel())<=3 then
		return
	end

	local stack = self.stack*0.1
	-- print(stack)
	if stack>=RandomInt(1, 100) then

		local enemies = FindUnitsInRadius(
						parent:GetTeamNumber(),	-- int, your team number
						parent:GetAbsOrigin(),	-- point, center point
						nil,	-- handle, cacheUnit. (not known)
						1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
						0,	-- int, flag filter
						0,	-- int, order filter
						false	-- bool, can grow cache
					)
					-- print(#enemies)
		for _, unit in ipairs(enemies) do
			if not unit:IsMagicImmune() then
				local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(parent, nil, "modifier_ChallengeInfo_025_debuff2", {duration = 3*StatusResistance})
				unit:EmitSound("Hero_Lion.Voodoo")
				break
			end
		end
			
	end
end


modifier_ChallengeInfo_025_debuff = advanced_modifier({})


function modifier_ChallengeInfo_025_debuff:IsHidden()	return false end
function modifier_ChallengeInfo_025_debuff:IsDebuff()	return true end
function modifier_ChallengeInfo_025_debuff:IsPurgable()	return false end
function modifier_ChallengeInfo_025_debuff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_025_debuff:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_debuff:OnCreated( kv )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_ChallengeInfo_025_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end


function modifier_ChallengeInfo_025_debuff:GetModifierModelChange()	return "models/props_gameplay/frog.vmdl" end

function modifier_ChallengeInfo_025_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end


function modifier_ChallengeInfo_025_debuff:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end



modifier_ChallengeInfo_025_debuff2 = advanced_modifier({})


function modifier_ChallengeInfo_025_debuff2:IsHidden()	return false end
function modifier_ChallengeInfo_025_debuff2:IsDebuff()	return true end
function modifier_ChallengeInfo_025_debuff2:IsPurgable()	return true end
function modifier_ChallengeInfo_025_debuff2:IsPurgeException() 	return true end
function modifier_ChallengeInfo_025_debuff2:GetTexture() return "lion_voodoo" end
function modifier_ChallengeInfo_025_debuff2:OnCreated( kv )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_ChallengeInfo_025_debuff2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end


function modifier_ChallengeInfo_025_debuff2:GetModifierModelChange()	return "models/props_gameplay/frog.vmdl" end

function modifier_ChallengeInfo_025_debuff2:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end


function modifier_ChallengeInfo_025_debuff2:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end









---------------------------苦难26


modifier_ChallengeInfo_026_1 = advanced_modifier({})
function modifier_ChallengeInfo_026_1:IsHidden()return false end
function modifier_ChallengeInfo_026_1:IsDebuff()return true end
function modifier_ChallengeInfo_026_1:IsPurgable()return false end
function modifier_ChallengeInfo_026_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_1:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_1:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_026_1:OnChallengeWaveEnd()
	
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_026_effect", {stack = 2})
	end

	if self.caster and not self.caster:IsNull() then
		self.caster:RemoveModifierByName("modifier_thinker_INVULNERABLE")
		-- self.caster:Kill(nil, self.caster)
	end
	-- print(self.caster:IsAlive())
	-- print("111111111111")

	-- UTIL_Remove(self.caster)
    return 1
end
function modifier_ChallengeInfo_026_1:OnCreated(keys)
	if IsServer() then
		self:SetDuration(RandomInt(3, 10), true)
		self:StartIntervalThink(0.1)
		-- self.caster = self:GetCaster()
	end
end

function modifier_ChallengeInfo_026_1:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(20, true)
		local pos =	parent:GetAbsOrigin()  + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local newPos 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*200
		local casterPOS 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*500
		self.caster:SetAbsOrigin(casterPOS)
		CreateModifierThinker(
			self.caster, -- player source
			nil, -- ability source
			"modifier_ChallengeInfo_026_damage", -- modifier name
			{damage_index = 0.1}, -- kv
			newPos,
			self.caster:GetTeamNumber(),
			false
		)
	end
end




modifier_ChallengeInfo_026_2 = advanced_modifier({})
function modifier_ChallengeInfo_026_2:IsHidden()return false end
function modifier_ChallengeInfo_026_2:IsDebuff()return true end
function modifier_ChallengeInfo_026_2:IsPurgable()return false end
function modifier_ChallengeInfo_026_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_2:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_2:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_026_2:OnChallengeWaveEnd()
	-- UTIL_Remove(self.caster)
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_026_effect", {stack = 4})
	end
	if self.caster and not self.caster:IsNull() then
		self.caster:RemoveModifierByName("modifier_thinker_INVULNERABLE")
		-- self.caster:Kill(nil, self.caster)
	end
	-- print(self.caster:IsAlive())
	-- print("111111111111")

    return 1
end
function modifier_ChallengeInfo_026_2:OnCreated(keys)
	if IsServer() then
		self:SetDuration(RandomInt(3, 10), true)
		self:StartIntervalThink(0.1)
		-- self.caster = self:GetCaster()
	end
end

function modifier_ChallengeInfo_026_2:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(17, true)
		local pos =	parent:GetAbsOrigin()  + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local newPos 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*200
		local casterPOS 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*500
		self.caster:SetAbsOrigin(casterPOS)
		CreateModifierThinker(
			self.caster, -- player source
			nil, -- ability source
			"modifier_ChallengeInfo_026_damage", -- modifier name
			{damage_index=0.2}, -- kv
			newPos,
			self.caster:GetTeamNumber(),
			false
		)
	end
end





modifier_ChallengeInfo_026_3 = advanced_modifier({})
function modifier_ChallengeInfo_026_3:IsHidden()return false end
function modifier_ChallengeInfo_026_3:IsDebuff()return true end
function modifier_ChallengeInfo_026_3:IsPurgable()return false end
function modifier_ChallengeInfo_026_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_3:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_3:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_026_3:OnChallengeWaveEnd()
	-- UTIL_Remove(self.caster)
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_026_effect", {stack = 6})
	end
	if self.caster and not self.caster:IsNull() then
		self.caster:RemoveModifierByName("modifier_thinker_INVULNERABLE")
		-- self.caster:Kill(nil, self.caster)
	end
	-- print(self.caster:IsAlive())
	-- print("111111111111")

    return 1
end
function modifier_ChallengeInfo_026_3:OnCreated(keys)
	if IsServer() then
		self:SetDuration(RandomInt(3, 10), true)
		self:StartIntervalThink(0.1)
		-- self.caster = self:GetCaster()
	end
end

function modifier_ChallengeInfo_026_3:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(14, true)
		local pos =	parent:GetAbsOrigin()  + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local newPos 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*200
		local casterPOS 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*500
		self.caster:SetAbsOrigin(casterPOS)
		CreateModifierThinker(
			self.caster, -- player source
			nil, -- ability source
			"modifier_ChallengeInfo_026_damage", -- modifier name
			{damage_index=0.3}, -- kv
			newPos,
			self.caster:GetTeamNumber(),
			false
		)
	end
end




modifier_ChallengeInfo_026_4 = advanced_modifier({})
function modifier_ChallengeInfo_026_4:IsHidden()return false end
function modifier_ChallengeInfo_026_4:IsDebuff()return true end
function modifier_ChallengeInfo_026_4:IsPurgable()return false end
function modifier_ChallengeInfo_026_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_4:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_4:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_026_4:OnChallengeWaveEnd()
	-- UTIL_Remove(self.caster)
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_026_effect", {stack = 8})
	end
	if self.caster and not self.caster:IsNull() then
		self.caster:RemoveModifierByName("modifier_thinker_INVULNERABLE")
		-- self.caster:Kill(nil, self.caster)
	end
	-- print(self.caster:IsAlive())
	-- print("111111111111")


    return 1
end
function modifier_ChallengeInfo_026_4:OnCreated(keys)
	if IsServer() then
		self:SetDuration(RandomInt(3, 10), true)
		self:StartIntervalThink(0.1)
		-- self.caster = self:GetCaster()
	end
end

function modifier_ChallengeInfo_026_4:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(10, true)
		local pos =	parent:GetAbsOrigin()  + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local newPos 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*200
		local casterPOS 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*500
		self.caster:SetAbsOrigin(casterPOS)
		CreateModifierThinker(
			self.caster, -- player source
			nil, -- ability source
			"modifier_ChallengeInfo_026_damage", -- modifier name
			{damage_index=0.5}, -- kv
			newPos,
			self.caster:GetTeamNumber(),
			false
		)
	end
end




modifier_ChallengeInfo_026_5 = advanced_modifier({})
function modifier_ChallengeInfo_026_5:IsHidden()return false end
function modifier_ChallengeInfo_026_5:IsDebuff()return true end
function modifier_ChallengeInfo_026_5:IsPurgable()return false end
function modifier_ChallengeInfo_026_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_5:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_5:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_026_5:OnChallengeWaveEnd()
	-- UTIL_Remove(self.caster)
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_026_effect", {stack = 10})
	end
	if self.caster and not self.caster:IsNull() then
		self.caster:RemoveModifierByName("modifier_thinker_INVULNERABLE")
		-- self.caster:Kill(nil, self.caster)
	end
	-- print(self.caster:IsAlive())
	-- print("111111111111")

    return 1
end
function modifier_ChallengeInfo_026_5:OnCreated(keys)
	if IsServer() then
		self:SetDuration(RandomInt(3, 10), true)
		self:StartIntervalThink(0.1)
		-- self.caster = self:GetCaster()
	end
end

function modifier_ChallengeInfo_026_5:OnIntervalThink(table)
	local parent = self:GetParent()

	if self:GetRemainingTime()<0  then
		self:SetDuration(7, true)
		local pos =	parent:GetAbsOrigin()  + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local newPos 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*200
		local casterPOS 	= parent:GetAbsOrigin()+(parent:GetAbsOrigin() - pos):Normalized()*500
		self.caster:SetAbsOrigin(casterPOS)
		CreateModifierThinker(
			self.caster, -- player source
			nil, -- ability source
			"modifier_ChallengeInfo_026_damage", -- modifier name
			{damage_index=0.7}, -- kv
			newPos,
			self.caster:GetTeamNumber(),
			false
		)
	end
end




modifier_ChallengeInfo_026_damage = advanced_modifier({})

function modifier_ChallengeInfo_026_damage:IsHidden()	return true end


function modifier_ChallengeInfo_026_damage:OnCreated( kv )
	if IsServer() then
		-- references
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		self.radius = 300
		self.distance = 1200
		self.speed = 300
	
		
		self.interval = 0.3
		self.duration = 4
		self.damage_index = kv.damage_index


		-- variables
		self.fallen = false
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = nil, --Optional.
		}

		self.effect_unit = {}


		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end



function modifier_ChallengeInfo_026_damage:OnDestroy( kv )
	if IsServer() then
		-- add vision
	
		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ChallengeInfo_026_damage:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		-- move & damages
		self:Move_Burn()
	end
end

function modifier_ChallengeInfo_026_damage:Burn()
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			self.damageTable.victim = enemy
			self.damageTable.damage = enemy:GetMaxHealth()*self.damage_index 
			ApplyDamage( self.damageTable )
		end
	


	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ChallengeInfo_026_damage:Move_Burn()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:SafeDestroy()
		return
	end
end

function modifier_ChallengeInfo_026_damage:PlayEffects1()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_ChallengeInfo_026_damage:PlayEffects2()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end







modifier_ChallengeInfo_026_effect = advanced_modifier({})


function modifier_ChallengeInfo_026_effect:IsHidden()return false end
function modifier_ChallengeInfo_026_effect:IsDebuff()return false end
function modifier_ChallengeInfo_026_effect:IsPurgable()return false end
function modifier_ChallengeInfo_026_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_026_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_026_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_026_effect:GetTexture() return "invoker_chaos_meteor" end
function modifier_ChallengeInfo_026_effect:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_026_effect:OnRefresh(keys)
	if IsServer() then
	
		self:SetStackCount(math.min(self:GetStackCount() + keys.stack,60))

	end
end


function modifier_ChallengeInfo_026_effect:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	
		

	}
end


function modifier_ChallengeInfo_026_effect:GetModifierMagicalResistanceBonus()	return self:GetStackCount() end


















--------苦难27


modifier_ChallengeInfo_027_1 = advanced_modifier({})
function modifier_ChallengeInfo_027_1:IsHidden()return false end
function modifier_ChallengeInfo_027_1:IsDebuff()return true end
function modifier_ChallengeInfo_027_1:IsPurgable()return false end
function modifier_ChallengeInfo_027_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_027_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_027_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_027_1:GetTexture() return "abyssal_underlord_atrophy_aura" end
function modifier_ChallengeInfo_027_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_027_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_027_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_006",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_027_2 = advanced_modifier({})
function modifier_ChallengeInfo_027_2:IsHidden()return false end
function modifier_ChallengeInfo_027_2:IsDebuff()return true end
function modifier_ChallengeInfo_027_2:IsPurgable()return false end
function modifier_ChallengeInfo_027_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_027_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_027_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_027_2:GetTexture() return "abyssal_underlord_atrophy_aura" end
function modifier_ChallengeInfo_027_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_027_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_027_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_006",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_027_3 = advanced_modifier({})
function modifier_ChallengeInfo_027_3:IsHidden()return false end
function modifier_ChallengeInfo_027_3:IsDebuff()return true end
function modifier_ChallengeInfo_027_3:IsPurgable()return false end
function modifier_ChallengeInfo_027_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_027_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_027_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_027_3:GetTexture() return "abyssal_underlord_atrophy_aura" end
function modifier_ChallengeInfo_027_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_027_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_027_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_006",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_027_4 = advanced_modifier({})
function modifier_ChallengeInfo_027_4:IsHidden()return false end
function modifier_ChallengeInfo_027_4:IsDebuff()return true end
function modifier_ChallengeInfo_027_4:IsPurgable()return false end
function modifier_ChallengeInfo_027_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_027_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_027_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_027_4:GetTexture() return "abyssal_underlord_atrophy_aura" end
function modifier_ChallengeInfo_027_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_027_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_027_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_006",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_027_5 = advanced_modifier({})
function modifier_ChallengeInfo_027_5:IsHidden()return false end
function modifier_ChallengeInfo_027_5:IsDebuff()return true end
function modifier_ChallengeInfo_027_5:IsPurgable()return false end
function modifier_ChallengeInfo_027_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_027_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_027_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_027_5:GetTexture() return "abyssal_underlord_atrophy_aura" end
function modifier_ChallengeInfo_027_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_027_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_027_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_006",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end








--------苦难28


modifier_ChallengeInfo_028_1 = advanced_modifier({})
function modifier_ChallengeInfo_028_1:IsHidden()return false end
function modifier_ChallengeInfo_028_1:IsDebuff()return true end
function modifier_ChallengeInfo_028_1:IsPurgable()return false end
function modifier_ChallengeInfo_028_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_028_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_028_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_028_1:GetTexture() return "luna/ti9_immortal_weapon/luna_moon_glaive_immortal" end
function modifier_ChallengeInfo_028_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_028_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_028_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_007",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_028_2 = advanced_modifier({})
function modifier_ChallengeInfo_028_2:IsHidden()return false end
function modifier_ChallengeInfo_028_2:IsDebuff()return true end
function modifier_ChallengeInfo_028_2:IsPurgable()return false end
function modifier_ChallengeInfo_028_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_028_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_028_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_028_2:GetTexture() return "luna/ti9_immortal_weapon/luna_moon_glaive_immortal" end
function modifier_ChallengeInfo_028_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_028_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_028_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_007",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_028_3 = advanced_modifier({})
function modifier_ChallengeInfo_028_3:IsHidden()return false end
function modifier_ChallengeInfo_028_3:IsDebuff()return true end
function modifier_ChallengeInfo_028_3:IsPurgable()return false end
function modifier_ChallengeInfo_028_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_028_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_028_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_028_3:GetTexture() return "luna/ti9_immortal_weapon/luna_moon_glaive_immortal" end
function modifier_ChallengeInfo_028_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_028_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_028_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_007",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_028_4 = advanced_modifier({})
function modifier_ChallengeInfo_028_4:IsHidden()return false end
function modifier_ChallengeInfo_028_4:IsDebuff()return true end
function modifier_ChallengeInfo_028_4:IsPurgable()return false end
function modifier_ChallengeInfo_028_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_028_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_028_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_028_4:GetTexture() return "luna/ti9_immortal_weapon/luna_moon_glaive_immortal" end
function modifier_ChallengeInfo_028_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_028_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_028_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_007",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,

						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_028_5 = advanced_modifier({})
function modifier_ChallengeInfo_028_5:IsHidden()return false end
function modifier_ChallengeInfo_028_5:IsDebuff()return true end
function modifier_ChallengeInfo_028_5:IsPurgable()return false end
function modifier_ChallengeInfo_028_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_028_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_028_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_028_5:GetTexture() return "luna/ti9_immortal_weapon/luna_moon_glaive_immortal" end
function modifier_ChallengeInfo_028_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_028_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_028_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_007",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end






---------------------------------苦难29

modifier_ChallengeInfo_029_1 = advanced_modifier({})
function modifier_ChallengeInfo_029_1:IsHidden()return false end
function modifier_ChallengeInfo_029_1:IsDebuff()return true end
function modifier_ChallengeInfo_029_1:IsPurgable()return false end
function modifier_ChallengeInfo_029_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_029_1:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 1})
    return 1
end
function modifier_ChallengeInfo_029_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_029_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_029_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_029_effect", {stack = 2})
		end
	end
end


modifier_ChallengeInfo_029_2 = advanced_modifier({})
function modifier_ChallengeInfo_029_2:IsHidden()return false end
function modifier_ChallengeInfo_029_2:IsDebuff()return true end
function modifier_ChallengeInfo_029_2:IsPurgable()return false end
function modifier_ChallengeInfo_029_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_029_2:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 2})
    return 1
end
function modifier_ChallengeInfo_029_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_029_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_029_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_029_effect", {stack = 4})
		end
	end
end




modifier_ChallengeInfo_029_3 = advanced_modifier({})
function modifier_ChallengeInfo_029_3:IsHidden()return false end
function modifier_ChallengeInfo_029_3:IsDebuff()return true end
function modifier_ChallengeInfo_029_3:IsPurgable()return false end
function modifier_ChallengeInfo_029_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_029_3:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 3})
    return 1
end
function modifier_ChallengeInfo_029_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_029_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_029_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_029_effect", {stack = 7})
		end
	end
end




modifier_ChallengeInfo_029_4 = advanced_modifier({})
function modifier_ChallengeInfo_029_4:IsHidden()return false end
function modifier_ChallengeInfo_029_4:IsDebuff()return true end
function modifier_ChallengeInfo_029_4:IsPurgable()return false end
function modifier_ChallengeInfo_029_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_029_4:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
	local heroes = GetAllRealHeroes()
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 4})
    return 1
end
function modifier_ChallengeInfo_029_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_029_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_029_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_029_effect", {stack = 12})
		end
	end
end










modifier_ChallengeInfo_029_5 = advanced_modifier({})
function modifier_ChallengeInfo_029_5:IsHidden()return false end
function modifier_ChallengeInfo_029_5:IsDebuff()return true end
function modifier_ChallengeInfo_029_5:IsPurgable()return false end
function modifier_ChallengeInfo_029_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_029_5:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
	local heroes = GetAllRealHeroes()
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 6})
    return 1
end
function modifier_ChallengeInfo_029_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_029_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_029_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_029_effect", {stack = 18})
		end
	end
end



modifier_ChallengeInfo_029_buff = advanced_modifier({})

function modifier_ChallengeInfo_029_buff:IsDebuff()			return false end
function modifier_ChallengeInfo_029_buff:IsHidden() 			return self:GetStackCount()<1 end
function modifier_ChallengeInfo_029_buff:IsPurgable() 		    return false end
function modifier_ChallengeInfo_029_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_029_buff:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_buff:OnCreated(keys)
	if IsServer() then
		self.stack = keys.stack
		-- self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_029_buff:OnRefresh(keys)
	if IsServer() then
		self.stack = self.stack + keys.stack
		-- self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_029_buff:OnWaveStart()
	local stack = (self.stack- 1 )/2
	self:SetStackCount(1+stack)
end


function modifier_ChallengeInfo_029_buff:Advanced_GetModifierIncomingDamage_Percentage(keys) 
	if IsClient() then
		return
	end
	if keys.damage<=0 then
		return 0 
	end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_SPELL  then
		return 0 
	end
    if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return -100
	end

	return 0 
end


function modifier_ChallengeInfo_029_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_ChallengeInfo_029_effect = advanced_modifier({})

function modifier_ChallengeInfo_029_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_029_effect:IsHidden() 			return false end
function modifier_ChallengeInfo_029_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_029_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_029_effect:GetTexture() return "antimage_spell_shield" end
function modifier_ChallengeInfo_029_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_029_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_029_effect:Advanced_GetModifierIncomingDamage_Percentage(keys) 
	if keys.damage<=0 then
		return 0 
	end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_SPELL  then
		return 0 
	end
    if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return -100
	end
	self:SafeDestroy()
	return 0 
end

function modifier_ChallengeInfo_029_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





---------------------------------苦难30

modifier_ChallengeInfo_030_1 = advanced_modifier({})
function modifier_ChallengeInfo_030_1:IsHidden()return false end
function modifier_ChallengeInfo_030_1:IsDebuff()return true end
function modifier_ChallengeInfo_030_1:IsPurgable()return false end
function modifier_ChallengeInfo_030_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_1:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
    return 1
end
function modifier_ChallengeInfo_030_1:OnCreated()
	if IsServer() then
		local hero = self:GetParent()
		local ability = hero:FindAbilityByName("Default_Move")

		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_bonus", {stack = 4})
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_effect", {stack = 5})
	end
end

modifier_ChallengeInfo_030_2 = advanced_modifier({})
function modifier_ChallengeInfo_030_2:IsHidden()return false end
function modifier_ChallengeInfo_030_2:IsDebuff()return true end
function modifier_ChallengeInfo_030_2:IsPurgable()return false end
function modifier_ChallengeInfo_030_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_2:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end

    return 1
end
function modifier_ChallengeInfo_030_2:OnCreated()
	if IsServer() then
		local hero = self:GetParent()
		local ability = hero:FindAbilityByName("Default_Move")

		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_bonus", {stack = 6})
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_effect", {stack = 10})
	end
end


modifier_ChallengeInfo_030_3 = advanced_modifier({})
function modifier_ChallengeInfo_030_3:IsHidden()return false end
function modifier_ChallengeInfo_030_3:IsDebuff()return true end
function modifier_ChallengeInfo_030_3:IsPurgable()return false end
function modifier_ChallengeInfo_030_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_3:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end

    return 1
end
function modifier_ChallengeInfo_030_3:OnCreated()
	if IsServer() then
		local hero = self:GetParent()
		local ability = hero:FindAbilityByName("Default_Move")

		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_bonus", {stack = 8})
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_effect", {stack = 15})
	end
end


modifier_ChallengeInfo_030_4 = advanced_modifier({})
function modifier_ChallengeInfo_030_4:IsHidden()return false end
function modifier_ChallengeInfo_030_4:IsDebuff()return true end
function modifier_ChallengeInfo_030_4:IsPurgable()return false end
function modifier_ChallengeInfo_030_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_4:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end

    return 1
end
function modifier_ChallengeInfo_030_4:OnCreated()
	if IsServer() then
		local hero = self:GetParent()
		local ability = hero:FindAbilityByName("Default_Move")

		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_bonus", {stack = 10})
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_effect", {stack = 25})
	end
end








modifier_ChallengeInfo_030_5 = advanced_modifier({})
function modifier_ChallengeInfo_030_5:IsHidden()return false end
function modifier_ChallengeInfo_030_5:IsDebuff()return true end
function modifier_ChallengeInfo_030_5:IsPurgable()return false end
function modifier_ChallengeInfo_030_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_5:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_029_buff", {stack = 1})
    return 1
end
function modifier_ChallengeInfo_030_5:OnCreated()
	if IsServer() then
		local hero = self:GetParent()
		local ability = hero:FindAbilityByName("Default_Move")

		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_bonus", {stack = 13})
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_effect", {stack = 40})
	end
end




modifier_ChallengeInfo_030_bonus = advanced_modifier({})
function modifier_ChallengeInfo_030_bonus:IsHidden()return false end
function modifier_ChallengeInfo_030_bonus:IsDebuff()return false end
function modifier_ChallengeInfo_030_bonus:IsPurgable()return false end
function modifier_ChallengeInfo_030_bonus:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_bonus:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_bonus:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_bonus:OnWaveEnd()
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_030_self_buff", {stack = self:GetStackCount()})

    if _G.GAME_ROUND >= (_G.GAME_END_WAVE-1) then
		self:SafeDestroy()
	end
    return 1
end

function modifier_ChallengeInfo_030_bonus:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end


function modifier_ChallengeInfo_030_bonus:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_030_bonus:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end



modifier_ChallengeInfo_030_effect = advanced_modifier({})
function modifier_ChallengeInfo_030_effect:IsHidden()return false end
function modifier_ChallengeInfo_030_effect:IsDebuff()return true end
function modifier_ChallengeInfo_030_effect:IsPurgable()return false end
function modifier_ChallengeInfo_030_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_effect:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_effect:OnWaveEnd()

	
    if _G.GAME_ROUND >= (_G.GAME_END_WAVE-1) then
		self:SafeDestroy()
	end
    return 1
end

function modifier_ChallengeInfo_030_effect:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end

function modifier_ChallengeInfo_030_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_030_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_030_effect:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_030_effect:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_030_enemy_buff", {stack = self:GetStackCount()})
		end
	end
end









modifier_ChallengeInfo_030_self_buff = advanced_modifier({})
function modifier_ChallengeInfo_030_self_buff:IsHidden()return false end
function modifier_ChallengeInfo_030_self_buff:IsDebuff()return false end
function modifier_ChallengeInfo_030_self_buff:IsPurgable()return false end
function modifier_ChallengeInfo_030_self_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_self_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_self_buff:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_self_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_self_buff:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_030_self_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_030_self_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_030_self_buff:GetModifierBonusStats_Agility()   return self:GetStackCount()*0.1 end
function modifier_ChallengeInfo_030_self_buff:GetModifierBonusStats_Intellect() return self:GetStackCount()*0.1 end
function modifier_ChallengeInfo_030_self_buff:GetModifierBonusStats_Strength()  return self:GetStackCount()*0.1 end



modifier_ChallengeInfo_030_enemy_buff = advanced_modifier({})
function modifier_ChallengeInfo_030_enemy_buff:IsHidden()return false end
function modifier_ChallengeInfo_030_enemy_buff:IsDebuff()return false end
function modifier_ChallengeInfo_030_enemy_buff:IsPurgable()return false end
function modifier_ChallengeInfo_030_enemy_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_030_enemy_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_030_enemy_buff:GetTexture() return "elder_titan_ancestral_spirit" end
function modifier_ChallengeInfo_030_enemy_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_030_enemy_buff:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_030_enemy_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_030_enemy_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_ChallengeInfo_030_enemy_buff:Advanced_GetModifier_StatusResistance(keys)
	return self:GetStackCount()
end










