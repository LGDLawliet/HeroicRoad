LinkLuaModifier("modifier_chaos_coming_hard_debuff", "modifier/chaotic_era_buff_card/modifier_chaos_coming_hard", LUA_MODIFIER_MOTION_NONE)
modifier_chaos_coming_hard = advanced_modifier({})

function modifier_chaos_coming_hard:IsHidden()return false end
function modifier_chaos_coming_hard:IsDebuff()return false end
function modifier_chaos_coming_hard:IsPurgable()return false end
function modifier_chaos_coming_hard:IsPurgeException() 	return false end
function modifier_chaos_coming_hard:RemoveOnDeath() return true end
function modifier_chaos_coming_hard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaos_coming_hard:GetTexture() return self.texture end

function modifier_chaos_coming_hard:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.hp_grow =1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01
        self.atk_grow =1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        self.rune_mult =1+GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        self.card_buff =GetChaticEra_BuffCardSpecial(self,"value4",keys.level or 1)
        self:SetStackCount(self.card_buff)

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


function modifier_chaos_coming_hard:ModifyTaskData(data)
    -- print("处理符石")
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        local unitName = kv.UnitName
        if IsChaosCreature(unitName) then
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
end


function modifier_chaos_coming_hard:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_chaos_coming_hard_debuff", {stack = self.card_buff})
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




modifier_chaos_coming_hard_debuff = advanced_modifier({})

function modifier_chaos_coming_hard_debuff:IsHidden()return false end
function modifier_chaos_coming_hard_debuff:IsDebuff()return true end
function modifier_chaos_coming_hard_debuff:IsPurgable()return false end
function modifier_chaos_coming_hard_debuff:IsPurgeException() 	return false end
function modifier_chaos_coming_hard_debuff:RemoveOnDeath() return false end
function modifier_chaos_coming_hard_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaos_coming_hard_debuff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_chaos_coming_hard_debuff:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_chaos_coming_hard_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end


function modifier_chaos_coming_hard_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return -self:GetStackCount()
end
function modifier_chaos_coming_hard_debuff:OnSummonUnit(keys)
    if not IsServer() then return end
    keys.target:AddNewModifier(self:GetParent(), nil, "modifier_chaos_coming_hard_debuff", {stack = self:GetStackCount()*0.5})
end
function modifier_chaos_coming_hard_debuff:GetTexture() return "ability_capture" end