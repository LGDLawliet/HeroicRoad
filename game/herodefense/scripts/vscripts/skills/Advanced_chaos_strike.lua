--特效优化 √
Advanced_chaos_strike = class({})
LinkLuaModifier( "modifier_Advanced_chaos_strike", "skills/Advanced_chaos_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_chaos_strike_buff", "skills/Advanced_chaos_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_chaos_strike_unlock3", "skills/Advanced_chaos_strike", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Passive Modifier
function Advanced_chaos_strike:GetIntrinsicModifierName()
	return "modifier_Advanced_chaos_strike"
end
function Advanced_chaos_strike:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_chaos_strike:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_chaos_strike:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_shapeshift_unloock3",{})
	return true

end
function Advanced_chaos_strike:CheckKV(key)
	local table = {
		crit_damage_min = 2,
		crit_damage_max = 4,






	}
	if self.unlock3_modifier and not self.unlock3_modifier:IsNull() then
		table.crit_damage_max = 4 + self.unlock3_modifier:GetStackCount()*0.2
	end
	local value = table[key] or -1
	return value

end
function Advanced_chaos_strike:SetModifier(modifier)
	self.unlock3_modifier =modifier
end
function Advanced_chaos_strike:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf", context )

	PrecacheResource( "particle", "particles/rebuild/spell/chaos_crit/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaos_crit/unlock1/effect.vpcf", context )



	
end

modifier_Advanced_chaos_strike = advanced_modifier({})


function modifier_Advanced_chaos_strike:IsHidden()	return true end
function modifier_Advanced_chaos_strike:IsPurgable()	return false end
function modifier_Advanced_chaos_strike:IsPurgeException() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_chaos_strike:OnCreated( kv )
	-- references
	if IsServer() then
		local ability = self:GetAbility()
		self.crit_chance = ability:GetSpecialValueFor( "crit_chance" )
		self.crit_damage_min = ability:GetSpecialValueFor( "crit_damage_min" )
		self.crit_damage_max = ability:GetSpecialValueFor( "crit_damage_max" )
		self.lifesteal = ability:GetSpecialValueFor( "lifesteal" )
		self.bonus_min = -5
		self.bonus_max = 15
		self.index = 0.1
		self.current_bonus = 0
		self.record = {}
		self:StartIntervalThink(2)
	end


end
function modifier_Advanced_chaos_strike:OnIntervalThink()
	local ability = self:GetAbility()
	self.crit_chance = ability:GetSpecialValueFor( "crit_chance" )
	self.crit_damage_min = ability:GetSpecialValueFor( "crit_damage_min" )
	self.crit_damage_max = ability:GetSpecialValueFor( "crit_damage_max" )
	self.lifesteal = ability:GetSpecialValueFor( "lifesteal" )
	if ability.advanced_level>=5 then
		self.bonus_min = -5
		self.bonus_max = 25
		if ability.advanced_level>=10 then
			self.index = 0.15
			if ability.advanced_level>=15 then
				self:SetStackCount(RandomInt(5, 15))

			end
		end
	end
	if ability.advanced_level>=25 then
		self:StartIntervalThink(-1)
	end
end


function modifier_Advanced_chaos_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function modifier_Advanced_chaos_strike:OnTakeDamage( params )
	if IsServer() then
		-- filter
	
		local ability = self:GetAbility()
		if params.inflictor==ability then
			return
		end
		local parent = self:GetParent()
		if parent==params.attacker then
			local pass = false
			if self.record[params.record] then
				pass = true
				self.record[params.record]= nil
			end
			-- logic
			if pass then
				-- get heal value
				if params.damage<=0 then
					return
				end
				
				if ability.unlock2 then
					self:Unlock2Effect( params.unit ,params.damage)
				elseif ability.unlock1 then
					self:Unlock1Effect(  params.unit ,params.damage)
				elseif ability.unlock3 then
					parent:AddNewModifier(parent, ability, "modifier_Advanced_chaos_strike_unlock3", {duration =35})
					
				end
				local heal = params.damage * self.lifesteal/100


				local gain = parent:GetModifierLifeStealGain(1)
				local flLifesteal =heal*gain
				parent:Heal( flLifesteal,ability )
				self:PlayEffects( params.unit )
	
				local bonus = math.min(1000,math.floor(params.damage*self.index))
				local modifier = parent:AddNewModifier(parent, ability, "modifier_Advanced_chaos_strike_buff", {duration =10})
				if modifier then
					modifier:SetStackCount(bonus)
				end
			else
				--销毁混沌裁决
				local modifier = parent:FindModifierByName("modifier_Advanced_chaos_strike_buff")
				if modifier then
					modifier:SafeDestroy()
				end

			end
		end


	end
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_chaos_strike:PlayEffects( target )
	-- get resource
	local sound_cast = "Hero_ChaosKnight.ChaosStrike"
	local pfx_name = "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_Advanced_chaos_strike:Unlock2Effect( target ,damage)
	if self.unlock2_timer and self.unlock2_timer>=GameRules:GetGameTime() then
		return
	end
	self.unlock2_timer =  GameRules:GetGameTime() +0.3
	local pfx_name = "particles/rebuild/spell/chaos_crit/unlock2/effect.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

   	local damageTable = {
	   attacker = self:GetParent(),
	   damage = damage*2,
	   damage_type = DAMAGE_TYPE_PHYSICAL,
	   damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
	   ability = self:GetAbility(), --Optional.
	}
	for _, enemy in pairs(enemies) do
		if target~=enemies then
			damageTable.victim = enemy
			ApplyDamage(damageTable)	
		end

	end


end


function modifier_Advanced_chaos_strike:Unlock1Effect( target ,damage)
	if self:GetCaster():GetRandomEffect(40,INT_TYPE,1)  >= RandomInt(1, 100) then
		Timers:CreateTimer(0.5, function()
			if target and not target:IsNull() and target:IsAlive() then
				local sound_cast = "Hero_ChaosKnight.ChaosStrike"
				local pfx_name = "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf"
				local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
				ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
				EmitSoundOn( sound_cast, self:GetParent() )
			
			
	
				local pfx_name = "particles/rebuild/spell/chaos_crit/unlock1/effect.vpcf"
				local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex(pfx)
				local damageTable = {
				victim = target,
				   attacker = self:GetParent(),
				   damage = damage,
				   damage_type = DAMAGE_TYPE_PHYSICAL,
				   damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				   ability = self:GetAbility(), --Optional.
				}
				ApplyDamage(damageTable)	
			end
		end)
	end
	



end

-- advanced_modifier
function modifier_Advanced_chaos_strike:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
		advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
function modifier_Advanced_chaos_strike:Advanced_GetModifier_RandomEffectGain(keys)
	return self:GetStackCount()
end


function modifier_Advanced_chaos_strike:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		--混沌系统
		local bonus =  RandomInt(self.bonus_min,self.bonus_max )

		local chance = self.crit_chance
		local damage = RandomInt(self.crit_damage_min, self.crit_damage_max)

		if self:GetAbility().advanced_level >= 20 then
			
			if self.current_bonus>1 and bonus>1 and (self.current_bonus%bonus==0 or bonus%self.current_bonus==0 )then
				chance = chance + 100
				damage = damage *2

			else
				chance = chance + bonus
			end
		end
		
		self.current_bonus = bonus

		local talent4 = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_chaos_knight_4")
		if talent4 then
			chance = chance +talent4:GetBonusChance()
			if chance>=RandomInt(1, 100) then
				talent4:ReSetStack()
				self.record[keys.record] = true
				local ability = self:GetCaster():FindAbilityByName("Advanced_Luminosity")
				if ability and ability.unlock2 then
					damage =damage * 1.3
				end
				damage = damage * RandomInt(talent4:GetSpecialValueFor("min_damage"), talent4:GetSpecialValueFor("max_damage"))*0.01
	
				return damage
			else
				talent4:InCreaseModifierStack()
			end
		else
			if chance>=RandomInt(1, 100) then
				self.record[keys.record] = true
				-- local damage = RandomInt(self.crit_damage_min, self.crit_damage_max)
				local ability = self:GetCaster():FindAbilityByName("Advanced_Luminosity")
				if ability and ability.unlock2 then
					damage =damage * 1.3
				end
				return damage
			end

		end

	end
end


modifier_Advanced_chaos_strike_buff = class({})

function modifier_Advanced_chaos_strike_buff:IsDebuff() return false end
function modifier_Advanced_chaos_strike_buff:IsHidden() return false end
function modifier_Advanced_chaos_strike_buff:IsPurgable() return false end
function modifier_Advanced_chaos_strike_buff:IsPurgeException() return true end
function modifier_Advanced_chaos_strike_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力,
	}
end

function modifier_Advanced_chaos_strike_buff:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end
-- modifier_Advanced_chaos_strike_unlock3





modifier_Advanced_chaos_strike_unlock3 = class({})

function modifier_Advanced_chaos_strike_unlock3:IsHidden()	return false end
function modifier_Advanced_chaos_strike_unlock3:IsDebuff()	return false end
function modifier_Advanced_chaos_strike_unlock3:IsPurgable()	return false end
function modifier_Advanced_chaos_strike_unlock3:OnCreated(params)
	self.ability = self:GetAbility()
	self.ability:SetModifier(self)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_chaos_strike_unlock3:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_chaos_strike_unlock3:OnIntervalThink()
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


