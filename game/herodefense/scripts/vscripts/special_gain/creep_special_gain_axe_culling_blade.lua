creep_special_gain_axe_culling_blade = class({})
-- LinkLuaModifier("modifier_creep_special_gain_axe_culling_blade_arua", "skills/creep_special_gain_axe_culling_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_axe_culling_blade_arua_effect", "skills/creep_special_gain_axe_culling_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_axe_culling_blade", "special_gain/creep_special_gain_axe_culling_blade", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_axe_culling_blade:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_axe_culling_blade"
end


modifier_creep_special_gain_axe_culling_blade = class({})




function modifier_creep_special_gain_axe_culling_blade:IsDebuff()			return false end
function modifier_creep_special_gain_axe_culling_blade:IsHidden() 			return true end
function modifier_creep_special_gain_axe_culling_blade:IsPurgable() 		return false end
function modifier_creep_special_gain_axe_culling_blade:IsPurgeException() 	return false end
function modifier_creep_special_gain_axe_culling_blade:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_creep_special_gain_axe_culling_blade:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local caster =  self:GetCaster()
	local ability = self:GetAbility()


	if keys.attacker ~= caster or keys.target:IsBuilding() or keys.target:IsOther() or caster:PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
	if self:GetStackCount()>=11 then
		self:SetStackCount(0)
		local target = keys.target
		local index = 1
		local modifier = target:FindAbilityByName("Advanced_feast")
		if modifier and modifier.unlock2 then
			index = index * 3
		end
		local skeleton_king_4 = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff")
		if skeleton_king_4 and skeleton_king_4.limit then
			index = index * (1+skeleton_king_4.limit)
		end
		if target:GetHealth()*index <= caster:GetDamageMax()*0.05 then
			TrueKill(caster, target, ability)
			target:EmitSound("Hero_Axe.Culling_Blade_Success")
			local culling_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
			ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(culling_kill_particle)

		end
	end

end




