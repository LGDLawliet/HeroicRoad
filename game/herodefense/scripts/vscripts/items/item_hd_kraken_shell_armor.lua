item_hd_kraken_shell_armor = class({})

LinkLuaModifier("modifier_item_hd_kraken_shell_armor", "items/item_hd_kraken_shell_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_kraken_shell_armor_active", "items/item_hd_kraken_shell_armor", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_kraken_shell_armor:GetIntrinsicModifierName()
	return "modifier_item_hd_kraken_shell_armor"
end



function item_hd_kraken_shell_armor:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf", context )

end





modifier_item_hd_kraken_shell_armor = advanced_modifier({})

function modifier_item_hd_kraken_shell_armor:IsDebuff() return false end
function modifier_item_hd_kraken_shell_armor:IsHidden() return true end
function modifier_item_hd_kraken_shell_armor:IsPurgable() return false end
function modifier_item_hd_kraken_shell_armor:IsPurgeException() return false end
function modifier_item_hd_kraken_shell_armor:RemoveOnDeath() return false end


function modifier_item_hd_kraken_shell_armor:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_armor =ability:GetSpecialValueFor("bonus_armor")
	self.bonus_health =ability:GetSpecialValueFor("bonus_health")
	if IsServer() then
		self.damage_record = 0
		self:StartIntervalThink(15)
	end
end
function modifier_item_hd_kraken_shell_armor:OnIntervalThink()
	if self.damage_record>0 then
		local parent = self:GetParent()
		parent:AddNewModifier(parent, self:GetParent(), "modifier_item_hd_kraken_shell_armor_active", {duration = 10,stack = self.damage_record*0.15})
		self.damage_record = 0
	end
end


function modifier_item_hd_kraken_shell_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,


	}
end


function modifier_item_hd_kraken_shell_armor:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_kraken_shell_armor:GetModifierPhysical_ConstantBlock(keys)
	self.damage_record = self.damage_record + keys.damage
	return 0
end

function modifier_item_hd_kraken_shell_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_kraken_shell_armor:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_kraken_shell_armor_active = advanced_modifier({})

function modifier_item_hd_kraken_shell_armor_active:IsDebuff() return false end
function modifier_item_hd_kraken_shell_armor_active:IsHidden() return false end
function modifier_item_hd_kraken_shell_armor_active:IsPurgable() return false end
function modifier_item_hd_kraken_shell_armor_active:GetTexture() return "item_book_of_death_2" end

function modifier_item_hd_kraken_shell_armor_active:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(math.min(keys.stack,self:GetParent():GetMaxHealth()*5))
	end

end

-- function modifier_item_hd_kraken_shell_armor_active:OnDestroy()
-- 	if IsServer() then
-- 		self:GetAbility():RemoveSummon(self:GetParent())
-- 	end

-- end

function modifier_item_hd_kraken_shell_armor_active:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(keys.stack+self:GetStackCount(),self:GetParent():GetMaxHealth()*5))
	end
end




function modifier_item_hd_kraken_shell_armor_active:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_item_hd_kraken_shell_armor_active:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return self:GetStackCount()
	end
	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end