item_hd_chaotic_demon = class({})

LinkLuaModifier("modifier_item_hd_chaotic_demon", "items/item_hd_chaotic_demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_chaotic_demon_summon", "items/item_hd_chaotic_demon", LUA_MODIFIER_MOTION_NONE)
function item_hd_chaotic_demon:OnSpellStart()
    if chaotic_era_spawner:GetCurrentWave() >= 35 then
        self:SpendCharge(0)
        return
    end

    local heroes = GetAllRealHeroes()
    for _,hero in pairs(heroes) do
        hero:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_chaotic_demon", {})
    end
	
	self:SpendCharge(0)
end

modifier_item_hd_chaotic_demon = advanced_modifier({})

function modifier_item_hd_chaotic_demon:IsDebuff() return true end
function modifier_item_hd_chaotic_demon:IsHidden() return false end
function modifier_item_hd_chaotic_demon:IsPurgable() return false end
function modifier_item_hd_chaotic_demon:IsPurgeException() return false end
function modifier_item_hd_chaotic_demon:RemoveOnDeath() return false end
function modifier_item_hd_chaotic_demon:GetTexture() return "item_chaotic_demon" end
function modifier_item_hd_chaotic_demon:OnCreated(keys)
    self.value1 = 70
    self.value2 = 50
    self.value3 = 1
    -- 依据回合时间减少
    self.value4 = 60
    self.value5 = 80
    self.value6 = 15
    if IsServer() then
        self.wave = chaotic_era_spawner:GetCurrentWave()
        self:SetStackCount(self.wave)

        local boss_rune = self:GetParent():FindModifierByName("modifier_boss_rune")
        if boss_rune then
           boss_rune:SetStackCount(boss_rune:GetStackCount() + (self.value6 - self:GetStackCount()*0.3)) 
        end
    end
    self.value4 = self.value4 - self:GetStackCount()*1.5
    self.value5 = self.value5 - self:GetStackCount()*2
    self.value6 = self.value6 - self:GetStackCount()*0.3
    self:SendBuffRefreshToClients()
end

function modifier_item_hd_chaotic_demon:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount
    }
end
function modifier_item_hd_chaotic_demon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()	
	return -self.value1
end
function modifier_item_hd_chaotic_demon:Advanced_GetModifierIncomingDamage_Percentage()	
	return self.value2
end
function modifier_item_hd_chaotic_demon:Advanced_GetChaotic_Era_Spell_GenerateCount()
    return -self.value3
end

function modifier_item_hd_chaotic_demon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_hd_chaotic_demon:OnSummonUnit(keys)
    if not IsServer() then return end
    keys.target:AddNewModifier(self:GetParent(),nil,"modifier_item_hd_chaotic_demon_summon",{})
end

function modifier_item_hd_chaotic_demon:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 6 + 1
	if self._tooltip == 1 then
		return  self.value1
	end
    if self._tooltip == 2 then
		return  self.value2
	end
    if self._tooltip == 3 then
		return  self.value3
	end
    if self._tooltip == 4 then
		return  self.value4
	end
    if self._tooltip == 5 then
		return  self.value5
	end
    if self._tooltip == 6 then
		return  self.value6
	end
end

-----------------------------
modifier_item_hd_chaotic_demon_summon = advanced_modifier({})

function modifier_item_hd_chaotic_demon_summon:IsDebuff() return true end
function modifier_item_hd_chaotic_demon_summon:IsHidden() return false end
function modifier_item_hd_chaotic_demon_summon:IsPurgable() return false end
function modifier_item_hd_chaotic_demon_summon:IsPurgeException() return false end
function modifier_item_hd_chaotic_demon_summon:RemoveOnDeath() return false end
function modifier_item_hd_chaotic_demon_summon:GetTexture() return "item_chaotic_demon" end
function modifier_item_hd_chaotic_demon_summon:OnCreated(keys)
    self.value1 = 70
    self.value2 = 50
end

function modifier_item_hd_chaotic_demon_summon:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_chaotic_demon_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()	
	return -self.value1
end
function modifier_item_hd_chaotic_demon_summon:Advanced_GetModifierIncomingDamage_Percentage()	
	return self.value2
end

function modifier_item_hd_chaotic_demon_summon:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_hd_chaotic_demon_summon:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.value1
	end
    if self._tooltip == 2 then
		return  self.value2
	end
end
