item_hd_arcane_ring_2 = class({})

LinkLuaModifier("modifier_item_hd_arcane_ring_2", "items/item_hd_arcane_ring_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcane_ring_2_active", "items/item_hd_arcane_ring_2", LUA_MODIFIER_MOTION_NONE)

function item_hd_arcane_ring_2:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_ring_2"
end
function item_hd_arcane_ring_2:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function item_hd_arcane_ring_2:OnSpellStart()
	local caster    =   self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local max = self:GetSpecialValueFor("max")
	local mana_get = self:GetSpecialValueFor("mana_get")*0.01
	local line = self:GetSpecialValueFor("line")
	local duration = self:GetSpecialValueFor("duration")
	--local duration = self:GetSpecialValueFor("duration")
	local ModifierStatusGain =caster:GetModifierDurationGainIndex(0.3)

	caster:EmitSound("DOTA_Item.ArcaneRing.Cast")
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
   	self:GetParent():EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
   	for i, unit in pairs(units) do
		if unit ~= caster then
	   	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
	   	ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
	   	ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
	   	ParticleManager:ReleaseParticleIndex(self.particle)
	   	--unit:AddNewModifier(caster, self, "modifier_item_hd_arcane_ring_2_active", {duration = 8*ModifierStatusGain})
	   	unit:Purge(false, true, false, false, false) --弱驱散
	   	local mana = (unit:GetMaxMana() - unit:GetMana())*mana_get
	   	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, mana, nil)
	   	unit:GiveMana(mana)
	   	if mana >= line then
			unit:AddNewModifier(caster, self, "modifier_item_hd_arcane_ring_2_active", {duration = duration*ModifierStatusGain})
	   	end
	   	if i>=max then
			break
		end
		end
   	end

   	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)  
   	caster:Purge(false, true, false, false, false) --弱驱散
   	local mana = (caster:GetMaxMana() - caster:GetMana())*mana_get
   	caster:GiveMana(mana)
	if mana >= line then
		caster:AddNewModifier(caster, self, "modifier_item_hd_arcane_ring_2_active", {duration = duration*ModifierStatusGain})
	end
   	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, mana, nil)
end
----------------------------------------------------------------------


modifier_item_hd_arcane_ring_2 = class({})

function modifier_item_hd_arcane_ring_2:IsDebuff() return false end
function modifier_item_hd_arcane_ring_2:IsHidden() return true end
function modifier_item_hd_arcane_ring_2:IsPurgable() 		return false end
function modifier_item_hd_arcane_ring_2:IsPurgeException() 	return false end
function modifier_item_hd_arcane_ring_2:RemoveOnDeath()  return false end



function modifier_item_hd_arcane_ring_2:OnCreated(keys)
    self.ability = self:GetAbility()
	
    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")

end


function modifier_item_hd_arcane_ring_2:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_MANA_BONUS

	}
end


-- function modifier_item_hd_arcane_ring_2:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_arcane_ring_2:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_arcane_ring_2:GetModifierManaBonus()	return self.bonus_mana end

---------------------------------------------------------------------
modifier_item_hd_arcane_ring_2_active = advanced_modifier({})

function modifier_item_hd_arcane_ring_2_active:IsDebuff() return false end
function modifier_item_hd_arcane_ring_2_active:IsHidden() return false end
function modifier_item_hd_arcane_ring_2_active:IsPurgable() return true end
-- function modifier_item_hd_arcane_ring_2_active:IsPurgeException() return false end
function modifier_item_hd_arcane_ring_2_active:GetTexture()return "item_arcane_ring_2" end
function modifier_item_hd_arcane_ring_2_active:GetEffectName()	return "particles/generic_gameplay/rune_arcane_b.vpcf" end
function modifier_item_hd_arcane_ring_2_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end



function modifier_item_hd_arcane_ring_2_active:Advanced_GetModifierSpellAmplifyBonus()  
	if not self:GetAbility() then self:Destroy() return end
	return self:GetAbility():GetSpecialValueFor("spell")
end
function modifier_item_hd_arcane_ring_2_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end