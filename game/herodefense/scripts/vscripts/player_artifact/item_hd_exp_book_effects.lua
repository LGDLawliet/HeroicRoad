-- 重写完成
item_hd_exp_book_effects = class({})
LinkLuaModifier("modifier_item_hd_exp_book_effects", "player_artifact/item_hd_exp_book_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_exp_book_effects_stationary", "player_artifact/item_hd_exp_book_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_exp_book_effects_block", "player_artifact/item_hd_exp_book_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_exp_book_effects_outgoing", "player_artifact/item_hd_exp_book_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_exp_book_effects_100_check", "player_artifact/item_hd_exp_book_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_exp_book_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_exp_book_effects"
end

modifier_item_hd_exp_book_effects_100_check = advanced_modifier({})

function modifier_item_hd_exp_book_effects_100_check:IsDebuff() return false end
function modifier_item_hd_exp_book_effects_100_check:IsHidden() return true end
function modifier_item_hd_exp_book_effects_100_check:IsPurgable() return false end
function modifier_item_hd_exp_book_effects_100_check:RemoveOnDeath() return false end
function modifier_item_hd_exp_book_effects_100_check:DestroyOnExpire() return false end

modifier_item_hd_exp_book_effects = advanced_modifier({})

function modifier_item_hd_exp_book_effects:IsDebuff() return false end
function modifier_item_hd_exp_book_effects:IsHidden() return false end
function modifier_item_hd_exp_book_effects:IsPurgable() return false end
function modifier_item_hd_exp_book_effects:RemoveOnDeath() return false end
function modifier_item_hd_exp_book_effects:GetTexture() return "item_artifact_68" end
function modifier_item_hd_exp_book_effects:DestroyOnExpire() return false end

function modifier_item_hd_exp_book_effects:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.check1 = self.ability:GetArtifactSpecialValueFor("check1")
    self.check2 = self.ability:GetArtifactSpecialValueFor("check2")
    self.check3 = self.ability:GetArtifactSpecialValueFor("check3")
    self.check4 = self.ability:GetArtifactSpecialValueFor("check4")
    self.block = self.ability:GetArtifactSpecialValueFor("block")
    self.gold = self.ability:GetArtifactSpecialValueFor("gold")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.maxhp_regen = self.ability:GetArtifactSpecialValueFor("maxhp_regen")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_exp_book_effects")
    
    -- Additional effects
    self.maxmp_regen_1 = self.ability:GetArtifactSpecialValueFor("maxmp_regen_1")
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3")
    self.exp_4 = self.ability:GetArtifactSpecialValueFor("exp_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.stack_10 = self.ability:GetArtifactSpecialValueFor("stack_10")
    self:SetStackCount(0)
    if self.level >= 70 then
        self.chance_2 = self.chance_7 
    end
    if self.level >= 100 then
        self:SetStackCount(self.stack_10)
        if IsServer() then
            if self.parent:IsAlive() and not self.parent:HasModifier("modifier_item_hd_exp_book_effects_100_check") then
                self.parent:HeroLevelUp(true)
                self.parent:AddNewModifier(self.parent, nil, "modifier_item_hd_exp_book_effects_100_check", {})
            end
        end
    end
    
    
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_exp_book_effects:OnRefresh()
     self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.check1 = self.ability:GetArtifactSpecialValueFor("check1")
    self.check2 = self.ability:GetArtifactSpecialValueFor("check2")
    self.check3 = self.ability:GetArtifactSpecialValueFor("check3")
    self.check4 = self.ability:GetArtifactSpecialValueFor("check4")
    self.block = self.ability:GetArtifactSpecialValueFor("block")
    self.gold = self.ability:GetArtifactSpecialValueFor("gold")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.maxhp_regen = self.ability:GetArtifactSpecialValueFor("maxhp_regen")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_exp_book_effects")
    
    self.maxmp_regen_1 = self.ability:GetArtifactSpecialValueFor("maxmp_regen_1")
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3")
    self.exp_4 = self.ability:GetArtifactSpecialValueFor("exp_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.stack_10 = self.ability:GetArtifactSpecialValueFor("stack_10")
    if self.level >= 70 then
        self.chance_2 = self.chance_7 
    end
    if self.level >= 100 then
        if IsServer() then
            if self.parent:IsAlive() and not self.parent:HasModifier("modifier_item_hd_exp_book_effects_100_check") then
                self.parent:HeroLevelUp(true)
                self.parent:AddNewModifier(self.parent, nil, "modifier_item_hd_exp_book_effects_100_check", {})
            end
        end
    end
end

function modifier_item_hd_exp_book_effects:OnIntervalThink()
    local parent = self:GetParent()
    if self.level >= 10 then
        if parent:GetVelocity():Length2D() < 1 then
            parent:AddNewModifier(parent, self.ability, "modifier_item_hd_exp_book_effects_stationary", {duration = 1})
        end
    end
end

function modifier_item_hd_exp_book_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_exp_book_effects:OnTooltip()
    return self:GetStackCount()
end

function modifier_item_hd_exp_book_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
    }
end


function modifier_item_hd_exp_book_effects:AdvancedGetModifierConstantHealthRegenPercentage()
    return self.maxhp_regen
end

function modifier_item_hd_exp_book_effects:OnChaoticEraRoundChange()
    if not IsServer() then return end
    
    local parent = self:GetParent()
    local current_stacks = self:GetStackCount()
    local random = math.random
    
    local stack_gain = 1
    
    if self.level >= 20 and self.chance_2 >= random(1,100) then
        stack_gain = 2
    end
    
    self:SetStackCount(current_stacks + stack_gain)
    
    if self:GetStackCount() >= self.check1 and not self.already_1 then
        parent:AddNewModifier(parent, nil, "modifier_item_hd_exp_book_effects_block", {value = self.block})
        self.already_1 = true
    end
    
    if self:GetStackCount() >= self.check2 and not self.already_2 then
        parent:ModifyGoldFiltered(self.gold, true, DOTA_ModifyGold_CreepKill)  --金币奖励
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self:GetParent(), self.gold, nil)
        self.already_2 = true
    end

    if self:GetStackCount() >= self.check3 and not self.already_3 then
        parent:AddNewModifier(parent, nil, "modifier_item_hd_exp_book_effects_outgoing", {value = self.outgoing})
        self.already_3 = true
    end

    if self.level >= 30 and self.chance_3 >= random(1,100) then
        parent:HeroLevelUp(true)
    end
end

-- Stationary modifier for additional_1 effect
modifier_item_hd_exp_book_effects_stationary = advanced_modifier({})

function modifier_item_hd_exp_book_effects_stationary:IsDebuff() return false end
function modifier_item_hd_exp_book_effects_stationary:IsHidden() return true end
function modifier_item_hd_exp_book_effects_stationary:IsPurgable() return false end

function modifier_item_hd_exp_book_effects_stationary:OnCreated()
    self.ability = self:GetAbility()
    self.maxmp_regen_1 = self.ability:GetArtifactSpecialValueFor("maxmp_regen_1")
    self.parent = self:GetParent()
end

function modifier_item_hd_exp_book_effects_stationary:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
    }
