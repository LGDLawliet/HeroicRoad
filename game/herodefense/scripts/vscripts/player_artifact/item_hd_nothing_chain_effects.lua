-- 重做完成
item_hd_nothing_chain_effects = class({})
LinkLuaModifier("modifier_item_hd_nothing_chain_effects", "player_artifact/item_hd_nothing_chain_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_nothing_chain_effects_lv20", "player_artifact/item_hd_nothing_chain_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_nothing_chain_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_nothing_chain_effects"
end

modifier_item_hd_nothing_chain_effects = advanced_modifier({})

function modifier_item_hd_nothing_chain_effects:IsDebuff() return false end
function modifier_item_hd_nothing_chain_effects:IsHidden()
    return (self.level < 20)
end
function modifier_item_hd_nothing_chain_effects:IsPurgable() return false end
function modifier_item_hd_nothing_chain_effects:GetTexture() return "item_artifact_41" end
function modifier_item_hd_nothing_chain_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_nothing_chain_effects")
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.cost_down = self.ability:GetArtifactSpecialValueFor("cost_down")
    self.cost_down_1 = self.ability:GetArtifactSpecialValueFor("cost_down_1")
    self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost")*0.01
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")*0.01
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.mana_3 = self.ability:GetArtifactSpecialValueFor("mana_3")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.mana_7 = self.ability:GetArtifactSpecialValueFor("mana_7")
    self.chance_10 = self.ability:GetArtifactSpecialValueFor("chance_10")
    if self.level >= 10 then
        self.cost_down = self.cost_down_1
    end
    if self.level >= 30 then
        self.bonus_mana = self.bonus_mana + self.mana_3
    end
end

function modifier_item_hd_nothing_chain_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_nothing_chain_effects")
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.cost_down = self.ability:GetArtifactSpecialValueFor("cost_down")
    self.cost_down_1 = self.ability:GetArtifactSpecialValueFor("cost_down_1")
    self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost")*0.01
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")*0.01
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.mana_3 = self.ability:GetArtifactSpecialValueFor("mana_3")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.mana_7 = self.ability:GetArtifactSpecialValueFor("mana_7")
    self.chance_10 = self.ability:GetArtifactSpecialValueFor("chance_10")
    if self.level >= 10 then
        self.cost_down = self.cost_down_1
    end
    if self.level >= 30 then
        self.bonus_mana = self.bonus_mana + self.mana_3
    end
end

function modifier_item_hd_nothing_chain_effects:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE
    }
end
function modifier_item_hd_nothing_chain_effects:GetModifierExtraManaPercentage()
    if self.level < 70 then return 0 end
    return self.mana_7
end
function modifier_item_hd_nothing_chain_effects:GetModifierPercentageManacostStacking()
    return self.cost_down
end

function modifier_item_hd_nothing_chain_effects:OnAbilityExecuted(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    local caster = keys.unit
    local ability = keys.ability
    if ability == nil or ability:IsItem() or ability:IsToggle() then return end
    if not caster:IsAlive() then return end
    local hp_cost = caster:GetHealth()*self.hp_cost
    caster:ModifyHealth(caster:GetHealth()-hp_cost, self:GetAbility(), false, 0)
    
    if self.level >= 20 then
        self:SetStackCount(self:GetStackCount() + hp_cost)
        local line = caster:GetMaxHealth()*self.line_2
        if self:GetStackCount() >= line or (self.level >= 100 and self.chance_10 >= math.random(1,100)) then
            self:SetStackCount(0)
            local newbuff = caster:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_nothing_chain_effects_lv20",{duration = self.duration_2})
            newbuff:SetStackCount(0)
            if self.level >= 100 and newbuff then
                newbuff:SetStackCount(1)
            end
        end
    end
    if self.level >= 40 then
        local mp_regen = self.index_4*hp_cost
        caster:GiveMana(mp_regen)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, mp_regen, nil)
    end

end

function modifier_item_hd_nothing_chain_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
    return funcs
end

function modifier_item_hd_nothing_chain_effects:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end


modifier_item_hd_nothing_chain_effects_lv20 = advanced_modifier({})

function modifier_item_hd_nothing_chain_effects_lv20:IsDebuff() return false end
function modifier_item_hd_nothing_chain_effects_lv20:IsHidden() return false end
function modifier_item_hd_nothing_chain_effects_lv20:IsPurgable() return false end
function modifier_item_hd_nothing_chain_effects_lv20:GetTexture() return "item_artifact_41" end

function modifier_item_hd_nothing_chain_effects_lv20:OnCreated()
    self.cd_reduce = self:GetAbility():GetArtifactSpecialValueFor("cds_2")*0.01*0.5
    self.spell_amp = self:GetAbility():GetArtifactSpecialValueFor("spell_10")
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end
function modifier_item_hd_nothing_chain_effects_lv20:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_nothing_chain_effects_lv20:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then self:Destroy() return end
    return self:GetStackCount()*self.spell_amp
end
function modifier_item_hd_nothing_chain_effects_lv20:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    local hero = self:GetParent()
    for i=0, hero:GetAbilityCount() - 1 do
		local Ability = hero:GetAbilityByIndex(i)
		if Ability ~= nil and (not Ability:IsCooldownReady()) and Ability:IsRefreshable() then
			if Ability ~= self:GetAbility()	then
				local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - self.cd_reduce,0)
				Ability:EndCooldown()
				Ability:StartCooldown(new_cooldown)
			end
		end
	end
end