item_hd_onlyone_effects = class({})
LinkLuaModifier("modifier_item_hd_onlyone_effects", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_both", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_i", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_s", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_lv70", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_lv30", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_lv40", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_onlyone_effects_lv100", "player_artifact/item_hd_onlyone_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_onlyone_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_onlyone_effects"
end

function item_hd_onlyone_effects:OnHeroLevelUp()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName("modifier_item_hd_onlyone_effects")
    if modifier then
        modifier:SetStackCount(math.max(modifier.levelneed - caster:GetLevel(), 0))
    end
end

modifier_item_hd_onlyone_effects = advanced_modifier({})

function modifier_item_hd_onlyone_effects:IsDebuff() return false end
function modifier_item_hd_onlyone_effects:IsHidden() return false end
function modifier_item_hd_onlyone_effects:IsPurgable() return false end
function modifier_item_hd_onlyone_effects:GetTexture() return "item_artifact_72" end
function modifier_item_hd_onlyone_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.levelneed = self.ability:GetArtifactSpecialValueFor("level")
    self.levelneed2 = self.ability:GetArtifactSpecialValueFor("level_2")
    self.bonus = self.ability:GetArtifactSpecialValueFor("bonus")*0.01
    self.bonus_7 = self.ability:GetArtifactSpecialValueFor("bonus_7")*0.01

    self.all = self.ability:GetArtifactSpecialValueFor("all")
    self.maxhp_regen_needlv = self.ability:GetArtifactSpecialValueFor("maxhp_regen_needlv")
    self.maxmp_regen_needlv = self.ability:GetArtifactSpecialValueFor("maxmp_regen_needlv")*0.01
    self.armor_needlv = self.ability:GetArtifactSpecialValueFor("armor_needlv")
    self.damage_needlv = self.ability:GetArtifactSpecialValueFor("damage_needlv")
    self.spell_amp_needlv = self.ability:GetArtifactSpecialValueFor("spell_amp_needlv")
    self.atb_10 = self.ability:GetArtifactSpecialValueFor("atb_10")

	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_onlyone_effects")
	
    if self.level >= 20 then
        self.levelneed = self.levelneed2
        if self.level >= 70 then
            self.bonus = self.bonus_7
        end
    end

    if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_marci_3") then
       self.all = self.all *0.33 
       self.maxhp_regen_needlv = self.maxhp_regen_needlv *0.33
       self.maxmp_regen_needlv = self.maxmp_regen_needlv *0.33
       self.armor_needlv = self.armor_needlv *0.33
       self.damage_needlv = self.damage_needlv *0.33
       self.spell_amp_needlv = self.spell_amp_needlv *0.33
    end

    self:SetStackCount(math.max(self.levelneed - self.parent:GetLevel(), 0))
end

function modifier_item_hd_onlyone_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.levelneed = self.ability:GetArtifactSpecialValueFor("level")
    self.levelneed2 = self.ability:GetArtifactSpecialValueFor("level_2")
    self.bonus = self.ability:GetArtifactSpecialValueFor("bonus")*0.01
    self.bonus_7 = self.ability:GetArtifactSpecialValueFor("bonus_7")*0.01

    self.all = self.ability:GetArtifactSpecialValueFor("all")
    self.maxhp_regen_needlv = self.ability:GetArtifactSpecialValueFor("maxhp_regen_needlv")
    self.maxmp_regen_needlv = self.ability:GetArtifactSpecialValueFor("maxmp_regen_needlv")*0.01
    self.armor_needlv = self.ability:GetArtifactSpecialValueFor("armor_needlv")
    self.damage_needlv = self.ability:GetArtifactSpecialValueFor("damage_needlv")
    self.spell_amp_needlv = self.ability:GetArtifactSpecialValueFor("spell_amp_needlv")
    self.atb_10 = self.ability:GetArtifactSpecialValueFor("atb_10")

	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_onlyone_effects")
	
    if self.level >= 20 then
        self.levelneed = self.levelneed2
        if self.level >= 70 then
            self.bonus = self.bonus_7
        end
    end

    if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_marci_3") then
       self.all = self.all *0.33 
       self.maxhp_regen_needlv = self.maxhp_regen_needlv *0.33
       self.maxmp_regen_needlv = self.maxmp_regen_needlv *0.33
       self.armor_needlv = self.armor_needlv *0.33
       self.damage_needlv = self.damage_needlv *0.33
       self.spell_amp_needlv = self.spell_amp_needlv *0.33
    end

    self:SetStackCount(math.max(self.levelneed - self.parent:GetLevel(), 0))
end

function modifier_item_hd_onlyone_effects:GoodBye()
    if not IsServer() then return end
    local parent = self:GetParent()
    if self.level >= 100 and not parent:HasModifier("modifier_item_hd_onlyone_effects_lv100") then
        parent:AddNewModifier(parent, nil, "modifier_item_hd_onlyone_effects_lv100", {stack = parent:GetLevel()*self.atb_10})
    end
end

function modifier_item_hd_onlyone_effects:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
end

function modifier_item_hd_onlyone_effects:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierBonusStats_Strength()
	return (1+self:GetStackCount()*self.bonus) *self.all
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierBonusStats_Agility()
	return (1+self:GetStackCount()*self.bonus) *self.all
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierBonusStats_Intellect()
	return (1+self:GetStackCount()*self.bonus) *self.all
end
function modifier_item_hd_onlyone_effects:AdvancedGetModifierConstantHealthRegenPercentage()
    if self.level < 10 then return 0 end
	return (1+self:GetStackCount()*self.bonus) *self.maxhp_regen_needlv
end
function modifier_item_hd_onlyone_effects:GetModifierConstantManaRegen()
    if self.level < 10 then return 0 end
	return (1+self:GetStackCount()*self.bonus) *self.maxmp_regen_needlv*self.parent:GetMaxMana()
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierPhysicalArmorBonus()
    if self.level < 30 then return 0 end
	return (1+self:GetStackCount()*self.bonus) *self.armor_needlv
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if self.level < 40 then return 0 end
	return (1+self:GetStackCount()*self.bonus) *self.damage_needlv
end
function modifier_item_hd_onlyone_effects:Advanced_GetModifierSpellAmplifyBonus()
    if self.level < 40 then return 0 end
	return (1+self:GetStackCount()*self.bonus) *self.spell_amp_needlv
end
function modifier_item_hd_onlyone_effects:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 6 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
    if self._tooltip == 2 then
        return self:AdvancedGetModifierConstantHealthRegenPercentage()
    end
    if self._tooltip == 3 then
        return (1+self:GetStackCount()*self.bonus) *self.maxmp_regen_needlv*100
    end
    if self._tooltip == 4 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
    end
    if self._tooltip == 5 then
        return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    end
    if self._tooltip == 6 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
    end
end


---
modifier_item_hd_onlyone_effects_lv100 = advanced_modifier({})

function modifier_item_hd_onlyone_effects_lv100:IsDebuff() return false end
function modifier_item_hd_onlyone_effects_lv100:IsHidden() return false end
function modifier_item_hd_onlyone_effects_lv100:IsPurgable() return false end
function modifier_item_hd_onlyone_effects_lv100:IsPurgeException() return false end
function modifier_item_hd_onlyone_effects_lv100:RemoveOnDeath() return false end
function modifier_item_hd_onlyone_effects_lv100:GetTexture() return "item_artifact_72" end
function modifier_item_hd_onlyone_effects_lv100:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    if not IsServer() then return end
    self:SetStackCount(keys.stack)
    self.parent:HeroLevelUp(true)
end

function modifier_item_hd_onlyone_effects_lv100:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_hd_onlyone_effects_lv100:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOOLTIP,

	}
end
function modifier_item_hd_onlyone_effects_lv100:Advanced_GetModifierBonusStats_Strength()
	return self:GetStackCount()
end
function modifier_item_hd_onlyone_effects_lv100:Advanced_GetModifierBonusStats_Agility()
	return self:GetStackCount()
end
function modifier_item_hd_onlyone_effects_lv100:Advanced_GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_item_hd_onlyone_effects_lv100:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
end
