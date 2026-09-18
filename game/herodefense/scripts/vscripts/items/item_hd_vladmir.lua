item_hd_vladmir = class({})
LinkLuaModifier("modifier_item_hd_vladmir_arua", "items/item_hd_vladmir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vladmir", "items/item_hd_vladmir", LUA_MODIFIER_MOTION_NONE)

function item_hd_vladmir:GetIntrinsicModifierName()
	return "modifier_item_hd_vladmir_arua"
end

modifier_item_hd_vladmir_arua = advanced_modifier({})

function modifier_item_hd_vladmir_arua:IsHidden() return false end
function modifier_item_hd_vladmir_arua:IsAura() return true end
--function modifier_item_hd_vladmir_arua:GetAuraDuration() return 0.5 end
function modifier_item_hd_vladmir_arua:RemoveOnDeath() return false end
function modifier_item_hd_vladmir_arua:GetModifierAura() return "modifier_item_hd_vladmir" end
function modifier_item_hd_vladmir_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_item_hd_vladmir_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_hd_vladmir_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_vladmir_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_vladmir_arua:GetTexture()return "item_vladmir" end

function modifier_item_hd_vladmir_arua:OnCreated()
	self.ability = self:GetAbility()
    self.caster = self:GetCaster()
	self.line = self.ability:GetSpecialValueFor("line")
	if IsServer() then
		self:StartIntervalThink(2)
	end
end

function modifier_item_hd_vladmir_arua:OnIntervalThink()
	
	for itemSlot = 0, 5 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == "item_hd_vladmir" then 
			if self:GetStackCount() >= self.line then
				UTIL_RemoveImmediate(item) --removeitem的暂时替代
				self:GetCaster():AddItemByName("item_hd_vladmir_2")
				break
			end
		end
	end
end

----------------------------------------------------------------------
modifier_item_hd_vladmir = advanced_modifier({})

function modifier_item_hd_vladmir:IsDebuff() return false end
function modifier_item_hd_vladmir:IsHidden() return false end
function modifier_item_hd_vladmir:IsPurgable() return false end
function modifier_item_hd_vladmir:GetTexture()return "item_vladmir" end


function modifier_item_hd_vladmir:OnCreated(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
	self.steal = self.ability:GetSpecialValueFor("steal")  --在这里先计算就不用每次攻击都浪费一次计算了
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_item_hd_vladmir:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end

function modifier_item_hd_vladmir:Advanced_GetModifier_LifeSteal_AttackDamage()
	return self.steal
end

function modifier_item_hd_vladmir:Advanced_GetModifierDamageOutgoing_Percentage() 
	return self.bonus_attack 
end

function modifier_item_hd_vladmir:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_hd_vladmir:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetCaster() then
		return
	end

	local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_vladmir_arua")
	if modifier then
		modifier:SetStackCount(modifier:GetStackCount() + 1)
	end

end