      
item_chaotic_blight_stone = class({})
LinkLuaModifier("modifier_item_chaotic_blight_stone", "items/item_chaotic_blight_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_blight_stone_active", "items/item_chaotic_blight_stone", LUA_MODIFIER_MOTION_NONE)


function item_chaotic_blight_stone:GetIntrinsicModifierName()
	return "modifier_item_chaotic_blight_stone"
end

modifier_item_chaotic_blight_stone = advanced_modifier({})

function modifier_item_chaotic_blight_stone:IsDebuff() return false end
function modifier_item_chaotic_blight_stone:IsHidden() return true end
function modifier_item_chaotic_blight_stone:IsPurgable() return false end
function modifier_item_chaotic_blight_stone:OnCreated(keys)
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
end


function modifier_item_chaotic_blight_stone:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},                           --攻击事件
	}
end

function modifier_item_chaotic_blight_stone:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindModifierByName("modifier_item_chaotic_blight_stone_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.duration, true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_chaotic_blight_stone_active", {duration = self.duration})
			end
		end
	end
end

--modifier2:敌人身上的减甲----------------------------------------
modifier_item_chaotic_blight_stone_active = advanced_modifier({})

function modifier_item_chaotic_blight_stone_active:IsDebuff() return true end
function modifier_item_chaotic_blight_stone_active:IsHidden() return false end
function modifier_item_chaotic_blight_stone_active:IsPurgable() return false end
function modifier_item_chaotic_blight_stone_active:GetTexture()return "item_blight_stone" end

function modifier_item_chaotic_blight_stone_active:OnCreated(keys)
	self.ability = self:GetAbility()
	self.armor_down = self.ability:GetSpecialValueFor("armor_down")
end


function modifier_item_chaotic_blight_stone_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_chaotic_blight_stone_active:Advanced_GetModifierPhysicalArmorBonus(keys)
	if not self:GetAbility() then self:Destroy() return end
	return -self.armor_down
end





    