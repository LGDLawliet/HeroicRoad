LinkLuaModifier("modifier_Advanced_morph", "skills/Advanced_morph", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_morph_lv15_str", "skills/Advanced_morph", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_morph_lv15_agi", "skills/Advanced_morph", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_morph_lv15_int", "skills/Advanced_morph", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_morph_unlock3", "skills/Advanced_morph", LUA_MODIFIER_MOTION_NONE)

Advanced_morph =  Advanced_morph or class({})


function Advanced_morph:CheckKV(key)
	local table = {
		bonus_attribute = 0.8,
		change_max = 2,
	}
	local value = table[key] or -1
	return value
end

function Advanced_morph:CheckKVFixedOverride(key)
	if key=="change_rate" then
		if self:GetUnlock(3)==3 then
			return 500
		end
	end

	return -999999

end


function Advanced_morph:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_morph:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- if not caster:HasAbility("heroTalent_npc_dota_hero_enigma") then
	-- 	self.CoreUnlock = false
	-- 	self.unlock2 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Malefice_unlock2",{})
	return true
end
function Advanced_morph:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	
	-- if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	-- self.totalcost = 0
	-- -- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fortunes_end_unlock3",{})
	-- _G.Fortunes_end_unlock3 = true
	return true

end

function Advanced_morph:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/morph/effect.vpcf", context )
end


function Advanced_morph:OnUpgrade()
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end


function Advanced_morph:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_morph:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end
-- function Advanced_morph:OnAdvancedUpgrade()
-- 	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_morph")
-- 	if modifier then
-- 		modifier:RefreshAttribute()
-- 	end
-- end

function Advanced_morph:OnToggle()
	if not IsServer() then return end
	if self:GetCaster():GetPrimaryAttribute() == DOTA_ATTRIBUTE_ALL then
		return
	end
	if self:GetToggleState() then
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_morph")
		if modifier then
			if self:GetAutoCastState() then
				modifier:SetType(true)
			else
				modifier:SetType(false)
			end
		end
	else
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_morph")
		if modifier then
			modifier:EndChanging()
		end
	end
	
end

function Advanced_morph:GetIntrinsicModifierName()
	return "modifier_Advanced_morph"
end

modifier_Advanced_morph	=  modifier_Advanced_morph or class({})

function modifier_Advanced_morph:IsHidden()	return true end
function modifier_Advanced_morph:IsDebuff() return false end
function modifier_Advanced_morph:RemoveOnDeath() return false end
function modifier_Advanced_morph:IsPurgable() return false end
function modifier_Advanced_morph:SetType(auto)
	local ability = self:GetAbility()
	self.back = auto
	self.parimary_attribute = self:GetParent():GetPrimaryAttribute()
	self.max_bonus = ability:GetSpecialValueFor("change_max")
	local new_rate = self:GetAbility():GetSpecialValueFor("change_rate")*0.01
	if new_rate~=self.change_rate then
		self:ResetAttribute()
		self.change_rate = new_rate
	end
	if ability.unlock1 then
		self.max_bonus = 9999
	end
	if self.origin_parimary_attribute~= self.parimary_attribute then
		self:ResetAttribute()
		self.origin_parimary_attribute= self.parimary_attribute

	end
	local color = Vector(0,0,0)
	if ability:GetAutoCastState() then
		color = Vector(255,255,255)
	elseif self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH then
		color = Vector(255,167,167)
	elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY then
		color = Vector(197,255,167)
	else
		color = Vector(167,167,255)
	end
	self:PlayEffect(color)
	--这里获取的冷却缩减 比方说30%获取到的是0.7
	-- 1-0.7 = 0.3
	-- 0.3=加速30%
	-- 如果两倍效果是加速60% 那么乘2
	local gain_indxe = 1
	self.heal_count = 10
	self.mana_count = 2
	if ability.advanced_level>=5 then
		self.heal_count = 16
		self.mana_count = 2*1.6
		if ability.advanced_level>=10 then
			gain_indxe = 1.4
			if ability.advanced_level>=15 then
				self.lv15 = true
			end
		end
	end
	if ability.unlock2 then
		self.heal_count = 40
		self.mana_count = 5
		self:StartIntervalThink(FrameTime())
	else
		local rate_gain =1 + (1-self:GetParent():GetCooldownReduction())*gain_indxe
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rate")/rate_gain)
	end
	if ability.unlock3 then
		self.unlock3= true
	end

	if ability.advanced_level>=20 then
		local count = 4
		if self.unlock3 then
			count = 20
		end
		for i = 1, count, 1 do
			if ability:GetToggleState() then
				self:OnIntervalThink()
			end
		end
	end



end
function modifier_Advanced_morph:EndChanging()
	self:StartIntervalThink(-1)
	ParticleManager:DestroyParticle(self.nFXIndex, false)
	self.nFXIndex = nil
end
function modifier_Advanced_morph:PlayEffect(color)
	if self.nFXIndex then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, color )
		return
	end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/morph/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, color )
	ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
end

