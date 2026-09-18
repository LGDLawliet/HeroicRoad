heroTalent_npc_dota_hero_oracle = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_oracle", "heroTalent/heroTalent_npc_dota_hero_oracle", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_oracle:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_oracle"
end



modifier_heroTalent_npc_dota_hero_oracle = class({})

function modifier_heroTalent_npc_dota_hero_oracle:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_oracle:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_oracle:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_oracle:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_oracle:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_oracle:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_oracle:BuyBackTarget(target)
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return
		end
		local particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local modifier = self:GetParent():FindModifierByName("modifier_Respawn_weak")
		if modifier then
			modifier:SafeDestroy()
		end
		Timers:CreateTimer(0.2, function()
			target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
		end)
	end
end



