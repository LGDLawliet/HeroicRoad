Middle_unleash = class({})
LinkLuaModifier( "modifier_Middle_unleash", "skills/Middle_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_unleash_animation", "skills/Middle_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_unleash_fury", "skills/Middle_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_unleash_debuff", "skills/Middle_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_unleash_recovery", "skills/Middle_unleash", LUA_MODIFIER_MOTION_NONE )


function Middle_unleash:OnSpellStart()
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor( "duration" )*gain
	caster:Purge( false, true, false, false, false )  --弱驱散
	
	caster:AddNewModifier(caster, self, "modifier_Middle_unleash",{ duration = duration } )

end

modifier_Middle_unleash = class({})


function modifier_Middle_unleash:IsHidden()	return false end
function modifier_Middle_unleash:IsDebuff()	return false end
function modifier_Middle_unleash:IsPurgable()	return false end


function modifier_Middle_unleash:OnCreated( kv )
	self.parent = self:GetParent()

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )

	if not IsServer() then return end


	self.parent:AddNewModifier(	self.parent,self:GetAbility(),"modifier_Middle_unleash_fury",{}	)
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )

end

function modifier_Middle_unleash:OnRefresh( kv )

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )	
	if not IsServer() then return end
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_Middle_unleash:OnDestroy()
	if not IsServer() then return end

	local modifier = self.parent:FindModifierByNameAndCaster( "modifier_Middle_unleash_fury", self.parent )
	if modifier then
		modifier:ForceDestroy()
	end

	local modifier = self.parent:FindModifierByNameAndCaster( "modifier_Middle_unleash_recovery", self.parent )
	if modifier then
		modifier:ForceDestroy()
	end


end


function modifier_Middle_unleash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_Middle_unleash:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_ms end


modifier_Middle_unleash_fury = class({})


function modifier_Middle_unleash_fury:IsHidden()	return false end
function modifier_Middle_unleash_fury:IsDebuff()	return false end
function modifier_Middle_unleash_fury:IsPurgable()	return false end


function modifier_Middle_unleash_fury:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_as = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.recovery = self:GetAbility():GetSpecialValueFor( "attack_interval" )
	self.charges = self:GetAbility():GetSpecialValueFor( "charges_per_flurry" )
	self.timer = self:GetAbility():GetSpecialValueFor( "max_time_window_per_hit" )

	self.radius = self:GetAbility():GetSpecialValueFor( "pulse_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "pulse_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "pulse_debuff_duration" )
	self.attack_count = 0
	if not IsServer() then return end

	self.counter = self.charges
	self:SetStackCount( self.counter )
	

	self.success = 0

	-- create anmiation modifier
	self.animation = self.parent:AddNewModifier(self.parent,self.ability, "modifier_Middle_unleash_animation", {}	)

	self:PlayEffects1()
	self:PlayEffects2( self.parent, self.counter )

end



function modifier_Middle_unleash_fury:OnRemoved()
end

function modifier_Middle_unleash_fury:OnDestroy()
	if not IsServer() then return end


	if not self.animation:IsNull() then
		self.animation:SafeDestroy()
	end

	local main = self.parent:FindModifierByNameAndCaster( "modifier_Middle_unleash", self.parent )
	if not main then return end


	if self.forced then return end
	local recovery = self.recovery
	if self.parent:HasAbility("heroTalent_npc_dota_hero_marci_2") and self.parent:GetRandomEffect(50,INT_TYPE,1)  > RandomInt(1, 100) then
		recovery = 0.03
	end
	self.parent:AddNewModifier(	self.parent, 	self.ability,"modifier_Middle_unleash_recovery", {duration = recovery,success = self.success,} )

	if self.success~=1 then return end
end


function modifier_Middle_unleash_fury:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end



function modifier_Middle_unleash_fury:OnAttack( params )
	if params.attacker~=self.parent then
		return
	end
	if self.parent:IsInSpecialAttack() then
		return
	end
	self:StartIntervalThink( self.timer )
	self.counter = self.counter - 1
	self:SetStackCount( self.counter )
	self:EditEffects2( self.counter )
	self:PlayEffects3( self.parent, params.target )
	self.attack_count = self.attack_count +1

	if self.counter<=0 then
		self.success = 1
		self:Pulse( params.target:GetOrigin() )
		self:SafeDestroy()
	else
		if self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
			self.counter = self.counter + 1
			self:SetStackCount( self.counter )
		end
	end

end

