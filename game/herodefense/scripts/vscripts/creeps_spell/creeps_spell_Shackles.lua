creeps_spell_Shackles = class({})
LinkLuaModifier("modifier_creeps_spell_Shackles", "creeps_spell/creeps_spell_Shackles", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_Shackles:IsHiddenWhenStolen() 		return false end
function creeps_spell_Shackles:IsRefreshable() 			return true end
function creeps_spell_Shackles:IsStealable() 				return true end
function creeps_spell_Shackles:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end



-- function creeps_spell_Shackles:CastFilterResultTarget(target)
-- 	if not self:GetCaster():HasModifier("modifier_creeps_spell_Shackles_target_handler") or target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or target == self:GetCaster() then
-- 		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
-- 	else
-- 		return UF_SUCCESS
-- 	end
-- end

function creeps_spell_Shackles:GetChannelTime()
    if self:GetCaster():IsInNightTime() or self:GetCaster():PassivesDisabled() then
	    return self:GetSpecialValueFor("duration")
    else
        return self:GetSpecialValueFor("duration") *2
    end
end

function creeps_spell_Shackles:OnSpellStart()
	local target = self:GetCursorTarget()

	-- if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then return end
	-- 		self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
	-- 		-- IMBAfication: Stronghold
	-- 		-- local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("stronghold_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS)
			
	-- 		for _, enemy in pairs(enemies) do
	-- 			enemy:AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Shackles", {duration = self:GetChannelTime()})
	-- 		end
	-- 	else
	-- 		self:GetCaster():Interrupt()
	-- 	end
	-- else
	-- 	target:AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Shackles_chariot", {duration = self:GetChannelTime()})
	-- end
    target:AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Shackles", {duration = self:GetChannelTime()})
	target:EmitSound("Hero_ShadowShaman.Shackles.Cast")
end

function creeps_spell_Shackles:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	if target then
		target:StopSound("Hero_ShadowShaman.Shackles.Cast")
		if target:FindModifierByNameAndCaster("modifier_creeps_spell_Shackles", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_creeps_spell_Shackles", self:GetCaster())
		end
	end
end


-----------------------
-- SHACKLES MODIFIER --
-----------------------
modifier_creeps_spell_Shackles = class({})
-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_creeps_spell_Shackles:IsDebuff()			return true end
function modifier_creeps_spell_Shackles:IsHidden() 			return false end
function modifier_creeps_spell_Shackles:IsPurgable()			return false end
function modifier_creeps_spell_Shackles:IsPurgeException()	    return false end
function modifier_creeps_spell_Shackles:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_Shackles:OnCreated()
	if not IsServer() then return end
	
	-- Create shackle particle (yeah this is like 100% wrong but I can't be assed to figure out what exactly goes where)
	local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/ss_fall20_tongue/shadowshaman_shackle_net_fall20.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
	self.tick_interval			= 0.5
	self.channel_time			= self:GetAbility():GetChannelTime()
	self:StartIntervalThink(self.tick_interval)
end

function modifier_creeps_spell_Shackles:OnIntervalThink()
	if not IsServer() then return end
	
	if not self:GetAbility():IsChanneling() then
		self:SafeDestroy()
	end
end

function modifier_creeps_spell_Shackles:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_creeps_spell_Shackles:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_creeps_spell_Shackles:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
