LinkLuaModifier("modifier_ChallengeInfo_031_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_031_debuff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_ChallengeInfo_032_effect", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_032_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_032_debuff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_033_effect", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_033_debuff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_033_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ChallengeInfo_034_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_035_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ChallengeInfo_036_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_037_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_041_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_ChallengeInfo_042_effect", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_042_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_042_shield", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ChallengeInfo_043_effect", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_043_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ChallengeInfo_044_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_044_active", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ChallengeInfo_044_enemy_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ChallengeInfo_045_buff", "modifier/modifier_challenge2", LUA_MODIFIER_MOTION_NONE)





require('internal/timers')   --计时器功能
function GetGoldBonus(name,unit)
	local bonus = challenge:GetChallengeInfo(name).bonus
	-- print("原本奖励="..bonus)
	bonus = bonus * _G.GAME_Challenge_gold_bonus_index
	local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_bounty_hunter_2")
	if modifier then
		bonus = bonus * modifier:GetBonusIndex()
	end
	-- print("现在奖励="..bonus)
	return bonus
end


modifier_ChallengeInfo_031_1 = advanced_modifier({})
function modifier_ChallengeInfo_031_1:IsHidden()return false end
function modifier_ChallengeInfo_031_1:IsDebuff()return true end
function modifier_ChallengeInfo_031_1:IsPurgable()return false end
function modifier_ChallengeInfo_031_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_031_1:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_1:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_031_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_031_buff", {stack = 5})
	end
    return 1
end


function modifier_ChallengeInfo_031_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_031_1:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then


		attacker:EmitSound("DOTA_Item.ComboBreaker")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 5, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if attacker:IsRealHero() then

			local ability = attacker:FindAbilityByName("Default_Move")
			attacker:AddNewModifier(attacker, ability, "modifier_ChallengeInfo_031_debuff", {stack = 5})
			
		end

		self:SafeDestroy()
		
    end
end






modifier_ChallengeInfo_031_2 = advanced_modifier({})
function modifier_ChallengeInfo_031_2:IsHidden()return false end
function modifier_ChallengeInfo_031_2:IsDebuff()return true end
function modifier_ChallengeInfo_031_2:IsPurgable()return false end
function modifier_ChallengeInfo_031_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_031_2:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_2:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_031_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_031_buff", {stack = 8})
	end
    return 1
end


function modifier_ChallengeInfo_031_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_031_2:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then

		attacker:EmitSound("DOTA_Item.ComboBreaker")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 5, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if attacker:IsRealHero() then

			local ability = attacker:FindAbilityByName("Default_Move")
			attacker:AddNewModifier(attacker, ability, "modifier_ChallengeInfo_031_debuff", {stack = 10})
			
		end

		self:SafeDestroy()
		
    end
end








modifier_ChallengeInfo_031_3 = advanced_modifier({})
function modifier_ChallengeInfo_031_3:IsHidden()return false end
function modifier_ChallengeInfo_031_3:IsDebuff()return true end
function modifier_ChallengeInfo_031_3:IsPurgable()return false end
function modifier_ChallengeInfo_031_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_031_3:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_3:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_031_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_031_buff", {stack = 11})
	end
    return 1
end


function modifier_ChallengeInfo_031_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end
function modifier_ChallengeInfo_031_3:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then


		attacker:EmitSound("DOTA_Item.ComboBreaker")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 5, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if attacker:IsRealHero() then

			local ability = attacker:FindAbilityByName("Default_Move")
			attacker:AddNewModifier(attacker, ability, "modifier_ChallengeInfo_031_debuff", {stack = 15})
			
		end

		self:SafeDestroy()
		
    end
end






modifier_ChallengeInfo_031_4 = advanced_modifier({})
function modifier_ChallengeInfo_031_4:IsHidden()return false end
function modifier_ChallengeInfo_031_4:IsDebuff()return true end
function modifier_ChallengeInfo_031_4:IsPurgable()return false end
function modifier_ChallengeInfo_031_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_031_4:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_4:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_031_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_031_buff", {stack = 15})
	end
    return 1
end


function modifier_ChallengeInfo_031_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_ChallengeInfo_031_4:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then


		attacker:EmitSound("DOTA_Item.ComboBreaker")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 5, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if attacker:IsRealHero() then
			local ability = attacker:FindAbilityByName("Default_Move")
			attacker:AddNewModifier(attacker, ability, "modifier_ChallengeInfo_031_debuff", {stack = 20})
			
		end

		self:SafeDestroy()
		
    end
end




modifier_ChallengeInfo_031_5 = advanced_modifier({})
function modifier_ChallengeInfo_031_5:IsHidden()return false end
function modifier_ChallengeInfo_031_5:IsDebuff()return true end
function modifier_ChallengeInfo_031_5:IsPurgable()return false end
function modifier_ChallengeInfo_031_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_031_5:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_5:DestroyOnExpire()	return false end
function modifier_ChallengeInfo_031_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_031_buff", {stack = 22})
	end
    return 1
end


function modifier_ChallengeInfo_031_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
	}
end




function modifier_ChallengeInfo_031_5:OnTakeDamage(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if attacker == self:GetParent() then
		if keys.damage<=0 then
			return
		end
		if attacker:GetTeamNumber()==target:GetTeamNumber() then
			return
		end

		attacker:EmitSound("DOTA_Item.ComboBreaker")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 5, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if attacker:IsRealHero() then
			local ability = attacker:FindAbilityByName("Default_Move")
			attacker:AddNewModifier(attacker, ability, "modifier_ChallengeInfo_031_debuff", {stack = 20})
			
		end

		self:SafeDestroy()
		
    end
end



modifier_ChallengeInfo_031_buff = advanced_modifier({})
function modifier_ChallengeInfo_031_buff:IsHidden()return false end
function modifier_ChallengeInfo_031_buff:IsDebuff()return false end
function modifier_ChallengeInfo_031_buff:IsPurgable()return false end
function modifier_ChallengeInfo_031_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_buff:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_031_buff:OnCreated(keys)
	if IsServer() then
		local attribute = self:GetParent():GetPrimaryAttribute()
		self.str_index = 0 
		self.agi_index = 0
		self.int_index = 0
		if attribute==0 then
			self.str_index = 1
		elseif attribute==1 then
			self.agi_index = 1
		else
			self.int_index = 1
		end
		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_031_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_031_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_031_buff:GetModifierBonusStats_Agility()   return self.agi_index*self:GetStackCount() end
function modifier_ChallengeInfo_031_buff:GetModifierBonusStats_Intellect() return self.int_index*self:GetStackCount() end
function modifier_ChallengeInfo_031_buff:GetModifierBonusStats_Strength()  return self.str_index*self:GetStackCount() end



modifier_ChallengeInfo_031_debuff = advanced_modifier({})
function modifier_ChallengeInfo_031_debuff:IsHidden()return false end
function modifier_ChallengeInfo_031_debuff:IsDebuff()return true end
function modifier_ChallengeInfo_031_debuff:IsPurgable()return false end
function modifier_ChallengeInfo_031_debuff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_031_debuff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_031_debuff:GetTexture() return "omniknight_purification" end
function modifier_ChallengeInfo_031_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_031_debuff:OnCreated(keys)
	if IsServer() then

		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_031_debuff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_031_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_ChallengeInfo_031_debuff:GetModifierBonusStats_Agility()   return -self:GetStackCount() end
function modifier_ChallengeInfo_031_debuff:GetModifierBonusStats_Intellect() return -self:GetStackCount() end
function modifier_ChallengeInfo_031_debuff:GetModifierBonusStats_Strength()  return -self:GetStackCount() end






---------------------------------苦难32
modifier_ChallengeInfo_032_1 = advanced_modifier({})
function modifier_ChallengeInfo_032_1:IsHidden()return false end
function modifier_ChallengeInfo_032_1:IsDebuff()return true end
function modifier_ChallengeInfo_032_1:IsPurgable()return false end
function modifier_ChallengeInfo_032_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_032_1:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_032_buff", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_032_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_032_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_032_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_032_effect", {stack = 5})
		end
	end
end

modifier_ChallengeInfo_032_2 = advanced_modifier({})
function modifier_ChallengeInfo_032_2:IsHidden()return false end
function modifier_ChallengeInfo_032_2:IsDebuff()return true end
function modifier_ChallengeInfo_032_2:IsPurgable()return false end
function modifier_ChallengeInfo_032_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_032_2:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_032_buff", {stack = 6})
	end
    return 1
end
function modifier_ChallengeInfo_032_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_032_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_032_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_032_effect", {stack = 8})
		end
	end
end


modifier_ChallengeInfo_032_3 = advanced_modifier({})
function modifier_ChallengeInfo_032_3:IsHidden()return false end
function modifier_ChallengeInfo_032_3:IsDebuff()return true end
function modifier_ChallengeInfo_032_3:IsPurgable()return false end
function modifier_ChallengeInfo_032_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_032_3:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_032_buff", {stack = 8})
	end
    return 1
end
function modifier_ChallengeInfo_032_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_032_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_032_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_032_effect", {stack = 14})
		end
	end
end








modifier_ChallengeInfo_032_4 = advanced_modifier({})
function modifier_ChallengeInfo_032_4:IsHidden()return false end
function modifier_ChallengeInfo_032_4:IsDebuff()return true end
function modifier_ChallengeInfo_032_4:IsPurgable()return false end
function modifier_ChallengeInfo_032_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_032_4:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_032_buff", {stack = 11})
	end
    return 1
end
function modifier_ChallengeInfo_032_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_032_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_032_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_032_effect", {stack = 20})
		end
	end
end



modifier_ChallengeInfo_032_5 = advanced_modifier({})
function modifier_ChallengeInfo_032_5:IsHidden()return false end
function modifier_ChallengeInfo_032_5:IsDebuff()return true end
function modifier_ChallengeInfo_032_5:IsPurgable()return false end
function modifier_ChallengeInfo_032_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_032_5:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	local ability = hero:FindAbilityByName("Default_Move")
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(hero, ability, "modifier_ChallengeInfo_032_buff", {stack = 15})
	end
    return 1
end
function modifier_ChallengeInfo_032_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_032_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_032_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_032_effect", {stack = 30})
		end
	end
end










modifier_ChallengeInfo_032_effect = advanced_modifier({})
function modifier_ChallengeInfo_032_effect:IsHidden()return false end
function modifier_ChallengeInfo_032_effect:IsDebuff()return false end
function modifier_ChallengeInfo_032_effect:IsPurgable()return false end
function modifier_ChallengeInfo_032_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_effect:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_032_effect:OnCreated(keys)
	if IsServer() then
		self.trigger = keys.stack
		self:SetStackCount(3)
	end
end
function modifier_ChallengeInfo_032_effect:OnRefresh(keys)
	if IsServer() then
		if keys.stack>self.trigger then
			self.trigger = keys.stack
		end
		self:IncrementStackCount()


	end
end

function modifier_ChallengeInfo_032_effect:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end


function modifier_ChallengeInfo_032_effect:OnAttackLanded(keys)
	if not IsServer() then return end


	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then	
		local attacker = self:GetParent()
		local target = keys.target
		if self.trigger>=RandomInt(1, 100) then
			local modifier = target:FindModifierByName("modifier_ChallengeInfo_032_debuff")
			if modifier then 
				return
			end
			local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, attacker:GetAttachmentOrigin(attacker:ScriptLookupAttachment("attach_hitloc")))
			ParticleManager:SetParticleControl(pfx, 2, Vector(100, 100, 100))
			attacker:EmitSound("Hero_Axe.Berserkers_Call")
			target:AddNewModifier(attacker, nil, "modifier_ChallengeInfo_032_debuff", {duration = 2})
			self:DecrementStackCount()
			if self:GetStackCount()<=0 then
				self:SafeDestroy()
				return
			end
		end

	
		
	end
end


modifier_ChallengeInfo_032_buff = advanced_modifier({})
function modifier_ChallengeInfo_032_buff:IsHidden()return true end
function modifier_ChallengeInfo_032_buff:IsDebuff()return false end
function modifier_ChallengeInfo_032_buff:IsPurgable()return false end
function modifier_ChallengeInfo_032_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_032_buff:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_032_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_032_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_032_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_ChallengeInfo_032_buff:GetModifierBonusStats_Strength()  return self:GetStackCount() end









modifier_ChallengeInfo_032_debuff = advanced_modifier({})

