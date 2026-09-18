item_hd_anti_arcane_ring_2 = class({})

LinkLuaModifier("modifier_item_hd_anti_arcane_ring_2", "items/item_hd_anti_arcane_ring_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_anti_arcane_ring_2_active", "items/item_hd_anti_arcane_ring_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_anti_arcane_ring_2_active2", "items/item_hd_anti_arcane_ring_2", LUA_MODIFIER_MOTION_NONE)

function item_hd_anti_arcane_ring_2:GetIntrinsicModifierName()
	return "modifier_item_hd_anti_arcane_ring_2"
end
function item_hd_anti_arcane_ring_2:IsAlertableItem()
	return true
end


function item_hd_anti_arcane_ring_2:OnSpellStart()

	local caster    =   self:GetCaster()

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	
	caster:EmitSound("DOTA_Item.ArcaneRing.Cast")
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
   DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
   self:GetParent():EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
   for i, unit in pairs(units) do
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
	    unit:AddNewModifier(caster, self, "modifier_item_hd_anti_arcane_ring_2_active", {duration = 8*StatusResistance})
		unit:AddNewModifier(caster, self, "modifier_item_hd_anti_arcane_ring_2_active2", {duration = 1})
		if i>=7 then
			break
		end
    end           



end



modifier_item_hd_anti_arcane_ring_2 = class({})

function modifier_item_hd_anti_arcane_ring_2:IsDebuff() return false end
function modifier_item_hd_anti_arcane_ring_2:IsHidden() return true end
function modifier_item_hd_anti_arcane_ring_2:IsPurgable() return false end


function modifier_item_hd_anti_arcane_ring_2:OnCreated(keys)
    self.ability = self:GetAbility()

    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


end

function modifier_item_hd_anti_arcane_ring_2:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
	
	}
end


function modifier_item_hd_anti_arcane_ring_2:GetModifierBonusStats_Intellect()	return self.bonus_int end

modifier_item_hd_anti_arcane_ring_2_active = advanced_modifier({})

function modifier_item_hd_anti_arcane_ring_2_active:IsDebuff() return true end
function modifier_item_hd_anti_arcane_ring_2_active:IsHidden() return false end
function modifier_item_hd_anti_arcane_ring_2_active:IsPurgable() 		return false end
function modifier_item_hd_anti_arcane_ring_2_active:IsPurgeException() 	return false end
function modifier_item_hd_anti_arcane_ring_2_active:RemoveOnDeath()  return false end
-- function modifier_item_hd_anti_arcane_ring_2_active:IsPurgeException() return false end
function modifier_item_hd_anti_arcane_ring_2_active:GetTexture()return "item_anti_arcane_ring_2" end
function modifier_item_hd_anti_arcane_ring_2_active:GetEffectName()	return "particles/econ/events/spring_2021/bottle_spring_2021_ring_green.vpcf" end
function modifier_item_hd_anti_arcane_ring_2_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end



function modifier_item_hd_anti_arcane_ring_2_active:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS


    }
end


function modifier_item_hd_anti_arcane_ring_2_active:Advanced_GetModifierSpellAmplifyBonus()   return -30 end



modifier_item_hd_anti_arcane_ring_2_active2 = advanced_modifier({})

function modifier_item_hd_anti_arcane_ring_2_active2:IsDebuff() return true end
function modifier_item_hd_anti_arcane_ring_2_active2:IsHidden() return true end
function modifier_item_hd_anti_arcane_ring_2_active2:IsPurgable() return true end
-- function modifier_item_hd_anti_arcane_ring_2_active2:IsPurgeException() return false end
function modifier_item_hd_anti_arcane_ring_2_active2:GetTexture()return "item_anti_arcane_ring" end





function modifier_item_hd_anti_arcane_ring_2_active2:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS


    }
end

function modifier_item_hd_anti_arcane_ring_2_active2:Advanced_GetModifierSpellAmplifyBonus()   return -500 end
