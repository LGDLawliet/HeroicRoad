Advanced_Vengeance_Aura = class({})
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_effect", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_effect_buff", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_unlock1", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_unlock2", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_unlock3_thinker", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vengeance_Aura_unlock3_effect", "skills/Advanced_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function Advanced_Vengeance_Aura:CheckKV(key)
	local table = {
		bonus_damage=1.5,



	}
	local value = table[key] or -1
	return value

end



function Advanced_Vengeance_Aura:UnlockFirstCore(key)
	self.unlock1_time = GameRules:GetGameTime()
	return true
end
function Advanced_Vengeance_Aura:UnlockSecondCore(key)
	return true
end
function Advanced_Vengeance_Aura:UnlockThirdCore(key)
	return true
end


function Advanced_Vengeance_Aura:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_abaddon_frostmourne.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/vengeance_aura/unlock3/effectstyle2.vpcf", context )


	
end






function Advanced_Vengeance_Aura:GetIntrinsicModifierName()
	return "modifier_Advanced_Vengeance_Aura"
end


modifier_Advanced_Vengeance_Aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Vengeance_Aura:IsHidden()	return true end
function modifier_Advanced_Vengeance_Aura:IsDebuff()	return false end
function modifier_Advanced_Vengeance_Aura:IsPurgable() 		return false end
function modifier_Advanced_Vengeance_Aura:IsPurgeException() 	return false end
function modifier_Advanced_Vengeance_Aura:RemoveOnDeath()  return false end
function modifier_Advanced_Vengeance_Aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Vengeance_Aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Vengeance_Aura:GetModifierAura()	return "modifier_Advanced_Vengeance_Aura_effect" end
function modifier_Advanced_Vengeance_Aura:GetAuraRadius()	
	if IsServer() then
		if not self:GetCaster():IsAlive() and self:GetAbility().advanced_level>=20 then
			return  99999

		end
	end
	return self:GetAbility():GetSpecialValueFor("radius") 
end

function modifier_Advanced_Vengeance_Aura:IsAuraActiveOnDeath()
	if IsServer() then
		if self:GetAbility().advanced_level>=20 then
			return  true
	
		end
		
	end
	return false
	
end
function modifier_Advanced_Vengeance_Aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Vengeance_Aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Vengeance_Aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_DEAD   end



modifier_Advanced_Vengeance_Aura_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Vengeance_Aura_effect:IsHidden()	return false end
function modifier_Advanced_Vengeance_Aura_effect:IsDebuff()	return false end
function modifier_Advanced_Vengeance_Aura_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Vengeance_Aura_effect:IsPurgable()	return false end
function modifier_Advanced_Vengeance_Aura_effect:OnCreated( kv )
	self.ability	= self:GetAbility()
	self.advanced_level = 1
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self:StartIntervalThink(1)

	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_Respawn_weak_target")
		if modifier then
			local gain = self:GetCaster():GetModifierDurationGainIndex(1)
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Vengeance_Aura_effect_buff", {duration = 20*gain})
		end
	end


end


function modifier_Advanced_Vengeance_Aura_effect:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsNull() then
			return
		end

		if parent.hdIsSummoned then
			local ability = self:GetAbility()
			if  not ability or not ability.unlock1 or ability.unlock1_time>=GameRules:GetGameTime() then
				return
			end
			if parent:HasModifier("modifier_Advanced_Vengeance_Aura_unlock1") or parent.Vengeance_Aura_unlock3 or parent.specialUnit then
				return
			end
			local health = parent:GetHealth()
			if health<=0 then --死亡
				ability.unlock1_time = GameRules:GetGameTime() +1
				local health = parent:GetMaxHealth()*2
				local damage = parent:GetDamageMax()*2
				local armor = parent:GetPhysicalArmorBaseValue()*2
				local mana = parent:GetMaxMana()*2
				local caster = self:GetCaster()
				local pos = parent:GetAbsOrigin()
				local unit = caster:SummonUnit(parent:GetUnitName(),10,
				pos,
				caster:GetForwardVector(),
				self:GetAbility(),0,health,mana,damage,armor,1,0)
				unit.Vengeance_Aura_unlock3 = true
				unit.specialUnit = true
				unit:AddNewModifier(caster, ability, "modifier_Advanced_Vengeance_Aura_unlock1", {})
			end
		end
	end
