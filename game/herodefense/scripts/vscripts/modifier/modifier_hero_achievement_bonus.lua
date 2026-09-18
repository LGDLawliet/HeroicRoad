require("internal/timers")
-- LinkLuaModifier("modifier_fakeDeathDebug", "modifier/modifier_fakeDeathDebug", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier( "modifier_melee_attack_effect", "modifier/modifier_hero_achievement_bonus", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
modifier_hero_achievement_bonus = modifier_hero_achievement_bonus or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hero_achievement_bonus:IsHidden()return true end
function modifier_hero_achievement_bonus:IsDebuff()return false end
function modifier_hero_achievement_bonus:IsStunDebuff()return false end
function modifier_hero_achievement_bonus:IsPurgable()return false end
function modifier_hero_achievement_bonus:IsPurgeException() 	return false end
function modifier_hero_achievement_bonus:RemoveOnDeath() return false end
function modifier_hero_achievement_bonus:OnCreated(keys)
    self.bonus_summon_intensity = 0
    if IsServer() then
        -- self:SetHasCustomTransmitterData(true)
    end
end

-- 奖励一览
function modifier_hero_achievement_bonus:InitSummonAchievement()
    self.bonus_summon_intensity = 2
    -- self:SetHasCustomTransmitterData(true)
end

-- function modifier_hero_achievement_bonus:AddCustomTransmitterData( )
-- 	return
-- 	{
-- 		bonus_summon_intensity = self.bonus_summon_intensity
-- 	}
-- end

-- function modifier_hero_achievement_bonus:HandleCustomTransmitterData( data )
-- 	self.bonus_summon_intensity = data.bonus_summon_intensity
-- end

-- advanced_modifier
function modifier_hero_achievement_bonus:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_hero_achievement_bonus:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity or 0
end
