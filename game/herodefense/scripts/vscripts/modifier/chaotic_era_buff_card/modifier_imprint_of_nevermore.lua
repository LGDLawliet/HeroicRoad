LinkLuaModifier("modifier_imprint_of_nevermore_buff", "modifier/chaotic_era_buff_card/modifier_imprint_of_nevermore", LUA_MODIFIER_MOTION_NONE)


modifier_imprint_of_nevermore = advanced_modifier({})

function modifier_imprint_of_nevermore:IsHidden()return false end
function modifier_imprint_of_nevermore:IsDebuff()return false end
function modifier_imprint_of_nevermore:IsPurgable()return false end
function modifier_imprint_of_nevermore:IsPurgeException() 	return false end
function modifier_imprint_of_nevermore:RemoveOnDeath() return true end
function modifier_imprint_of_nevermore:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imprint_of_nevermore:GetTexture() return self.texture end

function modifier_imprint_of_nevermore:OnCreated(keys)
    if IsServer() then
        self.bonus1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.bonus2 = 1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        self.rune_mult = 1+GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        self:SetStackCount(self.bonus1)

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

function modifier_imprint_of_nevermore:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_imprint_of_nevermore_buff", {stack = self.bonus1})
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

function modifier_imprint_of_nevermore:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_DEATH = {nil, nil},
    }
end

function modifier_imprint_of_nevermore:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		
		if unit:IsRealHero() then
            local spanData = chaotic_era_spawner.spawnList
            for index, data in ipairs(spanData) do
                data.attribute.bonusHealth = data.attribute.bonusHealth * self.bonus2
                data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage * self.bonus2
                --print("修改数据")
            end
            chaotic_era_spawner:UpdateSpawnList()
		end
	end
end

function modifier_imprint_of_nevermore:ModifyTaskData(data)
    -- local heroes = GetAllRealHeroes()
	-- for _, hero in ipairs(heroes) do
    --     hero:AddNewModifier(hero, nil, "modifier_imprint_of_nevermore_buff", {stack=self.bonus2})
	-- end
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



---------

modifier_imprint_of_nevermore_buff = advanced_modifier({})

function modifier_imprint_of_nevermore_buff:IsHidden()	return true end
function modifier_imprint_of_nevermore_buff:IsDebuff()	return false end
function modifier_imprint_of_nevermore_buff:IsPurgable()	return false end
function modifier_imprint_of_nevermore_buff:RemoveOnDeath() return false end
function modifier_imprint_of_nevermore_buff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_imprint_of_nevermore_buff:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_imprint_of_nevermore_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_imprint_of_nevermore_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    return self:GetStackCount()
end