function modifier_ChallengeInfo_032_debuff:IsDebuff()				return true end
function modifier_ChallengeInfo_032_debuff:IsHidden() 			return false end
function modifier_ChallengeInfo_032_debuff:IsPurgable() 			return false end
function modifier_ChallengeInfo_032_debuff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_032_debuff:GetTexture() return "axe_berserkers_call" end
function modifier_ChallengeInfo_032_debuff:CheckState() return {[MODIFIER_STATE_TAUNTED]=true} end


function modifier_ChallengeInfo_032_debuff:OnCreated( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) 
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
end

function modifier_ChallengeInfo_032_debuff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成   


	}
end

function modifier_ChallengeInfo_032_debuff:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.target == self:GetCaster() then
		return -50
	end
end


function modifier_ChallengeInfo_032_debuff:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end

function modifier_ChallengeInfo_032_debuff:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end



modifier_ChallengeInfo_033_1 = modifier_ChallengeInfo_033_1 or  advanced_modifier({})
function modifier_ChallengeInfo_033_1:IsHidden()return false end
function modifier_ChallengeInfo_033_1:IsDebuff()return true end
function modifier_ChallengeInfo_033_1:IsPurgable()return false end
function modifier_ChallengeInfo_033_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_1:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
	end
	local ability = hero:FindAbilityByName("Default_Move")
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_buff", {stack = 4})
	end
    return 1
end
function modifier_ChallengeInfo_033_1:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_033_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_033_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_effect", {stack = 10})
		end
	end
end

modifier_ChallengeInfo_033_2 = modifier_ChallengeInfo_033_2 or  advanced_modifier({})
function modifier_ChallengeInfo_033_2:IsHidden()return false end
function modifier_ChallengeInfo_033_2:IsDebuff()return true end
function modifier_ChallengeInfo_033_2:IsPurgable()return false end
function modifier_ChallengeInfo_033_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_2:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
	end
	local ability = hero:FindAbilityByName("Default_Move")
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_buff", {stack = 6})
	end
    return 1
end
function modifier_ChallengeInfo_033_2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_033_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_033_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_effect", {stack = 20})
		end
	end
end



modifier_ChallengeInfo_033_3 = modifier_ChallengeInfo_033_3 or  advanced_modifier({})
function modifier_ChallengeInfo_033_3:IsHidden()return false end
function modifier_ChallengeInfo_033_3:IsDebuff()return true end
function modifier_ChallengeInfo_033_3:IsPurgable()return false end
function modifier_ChallengeInfo_033_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_3:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
	end
	local ability = hero:FindAbilityByName("Default_Move")
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_buff", {stack = 8})
	end
    return 1
end
function modifier_ChallengeInfo_033_3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_033_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_033_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_effect", {stack = 30})
		end
	end
end



modifier_ChallengeInfo_033_4 = modifier_ChallengeInfo_033_4 or  advanced_modifier({})
function modifier_ChallengeInfo_033_4:IsHidden()return false end
function modifier_ChallengeInfo_033_4:IsDebuff()return true end
function modifier_ChallengeInfo_033_4:IsPurgable()return false end
function modifier_ChallengeInfo_033_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_4:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
	end
	local ability = hero:FindAbilityByName("Default_Move")
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_buff", {stack = 11})
	end
    return 1
end
function modifier_ChallengeInfo_033_4:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_033_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_033_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_effect", {stack = 50})
		end
	end
end



modifier_ChallengeInfo_033_5 = modifier_ChallengeInfo_033_5 or  advanced_modifier({})
function modifier_ChallengeInfo_033_5:IsHidden()return false end
function modifier_ChallengeInfo_033_5:IsDebuff()return true end
function modifier_ChallengeInfo_033_5:IsPurgable()return false end
function modifier_ChallengeInfo_033_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_5:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
	end
	local ability = hero:FindAbilityByName("Default_Move")
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_buff", {stack = 15})
	end
    return 1
end
function modifier_ChallengeInfo_033_5:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_033_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_033_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_effect", {stack = 70})
		end
	end
end


















modifier_ChallengeInfo_033_buff = modifier_ChallengeInfo_033_buff or advanced_modifier({})
function modifier_ChallengeInfo_033_buff:IsHidden()return true end
function modifier_ChallengeInfo_033_buff:IsDebuff()return false end
function modifier_ChallengeInfo_033_buff:IsPurgable()return false end
function modifier_ChallengeInfo_033_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_033_buff:GetTexture() return "antimage_mana_void" end
function modifier_ChallengeInfo_033_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_033_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_033_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount() + keys.stack,300))

	end
end
function modifier_ChallengeInfo_033_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_ChallengeInfo_033_buff:GetModifierBonusStats_Intellect()  return self:GetStackCount() end









modifier_ChallengeInfo_033_effect = modifier_ChallengeInfo_033_effect or advanced_modifier({})

function modifier_ChallengeInfo_033_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_033_effect:IsHidden() 			return true end
function modifier_ChallengeInfo_033_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_033_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_033_effect:GetTexture() return "antimage_mana_void" end
-- function modifier_ChallengeInfo_013_effect:RemoveOnDeath() return false end
-- function modifier_ChallengeInfo_013_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_033_effect:OnCreated(keys)
	if IsServer() then
		self.stack = keys.stack
	end
end
function modifier_ChallengeInfo_033_effect:OnRefresh(keys)
	if IsServer() then
		self.stack = self.stack+ keys.stack
	end
end


function modifier_ChallengeInfo_033_effect:OnDestroy()
    if not IsServer() then
        return
    end
	local unit = self:GetParent()


	if unit:IsNull() then
		return
	end
	if unit:IsInvulnerable() then
		return
	end
	local pos = unit:GetAbsOrigin()
	local health = unit:GetMaxHealth()
	local class_name = unit:GetClassname()
	local unit_name = unit:GetUnitName()
	if  unit_name=="npc_attack_unit" or class_name=="npc_dota_thinker" or class_name=="npc_dota_base" then
		return
	end

	
	if health<=50 then
		return
	end
	local stack = self.stack/100


	local pfx_aoe = ParticleManager:CreateParticle("particles/rebuild/challenge/mana_void/effect_ti_5.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, pos)
	ParticleManager:SetParticleControl(pfx_aoe, 1, Vector(500,0,0))
	ParticleManager:SetParticleControl(pfx_aoe, 5, pos+Vector(0,0,128))
	ParticleManager:ReleaseParticleIndex(pfx_aoe)

	local damage_mul = 1
	if self.stack>100 then
		damage_mul = 1+(self.stack-100)*0.02
	end
	

	local ability = self:GetAbility()

	Timers:CreateTimer(4, function()
		if not unit or unit:IsNull() then
			return
		end
		unit:EmitSound("Hero_Antimage.ManaVoid")
		local units = FindUnitsInRadius(unit:GetTeamNumber(), pos, nil,420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damagetable = {
			attacker = unit,
			ability = nil,
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		for _, target in ipairs(units) do
			if target:GetManaPercent()<10 then
				target:AddNewModifier(unit, ability, "modifier_ChallengeInfo_033_debuff", {duration = 4*damage_mul})
			end
			local mana_reduce = target:GetMaxMana()*stack
			local current_mana = target:GetMana()
			target:Script_ReduceMana(mana_reduce,ability)
			local real_reduce = current_mana-target:GetMana()
			if real_reduce>=5 then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, real_reduce, nil)
				damagetable.victim = target
				damagetable.damage = real_reduce*damage_mul
				ApplyDamage(damagetable)
			end
			

		end
		


		
	end)
end



modifier_ChallengeInfo_033_debuff = modifier_ChallengeInfo_033_debuff or advanced_modifier({})

function modifier_ChallengeInfo_033_debuff:IsDebuff() return true end
function modifier_ChallengeInfo_033_debuff:IsHidden() return false end
function modifier_ChallengeInfo_033_debuff:IsPurgable() return false end
function modifier_ChallengeInfo_033_debuff:IsPurgeException() return false end
function modifier_ChallengeInfo_033_debuff:GetTexture()return "antimage_mana_void" end
function modifier_ChallengeInfo_033_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_ChallengeInfo_033_debuff:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_ChallengeInfo_033_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,

}
	return state
end













modifier_ChallengeInfo_034_1 = modifier_ChallengeInfo_034_1 or  advanced_modifier({})
function modifier_ChallengeInfo_034_1:IsHidden()return false end
function modifier_ChallengeInfo_034_1:IsDebuff()return true end
function modifier_ChallengeInfo_034_1:IsPurgable()return false end
function modifier_ChallengeInfo_034_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_034_1:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_034_buff", {stack = 10})
	end

    return 1
end
-- function modifier_ChallengeInfo_034_1:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
-- 	}
-- end
-- function modifier_ChallengeInfo_034_1:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
-- 		return -20
-- 	end
-- end


-- advanced_modifier
function modifier_ChallengeInfo_034_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_034_1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return -20
	end
end





modifier_ChallengeInfo_034_2 = modifier_ChallengeInfo_034_2 or  advanced_modifier({})
function modifier_ChallengeInfo_034_2:IsHidden()return false end
function modifier_ChallengeInfo_034_2:IsDebuff()return true end
function modifier_ChallengeInfo_034_2:IsPurgable()return false end
function modifier_ChallengeInfo_034_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_034_2:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_034_buff", {stack = 13})
	end

    return 1
end
-- function modifier_ChallengeInfo_034_2:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
-- 	}
-- end
-- function modifier_ChallengeInfo_034_2:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
-- 		return -40
-- 	end
-- end


function modifier_ChallengeInfo_034_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_034_2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return -40
	end
end


modifier_ChallengeInfo_034_3 = modifier_ChallengeInfo_034_3 or  advanced_modifier({})
function modifier_ChallengeInfo_034_3:IsHidden()return false end
function modifier_ChallengeInfo_034_3:IsDebuff()return true end
function modifier_ChallengeInfo_034_3:IsPurgable()return false end
function modifier_ChallengeInfo_034_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_034_3:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_034_buff", {stack = 16})
	end

    return 1
end
-- function modifier_ChallengeInfo_034_3:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
-- 	}
-- end
-- function modifier_ChallengeInfo_034_3:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
-- 		return -70
-- 	end
-- end



function modifier_ChallengeInfo_034_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_034_3:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return -70
	end
end


modifier_ChallengeInfo_034_4 = modifier_ChallengeInfo_034_4 or  advanced_modifier({})
function modifier_ChallengeInfo_034_4:IsHidden()return false end
function modifier_ChallengeInfo_034_4:IsDebuff()return true end
function modifier_ChallengeInfo_034_4:IsPurgable()return false end
function modifier_ChallengeInfo_034_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_034_4:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_034_buff", {stack = 20})
	end

    return 1
end
-- function modifier_ChallengeInfo_034_4:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
-- 	}
-- end
-- function modifier_ChallengeInfo_034_4:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
-- 		return -95
-- 	end
-- end

function modifier_ChallengeInfo_034_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_034_4:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return -95
	end
end





modifier_ChallengeInfo_034_5 = modifier_ChallengeInfo_034_5 or  advanced_modifier({})
function modifier_ChallengeInfo_034_5:IsHidden()return false end
function modifier_ChallengeInfo_034_5:IsDebuff()return true end
function modifier_ChallengeInfo_034_5:IsPurgable()return false end
function modifier_ChallengeInfo_034_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_034_5:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_034_buff", {stack = 30})
	end

    return 1
end
-- function modifier_ChallengeInfo_034_5:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
-- 	}
-- end
-- function modifier_ChallengeInfo_034_5:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
-- 		return -200
-- 	end
-- end


function modifier_ChallengeInfo_034_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_034_5:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return -200
	end
end






modifier_ChallengeInfo_034_buff = modifier_ChallengeInfo_034_buff or advanced_modifier({})
function modifier_ChallengeInfo_034_buff:IsHidden()return true end
function modifier_ChallengeInfo_034_buff:IsDebuff()return false end
function modifier_ChallengeInfo_034_buff:IsPurgable()return false end
function modifier_ChallengeInfo_034_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_034_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_034_buff:GetTexture() return "tusk/glaciomarine_ability_icons/tusk_walrus_kick" end
function modifier_ChallengeInfo_034_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_034_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_034_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_034_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_ChallengeInfo_034_buff:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
		return self:GetStackCount()*0.1
	end
end





