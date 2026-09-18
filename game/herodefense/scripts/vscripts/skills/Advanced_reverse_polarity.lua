--特效优化 √
Advanced_reverse_polarity = class({})

LinkLuaModifier("modifier_Advanced_reverse_polarity_debuff", "skills/Advanced_reverse_polarity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reverse_polarity_debuff2", "skills/Advanced_reverse_polarity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reverse_polarity_buff", "skills/Advanced_reverse_polarity", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_reverse_polarity_unlock1", "skills/Advanced_reverse_polarity", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能


Advanced_reverse_polarity = Advanced_reverse_polarity or class({})
function Advanced_reverse_polarity:CheckKV(key)
	local table = {
		bonus_damage = 1,
	


	}
	local value = table[key] or -1
	return value

end
function Advanced_reverse_polarity:GetCooldown(iLevel)
	local base_cooldown = self.BaseClass.GetCooldown(self,iLevel)
	if self:GetUnlock(3)==3 then
		return base_cooldown-10
	end
	return base_cooldown
end

function Advanced_reverse_polarity:CheckKVFixedOverride(key)
	if key=="radius" then
		if self:GetUnlock(2)==2 then
			return 800
		end
	elseif key=="duration" then
		if self:GetUnlock(2)==2 then
			return 7
		end
	end

	return -999999

end
function Advanced_reverse_polarity:IsRefreshable()
	if self.unlock2 then
		return false
	end
	return true
end

function Advanced_reverse_polarity:UnlockFirstCore(key)
	return true
end
function Advanced_reverse_polarity:UnlockSecondCore(key)
	
	return true
end
function Advanced_reverse_polarity:UnlockThirdCore(key)
	return true
end
--------------------------------------------------------------------------------
-- Init Abilities
function Advanced_reverse_polarity:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context )
end
function Advanced_reverse_polarity:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function Advanced_reverse_polarity:Spawn()
	self.effect_cast = {}
end
--------------------------------------------------------------------------------
-- Ability Phase Start
function Advanced_reverse_polarity:OnAbilityPhaseStart()
	-- play effects
	if self.advanced_level>=20 then
		local heroes = GetAllRealHeroes()
		for  _, hero in pairs(heroes) do
			if hero:IsAlive() then
				self:PlayEffects1(hero)
			end
		end
	else
		self:PlayEffects1(self:GetCaster())
	end
	

	return true -- if success
end

function Advanced_reverse_polarity:OnAbilityPhaseInterrupted()
	-- stop effects
	self:StopEffects( true )
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_reverse_polarity:OnSpellStart()
	self:StopEffects( false )

	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	-- local damage = self:GetSpecialValueFor( "polarity_damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local pos = caster:GetOrigin() + caster:GetForwardVector() * 150
	local auto_cast = 0
	if self:GetAutoCastState() then
		auto_cast = 1
		
	end
	local max = 10
	if self.unlock2 then
		max = 15
	end
	for i,enemy in pairs(enemies) do

		local origin = enemy:GetOrigin()
		FindClearSpaceForUnit( enemy, pos, true )
		enemy:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_debuff", { duration = duration,auto_cast=auto_cast })
		enemy:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_debuff2", { duration = duration*2 })


		self:PlayEffects2( enemy, origin )
		if i>=max then
			break
		end
	end
	local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
		hero:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_buff", { duration = duration*2 })
    end

	if self.advanced_level>=15 then
		for  _, hero in pairs(heroes) do
			local new_pos = pos + Vector(	RandomInt(-200, 200),RandomInt(-200, 200),0)
			local damage = hero:GetHealth()*0.1+hero:GetMana()*0.15
			Timers:CreateTimer(RandomFloat(0.1, 0.8), function()
				self:SummonSunStrike( new_pos,250,damage )
			end)
		end
		if self.advanced_level>=20 then
			for  _, hero in pairs(heroes) do
				local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				hero:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
				)
				local pos = hero:GetOrigin() + hero:GetForwardVector() * 150
				local count = 0
				for _,enemy in pairs(enemies) do

					if not enemy:HasModifier("modifier_Advanced_reverse_polarity_debuff") then
						local origin = enemy:GetOrigin()
						FindClearSpaceForUnit( enemy, pos, true )
						enemy:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_debuff", { duration = duration,auto_cast=auto_cast })
						enemy:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_debuff2", { duration = duration*2 })


						self:PlayEffects2( enemy, origin )
						count = count + 1
						if count>=4 then
							break
						end
					end
				end
			end
		end
	end


	if self.unlock1 then
		-- modifier_Advanced_reverse_polarity_unlock1
		caster:AddNewModifier(caster, self,"modifier_Advanced_reverse_polarity_unlock1", { duration = 22})
	end

	if self.unlock3 then
		local ability = caster:FindAbilityByName("Advanced_shockwave")
		if ability then
			for i = 1, 4, 1 do

				local new_start = RotatePosition(pos, QAngle(0, 90*i, 0), pos+caster:GetForwardVector()*radius)
				-- print(new_start)
				Timers:CreateTimer(RandomFloat(0.1, 0.8), function()
					if ability:IsNull() then
						return
					end
					ability:CreateShockWave(new_start,pos)
				end)
				
			end
			
		end
		
	end


	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Effects
