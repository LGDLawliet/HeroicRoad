heroTalent_npc_dota_hero_bloodseeker_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_bloodseeker_2", "heroTalent/heroTalent_npc_dota_hero_bloodseeker_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect", "heroTalent/heroTalent_npc_dota_hero_bloodseeker_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_bloodseeker_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_bloodseeker_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_bloodseeker_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_bloodseeker_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_bloodseeker_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_bloodseeker_2" end
function heroTalent_npc_dota_hero_bloodseeker_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_explode.vpcf", context )

end

function heroTalent_npc_dota_hero_bloodseeker_2:Spawn()
	self.killCount = 0
end

function heroTalent_npc_dota_hero_bloodseeker_2:Unlockachievement()
	-- print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_bloodseeker_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("madness_1")
		end
	end

end

function heroTalent_npc_dota_hero_bloodseeker_2:AddKill()
	self.killCount = self.killCount + 1
	-- print("killCount="..self.killCount)
	if not self.customAchievement and self.killCount>=5 then
		self:Unlockachievement()
	end
end



modifier_heroTalent_npc_dota_hero_bloodseeker_2 = class({})

function modifier_heroTalent_npc_dota_hero_bloodseeker_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end


function modifier_heroTalent_npc_dota_hero_bloodseeker_2:OnCreated(keys)

	if IsServer() then
		self.duration = 13
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"madness_1") then
			self.duration = self.duration + 2
		end
	end
end







function modifier_heroTalent_npc_dota_hero_bloodseeker_2:OnDeath(keys)
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	if parent:PassivesDisabled() then
		return
	end
	if parent~=keys.attacker then
		return
	end
	
	if CalculateDistance(keys.unit,parent)>1000 then
		return
	end

	parent:EmitSound("hero_bloodseeker.bloodRite")
	-- local ability = self:GetAbility()

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
	ParticleManager:SetParticleControl( nFXIndex, 0, keys.unit:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(128,1,1) )
	-- ParticleManager:SetParticleControlEnt(nFXIndex, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)


	local duration = self.duration
	local stack = 1
	if keys.unit:IsRealHero() then
		duration = duration*10
		stack = 5
		self:GetAbility():AddKill()
	end
	local gain = parent:GetModifierDurationGainIndex(1)
	duration = duration * gain
	if parent:GetHealthPercent()<100 then
		local healing = HealWithGain(parent:GetMaxHealth()*0.05,parent,parent,self:GetAbility())
		if healing>=100 then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		end
	
	end

	parent:AddNewModifier(
		parent,
		self:GetAbility(),
		"modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect", {duration=duration,stack=stack,stack_time=duration}
	)

end





modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect = class({})

function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:RemoveOnDeath()  return false end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf" end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:GetActivityTranslationModifiers( params )
	if self:GetStackCount()>=3 then
		return "thirst"
	end
end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	return 25*self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:GetModifierMoveSpeedBonus_Constant( params )
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	return 25*self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+keys.stack_time

		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_heroTalent_npc_dota_hero_bloodseeker_2_effect:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end



