Middle_greater_bash = class({})
LinkLuaModifier( "modifier_Middle_greater_bash_buff", "skills/Middle_greater_bash", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Middle_greater_bash_debuff", "skills/Middle_greater_bash", LUA_MODIFIER_MOTION_NONE )


function Middle_greater_bash:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context )

end


function Middle_greater_bash:GetIntrinsicModifierName()
	return "modifier_Middle_greater_bash_buff"
end





modifier_Middle_greater_bash_buff = modifier_Middle_greater_bash_buff or class({})
function modifier_Middle_greater_bash_buff:IsHidden()	return true end
function modifier_Middle_greater_bash_buff:IsPurgable()	return false end

function modifier_Middle_greater_bash_buff:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) 
	-- self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
end

function modifier_Middle_greater_bash_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Middle_greater_bash_buff:OnDestroy( kv )

end


function modifier_Middle_greater_bash_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_Middle_greater_bash_buff:GetModifierProcAttack_BonusDamage_Physical( keys )
	if IsServer() then
		local caster = self:GetCaster()
		if caster:PassivesDisabled() or not caster:IsApplyModifier() then
			return
		end
		local ability = self:GetAbility()
		if not ability:IsCooldownReady() then return end

		if self:GetCaster():RollRandom(self.proc_chance,1)  then
			ability:UseResources(true, true, true, true)

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
			self:PlayEffects( keys.target )

			local bonus = ability:GetSpecialValueFor( "bonus_damage" )*0.01
			local index = 0.5
			return caster:GetIdealSpeed() * bonus + keys.target:GetIdealSpeed() * bonus*index
		end
	end
end

function modifier_Middle_greater_bash_buff:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
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
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