modifier_ChallengeInfo_035_1 = modifier_ChallengeInfo_035_1 or  advanced_modifier({})
function modifier_ChallengeInfo_035_1:IsHidden()return false end
function modifier_ChallengeInfo_035_1:IsDebuff()return true end
function modifier_ChallengeInfo_035_1:IsPurgable()return false end
function modifier_ChallengeInfo_035_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_035_1:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_035_buff", {stack = 1})
	end

    return 1
end

function modifier_ChallengeInfo_035_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_1:Advanced_GetModifier_Summon_Intensity(keys)
	return -15
end



modifier_ChallengeInfo_035_2 = modifier_ChallengeInfo_035_2 or  advanced_modifier({})
function modifier_ChallengeInfo_035_2:IsHidden()return false end
function modifier_ChallengeInfo_035_2:IsDebuff()return true end
function modifier_ChallengeInfo_035_2:IsPurgable()return false end
function modifier_ChallengeInfo_035_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_035_2:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_035_buff", {stack = 2})
	end

    return 1
end

function modifier_ChallengeInfo_035_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_2:Advanced_GetModifier_Summon_Intensity(keys)
	return -25
end



modifier_ChallengeInfo_035_3 = modifier_ChallengeInfo_035_3 or  advanced_modifier({})
function modifier_ChallengeInfo_035_3:IsHidden()return false end
function modifier_ChallengeInfo_035_3:IsDebuff()return true end
function modifier_ChallengeInfo_035_3:IsPurgable()return false end
function modifier_ChallengeInfo_035_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_035_3:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_035_buff", {stack = 3})
	end

    return 1
end

function modifier_ChallengeInfo_035_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_3:Advanced_GetModifier_Summon_Intensity(keys)
	return -45
end




modifier_ChallengeInfo_035_4 = modifier_ChallengeInfo_035_4 or  advanced_modifier({})
function modifier_ChallengeInfo_035_4:IsHidden()return false end
function modifier_ChallengeInfo_035_4:IsDebuff()return true end
function modifier_ChallengeInfo_035_4:IsPurgable()return false end
function modifier_ChallengeInfo_035_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_035_4:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_035_buff", {stack = 4})
	end

    return 1
end

function modifier_ChallengeInfo_035_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_4:Advanced_GetModifier_Summon_Intensity(keys)
	return -85
end

modifier_ChallengeInfo_035_5 = modifier_ChallengeInfo_035_5 or  advanced_modifier({})
function modifier_ChallengeInfo_035_5:IsHidden()return true end
function modifier_ChallengeInfo_035_5:IsDebuff()return true end
function modifier_ChallengeInfo_035_5:IsPurgable()return false end
function modifier_ChallengeInfo_035_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_035_5:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_035_buff", {stack = 6})
	end

    return 1
end

function modifier_ChallengeInfo_035_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_5:Advanced_GetModifier_Summon_Intensity(keys)
	return -200
end








modifier_ChallengeInfo_035_buff = modifier_ChallengeInfo_035_buff or advanced_modifier({})
function modifier_ChallengeInfo_035_buff:IsHidden()return true end
function modifier_ChallengeInfo_035_buff:IsDebuff()return false end
function modifier_ChallengeInfo_035_buff:IsPurgable()return false end
function modifier_ChallengeInfo_035_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_035_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_035_buff:GetTexture() return "furion_curse_of_the_forest" end
function modifier_ChallengeInfo_035_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_035_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_035_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end


function modifier_ChallengeInfo_035_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_ChallengeInfo_035_buff:Advanced_GetModifier_Summon_Intensity(keys)
	return self:GetStackCount()
end




modifier_ChallengeInfo_036_1 = modifier_ChallengeInfo_036_1 or  advanced_modifier({})
function modifier_ChallengeInfo_036_1:IsHidden()return false end
function modifier_ChallengeInfo_036_1:IsDebuff()return true end
function modifier_ChallengeInfo_036_1:IsPurgable()return false end
function modifier_ChallengeInfo_036_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_036_1:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_036_buff", {stack = 20})
	end

    return 1
end
function modifier_ChallengeInfo_036_1:OnCreated()
	if IsServer() then
		self.current_pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.03)
	end
end
function modifier_ChallengeInfo_036_1:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if CalculateDistance(pos,self.current_pos)>=300 then
		FindClearSpaceForUnit( parent, self.current_pos, true )
		local now_pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_end_fm06_ground_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, now_pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(now_pos, "sounds/weapons/hero/queenofpain/blink_in_layer.vsnd", parent)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(pos, "sounds/weapons/hero/queenofpain/blink_out.vsnd", parent)
	end
	self.current_pos = parent:GetAbsOrigin()
end

function modifier_ChallengeInfo_036_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
-- function modifier_ChallengeInfo_036_1:GetModifierCastRangeBonusStacking()	return -200 end
function modifier_ChallengeInfo_036_1:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetAbilityName()=="Default_Move" then
		local ability = keys.ability
		Timers:CreateTimer(1.2, function()
			if not ability or ability:IsNull() then
				return
			end
			local newCooldown = ability:GetCooldownTimeRemaining()*1.5
			ability:EndCooldown()
			if newCooldown>=0 then
				ability:StartCooldown(newCooldown)
			end
		end)
	end
	


end




-- advanced_modifier
function modifier_ChallengeInfo_036_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_ChallengeInfo_036_1:Advanced_GetModifierCastRangeBonusStacking(keys)

	return -200
end



modifier_ChallengeInfo_036_2 = modifier_ChallengeInfo_036_2 or  advanced_modifier({})
function modifier_ChallengeInfo_036_2:IsHidden()return false end
function modifier_ChallengeInfo_036_2:IsDebuff()return true end
function modifier_ChallengeInfo_036_2:IsPurgable()return false end
function modifier_ChallengeInfo_036_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_036_2:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_036_buff", {stack = 30})
	end

    return 1
end
function modifier_ChallengeInfo_036_2:OnCreated()
	if IsServer() then
		self.current_pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.03)
	end
end
function modifier_ChallengeInfo_036_2:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if CalculateDistance(pos,self.current_pos)>=300 then
		FindClearSpaceForUnit( parent, self.current_pos, true )
		local now_pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_end_fm06_ground_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, now_pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(now_pos, "sounds/weapons/hero/queenofpain/blink_in_layer.vsnd", parent)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(pos, "sounds/weapons/hero/queenofpain/blink_out.vsnd", parent)
	end
	self.current_pos = parent:GetAbsOrigin()
end

function modifier_ChallengeInfo_036_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
-- function modifier_ChallengeInfo_036_2:GetModifierCastRangeBonusStacking()	return -500 end
function modifier_ChallengeInfo_036_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetAbilityName()=="Default_Move" then
		local ability = keys.ability
		Timers:CreateTimer(1.2, function()
			if not ability or ability:IsNull() then
				return
			end
			local newCooldown = ability:GetCooldownTimeRemaining()*2.5
			ability:EndCooldown()
			if newCooldown>=0 then
				ability:StartCooldown(newCooldown)
			end
		end)
	end
	


end

-- advanced_modifier
function modifier_ChallengeInfo_036_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_ChallengeInfo_036_2:Advanced_GetModifierCastRangeBonusStacking(keys)

	return -500
end




modifier_ChallengeInfo_036_3 = modifier_ChallengeInfo_036_3 or  advanced_modifier({})
function modifier_ChallengeInfo_036_3:IsHidden()return false end
function modifier_ChallengeInfo_036_3:IsDebuff()return true end
function modifier_ChallengeInfo_036_3:IsPurgable()return false end
function modifier_ChallengeInfo_036_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_036_3:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_036_buff", {stack = 50})
	end

    return 1
end
function modifier_ChallengeInfo_036_3:OnCreated()
	if IsServer() then
		self.current_pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.03)
	end
end
function modifier_ChallengeInfo_036_3:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if CalculateDistance(pos,self.current_pos)>=300 then
		FindClearSpaceForUnit( parent, self.current_pos, true )
		local now_pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_end_fm06_ground_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, now_pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(now_pos, "sounds/weapons/hero/queenofpain/blink_in_layer.vsnd", parent)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(pos, "sounds/weapons/hero/queenofpain/blink_out.vsnd", parent)
	end
	self.current_pos = parent:GetAbsOrigin()
end

function modifier_ChallengeInfo_036_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
-- function modifier_ChallengeInfo_036_3:GetModifierCastRangeBonusStacking()	return -1000 end
function modifier_ChallengeInfo_036_3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetAbilityName()=="Default_Move" then
		local ability = keys.ability
		Timers:CreateTimer(1.2, function()
			if not ability or ability:IsNull() then
				return
			end
			local newCooldown = ability:GetCooldownTimeRemaining()*3.5
			ability:EndCooldown()
			if newCooldown>=0 then
				ability:StartCooldown(newCooldown)
			end
		end)
	end
	


end
-- advanced_modifier
function modifier_ChallengeInfo_036_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_ChallengeInfo_036_3:Advanced_GetModifierCastRangeBonusStacking(keys)

	return -1000
end


modifier_ChallengeInfo_036_4 = modifier_ChallengeInfo_036_4 or  advanced_modifier({})
function modifier_ChallengeInfo_036_4:IsHidden()return false end
function modifier_ChallengeInfo_036_4:IsDebuff()return true end
function modifier_ChallengeInfo_036_4:IsPurgable()return false end
function modifier_ChallengeInfo_036_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_036_4:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_036_buff", {stack = 70})
	end

    return 1
end
function modifier_ChallengeInfo_036_4:OnCreated()
	if IsServer() then
		self.current_pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.03)
	end
end
function modifier_ChallengeInfo_036_4:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if CalculateDistance(pos,self.current_pos)>=300 then
		FindClearSpaceForUnit( parent, self.current_pos, true )
		local now_pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_end_fm06_ground_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, now_pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(now_pos, "sounds/weapons/hero/queenofpain/blink_in_layer.vsnd", parent)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(pos, "sounds/weapons/hero/queenofpain/blink_out.vsnd", parent)
	end
	self.current_pos = parent:GetAbsOrigin()
end

function modifier_ChallengeInfo_036_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end

-- function modifier_ChallengeInfo_036_4:GetModifierCastRangeBonusStacking()	return -1500 end
function modifier_ChallengeInfo_036_4:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetAbilityName()=="Default_Move" then
		local ability = keys.ability
		Timers:CreateTimer(1.2, function()
			if not ability or ability:IsNull() then
				return
			end
			local newCooldown = ability:GetCooldownTimeRemaining()*5
			ability:EndCooldown()
			if newCooldown>=0 then
				ability:StartCooldown(newCooldown)
			end
		end)
	end
	


end


-- advanced_modifier
function modifier_ChallengeInfo_036_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_ChallengeInfo_036_4:Advanced_GetModifierCastRangeBonusStacking(keys)

	return -1500
end


modifier_ChallengeInfo_036_5 = modifier_ChallengeInfo_036_5 or  advanced_modifier({})
function modifier_ChallengeInfo_036_5:IsHidden()return false end
function modifier_ChallengeInfo_036_5:IsDebuff()return true end
function modifier_ChallengeInfo_036_5:IsPurgable()return false end
function modifier_ChallengeInfo_036_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_036_5:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_036_buff", {stack = 100})
	end

    return 1
end
function modifier_ChallengeInfo_036_5:OnCreated()
	if IsServer() then
		self.current_pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.03)
	end
end
function modifier_ChallengeInfo_036_5:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if CalculateDistance(pos,self.current_pos)>=300 then
		FindClearSpaceForUnit( parent, self.current_pos, true )
		local now_pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_end_fm06_ground_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, now_pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(now_pos, "sounds/weapons/hero/queenofpain/blink_in_layer.vsnd", parent)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_start_fm06_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(pos, "sounds/weapons/hero/queenofpain/blink_out.vsnd", parent)
	end
	self.current_pos = parent:GetAbsOrigin()
end

function modifier_ChallengeInfo_036_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end
-- function modifier_ChallengeInfo_036_5:GetModifierCastRangeBonusStacking()	return -3000 end
function modifier_ChallengeInfo_036_5:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetAbilityName()=="Default_Move" then
		local ability = keys.ability
		Timers:CreateTimer(1.2, function()
			if not ability or ability:IsNull() then
				return
			end
			local newCooldown = ability:GetCooldownTimeRemaining()*10
			ability:EndCooldown()
			if newCooldown>=0 then
				ability:StartCooldown(newCooldown)
			end
		end)
	end
	


