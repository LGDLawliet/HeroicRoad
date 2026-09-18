item_hd_elven_tunic = class({})

LinkLuaModifier("modifier_item_hd_elven_tunic", "items/item_hd_elven_tunic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_elven_tunic_active", "items/item_hd_elven_tunic", LUA_MODIFIER_MOTION_NONE)

function item_hd_elven_tunic:GetIntrinsicModifierName()
	return "modifier_item_hd_elven_tunic"
end
function item_hd_elven_tunic:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_elven_tunic_active", {duration = self:GetSpecialValueFor("duration")})
end

modifier_item_hd_elven_tunic = advanced_modifier({})

function modifier_item_hd_elven_tunic:IsDebuff() return false end
function modifier_item_hd_elven_tunic:IsHidden() return false end
function modifier_item_hd_elven_tunic:IsPurgable() return false end
function modifier_item_hd_elven_tunic:GetTexture() return "item_elven_tunic" end

function modifier_item_hd_elven_tunic:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
	
end
function modifier_item_hd_elven_tunic:OnIntervalThink(keys)
	self.evasion = self:GetParent():GetEvasion()*100
	self:SetStackCount(self.evasion*self:GetAbility():GetSpecialValueFor("evasion_attack_speed_morph"))
end


function modifier_item_hd_elven_tunic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
	}
end

function modifier_item_hd_elven_tunic:GetModifierAttackSpeedBonus_Constant() 	
	return math.max(0,self:GetStackCount())
end

function modifier_item_hd_elven_tunic:GetModifierEvasion_Constant() return self.bonus_evasion end

-------------
modifier_item_hd_elven_tunic_active = advanced_modifier({})

function modifier_item_hd_elven_tunic_active:IsDebuff() return false end
function modifier_item_hd_elven_tunic_active:IsHidden() return false end
function modifier_item_hd_elven_tunic_active:IsPurgable() return false end
function modifier_item_hd_elven_tunic_active:GetTexture() return "item_elven_tunic" end
function modifier_item_hd_elven_tunic_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_elven_tunic_active:GetEffectName() return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient_v2.vpcf" end
function modifier_item_hd_elven_tunic_active:OnCreated(keys)
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")

end
function modifier_item_hd_elven_tunic_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
	}
end

function modifier_item_hd_elven_tunic_active:GetModifierEvasion_Constant() return self.evasion_active end