end

function modifier_item_hd_exp_book_effects_stationary:GetModifierTotalPercentageManaRegen()
    if not self:GetAbility() then return end
    if self.parent:IsMoving() then return 0 end
    return self.maxmp_regen_1
end 

------------
modifier_item_hd_exp_book_effects_block = advanced_modifier({})

function modifier_item_hd_exp_book_effects_block:IsDebuff() return false end
function modifier_item_hd_exp_book_effects_block:IsHidden() return false end
function modifier_item_hd_exp_book_effects_block:IsPurgable() return false end
function modifier_item_hd_exp_book_effects_block:RemoveOnDeath() return false end
function modifier_item_hd_exp_book_effects_block:GetTexture() return "item_artifact_68" end
function modifier_item_hd_exp_book_effects_block:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.value)
    end
end

function modifier_item_hd_exp_book_effects_block:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
	}
    return funcs
end

function modifier_item_hd_exp_book_effects_block:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

	return self:GetStackCount()
end
------------
modifier_item_hd_exp_book_effects_outgoing = advanced_modifier({})

function modifier_item_hd_exp_book_effects_outgoing:IsDebuff() return false end
function modifier_item_hd_exp_book_effects_outgoing:IsHidden() return false end
function modifier_item_hd_exp_book_effects_outgoing:IsPurgable() return false end
function modifier_item_hd_exp_book_effects_outgoing:RemoveOnDeath() return false end
function modifier_item_hd_exp_book_effects_outgoing:GetTexture() return "item_artifact_68" end
function modifier_item_hd_exp_book_effects_outgoing:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.value)
    end
end

function modifier_item_hd_exp_book_effects_outgoing:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
    return funcs
end

function modifier_item_hd_exp_book_effects_outgoing:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
    return self:GetStackCount()
end