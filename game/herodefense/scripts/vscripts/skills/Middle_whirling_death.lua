Middle_whirling_death = class({})

LinkLuaModifier("modifier_Middle_whirling_death", "skills/Middle_whirling_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_whirling_death_buff", "skills/Middle_whirling_death", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
function Middle_whirling_death:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Middle_whirling_death:GetIntrinsicModifierName() return "modifier_Middle_whirling_death" end

function Middle_whirling_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_vahdrak/status_effect.vpcf", context )
end




modifier_Middle_whirling_death = class({})

function modifier_Middle_whirling_death:IsDebuff()				return false end
function modifier_Middle_whirling_death:IsPurgable() 			return false end
function modifier_Middle_whirling_death:IsPurgeException() 	return false end
function modifier_Middle_whirling_death:IsHidden()				return true end

function modifier_Middle_whirling_death:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Middle_whirling_death:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() or not self:GetAbility():IsCooldownReady() or not self:GetParent():IsAlive() then
		return
	end
	if keys.target == self:GetParent() then
		if self:GetParent():IsHexed() then
			return
		end
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		if (self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100)) then
			self:Trigger(keys.target)
			self:GetAbility():UseResources(true, true, true,true)
		end
	end
end


function modifier_Middle_whirling_death:Trigger(attachUnit)
	local caster = self:GetCaster()

	local ability = self:GetAbility()
	-- load data
	local radius = ability:GetSpecialValueFor( "radius" )
	local damage = ability:GetSpecialValueFor( "damage" ) + caster:GetPhysicalArmorValue(false)* ability:GetSpecialValueFor( "bonus_damage" )

	
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
	for i,enemy in pairs(enemies) do
		hit = true
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		if i>=6 then
			break
		end
	end

	-- Play effects
	self:PlayEffects( attachUnit,radius, hit )

	local gain =caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(
		caster,
		ability,
		"modifier_Middle_whirling_death_buff",
		{	duration = 13*gain}
    )
end


function modifier_Middle_whirling_death:PlayEffects( attachUnit,radius, hit )
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






modifier_Middle_whirling_death_buff = advanced_modifier({})

function modifier_Middle_whirling_death_buff:IsHidden()	return false end
function modifier_Middle_whirling_death_buff:IsDebuff()	return false end
function modifier_Middle_whirling_death_buff:IsPurgable()	return false end

function modifier_Middle_whirling_death_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Middle_whirling_death_buff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Middle_whirling_death_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Middle_whirling_death_buff:Advanced_GetModifierPhysicalArmorBonus()
    return 2*self:GetStackCount()
end



function modifier_Middle_whirling_death_buff:OnCreated(params)
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
function modifier_Middle_whirling_death_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 30 then
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

function modifier_Middle_whirling_death_buff:OnIntervalThink()
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


