-- 重写完成
item_hd_godfire_effects = class({})
LinkLuaModifier("modifier_item_hd_godfire_effects", "player_artifact/item_hd_godfire_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_godfire_effects_lv30", "player_artifact/item_hd_godfire_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_godfire_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_godfire_effects"
end

modifier_item_hd_godfire_effects = advanced_modifier({})

function modifier_item_hd_godfire_effects:IsDebuff() return false end
function modifier_item_hd_godfire_effects:IsHidden() return true end
function modifier_item_hd_godfire_effects:IsPurgable() return false end
function modifier_item_hd_godfire_effects:RemoveOnDeath() return false end

function modifier_item_hd_godfire_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")*0.01
    self.bonus_attack_1 = self.ability:GetArtifactSpecialValueFor("bonus_attack_1")*0.01
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.mana_attack = 0
    self.mana_attack_2 = self.ability:GetArtifactSpecialValueFor("mana_attack_2")*0.01
    self.attack_grow_max = self.ability:GetArtifactSpecialValueFor("attack_grow_max")
    self.attack_grow_max_7 = self.ability:GetArtifactSpecialValueFor("attack_grow_max_7")
    self.stack_10 = self.ability:GetArtifactSpecialValueFor("stack_10")
    self.index_10 = self.ability:GetArtifactSpecialValueFor("index_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_godfire_effects")

    if self.level >= 10 then
        self.bonus_attack = self.bonus_attack_1
    end
    if self.level >= 20 then
        self.mana_attack = self.mana_attack_2
    end
    if self.level >= 70 then
        self.attack_grow_max = self.attack_grow_max_7
    end
end

function modifier_item_hd_godfire_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")*0.01
    self.bonus_attack_1 = self.ability:GetArtifactSpecialValueFor("bonus_attack_1")*0.01
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.mana_attack = 0
    self.mana_attack_2 = self.ability:GetArtifactSpecialValueFor("mana_attack_2")*0.01
    self.attack_grow_max = self.ability:GetArtifactSpecialValueFor("attack_grow_max")
    self.attack_grow_max_7 = self.ability:GetArtifactSpecialValueFor("attack_grow_max_7")
    self.stack_10 = self.ability:GetArtifactSpecialValueFor("stack_10")
    self.index_10 = self.ability:GetArtifactSpecialValueFor("index_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_godfire_effects")

    if self.level >= 10 then
        self.bonus_attack = self.bonus_attack_1
    end
    if self.level >= 20 then
        self.mana_attack = self.mana_attack_2
    end
    if self.level >= 70 then
        self.attack_grow_max = self.attack_grow_max_7
    end
end

function modifier_item_hd_godfire_effects:CheckState()
    if self.level >= 20 and not self:GetParent():IsInSpecialAttack() then
        return{
            [MODIFIER_STATE_CANNOT_MISS] = true,
        }
    end
    return
end

function modifier_item_hd_godfire_effects:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_item_hd_godfire_effects:Advanced_GetModifierBaseDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_item_hd_godfire_effects:Advanced_GetModifierPreAttack_BonusDamage() 
    return  self.mana_attack*self:GetParent():GetMaxMana() + self:GetStackCount()
end


function modifier_item_hd_godfire_effects:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_hd_godfire_effects:GetModifierPreAttack_BonusDamagePostCrit(params) 
	return self.bonus_attack * self:GetParent():GetAverageTrueAttackDamage(nil)
end

function modifier_item_hd_godfire_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self:GetParent() then return end
    if target:GetTeamNumber() == attacker:GetTeamNumber() then return end
    
end

function modifier_item_hd_godfire_effects:OnDeath(keys)
    if not IsServer() then return end
    if self.level < 40 then return end
    if self.level < 70 and keys.attacker ~= self:GetParent() then return end
    
    local count = 1
    if self.level >= 70 then
        count = count*2
    end
    
    if self.level >= 100  then
        self:SetStackCount(math.max(self:GetStackCount(), self.stack_10))
        if keys.unit:IsChaoticEraElite() then
            count = count*self.index_10
        end
    end

    self:SetStackCount(math.min(self:GetStackCount()+count ,self.attack_grow_max))
end
