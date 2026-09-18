-- 仅作为自定义数据传输使用

require("internal/timers")
-- LinkLuaModifier("modifier_fakeDeathDebug", "modifier/modifier_fakeDeathDebug", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier( "modifier_melee_attack_effect", "modifier/modifier_hero_custom_data_manager", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
modifier_hero_custom_data_manager = modifier_hero_custom_data_manager or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hero_custom_data_manager:IsHidden()return true end
function modifier_hero_custom_data_manager:IsDebuff()return false end
function modifier_hero_custom_data_manager:IsStunDebuff()return false end
function modifier_hero_custom_data_manager:IsPurgable()return false end
function modifier_hero_custom_data_manager:IsPurgeException() 	return false end
function modifier_hero_custom_data_manager:RemoveOnDeath() return false end
function modifier_hero_custom_data_manager:OnCreated(keys)
    if IsServer() then
        self.parent = self:GetParent()
        local nPlayerID = self.parent:GetPlayerOwnerID()
        self.steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        self.kill = 0
        self.summon = 0
        self:StartIntervalThink(60)

        self.phoenixBuyBackCount = 0
        self.gold_carry = true

        self.customData = {}
        self.customDataWithValue = {}
    end
end

function modifier_hero_custom_data_manager:PhoenixBuyBack()
    self.phoenixBuyBackCount = self.phoenixBuyBackCount + 1
    if self.phoenixBuyBackCount>=50 then
        customDataManager:ModifySingleCustomData(self.steamID,"Nirvana_1",1,nil) 
        self.phoenixBuyBackCount = 0
    end
end

function modifier_hero_custom_data_manager:GreedLv25()    self.Advanced_Greevils_Greed_lv25 = true end
-- function modifier_hero_custom_data_manager:TuskTalent1()    self.tuskTalent_1 = true end
-- function modifier_hero_custom_data_manager:TuskTalent2()    self.tuskTalent_2 = true end
-- function modifier_hero_custom_data_manager:SvenTalent1()    self.svenTalent_1 = true end
-- function modifier_hero_custom_data_manager:TinkerTalent2()    self.tinkerTalent_2 = true end
-- function modifier_hero_custom_data_manager:bounty_hunterTalent2()    self.bounty_hunterTalent_2 = true end
-- function modifier_hero_custom_data_manager:razorTalent2()    self.razorTalent_2 = true end
-- function modifier_hero_custom_data_manager:abyssal_underlordTalent2()    self.abyssal_underlordTalent_2 = true end

-- function modifier_hero_custom_data_manager:TuskTalent1()    self.tuskTalent_1 = true end
-- function modifier_hero_custom_data_manager:TuskTalent2()    self.tuskTalent_2 = true end
function modifier_hero_custom_data_manager:SvenTalent1()    self.svenTalent_1 = true end
-- function modifier_hero_custom_data_manager:TinkerTalent2()    self.tinkerTalent_2 = true end
-- function modifier_hero_custom_data_manager:bounty_hunterTalent2()    self.bounty_hunterTalent_2 = true end
-- function modifier_hero_custom_data_manager:razorTalent2()    self.razorTalent_2 = true end
-- function modifier_hero_custom_data_manager:abyssal_underlordTalent2()    self.abyssal_underlordTalent_2 = true end

function modifier_hero_custom_data_manager:UnlockCustomData(name)
    table.insert(self.customData,name)
end
function modifier_hero_custom_data_manager:UnlockCustomDataWithValue(name,value)
    table.insert(self.customDataWithValue,{name=name,value=value})
end





function modifier_hero_custom_data_manager:OnWaveStart()
    local gold = self.parent:GetGold()
    if gold>=500 then
        self.gold_carry = false
    end
end






function modifier_hero_custom_data_manager:OnGameSettlement()
    -- 跟18回合有关系的
    if _G.GAME_ROUND>=18 then
        if self.gold_carry  then
            customDataManager:ModifySingleCustomData(self.steamID,"remain_uncorrupted_1",1,nil)
        end
       
        if  self.Advanced_Greevils_Greed_lv25 then
            customDataManager:ModifySingleCustomData(self.steamID,"avatar_of_greed_1",1,nil)
        end
        if self.svenTalent_1 then
            customDataManager:ModifySingleCustomData(self.steamID,"lonely_hero_1",1,nil)
        end
    end
    for _, name in ipairs(self.customData) do
        customDataManager:ModifySingleCustomData(self.steamID,name,1,nil)
    end
    for _, data in ipairs(self.customDataWithValue) do
        customDataManager:ModifySingleCustomData(self.steamID,data.name,data.value,nil)
    end
    -- 跟回合数没关系的
    -- if self.tuskTalent_1 then
    --     customDataManager:ModifySingleCustomData(self.steamID,"Walrus_punch_1",1,nil)
    -- end
    -- if self.tuskTalent_2 then
    --     customDataManager:ModifySingleCustomData(self.steamID,"Walrus_punch_2",1,nil)
    -- end
    -- if self.tinkerTalent_2 then
    --     customDataManager:ModifySingleCustomData(self.steamID,"acceleration_mode_1",1,nil)
    -- end
    -- if self.bounty_hunterTalent_2  then
    --     customDataManager:ModifySingleCustomData(self.steamID,"extremely_greed_1",1,nil)
    -- end
    -- if self.razorTalent_2 then
    --     customDataManager:ModifySingleCustomData(self.steamID,"electrostatic_extractor_1",1,nil)
    -- end
    -- if self.abyssal_underlordTalent_2 then
    --     customDataManager:ModifySingleCustomData(self.steamID,"self_decline_1",1,nil)
    -- end
    self:OnIntervalThink()
end

function modifier_hero_custom_data_manager:OnIntervalThink()
    self:StartIntervalThink(RandomInt(5, 10))

    if self.summon>0 then
        customDataManager:ModifySingleCustomData(self.steamID,"summon_1",self.summon,nil)
        customDataManager:ModifySingleCustomData(self.steamID,"summon_2",self.summon,nil)
        customDataManager:ModifySingleCustomData(self.steamID,"summon_3",self.summon,nil)
        customDataManager:ModifySingleCustomData(self.steamID,"summon_4",self.summon,nil)
        self.summon = 0
    end
    if self.kill>0 then
        customDataManager:ModifySingleCustomData(self.steamID,"enemy_kill_1",self.kill,nil)
        customDataManager:ModifySingleCustomData(self.steamID,"enemy_kill_2",self.kill,nil)
        if Game_State:IsInChaoticEra() then
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_1",self.kill,nil)
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_2",self.kill,nil)
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_3",self.kill,nil)
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_4",self.kill,nil)
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_5",self.kill,nil)
            customDataManager:ModifySingleCustomData(self.steamID,"chaotic_era_rune_killer_6",self.kill,nil)
        end
        self.kill = 0
    end







    
end


function modifier_hero_custom_data_manager:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_DEATH,                          --单位死亡
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

	}
end

function modifier_hero_custom_data_manager:OnDeath(keys)
	-- First check: Is the unit within capture range and an enemy and not reincarnating?
	if keys.attacker then
        if keys.attacker.GetPlayerOwnerID and keys.attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
            -- 击杀
            if IsEnemy(keys.attacker,keys.unit) then
                self.kill = self.kill + 1
            end
       
        end
		
		
	end
end

function modifier_hero_custom_data_manager:OnAbilityFullyCast( keys )
	if IsServer() then

		if keys.unit == self.parent then



			local hAbility = keys.ability 

			if hAbility ~= nil then
	
				if hAbility.IsSummonSpell then
					if hAbility:IsSummonSpell() then
						self.summon = self.summon + 1
							
					end
				end
				
			end
		end
	end


end

function modifier_hero_custom_data_manager:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end

