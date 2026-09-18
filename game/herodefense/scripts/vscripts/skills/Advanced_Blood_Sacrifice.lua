
Advanced_Blood_Sacrifice = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Blood_Sacrifice_buff", "skills/Advanced_Blood_Sacrifice", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Blood_Sacrifice_unlock3", "skills/Advanced_Blood_Sacrifice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blood_Sacrifice_unlock3_buff", "skills/Advanced_Blood_Sacrifice", LUA_MODIFIER_MOTION_NONE)

function Advanced_Blood_Sacrifice:CheckKV(key)
	local table = {
		buff_duration = 0.5,




	}
	local value = table[key] or -1
	return value

end

function Advanced_Blood_Sacrifice:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
function Advanced_Blood_Sacrifice:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Blood_Sacrifice:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end


function Advanced_Blood_Sacrifice:IsHiddenWhenStolen() 		return true end
function Advanced_Blood_Sacrifice:IsRefreshable() 			return true end
function Advanced_Blood_Sacrifice:IsStealable() 			return false end
function Advanced_Blood_Sacrifice:IsNetherWardStealable()	return false end

function Advanced_Blood_Sacrifice:OnSpellStart()
	self.advanced_level =self:GetSpecialValueFor("advanced_level")
	local caster = self:GetCaster()	
	local hp_percent = self:GetSpecialValueFor("hp_percent") * 0.01
	local damage = caster:GetHealth() *hp_percent
	if caster:GetHealth() ~= 1 then
		
		caster:SetHealth(caster:GetHealth() -damage)
	end	
	local random_response = RandomInt(1, 4)
	caster:EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
	caster:EmitSound("Hero_OgreMagi.Bloodlust.Target")
	local ModifierStatusGain =caster:GetModifierDurationGainIndex(0.7)
	local duration = self:GetSpecialValueFor("buff_duration")
	duration = math.min(duration*3,duration*ModifierStatusGain)

	local chance =0
	--LV5解锁叠加态+
	if self.advanced_level>=5 then
		chance = 30
		--LV20解锁叠加态++
		if self.advanced_level>=20 then
			chance = 100
		end
	end
	if caster:GetRandomEffect(chance,INT_TYPE,0.5) >=RandomInt(1, 100) then
		caster:AddNewModifier(caster, self, "modifier_Advanced_Blood_Sacrifice_buff", {duration = duration})
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_Blood_Sacrifice_buff", {duration =duration})

	

end



function Advanced_Blood_Sacrifice:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
		end
		if coreUnlockKV.coreUnlock ==3 then
			if self:GetCaster():HasModifier("modifier_Advanced_Blood_Sacrifice_unlock3") then
				return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
			else	
				return DOTA_ABILITY_BEHAVIOR_PASSIVE
			end
		
		end
		
	end


	return self.BaseClass.GetBehavior(self)
	
end

modifier_Advanced_Blood_Sacrifice_buff = advanced_modifier({})

function modifier_Advanced_Blood_Sacrifice_buff:IsDebuff()				return false end
function modifier_Advanced_Blood_Sacrifice_buff:IsHidden() 			return false end
function modifier_Advanced_Blood_Sacrifice_buff:IsPurgable() 			return true end
function modifier_Advanced_Blood_Sacrifice_buff:IsPurgeException() 	return true end

--function modifier_Advanced_Blood_Sacrifice_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Blood_Sacrifice_buff:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	} 
end





