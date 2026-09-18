LinkLuaModifier("modifier_greedy_buff", "modifier/chaotic_era_buff_card/modifier_greedy", LUA_MODIFIER_MOTION_NONE)

modifier_greedy = advanced_modifier({})

function modifier_greedy:IsHidden()return false end
function modifier_greedy:IsDebuff()return false end
function modifier_greedy:IsPurgable()return false end
function modifier_greedy:IsPurgeException() 	return false end
function modifier_greedy:RemoveOnDeath() return true end
function modifier_greedy:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_greedy:GetTexture() return self.texture end
function modifier_greedy:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.rune_mult =1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

        self:SetStackCount(self.value1)
        self:StartIntervalThink(1)
        self.heroRecord = {}
        self.heroCount = 0
        -- self.aurum_enable = true
        -- local wave = chaotic_era_spawner:GetCurrentWave()
        -- if wave>=self.value4 then
        --     self.aurum_enable = false
        -- end
        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end
    end
end
function modifier_greedy:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        local progressGainIndex = self.rune_mult
        data.runeProgress.level1 = data.runeProgress.level1 *progressGainIndex
        data.runeProgress.level2 = data.runeProgress.level2 *progressGainIndex
        data.runeProgress.level3 = data.runeProgress.level3 *progressGainIndex
        data.runeProgress.level4 = data.runeProgress.level4 *progressGainIndex
        data.runeProgress.level5 = data.runeProgress.level5 *progressGainIndex
    end
end
-- function modifier_greedy:InitAurumBonus(spanTaskCount)
--     if self.aurum_enable then
--         local wave = chaotic_era_spawner:GetCurrentWave()
--         if wave>=self.value4 then
--             return math.floor(spanTaskCount*self.value3)
--         end
--     end
--     return 0
-- end

function modifier_greedy:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_greedy_buff", {gold = self.value1})
            if modifier then
                self.heroRecord[unit] = true
                self.heroCount = self.heroCount + 1
            end
        end
        
    end
    if self.heroCount>=#heroes then
        self:StartIntervalThink(-1)
    end
end


modifier_greedy_buff = advanced_modifier({})

function modifier_greedy_buff:IsHidden()return false end
function modifier_greedy_buff:IsDebuff()return false end
function modifier_greedy_buff:IsPurgable()return false end
function modifier_greedy_buff:IsPurgeException() 	return false end
function modifier_greedy_buff:RemoveOnDeath() return false end
function modifier_greedy_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_greedy_buff:GetTexture() return "alchemist_goblins_greed" end
function modifier_greedy_buff:OnCreated(keys)
    if IsServer() then
        self.gold = keys.gold or 0
    end
end

function modifier_greedy_buff:OnRefresh(keys)
    if IsServer() then
        self.gold = keys.gold or 0
    end
end

function modifier_greedy_buff:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
    }
end

function modifier_greedy_buff:OnChaoticEraRoundChange(keys)
    local gold = self.gold* self:GetParent():GetLevel()

    self:GetParent():ModifyGoldFiltered(gold, true, DOTA_ModifyGold_CreepKill)  --金币奖励
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self:GetParent(), gold, nil)
end
