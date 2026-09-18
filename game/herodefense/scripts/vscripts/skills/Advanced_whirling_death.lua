Advanced_whirling_death = class({})

LinkLuaModifier("modifier_Advanced_whirling_death", "skills/Advanced_whirling_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_whirling_death_buff", "skills/Advanced_whirling_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_whirling_death_unlock3_buff", "skills/Advanced_whirling_death", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
function Advanced_whirling_death:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Advanced_whirling_death:GetIntrinsicModifierName() return "modifier_Advanced_whirling_death" end

function Advanced_whirling_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_vahdrak/status_effect.vpcf", context )
end
function Advanced_whirling_death:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_whirling_death:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_whirling_death:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_whirling_death:OnSpellStart()
	-- local caster = self:GetCaster()
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_whirling_death")
	if modifier and modifier:GetStackCount()>=1 then
		modifier:StartIntervalThink(0.1)
	end
end

function Advanced_whirling_death:CheckKV(key)
	local table = {
		damage=3,
		bonus_damage=0.16,



	}

	local value = table[key] or -1
	return value

end
modifier_Advanced_whirling_death = class({})

function modifier_Advanced_whirling_death:IsDebuff()				return false end
function modifier_Advanced_whirling_death:IsPurgable() 			return false end
function modifier_Advanced_whirling_death:IsPurgeException() 	return false end
function modifier_Advanced_whirling_death:IsHidden()				return self:GetStackCount()<=0 end

function modifier_Advanced_whirling_death:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Advanced_whirling_death:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if parent:PassivesDisabled() or not ability:IsCooldownReady() or not parent:IsAlive() then
		return
	end
	if keys.target == parent then
		if parent:IsHexed() then
			return
		end
		local chance = ability:GetSpecialValueFor("chance")
		if ability.advanced_level>=20 then
			local modifier = caster:FindModifierByName("modifier_Advanced_whirling_death_buff")
			if modifier then
				local bonus_chance =math.min( modifier:GetStackCount()*0.3,9)
				chance = chance + bonus_chance
			end
			
		end
		if (caster:GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100)) then
			local max_stack = 10
			if ability.advanced_level>=10 then
				max_stack = 16
			end
			if ability.unlock1 then
				max_stack = 40
			end
			if self:GetStackCount()<max_stack then
				self:IncrementStackCount()
				if ability.unlock1 then
					self:SetStackCount(math.min(self:GetStackCount()+1,40))
				end
			else
				self:Trigger(keys.target)
			end
			ability:UseResources(true, true, true, true)

		end

	else
		if ability.advanced_level>=15 and not IsEnemy(keys.target,parent) then
			local chance = 5
			local unlock2 = false
			if ability.unlock2 then
				chance = 10
				unlock2 = true
			else
				if 400<CalculateDistance(parent,keys.target) then
					return
				end
			end
			if (self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100)) then
				local max_stack = 10
				if ability.advanced_level>=10 then
					max_stack = 16
				end
				if ability.unlock1 then
					max_stack = 40
				end
				if self:GetStackCount()<max_stack then
					self:IncrementStackCount()
					if ability.unlock1 then
						self:SetStackCount(math.min(self:GetStackCount()+1,40))
					end
				else
					if unlock2 then
						self:Trigger(keys.target)
					else
						self:Trigger(parent)
					end
					
				end
				ability:UseResources(true, true, true, true)

	
			end
		end
	end
end


function modifier_Advanced_whirling_death:OnIntervalThink()
	if self:GetStackCount()>=1 then
		self:Trigger(self:GetCaster())
		self:DecrementStackCount()
	else
		self:StartIntervalThink(-1)
	end

end

