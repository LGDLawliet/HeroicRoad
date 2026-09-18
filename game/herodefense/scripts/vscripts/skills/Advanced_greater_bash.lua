Advanced_greater_bash = class({})
LinkLuaModifier( "modifier_Advanced_greater_bash_buff", "skills/Advanced_greater_bash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_greater_bash_active", "skills/Advanced_greater_bash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_greater_bash_cooldown", "skills/Advanced_greater_bash", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_greater_bash_unlock1_buff", "skills/Advanced_greater_bash", LUA_MODIFIER_MOTION_NONE )
function Advanced_greater_bash:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context )

	
end

function Advanced_greater_bash:CheckKV(key)
	local table = {

	
		bonus_damage =2,


	}
	local value = table[key] or -1
	return value

end

function Advanced_greater_bash:UnlockFirstCore(key)
	return true
end
function Advanced_greater_bash:UnlockSecondCore(key)
	return true
end
function Advanced_greater_bash:UnlockThirdCore(key)
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_greater_bash_buff")
	if modifier then
		modifier:StartIntervalThink(0.06)
	end
	return true
end

function Advanced_greater_bash:GetIntrinsicModifierName()
	return "modifier_Advanced_greater_bash_buff"
end

function Advanced_greater_bash:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")

	if advanced_level>=20 then
		if self:GetUnlock(3)==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else 
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end
function Advanced_greater_bash:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	if self:GetCaster():HasModifier("modifier_Advanced_greater_bash_cooldown")  then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Advanced_greater_bash:GetCustomCastError()
	if IsClient() then
		return
	end


	return "#DOTA_HUB_CANT_CAST"
end

function Advanced_greater_bash:OnSpellStart()

	local caster = self:GetCaster()
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_greater_bash_active", -- modifier name
		{ duration =5} -- kv
	)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_greater_bash_cooldown", -- modifier name
		{ duration =30} -- kv
	)

	
end



modifier_Advanced_greater_bash_buff = modifier_Advanced_greater_bash_buff or class({})
function modifier_Advanced_greater_bash_buff:IsHidden()	return true end
function modifier_Advanced_greater_bash_buff:IsPurgable()	return false end

function modifier_Advanced_greater_bash_buff:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) 
	-- self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )

	if IsServer() then
		self.parent = self:GetParent()
        self.currentPos = self.parent:GetAbsOrigin()
	end
end

function modifier_Advanced_greater_bash_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_greater_bash_buff:OnDestroy( kv )

end


function modifier_Advanced_greater_bash_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_Advanced_greater_bash_buff:GetModifierProcAttack_BonusDamage_Physical( keys )
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock3 then
			return
		end
		return self:BashEffect(keys)
	

	end
end


function modifier_Advanced_greater_bash_buff:BashEffect(keys)
	local caster = self:GetCaster()
		if caster:PassivesDisabled() or not caster:IsApplyModifier() then
			return
		end
		local ability = self:GetAbility()
		local level = ability:GetSpecialValueFor("advanced_level")
		local lv20Active = false
		if caster:HasModifier("modifier_Advanced_greater_bash_active") then
			lv20Active = true
		end
		if lv20Active or ability:IsCooldownReady() then 
			local chance = self.proc_chance
			if lv20Active then
				chance = chance + 10
			end

			if ability.unlock3 or self:GetCaster():RollRandom(chance,1)  then
				if not lv20Active and not ability.unlock3 then
					ability:UseResources(true, true, true, true)
				end
				
	
				local pos = caster:GetOrigin()
				local knockBack_kv = 
				{
					center_x = pos.x,
					center_y = pos.y,
					center_z = pos.z,
					duration = math.min(self.duration*caster:HDGetDebuffDurationGain(),0.1),
					should_stun = true, 
					knockback_duration = self.knockback_duration,
					knockback_distance = self.knockback_distance,
					knockback_height = self.knockback_height,
				}
				keys.target:AddNewModifier( caster, ability, "modifier_knockback", knockBack_kv )
				if ability.unlock1 then
					caster:AddNewModifier( caster, ability, "modifier_Advanced_greater_bash_unlock1_buff", {} )
				end
				local critical =false
				if self:GetCaster():RollRandom(35,1)  then
					critical = true
				end
				if not critical and level>=10 then
					if caster:GetIdealSpeed()>=550 and keys.target:GetIdealSpeed()>=550 then
						critical = true
					end
				end
				self:PlayEffects( keys.target ,critical)
	
				local bonus = ability:GetSpecialValueFor( "bonus_damage" )*0.01
				local index = 0.5
				if level>=5 then
					index = 0.75
				end
				local damage = caster:GetIdealSpeed() * bonus + keys.target:GetIdealSpeed() * bonus*index
				if critical then
					damage = damage * 2
					if ability.unlock2 then
						self:Unlock2Effect(keys.target,damage)
					end
				end
				if  ability.unlock3 then
					damage = damage * 2
				end

				return damage
			end
		else
			if self:GetCaster():RollRandom(self.proc_chance,1)  then
				local critical =false
				if self:GetCaster():RollRandom(35,1)  then
					critical = true
				end
				if not critical and level>=10 then
					if caster:GetIdealSpeed()>=550 and keys.target:GetIdealSpeed()>=550 then
						critical = true
					end
				end
				self:PlayEffects( keys.target ,critical)
	
				local bonus = ability:GetSpecialValueFor( "bonus_damage" )*0.01
				local index = 0.5
				if level>=5 then
					index = 0.75
				end
				local damage = caster:GetIdealSpeed() * bonus + keys.target:GetIdealSpeed() * bonus*index
				if critical then
					damage = damage * 2
					if ability.unlock2 then
						self:Unlock2Effect(keys.target,damage*0.6)
					end
				end
				return damage*0.6
			end 
		end