function modifier_Advanced_morph:OnCreated(keys)
	
	if IsServer() then
		self.origin_parimary_attribute = self:GetParent():GetPrimaryAttribute()
		self.max_bonus = self:GetAbility():GetSpecialValueFor("change_max")
		self.bonus = 0
		self.bonus_str = 0
		self.bonus_agi = 0
		self.bonus_int = 0
		self.change_rate = self:GetAbility():GetSpecialValueFor("change_rate")*0.01
		self.bonus_attribute =  self:GetAbility():GetSpecialValueFor("bonus_attribute")

		self.str_gain = 0
		self.agi_gain = 0
		self.int_gain = 0
	end
end
function modifier_Advanced_morph:OnRefresh(keys)
	if IsServer() then
		self.max_bonus = self:GetAbility():GetSpecialValueFor("change_max")
		local new_rate = self:GetAbility():GetSpecialValueFor("change_rate")*0.01
		if new_rate~=self.change_rate then
			self:ResetAttribute()
		end
		self.change_rate = new_rate
		self.bonus_attribute =  self:GetAbility():GetSpecialValueFor("bonus_attribute")
	end
end
-- function modifier_Advanced_morph:RefreshAttribute()
-- 	self:OnRefresh()
-- end
function modifier_Advanced_morph:OnDestroy()
	if IsServer() then
		self:ResetAttribute()
	end
end
function modifier_Advanced_morph:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if self.back then --逆转
		--看看扣除的属性是否大过最高奖励
		if -self.bonus>=self.max_bonus then
			ability:ToggleAbility()
			return
		end
		if self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH  then
			--主属性是力量  抽取智力与敏捷
			if self:CheckSubAttribute(true,false,false) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self:OnGainAGI(gain)
				self:OnGainINT(gain)
				self.bonus_str = self.bonus_str - 1
				self.bonus = self.bonus - 1
				self.bonus_agi = self.bonus_agi+gain
				self.bonus_int = self.bonus_int +gain
			else
				ability:ToggleAbility()
				return
			end
		elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY  then
			--主属性是敏捷  抽取力量与智力
			if self:CheckSubAttribute(false,true,false) then
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self:OnGainSTR(gain)
				self:OnGainINT(gain)
				self.bonus_agi = self.bonus_agi - 1
				self.bonus = self.bonus - 1
				self.bonus_str = self.bonus_str+gain
				self.bonus_int = self.bonus_int +gain
			else
				ability:ToggleAbility()
				return
			end
		else

			--主属性是智力  抽取力量与敏捷
			if self:CheckSubAttribute(false,false,true) then
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				self:OnGainSTR(gain)
				self:OnGainAGI(gain)
				self.bonus_int = self.bonus_int - 1
				self.bonus = self.bonus - 1
				self.bonus_str = self.bonus_str+gain
				self.bonus_agi = self.bonus_agi +gain
			else
				ability:ToggleAbility()
				return
			end
		end
	else
		--超过最大转化值了
		if self.bonus>=self.max_bonus then
			ability:ToggleAbility()
			return
		end
		if self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH  then
			--主属性是力量  抽取智力与敏捷
			if self:CheckSubAttribute(false,true,true) then
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				self:OnGainSTR(gain)
				self.bonus_str = self.bonus_str + gain
				self.bonus = self.bonus + gain
				self.bonus_agi = self.bonus_agi - 1
				self.bonus_int = self.bonus_int - 1

			else
				ability:ToggleAbility()
				return
			end
		elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY  then
			--主属性是敏捷  抽取力量与智力
			if self:CheckSubAttribute(true,false,true) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				self:OnGainAGI(gain)
				self.bonus_agi = self.bonus_agi + gain
				self.bonus = self.bonus + gain
				self.bonus_str = self.bonus_str - 1
				self.bonus_int = self.bonus_int - 1

			else
				ability:ToggleAbility()
				return
			end
		else
			if self:CheckSubAttribute(true,true,false) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self:OnGainINT(gain)
				self.bonus_int = self.bonus_int + gain
				self.bonus = self.bonus + gain
				self.bonus_str = self.bonus_str - 1
				self.bonus_agi = self.bonus_agi - 1

			else
				ability:ToggleAbility()
				return
			end
		end
	end
end
function modifier_Advanced_morph:ResetAttribute()
	local parent = self:GetParent()
	parent:SetBaseStrength(parent:GetBaseStrength()-self.bonus_str)
	parent:SetBaseAgility(parent:GetBaseAgility()-self.bonus_agi)
	parent:SetBaseIntellect(parent:GetBaseIntellect()-self.bonus_int)
	self.bonus = 0
	self.bonus_str = 0
	self.bonus_agi = 0
	self.bonus_int = 0
end

function modifier_Advanced_morph:CheckSubAttribute(str,agi,int)
	local parent = self:GetParent()
	if str then
		local strength = parent:GetBaseStrength()
		if strength<=1 then
			return false
		end
	end
	if agi then
		local agility = parent:GetBaseAgility()
		if agility<=1 then
			return false
		end
	end

	if int then
		local intellect = parent:GetBaseIntellect()
		if intellect<=1 then
			return false
		end
	end
	return true
end