function modifier_Advanced_whirling_death:Trigger(attachUnit)
	local caster = self:GetCaster()

	local ability = self:GetAbility()
	-- load data
	local radius = ability:GetSpecialValueFor( "radius" )
	local damage = ability:GetSpecialValueFor( "damage" ) + caster:GetPhysicalArmorValue(false)* ability:GetSpecialValueFor( "bonus_damage" )
	if ability.unlock3 then
		damage = damage + caster:GetMaxHealth()*0.05
	end
	local gain =caster:GetModifierDurationGainIndex(1)
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		attachUnit:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local hit = false
	if ability.unlock3 then
		for i,enemy in pairs(enemies) do
			hit = true
			damageTable.victim = enemy
			local real_damage = ApplyDamage( damageTable )*0.01
			if real_damage>=1 then
				-- local gain =caster:GetModifierDurationGainIndex(1)
				caster:AddNewModifier(
					caster,
					ability,
					"modifier_Advanced_whirling_death_unlock3_buff", {duration=30*gain,stack=real_damage}
				)
			end
			if i>=6 then
				break
			end
		end
	else
		for i,enemy in pairs(enemies) do
			hit = true
			damageTable.victim = enemy
			ApplyDamage( damageTable )
			if i>=6 then
				break
			end
		end
	end


	-- Play effects
	self:PlayEffects( attachUnit,radius, hit )

	local duration = 13
	if ability.advanced_level>=5 then
		duration = 17
	end

	caster:AddNewModifier(
		caster,
		ability,
		"modifier_Advanced_whirling_death_buff",
		{	duration = duration*gain}
    )
end


function modifier_Advanced_whirling_death:PlayEffects( attachUnit,radius, hit )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf"
	local sound_cast = "Hero_Shredder.WhirlingDeath.Cast"
	local sound_target = "Hero_Shredder.WhirlingDeath.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, attachUnit )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		attachUnit,
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, attachUnit )
	if hit then
		EmitSoundOn( sound_target, attachUnit )
	end
end






modifier_Advanced_whirling_death_buff = advanced_modifier({})

function modifier_Advanced_whirling_death_buff:IsHidden()	return false end
function modifier_Advanced_whirling_death_buff:IsDebuff()	return false end
function modifier_Advanced_whirling_death_buff:IsPurgable()	return false end


function modifier_Advanced_whirling_death_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_whirling_death_buff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_whirling_death_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_whirling_death_buff:Advanced_GetModifierPhysicalArmorBonus()
    return 2*self:GetStackCount()
end





function modifier_Advanced_whirling_death_buff:OnCreated(params)
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
function modifier_Advanced_whirling_death_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		local max = 30
		if self:GetAbility().advanced_level>=5 then
			max = 40
		end
		if self:GetStackCount()>= max then
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

function modifier_Advanced_whirling_death_buff:OnIntervalThink()
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





modifier_Advanced_whirling_death_unlock3_buff = class({})

function modifier_Advanced_whirling_death_unlock3_buff:IsDebuff() return false end
function modifier_Advanced_whirling_death_unlock3_buff:IsHidden() return false end
function modifier_Advanced_whirling_death_unlock3_buff:IsPurgable() 		return false end
function modifier_Advanced_whirling_death_unlock3_buff:IsPurgeException() 	return false end
function modifier_Advanced_whirling_death_unlock3_buff:RemoveOnDeath()  return false end
-- function modifier_Advanced_whirling_death_unlock3_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf" end
function modifier_Advanced_whirling_death_unlock3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_Advanced_whirling_death_unlock3_buff:GetModifierHealthBonus( params )
	-- if self:GetParent():PassivesDisabled() then
	-- 	return 0
	-- end
	return math.min(self:GetStackCount(),20000)
end

function modifier_Advanced_whirling_death_unlock3_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_whirling_death_unlock3_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		-- if self:GetStackCount()>= 25000 then
		-- 	--移除第一个 添加一个
		-- 	self:SetStackCount(self:GetStackCount()-self.tData[1].stack)
		-- 	table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		-- 	self:SetStackCount( self:GetStackCount()+ keys.stack)


		-- else
		-- 	table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		-- 	self:SetStackCount( self:GetStackCount()+ keys.stack)
		-- end

		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
		

	end
end

function modifier_Advanced_whirling_death_unlock3_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end



