
Advanced_Blood_Lust = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Blood_Lust", "skills/Advanced_Blood_Lust", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Blood_Lust_unlock3", "skills/Advanced_Blood_Lust", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blood_Lust_unlock3_sub", "skills/Advanced_Blood_Lust", LUA_MODIFIER_MOTION_NONE)

function Advanced_Blood_Lust:CheckKV(key)
	local table = {
		move_bonus = 0.4,
		attack_speed_bonus = 2,
		attack_damage_bonus = 2,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Blood_Lust:UnlockFirstCore(key)
	return true
end
function Advanced_Blood_Lust:UnlockSecondCore(key)
	return true
end
function Advanced_Blood_Lust:UnlockThirdCore(key)
	return true
end

function Advanced_Blood_Lust:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/blood_lust/unlock1/ogre_ti8_immortal_bloodlust_buff.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf", context )

	
end






function Advanced_Blood_Lust:IsHiddenWhenStolen() 		return false end
function Advanced_Blood_Lust:IsRefreshable() 			return true end
function Advanced_Blood_Lust:IsStealable() 			return true end
function Advanced_Blood_Lust:IsNetherWardStealable()	return true end
function Advanced_Blood_Lust:GetAOERadius()
	-- local caster = self:GetCaster()
	if self:GetUnlock(2)==2 then
		return 500
	end
		
	return 0		 
end
function Advanced_Blood_Lust:OnSpellStart(scepter)
	local caster = self:GetCaster()
		
	local duration = self:GetSpecialValueFor("buff_duration")
	if self.unlock3 then
		local ModifierStatusGain = 0
		if caster:GetModifierDurationGainIndex(1)>0 then
			ModifierStatusGain = caster:GetModifierDurationGainIndex(1.4)
		else
			ModifierStatusGain = caster:GetModifierDurationGainIndex(0.7)
		end
		duration = math.min(duration*2,duration*ModifierStatusGain)
		caster:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust_unlock3", {duration = duration})
		if caster:GetRandomEffect(30,INT_TYPE,0.5) >=RandomInt(1, 100) then
			caster:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust_unlock3", {duration = duration})
		end
		local pfx1 = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx1)
		caster:EmitSound("Hero_OgreMagi.Bloodlust.Cast")
		return
	end


	local target = self:GetCursorTarget()
	if self.unlock1 then
		duration = 50
	else
		local ModifierStatusGain = 0
		--LV15解锁持久力
		if self.advanced_level>=15 and caster:GetModifierDurationGainIndex(1)>0 then
			ModifierStatusGain = caster:GetModifierDurationGainIndex(1.4)
		else
			ModifierStatusGain = caster:GetModifierDurationGainIndex(0.7)
		end
		duration = math.min(duration*2,duration*ModifierStatusGain)
	end
	
	target:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
	--LV10解锁叠加态+
	if self.advanced_level>=10 and caster:GetRandomEffect(30,INT_TYPE,0.5) >=RandomInt(1, 100) then
		target:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
	end
    local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx1)

	if self.unlock1 then
		local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/rebuild/spell/blood_lust/unlock1/ogre_ti8_immortal_bloodlust_buff.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:ReleaseParticleIndex(pfx1)
	end
	caster:EmitSound("Hero_OgreMagi.Bloodlust.Cast")

	if self.unlock2 then
		local radius = 1000	
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				hero:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
				if caster:GetRandomEffect(30,INT_TYPE,0.5) >=RandomInt(1, 100) then
					hero:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
				end
				local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx1, 2, hero, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx1, 3, hero, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx1)
				return
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				unit:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
				if caster:GetRandomEffect(30,INT_TYPE,0.5) >=RandomInt(1, 100) then
					unit:AddNewModifier(caster, self, "modifier_Advanced_Blood_Lust", {duration = duration})
				end
				local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx1, 2, unit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx1, 3, unit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx1)
				return
			end
		end
	end		
	
end



function Advanced_Blood_Lust:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		end
		
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end


modifier_Advanced_Blood_Lust = advanced_modifier({})

function modifier_Advanced_Blood_Lust:IsDebuff()				return false end
function modifier_Advanced_Blood_Lust:IsHidden() 			return false end
function modifier_Advanced_Blood_Lust:IsPurgable() 			return true end
function modifier_Advanced_Blood_Lust:IsPurgeException() 	return true end
--function modifier_Advanced_Blood_Lust:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end  --允许叠加
function modifier_Advanced_Blood_Lust:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	} 
end

