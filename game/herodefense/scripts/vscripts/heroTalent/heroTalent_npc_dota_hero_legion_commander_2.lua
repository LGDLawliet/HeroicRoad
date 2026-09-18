heroTalent_npc_dota_hero_legion_commander_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_legion_commander_2", "heroTalent/heroTalent_npc_dota_hero_legion_commander_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_legion_commander_2_effect", "heroTalent/heroTalent_npc_dota_hero_legion_commander_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_legion_commander_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_legion_commander_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_legion_commander_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_legion_commander_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_legion_commander_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_legion_commander_2" end
-- function heroTalent_npc_dota_hero_legion_commander_2:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_legion_commander_2")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end


modifier_heroTalent_npc_dota_hero_legion_commander_2 = class({})

function modifier_heroTalent_npc_dota_hero_legion_commander_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:IsHidden() 			return self:GetStackCount()<=0 end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_legion_commander_2:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_Challenge_boss_die", Dynamic_Wrap( self, 'OnChallengeBossKilled' ),self )
	end
end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_heroTalent_npc_dota_hero_legion_commander_2:OnChallengeBossKilled(keys)
	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		local level = unit.challenge_level
		if level then
			self:SetStackCount(self:GetStackCount()+level*4)
			local caster = self:GetCaster()
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			local pos = caster:GetAbsOrigin()
			pos.z = pos.z +128
			ParticleManager:SetParticleControl( nFXIndex, 0, pos )
			
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			caster:EmitSound("Hero_LegionCommander.Duel.Victory")
		end
		
	end
end



function modifier_heroTalent_npc_dota_hero_legion_commander_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_heroTalent_npc_dota_hero_legion_commander_2:GetModifierPreAttack_BonusDamage( params )
	return self:GetStackCount()*0.7
end
function modifier_heroTalent_npc_dota_hero_legion_commander_2:GetModifierBaseAttack_BonusDamage( params )
	return self:GetStackCount()*0.3
end
