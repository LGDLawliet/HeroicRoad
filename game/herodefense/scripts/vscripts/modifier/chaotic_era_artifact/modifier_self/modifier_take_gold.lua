
modifier_take_gold = advanced_modifier({})

function modifier_take_gold:IsHidden()return false end
function modifier_take_gold:IsDebuff()return false end
function modifier_take_gold:IsPurgable()return false end
function modifier_take_gold:IsPurgeException() 	return false end
function modifier_take_gold:RemoveOnDeath() return false end
function modifier_take_gold:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_take_gold:GetTexture() return "kobold_taskmaster_speed_aura" end

function modifier_take_gold:OnCreated(keys)
    self.atb = 5
    self.base_attack = 20
    self.armor = 2
    self.gold = 35
    if IsServer() then 
        self:StartIntervalThink(10)
    end
end

function modifier_take_gold:OnIntervalThink()
    if Game_State:IsInBattle() then
        chaotic_era_spawner:PlayerGetGoldBounty(self:GetParent(),self.gold,nil) 
    end
end

function modifier_take_gold:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_take_gold:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end
function modifier_take_gold:Advanced_GetModifierBaseAttack_BonusDamage()
    return self.base_attack
end
function modifier_take_gold:Advanced_GetModifierBonusStats_Strength()
    return self.atb
end
function modifier_take_gold:Advanced_GetModifierBonusStats_Agility()
    return self.atb
end
function modifier_take_gold:Advanced_GetModifierBonusStats_Intellect()
    return self.atb
end