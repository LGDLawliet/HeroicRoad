
creeps_spell_Luna_Arrow = class({})

-- LinkLuaModifier("modifier_creeps_spell_Luna_Arrow_thinker", "creeps_spell/creeps_spell_Luna_Arrow", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_Luna_Arrow_stun", "creeps_spell/creeps_spell_Luna_Arrow", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Luna_Arrow:IsHiddenWhenStolen() 	return false end
function creeps_spell_Luna_Arrow:IsRefreshable() 			return true end
function creeps_spell_Luna_Arrow:IsStealable() 			return true end
function creeps_spell_Luna_Arrow:IsNetherWardStealable()	return true end


function creeps_spell_Luna_Arrow:OnSpellStart()
	local caster = self:GetCaster()
	local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	caster:EmitSound("Hero_Mirana.ArrowCast")

	local info = 
	{
		Ability = self,
		EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 3000,
		fStartRadius = 150,
		fEndRadius = 150,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 90.0,
		bDeleteOnHit = true,
		vVelocity = direction * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		-- ExtraData = {thinker = thinker}
	}
	ProjectileManager:CreateLinearProjectile(info)
end

-- function creeps_spell_Luna_Arrow:OnProjectileThink_ExtraData(location, keys)
-- 	local pos = GetGroundPosition(location, nil)
-- 	EntIndexToHScript(keys.thinker):SetOrigin(Vector(pos.x,pos.y,pos.z+200))
-- end

function creeps_spell_Luna_Arrow:OnProjectileHit_ExtraData(target, location, keys)

	if not target then
		-- EntIndexToHScript(keys.thinker):ForceKill(false)
		return true
	end

	-- EntIndexToHScript(keys.thinker):ForceKill(false)
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = self:GetSpecialValueFor("damage") * self:GetCaster():GetBaseDamageMax(),
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dmg_done, nil)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Mirana.ArrowImpact", target)


	if self:GetCaster():IsInDayTime() then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance =  target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
	end
	if  self:GetCaster():IsInNightTime() then
		local pos = target:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_notarget_moonfall.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,pos.z+128))
		ParticleManager:SetParticleControl(pfx, 5, Vector(pos.x,pos.y,pos.z+128))
		ParticleManager:ReleaseParticleIndex(pfx)
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("bonus_damage") * self:GetCaster():GetBaseDamageMax(),
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
        local dmg_done = ApplyDamage(damageTable)
	end

	
	return true
end


-- modifier_creeps_spell_Luna_Arrow_stun = class({})

-- function modifier_creeps_spell_Luna_Arrow_stun:IsDebuff()			return true end
-- function modifier_creeps_spell_Luna_Arrow_stun:IsHidden() 			return false end
-- function modifier_creeps_spell_Luna_Arrow_stun:IsPurgable() 		return true end
-- function modifier_creeps_spell_Luna_Arrow_stun:IsPurgeException() 	return true end
-- function modifier_creeps_spell_Luna_Arrow_stun:IsStunDebuff() return true end
-- function modifier_creeps_spell_Luna_Arrow_stun:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
-- function modifier_creeps_spell_Luna_Arrow_stun:GetStatusEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
-- function modifier_creeps_spell_Luna_Arrow_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
-- function modifier_creeps_spell_Luna_Arrow_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
-- function modifier_creeps_spell_Luna_Arrow_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

-- function modifier_creeps_spell_Luna_Arrow_stun:OnCreated()
-- 	if IsServer() then
-- 		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
-- 	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
-- 	end
-- end

-- function modifier_creeps_spell_Luna_Arrow_stun:OnRefresh(table)
-- 	if IsServer() then
-- 		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
-- 	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
-- 	end
-- end