end


-- advanced_modifier
function modifier_ChallengeInfo_036_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_ChallengeInfo_036_5:Advanced_GetModifierCastRangeBonusStacking(keys)

	return -3000
end









modifier_ChallengeInfo_036_buff = modifier_ChallengeInfo_036_buff or advanced_modifier({})
function modifier_ChallengeInfo_036_buff:IsHidden()return false end
function modifier_ChallengeInfo_036_buff:IsDebuff()return false end
function modifier_ChallengeInfo_036_buff:IsPurgable()return false end
function modifier_ChallengeInfo_036_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_036_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_036_buff:GetTexture() return "faceless_void_chronosphere" end
function modifier_ChallengeInfo_036_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_036_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_036_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end

function modifier_ChallengeInfo_036_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING, 

	}
end
function modifier_ChallengeInfo_036_buff:GetModifierCastRangeBonusStacking()	return self:GetStackCount() end









modifier_ChallengeInfo_037_1 = modifier_ChallengeInfo_037_1 or  advanced_modifier({})
function modifier_ChallengeInfo_037_1:IsHidden()return false end
function modifier_ChallengeInfo_037_1:IsDebuff()return true end
function modifier_ChallengeInfo_037_1:IsPurgable()return false end
function modifier_ChallengeInfo_037_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_037_1:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_037_buff", {stack = 2})
	end

    return 1
end
function modifier_ChallengeInfo_037_1:OnCreated()
	if IsServer() then
		self.damage_reduction = 0
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_1:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		800, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.damage_reduction = -1000
			return
		end
	end
	self.damage_reduction = 0
end


-- function modifier_ChallengeInfo_037_1:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

-- 	}
-- end
-- function modifier_ChallengeInfo_037_1:GetModifierTotalDamageOutgoing_Percentage()	return self.damage_reduction or 0 end

function modifier_ChallengeInfo_037_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_037_1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.damage_reduction or 0 
end




modifier_ChallengeInfo_037_2 = modifier_ChallengeInfo_037_2 or  advanced_modifier({})
function modifier_ChallengeInfo_037_2:IsHidden()return false end
function modifier_ChallengeInfo_037_2:IsDebuff()return true end
function modifier_ChallengeInfo_037_2:IsPurgable()return false end
function modifier_ChallengeInfo_037_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_037_2:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_037_buff", {stack = 3})
	end

    return 1
end
function modifier_ChallengeInfo_037_2:OnCreated()
	if IsServer() then
		self.damage_reduction = 0
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_2:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		1500, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.damage_reduction = -1000
			return
		end
	end
	self.damage_reduction = 0
end


-- function modifier_ChallengeInfo_037_2:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

-- 	}
-- end
-- function modifier_ChallengeInfo_037_2:GetModifierTotalDamageOutgoing_Percentage()	return self.damage_reduction or 0 end



function modifier_ChallengeInfo_037_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_037_2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.damage_reduction or 0 
end



modifier_ChallengeInfo_037_3 = modifier_ChallengeInfo_037_3 or  advanced_modifier({})
function modifier_ChallengeInfo_037_3:IsHidden()return false end
function modifier_ChallengeInfo_037_3:IsDebuff()return true end
function modifier_ChallengeInfo_037_3:IsPurgable()return false end
function modifier_ChallengeInfo_037_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_037_3:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_037_buff", {stack = 5})
	end

    return 1
end
function modifier_ChallengeInfo_037_3:OnCreated()
	if IsServer() then
		self.damage_reduction = 0
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_3:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		2500, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.damage_reduction = -1000
			return
		end
	end
	self.damage_reduction = 0
end


-- function modifier_ChallengeInfo_037_3:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

-- 	}
-- end
-- function modifier_ChallengeInfo_037_3:GetModifierTotalDamageOutgoing_Percentage()	return self.damage_reduction or 0 end


function modifier_ChallengeInfo_037_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_037_3:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.damage_reduction or 0 
end

modifier_ChallengeInfo_037_4 = modifier_ChallengeInfo_037_4 or  advanced_modifier({})
function modifier_ChallengeInfo_037_4:IsHidden()return false end
function modifier_ChallengeInfo_037_4:IsDebuff()return true end
function modifier_ChallengeInfo_037_4:IsPurgable()return false end
function modifier_ChallengeInfo_037_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_037_4:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_037_buff", {stack = 7})
	end

    return 1
end
function modifier_ChallengeInfo_037_4:OnCreated()
	if IsServer() then
		self.damage_reduction = 0
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_4:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		3500, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.damage_reduction = -1000
			return
		end
	end
	self.damage_reduction = 0
end


-- function modifier_ChallengeInfo_037_4:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

-- 	}
-- end
-- function modifier_ChallengeInfo_037_4:GetModifierTotalDamageOutgoing_Percentage()	return self.damage_reduction or 0 end



function modifier_ChallengeInfo_037_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_037_4:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.damage_reduction or 0 
end


modifier_ChallengeInfo_037_5 = modifier_ChallengeInfo_037_5 or  advanced_modifier({})
function modifier_ChallengeInfo_037_5:IsHidden()return false end
function modifier_ChallengeInfo_037_5:IsDebuff()return true end
function modifier_ChallengeInfo_037_5:IsPurgable()return false end
function modifier_ChallengeInfo_037_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_037_5:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_037_buff", {stack = 10})
	end

    return 1
end
function modifier_ChallengeInfo_037_5:OnCreated()
	if IsServer() then
		self.damage_reduction = 0
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_5:OnIntervalThink()
	local parent = self:GetParent()
	
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		5000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.damage_reduction = -1000
			return
		end
	end
	self.damage_reduction = 0
end


-- function modifier_ChallengeInfo_037_5:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 

-- 	}
-- end
-- function modifier_ChallengeInfo_037_5:GetModifierTotalDamageOutgoing_Percentage()	return self.damage_reduction or 0 end


function modifier_ChallengeInfo_037_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_037_5:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.damage_reduction or 0 
end






modifier_ChallengeInfo_037_buff = modifier_ChallengeInfo_037_buff or advanced_modifier({})
function modifier_ChallengeInfo_037_buff:IsHidden()return true end
function modifier_ChallengeInfo_037_buff:IsDebuff()return false end
function modifier_ChallengeInfo_037_buff:IsPurgable()return false end
function modifier_ChallengeInfo_037_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_037_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_037_buff:GetTexture() return "enigma_demonic_conversion" end
function modifier_ChallengeInfo_037_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_037_buff:OnCreated(keys)
	if IsServer() then
		self.bonus = 1
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_037_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)

	end
end
function modifier_ChallengeInfo_037_buff:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		1000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, unit in ipairs(units) do
		if unit~=parent then
			self.bonus = 1
			return
		end
	end
	self.bonus = 0
end




function modifier_ChallengeInfo_037_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷, 

	}
end
function modifier_ChallengeInfo_037_buff:GetModifierBonusStats_Strength()	return self:GetStackCount()*(self.bonus or 0) end
function modifier_ChallengeInfo_037_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount()*(self.bonus or 0) end
function modifier_ChallengeInfo_037_buff:GetModifierBonusStats_Agility()	return self:GetStackCount()*(self.bonus or 0) end















modifier_ChallengeInfo_038_1 = modifier_ChallengeInfo_038_1 or  advanced_modifier({})
function modifier_ChallengeInfo_038_1:IsHidden()return false end
function modifier_ChallengeInfo_038_1:IsDebuff()return true end
function modifier_ChallengeInfo_038_1:IsPurgable()return false end
function modifier_ChallengeInfo_038_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_038_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_038_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_038_1:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_ChallengeInfo_038_1:OnChallengeWaveEnd()
	if self.fail then
		return
	end
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		hero:ModifyGoldGainPercentage(0.01)
	end

    return 1
end
function modifier_ChallengeInfo_038_1:OnCreated()
	if IsServer() then
		self.fail = false
		self.lost_index = 0.1
		self.min_lost = 300
		-- self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_038_1:OnIntervalThink()
	local target = self:GetParent()
	local gold = target:GetGold()
	local reduce = self:GetStackCount()
	if gold>=reduce then
		target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
		self:SafeDestroy()
	else
		target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
		self:SetStackCount((reduce-gold))
	end
end

function modifier_ChallengeInfo_038_1:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_ChallengeInfo_038_1:OnDeath(keys)
	if self.fail then
		return
	end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() and IsEnemy(target,attacker) then


		attacker:EmitSound("Hero_BountyHunter.Jinada")
		local particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)



		local gold = target:GetGold()
		local reduce = math.max(gold*self.lost_index,self.min_lost)
		if gold>=reduce then
			target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
			self:SafeDestroy()
		else
		
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((reduce-gold))
			self:StartIntervalThink(1)
			self.fail =  true
		end

		
    end
end




modifier_ChallengeInfo_038_2 = modifier_ChallengeInfo_038_2 or  advanced_modifier({})
function modifier_ChallengeInfo_038_2:IsHidden()return false end
function modifier_ChallengeInfo_038_2:IsDebuff()return true end
function modifier_ChallengeInfo_038_2:IsPurgable()return false end
function modifier_ChallengeInfo_038_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_038_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_038_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_038_2:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_ChallengeInfo_038_2:OnChallengeWaveEnd()
	if self.fail then
		return
	end
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		hero:ModifyGoldGainPercentage(0.015)
	end

    return 1
end
function modifier_ChallengeInfo_038_2:OnCreated()
	if IsServer() then
		self.fail = false
		self.lost_index = 0.2
		self.min_lost = 600
		-- self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_038_2:OnIntervalThink()
	local target = self:GetParent()
	local gold = target:GetGold()
	local reduce = self:GetStackCount()
	if gold>=reduce then
		target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
		self:SafeDestroy()
	else
		target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
		self:SetStackCount((reduce-gold))
	end
end


function modifier_ChallengeInfo_038_2:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_ChallengeInfo_038_2:OnDeath(keys)
	if self.fail then
		return
	end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() and IsEnemy(target,attacker) then


		attacker:EmitSound("Hero_BountyHunter.Jinada")
		local particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)



		local gold = target:GetGold()
		local reduce = math.max(gold*self.lost_index,self.min_lost)
		if gold>=reduce then
			target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
			self:SafeDestroy()
		else
		
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((reduce-gold))
			self:StartIntervalThink(1)
			self.fail =  true
		end

		
    end
end



modifier_ChallengeInfo_038_3 = modifier_ChallengeInfo_038_3 or  advanced_modifier({})
function modifier_ChallengeInfo_038_3:IsHidden()return false end
function modifier_ChallengeInfo_038_3:IsDebuff()return true end
function modifier_ChallengeInfo_038_3:IsPurgable()return false end
function modifier_ChallengeInfo_038_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_038_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_038_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_038_3:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_ChallengeInfo_038_3:OnChallengeWaveEnd()
	if self.fail then
		return
	end
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		hero:ModifyGoldGainPercentage(0.02)
	end

    return 1
end
function modifier_ChallengeInfo_038_3:OnCreated()
	if IsServer() then
		self.fail = false
		self.lost_index = 0.3
		self.min_lost = 900
		-- self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_038_3:OnIntervalThink()
	local target = self:GetParent()
	local gold = target:GetGold()
	local reduce = self:GetStackCount()
	if gold>=reduce then
		target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
		self:SafeDestroy()
	else
		target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
		self:SetStackCount((reduce-gold))
	end
end


function modifier_ChallengeInfo_038_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_ChallengeInfo_038_3:OnDeath(keys)
	if self.fail then
		return
	end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() and IsEnemy(target,attacker) then


		attacker:EmitSound("Hero_BountyHunter.Jinada")
		local particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)


		local gold = target:GetGold()
		local reduce = math.max(gold*self.lost_index,self.min_lost)
		if gold>=reduce then
			target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
			self:SafeDestroy()
		else
		
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((reduce-gold))
			self:StartIntervalThink(1)
			self.fail =  true
		end

		
    end
end



modifier_ChallengeInfo_038_4 = modifier_ChallengeInfo_038_4 or  advanced_modifier({})
function modifier_ChallengeInfo_038_4:IsHidden()return false end
function modifier_ChallengeInfo_038_4:IsDebuff()return true end
function modifier_ChallengeInfo_038_4:IsPurgable()return false end
function modifier_ChallengeInfo_038_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_038_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_038_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_038_4:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_ChallengeInfo_038_4:OnChallengeWaveEnd()
	if self.fail then
		return
	end
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		hero:ModifyGoldGainPercentage(0.03)
	end

    return 1
