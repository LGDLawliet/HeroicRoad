LinkLuaModifier("modifier_planar_bridge_hard_debuff", "modifier/chaotic_era_buff_card/modifier_planar_bridge_hard", LUA_MODIFIER_MOTION_NONE)
modifier_planar_bridge_hard = advanced_modifier({})

function modifier_planar_bridge_hard:IsHidden()return false end
function modifier_planar_bridge_hard:IsDebuff()return false end
function modifier_planar_bridge_hard:IsPurgable()return false end
function modifier_planar_bridge_hard:IsPurgeException() 	return false end
function modifier_planar_bridge_hard:RemoveOnDeath() return true end
function modifier_planar_bridge_hard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_planar_bridge_hard:GetTexture() return self.texture end

function modifier_planar_bridge_hard:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.rune_mult = 1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

        self.bonus3 =GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)
        self.bonus4 =GetChaticEra_BuffCardSpecial(self,"value4",keys.level or 1)
        self:SetStackCount(self.bonus3)

        self:StartIntervalThink(1)
        self.heroRecord = {}
        self.heroCount = 0

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

function modifier_planar_bridge_hard:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Wave_Bonus,
    }
end

function modifier_planar_bridge_hard:ModifyTaskData(data)
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

function modifier_planar_bridge_hard:Advanced_Chaotic_Era_Wave_Bonus()
	return self.value1
end


function modifier_planar_bridge_hard:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_planar_bridge_hard_debuff", {stack = self.bonus3})
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


modifier_planar_bridge_hard_debuff = advanced_modifier({})

function modifier_planar_bridge_hard_debuff:IsHidden()return false end
function modifier_planar_bridge_hard_debuff:IsDebuff()return true end
function modifier_planar_bridge_hard_debuff:IsPurgable()return false end
function modifier_planar_bridge_hard_debuff:IsPurgeException() 	return false end
function modifier_planar_bridge_hard_debuff:RemoveOnDeath() return false end
function modifier_planar_bridge_hard_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_planar_bridge_hard_debuff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_planar_bridge_hard_debuff:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_planar_bridge_hard_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end


function modifier_planar_bridge_hard_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return -self:GetStackCount()
end

function modifier_planar_bridge_hard_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()
end

function modifier_planar_bridge_hard_debuff:OnSummonUnit(keys)
    if not IsServer() then return end
    keys.target:AddNewModifier(self:GetParent(), nil, "modifier_planar_bridge_hard_debuff", {stack = self:GetStackCount()*0.5})
end
function modifier_planar_bridge_hard_debuff:GetTexture() return "ability_capture" end