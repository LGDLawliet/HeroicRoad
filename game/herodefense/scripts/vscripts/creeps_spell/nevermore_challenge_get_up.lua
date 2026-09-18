LinkLuaModifier( "modifier_nevermore_challenge_get_up", "creeps_spell/nevermore_challenge_get_up", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_challenge_get_up_active", "creeps_spell/nevermore_challenge_get_up", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_challenge_get_up_after", "creeps_spell/nevermore_challenge_get_up", LUA_MODIFIER_MOTION_NONE )


require('internal/timers')
nevermore_challenge_get_up = class({})

function nevermore_challenge_get_up:GetIntrinsicModifierName()
	return "modifier_nevermore_challenge_get_up"
end

function nevermore_challenge_get_up:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/boss/fight/stack.vpcf", context )
end
---------------------------------------------------------------------

modifier_nevermore_challenge_get_up = advanced_modifier({})
function modifier_nevermore_challenge_get_up:IsDebuff() return false end
function modifier_nevermore_challenge_get_up:IsHidden() return true end
function modifier_nevermore_challenge_get_up:IsPurgable() return false end

function modifier_nevermore_challenge_get_up:OnCreated(params)
	if not IsServer() then
		return
	end

	self.time = self:GetAbility():GetSpecialValueFor("time")
	local heroes = GetAllRealHeroes()
	if #heroes >= 2 then
		self.trigger = true
	end
	if self.trigger then
		self:StartIntervalThink(1)
	end
end

function modifier_nevermore_challenge_get_up:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and self:GetCaster():GetHealthPercent() <= 50 then
		if _G.GAME_ROUND>=_G.GAME_END_WAVE then
			return
		end
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 100000,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false )

		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nevermore_challenge_get_up_active",{duration = self.time})
			break
		end
		self:GetAbility():UseResources(true, true, true, true)
	end
end

---------------------------------------------------------------------

modifier_nevermore_challenge_get_up_active = advanced_modifier({})
function modifier_nevermore_challenge_get_up_active:IsDebuff() return true end
function modifier_nevermore_challenge_get_up_active:IsHidden() return false end
function modifier_nevermore_challenge_get_up_active:IsPurgable() return false end
function modifier_nevermore_challenge_get_up_active:RemoveOnDeath() return true end

function modifier_nevermore_challenge_get_up_active:OnCreated(params)
	self.hp_damage = self:GetAbility():GetSpecialValueFor("hp_damage")*0.01
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.time = self:GetAbility():GetSpecialValueFor("time")

	if IsServer() then

		local parent = self:GetParent()
		self:SetStackCount(self.time)
		self.particle = ParticleManager:CreateParticle("particles/rebuild/boss/fight/stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
		ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self:GetStackCount(),0) )
		self:AddParticle(self.particle, false, false, -1, false, false)

		self.particle_2 = ParticleManager:CreateParticle("particles/rebuild/boss/fight/stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl( self.particle_2, 1, Vector(0,self:GetStackCount(),0) )
		self:AddParticle(self.particle_2, false, false, -1, false, false)


		self:StartIntervalThink(1)
	end
end

function modifier_nevermore_challenge_get_up_active:OnIntervalThink()
	self:SetStackCount(math.max(self:GetStackCount() - 1 ,0))
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0,self:GetStackCount(),0))
	ParticleManager:SetParticleControl(self.particle_2, 1, Vector(0,self:GetStackCount(),0))
	if self:GetStackCount() <= 0 then
		ParticleManager:DestroyParticle(self.particle,true)
		ParticleManager:DestroyParticle(self.particle_2,true)
	end
end

function modifier_nevermore_challenge_get_up_active:OnDestroy()
	if not IsServer() then
		return
	end
	if not self:GetCaster() then
		ParticleManager:DestroyParticle(self.particle,true)
		return
	end
	if not self:GetCaster():IsAlive() then
		ParticleManager:DestroyParticle(self.particle,true)
		return
	end
	self.hp_damage = self:GetAbility():GetSpecialValueFor("hp_damage")*0.01
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local pos = parent:GetAbsOrigin()

	local sound_cast = "Hero_Nevermore.RequiemOfSouls"
	local particle_caster_ground = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	EmitSoundOn(sound_cast, caster)

	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)


	local partners =  FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false )

	for _,partner in pairs(partners) do
		
		self.damageTable = {
			victim = partner,
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			hd_flags =  HD_DAMAGE_FLAG_NO_SPELL_CRIT,
		}

		if #partners >= 2 then
			self.hp_damage = self:GetAbility():GetSpecialValueFor("hp_damage")*0.01/#partners
			self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
		end

		local damage = partner:GetMaxHealth()*self.hp_damage
		self.damageTable.damage = damage
		print(self.hp_damage)
		print(damage)

		ApplyDamage(self.damageTable)
		local taoke = partner:FindModifierByName("modifier_Primary_borrowed_time_buff_hot_caster") or partner:FindModifierByName("modifier_Middle_borrowed_time_buff_hot_caster") or partner:FindModifierByName("modifier_Advanced_borrowed_time_buff_hot_caster")
					or partner:FindModifierByName("modifier_Primary_Refraction_buff_block") or partner:FindModifierByName("modifier_Middle_Refraction_buff_block") or partner:FindModifierByName("modifier_Advanced_Refraction_buff_block")
					or partner:IsInvulnerable()
		if not taoke and #partners >= 2 then
			partner:AddNewModifier(caster,ability,"modifier_nevermore_challenge_get_up_after",{duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end

	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle,true)
	end
end


---------------------------------------------------------------------

modifier_nevermore_challenge_get_up_after = advanced_modifier({})
function modifier_nevermore_challenge_get_up_after:IsDebuff() return false end
function modifier_nevermore_challenge_get_up_after:IsHidden() return false end
function modifier_nevermore_challenge_get_up_after:IsPurgable() return false end
function modifier_nevermore_challenge_get_up_after:RemoveOnDeath() return false end

function modifier_nevermore_challenge_get_up_after:OnCreated(keys)
	self.outgoing_after = self:GetAbility():GetSpecialValueFor("outgoing_after")
end

function modifier_nevermore_challenge_get_up_after:OnRefresh(keys)
	self:SetStackCount(math.min(self:GetStackCount()+1 , 100))
end

function modifier_nevermore_challenge_get_up_after:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function modifier_nevermore_challenge_get_up_after:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return 0
	end
	if keys.target == self:GetCaster() then
		return self.outgoing_after * self:GetStackCount()
	end
	return 0
end

function modifier_nevermore_challenge_get_up_after:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_nevermore_challenge_get_up_after:OnTooltip()
	return self.outgoing_after * self:GetStackCount()
end