end
function modifier_ChallengeInfo_038_4:OnCreated()
	if IsServer() then
		self.fail = false
		self.lost_index = 0.5
		self.min_lost = 1200
		-- self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_038_4:OnIntervalThink()
	local target = self:GetParent()
	local gold = target:GetGold()
	local reduce = self:GetStackCount()
	if gold>=reduce then
		target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
		self:SafeDestroy()
	else
		target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
		self:SetStackCount((reduce-gold))
	end
end


function modifier_ChallengeInfo_038_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_ChallengeInfo_038_4:OnDeath(keys)
	if self.fail then
		return
	end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() and IsEnemy(target,attacker) then


		attacker:EmitSound("Hero_BountyHunter.Jinada")
		local particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)



		local gold = target:GetGold()
		local reduce = math.max(gold*self.lost_index,self.min_lost)
		if gold>=reduce then
			target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
			self:SafeDestroy()
		else
		
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((reduce-gold))
			self:StartIntervalThink(1)
			self.fail =  true
		end

		
    end
end



modifier_ChallengeInfo_038_5 = modifier_ChallengeInfo_038_5 or  advanced_modifier({})
function modifier_ChallengeInfo_038_5:IsHidden()return false end
function modifier_ChallengeInfo_038_5:IsDebuff()return true end
function modifier_ChallengeInfo_038_5:IsPurgable()return false end
function modifier_ChallengeInfo_038_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_038_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_038_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_038_5:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_ChallengeInfo_038_5:OnChallengeWaveEnd()
	if self.fail then
		return
	end
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		hero:ModifyGoldGainPercentage(0.04)
	end

    return 1
end
function modifier_ChallengeInfo_038_5:OnCreated()
	if IsServer() then
		self.fail = false
		self.lost_index = 0.7
		self.min_lost = 2000
		-- self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_038_5:OnIntervalThink()
	local target = self:GetParent()
	local gold = target:GetGold()
	local reduce = self:GetStackCount()
	if gold>=reduce then
		target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
		self:SafeDestroy()
	else
		target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
		self:SetStackCount((reduce-gold))
	end
end


function modifier_ChallengeInfo_038_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_ChallengeInfo_038_5:OnDeath(keys)
	if self.fail then
		return
	end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() and IsEnemy(target,attacker) then


		attacker:EmitSound("Hero_BountyHunter.Jinada")
		local particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)



		local gold = target:GetGold()
		local reduce = math.max(gold*self.lost_index,self.min_lost)
		if gold>=reduce then
			target:ModifyGoldFiltered(-reduce,true,DOTA_ModifyGold_CreepKill )
			self:SafeDestroy()
		else
		
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((reduce-gold))
			self:StartIntervalThink(1)
			self.fail =  true
		end

		
    end
end




modifier_ChallengeInfo_039_1 = advanced_modifier({})
function modifier_ChallengeInfo_039_1:IsHidden()return false end
function modifier_ChallengeInfo_039_1:IsDebuff()return true end
function modifier_ChallengeInfo_039_1:IsPurgable()return false end
function modifier_ChallengeInfo_039_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_039_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_039_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_039_1:GetTexture() return "razor_eye_of_the_storm" end
function modifier_ChallengeInfo_039_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_039_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_039_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_008",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_039_2 = advanced_modifier({})
function modifier_ChallengeInfo_039_2:IsHidden()return false end
function modifier_ChallengeInfo_039_2:IsDebuff()return true end
function modifier_ChallengeInfo_039_2:IsPurgable()return false end
function modifier_ChallengeInfo_039_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_039_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_039_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_039_2:GetTexture() return "razor_eye_of_the_storm" end
function modifier_ChallengeInfo_039_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_039_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_039_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_008",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_039_3 = advanced_modifier({})
function modifier_ChallengeInfo_039_3:IsHidden()return false end
function modifier_ChallengeInfo_039_3:IsDebuff()return true end
function modifier_ChallengeInfo_039_3:IsPurgable()return false end
function modifier_ChallengeInfo_039_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_039_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_039_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_039_3:GetTexture() return "razor_eye_of_the_storm" end
function modifier_ChallengeInfo_039_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_039_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_039_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_008",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_039_4 = advanced_modifier({})
function modifier_ChallengeInfo_039_4:IsHidden()return false end
function modifier_ChallengeInfo_039_4:IsDebuff()return true end
function modifier_ChallengeInfo_039_4:IsPurgable()return false end
function modifier_ChallengeInfo_039_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_039_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_039_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_039_4:GetTexture() return "razor_eye_of_the_storm" end
function modifier_ChallengeInfo_039_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_039_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_039_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_008",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_039_5 = advanced_modifier({})
function modifier_ChallengeInfo_039_5:IsHidden()return false end
function modifier_ChallengeInfo_039_5:IsDebuff()return true end
function modifier_ChallengeInfo_039_5:IsPurgable()return false end
function modifier_ChallengeInfo_039_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_039_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_039_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_039_5:GetTexture() return "razor_eye_of_the_storm" end
function modifier_ChallengeInfo_039_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_039_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_039_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_008",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
						gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end







CHALLENGE40_STATE_SAVE = 1
CHALLENGE40_STATE_GET_GOLD = 2





modifier_ChallengeInfo_040_1 = modifier_ChallengeInfo_040_1 or  advanced_modifier({})
function modifier_ChallengeInfo_040_1:IsHidden()return false end
function modifier_ChallengeInfo_040_1:IsDebuff()return true end
function modifier_ChallengeInfo_040_1:IsPurgable()return false end
function modifier_ChallengeInfo_040_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_040_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_040_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_040_1:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_ChallengeInfo_040_1:OnChallengeWaveEnd()
	if self.state==CHALLENGE40_STATE_SAVE then
		if self.need_wave_count<=0 then
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
			self:SetStackCount(self:GetStackCount()*self.bonus_gold_index)
			self.state = CHALLENGE40_STATE_GET_GOLD
		else
			self.need_wave_count = self.need_wave_count - 1
		end
	end
	
    return 1
end

function modifier_ChallengeInfo_040_1:OnCreated()
	if IsServer() then
		self.need_wave_count = 1
		self.bonus_gold_index = 1.05
		self.exp_bonus = 5
		if _G.GAME_ROUND>13 then
			--大于13回合直接完成
			self:SafeDestroy()
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
		end
		
		self.state = CHALLENGE40_STATE_SAVE
		self:StartIntervalThink(0.06)
	end
end
function modifier_ChallengeInfo_040_1:OnIntervalThink()
	if self.state==CHALLENGE40_STATE_SAVE then
		local target = self:GetParent()
		local gold = target:GetGold()
		if gold>=1 then
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((self:GetStackCount()+gold))
		end

	else
		if self.state==CHALLENGE40_STATE_GET_GOLD then
			local target = self:GetParent()
			local gold = target:GetGold()
			local bonus = self:GetStackCount()
			if gold>=70000 then
				return
			end
			--如何加起来大于70000则取一部分
			if( gold+bonus)>=70000 then
				local get_count = 70000-gold
				self:SetStackCount(self:GetStackCount()-get_count)
				target:ModifyGoldFiltered(get_count,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, get_count, nil)
			else
				target:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, bonus, nil)
				self:SafeDestroy()
			end
			

		end
	end
	
end




modifier_ChallengeInfo_040_2 = modifier_ChallengeInfo_040_2 or  advanced_modifier({})
function modifier_ChallengeInfo_040_2:IsHidden()return false end
function modifier_ChallengeInfo_040_2:IsDebuff()return true end
function modifier_ChallengeInfo_040_2:IsPurgable()return false end
function modifier_ChallengeInfo_040_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_040_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_040_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_040_2:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_ChallengeInfo_040_2:OnChallengeWaveEnd()
	if self.state==CHALLENGE40_STATE_SAVE then
		if self.need_wave_count<=0 then
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
			self:SetStackCount(self:GetStackCount()*self.bonus_gold_index)
			self.state = CHALLENGE40_STATE_GET_GOLD
		else
			self.need_wave_count = self.need_wave_count - 1
		end
	end
	
    return 1
end

function modifier_ChallengeInfo_040_2:OnCreated()
	if IsServer() then
		self.need_wave_count = 2
		self.bonus_gold_index = 1.07
		self.exp_bonus = 10
		if _G.GAME_ROUND>13 then
			--大于13回合直接完成
			self:SafeDestroy()
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
		end
		
		self.state = CHALLENGE40_STATE_SAVE
		self:StartIntervalThink(0.06)
	end
end
function modifier_ChallengeInfo_040_2:OnIntervalThink()
	if self.state==CHALLENGE40_STATE_SAVE then
		local target = self:GetParent()
		local gold = target:GetGold()
		if gold>=1 then
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((self:GetStackCount()+gold))
		end

	else
		if self.state==CHALLENGE40_STATE_GET_GOLD then
			local target = self:GetParent()
			local gold = target:GetGold()
			local bonus = self:GetStackCount()
			if gold>=70000 then
				return
			end
			--如何加起来大于70000则取一部分
			if( gold+bonus)>=70000 then
				local get_count = 70000-gold
				self:SetStackCount(self:GetStackCount()-get_count)
				target:ModifyGoldFiltered(get_count,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, get_count, nil)
			else
				target:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, bonus, nil)
				self:SafeDestroy()
			end
			

		end
	end
	
end






modifier_ChallengeInfo_040_3 = modifier_ChallengeInfo_040_3 or  advanced_modifier({})
function modifier_ChallengeInfo_040_3:IsHidden()return false end
function modifier_ChallengeInfo_040_3:IsDebuff()return true end
function modifier_ChallengeInfo_040_3:IsPurgable()return false end
function modifier_ChallengeInfo_040_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_040_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_040_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_040_3:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_ChallengeInfo_040_3:OnChallengeWaveEnd()
	if self.state==CHALLENGE40_STATE_SAVE then
		if self.need_wave_count<=0 then
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
			self:SetStackCount(self:GetStackCount()*self.bonus_gold_index)
			self.state = CHALLENGE40_STATE_GET_GOLD
		else
			self.need_wave_count = self.need_wave_count - 1
		end
	end
	
    return 1
end

function modifier_ChallengeInfo_040_3:OnCreated()
	if IsServer() then
		self.need_wave_count = 3
		self.bonus_gold_index = 1.1
		self.exp_bonus = 15
		if _G.GAME_ROUND>13 then
			--大于13回合直接完成
			self:SafeDestroy()
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
		end
		
		self.state = CHALLENGE40_STATE_SAVE
		self:StartIntervalThink(0.06)
	end
end
function modifier_ChallengeInfo_040_3:OnIntervalThink()
	if self.state==CHALLENGE40_STATE_SAVE then
		local target = self:GetParent()
		local gold = target:GetGold()
		if gold>=1 then
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((self:GetStackCount()+gold))
		end

	else
		if self.state==CHALLENGE40_STATE_GET_GOLD then
			local target = self:GetParent()
			local gold = target:GetGold()
			local bonus = self:GetStackCount()
			if gold>=70000 then
				return
			end
			--如何加起来大于70000则取一部分
			if( gold+bonus)>=70000 then
				local get_count = 70000-gold
				self:SetStackCount(self:GetStackCount()-get_count)
				target:ModifyGoldFiltered(get_count,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, get_count, nil)
			else
				target:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, bonus, nil)
				self:SafeDestroy()
			end
			

		end
	end
	
end






modifier_ChallengeInfo_040_4 = modifier_ChallengeInfo_040_4 or  advanced_modifier({})
function modifier_ChallengeInfo_040_4:IsHidden()return false end
function modifier_ChallengeInfo_040_4:IsDebuff()return true end
function modifier_ChallengeInfo_040_4:IsPurgable()return false end
function modifier_ChallengeInfo_040_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_040_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_040_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_040_4:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_ChallengeInfo_040_4:OnChallengeWaveEnd()
	if self.state==CHALLENGE40_STATE_SAVE then
		if self.need_wave_count<=0 then
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
			self:SetStackCount(self:GetStackCount()*self.bonus_gold_index)
			self.state = CHALLENGE40_STATE_GET_GOLD
		else
			self.need_wave_count = self.need_wave_count - 1
		end
	end
	
    return 1
