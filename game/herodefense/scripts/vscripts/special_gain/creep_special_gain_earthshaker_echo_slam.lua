creep_special_gain_earthshaker_echo_slam = class({})

LinkLuaModifier("modifier_creep_special_gain_earthshaker_echo_slam", "special_gain/creep_special_gain_earthshaker_echo_slam", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_earthshaker_echo_slam_arua", "special_gain/creep_special_gain_earthshaker_echo_slam", LUA_MODIFIER_MOTION_NONE)
function creep_special_gain_earthshaker_echo_slam:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_earthshaker_echo_slam"
end


modifier_creep_special_gain_earthshaker_echo_slam = class({})

function modifier_creep_special_gain_earthshaker_echo_slam:IsDebuff() return false end
function modifier_creep_special_gain_earthshaker_echo_slam:IsHidden() return false end
function modifier_creep_special_gain_earthshaker_echo_slam:IsPurgable() return false end
function modifier_creep_special_gain_earthshaker_echo_slam:IsAura()	return true end
function modifier_creep_special_gain_earthshaker_echo_slam:GetModifierAura()	return  "modifier_creep_special_gain_earthshaker_echo_slam_arua" end
function modifier_creep_special_gain_earthshaker_echo_slam:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creep_special_gain_earthshaker_echo_slam:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_creep_special_gain_earthshaker_echo_slam:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor( "radius" ) end
function modifier_creep_special_gain_earthshaker_echo_slam:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creep_special_gain_earthshaker_echo_slam:OnCreated(keys)
	if IsServer() then
		self.parent = self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_anti_cleve.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(shackle_particle, 2, Vector(280,0,0))
		self:AddParticle(shackle_particle, true, false, -1, true, false)
	end
end


modifier_creep_special_gain_earthshaker_echo_slam_arua = advanced_modifier({})

--------------------------------------------------------------------------------
function modifier_creep_special_gain_earthshaker_echo_slam_arua:IsDebuff() return true end
function modifier_creep_special_gain_earthshaker_echo_slam_arua:IsHidden() return false end
function modifier_creep_special_gain_earthshaker_echo_slam_arua:IsPurgable()	return false end
function modifier_creep_special_gain_earthshaker_echo_slam_arua:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(0)
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_gain_earthshaker_echo_slam_arua:OnIntervalThink()
	if not self:GetCaster() or not self:GetAbility() then return end
	self:SetStackCount(math.min(self:GetStackCount()+1,self:GetAbility():GetSpecialValueFor("line")))
	if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("line") then
		local modifier_keys = {
			duration = -1,
			iSpecialAttack = 0,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 0,
		}
		self.attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	else
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	end
end 
function modifier_creep_special_gain_earthshaker_echo_slam_arua:OnDestroy( kv )
	if IsServer() then
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	end
end


