modifier_diff_1 = advanced_modifier({})

function modifier_diff_1:IsHidden()return false end
function modifier_diff_1:IsDebuff()return false end
function modifier_diff_1:IsPurgable()return false end
function modifier_diff_1:IsPurgeException() 	return false end
function modifier_diff_1:RemoveOnDeath() return true end
function modifier_diff_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_diff_1:GetTexture() return self.texture end

function modifier_diff_1:OnCreated(keys)
    if IsServer() then
        self.hp = GetChaticEra_BuffCardSpecial(self,"hp",keys.level or 1)-100
        self.atk = GetChaticEra_BuffCardSpecial(self,"atk",keys.level or 1)-100
        self.rune = GetChaticEra_BuffCardSpecial(self,"rune",keys.level or 1)*0.01

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


function modifier_diff_1:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        data.attribute.bonusHealth = data.attribute.bonusHealth*(1+self.hp*0.01)
        data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage*(1+self.atk*0.01)

        data.runeProgress.level1 = data.runeProgress.level1 * self.rune
        data.runeProgress.level2 = data.runeProgress.level2 * self.rune
        data.runeProgress.level3 = data.runeProgress.level3 * self.rune
        data.runeProgress.level4 = data.runeProgress.level4 * self.rune
        data.runeProgress.level5 = data.runeProgress.level5 * self.rune
    end
end

--每过回合征召怪物cy
function modifier_diff_1:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
        MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData,
    }
end



function modifier_diff_1:OnChaoticEraRoundChange(keys)
    local round = keys.round
    local round_index = 0.2 + round/40
    if round >= 24 then
        round_index = round_index + round/120
        if round >= 30 then
            round_index = round_index + round/150
        end
    end
    if round >= 4 and round <= 30 then
        self:DecrementStackCount()
        if self:GetStackCount() <= 0 then
            self:SetStackCount(2)

            local insertKeys = {
                attribute_index = round_index,
                rune_progressIndex = 1.8,
            }

            local monsterId = ""

            if round >= 2 and round <= 6 then--2,4,6
                monsterId = "id" .. math.random(7, 9)

            elseif round >= 7 and round <= 12 then--8,10,12
                local possibleIds = {"id13", "id15", "id16", "id17"}
                monsterId = possibleIds[math.random(1, #possibleIds)]

            elseif round >= 13 and round <= 21 then--14,16,18,20
                monsterId = "id" .. math.random(18, 21)

            elseif round >= 22 and round <= 30 then--22,24,26,28,30
                monsterId = "id" .. math.random(22, 25)

            end

            if monsterId ~= "" then
                chaotic_era_spawner:InsertMonsterSpawn__WithID(monsterId, insertKeys)
            end
        end
    end

    if round > 30 and round <= 34 then--31,32,33,34
        local insertKeys = {
            attribute_index = round_index + 0.3,
            rune_progressIndex = 1.8,
        }

        local monsterId = "id" .. math.random(22, 25)
        if monsterId ~= "" then
            chaotic_era_spawner:InsertMonsterSpawn__WithID(monsterId, insertKeys)
        end
    end
end

function modifier_diff_1:AdvancedModifyChaoticEraSpwnData(attribute,unit)
    if unit then
        unit:AddNewModifier(nil, nil, "modifier_chaotic_era_buffskill_fix", {})
    end
    return 0
end