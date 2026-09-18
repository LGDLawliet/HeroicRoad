-- 重写完成
item_hd_woodknife_effects = class({})
LinkLuaModifier("modifier_item_hd_woodknife_effects", "player_artifact/item_hd_woodknife_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_woodknife_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_woodknife_effects"
end

modifier_item_hd_woodknife_effects = advanced_modifier({})

function modifier_item_hd_woodknife_effects:IsDebuff() return false end
function modifier_item_hd_woodknife_effects:IsHidden() return true end
function modifier_item_hd_woodknife_effects:IsPurgable() return false end
function modifier_item_hd_woodknife_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_attack_speed = self.ability:GetArtifactSpecialValueFor("bonus_attack_speed")
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")
    
    self.attack_speed_1 = self.ability:GetArtifactSpecialValueFor("attack_speed_1") 
    self.attack_3 = self.ability:GetArtifactSpecialValueFor("attack_3") 
    self.atb_4 = 0
    self.cleave_10 = 0
    self.poison_7 = self.ability:GetArtifactSpecialValueFor("poison_7")*0.01
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_woodknife_effects")
    
    if self.level >= 10 then
        self.bonus_attack_speed = self.bonus_attack_speed +  self.attack_speed_1
    end
    if self.level >= 30 then
        self.bonus_attack = self.bonus_attack +  self.attack_3
    end
    if self.level >= 40 then
       self.atb_4 =  self.ability:GetArtifactSpecialValueFor("atb_4") 
    end
    if self.level >= 100 then
        self.poison_7 = self.ability:GetArtifactSpecialValueFor("poison_10")*0.01
        self.cleave_10 = self.ability:GetArtifactSpecialValueFor("cleave_10")*0.01
    end
end

function modifier_item_hd_woodknife_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_attack_speed = self.ability:GetArtifactSpecialValueFor("bonus_attack_speed")
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")
    
    self.attack_speed_1 = self.ability:GetArtifactSpecialValueFor("attack_speed_1") 
    self.attack_3 = self.ability:GetArtifactSpecialValueFor("attack_3") 
    self.atb_4 = 0
    self.cleave_10 = 0
    self.poison_7 = self.ability:GetArtifactSpecialValueFor("poison_7")*0.01
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_woodknife_effects")
    
    if self.level >= 10 then
        self.bonus_attack_speed = self.bonus_attack_speed +  self.attack_speed_1
    end
    if self.level >= 30 then
        self.bonus_attack = self.bonus_attack +  self.attack_3
    end
    if self.level >= 40 then
       self.atb_4 =  self.ability:GetArtifactSpecialValueFor("atb_4") 
    end
    if self.level >= 100 then
        self.poison_7 = self.ability:GetArtifactSpecialValueFor("poison_10")*0.01
        self.cleave_10 = self.ability:GetArtifactSpecialValueFor("cleave_10")*0.01
    end
end

function modifier_item_hd_woodknife_effects:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_hd_woodknife_effects:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed 
end
    
function modifier_item_hd_woodknife_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
    }
    return funcs
end

function modifier_item_hd_woodknife_effects:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_attack
end
function modifier_item_hd_woodknife_effects:Advanced_GetModifierBonusStats_Strength()   
    return self.atb_4
end
function modifier_item_hd_woodknife_effects:Advanced_GetModifierBonusStats_Agility()
    return self.atb_4
end 
function modifier_item_hd_woodknife_effects:Advanced_GetModifierBonusStats_Intellect()
    return self.atb_4
end
function modifier_item_hd_woodknife_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    if self.level < 70 then return end
    
	local attacker = keys.attacker
    local target = keys.target
    local parent = self:GetParent()
	local ability = self:GetAbility()
    if not ability or attacker ~= parent then return end
    if not target:IsAlive() then return end

    local poison = attacker:GetAverageTrueAttackDamage(nil)*self.poison_7

    target:Poison(attacker, ability, poison)
end

