
LinkLuaModifier("modifier_super_elite_debuff", "modifier/chaotic_era_buff_card/modifier_super_elite", LUA_MODIFIER_MOTION_NONE)
modifier_super_elite = advanced_modifier({})

function modifier_super_elite:IsHidden()return false end
function modifier_super_elite:IsDebuff()return false end
function modifier_super_elite:IsPurgable()return false end
function modifier_super_elite:IsPurgeException() 	return false end
function modifier_super_elite:RemoveOnDeath() return true end
function modifier_super_elite:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_super_elite:GetTexture() return self.texture end

function modifier_super_elite:OnCreated(keys)
    if IsServer() then

        self.rune = 1+GetChaticEra_BuffCardSpecial(self,"rune",keys.level or 1)*0.01

        self:SetStackCount(1)

        self:StartIntervalThink(1)
        self.heroRecord = {}
        self.heroCount = 0
        
        --插入时立刻对现有队列生效cy
        local spanData = chaotic_era_spawner.spawnList
        for index, data in ipairs(spanData) do
            local progressGainIndex= self.rune
            data.runeProgress.level1 = data.runeProgress.level1 *progressGainIndex    
            data.runeProgress.level2 = data.runeProgress.level2 *progressGainIndex    
            data.runeProgress.level3 = data.runeProgress.level3 *progressGainIndex    
            data.runeProgress.level4 = data.runeProgress.level4 *progressGainIndex    
            data.runeProgress.level5 = data.runeProgress.level5 *progressGainIndex 
            --print("种族check完毕--修改数据")
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


function modifier_super_elite:ModifyTaskData(data)
    -- print("处理符石")
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        data.runeProgress.level1 = data.runeProgress.level1 *self.rune    
        data.runeProgress.level2 = data.runeProgress.level2 *self.rune    
        data.runeProgress.level3 = data.runeProgress.level3 *self.rune    
        data.runeProgress.level4 = data.runeProgress.level4 *self.rune    
        data.runeProgress.level5 = data.runeProgress.level5 *self.rune
    end
end


function modifier_super_elite:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_super_elite_debuff", {})
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
----------------------
modifier_super_elite_debuff = advanced_modifier({})

function modifier_super_elite_debuff:IsHidden()return false end
function modifier_super_elite_debuff:IsDebuff()return true end
function modifier_super_elite_debuff:IsPurgable()return false end
function modifier_super_elite_debuff:IsPurgeException() 	return false end
function modifier_super_elite_debuff:RemoveOnDeath() return false end
function modifier_super_elite_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_super_elite_debuff:GetTexture() return "ability_capture" end