function modifier_Middle_unleash_fury:GetModifierAttackSpeedBonus_Constant()	return self.bonus_as+200*self.attack_count end

function modifier_Middle_unleash_fury:GetActivityTranslationModifiers()
	if self:GetStackCount()==1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount()%2==0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end


function modifier_Middle_unleash_fury:OnIntervalThink()
	self:SafeDestroy()
end


function modifier_Middle_unleash_fury:Pulse( center )

	local enemies = FindUnitsInRadius(	self.parent:GetTeamNumber(),center,	nil,	self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE ,
		FIND_ANY_ORDER ,
		false	
	)


	local damageTable = {
		attacker = self.parent,
		damage = self.damage*self.parent:GetDamageMax(),
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
	}

	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)


		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(self.parent, self.ability, "modifier_Middle_unleash_debuff", { duration = self.duration*StatusResistance })
	end


	self:PlayEffects4( center, self.radius )
end

function modifier_Middle_unleash_fury:ForceDestroy()
	self.forced = true
	self:SafeDestroy()
end


function modifier_Middle_unleash_fury:PlayEffects1()

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Charged"
	local sound_cast2 = "Hero_Marci.Unleash.Charged.2D"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_l",Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt(effect_cast,2,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_r",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,3,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,4,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,5,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt(effect_cast,6,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	self:AddParticle(effect_cast,false, false, -1, false, false )
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_cast2, self:GetParent() )
end

function modifier_Middle_unleash_fury:PlayEffects2( caster, counter )

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, counter, 0 ) )
	self:AddParticle(effect_cast,false, false, -1, false, false )
	self.effect_cast = effect_cast
end

function modifier_Middle_unleash_fury:EditEffects2( counter )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, counter, 0 ) )
end

function modifier_Middle_unleash_fury:PlayEffects3( caster, target )
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	DestroyParticleByDelayButNotImmediately(effect_cast,2)
end

function modifier_Middle_unleash_fury:PlayEffects4( point, radius )

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Pulse"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,radius,radius) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetParent() )
end



modifier_Middle_unleash_debuff = class({})

function modifier_Middle_unleash_debuff:IsHidden()	return false end
function modifier_Middle_unleash_debuff:IsDebuff()	return true end
function modifier_Middle_unleash_debuff:IsPurgable()	return true end

function modifier_Middle_unleash_debuff:OnCreated( kv )
	self.as_slow = -self:GetAbility():GetSpecialValueFor( "pulse_attack_slow_pct" )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor( "pulse_move_slow_pct" )

	if not IsServer() then return end
end

function modifier_Middle_unleash_debuff:OnRefresh( kv )	self:OnCreated( kv ) end
function modifier_Middle_unleash_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Middle_unleash_debuff:GetModifierAttackSpeedBonus_Constant()	return self.as_slow end
function modifier_Middle_unleash_debuff:GetModifierMoveSpeedBonus_Constant()	return self.ms_slow end
function modifier_Middle_unleash_debuff:GetEffectName()	return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf" end
function modifier_Middle_unleash_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_unleash_debuff:GetStatusEffectName()	return "particles/status_fx/status_effect_snapfire_slow.vpcf" end
function modifier_Middle_unleash_debuff:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end


modifier_Middle_unleash_animation = class({})
function modifier_Middle_unleash_animation:IsHidden()	return true end
function modifier_Middle_unleash_animation:IsDebuff()	return false end
function modifier_Middle_unleash_animation:IsPurgable()	return false end

function modifier_Middle_unleash_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_Middle_unleash_animation:GetActivityTranslationModifiers()	return "unleash" end


modifier_Middle_unleash_recovery = class({})
function modifier_Middle_unleash_recovery:IsHidden()	return false end
function modifier_Middle_unleash_recovery:IsDebuff()	return true end
function modifier_Middle_unleash_recovery:IsPurgable()	return false end
function modifier_Middle_unleash_recovery:OnCreated( kv )
	self.parent = self:GetParent()
	if not IsServer() then return end
	self.success = kv.success==1
end

function modifier_Middle_unleash_recovery:OnRefresh( kv )
	self:OnCreated( kv )
end



function modifier_Middle_unleash_recovery:OnDestroy()
	if not IsServer() then return end
	local main = self.parent:FindModifierByName("modifier_Middle_unleash")
	if not main then return end
	if self.forced then return end
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_Middle_unleash_fury", {} )

end





function modifier_Middle_unleash_recovery:ForceDestroy()
	self.forced = true
	self:SafeDestroy()
end