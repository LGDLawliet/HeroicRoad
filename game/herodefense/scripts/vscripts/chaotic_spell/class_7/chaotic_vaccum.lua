
chaotic_vaccum = class({})
LinkLuaModifier( "modifier_chaotic_vaccum", "chaotic_spell/class_7/chaotic_vaccum", LUA_MODIFIER_MOTION_HORIZONTAL )

function chaotic_vaccum:Precache( context )
	PrecacheResource( "particle","particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", context )
end

function chaotic_vaccum:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function chaotic_vaccum:OnSpellStart()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	self:PlayEffects(point, radius, 1)

	if self:GetRuneType() == 1 then
		local delay = self:GetSpecialValueFor("rune_1_delay")
		radius =  radius * self:GetSpecialValueFor("rune_1_radius")*0.01
		local damageindex = self:GetSpecialValueFor("rune_1_damage")*0.01
		self:GetCaster():GameTimer(delay,function(...)
			self:PlayEffects(point, radius, damageindex)
		end)
	end
end


function chaotic_vaccum:PlayEffects( point, radius, damageindex )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

	local enemies = FindUnitsInRadius(caster:GetTeamNumber() ,point ,nil ,radius ,DOTA_UNIT_TARGET_TEAM_ENEMY ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,0 ,false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster,self,"modifier_chaotic_vaccum",{duration = duration, x = point.x, y = point.y, damageindex = damageindex})
	end

	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
	local sound_cast = "Hero_Dark_Seer.Vacuum"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------
modifier_chaotic_vaccum = advanced_modifier({})

function modifier_chaotic_vaccum:IsHidden()return false end
function modifier_chaotic_vaccum:IsDebuff()return true end
function modifier_chaotic_vaccum:IsStunDebuff()return true end
function modifier_chaotic_vaccum:IsPurgable()return false end


function modifier_chaotic_vaccum:OnCreated( kv )
    if not IsServer() then
        return
    end

    if not self:GetAbility() then return end
    
	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():HDGetPrimaryStatValue()*kv.damageindex
    self.move_line = self:GetAbility():GetSpecialValueFor("move_line")
    self.slow_outgoing = 1+self:GetAbility():GetSpecialValueFor("slow_outgoing")*0.01

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

function modifier_chaotic_vaccum:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_chaotic_vaccum:OnDestroy()
	if not IsServer() then
        return
    end
    if not self:GetAbility() then return end
    
	self:GetParent():RemoveHorizontalMotionController( self )

    local damage = self.damage
    if self:GetParent():GetIdealSpeed() <= self.move_line then
        damage = damage* self.slow_outgoing
    end

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
		hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        
	}
	ApplyDamage(damageTable)
    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
end

function modifier_chaotic_vaccum:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_chaotic_vaccum:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end

function modifier_chaotic_vaccum:OnHorizontalMotionInterrupted()
	self:Destroy()
end