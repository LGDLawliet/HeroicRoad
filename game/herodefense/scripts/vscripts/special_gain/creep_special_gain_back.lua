LinkLuaModifier( "modifier_creep_special_gain_back", "special_gain/creep_special_gain_back.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_special_gain_back_active", "special_gain/creep_special_gain_back.lua", LUA_MODIFIER_MOTION_NONE )
creep_special_gain_back = class({})

function creep_special_gain_back:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_back"
end
---------------------------------------------------------------------

modifier_creep_special_gain_back = advanced_modifier({})
function modifier_creep_special_gain_back:IsDebuff() return false end
function modifier_creep_special_gain_back:IsHidden() return false end
function modifier_creep_special_gain_back:IsPurgable() 		return false end
function modifier_creep_special_gain_back:OnCreated(params)
	self.ability = self:GetAbility()
	self.hp_line = self.ability:GetSpecialValueFor("hp_line")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creep_special_gain_back:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
end

function modifier_creep_special_gain_back:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not self.ability:IsCooldownReady() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if keys.unit:GetHealthPercent() <= self.hp_line then

		if not keys.unit:IsAlive() then
			keys.unit:SetHealth(1)
		end

		keys.unit:EmitSound("Hero_Abaddon.BorrowedTime")
		keys.unit:AddNewModifier(keys.unit, self.ability, "modifier_creep_special_gain_back_active", {duration = self.duration})
		self.ability:UseResources(true, true, true, true)

	end
end

---------------------------------------------------------------------

modifier_creep_special_gain_back_active = advanced_modifier({})
function modifier_creep_special_gain_back_active:IsDebuff() return false end
function modifier_creep_special_gain_back_active:IsHidden() return false end
function modifier_creep_special_gain_back_active:IsPurgable() return true end
function modifier_creep_special_gain_back_active:IsPurgeException() return true end
function modifier_creep_special_gain_back_active:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_creep_special_gain_back_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW  end
function modifier_creep_special_gain_back_active:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_creep_special_gain_back_active:StatusEffectPriority() return 10 end

function modifier_creep_special_gain_back_active:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		target:Purge(false, true, false, true, false)
	end
end

function modifier_creep_special_gain_back_active:Advanced_GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local target 	= self:GetParent()
		if kv.damage<=0 then
			return
		end
		if kv.attacker == target then
			return
		end
		
		-- Show borrowed time heal particle
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)

		if target:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("max_line") then
			target:Heal(kv.damage, target)
		end
		
		return -100
	end
	return -100
end

function modifier_creep_special_gain_back_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
