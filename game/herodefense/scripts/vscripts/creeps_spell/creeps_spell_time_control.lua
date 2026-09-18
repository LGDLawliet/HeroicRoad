creeps_spell_time_control = class({})

LinkLuaModifier("modifier_creeps_spell_time_control_passive", "creeps_spell/creeps_spell_time_control", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_time_control", "creeps_spell/creeps_spell_time_control", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function creeps_spell_time_control:GetIntrinsicModifierName() return "modifier_creeps_spell_time_control_passive" end


function creeps_spell_time_control:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_game_spawn.vpcf", context )
end







modifier_creeps_spell_time_control_passive = class({})

function modifier_creeps_spell_time_control_passive:IsDebuff()			return false end
function modifier_creeps_spell_time_control_passive:IsHidden() 			return true end
function modifier_creeps_spell_time_control_passive:IsPurgable() 		return false end
function modifier_creeps_spell_time_control_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_time_control_passive:RemoveOnDeath()  return false end

function modifier_creeps_spell_time_control_passive:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_creeps_spell_time_control_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetParent()
    if _G.GAME_DIFFICULTY<=3 then
        return
    end
	if keys.attacker ~= caster or caster:IsIllusion() or caster:PassivesDisabled() or not keys.target:IsAlive() then
		return
	end

	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end

	local ability = self:GetAbility()


	if self:GetCaster():GetRandomEffect(ability:GetSpecialValueFor("proc_chance"),INT_TYPE,1)   > RandomInt(0,100) then

		
		local target_ability
		for i=0, keys.target:GetAbilityCount() - 1 do
			local Ability = keys.target:GetAbilityByIndex(i)
			if Ability ~= nil and not Ability:IsCooldownReady() then
				if target_ability==nil then
					target_ability = Ability
				else
					if Ability:GetCooldownTimeRemaining()>=target_ability:GetCooldownTimeRemaining() or target_ability:GetCooldownTimeRemaining()>=360 then
						target_ability = Ability
					end
				end
			end
		end
		if target_ability then
			keys.target:EmitSound("Greevil.ColdSnap.Cast")
			target_ability:StartCooldown(target_ability:GetCooldownTimeRemaining()+ability:GetSpecialValueFor("reduce"))
			local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_game_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target_ability )
			ParticleManager:SetParticleControl(effect_cast,0,target_ability:GetOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
		end





		
	
	end
end


