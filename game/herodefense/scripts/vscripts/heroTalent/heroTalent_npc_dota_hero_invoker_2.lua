heroTalent_npc_dota_hero_invoker_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_invoker_2", "heroTalent/heroTalent_npc_dota_hero_invoker_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_invoker_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_invoker_2"
end



modifier_heroTalent_npc_dota_hero_invoker_2 = class({})

function modifier_heroTalent_npc_dota_hero_invoker_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_invoker_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_invoker_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_invoker_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_invoker_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_invoker_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		_G.GAME_BOSS_SPELL_INDEX = _G.GAME_BOSS_SPELL_INDEX + 1
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb1", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb2", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb3", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )

	end

end
