
modifier_crazy_surf = advanced_modifier({})

function modifier_crazy_surf:IsHidden()return false end
function modifier_crazy_surf:IsDebuff()return false end
function modifier_crazy_surf:IsPurgable()return false end
function modifier_crazy_surf:IsPurgeException() 	return false end
function modifier_crazy_surf:RemoveOnDeath() return true end
function modifier_crazy_surf:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_crazy_surf:GetTexture() return self.texture end

function modifier_crazy_surf:OnCreated(keys)
    if IsServer() then
        self.time_down = 1/(1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01)
        self.gold_down = 1 - GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        print()
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

function modifier_crazy_surf:ModifyTaskData(data)
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        local time_down = self.time_down
        local gold_down = self.gold_down
        data.interval = data.interval *time_down
        data.attribute.bounty = data.attribute.bounty *gold_down    
        data.attribute.bonusBounty = data.attribute.bonusBounty *gold_down       
    end
end