end

function modifier_ChallengeInfo_040_4:OnCreated()
	if IsServer() then
		self.need_wave_count = 4
		self.bonus_gold_index = 1.13
		self.exp_bonus = 25
		if _G.GAME_ROUND>13 then
			--大于13回合直接完成
			self:SafeDestroy()
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
		end
		
		self.state = CHALLENGE40_STATE_SAVE
		self:StartIntervalThink(0.06)
	end
end
function modifier_ChallengeInfo_040_4:OnIntervalThink()
	if self.state==CHALLENGE40_STATE_SAVE then
		local target = self:GetParent()
		local gold = target:GetGold()
		if gold>=1 then
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((self:GetStackCount()+gold))
		end

	else
		if self.state==CHALLENGE40_STATE_GET_GOLD then
			local target = self:GetParent()
			local gold = target:GetGold()
			local bonus = self:GetStackCount()
			if gold>=70000 then
				return
			end
			--如何加起来大于70000则取一部分
			if( gold+bonus)>=70000 then
				local get_count = 70000-gold
				self:SetStackCount(self:GetStackCount()-get_count)
				target:ModifyGoldFiltered(get_count,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, get_count, nil)
			else
				target:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, bonus, nil)
				self:SafeDestroy()
			end
			

		end
	end
	
end






modifier_ChallengeInfo_040_5 = modifier_ChallengeInfo_040_5 or  advanced_modifier({})
function modifier_ChallengeInfo_040_5:IsHidden()return false end
function modifier_ChallengeInfo_040_5:IsDebuff()return true end
function modifier_ChallengeInfo_040_5:IsPurgable()return false end
function modifier_ChallengeInfo_040_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_040_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_040_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_040_5:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_ChallengeInfo_040_5:OnChallengeWaveEnd()
	if self.state==CHALLENGE40_STATE_SAVE then
		if self.need_wave_count<=0 then
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
			self:SetStackCount(self:GetStackCount()*self.bonus_gold_index)
			self.state = CHALLENGE40_STATE_GET_GOLD
		else
			self.need_wave_count = self.need_wave_count - 1
		end
	end
	
    return 1
end

function modifier_ChallengeInfo_040_5:OnCreated()
	if IsServer() then
		self.need_wave_count = 3
		self.bonus_gold_index = 1.16
		self.exp_bonus = 40
		if _G.GAME_ROUND>13 then
			--大于13回合直接完成
			self:SafeDestroy()
			local name = string.sub(self:GetName(),10,30)
			local hero = self:GetParent()
			local bonus = GetGoldBonus(name,hero)
			hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
			if hero:IsRealHero() then
				_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +self.exp_bonus
			end
		end
		
		self.state = CHALLENGE40_STATE_SAVE
		self:StartIntervalThink(0.06)
	end
end
function modifier_ChallengeInfo_040_5:OnIntervalThink()
	if self.state==CHALLENGE40_STATE_SAVE then
		local target = self:GetParent()
		local gold = target:GetGold()
		if gold>=1 then
			target:ModifyGoldFiltered(-gold,true,DOTA_ModifyGold_CreepKill )
			self:SetStackCount((self:GetStackCount()+gold))
		end

	else
		if self.state==CHALLENGE40_STATE_GET_GOLD then
			local target = self:GetParent()
			local gold = target:GetGold()
			local bonus = self:GetStackCount()
			if gold>=70000 then
				return
			end
			--如何加起来大于70000则取一部分
			if( gold+bonus)>=70000 then
				local get_count = 70000-gold
				self:SetStackCount(self:GetStackCount()-get_count)
				target:ModifyGoldFiltered(get_count,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, get_count, nil)
			else
				target:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, bonus, nil)
				self:SafeDestroy()
			end
			

		end
	end
	
end






modifier_ChallengeInfo_041_1 = modifier_ChallengeInfo_041_1 or  advanced_modifier({})
function modifier_ChallengeInfo_041_1:IsHidden()return false end
function modifier_ChallengeInfo_041_1:IsDebuff()return true end
function modifier_ChallengeInfo_041_1:IsPurgable()return false end
function modifier_ChallengeInfo_041_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_041_1:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_1:OnChallengeWaveEnd()

    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_041_buff", {stack = 3})
	end

    return 1
end
function modifier_ChallengeInfo_041_1:OnCreated( kv )
	if not IsServer() then return end
	self.refuse_chance = 20
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_ChallengeInfo_041_1:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_ChallengeInfo_041_1:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if self.refuse_chance>=RandomInt(1, 100) then
		return false
	end
	
	return true
end




modifier_ChallengeInfo_041_2 = modifier_ChallengeInfo_041_2 or  advanced_modifier({})
function modifier_ChallengeInfo_041_2:IsHidden()return false end
function modifier_ChallengeInfo_041_2:IsDebuff()return true end
function modifier_ChallengeInfo_041_2:IsPurgable()return false end
function modifier_ChallengeInfo_041_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_041_2:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_2:OnChallengeWaveEnd()

    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_041_buff", {stack = 5})
	end

    return 1
end
function modifier_ChallengeInfo_041_2:OnCreated( kv )
	if not IsServer() then return end
	self.refuse_chance = 50
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_ChallengeInfo_041_2:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_ChallengeInfo_041_2:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if self.refuse_chance>=RandomInt(1, 100) then
		return false
	end
	
	return true
end




modifier_ChallengeInfo_041_3 = modifier_ChallengeInfo_041_3 or  advanced_modifier({})
function modifier_ChallengeInfo_041_3:IsHidden()return false end
function modifier_ChallengeInfo_041_3:IsDebuff()return true end
function modifier_ChallengeInfo_041_3:IsPurgable()return false end
function modifier_ChallengeInfo_041_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_041_3:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_3:OnChallengeWaveEnd()

    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_041_buff", {stack = 8})
	end

    return 1
end
function modifier_ChallengeInfo_041_3:OnCreated( kv )
	if not IsServer() then return end
	self.refuse_chance = 85
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_ChallengeInfo_041_3:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_ChallengeInfo_041_3:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if self.refuse_chance>=RandomInt(1, 100) then
		return false
	end
	
	return true
end




modifier_ChallengeInfo_041_4 = modifier_ChallengeInfo_041_4 or  advanced_modifier({})
function modifier_ChallengeInfo_041_4:IsHidden()return false end
function modifier_ChallengeInfo_041_4:IsDebuff()return true end
function modifier_ChallengeInfo_041_4:IsPurgable()return false end
function modifier_ChallengeInfo_041_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_041_4:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_4:OnChallengeWaveEnd()

    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_041_buff", {stack = 12})
	end

    return 1
end
function modifier_ChallengeInfo_041_4:OnCreated( kv )
	if not IsServer() then return end
	self.refuse_chance = 90
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_ChallengeInfo_041_4:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_ChallengeInfo_041_4:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if self.refuse_chance>=RandomInt(1, 100) then
		return false
	end
	
	return true
end




modifier_ChallengeInfo_041_5 = modifier_ChallengeInfo_041_5 or  advanced_modifier({})
function modifier_ChallengeInfo_041_5:IsHidden()return false end
function modifier_ChallengeInfo_041_5:IsDebuff()return true end
function modifier_ChallengeInfo_041_5:IsPurgable()return false end
function modifier_ChallengeInfo_041_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE +MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ChallengeInfo_041_5:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_5:OnChallengeWaveEnd()

    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_041_buff", {stack =18})
	end

    return 1
end
function modifier_ChallengeInfo_041_5:OnCreated( kv )
	if not IsServer() then return end
	self.refuse_chance = 95
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_ChallengeInfo_041_5:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_ChallengeInfo_041_5:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if self.refuse_chance>=RandomInt(1, 100) then
		return false
	end
	
	return true
end


modifier_ChallengeInfo_041_buff = modifier_ChallengeInfo_041_buff or advanced_modifier({})
function modifier_ChallengeInfo_041_buff:IsHidden()return true end
function modifier_ChallengeInfo_041_buff:IsDebuff()return false end
function modifier_ChallengeInfo_041_buff:IsPurgable()return false end
function modifier_ChallengeInfo_041_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_041_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_041_buff:GetTexture() return "enchantress_untouchable" end
function modifier_ChallengeInfo_041_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_041_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_ChallengeInfo_041_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

-- advanced_modifier
function modifier_ChallengeInfo_041_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint

    }

	return funcs

end

function modifier_ChallengeInfo_041_buff:Advanced_GetModifier_CastPoint() return self:GetStackCount() end









modifier_ChallengeInfo_042_1 = modifier_ChallengeInfo_042_1 or  advanced_modifier({})
function modifier_ChallengeInfo_042_1:IsHidden()return false end
function modifier_ChallengeInfo_042_1:IsDebuff()return true end
function modifier_ChallengeInfo_042_1:IsPurgable()return false end
function modifier_ChallengeInfo_042_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_042_1:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5

		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_042_buff", {stack = 3})
	end

    return 1
end
function modifier_ChallengeInfo_042_1:OnCreated()
	if IsServer() then
		self.change_index = 0.15
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_042_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_042_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			local index = caster:GetMaxHealth()
			local mana = caster:GetMaxMana()
			if mana>index then
				index = mana
			end
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_042_effect", {stack = index * self.change_index})
		end
	end
end

modifier_ChallengeInfo_042_2 = modifier_ChallengeInfo_042_2 or  advanced_modifier({})
function modifier_ChallengeInfo_042_2:IsHidden()return false end
function modifier_ChallengeInfo_042_2:IsDebuff()return true end
function modifier_ChallengeInfo_042_2:IsPurgable()return false end
function modifier_ChallengeInfo_042_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_042_2:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_042_buff", {stack = 5})
	end

    return 1
end
function modifier_ChallengeInfo_042_2:OnCreated()
	if IsServer() then
		self.change_index = 0.3
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_042_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_042_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			local index = caster:GetMaxHealth()
			local mana = caster:GetMaxMana()
			if mana>index then
				index = mana
			end
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_042_effect", {stack = index * self.change_index})
		end
	end
end

modifier_ChallengeInfo_042_3 = modifier_ChallengeInfo_042_3 or  advanced_modifier({})
function modifier_ChallengeInfo_042_3:IsHidden()return false end
function modifier_ChallengeInfo_042_3:IsDebuff()return true end
function modifier_ChallengeInfo_042_3:IsPurgable()return false end
function modifier_ChallengeInfo_042_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_042_3:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_042_buff", {stack = 7})
	end

    return 1
end
function modifier_ChallengeInfo_042_3:OnCreated()
	if IsServer() then
		self.change_index = 0.6
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_042_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_042_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			local index = caster:GetMaxHealth()
			local mana = caster:GetMaxMana()
			if mana>index then
				index = mana
			end
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_042_effect", {stack = index * self.change_index})
		end
	end
end

modifier_ChallengeInfo_042_4 = modifier_ChallengeInfo_042_4 or  advanced_modifier({})
function modifier_ChallengeInfo_042_4:IsHidden()return false end
function modifier_ChallengeInfo_042_4:IsDebuff()return true end
function modifier_ChallengeInfo_042_4:IsPurgable()return false end
function modifier_ChallengeInfo_042_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_042_4:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_042_buff", {stack = 10})
	end

    return 1
end
function modifier_ChallengeInfo_042_4:OnCreated()
	if IsServer() then
		self.change_index = 1
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_042_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_042_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			local index = caster:GetMaxHealth()
			local mana = caster:GetMaxMana()
			if mana>index then
				index = mana
			end
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_042_effect", {stack = index * self.change_index})
		end
	end
end

modifier_ChallengeInfo_042_5 = modifier_ChallengeInfo_042_5 or  advanced_modifier({})
function modifier_ChallengeInfo_042_5:IsHidden()return false end
function modifier_ChallengeInfo_042_5:IsDebuff()return true end
function modifier_ChallengeInfo_042_5:IsPurgable()return false end
function modifier_ChallengeInfo_042_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_042_5:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_042_buff", {stack =15})
	end

    return 1
end
function modifier_ChallengeInfo_042_5:OnCreated()
	if IsServer() then
		self.change_index = 2
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_042_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_042_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			local index = caster:GetMaxHealth()
			local mana = caster:GetMaxMana()
			if mana>index then
				index = mana
			end
			unit:AddNewModifier(unit, ability, "modifier_ChallengeInfo_042_effect", {stack = index * self.change_index})
		end
	end
