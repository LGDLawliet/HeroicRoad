heroTalent_npc_dota_hero_invoker = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_invoker", "heroTalent/heroTalent_npc_dota_hero_invoker", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_invoker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_invoker"
end



modifier_heroTalent_npc_dota_hero_invoker = class({})

function modifier_heroTalent_npc_dota_hero_invoker:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_invoker:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_invoker:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_invoker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_invoker:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_invoker:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
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
