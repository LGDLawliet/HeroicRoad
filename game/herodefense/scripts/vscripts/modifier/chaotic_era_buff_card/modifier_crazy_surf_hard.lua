LinkLuaModifier("modifier_crazy_surf_hard_debuff", "modifier/chaotic_era_buff_card/modifier_crazy_surf_hard", LUA_MODIFIER_MOTION_NONE)
modifier_crazy_surf_hard = advanced_modifier({})

function modifier_crazy_surf_hard:IsHidden()return false end
function modifier_crazy_surf_hard:IsDebuff()return false end
function modifier_crazy_surf_hard:IsPurgable()return false end
function modifier_crazy_surf_hard:IsPurgeException() 	return false end
function modifier_crazy_surf_hard:RemoveOnDeath() return true end
function modifier_crazy_surf_hard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_crazy_surf_hard:GetTexture() return self.texture end

function modifier_crazy_surf_hard:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.time_down = 1/(1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01)
        self.gold_down = 1 - GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        self.value3 = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)
        self:SetStackCount(self.value3)

        self:StartIntervalThink(1)
        self.heroRecord = {}
        self.heroCount = 0

        --插入时立刻对现有队列生效cy
        local spanData = chaotic_era_spawner.spawnList
        for index, data in ipairs(spanData) do
            local time_down = self.time_down
            local gold_down = self.gold_down
            data.interval = data.interval *time_down
            data.attribute.bounty = data.attribute.bounty *gold_down    
            data.attribute.bonusBounty = data.attribute.bonusBounty *gold_down   
        end
        chaotic_era_spawner:UpdateSpawnList()

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

function modifier_crazy_surf_hard:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_crazy_surf_hard_debuff", {stack = self.value3})
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

function modifier_crazy_surf_hard:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        local time_down = self.time_down
            local gold_down = self.gold_down
            data.interval = data.interval *time_down
            data.attribute.bounty = data.attribute.bounty *gold_down    
            data.attribute.bonusBounty = data.attribute.bonusBounty *gold_down   
    end
end

modifier_crazy_surf_hard_debuff = advanced_modifier({})

function modifier_crazy_surf_hard_debuff:IsHidden()return false end
function modifier_crazy_surf_hard_debuff:IsDebuff()return true end
function modifier_crazy_surf_hard_debuff:IsPurgable()return false end
function modifier_crazy_surf_hard_debuff:IsPurgeException() 	return false end
function modifier_crazy_surf_hard_debuff:RemoveOnDeath() return false end
function modifier_crazy_surf_hard_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_crazy_surf_hard_debuff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_crazy_surf_hard_debuff:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_crazy_surf_hard_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end


function modifier_crazy_surf_hard_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return -self:GetStackCount()
end

function modifier_crazy_surf_hard_debuff:OnSummonUnit(keys)
    if not IsServer() then return end
    keys.target:AddNewModifier(self:GetParent(), nil, "modifier_crazy_surf_hard_debuff", {stack = self:GetStackCount()*0.5})
end
function modifier_crazy_surf_hard_debuff:GetTexture() return "ability_capture" end