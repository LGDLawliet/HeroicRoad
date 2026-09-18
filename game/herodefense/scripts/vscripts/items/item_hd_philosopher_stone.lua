item_hd_philosopher_stone = class({})

LinkLuaModifier("modifier_item_hd_philosopher_stone", "items/item_hd_philosopher_stone", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_philosopher_stone:GetIntrinsicModifierName()
	return "modifier_item_hd_philosopher_stone"
end


modifier_item_hd_philosopher_stone = class({})

function modifier_item_hd_philosopher_stone:IsDebuff() return false end
function modifier_item_hd_philosopher_stone:IsHidden() return false end
function modifier_item_hd_philosopher_stone:IsPurgable() return false end
function modifier_item_hd_philosopher_stone:IsPurgeException()return false end
function modifier_item_hd_philosopher_stone:RemoveOnDeath() return false end
function modifier_item_hd_philosopher_stone:GetTexture() return "item_philosopher_stone" end
function modifier_item_hd_philosopher_stone:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_mana =ability:GetSpecialValueFor("bonus_mana")
    if IsServer() then
		self:StartIntervalThink(0.3)
	end
end



function modifier_item_hd_philosopher_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,       
		MODIFIER_PROPERTY_TOOLTIP      

	}
end


function modifier_item_hd_philosopher_stone:GetModifierExtraManaPercentage()	return self.bonus_mana   end
function modifier_item_hd_philosopher_stone:OnTooltip()	return self:GetStackCount()   end




function modifier_item_hd_philosopher_stone:OnIntervalThink()
	local parent = self:GetParent()
	local maxMana = parent:GetMaxMana()
    if parent:GetManaPercent()>90 then
		local stack = self:GetStackCount()
		if stack>=maxMana*10 then
			return
		end
		local mana = parent:GetMana()
		local gain = mana-maxMana*0.9
        self:GetParent():SetMana(maxMana*0.9)
		self:SetStackCount(math.min(stack+gain,maxMana*10))
	elseif parent:GetManaPercent()<50 then
		local stack = self:GetStackCount()
		if stack<=0 then
			return
		end
		local mana = parent:GetMana()
		local limit = maxMana*0.5
		local gain = math.min(limit-mana,stack)
		parent:GiveMana(gain)
		self:SetStackCount(stack-gain)
    end
end