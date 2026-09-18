heroTalent_npc_dota_hero_tinker_2 = heroTalent_npc_dota_hero_tinker_2 or  class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_2_thinker", "heroTalent/heroTalent_npc_dota_hero_tinker_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_2", "heroTalent/heroTalent_npc_dota_hero_tinker_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_tinker_2:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/cast_effect/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/effect.vpcf", context )

	

-- end
function heroTalent_npc_dota_hero_tinker_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tinker_2"
end

function heroTalent_npc_dota_hero_tinker_2:Spawn()
	if IsServer() then
		self.changeScale = 1.6
		self.wave_finish_count = 0
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"acceleration_mode_1") then
			self.changeScale = 1.7
		end
		if IsInToolsMode() then
			self.changeScale = 4
		end
	end
end
function heroTalent_npc_dota_hero_tinker_2:AddWave()
	self.wave_finish_count = self.wave_finish_count + 1
end
function heroTalent_npc_dota_hero_tinker_2:OnCustomDataSettlement()
	if self.wave_finish_count>=15 then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			-- modifier:TinkerTalent2()
			modifier:UnlockCustomData("acceleration_mode_1")
			
		end
	end

end

function heroTalent_npc_dota_hero_tinker_2:OnSpellStart()
	local caster = self:GetCaster()
	uimanager:ChegeTimeScaleOrder(caster:GetPlayerOwnerID(),self.changeScale or 1.6)
	caster:EmitSound("Hero_Tinker.Rearm")

end


modifier_heroTalent_npc_dota_hero_tinker_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tinker_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tinker_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tinker_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_tinker_2:OnWaveStart()
	if _G.GAME_TIME_SCALE==1.6 then
		self.time_scale_trigger = true
	else
		self.time_scale_trigger = false
	end

end


function modifier_heroTalent_npc_dota_hero_tinker_2:OnWaveEnd()
	if self.time_scale_trigger and _G.GAME_TIME_SCALE==1.6 then
		
		self:GetAbility():AddWave()
	end
end

function modifier_heroTalent_npc_dota_hero_tinker_2:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
