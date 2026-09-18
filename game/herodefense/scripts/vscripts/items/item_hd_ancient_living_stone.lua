item_hd_ancient_living_stone = class({})

LinkLuaModifier("modifier_item_hd_ancient_living_stone", "items/item_hd_ancient_living_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ancient_living_stone_active", "items/item_hd_ancient_living_stone", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ancient_living_stone:GetIntrinsicModifierName()
	return "modifier_item_hd_ancient_living_stone"
end

function item_hd_ancient_living_stone:OnSpellStart()
	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_hd_ancient_living_stone_active") then
		return
	end
	caster:EmitSound("ui.npe_objective_given")
	caster:AddNewModifier(caster, self, "modifier_item_hd_ancient_living_stone_active", {})
	self:SpendCharge(0)
end






modifier_item_hd_ancient_living_stone = advanced_modifier({})

function modifier_item_hd_ancient_living_stone:IsDebuff() return false end
function modifier_item_hd_ancient_living_stone:IsHidden() return true end
function modifier_item_hd_ancient_living_stone:IsPurgable() 		return false end
function modifier_item_hd_ancient_living_stone:IsPurgeException() 	return false end
function modifier_item_hd_ancient_living_stone:RemoveOnDeath()  return false end



function modifier_item_hd_ancient_living_stone:OnCreated(keys)
    self.ability = self:GetAbility()

 


    if IsServer() then

		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_ancient_living_stone:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsInDayTime() then
			self:SetStackCount(1)
		else
			self:SetStackCount(2)
		end
	end
end


function modifier_item_hd_ancient_living_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_ancient_living_stone:GetModifierBonusStats_Strength()	return self:GetStackCount()==2 and 50 or 0  end
function modifier_item_hd_ancient_living_stone:GetModifierBonusStats_Intellect()	return self:GetStackCount()==2 and 50 or 0   end
function modifier_item_hd_ancient_living_stone:GetModifierBonusStats_Agility()	return self:GetStackCount()==2 and 50 or 0   end

-- advanced_modifier
function modifier_item_hd_ancient_living_stone:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end

function modifier_item_hd_ancient_living_stone:AdvancedGetModifierConstantHealthRegen()
    return  self:GetStackCount()==1 and 150 or 0
end
function modifier_item_hd_ancient_living_stone:AdvancedGetModifierConstantManaRegen()
    return  self:GetStackCount()==1 and 30 or 0
end



modifier_item_hd_ancient_living_stone_active = advanced_modifier({})

function modifier_item_hd_ancient_living_stone_active:IsDebuff() return false end
function modifier_item_hd_ancient_living_stone_active:IsHidden() return false end
function modifier_item_hd_ancient_living_stone_active:IsPurgable() 		return false end
function modifier_item_hd_ancient_living_stone_active:IsPurgeException() 	return false end
function modifier_item_hd_ancient_living_stone_active:RemoveOnDeath()  return false end
function modifier_item_hd_ancient_living_stone_active:GetTexture() return "item_ancient_living_stone" end


function modifier_item_hd_ancient_living_stone_active:OnCreated(keys)
    self.ability = self:GetAbility()

	self.attribute_bonus = 50*0.7
	self.health_regen = 150*0.7
	self.mana_regen = 30 *0.7


    if IsServer() then

		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_ancient_living_stone_active:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsInDayTime() then
			self:SetStackCount(1)
		else
			self:SetStackCount(2)
		end
	end
end


function modifier_item_hd_ancient_living_stone_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}
end


function modifier_item_hd_ancient_living_stone_active:GetModifierBonusStats_Strength()	return self:GetStackCount()==2 and self.attribute_bonus or 0  end
function modifier_item_hd_ancient_living_stone_active:GetModifierBonusStats_Intellect()	return self:GetStackCount()==2 and self.attribute_bonus or 0   end
function modifier_item_hd_ancient_living_stone_active:GetModifierBonusStats_Agility()	return self:GetStackCount()==2 and self.attribute_bonus or 0   end



function modifier_item_hd_ancient_living_stone_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end

function modifier_item_hd_ancient_living_stone_active:AdvancedGetModifierConstantHealthRegen()
    return self:GetStackCount()==1 and self.health_regen or 0
end
function modifier_item_hd_ancient_living_stone_active:AdvancedGetModifierConstantManaRegen()
    return self:GetStackCount()==1 and self.mana_regen or 0  
end