function Advanced_reverse_polarity:PlayEffects1(target)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = self:GetSpecialValueFor( "radius" )
	local castpoint = self:GetCastPoint()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, target:GetForwardVector() )

	local info = {
		effect_cast = effect_cast,
		unit = target,
	}
	table.insert(self.effect_cast,info)
	-- self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function Advanced_reverse_polarity:StopEffects( interrupted )
	-- stop particle
	for _, info in ipairs(self.effect_cast) do
		ParticleManager:DestroyParticle( info.effect_cast, interrupted )
		ParticleManager:ReleaseParticleIndex( info.effect_cast )
		local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
		StopSoundOn( sound_cast, info.unit )
	end
	

	-- stop sound
	
end

function Advanced_reverse_polarity:PlayEffects2( target, origin )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end



function Advanced_reverse_polarity:SummonSunStrike( pos,radius,damage )

	local caster = self:GetCaster()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Charge"


	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle("particles/rebuild/spell/reverse_polarity_rebuild/reverse_polarity_rebuild_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 3, pos )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( radius, 0, 0 ) )
	DestroyParticleByDelay(effect_cast,3)

	EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
	Timers:CreateTimer(1.5, function()
		if not self or self:IsNull() then
			return
		end
		local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
		local sound_cast = "Hero_Invoker.SunStrike.Ignite"

		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( effect_cast, 0,pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(250, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos,
		nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER, false)
		local damageTable = {
			-- victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}
		for i, enemy in pairs(enemies) do
			damageTable.victim = enemy
			
			ApplyDamage(damageTable)  		
			if i>=5 then
				break
			end			
		end

	end)
	
end



modifier_Advanced_reverse_polarity_debuff = advanced_modifier({})

function modifier_Advanced_reverse_polarity_debuff:IsDebuff()			return true end
function modifier_Advanced_reverse_polarity_debuff:IsHidden() 			return false end
function modifier_Advanced_reverse_polarity_debuff:IsPurgable() 		return false end
function modifier_Advanced_reverse_polarity_debuff:IsPurgeException() 	return true end
function modifier_Advanced_reverse_polarity_debuff:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	} 

	return funcs
end
function modifier_Advanced_reverse_polarity_debuff:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_Advanced_reverse_polarity_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_reverse_polarity_debuff:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

function modifier_Advanced_reverse_polarity_debuff:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end
function modifier_Advanced_reverse_polarity_debuff:OnCreated(keys)
	self.bonus_armor =0
	self.magic_resistance =0
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if IsServer() then
		
		if keys.auto_cast==1 then
			self:SetStackCount(1)
		end
	end
	if self:GetStackCount()==1 then

		self.magic_resistance =-30
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
			self.magic_resistance = -45
		end
	else
		self.bonus_armor = -10
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
			self.bonus_armor = -15
		end
	end
end


function modifier_Advanced_reverse_polarity_debuff:GetModifierMagicalResistanceBonus(keys)
	return self.magic_resistance
end


function modifier_Advanced_reverse_polarity_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_damage
end

function modifier_Advanced_reverse_polarity_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end



function modifier_Advanced_reverse_polarity_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_Advanced_reverse_polarity_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end











modifier_Advanced_reverse_polarity_debuff2 = class({})

function modifier_Advanced_reverse_polarity_debuff2:IsDebuff()			return true end
function modifier_Advanced_reverse_polarity_debuff2:IsHidden() 			return true end
function modifier_Advanced_reverse_polarity_debuff2:IsPurgable() 		return false end
function modifier_Advanced_reverse_polarity_debuff2:IsPurgeException() 	return true end




modifier_Advanced_reverse_polarity_buff = advanced_modifier({})

function modifier_Advanced_reverse_polarity_buff:IsDebuff()			return false end
function modifier_Advanced_reverse_polarity_buff:IsHidden() 			return true end
function modifier_Advanced_reverse_polarity_buff:IsPurgable() 		return false end
function modifier_Advanced_reverse_polarity_buff:IsPurgeException() 	return false end
function modifier_Advanced_reverse_polarity_buff:OnCreated(keys)
	if IsServer() then
		self.bonus_damage = 200
		if self:GetAbility().advanced_level>=10 then
			self.bonus_damage = 250
		end
	end
end

function modifier_Advanced_reverse_polarity_buff:Advanced_GetModifierCriticalStrike(keys)
   if IsServer() and keys.target:HasModifier("modifier_Advanced_reverse_polarity_debuff2") then
		return self.bonus_damage
   end
end


-- advanced_modifier
function modifier_Advanced_reverse_polarity_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end



modifier_Advanced_reverse_polarity_unlock1 = class({})

function modifier_Advanced_reverse_polarity_unlock1:IsDebuff()			return false end
function modifier_Advanced_reverse_polarity_unlock1:IsHidden() 			return false end
function modifier_Advanced_reverse_polarity_unlock1:IsPurgable() 		return false end
function modifier_Advanced_reverse_polarity_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_reverse_polarity_unlock1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_reverse_polarity_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(3)
	end
end

function modifier_Advanced_reverse_polarity_unlock1:OnIntervalThink()
	local heroes = GetAllRealHeroes()
	local pos = self:GetParent():GetOrigin()
	local ability = self:GetAbility()
	for  _, hero in pairs(heroes) do
		local new_pos = pos + Vector(	RandomInt(-200, 200),RandomInt(-200, 200),0)
		local damage = hero:GetHealth()*0.1+hero:GetMana()*0.15
		Timers:CreateTimer(RandomFloat(0.1, 0.8), function()
			ability:SummonSunStrike( new_pos,250,damage )
		end)
	end
end
