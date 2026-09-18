creeps_spell_time_lock = class({})

LinkLuaModifier("modifier_creeps_spell_time_lock_passive", "creeps_spell/creeps_spell_time_lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_time_lock", "creeps_spell/creeps_spell_time_lock", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function creeps_spell_time_lock:GetIntrinsicModifierName() return "modifier_creeps_spell_time_lock_passive" end


function creeps_spell_time_lock:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_lock_tentacle_bash.vpcf", context )
end







modifier_creeps_spell_time_lock_passive = class({})

function modifier_creeps_spell_time_lock_passive:IsDebuff()			return false end
function modifier_creeps_spell_time_lock_passive:IsHidden() 			return true end
function modifier_creeps_spell_time_lock_passive:IsPurgable() 		return false end
function modifier_creeps_spell_time_lock_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_time_lock_passive:RemoveOnDeath()  return false end

function modifier_creeps_spell_time_lock_passive:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_creeps_spell_time_lock_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetParent()

	if keys.attacker ~= caster or caster:IsIllusion() or caster:PassivesDisabled() or not keys.target:IsAlive() then
		return
	end

	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end

	local ability = self:GetAbility()


	if self:GetCaster():GetRandomEffect(ability:GetSpecialValueFor("proc_chance"),INT_TYPE,1)   > RandomInt(0,100) then

		keys.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		keys.target:AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_time_lock", {duration = ability:GetSpecialValueFor("duration")*StatusResistance})
		local damageTable = {
			victim = keys.target,
			attacker = caster,
			damage = ability:GetSpecialValueFor("base_damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetAverageTrueAttackDamage(nil),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
		ApplyDamage(damageTable)


		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_lock_tentacle_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
		-- ParticleManager:SetParticleControl(effect_cast,1,keys.target:GetOrigin() )
		ParticleManager:SetParticleControlEnt(effect_cast,1,keys.target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
		-- local phantom_delay = math.max(self:GetDuration()-0.05,0)
		-- ParticleManager:SetParticleControl(self.effect_cast,10,Vector(phantom_delay,0,0) )
		ParticleManager:ReleaseParticleIndex(effect_cast)

		Timers:CreateTimer(0.4, function()
			if not caster:IsNull() and caster:IsAlive() and not keys.target:IsNull() and keys.target:IsAlive() then
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave = 0,
					iDisableSplit = 0,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier(ability,modifier_keys)
			
				caster:PerformAttack(keys.target, false, true, true, false, false, false, true)
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			end
	

		end)

		
	
	end
end



modifier_creeps_spell_time_lock = class({})

function modifier_creeps_spell_time_lock:IsDebuff()			return true end
function modifier_creeps_spell_time_lock:IsHidden() 			return false end
function modifier_creeps_spell_time_lock:IsPurgable() 			return false end
function modifier_creeps_spell_time_lock:IsPurgeException() 	return true end
-- function modifier_creeps_spell_time_lock:ShouldUseOverheadOffset() return true end
-- function modifier_creeps_spell_time_lock:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
-- function modifier_creeps_spell_time_lock:GetModifierMoveSpeedBonus_Percentage() return (0 - 100) end
function modifier_creeps_spell_time_lock:CheckState()
    return {
      
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }
end



