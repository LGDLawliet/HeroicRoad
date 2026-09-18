LinkLuaModifier("modifier_smothering_tithe_debuff", "modifier/chaotic_era_buff_card/modifier_smothering_tithe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_smothering_tithe_buff", "modifier/chaotic_era_buff_card/modifier_smothering_tithe", LUA_MODIFIER_MOTION_NONE)
modifier_smothering_tithe = advanced_modifier({})

function modifier_smothering_tithe:IsHidden()return false end
function modifier_smothering_tithe:IsDebuff()return false end
function modifier_smothering_tithe:IsPurgable()return false end
function modifier_smothering_tithe:IsPurgeException() 	return false end
function modifier_smothering_tithe:RemoveOnDeath() return true end
function modifier_smothering_tithe:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_smothering_tithe:GetTexture() return self.texture end

function modifier_smothering_tithe:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.gold = GetChaticEra_BuffCardSpecial(self,"gold",keys.level or 1)
        self.interval = GetChaticEra_BuffCardSpecial(self,"interval",keys.level or 1)
        self.back = GetChaticEra_BuffCardSpecial(self,"back",keys.level or 1)*0.01
        self.value2 = GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)
        self.value3 = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)
        self.bonus = GetChaticEra_BuffCardSpecial(self,"bonus",keys.level or 1)
        self.index = GetChaticEra_BuffCardSpecial(self,"index",keys.level or 1)*0.01

        local heroes = GetAllRealHeroes()
        local all_gold_owe = #heroes*self.gold*self.index
        for _, hero in pairs(heroes) do
            chaotic_era_spawner:PlayerGetGoldBounty(hero, self.gold, nil)
			SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD  ,hero, self.gold, nil)
            
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end

        self:SetStackCount(all_gold_owe)

        self:StartIntervalThink(1)
    end
end

function modifier_smothering_tithe:UpdateGameSettlementData(rune_progress)
    if self:GetStackCount()<=0 then
        rune_progress["level3"].count = rune_progress["level3"].count + self.value2
        rune_progress["level4"].count = rune_progress["level4"].count + self.value3
    end
end

function modifier_smothering_tithe:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    if self:GetStackCount()>0 then
        
        for index, unit in ipairs(heroes) do
            unit:AddNewModifier(unit, nil, "modifier_smothering_tithe_debuff", 
            {
                stack = self:GetStackCount(), 
                interval = self.interval,
                back = self.back,
            }
            )
        end
    else
        for index, unit in ipairs(heroes) do
            unit:RemoveModifierByName("modifier_smothering_tithe_debuff")
            unit:AddNewModifier(unit, nil, "modifier_smothering_tithe_buff", 
            {
                bonus = self.bonus, 
            }
            )
        end
        self:StartIntervalThink(-1)
        local gameEvent = {}
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#HUD_ChaoticEra_smothering_tithe_success"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end

end

function modifier_smothering_tithe:GoldFlite(value)
    if value>self:GetStackCount() then
        value = value - self:GetStackCount()
        self:SetStackCount(0)
        return value
    else
        self:SetStackCount(self:GetStackCount()-value)
        return 0 
    end
end



modifier_smothering_tithe_debuff = advanced_modifier({})

function modifier_smothering_tithe_debuff:IsHidden()return false end
function modifier_smothering_tithe_debuff:IsDebuff()return true end
function modifier_smothering_tithe_debuff:IsPurgable()return false end
function modifier_smothering_tithe_debuff:IsPurgeException() 	return false end
function modifier_smothering_tithe_debuff:RemoveOnDeath() return false end
function modifier_smothering_tithe_debuff:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_smothering_tithe_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_smothering_tithe_debuff:OnCreated(keys)
    if IsServer() then
        self.stack = keys.stack
        self.interval = keys.interval
        self.back = keys.back
        self:SetStackCount(self.stack)
        self:StartIntervalThink(self.interval)

        self.already = 0
    end
end

function modifier_smothering_tithe_debuff:OnRefresh(keys)
    if IsServer() then
        self.stack = keys.stack
        self.interval = keys.interval
        self.back = keys.back
        self:SetStackCount(self.stack)
    end
end

function modifier_smothering_tithe_debuff:OnDestroy()
    if IsServer() then
        if self.already then
            local gameEvent={}
            gameEvent["message"] = "#DOTA_HUD_tithe_final_info"
            gameEvent["locstring_value"] = self.already
            gameEvent["locstring_value2"] = self:GetParent():GetUnitName()
            gameEvent["teamnumber"] = -1
            FireGameEvent( "dota_combat_event_message", gameEvent )
        end
    end
end

function modifier_smothering_tithe_debuff:OnIntervalThink()
    if not self:GetParent():IsAlive() then
        return
    end
    local hero_num = #GetAllRealHeroes()
    local gold = self:GetParent():GetGold()
    local will_back = math.min(gold*self.back, self:GetStackCount()/hero_num)
    self:GetParent():ModifyGoldFiltered(-will_back, true, DOTA_ModifyGold_AbilityCost)
    self.already = self.already + will_back

    local modifier = MODIFIER_GLOBAL_DUMMY:FindModifierByName("modifier_smothering_tithe")
    if modifier then
        modifier:GoldFlite(will_back)
    end

    if self.already then
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_tithe_info"
        gameEvent["locstring_value"] = will_back
        gameEvent["locstring_value2"] = self:GetParent():GetUnitName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

modifier_smothering_tithe_buff = advanced_modifier({})

function modifier_smothering_tithe_buff:IsHidden()return false end
function modifier_smothering_tithe_buff:IsDebuff()return false end
function modifier_smothering_tithe_buff:IsPurgable()return false end
function modifier_smothering_tithe_buff:IsPurgeException() 	return false end
function modifier_smothering_tithe_buff:RemoveOnDeath() return false end
function modifier_smothering_tithe_buff:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_smothering_tithe_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_smothering_tithe_buff:OnCreated(keys)
    if IsServer() then
        self.bonus = keys.bonus

        self:SetStackCount(self.bonus)
    end
end

function modifier_smothering_tithe_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount
    }
end
function modifier_smothering_tithe_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_smothering_tithe_buff:Advanced_GetChaotic_Era_Spell_GenerateCount()
	return self:GetStackCount()
end
function modifier_smothering_tithe_buff:OnTooltip()
	return self:GetStackCount()
end
