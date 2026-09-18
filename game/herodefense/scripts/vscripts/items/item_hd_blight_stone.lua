      
item_hd_blight_stone = class({})
LinkLuaModifier("modifier_item_hd_blight_stone", "items/item_hd_blight_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blight_stone_active", "items/item_hd_blight_stone", LUA_MODIFIER_MOTION_NONE)


function item_hd_blight_stone:GetIntrinsicModifierName()
	return "modifier_item_hd_blight_stone"
end
--modifier1:枯萎之石人物本体减甲------------------------
modifier_item_hd_blight_stone = class({})

function modifier_item_hd_blight_stone:IsDebuff() return false end
function modifier_item_hd_blight_stone:IsHidden() return true end
function modifier_item_hd_blight_stone:IsPurgable() return false end
function modifier_item_hd_blight_stone:OnCreated(keys)
	self.ability = self:GetAbility()
	self.debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")
end


function modifier_item_hd_blight_stone:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,                           --攻击事件
	}
end

function modifier_item_hd_blight_stone:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() then
			local modifier = keys.target:FindModifierByName("modifier_item_hd_blight_stone_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self.debuff_duration, true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_blight_stone_active", {duration = self.debuff_duration})
			end
		end
	end
end

--modifier2:敌人身上的减甲----------------------------------------
modifier_item_hd_blight_stone_active = advanced_modifier({})

function modifier_item_hd_blight_stone_active:IsDebuff() return true end
function modifier_item_hd_blight_stone_active:IsHidden() return false end
function modifier_item_hd_blight_stone_active:IsPurgable() return true end
function modifier_item_hd_blight_stone_active:GetTexture()return "item_blight_stone" end
function modifier_item_hd_blight_stone_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_blight_stone_active:OnCreated(keys)
	self.ability = self:GetAbility()
	self.bonus_armor_reduce_enemy = -self.ability:GetSpecialValueFor("bonus_armor_reduce_enemy")
	self:StartIntervalThink(1)
end

function modifier_item_hd_blight_stone_active:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_presence_of_the_dark_lord") or self:GetCaster():FindAbilityByName("Middle_presence_of_the_dark_lord") or self:GetCaster():FindAbilityByName("Advanced_presence_of_the_dark_lord") then
		self.bonus_armor_reduce_enemy = -(self.ability:GetSpecialValueFor("bonus_armor_reduce_enemy") +self.ability:GetSpecialValueFor("bonus_armor_reduce_enemy_extra"))
	else
		self.bonus_armor_reduce_enemy = -self.ability:GetSpecialValueFor("bonus_armor_reduce_enemy")
	end
end

function modifier_item_hd_blight_stone_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_hd_blight_stone_active:Advanced_GetModifierPhysicalArmorBonus(keys)
	if not self:GetAbility() then self:Destroy() return end
	return self.bonus_armor_reduce_enemy
end





    