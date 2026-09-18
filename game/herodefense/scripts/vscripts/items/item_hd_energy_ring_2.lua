item_hd_energy_ring_2 = class({})

LinkLuaModifier("modifier_item_hd_energy_ring_2", "items/item_hd_energy_ring_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_energy_ring_2_active", "items/item_hd_energy_ring_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_energy_ring_2_buff", "items/item_hd_energy_ring_2", LUA_MODIFIER_MOTION_NONE)
function item_hd_energy_ring_2:GetIntrinsicModifierName()
	return "modifier_item_hd_energy_ring_2"
end
function item_hd_energy_ring_2:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function item_hd_energy_ring_2:OnSpellStart()
	local caster    =   self:GetCaster()
	local ModifierStatusGain =  caster:GetModifierDurationGainIndex(0.3)
	local radius = self:GetSpecialValueFor("radius")
	local max = self:GetSpecialValueFor("max")
	local active_duration = self:GetSpecialValueFor("active_duration")
	local armor_per = self:GetSpecialValueFor("armor_per")

	caster:EmitSound("DOTA_Item.EssenceRing.Cast")
	
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
   	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
   for i, unit in pairs(units) do
		if unit ~= caster then 
		self.particle = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		local modifier = unit:FindModifierByName("modifier_item_hd_energy_ring_2_active")
		if modifier then
			modifier:SafeDestroy()
		end
		unit:AddNewModifier(caster, self, "modifier_item_hd_energy_ring_2_active", {duration = active_duration*ModifierStatusGain, armor_per = armor_per})
		if i>=max then
			break
		end
		end
   end

   self.particle = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_POINT_FOLLOW, caster)
   ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
   ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
   ParticleManager:ReleaseParticleIndex(self.particle)
   local modifier = caster:FindModifierByName("modifier_item_hd_energy_ring_2_active")
		if modifier then
			modifier:SafeDestroy()
		end
   caster:AddNewModifier(caster, self, "modifier_item_hd_energy_ring_2_active", {duration = active_duration*ModifierStatusGain, armor_per = armor_per})           
end
-------------------------------------------------
modifier_item_hd_energy_ring_2 = advanced_modifier({})

function modifier_item_hd_energy_ring_2:IsDebuff() return false end
function modifier_item_hd_energy_ring_2:IsHidden() return true end
function modifier_item_hd_energy_ring_2:IsPurgable() return false end
function modifier_item_hd_energy_ring_2:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amp = self.ability:GetSpecialValueFor("bonus_heal_amp")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
end

function modifier_item_hd_energy_ring_2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,           --力量
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,

	}
end

function modifier_item_hd_energy_ring_2:AdvancedGetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_energy_ring_2:Advanced_GetModifierHealAMP_Percentage()	return self.bonus_heal_amp end
function modifier_item_hd_energy_ring_2:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if keys.target:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
            return
        end
		local modifier = keys.target:FindModifierByName("modifier_item_hd_energy_ring_2_active")
		if modifier then
			return
		end
        if not self:GetAbility():IsCooldownReady() then
            return
        end
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local armor_per = self:GetAbility():GetSpecialValueFor("armor_per")*self:GetAbility():GetSpecialValueFor("index")*0.01
		local ModifierStatusGain =  self:GetParent():GetModifierDurationGainIndex(0.3)
        keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_energy_ring_2_active", {duration = duration*ModifierStatusGain ,armor_per = armor_per})
	end
end
---------------------------------------------------
modifier_item_hd_energy_ring_2_active = advanced_modifier({})

function modifier_item_hd_energy_ring_2_active:IsDebuff() return false end
function modifier_item_hd_energy_ring_2_active:IsHidden() return false end
function modifier_item_hd_energy_ring_2_active:IsPurgable() return true end
-- function modifier_item_hd_energy_ring_2_active:IsPurgeException() return false end
function modifier_item_hd_energy_ring_2_active:GetTexture()return "item_essence_ring" end
function modifier_item_hd_energy_ring_2_active:GetEffectName()	return "particles/new_effect/new_effect/new_hd_energy_ring.vpcf" end
function modifier_item_hd_energy_ring_2_active:GetEffectAttachType()	return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_energy_ring_2_active:OnCreated(keys)
	if IsServer() then
		self.armor_per = keys.armor_per or 0
		self.armor = (101 - self:GetParent():GetHealthPercent())*self.armor_per*0.01
		self:SetHasCustomTransmitterData( true )-- 同步cy
		--print("传入修正为"..self.armor_per)
	end
end
function modifier_item_hd_energy_ring_2_active:OnRefresh(keys)
	if IsServer() then
		self.armor_per = keys.armor_per or 0
		self.armor = (101 - self:GetParent():GetHealthPercent())*self.armor_per*0.01
		self:SetHasCustomTransmitterData( true )-- 同步cy
		--print("传入修正为"..self.armor_per)
	end
end

function modifier_item_hd_energy_ring_2_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_hd_energy_ring_2_active:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = (101 - self:GetParent():GetHealthPercent())*self.armor_per*0.01
	return self.armor
end

function modifier_item_hd_energy_ring_2_active:AddCustomTransmitterData( )
	return
	{
		armor_per = self.armor_per,
		armor = self.armor,
	}
end

function modifier_item_hd_energy_ring_2_active:HandleCustomTransmitterData( data )
	self.armor_per = data.armor_per
	self.armor = data.armor
end
