creep_special_gain_Invalidation_of_health_regen = class({})

LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_health_regen", "special_gain/creep_special_gain_Invalidation_of_health_regen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_of_health_regen_arua", "special_gain/creep_special_gain_Invalidation_of_health_regen", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Invalidation_of_health_regen:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Invalidation_of_health_regen"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_Invalidation_of_health_regen = class({})

function modifier_creep_special_gain_Invalidation_of_health_regen:IsDebuff() return false end
function modifier_creep_special_gain_Invalidation_of_health_regen:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_of_health_regen:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetEffectName() 	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_2_rebuild.vpcf" end
-- function modifier_creep_special_gain_Invalidation_of_health_regen:GetStatusEffectName() 	return "particles/status_fx/status_effect_necrolyte_spirit.vpcf" end
function modifier_creep_special_gain_Invalidation_of_health_regen:IsAura()	return true end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetModifierAura()	return  "modifier_creep_special_gain_Invalidation_of_health_regen_arua" end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetAuraRadius()	return 400 end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetAuraDuration() return 0.1 end
function modifier_creep_special_gain_Invalidation_of_health_regen:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_creep_special_gain_Invalidation_of_health_regen:OnCreated(keys)
-- 	if IsServer() then
-- 		self.parent = self:GetParent()
-- 		local shackle_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_anti_cleve.vpcf", PATTACH_POINT_FOLLOW, self.parent)
-- 		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
-- 		-- ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
-- 		ParticleManager:SetParticleControl(shackle_particle, 2, Vector(280,0,0))
-- 		-- ParticleManager:SetParticleControlEnt(shackle_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
-- 		-- ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
-- 		self:AddParticle(shackle_particle, true, false, -1, true, false)
-- 	end
-- end


modifier_creep_special_gain_Invalidation_of_health_regen_arua = class({})

--------------------------------------------------------------------------------
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:IsDebuff() return true end
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:IsPurgable()	return false end
-- function modifier_creep_special_gain_Invalidation_of_health_regen_arua:GetEffectName()	return "particles/items4_fx/spirit_vessel_damage.vpcf" end

-- function modifier_creep_special_gain_Invalidation_of_health_regen_arua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:OnIntervalThink(keys)
	self:SetStackCount(math.min(6,self:GetStackCount()+1))
end

function modifier_creep_special_gain_Invalidation_of_health_regen_arua:DeclareFunctions()    return {MODIFIER_PROPERTY_DISABLE_HEALING,}end
function modifier_creep_special_gain_Invalidation_of_health_regen_arua:GetDisableHealing()	return self:GetStackCount()>=6 and 1 or 0 end
