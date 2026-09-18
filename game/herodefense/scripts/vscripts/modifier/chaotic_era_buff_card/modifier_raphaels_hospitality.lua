
modifier_raphaels_hospitality = advanced_modifier({})

function modifier_raphaels_hospitality:IsHidden()return false end
function modifier_raphaels_hospitality:IsDebuff()return false end
function modifier_raphaels_hospitality:IsPurgable()return false end
function modifier_raphaels_hospitality:IsPurgeException() 	return false end
function modifier_raphaels_hospitality:RemoveOnDeath() return true end
function modifier_raphaels_hospitality:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_raphaels_hospitality:GetTexture() return self.texture end

function modifier_raphaels_hospitality:OnCreated(keys)
    if IsServer() then
        if chaotic_era_spawner:GetCurrentWave()>23 then
            local gameEvent = {}
            gameEvent["teamnumber"] = -1
            gameEvent["message"] = "#HUD_ChaoticEra_raphaels_select_fail"
            FireGameEvent( "dota_combat_event_message", gameEvent )
            self:Destroy()
            return
        end
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.value2 = GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)

    end
end



function modifier_raphaels_hospitality:UpdateGameSettlementData(rune_progress)
    local count = rune_progress["level4"].count + rune_progress["level5"].count*5
    if count>=self.value1 then
        -- 成功
        rune_progress["level4"].count = rune_progress["level4"].count + self.value2

        local gameEvent = {}
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#HUD_ChaoticEra_raphaels_buff"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    else
        rune_progress["level4"].count = 0
        rune_progress["level5"].count = 0
        local gameEvent = {}
        gameEvent["teamnumber"] = -1
        gameEvent["message"] = "#HUD_ChaoticEra_raphaels_debuff"
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end


    

end