function modifier_Advanced_Blood_Lust:GetModifierMoveSpeedBonus_Percentage() 	return (self.move_bonus*self.gain_index)  end
function modifier_Advanced_Blood_Lust:GetModifierAttackSpeedBonus_Constant() 	return (self.attack_speed_bonus*self.gain_index) end 
function modifier_Advanced_Blood_Lust:GetModifierPreAttack_BonusDamage() 	return (self.attack_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Lust:Advanced_GetModifierSpellAmplifyBonus() 	return (self.ability_damage_bonus*self.gain_index)*self.bonus_index  end
function modifier_Advanced_Blood_Lust:GetModifierBonusStats_Strength()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust:GetModifierBonusStats_Intellect()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust:GetModifierBonusStats_Agility()	return self.gain_index*self.bonus_attribute end
-- function modifier_Advanced_Blood_Lust:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index)*self.bonus_index end



function modifier_Advanced_Blood_Lust:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end
function modifier_Advanced_Blood_Lust:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_Blood_Lust:OnCreated(params)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_index = 1
	--LV5解锁咏唱者+
	if self.advanced_level>=5 then
		self.bonus_index = 1.5
	end
	self.ability_damage_bonus = ability:GetSpecialValueFor("ability_damage_bonus")
	self.casttime = ability:GetSpecialValueFor("cast_time")

	self.move_bonus = ability:GetSpecialValueFor("move_bonus")
	self.attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.attack_damage_bonus = ability:GetSpecialValueFor("attack_damage_bonus")
	self.bonus_attribute = 0
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	--LV20解锁全属性提升
	if self.advanced_level>=20 then
		self.bonus_attribute = 10
	end
	self.bonus_reduce_index = 0.94
	if ability:GetSpecialValueFor('advanced_level')>=10 then
		self.bonus_reduce_index = 0.95
	end
	if ability:GetUnlock(1)==1 then
		self.bonus_reduce_index = 0.975
	end

	self.gain_index = 1
	self:StartIntervalThink(0.1)
	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	if IsServer() then
		self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
		self:IncrementStackCount()
	end

end
function modifier_Advanced_Blood_Lust:OnRefresh(params)
	table.insert(self.tData, {dieTime = self:GetDieTime() })
	if IsServer() then
		
		self:IncrementStackCount()
	end
	local stack = self:GetStackCount()
	local now_index = 1
	self.gain_index = 1
	for i = 2, stack, 1 do
		now_index = now_index *self.bonus_reduce_index
		self.gain_index = self.gain_index + now_index
	end

end

function modifier_Advanced_Blood_Lust:OnIntervalThink()

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







-- advanced_modifier
function modifier_Advanced_Blood_Lust:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint
    }
end
function modifier_Advanced_Blood_Lust:Advanced_GetModifierCastRangeBonusStacking(keys)
	return (self.cast_distance*self.gain_index)*self.bonus_index
end

function modifier_Advanced_Blood_Lust:Advanced_GetModifier_CastPoint() return self.casttime*self.bonus_index end









modifier_Advanced_Blood_Lust_unlock3 = advanced_modifier({})

function modifier_Advanced_Blood_Lust_unlock3:IsDebuff()				return false end
function modifier_Advanced_Blood_Lust_unlock3:IsHidden() 			return false end
function modifier_Advanced_Blood_Lust_unlock3:IsPurgable() 			return true end
function modifier_Advanced_Blood_Lust_unlock3:IsPurgeException() 	return true end
function modifier_Advanced_Blood_Lust_unlock3:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	} 
end


function modifier_Advanced_Blood_Lust_unlock3:GetModifierMoveSpeedBonus_Percentage() 	return (self.move_bonus*self.gain_index)  end
function modifier_Advanced_Blood_Lust_unlock3:GetModifierAttackSpeedBonus_Constant() 	return (self.attack_speed_bonus*self.gain_index) end 
function modifier_Advanced_Blood_Lust_unlock3:GetModifierPreAttack_BonusDamage() 	return (self.attack_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Lust_unlock3:Advanced_GetModifierSpellAmplifyBonus() 	return (self.ability_damage_bonus*self.gain_index)*self.bonus_index  end
function modifier_Advanced_Blood_Lust_unlock3:GetModifierBonusStats_Strength()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust_unlock3:GetModifierBonusStats_Intellect()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust_unlock3:GetModifierBonusStats_Agility()	return self.gain_index*self.bonus_attribute end
-- function modifier_Advanced_Blood_Lust_unlock3:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index)*self.bonus_index end
function modifier_Advanced_Blood_Lust_unlock3:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_Advanced_Blood_Lust_unlock3:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Blood_Lust_unlock3:IsAura()	return true end
function modifier_Advanced_Blood_Lust_unlock3:GetModifierAura()	return "modifier_Advanced_Blood_Lust_unlock3_sub" end
function modifier_Advanced_Blood_Lust_unlock3:GetAuraRadius()	return 1000  end
function modifier_Advanced_Blood_Lust_unlock3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Blood_Lust_unlock3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Blood_Lust_unlock3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Blood_Lust_unlock3:GetAuraEntityReject(hEntity)

	if hEntity == self:GetParent() then
		return true
	end
	return false
