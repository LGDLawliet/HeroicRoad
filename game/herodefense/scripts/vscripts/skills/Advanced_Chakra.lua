--特效优化 √

LinkLuaModifier( "modifier_Advanced_Chakra_buff", "skills/Advanced_Chakra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chakra_unlock1", "skills/Advanced_Chakra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chakra_unlock2", "skills/Advanced_Chakra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chakra_unlock3", "skills/Advanced_Chakra", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Advanced_Chakra_debuff", "skills/Advanced_Chakra", LUA_MODIFIER_MOTION_NONE )

Advanced_Chakra = class({})
function Advanced_Chakra:CheckKV(key)
	local table = {
		mana_return =20,
		bonus_mana_return = 0.1,
		cooldown_reduce = 0.3,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Chakra:UnlockFirstCore(key)
	return true
end
function Advanced_Chakra:UnlockSecondCore(key)
	return true
end
function Advanced_Chakra:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,nil,"modifier_Advanced_Chakra_unlock3",{duration=40})
	modifier.ability = self
	return true
end


--------------------------------------------------------------------------------
-- Ability Start
function Advanced_Chakra:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	local mana_return = self:GetSpecialValueFor("mana_return")+(self:GetSpecialValueFor("bonus_mana_return"))*caster:GetIntellect(false)
	local time = self:GetSpecialValueFor("cooldown_reduce")
	local buff_duration = 10
	local index = 3
	if self.advanced_level>=5 then
		buff_duration = 15
		if self.advanced_level>=10 then
			index = 2
		end
	end
	if self:GetAutoCastState() then
		time = time*3
		mana_return = mana_return*3
		local cooldown = self:GetCooldownTimeRemaining()
		self:StartCooldown(cooldown*index)
		buff_duration = buff_duration*3
	end
	target:GiveMana(mana_return)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, mana_return, nil)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)


	-- effects
	target:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")

	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_Advanced_Chakra_buff", {duration = buff_duration*gain})
	if self.unlock2 then
		local modifier = target:AddNewModifier(caster, self, "modifier_Advanced_Chakra_unlock2", {duration = buff_duration*gain})
		if modifier then
			if self:GetAutoCastState() then
				modifier:SetStackCount(600)
			else
				modifier:SetStackCount(200)
			end
		end
	end
	for i=0, target:GetAbilityCount() - 1 do
		local Ability = target:GetAbilityByIndex(i)
		if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
			
	
			local newCooldown = Ability:GetCooldownTimeRemaining() - time
			Ability:EndCooldown()
			-- Ability:StartCooldown(newCooldown)
			if newCooldown>0 then
				Ability:StartCooldown(newCooldown)
			end
			break
		end
	end







end




modifier_Advanced_Chakra_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chakra_buff:IsHidden()	return false end
function modifier_Advanced_Chakra_buff:IsDebuff()	return false end
function modifier_Advanced_Chakra_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_INVULNERABLE 
end

function modifier_Advanced_Chakra_buff:IsPurgable()	return true end



--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Chakra_buff:OnCreated( kv )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	-- references
	self.cooldown_reduce = 0.5
	self.bonus= 0
	if self.advanced_level>=20 then
		self.bonus = 1
	end


	if IsServer() then
		self:StartIntervalThink(1)
		self.unlock1Mana = 0
		local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_Advanced_Chakra_unlock1",caster)
		if modifier then
			modifier:Destroy()
		end
	end
end

function modifier_Advanced_Chakra_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(0)
		local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_Advanced_Chakra_unlock1",self:GetCaster())
		if modifier then
			modifier:Destroy()
		end
	end
end


function modifier_Advanced_Chakra_buff:OnIntervalThink( kv )


	if IsServer() then
		for i=0, self:GetParent():GetAbilityCount() - 1 do
			local Ability = self:GetParent():GetAbilityByIndex(i)
			if Ability ~= nil and Ability ~= self:GetAbility()  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then

		
				local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduce
				Ability:EndCooldown()
				if newCooldown>0 then
					Ability:StartCooldown(newCooldown)
				end
				
				break
			end
		end
		if self.advanced_level>=15 then
			self:IncrementStackCount()
		end
	end
end




function modifier_Advanced_Chakra_buff:DeclareFunctions()
	if self:GetAbility():GetUnlock(1)==1 then
		return {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
			MODIFIER_EVENT_ON_SPENT_MANA,
			
	
		}
	end
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Advanced_Chakra_buff:GetModifierBonusStats_Strength()	return self.bonus*self:GetStackCount() end
function modifier_Advanced_Chakra_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_Advanced_Chakra_buff:GetModifierBonusStats_Agility()	return self.bonus*self:GetStackCount() end
function modifier_Advanced_Chakra_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability and ability.unlock1 and self.unlock1Mana>0 then
			local modifier = self:GetParent():AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Chakra_unlock1", {})
			if modifier then
				modifier:SetStackCount(math.min(20000,self.unlock1Mana))
			end
		end
	end