end


modifier_ChallengeInfo_042_effect = modifier_ChallengeInfo_042_effect or advanced_modifier({})

function modifier_ChallengeInfo_042_effect:IsDebuff()			return false end
function modifier_ChallengeInfo_042_effect:IsHidden() 			return false end
function modifier_ChallengeInfo_042_effect:IsPurgable() 		    return false end
function modifier_ChallengeInfo_042_effect:IsPurgeException() return false end
function modifier_ChallengeInfo_042_effect:GetTexture() return "brewmaster_earth_spell_immunity" end
-- function modifier_ChallengeInfo_042_effect:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_ChallengeInfo_042_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/challenge/challenge_42/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(10, 1, 1))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)

		-- self:StartIntervalThink(0.5)
	end
end

function modifier_ChallengeInfo_042_effect:OnRefresh(keys)
   if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
   end

end



function modifier_ChallengeInfo_042_effect:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_ChallengeInfo_042_effect:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return  self:GetStackCount()
	end
	if keys.block_disabled then
        return 0 
    end
	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end









modifier_ChallengeInfo_042_buff = modifier_ChallengeInfo_042_buff or advanced_modifier({})
function modifier_ChallengeInfo_042_buff:IsHidden()return true end
function modifier_ChallengeInfo_042_buff:IsDebuff()return false end
function modifier_ChallengeInfo_042_buff:IsPurgable()return false end
function modifier_ChallengeInfo_042_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_042_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_042_buff:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_ChallengeInfo_042_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(18)
	end
end
function modifier_ChallengeInfo_042_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + keys.stack)
	end
end

function modifier_ChallengeInfo_042_buff:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		return
	end
	local index = caster:GetMaxHealth()
	local mana = caster:GetMaxMana()
	if mana>index then
		index = mana
	end
	local shield = index * (self:GetStackCount()*0.01)
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_ChallengeInfo_042_shield", {stack = math.max(shield,300)})
end



modifier_ChallengeInfo_042_shield = modifier_ChallengeInfo_042_shield or advanced_modifier({})

function modifier_ChallengeInfo_042_shield:IsDebuff()			return false end
function modifier_ChallengeInfo_042_shield:IsHidden() 			return false end
function modifier_ChallengeInfo_042_shield:IsPurgable() 		    return false end
function modifier_ChallengeInfo_042_shield:IsPurgeException() return false end
function modifier_ChallengeInfo_042_shield:GetTexture() return "brewmaster_earth_spell_immunity" end
function modifier_ChallengeInfo_042_shield:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/challenge/challenge_42/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(15, 1, 1))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
	end
end

function modifier_ChallengeInfo_042_shield:OnRefresh(keys)
   if IsServer() then
		self:SetStackCount(keys.stack)
   end

end

function modifier_ChallengeInfo_042_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_ChallengeInfo_042_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return  self:GetStackCount()
	end
	if keys.block_disabled then
        return 0 
    end
	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end














modifier_ChallengeInfo_043_1 = modifier_ChallengeInfo_043_1 or  advanced_modifier({})
function modifier_ChallengeInfo_043_1:IsHidden()return false end
function modifier_ChallengeInfo_043_1:IsDebuff()return true end
function modifier_ChallengeInfo_043_1:IsPurgable()return false end
function modifier_ChallengeInfo_043_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_1:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local hero = self:GetParent()

	if GetHealReceiveAMP_Percentage(hero, nil)<=-100 then
		return
	end

	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_043_buff", {stack = 5})
	end

    return 1
end
function modifier_ChallengeInfo_043_1:OnCreated()
	if IsServer() then
		self:OnChallengeWaveEnd()
	end
end



modifier_ChallengeInfo_043_2 = modifier_ChallengeInfo_043_2 or  advanced_modifier({})
function modifier_ChallengeInfo_043_2:IsHidden()return false end
function modifier_ChallengeInfo_043_2:IsDebuff()return true end
function modifier_ChallengeInfo_043_2:IsPurgable()return false end
function modifier_ChallengeInfo_043_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_2:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local hero = self:GetParent()

	if GetHealReceiveAMP_Percentage(hero, nil)<=-100 then
		return
	end

	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_043_buff", {stack = 8})
	end

    return 1
end
function modifier_ChallengeInfo_043_2:OnCreated()
	if IsServer() then
		self:OnChallengeWaveEnd()
	end
end




modifier_ChallengeInfo_043_3 = modifier_ChallengeInfo_043_3 or  advanced_modifier({})
function modifier_ChallengeInfo_043_3:IsHidden()return false end
function modifier_ChallengeInfo_043_3:IsDebuff()return true end
function modifier_ChallengeInfo_043_3:IsPurgable()return false end
function modifier_ChallengeInfo_043_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_3:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local hero = self:GetParent()

	if GetHealReceiveAMP_Percentage(hero, nil)<=-100 then
		return
	end

	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_043_buff", {stack = 12})
	end

    return 1
end
function modifier_ChallengeInfo_043_3:OnCreated()
	if IsServer() then
		self:OnChallengeWaveEnd()
	end
end



modifier_ChallengeInfo_043_4 = modifier_ChallengeInfo_043_4 or  advanced_modifier({})
function modifier_ChallengeInfo_043_4:IsHidden()return false end
function modifier_ChallengeInfo_043_4:IsDebuff()return true end
function modifier_ChallengeInfo_043_4:IsPurgable()return false end
function modifier_ChallengeInfo_043_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_4:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local hero = self:GetParent()

	if GetHealReceiveAMP_Percentage(hero, nil)<=-100 then
		return
	end

	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_043_buff", {stack = 16})
	end

    return 1
end
function modifier_ChallengeInfo_043_4:OnCreated()
	if IsServer() then
		self:OnChallengeWaveEnd()
	end
end



modifier_ChallengeInfo_043_5 = modifier_ChallengeInfo_043_5 or  advanced_modifier({})
function modifier_ChallengeInfo_043_5:IsHidden()return false end
function modifier_ChallengeInfo_043_5:IsDebuff()return true end
function modifier_ChallengeInfo_043_5:IsPurgable()return false end
function modifier_ChallengeInfo_043_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_5:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local hero = self:GetParent()

	if GetHealReceiveAMP_Percentage(hero, nil)<=-100 then
		return
	end

	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_043_buff", {stack = 25})
	end

    return 1
end
function modifier_ChallengeInfo_043_5:OnCreated()
	if IsServer() then
		self:OnChallengeWaveEnd()
	end
end





modifier_ChallengeInfo_043_buff = modifier_ChallengeInfo_043_buff or  advanced_modifier({})
function modifier_ChallengeInfo_043_buff:IsHidden()return false end
function modifier_ChallengeInfo_043_buff:IsDebuff()return true end
function modifier_ChallengeInfo_043_buff:IsPurgable()return false end
function modifier_ChallengeInfo_043_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_buff:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)

		self.ability =  self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_043_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)


	end
end
function modifier_ChallengeInfo_043_buff:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_043_buff:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_043_effect", {stack =self:GetStackCount()})
		end
	end
end
-- advanced_modifier
function modifier_ChallengeInfo_043_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_043_buff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -self:GetStackCount()*2.5
end









modifier_ChallengeInfo_043_effect = modifier_ChallengeInfo_043_effect or  advanced_modifier({})
function modifier_ChallengeInfo_043_effect:IsHidden()return false end
function modifier_ChallengeInfo_043_effect:IsDebuff()return true end
function modifier_ChallengeInfo_043_effect:IsPurgable()return false end
function modifier_ChallengeInfo_043_effect:IsPurgeException() 	return false end
function modifier_ChallengeInfo_043_effect:RemoveOnDeath() return false end
function modifier_ChallengeInfo_043_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_043_effect:GetTexture() return "necrolyte/ti9_immortal_legs/necrophos_ghost_shroud_immortal" end
function modifier_ChallengeInfo_043_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)

	end
end
function modifier_ChallengeInfo_043_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
-- advanced_modifier
function modifier_ChallengeInfo_043_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_ChallengeInfo_043_effect:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -self:GetStackCount()
end






modifier_ChallengeInfo_044_1 = modifier_ChallengeInfo_044_1 or  advanced_modifier({})
function modifier_ChallengeInfo_044_1:IsHidden()return false end
function modifier_ChallengeInfo_044_1:IsDebuff()return true end
function modifier_ChallengeInfo_044_1:IsPurgable()return false end
function modifier_ChallengeInfo_044_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_1:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_044_buff", {stack =5})
	end

    return 1
end
function modifier_ChallengeInfo_044_1:OnCreated()
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_044_1:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_044_1:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_044_enemy_buff", {stack = 3})
		end
	end
end



modifier_ChallengeInfo_044_2 = modifier_ChallengeInfo_044_2 or  advanced_modifier({})
function modifier_ChallengeInfo_044_2:IsHidden()return false end
function modifier_ChallengeInfo_044_2:IsDebuff()return true end
function modifier_ChallengeInfo_044_2:IsPurgable()return false end
function modifier_ChallengeInfo_044_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_2:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_044_buff", {stack =9})
	end

    return 1
end
function modifier_ChallengeInfo_044_2:OnCreated()
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_044_2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_044_2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_044_enemy_buff", {stack = 5})
		end
	end
end




modifier_ChallengeInfo_044_3 = modifier_ChallengeInfo_044_3 or  advanced_modifier({})
function modifier_ChallengeInfo_044_3:IsHidden()return false end
function modifier_ChallengeInfo_044_3:IsDebuff()return true end
function modifier_ChallengeInfo_044_3:IsPurgable()return false end
function modifier_ChallengeInfo_044_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_3:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_044_buff", {stack =13})
	end

    return 1
end
function modifier_ChallengeInfo_044_3:OnCreated()
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_044_3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_044_3:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_044_enemy_buff", {stack = 7})
		end
	end
end



modifier_ChallengeInfo_044_4 = modifier_ChallengeInfo_044_4 or  advanced_modifier({})
function modifier_ChallengeInfo_044_4:IsHidden()return false end
function modifier_ChallengeInfo_044_4:IsDebuff()return true end
function modifier_ChallengeInfo_044_4:IsPurgable()return false end
function modifier_ChallengeInfo_044_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_4:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_044_buff", {stack =20})
	end

    return 1
end
function modifier_ChallengeInfo_044_4:OnCreated()
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_044_4:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_044_4:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_044_enemy_buff", {stack = 10})
		end
	end
end




modifier_ChallengeInfo_044_5 = modifier_ChallengeInfo_044_5 or  advanced_modifier({})
function modifier_ChallengeInfo_044_5:IsHidden()return false end
function modifier_ChallengeInfo_044_5:IsDebuff()return true end
function modifier_ChallengeInfo_044_5:IsPurgable()return false end
function modifier_ChallengeInfo_044_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_5:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_044_buff", {stack =25})
	end

    return 1
end
function modifier_ChallengeInfo_044_5:OnCreated()
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Default_Move")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
	end
end
function modifier_ChallengeInfo_044_5:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_ChallengeInfo_044_5:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if not caster then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			unit:AddNewModifier(unit, self.ability, "modifier_ChallengeInfo_044_enemy_buff", {stack = 15})
		end
	end
end




modifier_ChallengeInfo_044_buff = modifier_ChallengeInfo_044_buff or  advanced_modifier({})
function modifier_ChallengeInfo_044_buff:IsHidden()return false end
function modifier_ChallengeInfo_044_buff:IsDebuff()return false end
function modifier_ChallengeInfo_044_buff:IsPurgable()return false end
function modifier_ChallengeInfo_044_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_buff:DestroyOnExpire() return false end
function modifier_ChallengeInfo_044_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_buff:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)

	end
end
function modifier_ChallengeInfo_044_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end
function modifier_ChallengeInfo_044_buff:OnIntervalThink()
	local parent = self:GetParent()
	self:StartIntervalThink(0.1)
	if parent:IsAlive() and parent:GetHealthPercent()<=30 then
		if self:GetRemainingTime()<=0 then
			self:SetDuration(80, true)
			self:StartIntervalThink(80)
			local duration =math.min( 1+self:GetStackCount()*0.1,15)
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_ChallengeInfo_044_active", {duration = duration})
		end
	end
end



