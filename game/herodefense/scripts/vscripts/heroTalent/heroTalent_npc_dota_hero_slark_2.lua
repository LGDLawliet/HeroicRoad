heroTalent_npc_dota_hero_slark_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slark_2", "heroTalent/heroTalent_npc_dota_hero_slark_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slark_2_buff", "heroTalent/heroTalent_npc_dota_hero_slark_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_slark_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_slark_2"
end



modifier_heroTalent_npc_dota_hero_slark_2 = class({})

function modifier_heroTalent_npc_dota_hero_slark_2:IsHidden()	return self:GetStackCount()<=0 end
function modifier_heroTalent_npc_dota_hero_slark_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_slark_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_slark_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_slark_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slark_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_Challenge_boss_die", Dynamic_Wrap( self, 'OnChallengeBossKilled' ),self )
	end
end
function modifier_heroTalent_npc_dota_hero_slark_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_heroTalent_npc_dota_hero_slark_2:OnChallengeBossKilled(keys)
	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		local level = unit.challenge_level
		if level then
			self:SetStackCount(self:GetStackCount()+level)
			self:PlayEffects(unit )
		end
		
	end
end








function modifier_heroTalent_npc_dota_hero_slark_2:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end




function modifier_heroTalent_npc_dota_hero_slark_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_slark_2:GetModifierBonusStats_Agility()	return self:GetStackCount() end


