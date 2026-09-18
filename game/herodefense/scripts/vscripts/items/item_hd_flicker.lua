item_hd_flicker = class({})

LinkLuaModifier("modifier_item_hd_flicker", "items/item_hd_flicker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_flicker_active", "items/item_hd_flicker", LUA_MODIFIER_MOTION_NONE)

function item_hd_flicker:GetIntrinsicModifierName()
	return "modifier_item_hd_flicker"
end

function item_hd_flicker:IsRefreshable() return false end



function item_hd_flicker:OnSpellStart()

	
	local caster    =   self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_hd_flicker_active", {duration = 1})
	ProjectileManager:ProjectileDodge(caster) --弹道躲闪
	caster:Purge(false, true, false, false,true)
	caster:EmitSound("DOTA_Item.Swift_Blink.NailedIt")
	self.particle = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
	self:StartCooldown(5)

end





modifier_item_hd_flicker = class({})

function modifier_item_hd_flicker:IsDebuff() return false end
function modifier_item_hd_flicker:IsHidden() return true end
function modifier_item_hd_flicker:IsPurgable() return false end


function modifier_item_hd_flicker:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")


end

function modifier_item_hd_flicker:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	


	}
end

function modifier_item_hd_flicker:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end


modifier_item_hd_flicker_active = advanced_modifier({})

function modifier_item_hd_flicker_active:IsDebuff() return false end
function modifier_item_hd_flicker_active:IsHidden() return true end
function modifier_item_hd_flicker_active:IsPurgable() return false end

function modifier_item_hd_flicker_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -100
end

function modifier_item_hd_flicker_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
