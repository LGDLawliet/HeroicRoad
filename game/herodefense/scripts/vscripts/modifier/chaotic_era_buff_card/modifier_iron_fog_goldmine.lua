
modifier_iron_fog_goldmine = advanced_modifier({})

function modifier_iron_fog_goldmine:IsHidden()return false end
function modifier_iron_fog_goldmine:IsDebuff()return false end
function modifier_iron_fog_goldmine:IsPurgable()return false end
function modifier_iron_fog_goldmine:IsPurgeException() 	return false end
function modifier_iron_fog_goldmine:RemoveOnDeath() return true end
function modifier_iron_fog_goldmine:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_iron_fog_goldmine:GetTexture() return self.texture end

function modifier_iron_fog_goldmine:OnCreated(keys)
    if IsServer() then
        self.value1 =1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01
        self.rune_mult =1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

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

function modifier_iron_fog_goldmine:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus,
        -- MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
        -- 乱纪元回合切换cy
    }
end

function modifier_iron_fog_goldmine:Advanced_GetChaotic_Era_BountyBonus()
	return self.value1
end

function modifier_iron_fog_goldmine:ModifyTaskData(data)
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

--乱纪元回合切换cy
-- function modifier_iron_fog_goldmine:OnChaoticEraRoundChange(keys)
-- 	if keys.round>=self.wave then
--         self:Destroy()
--         -- print("没加成咯")
--     end
-- end