end


function modifier_Advanced_Blood_Lust_unlock3:OnCreated(params)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_index = 1.5
	self.ability_damage_bonus = ability:GetSpecialValueFor("ability_damage_bonus")
	self.casttime = ability:GetSpecialValueFor("cast_time")
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	self.move_bonus = ability:GetSpecialValueFor("move_bonus")
	self.attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.attack_damage_bonus = ability:GetSpecialValueFor("attack_damage_bonus")
	self.bonus_attribute = 10

	self.bonus_reduce_index = 0.95
	self.gain_index = 1
	self:StartIntervalThink(0.1)
	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	if IsServer() then
		self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
		self:IncrementStackCount()
	end

end
function modifier_Advanced_Blood_Lust_unlock3:OnRefresh(params)
	table.insert(self.tData, {dieTime = self:GetDieTime() })
	if IsServer() then
		self:IncrementStackCount()
	end
	local stack = self:GetStackCount()
	local now_index = 1
	self.gain_index = 1
	for i = 2, stack, 1 do
		now_index = now_index *self.bonus_reduce_index
		self.gain_index = self.gain_index + now_index
	end

end

function modifier_Advanced_Blood_Lust_unlock3:OnIntervalThink()

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



function modifier_Advanced_Blood_Lust_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint
    }
end
function modifier_Advanced_Blood_Lust_unlock3:Advanced_GetModifierCastRangeBonusStacking(keys)
	return (self.cast_distance*self.gain_index)*self.bonus_index
end


function modifier_Advanced_Blood_Lust_unlock3:Advanced_GetModifier_CastPoint() return self.casttime*self.bonus_index end











modifier_Advanced_Blood_Lust_unlock3_sub = advanced_modifier({})

function modifier_Advanced_Blood_Lust_unlock3_sub:IsDebuff()				return false end
function modifier_Advanced_Blood_Lust_unlock3_sub:IsHidden() 			return false end
function modifier_Advanced_Blood_Lust_unlock3_sub:IsPurgable() 			return true end
function modifier_Advanced_Blood_Lust_unlock3_sub:IsPurgeException() 	return true end
function modifier_Advanced_Blood_Lust_unlock3_sub:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	} 
end
function modifier_Advanced_Blood_Lust_unlock3_sub:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint,
    }
end

function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierMoveSpeedBonus_Percentage() 	return (self.move_bonus*self.gain_index)  end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierAttackSpeedBonus_Constant() 	return (self.attack_speed_bonus*self.gain_index) end 
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierPreAttack_BonusDamage() 	return (self.attack_damage_bonus*self.gain_index) end
function modifier_Advanced_Blood_Lust_unlock3_sub:Advanced_GetModifierSpellAmplifyBonus() 	return (self.ability_damage_bonus*self.gain_index)*self.bonus_index  end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierBonusStats_Strength()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierBonusStats_Intellect()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierBonusStats_Agility()	return self.gain_index*self.bonus_attribute end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index)*self.bonus_index end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end
function modifier_Advanced_Blood_Lust_unlock3_sub:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Advanced_Blood_Lust_unlock3_sub:OnCreated(params)
	local ability = self:GetAbility()
	self.bonus_index = 1.5
	self.ability_damage_bonus = ability:GetSpecialValueFor("ability_damage_bonus")
	self.casttime = ability:GetSpecialValueFor("cast_time")
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	self.move_bonus = ability:GetSpecialValueFor("move_bonus")
	self.attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.attack_damage_bonus = ability:GetSpecialValueFor("attack_damage_bonus")
	self.bonus_attribute = 10
	self.bonus_reduce_index = 0.95
	self.gain_index = 0.5
	self:StartIntervalThink(0.1)
	self.now_stack = 1
	if IsServer() then
		self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
		self:IncrementStackCount()
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Blood_Lust_unlock3")
		if modifier then
			self:SetStackCount(modifier:GetStackCount())
		end
	end

end


function modifier_Advanced_Blood_Lust_unlock3_sub:OnIntervalThink()

	if IsServer() then
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Blood_Lust")
		if modifier then
			self:SetStackCount(modifier:GetStackCount())
		end
	end

	local stack = self:GetStackCount()
	if self.now_stack~=stack then
		self.now_stack = stack
		local now_index = 1
		self.gain_index = 1
		for i = 2, stack, 1 do
			now_index = now_index *self.bonus_reduce_index
			self.gain_index = self.gain_index + now_index
		end
		self.gain_index = self.gain_index *0.5
	end


end
function modifier_Advanced_Blood_Lust_unlock3_sub:Advanced_GetModifier_CastPoint() return self.casttime*self.bonus_index end


