item_hd_Siltbreaker_Unhallowed = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Unhallowed_arua", "items/item_hd_Siltbreaker_Unhallowed", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Unhallowed_arua_effect", "items/item_hd_Siltbreaker_Unhallowed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Unhallowed", "items/item_hd_Siltbreaker_Unhallowed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Unhallowed_active", "items/item_hd_Siltbreaker_Unhallowed", LUA_MODIFIER_MOTION_NONE)
function item_hd_Siltbreaker_Unhallowed:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Unhallowed"
end

function item_hd_Siltbreaker_Unhallowed:OnSpellStart()
	local caster = self:GetCaster()	

	if caster:GetHealth() >5 then
		self:GetCaster():SetHealth(caster:GetHealth() * 0.2)
	end	
	local random_response = RandomInt(1, 4)
	self:EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
	self:EmitSound("Hero_OgreMagi.Bloodlust.Target")

	caster:AddNewModifier(caster, self, "modifier_item_hd_Siltbreaker_Unhallowed_active", {duration = 15})


end



modifier_item_hd_Siltbreaker_Unhallowed = class({})

function modifier_item_hd_Siltbreaker_Unhallowed:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Unhallowed:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Unhallowed:IsPurgable() return false end


function modifier_item_hd_Siltbreaker_Unhallowed:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	
end


function modifier_item_hd_Siltbreaker_Unhallowed:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
	
		

	}
end


function modifier_item_hd_Siltbreaker_Unhallowed:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_Siltbreaker_Unhallowed:GetModifierManaBonus()	return self.bonus_mana end



modifier_item_hd_Siltbreaker_Unhallowed_active = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Unhallowed_active:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Unhallowed_active:IsHidden() return false end
function modifier_item_hd_Siltbreaker_Unhallowed_active:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Unhallowed_active:GetTexture()return "item_Siltbreaker_Unhallowed" end
function modifier_item_hd_Siltbreaker_Unhallowed_active:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_item_hd_Siltbreaker_Unhallowed_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_Siltbreaker_Unhallowed_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end
-- function modifier_item_hd_Siltbreaker_Unhallowed_active:GetModifierPercentageCasttime()return 1000 end
function modifier_item_hd_Siltbreaker_Unhallowed_active:Advanced_GetModifierSpellAmplifyBonus()return 30 end
function modifier_item_hd_Siltbreaker_Unhallowed_active:GetModifierMoveSpeedBonus_Constant()return 150 end



function modifier_item_hd_Siltbreaker_Unhallowed_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint
    }
end

function modifier_item_hd_Siltbreaker_Unhallowed_active:Advanced_GetModifier_CastPoint() return 1000 end
