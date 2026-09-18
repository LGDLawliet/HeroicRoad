LinkLuaModifier("modifier_item_hd_enhancement_wise", "items/item_hd_enhancement_wise", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_enhancement_wise_buff", "items/item_hd_enhancement_wise", LUA_MODIFIER_MOTION_NONE)
item_hd_enhancement_wise = class({})

function item_hd_enhancement_wise:GetIntrinsicModifierName()
    return "modifier_item_hd_enhancement_wise"
end

function item_hd_enhancement_wise:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSoundParams( "Hero_ShadowDemon.Soul_Catcher", 0, 0.5, 0 )

	local buff = caster:FindModifierByName("modifier_item_hd_enhancement_wise_buff")
	if buff then
		buff:SetStackCount(buff:GetStackCount() + self:GetSpecialValueFor("eat_profic"))
	else
		local newbuff = caster:AddNewModifier(caster, nil, "modifier_item_hd_enhancement_wise_buff", {})
		newbuff:SetStackCount(self:GetSpecialValueFor("eat_profic"))
	end

	caster:HeroLevelUp(true)

	local item = caster:FindItemInInventory("item_hd_enhancement_wise")
    if item ~=nil then
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end
---------------------------------------------------------------------
modifier_item_hd_enhancement_wise_buff = advanced_modifier({})

function modifier_item_hd_enhancement_wise_buff:IsHidden()return false end
function modifier_item_hd_enhancement_wise_buff:IsPurgable()return false end
function modifier_item_hd_enhancement_wise_buff:RemoveOnDeath()return false end
function modifier_item_hd_enhancement_wise_buff:GetTexture() return "item_enhancement_wise" end

function modifier_item_hd_enhancement_wise_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_item_hd_enhancement_wise_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
    }
end

function modifier_item_hd_enhancement_wise_buff:Advanced_GetModifier_TalentEffectGain()
    return self:GetStackCount()
end
function modifier_item_hd_enhancement_wise_buff:OnTooltip()
    return self:GetStackCount()
end


---------------------------------------------------------------------
modifier_item_hd_enhancement_wise = advanced_modifier({})

function modifier_item_hd_enhancement_wise:IsHidden()return true end
function modifier_item_hd_enhancement_wise:IsPurgable()return false end

function modifier_item_hd_enhancement_wise:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.all_attribute = self.ability:GetSpecialValueFor("all_attribute")
end

-- function modifier_item_hd_enhancement_wise:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_EVASION_CONSTANT,
--     }
-- end

function modifier_item_hd_enhancement_wise:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end

function modifier_item_hd_enhancement_wise:Advanced_GetModifierBonusStats_Strength()
    return self.all_attribute
end
function modifier_item_hd_enhancement_wise:Advanced_GetModifierBonusStats_Agility()
    return  self.all_attribute
end
function modifier_item_hd_enhancement_wise:Advanced_GetModifierBonusStats_Intellect()
    return self.all_attribute
end
function modifier_item_hd_enhancement_wise:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end

--
-- modifier_item_hd_enhancement_wise_buff = advanced_modifier({})

-- function modifier_item_hd_enhancement_wise_buff:IsHidden()return false end
-- function modifier_item_hd_enhancement_wise_buff:IsPurgable()return false end

-- function modifier_item_hd_enhancement_wise_buff:OnCreated()
--     self.parent = self:GetParent()
--     self.ability = self:GetAbility()
--     self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
-- end

-- -- function modifier_item_hd_enhancement_wise:DeclareFunctions()
-- --     return{
-- --         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
-- --     }
-- -- end

-- function modifier_item_hd_enhancement_wise_buff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
--     }
-- end

-- function modifier_item_hd_enhancement_wise_buff:Advanced_GetModifier_TalentEffectGain()
-- 	if not self:GetAbility() then self:Destroy() return end
--     return self.bonus_profic
-- end


