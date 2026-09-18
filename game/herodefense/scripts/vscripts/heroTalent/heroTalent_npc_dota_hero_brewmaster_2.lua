heroTalent_npc_dota_hero_brewmaster_2 = class({})


LinkLuaModifier("modifier_heroTalent_npc_dota_hero_brewmaster_2", "heroTalent/heroTalent_npc_dota_hero_brewmaster_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_brewmaster_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_brewmaster_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_brewmaster_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_brewmaster_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_brewmaster_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_brewmaster_2" end
-- function heroTalent_npc_dota_hero_brewmaster_2:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_brewmaster_2")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end
function heroTalent_npc_dota_hero_brewmaster_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_primal_split_shard.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_brewmaster_2 = class({})

function modifier_heroTalent_npc_dota_hero_brewmaster_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_heroTalent_npc_dota_hero_brewmaster_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end
	if keys.ability and keys.ability.IsElementSummon then 
		if keys.ability:IsElementSummon() then
			local time = keys.ability:GetCooldownTimeRemaining()
			if time>0 then
				keys.ability:EndCooldown()
				keys.ability:StartCooldown(time*0.7)
				local caster = self:GetCaster()
				local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_primal_split_shard.vpcf", PATTACH_WORLDORIGIN, caster )
				ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin() )
				DestroyParticleByDelay(effect_cast,3)
				
			end
		end 
	end

end
-- function modifier_heroTalent_npc_dota_hero_brewmaster_2:OnSummonUnit(keys)
-- 	if IsServer() then
		
-- 		local unit = keys.target
-- 		local name = unit:GetUnitName()
-- 		if name=="npc_Advanced_Plague_Ward" or name=="npc_Advanced_Plague_Ward_2" then
-- 			local ability = self:GetAbility():GetPoison_Sting()
-- 			if ability then
-- 				ability:OnTalentSummon(unit)
-- 			end
-- 		end
-- 		IsElementSummon

-- 	end
-- end
