item_hd_energy_ring = class({})

LinkLuaModifier("modifier_item_hd_energy_ring", "items/item_hd_energy_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_energy_ring_active", "items/item_hd_energy_ring", LUA_MODIFIER_MOTION_NONE)

function item_hd_energy_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_energy_ring"
end



function item_hd_energy_ring:OnSpellStart()

	local caster    =   self:GetCaster()

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)

	caster:EmitSound("DOTA_Item.EssenceRing.Cast")
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
--    self:GetParent():EmitSound("DOTA_Item.EssenceRing.Cast")
   for i, unit in pairs(units) do
		self.particle = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		unit:AddNewModifier(caster, self, "modifier_item_hd_energy_ring_active", {duration = 4*ModifierStatusGain})
		if i>=7 then
			break
		end
   end           


end





modifier_item_hd_energy_ring = class({})

function modifier_item_hd_energy_ring:IsDebuff() return false end
function modifier_item_hd_energy_ring:IsHidden() return true end
function modifier_item_hd_energy_ring:IsPurgable() return false end



function modifier_item_hd_energy_ring:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")

end



function modifier_item_hd_energy_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量


	}
end


function modifier_item_hd_energy_ring:GetModifierBonusStats_Strength()	return self.bonus_str end

modifier_item_hd_energy_ring_active = advanced_modifier({})

function modifier_item_hd_energy_ring_active:IsDebuff() return false end
function modifier_item_hd_energy_ring_active:IsHidden() return false end
function modifier_item_hd_energy_ring_active:IsPurgable() return true end
-- function modifier_item_hd_energy_ring_active:IsPurgeException() return false end
function modifier_item_hd_energy_ring_active:GetTexture()return "item_energy_ring" end
function modifier_item_hd_energy_ring_active:GetEffectName()	return "particles/new_effect/new_effect/new_hd_energy_ring.vpcf" end
function modifier_item_hd_energy_ring_active:GetEffectAttachType()	return PATTACH_CENTER_FOLLOW end




function modifier_item_hd_energy_ring_active:AdvancedGetModifierConstantHealthRegenAmpPercentage()	return 15 end

function modifier_item_hd_energy_ring_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE
    }
end
function modifier_item_hd_energy_ring_active:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return 10
end

