item_hd_qingnan_sheet = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_qingnan_sheet", "items/item_hd_qingnan_sheet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_qingnan_sheet_active", "items/item_hd_qingnan_sheet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_qingnan_sheet_active_2", "items/item_hd_qingnan_sheet", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
function item_hd_qingnan_sheet:GetIntrinsicModifierName()
	return "modifier_item_hd_qingnan_sheet"
end
----------------------

modifier_item_hd_qingnan_sheet = advanced_modifier({})

function modifier_item_hd_qingnan_sheet:IsDebuff() return false end
function modifier_item_hd_qingnan_sheet:IsHidden() return true end
function modifier_item_hd_qingnan_sheet:IsPurgable() return false end

function modifier_item_hd_qingnan_sheet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
end

-- advanced_modifier
function modifier_item_hd_qingnan_sheet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end

function modifier_item_hd_qingnan_sheet:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if not self:GetAbility():IsCooldownReady() then
            return
        end
        keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_qingnan_sheet_active", {})
        --print("添加成功")
        self:GetAbility():UseResources(true, true, true, true)
	end
end
function modifier_item_hd_qingnan_sheet:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end
--------------------------------------------------------------------------------------------------------------------------------
modifier_item_hd_qingnan_sheet_active = advanced_modifier({})

function modifier_item_hd_qingnan_sheet_active:IsDebuff() return false end
function modifier_item_hd_qingnan_sheet_active:IsHidden() return true end
function modifier_item_hd_qingnan_sheet_active:IsPurgable() return false end
function modifier_item_hd_qingnan_sheet_active:GetEffectName() return "particles/items_fx/wand_of_the_brine_buff_bubble_outer.vpcf" end
function modifier_item_hd_qingnan_sheet_active:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end

function modifier_item_hd_qingnan_sheet_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = -self.ability:GetSpecialValueFor("active")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self:SetStackCount(1)
    
end
function modifier_item_hd_qingnan_sheet_active:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.active = -self.ability:GetSpecialValueFor("active")
	self.duration = self.ability:GetSpecialValueFor("duration")
    self:SetStackCount(1)

end

function modifier_item_hd_qingnan_sheet_active:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end


function modifier_item_hd_qingnan_sheet_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber()then
            return 0
        end
        if keys.target ~= self:GetParent() then
            return 0
        end
        if keys.damage<=50 then
            return 0
        end
        if keys.attacker == self:GetParent() then
            return 0
        end
        if self:GetStackCount()==1 then
            self:DecrementStackCount()
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_qingnan_sheet_active_2", {duration = self.duration})
           --print("减伤成功")
            return self.active
            
        else
            self:SafeDestroy()
		    return 0
        end
    end
end
------------------------------------------------------
modifier_item_hd_qingnan_sheet_active_2 = advanced_modifier({})

function modifier_item_hd_qingnan_sheet_active_2:IsDebuff() return false end
function modifier_item_hd_qingnan_sheet_active_2:IsHidden() return true end
function modifier_item_hd_qingnan_sheet_active_2:IsPurgable() return false end


function modifier_item_hd_qingnan_sheet_active_2:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = -self.ability:GetSpecialValueFor("active")
    
end
function modifier_item_hd_qingnan_sheet_active_2:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.active = -self.ability:GetSpecialValueFor("active")

end

function modifier_item_hd_qingnan_sheet_active_2:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end


function modifier_item_hd_qingnan_sheet_active_2:Advanced_GetModifierIncomingDamage_Percentage(keys)
    return self.active
end