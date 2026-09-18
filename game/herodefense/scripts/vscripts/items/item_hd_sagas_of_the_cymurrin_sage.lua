item_hd_sagas_of_the_cymurrin_sage = class({})
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_arua", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_arua_effect", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_active", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_effect", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_effect2", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_active_standby", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_debuff", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sagas_of_the_cymurrin_sage_thinker", "items/item_hd_sagas_of_the_cymurrin_sage", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_sagas_of_the_cymurrin_sage:GetIntrinsicModifierName()
	return "modifier_item_hd_sagas_of_the_cymurrin_sage"
end




function item_hd_sagas_of_the_cymurrin_sage:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
	local particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_flash.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	target:AddNewModifier(caster, self, "modifier_item_hd_sagas_of_the_cymurrin_sage_active", {duration = 8})

end



modifier_item_hd_sagas_of_the_cymurrin_sage = advanced_modifier({})

function modifier_item_hd_sagas_of_the_cymurrin_sage:IsDebuff() return false end
function modifier_item_hd_sagas_of_the_cymurrin_sage:IsHidden() return true end
function modifier_item_hd_sagas_of_the_cymurrin_sage:IsPurgable() return false end


function modifier_item_hd_sagas_of_the_cymurrin_sage:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")

end



function modifier_item_hd_sagas_of_the_cymurrin_sage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end

function modifier_item_hd_sagas_of_the_cymurrin_sage:GetModifierBonusStats_Intellect()	return self.bonus_int end

function modifier_item_hd_sagas_of_the_cymurrin_sage:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end


function modifier_item_hd_sagas_of_the_cymurrin_sage:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_sagas_of_the_cymurrin_sage:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_sagas_of_the_cymurrin_sage_active = advanced_modifier({})

function modifier_item_hd_sagas_of_the_cymurrin_sage_active:IsDebuff() return true end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:IsHidden() return false end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:IsPurgable() return true end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:GetTexture()return "item_sagas_of_the_cymurrin_sage" end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames_heal_flame.vpcf" end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:GetModifierMagicalResistanceBonus() return -20 end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_sagas_of_the_cymurrin_sage_effect", {duration = 40})
	end
end

function modifier_item_hd_sagas_of_the_cymurrin_sage_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_sagas_of_the_cymurrin_sage_active:Advanced_GetModifierPhysicalArmorBonus()
    return -10
end

modifier_item_hd_sagas_of_the_cymurrin_sage_effect = advanced_modifier({})

function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:IsDebuff() return false end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:IsHidden() return false end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:IsPurgable() return true end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:GetTexture()return "item_sagas_of_the_cymurrin_sage" end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:GetEffectName() return "particles/new_effect/new_effect/new_hd_sagas_of_the_cymurrin_sage.vpcf" end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end

function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:GetModifierMagicalResistanceBonus() return 20 end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_sagas_of_the_cymurrin_sage_effect:Advanced_GetModifierPhysicalArmorBonus()
    return 10
end