end
function modifier_Advanced_Chakra_buff:OnSpentMana(keys)
	if IsServer() then
		-- PrintTable(keys)
		if keys.cost<=0 then
			return
		end
		if keys.unit~=self:GetParent() then
			return
		end
		self.unlock1Mana  = self.unlock1Mana+ keys.cost
	end
end







modifier_Advanced_Chakra_unlock1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chakra_unlock1:IsHidden()	return false end
function modifier_Advanced_Chakra_unlock1:IsDebuff()	return false end
function modifier_Advanced_Chakra_unlock1:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_Advanced_Chakra_unlock1:IsPurgable()	return false end
function modifier_Advanced_Chakra_unlock1:IsPurgeException() return true end
function modifier_Advanced_Chakra_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end


function modifier_Advanced_Chakra_unlock1:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
	end
end


function modifier_Advanced_Chakra_unlock1:DeclareFunctions()

	return {
		MODIFIER_PROPERTY_MANA_BONUS,    

		

	}
end


function modifier_Advanced_Chakra_unlock1:GetModifierManaBonus()	return self:GetStackCount() end








modifier_Advanced_Chakra_unlock2 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chakra_unlock2:IsHidden()	return true end
function modifier_Advanced_Chakra_unlock2:IsDebuff()	return false end
function modifier_Advanced_Chakra_unlock2:IsPurgable()	return true end
function modifier_Advanced_Chakra_unlock2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_Chakra_unlock2:Advanced_GetModifierSpellAmplifyBonus(keys)   
	if IsClient() then
		return self:GetStackCount()
	end
	if keys.inflictor then
		self:SafeDestroy()
		return self:GetStackCount()
	end
	return 0
end







modifier_Advanced_Chakra_unlock3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chakra_unlock3:IsHidden()	return false end
function modifier_Advanced_Chakra_unlock3:IsDebuff()	return false end
function modifier_Advanced_Chakra_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Chakra_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Chakra_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_Chakra_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Chakra_unlock3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Chakra_unlock3:GetTexture() return "keeper_of_the_light_chakra_magic" end
function modifier_Advanced_Chakra_unlock3:OnCreated()
	if IsServer() then
		self.health = 0
		self.mana = 0
		self.str = 0
		self.agi = 0
		self.int = 0
		self:StartIntervalThink(0.2)
	end
end
function modifier_Advanced_Chakra_unlock3:OnIntervalThink()
	if Game_State:IsInBattle() then
		if self:GetRemainingTime()<=0 then
			local switch = {
                [1] = function ()
					self.health = self.health +50
                end,

                [2] = function ()
					self.mana = self.mana +25
                end,

                [3] = function ()
					self.str = self.str + 2
                end,
				[4] = function ()
					self.agi = self.agi + 2
                end,
				[5] = function ()
					self.int = self.int +2
                end,
                
            }
			local test = switch[RandomInt(1, 5)]
            if test then
                local result = test()
            end
			self:IncrementStackCount()
			if  self:GetStackCount() >=200 then
				self:StartIntervalThink(-1)
				if self.ability and not self.ability:IsNull() then
					self.ability.unlock2 = false
					self.ability.CoreUnlock = false
					local NetTable_key = tostring(self:GetCaster():GetPlayerID()).."_".."Advanced_Chakra".."_unlock"
					CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =-1 } )  --更新网表
				end

				return
			end
			self:SetDuration(40, true)
		end
	else
		self:SetDuration(self:GetRemainingTime()+0.2, true)
	end

end
function modifier_Advanced_Chakra_unlock3:DeclareFunctions()

	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
		

	}
end


function modifier_Advanced_Chakra_unlock3:GetModifierBonusStats_Strength()	return self.str end
function modifier_Advanced_Chakra_unlock3:GetModifierBonusStats_Intellect()	return self.int end
function modifier_Advanced_Chakra_unlock3:GetModifierBonusStats_Agility()	return self.agi end
function modifier_Advanced_Chakra_unlock3:GetModifierHealthBonus()	return self.health end
function modifier_Advanced_Chakra_unlock3:GetModifierManaBonus()	return self.mana end

function modifier_Advanced_Chakra_unlock3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end


	if Game_State:IsInBattle() then
		if self:GetStackCount()<200 then
			self:SetDuration(math.max(self:GetRemainingTime()-2,0.1), true)
		end
	end

end
