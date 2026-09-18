heroTalent_npc_dota_hero_abyssal_underlord_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_2", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord_2", LUA_MODIFIER_MOTION_HORIZONTAL  )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_abyssal_underlord_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_abyssal_underlord_2"
end

function heroTalent_npc_dota_hero_abyssal_underlord_2:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_abyssal_underlord_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/underlord/underlord_2/effect.vpcf", context )
end

function heroTalent_npc_dota_hero_abyssal_underlord_2:Unlockachievement()
	self.customAchievement = true
	-- print("解锁")
end
function heroTalent_npc_dota_hero_abyssal_underlord_2:OnCustomDataSettlement()
	if self.customAchievement then
		-- print("条件满足")
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			-- modifier:abyssal_underlordTalent2()
			modifier:UnlockCustomData("self_decline_1")
		end
	end

end



modifier_heroTalent_npc_dota_hero_abyssal_underlord_2 = class({})

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:OnCreated(keys)
	if IsServer() then
		self.bonus = 0.025
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"self_decline_1") then
			-- print("获得奖励")
			self.bonus = 0.027
		end
	end
end



function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:OnDeath(keys)
    if not IsServer() then
        return
    end
	--仅战斗回合有用
	if not Game_State:IsInBattle() then
		return
	end
	local parent = self:GetParent()
	if keys.unit~=parent then
		if parent:PassivesDisabled() then
			return
		end
		local dis = CalculateDistance(keys.unit,parent)
		if dis<=1000 then
			local gain = self:GetParent():GetModifierDurationGainIndex(1)
			self:PlayEffects( keys.unit )
			local index =  _G.GAME_ROUND>=20 and (self.bonus*2) or self.bonus

			local stack = math.floor(parent:GetDamageMax()*index)
			parent:AddNewModifier(parent,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff",{	duration = 60*gain,stack = stack})
		end
	end


end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2:PlayEffects(target)
	local particle_cast = "particles/rebuild/talent/underlord/underlord_2/effect.vpcf"


	-- Get Data
	local caster = self:GetCaster()


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect_cast,0,caster,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,1,caster,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,2,target,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )

	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle(effect_cast, false)
		ParticleManager:ReleaseParticleIndex(effect_cast)
	end)


end






modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff = class({})

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:GetModifierPreAttack_BonusDamage()	return math.min(self:GetStackCount(),8000) end


function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = keys.stack })
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		table.insert(self.tData, {dieTime = dieTime,stack = keys.stack })
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:OnIntervalThink()
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


function modifier_heroTalent_npc_dota_hero_abyssal_underlord_2_buff:OnDestroy()

	if IsServer() then
		if self:GetStackCount()>=8000 then
			self:GetAbility():Unlockachievement()
		end
	end
end



