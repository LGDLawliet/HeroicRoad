item_hd_arcane_ring = class({})

LinkLuaModifier("modifier_item_hd_arcane_ring", "items/item_hd_arcane_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcane_ring_active", "items/item_hd_arcane_ring", LUA_MODIFIER_MOTION_NONE)

function item_hd_arcane_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_ring"
end



function item_hd_arcane_ring:OnSpellStart()

	local caster    =   self:GetCaster()

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)

	caster:EmitSound("DOTA_Item.ArcaneRing.Cast")
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
   self:GetParent():EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
   for i, unit in pairs(units) do

	   self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
	   ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
	   ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
	   ParticleManager:ReleaseParticleIndex(self.particle)
	   unit:AddNewModifier(caster, self, "modifier_item_hd_arcane_ring_active", {duration = 4*ModifierStatusGain})
	   if i>=7 then
		break
	end
   end           



end



modifier_item_hd_arcane_ring = class({})

function modifier_item_hd_arcane_ring:IsDebuff() return false end
function modifier_item_hd_arcane_ring:IsHidden() return true end
function modifier_item_hd_arcane_ring:IsPurgable() 		return false end
function modifier_item_hd_arcane_ring:IsPurgeException() 	return false end
function modifier_item_hd_arcane_ring:RemoveOnDeath()  return false end



function modifier_item_hd_arcane_ring:OnCreated(keys)
    self.ability = self:GetAbility()
	
    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


end


function modifier_item_hd_arcane_ring:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力


	}
end


-- function modifier_item_hd_arcane_ring:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_arcane_ring:GetModifierBonusStats_Intellect()	return self.bonus_int end

modifier_item_hd_arcane_ring_active = advanced_modifier({})

function modifier_item_hd_arcane_ring_active:IsDebuff() return false end
function modifier_item_hd_arcane_ring_active:IsHidden() return false end
function modifier_item_hd_arcane_ring_active:IsPurgable() return true end
-- function modifier_item_hd_arcane_ring_active:IsPurgeException() return false end
function modifier_item_hd_arcane_ring_active:GetTexture()return "item_arcane_ring" end
function modifier_item_hd_arcane_ring_active:GetEffectName()	return "particles/generic_gameplay/rune_arcane_b.vpcf" end
function modifier_item_hd_arcane_ring_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end



function modifier_item_hd_arcane_ring_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗
	}
end


function modifier_item_hd_arcane_ring_active:Advanced_GetModifierSpellAmplifyBonus()   return 10 end
function modifier_item_hd_arcane_ring_active:GetModifierPercentageManacost()   return 10 end
function modifier_item_hd_arcane_ring_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end