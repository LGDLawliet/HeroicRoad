heroTalent_npc_dota_hero_bounty_hunter_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bounty_hunter_2", "heroTalent/heroTalent_npc_dota_hero_bounty_hunter_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_bounty_hunter_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bounty_hunter_2"
end


function heroTalent_npc_dota_hero_bounty_hunter_2:Spawn()
	self.difficulty5_count = 0
end

function heroTalent_npc_dota_hero_bounty_hunter_2:AddStack()
	self.difficulty5_count = self.difficulty5_count + 1
	-- print("加1")
end
function heroTalent_npc_dota_hero_bounty_hunter_2:OnCustomDataSettlement()
	if self.difficulty5_count>=15 then
		-- print("条件满足")
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			-- modifier:bounty_hunterTalent2()
			modifier:UnlockCustomData("extremely_greed_1")
		end
	end

end

function heroTalent_npc_dota_hero_bounty_hunter_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/taunts/bounty_hunter/bh_taunt_goldpiles/bh_taunt_goldpiles.vpcf", context )
end

modifier_heroTalent_npc_dota_hero_bounty_hunter_2 = class({})

function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:GetBonusIndex() 
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/taunts/bounty_hunter/bh_taunt_goldpiles/bh_taunt_goldpiles.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("Hero_BountyHunter.Shuriken")
	return self.bonus_index
end

function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:OnCreated(keys)
	if IsServer() then
		self.bonus_index = 2.4
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"extremely_greed_1") then
			self.bonus_index = 2.55
		end
		self.GameEvent = ListenToGameEvent( "dota_hd_challenge_init", Dynamic_Wrap( self, 'OnHDchallenge_init' ),self )
	end
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:OnDestroy(keys)
	if IsServer() then
		if self.GameEvent then
			StopListeningToGameEvent(self.GameEvent)
		end
	end
end

function modifier_heroTalent_npc_dota_hero_bounty_hunter_2:OnHDchallenge_init(keys)

	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		-- local target =  EntIndexToHScript(keys.target)
		if unit==self:GetParent() then
			if keys.difficulty==5 then
				self:GetAbility():AddStack()
			end
		end

	end
end