function modifier_Advanced_morph:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Advanced_morph:GetModifierBonusStats_Strength()	
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_STRENGTH  then
			return self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
	end
	
end
function modifier_Advanced_morph:GetModifierBonusStats_Intellect()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_INTELLECT  or self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_ALL  then
			return self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
		-- if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_INTELLECT   then
		-- 	return self:GetAbility():GetSpecialValueFor("bonus_attribute")
		-- end
	end
end
function modifier_Advanced_morph:GetModifierBonusStats_Agility()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_AGILITY   then
			return self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
	end
end

function modifier_Advanced_morph:OnGainSTR(value)
	self.str_gain = self.str_gain + value
	if self.str_gain>=1 then
		local count = self.str_gain - self.str_gain%1
		self.str_gain = self.str_gain - count
		local parent = self:GetParent()
		parent:Heal(self.heal_count*count, self:GetAbility())
		local gain = parent:GetModifierDurationGainIndex(1)
		if self.lv15 then
			for i = 1, count, 1 do
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_lv15_str", {duration = 20*gain})
				if self.unlock3 then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_unlock3", {duration = 30*gain})
				end
			end
			
		end
	end

end
function modifier_Advanced_morph:OnGainAGI(value)
	self.agi_gain =  self.agi_gain + value
	if self.lv15 and self.agi_gain>=1 then
		local count = self.agi_gain - self.agi_gain%1
		self.agi_gain = self.agi_gain - count
		local parent = self:GetParent()
		local gain = parent:GetModifierDurationGainIndex(1)

		for i = 1, count, 1 do
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_lv15_agi", {duration = 20*gain})
			if self.unlock3 then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_unlock3", {duration = 30*gain})
			end
		end
		
	end
end
function modifier_Advanced_morph:OnGainINT(value)
	self.int_gain =self.int_gain +value
	if self.int_gain>=1 then
		local count = self.int_gain - self.int_gain%1
		
		self.int_gain = self.int_gain - count
		local parent = self:GetParent()
		parent:GiveMana(self.mana_count*count)
	
		if self.lv15 then

			local gain = parent:GetModifierDurationGainIndex(1)
			for i = 1, count, 1 do
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_lv15_int", {duration = 20*gain})
				if self.unlock3 then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_morph_unlock3", {duration = 30*gain})
				end
			end
			
		end
	end
end






modifier_Advanced_morph_lv15_str = modifier_Advanced_morph_lv15_str or  class({})

function modifier_Advanced_morph_lv15_str:IsHidden()	return false end
function modifier_Advanced_morph_lv15_str:IsDebuff()	return false end
function modifier_Advanced_morph_lv15_str:IsPurgable()	return false end
function modifier_Advanced_morph_lv15_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}

	return funcs
end

function modifier_Advanced_morph_lv15_str:GetModifierHealthBonus()	return self:GetStackCount()*10 end
function modifier_Advanced_morph_lv15_str:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.2)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_morph_lv15_str:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 120 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end
function modifier_Advanced_morph_lv15_str:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end




modifier_Advanced_morph_lv15_agi = modifier_Advanced_morph_lv15_agi or  class({})

function modifier_Advanced_morph_lv15_agi:IsHidden()	return false end
function modifier_Advanced_morph_lv15_agi:IsDebuff()	return false end
function modifier_Advanced_morph_lv15_agi:IsPurgable()	return false end
function modifier_Advanced_morph_lv15_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_morph_lv15_agi:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount()*2 end
function modifier_Advanced_morph_lv15_agi:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.2)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_morph_lv15_agi:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 120 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end
function modifier_Advanced_morph_lv15_agi:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end



modifier_Advanced_morph_lv15_int = modifier_Advanced_morph_lv15_int or  advanced_modifier({})

function modifier_Advanced_morph_lv15_int:IsHidden()	return false end
function modifier_Advanced_morph_lv15_int:IsDebuff()	return false end
function modifier_Advanced_morph_lv15_int:IsPurgable()	return false end

function modifier_Advanced_morph_lv15_int:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_morph_lv15_int:Advanced_GetModifierSpellAmplifyBonus()	return self:GetStackCount()*0.3 end
function modifier_Advanced_morph_lv15_int:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.2)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_morph_lv15_int:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 120 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end
function modifier_Advanced_morph_lv15_int:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end













modifier_Advanced_morph_unlock3 = modifier_Advanced_morph_unlock3 or  advanced_modifier({})

function modifier_Advanced_morph_unlock3:IsHidden()	return false end
function modifier_Advanced_morph_unlock3:IsDebuff()	return false end
function modifier_Advanced_morph_unlock3:IsPurgable()	return false end
function modifier_Advanced_morph_unlock3:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

-- function modifier_Advanced_morph_unlock3:GetModifierTotalDamageOutgoing_Percentage()	return self:GetStackCount()*0.3 end
function modifier_Advanced_morph_unlock3:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.2)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_morph_unlock3:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 200 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end
function modifier_Advanced_morph_unlock3:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_Advanced_morph_unlock3:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end


-- advanced_modifier
function modifier_Advanced_morph_unlock3:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_morph_unlock3:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount()*0.3
end