-- function modifier_Advanced_Blood_Sacrifice_buff:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_buff:GetModifierDamageOutgoing_Percentage() return (self.attack_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_buff:AdvancedGetModifierExtraHealthPercentage() return (self.bonus_health*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_buff:AdvancedGetModifierConstantHealthRegenPercentage() return (self.bonus_health_regen*self.gain_index) end




function modifier_Advanced_Blood_Sacrifice_buff:GetModifierAttackSpeedBonus_Constant() return (self.attack_speed_bonus*self.gain_index)  end 
function modifier_Advanced_Blood_Sacrifice_buff:Advanced_GetModifierSpellAmplifyBonus() return (self.ability_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_buff:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_Advanced_Blood_Sacrifice_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_Blood_Sacrifice_buff:OnCreated(params)
	local ability = self:GetAbility()
	self.cast_distance = ability:GetSpecialValueFor("cast_distance")
	self.attack_damage_bonus = ability:GetSpecialValueFor("attack_damage_bonus")
	self.attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.ability_damage_bonus = ability:GetSpecialValueFor("ability_damage_bonus")
	self.bonus_reduce_index = 0.94
	self.bonus_health = 0
	self.bonus_health_regen = 0
	if ability:GetSpecialValueFor('advanced_level')>=20 then
		self.bonus_reduce_index = 0.95
		if ability:GetUnlock(1)==1 then
			self.bonus_reduce_index = 0.983
	
		end
		if ability:GetUnlock(2)==2 then
			self.bonus_health = 8
			self.bonus_health_regen = 0.7
		end
	end


	self.gain_index = 1
	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	if IsServer() then

		self:IncrementStackCount()
		self.life_steal =ability:GetSpecialValueFor("hero_lifesteal")
		--LV10解锁血怒+
		if ability.advanced_level>=10 then
			self.life_steal = self.life_steal *1.5
		end
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Blood_Sacrifice_buff:OnRefresh(params)
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	self.attack_damage_bonus = self:GetAbility():GetSpecialValueFor("attack_damage_bonus")
	self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.ability_damage_bonus = self:GetAbility():GetSpecialValueFor("ability_damage_bonus")
	table.insert(self.tData, {dieTime = self:GetDieTime() })
	if IsServer() then
		
		self:IncrementStackCount()
		self.life_steal = self:GetAbility():GetSpecialValueFor("hero_lifesteal")
		--LV10解锁血怒+
		if self:GetAbility().advanced_level>=10 then
			self.life_steal = self.life_steal *1.5
			if self:GetAbility().advanced_level>=15 then
				for i = #self.tData, 1, -1 do
					if i<=13 then
						self.tData[i].dieTime = self.tData[i].dieTime + 5
						
					end
				end
			end
		end
	end
	local stack = self:GetStackCount()
	local now_index = 1
	self.gain_index = 1
	for i = 2, stack, 1 do
		now_index = now_index *self.bonus_reduce_index
		self.gain_index = self.gain_index + now_index
	end

end
--onattacklanded 时添加一层modifier_Advanced_Blood_Sacrifice_buff
-- function modifier_Advanced_Blood_Sacrifice_buff:OnAttackLanded(keys)
-- 	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
-- 		return
-- 	end
-- 	--血量低于28%时不触发
-- 	if self:GetParent():GetHealthPercent()<=28 then
-- 		return
-- 	end
-- 	--LV15解锁回馈
-- 	if  self:GetAbility().advanced_level<15 then return end
	
	
-- 	local caster = self:GetParent()
-- 	local hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent") * 0.01
-- 	local damage = caster:GetHealth() *hp_percent
-- 	--当魔法值小于施法所需要的魔法值不触发本效果
-- 	if caster:GetMana()<= self:GetAbility():GetManaCost(-1) then
-- 		return
-- 	end
-- 	if caster:GetHealth() ~= 1 then
		
-- 		caster:SetHealth(caster:GetHealth() -damage)
-- 	end	
-- 	--如果有层数则增加一层
-- 	if self:GetStackCount() and self:GetStackCount()>=1  then
-- 		self:IncrementStackCount()
-- 		--减少魔法值
-- 		caster:SpendMana(self:GetAbility():GetManaCost(-1), self:GetAbility())

-- 	end

-- end	

function modifier_Advanced_Blood_Sacrifice_buff:OnIntervalThink()

	local fGameTime = GameRules:GetGameTime()
	local change = false
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].dieTime then
			table.remove(self.tData, i)
			if IsServer() then
				self:DecrementStackCount()

			end
			change = true
			
		end
	end
	if change then
		local stack = self:GetStackCount()
		local now_index = 1
		self.gain_index = 1
		for i = 2, stack, 1 do
			now_index = now_index *self.bonus_reduce_index
			self.gain_index = self.gain_index + now_index
		end
	end

end
function modifier_Advanced_Blood_Sacrifice_buff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local ModifierStatusGain = Attacker:GetModifierDurationGainIndex(1)
		local flLifesteal = flDamage * self.life_steal*ModifierStatusGain
		Attacker:Heal( flLifesteal, ability)
	end

	return 0.0

end


-- advanced_modifier
function modifier_Advanced_Blood_Sacrifice_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
    }
end
function modifier_Advanced_Blood_Sacrifice_buff:Advanced_GetModifierCastRangeBonusStacking(keys)
	return  (self.cast_distance*self.gain_index)
end







modifier_Advanced_Blood_Sacrifice_unlock3 = class({})

function modifier_Advanced_Blood_Sacrifice_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Blood_Sacrifice_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Blood_Sacrifice_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Blood_Sacrifice_unlock3:IsHidden()				return true end
function modifier_Advanced_Blood_Sacrifice_unlock3:IsDebuff() return false end
function modifier_Advanced_Blood_Sacrifice_unlock3:OnCreated(keys)
    if IsServer() then
        self:StartIntervalThink(0.05)
    end
end

function modifier_Advanced_Blood_Sacrifice_unlock3:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:GetAutoCastState() then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_Advanced_Blood_Sacrifice_buff")
		if modifier then
			local stack = modifier:GetStackCount()
			local new_modifier = caster:AddNewModifier(caster, ability, "modifier_Advanced_Blood_Sacrifice_unlock3_buff", {})
			if new_modifier then
				new_modifier:SetStackCount(stack)
				self:StartIntervalThink(-1)
				self:SafeDestroy()
				modifier:SafeDestroy()
				
			end

		end
	end
end


modifier_Advanced_Blood_Sacrifice_unlock3_buff = advanced_modifier({})

function modifier_Advanced_Blood_Sacrifice_unlock3_buff:IsDebuff()				return false end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:IsHidden() 			return false end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:IsPurgable() 			return false end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:IsPurgeException() 	return false end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:RemoveOnDeath() return false end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:DeclareFunctions() return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
} 
end
-- function modifier_Advanced_Blood_Sacrifice_unlock3_buff:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:GetModifierDamageOutgoing_Percentage() return (self.attack_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:GetModifierAttackSpeedBonus_Constant() return (self.attack_speed_bonus*self.gain_index)  end 
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:Advanced_GetModifierSpellAmplifyBonus() return (self.ability_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_Blood_Sacrifice_unlock3_buff:OnCreated(params)
	local ability = self:GetAbility()
	self.cast_distance = ability:GetSpecialValueFor("cast_distance")
	self.attack_damage_bonus = ability:GetSpecialValueFor("attack_damage_bonus")
	self.attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.ability_damage_bonus = ability:GetSpecialValueFor("ability_damage_bonus")
	self.bonus_reduce_index = 0.95
	self.gain_index = 1
	self:StartIntervalThink(0.5)
	if IsServer() then
		self:IncrementStackCount()
		self.life_steal =ability:GetSpecialValueFor("hero_lifesteal")*1.5
		
	end
end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:OnIntervalThink()
	local stack = self:GetStackCount()
	local now_index = 1
	self.gain_index = 1
	for i = 2, stack, 1 do
		now_index = now_index *self.bonus_reduce_index
		self.gain_index = self.gain_index + now_index
	end
	self:StartIntervalThink(-1)
end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local ModifierStatusGain = Attacker:GetModifierDurationGainIndex(1)
		local flLifesteal = flDamage * self.life_steal*ModifierStatusGain
		Attacker:Heal( flLifesteal, ability)
	end

	return 0.0

end


-- advanced_modifier
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_Blood_Sacrifice_unlock3_buff:Advanced_GetModifierCastRangeBonusStacking(keys)
	return  (self.cast_distance*self.gain_index)
end

