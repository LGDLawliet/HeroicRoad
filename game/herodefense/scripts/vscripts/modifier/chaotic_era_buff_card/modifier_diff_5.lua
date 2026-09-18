modifier_diff_5 = advanced_modifier({})

function modifier_diff_5:IsHidden()return false end
function modifier_diff_5:IsDebuff()return false end
function modifier_diff_5:IsPurgable()return false end
function modifier_diff_5:IsPurgeException() 	return false end
function modifier_diff_5:RemoveOnDeath() return true end
function modifier_diff_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_diff_5:GetTexture() return self.texture end

function modifier_diff_5:OnCreated(keys)
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

        self.skilltable = {}
        for i = 1, 16 do
            local skill_name = string.format("chaotic_era_buffskill_%d", i)
            -- if skill_name ~= "chaotic_era_buffskill_17" then
                table.insert(self.skilltable, skill_name)
            -- end
        end
    end
end


function modifier_diff_5:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        -- local current_wave = GetWave()
        -- local hp_scale = 1 + (self.hp / 100) * (current_wave / 30)
        -- local atk_scale = 1 + (self.atk / 100) * (current_wave / 30)
        -- print("生命成长为"..hp_scale.."攻击力成长为"..atk_scale)

        -- data.attribute.bonusHealth = data.attribute.bonusHealth*hp_scale
        -- data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage*atk_scale
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
function modifier_diff_5:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
        MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData,
    }
end

function modifier_diff_5:OnChaoticEraRoundChange(keys)
    local round = keys.round
    local round_index = 0.2 + round/28
    if round >= 24 then
        round_index = round_index + round/45
        if round >= 30 then
            round_index = round_index + round/60
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
            attribute_index = round_index+ 0.2,
            rune_progressIndex = 1.8,
        }

        local monsterId = "id" .. math.random(22, 25)
        if monsterId ~= "" then
            chaotic_era_spawner:InsertMonsterSpawn__WithID(monsterId, insertKeys)
        end
    end
end

function modifier_diff_5:AdvancedModifyChaoticEraSpwnData(attribute,unit)
    if unit then
         unit:AddNewModifier(nil, nil, "modifier_chaotic_era_buffskill_fix", {})
        local wave = GetWave()
        if self.skilltable and type(self.skilltable) == "table" then
            -- 复制技能表
            local available_skills = {}
            for i, v in ipairs(self.skilltable) do
                table.insert(available_skills, v)
            end
            -- 回合数不同生成的词条数目也应该不同,0-8回合是0-1个，9-16回合是1-2个，17-24回合是2-3个，25-30回合是3个，31-34回合是4个
            --print("wave="..wave)
            local count = 1
            if wave >= 9 then
                count = 2
                if wave >= 17 then
                    count = 3
                    table.insert(available_skills, "chaotic_era_buffskill_17")
                    if wave >= 31 then
                        count = 4
                    end
                end
            end
            if math.random(1,100) <= 50 or wave >= 25 then
                count = count + 1
            end
            count = math.min(count, #available_skills)
            --print("基于回合数，当前生成词条数量"..count.."个")
            
            -- 随机抽取不重复的技能
            local selected_skills = {}
            for i = 1, count do
                if #available_skills > 0 then
                    local random_index = math.random(1, #available_skills)
                    local selected_skill = available_skills[random_index]
                    table.insert(selected_skills, selected_skill)
                    -- 从可用技能中移除已选择的技能
                    table.remove(available_skills, random_index)
                end
            end
            
            -- 添加技能到单位
            for i = 1, #selected_skills do
                local ability = unit:AddAbility(selected_skills[i])
                if ability then
                    ability:SetLevel(1)
                end
            end
        end
    end
	-- attribute.attackDamage = math.max(attribute.attackDamage - damage_reduction,1)
    return 0
end

modifier_diff_5_buff = advanced_modifier({})

function modifier_diff_5_buff:IsHidden()return false end
function modifier_diff_5_buff:IsDebuff()return false end
function modifier_diff_5_buff:IsPurgable()return false end
function modifier_diff_5_buff:IsPurgeException() 	return false end