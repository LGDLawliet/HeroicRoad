
Primary_vaccum = class({})
LinkLuaModifier( "modifier_Primary_vaccum", "skills/Primary_vaccum", LUA_MODIFIER_MOTION_HORIZONTAL )

function Primary_vaccum:Precache( context )
	PrecacheResource( "particle","particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", context )
end

function Primary_vaccum:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function Primary_vaccum:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "duration" )

	local enemies = FindUnitsInRadius(caster:GetTeamNumber() ,point ,nil ,radius ,DOTA_UNIT_TARGET_TEAM_ENEMY ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,0 ,false)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster,self,"modifier_Primary_vaccum",{duration = duration, x = point.x, y = point.y,})
	end

	self:PlayEffects( point, radius )
end


function Primary_vaccum:PlayEffects( point, radius )

	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
	local sound_cast = "Hero_Dark_Seer.Vacuum"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------
modifier_Primary_vaccum = advanced_modifier({})

function modifier_Primary_vaccum:IsHidden()return false end
function modifier_Primary_vaccum:IsDebuff()return true end
function modifier_Primary_vaccum:IsStunDebuff()return true end
function modifier_Primary_vaccum:IsPurgable()return false end


function modifier_Primary_vaccum:OnCreated( kv )
    if not IsServer() then
        return
    end

	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	local center = Vector( kv.x, kv.y, 0 )
	self.direction = center - self:GetParent():GetOrigin()
	self.speed = self.direction:Length2D()/self:GetDuration()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Primary_vaccum:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Primary_vaccum:OnDestroy()
	if not IsServer() then
        return
    end
	self:GetParent():RemoveHorizontalMotionController( self )

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        
	}
	ApplyDamage(damageTable)
    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
end

function modifier_Primary_vaccum:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_Primary_vaccum:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end

function modifier_Primary_vaccum:OnHorizontalMotionInterrupted()
	self:Destroy()
end