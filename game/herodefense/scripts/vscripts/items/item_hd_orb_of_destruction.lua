item_hd_orb_of_destruction = class({})

LinkLuaModifier("modifier_item_hd_orb_of_destruction", "items/item_hd_orb_of_destruction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_orb_of_destruction_active", "items/item_hd_orb_of_destruction", LUA_MODIFIER_MOTION_NONE)

function item_hd_orb_of_destruction:GetIntrinsicModifierName()
	return "modifier_item_hd_orb_of_destruction"
end



modifier_item_hd_orb_of_destruction = advanced_modifier({})

function modifier_item_hd_orb_of_destruction:IsDebuff() return false end
function modifier_item_hd_orb_of_destruction:IsHidden() return true end
function modifier_item_hd_orb_of_destruction:IsPurgable() return false end

function modifier_item_hd_orb_of_destruction:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},                    --攻击降临
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end



function modifier_item_hd_orb_of_destruction:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindModifierByName("modifier_item_hd_orb_of_destruction_active")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_orb_of_destruction_active", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			end
		end
	end
end
function modifier_item_hd_orb_of_destruction:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end



modifier_item_hd_orb_of_destruction_active = advanced_modifier({})

function modifier_item_hd_orb_of_destruction_active:IsDebuff() return true end
function modifier_item_hd_orb_of_destruction_active:IsHidden() return false end
function modifier_item_hd_orb_of_destruction_active:IsPurgable() return false end
function modifier_item_hd_orb_of_destruction_active:GetTexture()return "item_orb_of_destruction" end
function modifier_item_hd_orb_of_destruction_active:GetEffectName() return "particles/new_effect/new_effect/radiant_shrine_regen_steam_orange.vpcf" end
function modifier_item_hd_orb_of_destruction_active:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_orb_of_destruction_active:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end

function modifier_item_hd_orb_of_destruction_active:GetModifierMoveSpeedBonus_Percentage()	
	if not self:GetAbility() then self:Destroy() return end
	return -self:GetAbility():GetSpecialValueFor("move_down_pct") 
end

function modifier_item_hd_orb_of_destruction_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_hd_orb_of_destruction_active:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
    return -self:GetAbility():GetSpecialValueFor("armor_down")
end