end

function modifier_Advanced_greater_bash_buff:OnIntervalThink()
  

	local dis = CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    if dis>=300 then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")
	
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_magnet_redirect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
		DestroyParticleByDelay(particle,2)
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.currentPos,nil, 200,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE)
		local damageTable = {
			-- victim = target,
			-- damage = caster:HDGetPrimaryStatValue()*6,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			attacker = caster,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		local keys = {}

		for i, enemy in pairs(tTargets) do
			keys.target = enemy
			local damage = self:BashEffect(keys)
			damageTable.damage =damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
    end
	self.currentPos = self.parent:GetAbsOrigin()
end







function modifier_Advanced_greater_bash_buff:Unlock2Effect(target,damage)
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	local damage = damage*3

	local damageTable = {
	   attacker = caster,
	   damage = damage,
	   damage_type = DAMAGE_TYPE_PHYSICAL,
	   damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
	   ability = self:GetAbility(), --Optional.
	   }
	for _, enemy in pairs(enemies) do
		if enemy~=target then
			self:PlayEffects( enemy ,true)
			damageTable.victim = enemy
			ApplyDamage(damageTable)	
			
		end
	end

end




function modifier_Advanced_greater_bash_buff:PlayEffects( target ,critical)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
	if critical then
		particle_cast = "particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf"
	end
	local sound_cast = "Hero_Spirit_Breaker.GreaterBash"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward(effect_cast, 1, self:GetParent():GetForwardVector())
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end








modifier_Advanced_greater_bash_active = modifier_Advanced_greater_bash_active or class({})
function modifier_Advanced_greater_bash_active:IsHidden()	return false end
function modifier_Advanced_greater_bash_active:IsDebuff()	return false end
function modifier_Advanced_greater_bash_active:IsPurgable()	return true end
function modifier_Advanced_greater_bash_active:IsPurgeException() return true end
function modifier_Advanced_greater_bash_active:RemoveOnDeath() return true end
function modifier_Advanced_greater_bash_active:GetEffectName()	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf" end
function modifier_Advanced_greater_bash_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end





modifier_Advanced_greater_bash_cooldown = modifier_Advanced_greater_bash_cooldown or class({})
function modifier_Advanced_greater_bash_cooldown:IsHidden()	return false end
function modifier_Advanced_greater_bash_cooldown:IsDebuff()	return false end
function modifier_Advanced_greater_bash_cooldown:IsPurgable()	return false end
function modifier_Advanced_greater_bash_cooldown:IsPurgeException() return false end
function modifier_Advanced_greater_bash_cooldown:RemoveOnDeath() return false end




modifier_Advanced_greater_bash_unlock1_buff = modifier_Advanced_greater_bash_unlock1_buff or class({})
function modifier_Advanced_greater_bash_unlock1_buff:IsHidden()	return false end
function modifier_Advanced_greater_bash_unlock1_buff:IsDebuff()	return false end
function modifier_Advanced_greater_bash_unlock1_buff:IsPurgable()	return false end
function modifier_Advanced_greater_bash_unlock1_buff:IsPurgeException() return false end
function modifier_Advanced_greater_bash_unlock1_buff:RemoveOnDeath() return false end
function modifier_Advanced_greater_bash_unlock1_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(math.min(4000,self:GetStackCount()+3))
	end
end

function modifier_Advanced_greater_bash_unlock1_buff:OnRefresh(keys)
	if IsServer() then
		self:OnCreated(keys)
	end
end


function modifier_Advanced_greater_bash_unlock1_buff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度

		

	}
end


function modifier_Advanced_greater_bash_unlock1_buff:GetModifierMoveSpeedBonus_Constant()	return self:GetStackCount() end