modifier_ChallengeInfo_044_enemy_buff = modifier_ChallengeInfo_044_enemy_buff or  advanced_modifier({})
function modifier_ChallengeInfo_044_enemy_buff:IsHidden()return true end
function modifier_ChallengeInfo_044_enemy_buff:IsDebuff()return false end
function modifier_ChallengeInfo_044_enemy_buff:IsPurgable()return false end
function modifier_ChallengeInfo_044_enemy_buff:IsPurgeException() 	return false end
-- function modifier_ChallengeInfo_044_enemy_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_044_enemy_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_044_enemy_buff:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_enemy_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)

	end
end
function modifier_ChallengeInfo_044_enemy_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end
function modifier_ChallengeInfo_044_enemy_buff:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=15 then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_ChallengeInfo_044_active", {duration = self:GetStackCount()})
		self:SafeDestroy()
	end
end


modifier_ChallengeInfo_044_active = modifier_ChallengeInfo_044_active or  advanced_modifier({})
function modifier_ChallengeInfo_044_active:IsHidden()return false end
function modifier_ChallengeInfo_044_active:IsDebuff()return false end
function modifier_ChallengeInfo_044_active:IsPurgable()return false end
function modifier_ChallengeInfo_044_active:IsPurgeException() 	return false end
function modifier_ChallengeInfo_044_active:GetTexture() return "necrolyte/necronub/necrolyte_sadist" end
function modifier_ChallengeInfo_044_active:OnCreated(keys)
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/challenge/challenge_044/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(10, 1, 1))
		ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(50, 1, 1))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
	end
end
function modifier_ChallengeInfo_044_active:DeclareFunctions()
	local funcs	=	{
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, --免疫物理
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,  --免疫魔法
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,     --免疫纯粹
	}
	return funcs
end


function modifier_ChallengeInfo_044_active:GetAbsoluteNoDamagePhysical()return 1 end
function modifier_ChallengeInfo_044_active:GetAbsoluteNoDamageMagical()return 1 end
function modifier_ChallengeInfo_044_active:GetAbsoluteNoDamagePure()return 1 end














modifier_ChallengeInfo_045_1 = modifier_ChallengeInfo_045_1 or  advanced_modifier({})
function modifier_ChallengeInfo_045_1:IsHidden()return false end
function modifier_ChallengeInfo_045_1:IsDebuff()return true end
function modifier_ChallengeInfo_045_1:IsPurgable()return false end
function modifier_ChallengeInfo_045_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_1:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +5
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_045_buff", {stack =5})
	end

    return 1
end
function modifier_ChallengeInfo_045_1:OnCreated()
	if IsServer() then
		self.max = 200
		self.change = 10
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_1:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_1:GetModifierDamageOutgoing_Percentage()
	return -math.max(self:GetStackCount()*0.1,10)
end



modifier_ChallengeInfo_045_2 = modifier_ChallengeInfo_045_2 or  advanced_modifier({})
function modifier_ChallengeInfo_045_2:IsHidden()return false end
function modifier_ChallengeInfo_045_2:IsDebuff()return true end
function modifier_ChallengeInfo_045_2:IsPurgable()return false end
function modifier_ChallengeInfo_045_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_2:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +10
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_045_buff", {stack =7})
	end

    return 1
end
function modifier_ChallengeInfo_045_2:OnCreated()
	if IsServer() then
		self.max = 300
		self.change = 15
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_2:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_2:GetModifierDamageOutgoing_Percentage()
	return -math.max(self:GetStackCount()*0.1,15)
end




modifier_ChallengeInfo_045_3 = modifier_ChallengeInfo_045_3 or  advanced_modifier({})
function modifier_ChallengeInfo_045_3:IsHidden()return false end
function modifier_ChallengeInfo_045_3:IsDebuff()return true end
function modifier_ChallengeInfo_045_3:IsPurgable()return false end
function modifier_ChallengeInfo_045_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_3:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +15
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_045_buff", {stack =10})
	end

    return 1
end
function modifier_ChallengeInfo_045_3:OnCreated()
	if IsServer() then
		self.max = 450
		self.change = 20
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_3:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_3:GetModifierDamageOutgoing_Percentage()
	return -math.max(self:GetStackCount()*0.1,23)
end



modifier_ChallengeInfo_045_4 = modifier_ChallengeInfo_045_4 or  advanced_modifier({})
function modifier_ChallengeInfo_045_4:IsHidden()return false end
function modifier_ChallengeInfo_045_4:IsDebuff()return true end
function modifier_ChallengeInfo_045_4:IsPurgable()return false end
function modifier_ChallengeInfo_045_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_4:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +25
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_045_buff", {stack =14})
	end

    return 1
end
function modifier_ChallengeInfo_045_4:OnCreated()
	if IsServer() then
		self.max = 650
		self.change = 25
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_4:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_4:GetModifierDamageOutgoing_Percentage()
	return -math.max(self:GetStackCount()*0.1,30)
end




modifier_ChallengeInfo_045_5 = modifier_ChallengeInfo_045_5 or  advanced_modifier({})
function modifier_ChallengeInfo_045_5:IsHidden()return false end
function modifier_ChallengeInfo_045_5:IsDebuff()return true end
function modifier_ChallengeInfo_045_5:IsPurgable()return false end
function modifier_ChallengeInfo_045_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_5:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local hero = self:GetParent()
	local bonus = GetGoldBonus(name,hero)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	
	if hero:IsRealHero() then
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +40
		local ability = hero:FindAbilityByName("Default_Move")
		hero:AddNewModifier(hero, ability, "modifier_ChallengeInfo_045_buff", {stack =20})
	end

    return 1
end
function modifier_ChallengeInfo_045_5:OnCreated()
	if IsServer() then
		self.max = 900
		self.change = 30
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_5:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_5:GetModifierDamageOutgoing_Percentage()
	return -math.max(self:GetStackCount()*0.1,50)
end









modifier_ChallengeInfo_045_buff = modifier_ChallengeInfo_045_buff or  advanced_modifier({})
function modifier_ChallengeInfo_045_buff:IsHidden()return false end
function modifier_ChallengeInfo_045_buff:IsDebuff()return false end
function modifier_ChallengeInfo_045_buff:IsPurgable()return false end
function modifier_ChallengeInfo_045_buff:IsPurgeException() 	return false end
function modifier_ChallengeInfo_045_buff:RemoveOnDeath() return false end
function modifier_ChallengeInfo_045_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_045_buff:GetTexture() return "enigma_midnight_pulse" end
function modifier_ChallengeInfo_045_buff:OnCreated(keys)
	if IsServer() then
		self.max = 30 + keys.stack
		self.change = 10
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_buff:OnRefresh(keys)
	if IsServer() then
		self.max = math.min(self.max + keys.stack,300)
		self.change = 10
		self.forward = 1
		self:StartIntervalThink(1)
	end
end
function modifier_ChallengeInfo_045_buff:OnIntervalThink()
	if self.forward==1 then
		self:SetStackCount(math.min(self:GetStackCount()+self.change,self.max))
		if self:GetStackCount()>=self.max then
			self.forward = 0
		end
	else
		self:SetStackCount(math.max(self:GetStackCount()-self.change,0))
		if self:GetStackCount()<=0 then
			self.forward = 1
		end
	end
end

function modifier_ChallengeInfo_045_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}
	return funcs
end


function modifier_ChallengeInfo_045_buff:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount()*0.1
end














modifier_ChallengeInfo_046_1 = advanced_modifier({})
function modifier_ChallengeInfo_046_1:IsHidden()return false end
function modifier_ChallengeInfo_046_1:IsDebuff()return true end
function modifier_ChallengeInfo_046_1:IsPurgable()return false end
function modifier_ChallengeInfo_046_1:IsPurgeException() 	return false end
function modifier_ChallengeInfo_046_1:RemoveOnDeath() return false end
function modifier_ChallengeInfo_046_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_046_1:GetTexture() return "leshrac_pulse_nova" end
function modifier_ChallengeInfo_046_1:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.2
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +12
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.12
	end
    return 1
end
function modifier_ChallengeInfo_046_1:WaveEndGOLDBONUS2()
    return 500
end
function modifier_ChallengeInfo_046_1:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_009",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 1,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_046_2 = advanced_modifier({})
function modifier_ChallengeInfo_046_2:IsHidden()return false end
function modifier_ChallengeInfo_046_2:IsDebuff()return true end
function modifier_ChallengeInfo_046_2:IsPurgable()return false end
function modifier_ChallengeInfo_046_2:IsPurgeException() 	return false end
function modifier_ChallengeInfo_046_2:RemoveOnDeath() return false end
function modifier_ChallengeInfo_046_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_046_2:GetTexture() return "leshrac_pulse_nova" end
function modifier_ChallengeInfo_046_2:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +1.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +18
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.18
	end
    return 1
end
function modifier_ChallengeInfo_046_2:WaveEndGOLDBONUS2()
    return 800
end
function modifier_ChallengeInfo_046_2:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_009",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 2,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_046_3 = advanced_modifier({})
function modifier_ChallengeInfo_046_3:IsHidden()return false end
function modifier_ChallengeInfo_046_3:IsDebuff()return true end
function modifier_ChallengeInfo_046_3:IsPurgable()return false end
function modifier_ChallengeInfo_046_3:IsPurgeException() 	return false end
function modifier_ChallengeInfo_046_3:RemoveOnDeath() return false end
function modifier_ChallengeInfo_046_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_046_3:GetTexture() return "leshrac_pulse_nova" end
function modifier_ChallengeInfo_046_3:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +2.4
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +36
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.24
	end
    return 1
end
function modifier_ChallengeInfo_046_3:WaveEndGOLDBONUS2()
    return 1200
end
function modifier_ChallengeInfo_046_3:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_009",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 3,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end




modifier_ChallengeInfo_046_4 = advanced_modifier({})
function modifier_ChallengeInfo_046_4:IsHidden()return false end
function modifier_ChallengeInfo_046_4:IsDebuff()return true end
function modifier_ChallengeInfo_046_4:IsPurgable()return false end
function modifier_ChallengeInfo_046_4:IsPurgeException() 	return false end
function modifier_ChallengeInfo_046_4:RemoveOnDeath() return false end
function modifier_ChallengeInfo_046_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_046_4:GetTexture() return "leshrac_pulse_nova" end
function modifier_ChallengeInfo_046_4:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +3.6
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +60
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.3
	end
    return 1
end
function modifier_ChallengeInfo_046_4:WaveEndGOLDBONUS2()
    return 1600
end
function modifier_ChallengeInfo_046_4:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_009",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   =0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
							gain_class = 5,
						side = 400,
						challenge_level = 4,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end



modifier_ChallengeInfo_046_5 = advanced_modifier({})
function modifier_ChallengeInfo_046_5:IsHidden()return false end
function modifier_ChallengeInfo_046_5:IsDebuff()return true end
function modifier_ChallengeInfo_046_5:IsPurgable()return false end
function modifier_ChallengeInfo_046_5:IsPurgeException() 	return false end
function modifier_ChallengeInfo_046_5:RemoveOnDeath() return false end
function modifier_ChallengeInfo_046_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ChallengeInfo_046_5:GetTexture() return "leshrac_pulse_nova" end
function modifier_ChallengeInfo_046_5:OnChallengeWaveEnd()
    self:SafeDestroy()
	local name = string.sub(self:GetName(),10,30)
	local bonus = GetGoldBonus(name,self:GetParent())
	self:GetParent():ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_SellItem )  --金币奖励
	local hero = self:GetParent()
	if hero:IsRealHero() then
		_G.GAME_BONUS_GOLD = _G.GAME_BONUS_GOLD +4.8
		_G.GAME_BONUS_EXP = _G.GAME_BONUS_EXP +84
		_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +0.36
	end
    return 1
end
function modifier_ChallengeInfo_046_5:WaveEndGOLDBONUS2()
    return 2000
end

function modifier_ChallengeInfo_046_5:OnCreated()
	if IsServer() then
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		if IsInToolsMode() then
			gameWave_index = _G.GAME_ROUND
		end
		local npc_info = 					  
		{
						name = "npc_monster_challenge_009",
						number_min ='1',
						number_max = '1',
						wave = 1,
						startTime = 20,
						interval = 7,
						needTime = 3,
						haveGain   = 0,
						SpecialGain_index_min = 1000,
						SpecialGain_index_max = 1000,
						gain_class = 5,
						side = 400,
						challenge_level = 5,
		}
		table.insert(_G.GAME_Units[gameWave_index],npc_info)
	end
end


