
modifier_weirding_wood = advanced_modifier({})

function modifier_weirding_wood:IsHidden()return false end
function modifier_weirding_wood:IsDebuff()return false end
function modifier_weirding_wood:IsPurgable()return false end
function modifier_weirding_wood:IsPurgeException() 	return false end
function modifier_weirding_wood:RemoveOnDeath() return true end
function modifier_weirding_wood:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_weirding_wood:GetTexture() return self.texture end

function modifier_weirding_wood:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.hp_grow =1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01
        self.atk_grow =1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        self.rune_mult =1+GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end
        --插入时立刻对现有队列生效cy
    --     local spanData = chaotic_era_spawner.spawnList
    --     for index, data in ipairs(spanData) do
    --         if IsBotanicalCreature(data.UnitName) then
                
    --             data.attribute.bonusHealth = data.attribute.bonusHealth * self.hp_grow
    --             data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage * self.atk_grow

    --             local progressGainIndex= self.rune_mult
    --             data.runeProgress.level1 = data.runeProgress.level1 *progressGainIndex    
    --             data.runeProgress.level2 = data.runeProgress.level2 *progressGainIndex    
    --             data.runeProgress.level3 = data.runeProgress.level3 *progressGainIndex    
    --             data.runeProgress.level4 = data.runeProgress.level4 *progressGainIndex    
    --             data.runeProgress.level5 = data.runeProgress.level5 *progressGainIndex 
    --             --print("种族check完毕--修改数据")
    --         else
    --             --print("种族不对，不修改")
    --         end
    --     end
    --     chaotic_era_spawner:UpdateSpawnList()
    end
end


function modifier_weirding_wood:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        local unitName = kv.UnitName
        if IsBotanicalCreature(unitName) then
            data.attribute.bonusHealth = data.attribute.bonusHealth*self.hp_grow
            data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage*self.atk_grow

            local progressGainIndex= self.rune_mult
            data.runeProgress.level1 = data.runeProgress.level1 *progressGainIndex    
            data.runeProgress.level2 = data.runeProgress.level2 *progressGainIndex    
            data.runeProgress.level3 = data.runeProgress.level3 *progressGainIndex    
            data.runeProgress.level4 = data.runeProgress.level4 *progressGainIndex    
            data.runeProgress.level5 = data.runeProgress.level5 *progressGainIndex      
        end
        
    end
	-- runeProgress = {
    --     level1 = value.RuneProgress_1 or 0,
    --     level2 = value.RuneProgress_2 or 0,
    --     level3 = value.RuneProgress_3 or 0,
    --     level4 = value.RuneProgress_4 or 0,
    --     level5 = value.RuneProgress_5 or 0,
        
    -- },

    -- level3获得加成 数值等于 level1的百分比
    -- data.runeProgress.level3 = data.runeProgress.level3 + data.runeProgress.level1*self.bonus3
    -- 不需要返回 因为data指向原来的地址
end


