item_hd_sphere = class({})
-- LinkLuaModifier("modifier_item_hd_sphere_arua", "items/item_hd_sphere", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sphere_arua_effect", "items/item_hd_sphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sphere", "items/item_hd_sphere", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_sphere:GetIntrinsicModifierName()
	return "modifier_item_hd_sphere"
end




modifier_item_hd_sphere = advanced_modifier({})

function modifier_item_hd_sphere:IsDebuff() return false end
function modifier_item_hd_sphere:IsHidden() return true end
function modifier_item_hd_sphere:IsPurgable() return false end


function modifier_item_hd_sphere:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	
end

function modifier_item_hd_sphere:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_ABSORB_SPELL,

	}
end


function modifier_item_hd_sphere:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_sphere:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_sphere:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_sphere:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_sphere:AdvancedGetModifierConstantManaRegen() 	return self.bonus_mana_regeneration end


function modifier_item_hd_sphere:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	if  not self:GetAbility():IsCooldownReady() then
		return
	end
	if not IsEnemy(keys.ability:GetCaster(), self:GetParent()) then
		return 0
	end
	--说明这次法术吸收是有法术反弹引起的
	if self:GetParent():HasModifier("modifier_item_lotus_orb_active") then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
	self:GetAbility():UseResources(true, true, true,true)

	return 1
end


function modifier_item_hd_sphere:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end