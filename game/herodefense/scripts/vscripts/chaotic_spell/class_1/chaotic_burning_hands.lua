LinkLuaModifier("modifier_chaotic_burning_hands_rune_3", "chaotic_spell/class_1/chaotic_burning_hands", LUA_MODIFIER_MOTION_NONE)
chaotic_burning_hands = class({})

function chaotic_burning_hands:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end


function chaotic_burning_hands:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_burning_hands:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end


function chaotic_burning_hands:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_burning_hands:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* (self:GetSpecialValueFor("distance") +self:GetSpecialValueFor("end_width")*0.5)

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("end_width"),self:GetSpecialValueFor("start_width"),0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_burning_hands:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_burning_hands:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	local range = self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()
	if self:GetRuneType()==2 then
		range = range * (1+self:GetSpecialValueFor("rune_2_range_up")*0.01)
	end
	return range
end
function chaotic_burning_hands:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end


function chaotic_burning_hands:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/effect_flame/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", context )
end

function chaotic_burning_hands:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")
	-- local target_pos = caster_loc + direction* distance

	caster:EmitSound("Hero_DragonKnight.BreathFire")


	

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 5, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	local end_width = self:GetSpecialValueFor("end_width")
	local start_width = self:GetSpecialValueFor("start_width")
	local speed = 1200
	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	local gain = 1
	gain = self:GetEffectGain(1)

	if self:GetRuneType()==1 then
		damage = damage * (1-self:GetSpecialValueFor("rune_1_damage_down")*0.01)
	end
	if self:GetRuneType()==2 then
		speed = speed * (1-self:GetSpecialValueFor("rune_2_speed_down")*0.01)
		distance = distance * (1+self:GetSpecialValueFor("rune_2_range_up")*0.01)
	end
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/rebuild/chaotic_spell/chaotic_burning_hands/effect_flame/effect.vpcf",
	    fDistance = distance-(end_width*0.5),
	    fStartRadius = start_width,
	    fEndRadius =end_width,
		vVelocity = direction * speed,
		ExtraData = {
			damage = damage * gain
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
	if self:GetRuneType()==1 then
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("rune_1_cd"))
	end
end




function chaotic_burning_hands:OnProjectileHit_ExtraData( target, location,keys )
	if not target then return end

	-- load data
	-- local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	self:PlayEffect(target)
	-- local gain = rune_1_bouns_gain
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = keys.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	
	ApplyDamage(damageTable)

	if self:GetRuneType()==3 then
		target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_burning_hands_rune_3", {duration = self:GetSpecialValueFor("rune_3_duration")})
	end
end




function chaotic_burning_hands:PlayEffect(target)
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end




-------------

modifier_chaotic_burning_hands_rune_3 = advanced_modifier({})

function modifier_chaotic_burning_hands_rune_3:IsHidden() return false end
function modifier_chaotic_burning_hands_rune_3:IsDebuff() return true end
function modifier_chaotic_burning_hands_rune_3:IsPurgable() return false end
function modifier_chaotic_burning_hands_rune_3:OnCreated()
	self.magic_res_down = self:GetAbility():GetSpecialValueFor("rune_3_magicres_down")
end
function modifier_chaotic_burning_hands_rune_3:OnRefresh()
	self.magic_res_down = self:GetAbility():GetSpecialValueFor("rune_3_magicres_down")
end
function modifier_chaotic_burning_hands_rune_3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_chaotic_burning_hands_rune_3:GetModifierMagicalResistanceBonus()
	return -self.magic_res_down
end