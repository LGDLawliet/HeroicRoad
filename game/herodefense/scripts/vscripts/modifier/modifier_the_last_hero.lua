
--------------------------------------------------------------------------------
modifier_the_last_hero = class({})
require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_the_last_hero:IsHidden()return false end
function modifier_the_last_hero:IsDebuff()return false end
function modifier_the_last_hero:IsStunDebuff()return false end
function modifier_the_last_hero:IsPurgable()return false end
function modifier_the_last_hero:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_the_last_hero:IsPurgeException() 	return false end
function modifier_the_last_hero:RemoveOnDeath() return false end
function modifier_the_last_hero:GetEffectName() return "particles/rebuild/spell/last_hero/the_last_hero_ambient.vpcf" end
-- function modifier_the_last_hero:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_the_last_hero:OnCreated(keys)
	if IsServer() then
		local caster = self:GetParent()
		local pos = caster:GetAbsOrigin()
		local particle_main_fx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
	    ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		for i = 1, 10, 1 do

			Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
				local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
				vDir.z = 0
				vDir = vDir:Normalized()
				local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
				local particle_main_fx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
				caster:EmitSound("Hero_Sven.GodsStrength")
			end)
	
		end

		caster:EmitSound("Hero_Sven.GodsStrength")
		self:StartIntervalThink(0.5)
	end
end
function modifier_the_last_hero:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:ReleaseParticleIndex(pfx)

end
function modifier_the_last_hero:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
		-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		

	}
end


function modifier_the_last_hero:GetModifierBonusStats_Strength()	return 75 end
function modifier_the_last_hero:GetModifierBonusStats_Intellect()	return 75 end
function modifier_the_last_hero:GetModifierBonusStats_Agility()	return 75 end
