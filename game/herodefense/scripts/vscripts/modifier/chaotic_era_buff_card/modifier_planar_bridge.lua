
modifier_planar_bridge = advanced_modifier({})

function modifier_planar_bridge:IsHidden()return false end
function modifier_planar_bridge:IsDebuff()return false end
function modifier_planar_bridge:IsPurgable()return false end
function modifier_planar_bridge:IsPurgeException() 	return false end
function modifier_planar_bridge:RemoveOnDeath() return true end
function modifier_planar_bridge:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_planar_bridge:GetTexture() return self.texture end

function modifier_planar_bridge:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.rune_mult = 1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

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

function modifier_planar_bridge:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Wave_Bonus,
    }
end

function modifier_planar_bridge:ModifyTaskData(data)
    -- print("处理符石")
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then

        local progressGainIndex= self.rune_mult
        data.runeProgress.level1 = data.runeProgress.level1 *progressGainIndex    
        data.runeProgress.level2 = data.runeProgress.level2 *progressGainIndex    
        data.runeProgress.level3 = data.runeProgress.level3 *progressGainIndex    
        data.runeProgress.level4 = data.runeProgress.level4 *progressGainIndex    
        data.runeProgress.level5 = data.runeProgress.level5 *progressGainIndex         
    end
end


function modifier_planar_bridge:Advanced_Chaotic_Era_Wave_Bonus()
	return self.value1
end