end
function modifier_Advanced_Vengeance_Aura_effect:OnIntervalThink()
	if not self.ability or self.ability:IsNull() then
		return
	end

	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	if self:GetStackCount()==1 then
		self.bonus_damage = self.bonus_damage*1.5
	end
	if IsServer() then
		
		local modifier = self:GetParent():FindModifierByName("modifier_Respawn_weak_target")
		if modifier then
			local gain = self:GetCaster():GetModifierDurationGainIndex(1)
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Vengeance_Aura_effect_buff", {duration = 20*gain})
		end
		if self:GetCaster():IsInNightTime() and self.advanced_level>=15 then
			self:SetStackCount(1)
		else
			self:SetStackCount(0)
		end
		self.bonus = 0
		if not self:GetCaster():IsAlive() and self.advanced_level>=20 then
			self.bonus = 30
		end
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Vengeance_Aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		-- MODIFIER_PROPERTY_BASE_MANA_REGEN,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}

	return funcs
end
function modifier_Advanced_Vengeance_Aura_effect:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},} 
end
function modifier_Advanced_Vengeance_Aura_effect:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage
end

function modifier_Advanced_Vengeance_Aura_effect:GetModifierBonusStats_Strength()	return self.bonus end
function modifier_Advanced_Vengeance_Aura_effect:GetModifierBonusStats_Intellect()	return self.bonus end
function modifier_Advanced_Vengeance_Aura_effect:GetModifierBonusStats_Agility()	return self.bonus end
function modifier_Advanced_Vengeance_Aura_effect:AdvancedOnDeathAgain(keys)
	if not IsServer() then
        return
    end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,
    500,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local target = enemies[1]



	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	local damage = parent:GetDamageMax()*5
	if self.advanced_level>=5 then
		damage = parent:GetAverageTrueAttackDamage(nil)*5
	end
	if parent:IsRealHero() then
		damage =damage *2
	end
	damage = damage* keys.mul_index

	parent:GameTimer(0.2,function()
		if IsValid(self) then
			ApplyDamage({victim = target, attacker = parent, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
			target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
		end
	end)
end





function modifier_Advanced_Vengeance_Aura_effect:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if not keys.attacker then
		return
	end
    if keys.unit == self:GetParent() and IsEnemy(keys.unit, keys.attacker) then
		local parent = self:GetParent()
		local target = keys.attacker



		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local damage = parent:GetDamageMax()*5
		if self.advanced_level>=5 then
			damage = parent:GetAverageTrueAttackDamage(nil)*5
		end
		if parent:IsRealHero() then
			damage =damage *2
		end
		parent:GameTimer(0.2,function()
			if IsValid(self) then
				ApplyDamage({victim = target, attacker = parent, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
				target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
			end
		end)
		if parent == self:GetCaster() and ability.unlock3 then
			self:TriggerUnlock3()
		end

    end
	if keys.attacker==self:GetParent() and ability.unlock2 then
		local gain = self:GetCaster():GetModifierDurationGainIndex(1)
		keys.attacker:AddNewModifier(
			self:GetCaster(),
			ability,
			"modifier_Advanced_Vengeance_Aura_unlock2",
			{	duration =120*gain})
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, keys.attacker:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

end


function modifier_Advanced_Vengeance_Aura_effect:TriggerUnlock3()
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
		
	local thinker =CreateModifierThinker(
		caster,
		self:GetAbility(),
		"modifier_Advanced_Vengeance_Aura_unlock3_thinker",
		{
			duration = -1,
		},
		pos,
		caster:GetTeamNumber(),
		false
	)
end

modifier_Advanced_Vengeance_Aura_effect_buff = class({})


function modifier_Advanced_Vengeance_Aura_effect_buff:IsHidden()return false end
function modifier_Advanced_Vengeance_Aura_effect_buff:IsDebuff()return false end
function modifier_Advanced_Vengeance_Aura_effect_buff:IsStunDebuff()return false end
function modifier_Advanced_Vengeance_Aura_effect_buff:IsPurgable()return false end
function modifier_Advanced_Vengeance_Aura_effect_buff:IsPurgeException() 	return false end
function modifier_Advanced_Vengeance_Aura_effect_buff:RemoveOnDeath() return false end
-- function modifier_Advanced_Vengeance_Aura_effect_buff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Vengeance_Aura_effect_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Advanced_Vengeance_Aura_effect_buff:GetModifierBonusStats_Strength()	return self.bonus end
function modifier_Advanced_Vengeance_Aura_effect_buff:GetModifierBonusStats_Intellect()	return self.bonus end
function modifier_Advanced_Vengeance_Aura_effect_buff:GetModifierBonusStats_Agility()	return self.bonus end


function modifier_Advanced_Vengeance_Aura_effect_buff:OnCreated(keys)
	if IsServer() then
		
		self.bonus =50
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
			self.bonus = 75
		end

	end
end








modifier_Advanced_Vengeance_Aura_unlock1 = class({})

function modifier_Advanced_Vengeance_Aura_unlock1:IsDebuff()			return false end
function modifier_Advanced_Vengeance_Aura_unlock1:IsHidden() 			return true end
function modifier_Advanced_Vengeance_Aura_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Vengeance_Aura_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Vengeance_Aura_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Vengeance_Aura_unlock1:CheckState() return 
	{[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	 [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	} 
end
function modifier_Advanced_Vengeance_Aura_unlock1:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_frostmourne.vpcf" end
function modifier_Advanced_Vengeance_Aura_unlock1:StatusEffectPriority() return 10000 end






modifier_Advanced_Vengeance_Aura_unlock2 = class({})

function modifier_Advanced_Vengeance_Aura_unlock2:IsHidden()	return false end
function modifier_Advanced_Vengeance_Aura_unlock2:IsDebuff()	return false end
function modifier_Advanced_Vengeance_Aura_unlock2:IsPurgable()	return false end
function modifier_Advanced_Vengeance_Aura_unlock2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Advanced_Vengeance_Aura_unlock2:GetModifierBonusStats_Strength()	return 5*self:GetStackCount() end
function modifier_Advanced_Vengeance_Aura_unlock2:GetModifierBonusStats_Intellect()	return 5*self:GetStackCount() end
function modifier_Advanced_Vengeance_Aura_unlock2:GetModifierBonusStats_Agility()	return 5*self:GetStackCount() end




function modifier_Advanced_Vengeance_Aura_unlock2:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_Vengeance_Aura_unlock2:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 20 then
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

function modifier_Advanced_Vengeance_Aura_unlock2:OnIntervalThink()
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









modifier_Advanced_Vengeance_Aura_unlock3_thinker = class({})
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:IsAura()	return true end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:GetModifierAura()	return "modifier_Advanced_Vengeance_Aura_unlock3_effect" end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:GetAuraRadius()	return 2000  end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:OnCreated(params)
	if IsServer() then
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/vengeance_aura/unlock3/effectstyle2.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(9999,0,0) )
		-- ParticleManager:ReleaseParticleIndex(effect_cast)
		self:StartIntervalThink(0.2)
	end
end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:OnIntervalThink()
	if self:GetCaster():IsAlive() then
		self:SafeDestroy()
	end
end
function modifier_Advanced_Vengeance_Aura_unlock3_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast,false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	UTIL_Remove( self:GetParent() )
end


modifier_Advanced_Vengeance_Aura_unlock3_effect = advanced_modifier({})
function modifier_Advanced_Vengeance_Aura_unlock3_effect:IsHidden()	return false end
function modifier_Advanced_Vengeance_Aura_unlock3_effect:IsDebuff()	return true end
function modifier_Advanced_Vengeance_Aura_unlock3_effect:IsPurgable()	return false end

function modifier_Advanced_Vengeance_Aura_unlock3_effect:Advanced_GetModifierIncomingDamage_Percentage()	return 100 end
function modifier_Advanced_Vengeance_Aura_unlock3_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

