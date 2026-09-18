--
heroTalent_npc_dota_hero_windrunner_2 = heroTalent_npc_dota_hero_windrunner_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_windrunner_2", "heroTalent/heroTalent_npc_dota_hero_windrunner_2", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_windrunner_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_windrunner_2"
end

function heroTalent_npc_dota_hero_windrunner_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )

end



function heroTalent_npc_dota_hero_windrunner_2:Unlockachievement()
	print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_windrunner_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("family_man_1")
		end
	end

end



modifier_heroTalent_npc_dota_hero_windrunner_2 =modifier_heroTalent_npc_dota_hero_windrunner_2 or  class({})

function modifier_heroTalent_npc_dota_hero_windrunner_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_windrunner_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_windrunner_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_windrunner_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_windrunner_2:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_windrunner_2:GetEffectName() return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_debut_ambient_ground_arcs_pnt.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_windrunner_2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_windrunner_2:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_int  = 0
	self.move_max = self.ability:GetSpecialValueFor("move_max")
	self.move_to_int = self.ability:GetSpecialValueFor("move_to_int")*0.01
	self.line = self.ability:GetSpecialValueFor("line")

	self.move_to_int_t = self.move_to_int*self.ability:GetTalentGain(0.25)
	if IsServer() then
		self.sayTime = 0
		self.stackCountAdd= self.ability:GetSpecialValueFor("move")
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"family_man_1") then
			self.stackCountAdd = self.stackCountAdd + 10
			self.family_man_1 = true
		end
		self:StartIntervalThink(0.1)
 		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:OnIntervalThink()
	local parent = self:GetParent()
	local move_speed = parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false)
	if parent:IsStunned() or parent:IsFrozen() or parent:IsHexed() or parent:IsRooted() then
		self.bonus_int = 0
	else
		self.move_to_int_t = self.move_to_int*self.ability:GetTalentGain(0.25)
		local gain = move_speed*self.move_to_int_t
		self.bonus_int = (math.min(gain,1500))
	end
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:OnSendMessage()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		local parent = self:GetParent()
		if parent:GetHealthPercent()<=30 then
			local pass= false
			local heroes = GetAllRealHeroes()
			for _, hero in ipairs(heroes) do
				if hero~=parent then
					pass = true
					Timers:CreateTimer(RandomFloat(0.2, 1), function()
						Say(hero, "Yeah!", true)
					end)
				end
				
			end
			if pass then
				self:SetStackCount(math.min(self:GetStackCount()+self.stackCountAdd,2000))
				ability:UseResources(true,true,true,true)
				EmitSoundOn("Hero_Windrunner.GaleForce", parent)	
				local pfx_name = "particles/rebuild/spell/summon_wind_element/effect.vpcf"
				local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControl(pfx, 0, parent:GetOrigin())
				DestroyParticleByDelay(pfx,3)

			end
			-- Say(entity: CBaseEntity | nil, message: string, teamOnly: bool)
		end
	end
	if not self.family_man_1 then
		self.sayTime = self.sayTime + 1
		if self.sayTime>=10 then
			self:GetAbility():Unlockachievement()
			self.family_man_ = true
		else
			Timers:CreateTimer(10, function()
				self.sayTime = self.sayTime - 1
			end)
		end



	end
	
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:GetModifierIgnoreMovespeedLimit()             return   1  end

function modifier_heroTalent_npc_dota_hero_windrunner_2:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end


function modifier_heroTalent_npc_dota_hero_windrunner_2:OnTooltip()
	self.move_to_int = self.ability:GetSpecialValueFor("move_to_int")*0.01
	self.move_to_int_t = self.move_to_int*self.ability:GetTalentGain(0.25)

	local parent = self:GetParent()
	local move_speed = parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false)
	if parent:IsStunned() or parent:IsFrozen() or parent:IsHexed() or parent:IsRooted() then
		self.bonus_int = 0
	else
		self.move_to_int_t = self.move_to_int*self.ability:GetTalentGain(0.25)
		local gain = move_speed*self.move_to_int_t
		self.bonus_int = (math.min(gain,1500))
	end

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.move_to_int_t*100
    elseif self._tooltip == 2 then
        return self:GetStackCount()
	elseif self._tooltip == 3 then
        return self.bonus_int
    end
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:AddCustomTransmitterData( )
	return
	{
		bonus_int = self.bonus_int,
	}
end

function modifier_heroTalent_npc_dota_hero_windrunner_2:HandleCustomTransmitterData( data )
	self.bonus_int = data.bonus_int
end