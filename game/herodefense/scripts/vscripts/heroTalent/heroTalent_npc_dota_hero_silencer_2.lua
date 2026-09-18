heroTalent_npc_dota_hero_silencer_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer_2", "heroTalent/heroTalent_npc_dota_hero_silencer_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer_2_buff", "heroTalent/heroTalent_npc_dota_hero_silencer_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_silencer_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_silencer_2"
end

function heroTalent_npc_dota_hero_silencer_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf" , context )
end

function heroTalent_npc_dota_hero_silencer_2:Unlockachievement()
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_silencer_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("genius_1")
		end
	end

end

modifier_heroTalent_npc_dota_hero_silencer_2 = class({})

function modifier_heroTalent_npc_dota_hero_silencer_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_silencer_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_silencer_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_silencer_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_heroTalent_npc_dota_hero_silencer_2:OnCreated(keys)
	if IsServer() then
		self.duration_index = 0.7
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"genius_1") then
			-- print("获得奖励")
			self.duration_index = 0.65
		end
	end
end


function modifier_heroTalent_npc_dota_hero_silencer_2:GetModifierProcAttack_BonusDamage_Magical() 
	if IsServer() then
		local parent = self:GetParent()
		if parent:PassivesDisabled() then
			return 0
		end
		return parent:GetIntellect(false)
	end
end

function modifier_heroTalent_npc_dota_hero_silencer_2:GetModifierProjectileName()
    if IsServer() and not self:GetParent():PassivesDisabled() then
        return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf" 
    end	
end 


function modifier_heroTalent_npc_dota_hero_silencer_2:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	local parent = self:GetParent()
	if parent:PassivesDisabled() or not parent:IsAlive() or parent:IsIllusion() then
		return
    end
    if keys.target:IsMagicImmune() then
        return
    end

    if not parent:IsApplyModifier()  then
        return
    end
    if keys.attacker == parent then 

		local duration = 90*parent:GetModifierDurationGainIndex(1)
		duration = math.min(duration,220)
		local modifier = parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_silencer_2_buff")
		if modifier then
			duration = duration-modifier:GetStackCount()*self.duration_index
		end
		if duration>0 then
			parent:AddNewModifier(
			parent,
			self:GetAbility(),
			"modifier_heroTalent_npc_dota_hero_silencer_2_buff",
			{	duration = duration,stack_time = duration}  
    	)
		end
		
        
	end 
end  








modifier_heroTalent_npc_dota_hero_silencer_2_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_silencer_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_silencer_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_silencer_2_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_silencer_2_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_silencer_2_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+params.stack_time
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		if self:GetStackCount()>=200 then
			
			self:GetAbility():Unlockachievement()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_silencer_2_buff:OnIntervalThink()
	if IsServer() then

		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


