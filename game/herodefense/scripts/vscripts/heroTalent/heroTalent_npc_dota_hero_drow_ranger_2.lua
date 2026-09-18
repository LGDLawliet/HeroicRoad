heroTalent_npc_dota_hero_drow_ranger_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_drow_ranger_2", "heroTalent/heroTalent_npc_dota_hero_drow_ranger_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect", "heroTalent/heroTalent_npc_dota_hero_drow_ranger_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_drow_ranger_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_drow_ranger_2"
end

function heroTalent_npc_dota_hero_drow_ranger_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/drow/drow_arcana/drow_arcana_loadout_spawn_crossbow_load_v2.vpcf", context )

end

function heroTalent_npc_dota_hero_drow_ranger_2:Unlockachievement()
	-- print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_drow_ranger_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("precipitate_1")
		end
	end

end




modifier_heroTalent_npc_dota_hero_drow_ranger_2 = class({})

function modifier_heroTalent_npc_dota_hero_drow_ranger_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:OnCreated( kv )

	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() then
		local caster = self:GetCaster()
		caster:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect", -- modifier name
			{} -- kv
		)
	
	end
end

modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:OnCreated( kv )

	if IsServer() then
		self.max_stack = 30
		self.wave_count = 0
		local interval = 1
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"precipitate_1") then
			-- print("achievement ok")
			interval = 0.9
		end
		self:StartIntervalThink(interval)
	end
end



function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stack))
end

--------------------------------------------------------------------------------
-- Modifier Effects
-- function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

-- 	}

-- 	return funcs
-- end

-- function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if IsClient() then
-- 		return self:GetStackCount()*30
-- 	end
-- 	if not keys.target then
-- 		return
-- 	end

-- 	if  not self.trigger then
-- 		self:SetDuration(0, true)
-- 		self.trigger = true
-- 		self:GetAbility():StartCooldown(2)

-- 	end

-- 	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_loadout_spawn_crossbow_load_v2.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
-- 	ParticleManager:SetParticleControlEnt( nFXIndex, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.target:GetAbsOrigin(), true )
-- 	ParticleManager:ReleaseParticleIndex(nFXIndex)

	
-- 	return self:GetStackCount()*15
-- end


function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:OnWaveStart()
	if self:GetStackCount()>=self.max_stack then
		self.trigger = true
	end
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:OnWaveEnd()
	if self.trigger then
		self.wave_count = self.wave_count + 1
		if self.wave_count>=2 then
			self:GetAbility():Unlockachievement()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return self:GetStackCount()*30
	end
	if not keys.target then
		return
	end

	if  not self.attack_trigger then
		self:SetDuration(0, true)
		self.attack_trigger = true
		self:GetAbility():StartCooldown(2)

	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_loadout_spawn_crossbow_load_v2.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.target:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	
	return self:GetStackCount()*15
end


function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
}
end

-- function modifier_item_hd_skeletology:GetModifierTotalDamageOutgoing_Percentage()	return self:GetStackCount()*2 end
function modifier_heroTalent_npc_dota_hero_drow_ranger_2_effect:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end
