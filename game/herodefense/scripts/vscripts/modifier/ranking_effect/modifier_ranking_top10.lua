modifier_ranking_top1 =modifier_ranking_top1 or  class({})



-- function modifier_ranking_top1:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", context )

	
-- end
--------------------------------------------------------------------------------
-- Classifications
function modifier_ranking_top1:IsHidden()return false end
function modifier_ranking_top1:IsDebuff()return false end
function modifier_ranking_top1:IsStunDebuff()return false end
function modifier_ranking_top1:IsPurgable()return false end
function modifier_ranking_top1:IsPurgeException() 	return false end
function modifier_ranking_top1:RemoveOnDeath() return false end
function modifier_ranking_top1:GetTexture() return "skeleton_king/arcana/skeleton_king_bone_guard_arcana_alt" end
-- function modifier_ranking_top1:GetEffectName() return "particles/new_effect/player_deferred_light_rebuild.vpcf" end
-- function modifier_ranking_top1:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
-- function modifier_ranking_top1:OnCreated(table)
--     if IsServer() then
--         local parnet = self:GetParent()
--         local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parnet )
--         ParticleManager:SetParticleControlEnt( nFXIndex, 0, parnet, PATTACH_POINT_FOLLOW, nil, parnet:GetAbsOrigin(), true )
--         self:AddParticle( nFXIndex, false, false, -1, true, false )
--     end
-- end



modifier_ranking_top3 =  modifier_ranking_top3 or class({})

-- function modifier_ranking_top3:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", context )

	
-- end
--------------------------------------------------------------------------------
-- Classifications
function modifier_ranking_top3:IsHidden()return false end
function modifier_ranking_top3:IsDebuff()return false end
function modifier_ranking_top3:IsStunDebuff()return false end
function modifier_ranking_top3:IsPurgable()return false end
function modifier_ranking_top3:IsPurgeException() 	return false end
function modifier_ranking_top3:RemoveOnDeath() return false end
function modifier_ranking_top3:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
-- function modifier_ranking_top3:GetEffectName() return "particles/new_effect/player_deferred_light_rebuild.vpcf" end
-- function modifier_ranking_top3:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
-- function modifier_ranking_top3:OnCreated(table)
--     if IsServer() then
--         local parnet = self:GetParent()
--         local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parnet )
--         ParticleManager:SetParticleControlEnt( nFXIndex, 0, parnet, PATTACH_POINT_FOLLOW, nil, parnet:GetAbsOrigin(), true )
--         self:AddParticle( nFXIndex, false, false, -1, true, false )
--     end
-- end



modifier_ranking_top10 =  modifier_ranking_top10 or class({})

-- function modifier_ranking_top10:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/special_effect/top10_effect/001/energy.vpcf", context )

	
-- end
--------------------------------------------------------------------------------
-- Classifications
function modifier_ranking_top10:IsHidden()return false end
function modifier_ranking_top10:IsDebuff()return false end
function modifier_ranking_top10:IsStunDebuff()return false end
function modifier_ranking_top10:IsPurgable()return false end
function modifier_ranking_top10:IsPurgeException() 	return false end
function modifier_ranking_top10:RemoveOnDeath() return false end
function modifier_ranking_top10:GetTexture() return "zuus_static_field" end
-- function modifier_ranking_top10:GetEffectName() return "particles/new_effect/player_deferred_light_rebuild.vpcf" end
-- function modifier_ranking_top10:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
-- function modifier_ranking_top10:OnCreated(table)
--     if IsServer() then
--         local parnet = self:GetParent()
--         local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/special_effect/top10_effect/001/energy.vpcf", PATTACH_ABSORIGIN_FOLLOW,parnet )
--         ParticleManager:SetParticleControlEnt( nFXIndex, 0, parnet, PATTACH_POINT_FOLLOW, "attach_hitloc", parnet:GetAbsOrigin(), true )
--         self:AddParticle( nFXIndex, false, false, -1, true, false )
--     end
-- end