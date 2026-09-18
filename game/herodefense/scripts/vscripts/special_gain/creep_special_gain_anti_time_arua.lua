creep_special_gain_anti_time_arua = class({})
-- LinkLuaModifier("modifier_creep_special_gain_anti_time_arua_arua", "skills/creep_special_gain_anti_time_arua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_anti_time_arua_arua_effect", "skills/creep_special_gain_anti_time_arua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_anti_time_arua", "special_gain/creep_special_gain_anti_time_arua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_anti_time_arua_active", "special_gain/creep_special_gain_anti_time_arua", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
require('internal/timers')   --计时器功能
function creep_special_gain_anti_time_arua:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_anti_time_arua"
end


modifier_creep_special_gain_anti_time_arua = class({})




function modifier_creep_special_gain_anti_time_arua:IsHidden() 
	return false
end
function modifier_creep_special_gain_anti_time_arua:IsPurgable() return false end
function modifier_creep_special_gain_anti_time_arua:IsDebuff() return false end
-- function modifier_creep_special_gain_anti_time_arua:GetEffectName() return "particles/new_effect/new_effect/invalidation_magic.vpcf" end
-- function modifier_creep_special_gain_anti_time_arua:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_anti_time_arua:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(25)
	end
end
function modifier_creep_special_gain_anti_time_arua:OnIntervalThink()


	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creep_special_gain_anti_time_arua_active", {duration = 5})
end


modifier_creep_special_gain_anti_time_arua_active = class({})

function modifier_creep_special_gain_anti_time_arua_active:IsDebuff() return false end
function modifier_creep_special_gain_anti_time_arua_active:IsHidden() return false end
function modifier_creep_special_gain_anti_time_arua_active:IsPurgable() return false end
function modifier_creep_special_gain_anti_time_arua_active:IsPurgeException() return true end
function modifier_creep_special_gain_anti_time_arua_active:OnCreated(keys)
	if IsServer() then
		self.parent = self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/anti_time_arua.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_gain_anti_time_arua_active:OnIntervalThink()
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	for a, enemy in pairs(units) do
		if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then

			for i=0, enemy:GetAbilityCount() - 1 do
				local Ability = enemy:GetAbilityByIndex(i)
				if Ability ~= nil and Ability:GetAbilityType() ~= 1   then
					if not Ability:IsCooldownReady() then
						local newCooldown = Ability:GetCooldownTimeRemaining() +2
						Ability:StartCooldown(newCooldown)
					end
				end
			end
		end
	end
end