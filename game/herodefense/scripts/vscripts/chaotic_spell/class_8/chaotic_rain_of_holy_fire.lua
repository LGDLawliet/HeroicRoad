LinkLuaModifier("modifier_chaotic_rain_of_holy_fire_thinker", "chaotic_spell/class_8/chaotic_rain_of_holy_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_rain_of_holy_fire_rune_2_buff", "chaotic_spell/class_8/chaotic_rain_of_holy_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_rain_of_holy_fire_immune", "chaotic_spell/class_8/chaotic_rain_of_holy_fire", LUA_MODIFIER_MOTION_NONE)
chaotic_rain_of_holy_fire = class({})

function chaotic_rain_of_holy_fire:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/effct_ground/effectunits/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/effct_death/effect_idle_throw.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/rune_1_blast/effect_explosion.vpcf", context )

	
end


function chaotic_rain_of_holy_fire:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_rain_of_holy_fire:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_chaotic_rain_of_holy_fire_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
	if self:GetRuneType()==2 then
		caster:AddNewModifier(caster, self, "modifier_chaotic_rain_of_holy_fire_rune_2_buff", {duration =self:GetSpecialValueFor("duration")})
	end
end


modifier_chaotic_rain_of_holy_fire_thinker = advanced_modifier({})

function modifier_chaotic_rain_of_holy_fire_thinker:IsAura()return true end
function modifier_chaotic_rain_of_holy_fire_thinker:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		self.immune_duration = ability:GetSpecialValueFor("immune_duration")
		self.radius = ability:GetSpecialValueFor("radius")
		self.health_require = ability:GetSpecialValueFor("health_require")
		self.gain = ability:GetEffectGain()
		self.interval = ability:GetSpecialValueFor("damage_interval")

		if ability:GetRuneType()==3 then
			self.rune_3_chance = ability:GetSpecialValueFor("rune_3_chance")
			self.rune_3_radius = ability:GetSpecialValueFor("rune_3_radius")*0.01
			self.interval = self.interval - ability:GetSpecialValueFor("rune_3_interval")
			if self.rune_3_chance >= math.random(1,100) then
				self.radius = self.radius*(1+self.rune_3_radius)
			end
		end

		parent:EmitSound("Hero_Oracle.RainOfDestiny.Cast")
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/effct_ground/effectunits/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,1,1))
		self:AddParticle(self.particle, false, false, -1, false, false)

		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_rain_of_holy_fire_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_rain_of_holy_fire_thinker:OnIntervalThink(index)
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
		return
	end

	local parent = self:GetParent()
	local caster = self:GetCaster()
	local center = parent:GetAbsOrigin()

	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
	if index then
		damage = damage * index
	end
	local damageTable = {
		-- victim = self:GetParent(),
		attacker = caster,
		damage = damage*self.gain,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}

	for _, unit in ipairs(enemies) do

		if IsEnemy(unit, caster) then
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if IsValid(unit) and unit:IsAlive() then
				unit:Purge(true, false, false, false, false)
				if unit:GetHealthPercent()<=self.health_require then
					self:PlayEffect(unit)
					TrueKill(caster,unit,ability)
				end
			end
		else
			unit:AddNewModifier(caster, ability, "modifier_chaotic_rain_of_holy_fire_immune", {duration = self.immune_duration})
		end
	end

	if ability:GetRuneType()==1 then
		local chance = ability:GetSpecialValueFor("rune_1_chance")
		local index = 0
		for _, unit in ipairs(enemies) do

			if not IsValid(unit) or not unit:IsAlive() then
				if caster:RollRandom(chance,1)  then
					index = index + 1
					if IsValid(unit) and not unit:IsAlive() then
						self:PlayEffect_rune1(unit)
					end
				end
	
			end
		end
		if index>=1 then
			
			caster:GameTimer(0.1,function()
				if IsValid(self) then
					self:OnIntervalThink(index)
				end
				
			end)
		end
	end
end


function modifier_chaotic_rain_of_holy_fire_thinker:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/effct_death/effect_idle_throw.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(effect_cast1,4)
	target:EmitSound("Hero_Oracle.PreAttack")
end



function modifier_chaotic_rain_of_holy_fire_thinker:PlayEffect_rune1(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/chaotic_rain_of_holy_fire/rune_1_blast/effect_explosion.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(effect_cast1,4)
	target:EmitSound("Hero_Oracle.PreAttack")
end




modifier_chaotic_rain_of_holy_fire_immune = advanced_modifier({})

function modifier_chaotic_rain_of_holy_fire_immune:IsHidden() return false end
function modifier_chaotic_rain_of_holy_fire_immune:IsPurgable() return false end
function modifier_chaotic_rain_of_holy_fire_immune:IsDebuff() return false end
function modifier_chaotic_rain_of_holy_fire_immune:CheckState()
    return 
    {	
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end



-------------

modifier_chaotic_rain_of_holy_fire_rune_2_buff = advanced_modifier({})

function modifier_chaotic_rain_of_holy_fire_rune_2_buff:IsHidden() return false end
function modifier_chaotic_rain_of_holy_fire_rune_2_buff:IsPurgable() return false end
function modifier_chaotic_rain_of_holy_fire_rune_2_buff:IsDebuff() return false end

function modifier_chaotic_rain_of_holy_fire_rune_2_buff:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("rune_2_bonus")
end

function modifier_chaotic_rain_of_holy_fire_rune_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_rain_of_holy_fire_rune_2_buff:OnTooltip() return self.bonus_damage end
function modifier_chaotic_rain_of_holy_fire_rune_2_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if IsServer() and DamageFilter(keys.record,HD_DAMAGE_FLAG_HOLY_DAMAGE) then
		if not self:GetAbility() then self:Destroy() return end
		return self.bonus_damage
	end
	return 0
end

function modifier_chaotic_rain_of_holy_fire_rune_2_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end









