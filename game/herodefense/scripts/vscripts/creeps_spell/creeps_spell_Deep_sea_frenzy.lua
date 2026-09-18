creeps_spell_Deep_sea_frenzy = class({})

LinkLuaModifier("modifier_creeps_spell_Deep_sea_frenzy_slow", "creeps_spell/creeps_spell_Deep_sea_frenzy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Deep_sea_frenzy_triger", "creeps_spell/creeps_spell_Deep_sea_frenzy", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Deep_sea_frenzy:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/deep_sea/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/kunkka_talent/kunkka_talent_ghost_ship_model.vpcf", context )

	
end
function creeps_spell_Deep_sea_frenzy:IsHiddenWhenStolen() 		return false end
function creeps_spell_Deep_sea_frenzy:IsRefreshable() 			return true end
function creeps_spell_Deep_sea_frenzy:IsStealable() 				return true end
function creeps_spell_Deep_sea_frenzy:IsNetherWardStealable()		return true end

function creeps_spell_Deep_sea_frenzy:OnSpellStart()

    self:GetCaster():AddNewModifier(
        self:GetCaster(),
        self,
        "modifier_creeps_spell_Deep_sea_frenzy_triger",
        {	duration = 10})
end









modifier_creeps_spell_Deep_sea_frenzy_triger = class({})
function modifier_creeps_spell_Deep_sea_frenzy_triger:IsHidden() return true end
function modifier_creeps_spell_Deep_sea_frenzy_triger:IsDebuff() return false end
function modifier_creeps_spell_Deep_sea_frenzy_triger:IsPurgable() return false end
function modifier_creeps_spell_Deep_sea_frenzy_triger:IsPurgeException() return false end
function modifier_creeps_spell_Deep_sea_frenzy_triger:IsStunDebuff() return false end
function modifier_creeps_spell_Deep_sea_frenzy_triger:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_Deep_sea_frenzy_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
    }
    return state
end
function modifier_creeps_spell_Deep_sea_frenzy_triger:DeclareFunctions() return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
} end
function modifier_creeps_spell_Deep_sea_frenzy_triger:GetOverrideAnimation( params ) return ACT_DOTA_CAST_ABILITY_1 end
function modifier_creeps_spell_Deep_sea_frenzy_triger:GetOverrideAnimationRate( params ) return 2 end



function modifier_creeps_spell_Deep_sea_frenzy_triger:OnCreated(keys)
    if IsServer() then
        self.model_scale = 1


		self.next_step = RandomInt(0, 360)

		self.turn_speed = 5
		self.timer = 0
		self.time = 0
		self:StartIntervalThink(FrameTime())
 
        local caster = self:GetCaster()
		local ability = self:GetAbility()
	
		self.radius = ability:GetSpecialValueFor("radius")
		self.bonus_radius =  ability:GetSpecialValueFor("radius_per_s")

		-- local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		-- local damageTable = {

		-- 	attacker =caster,
		-- 	damage = caster:GetStrength(),
		-- 	damage_type = DAMAGE_TYPE_MAGICAL,
		-- 	ability = ability, --Optional.
		-- }
		caster:EmitSound("Hero_ShadowDemon.Soul_Catcher")
		-- for _, enemy in ipairs(units) do
		-- 	damageTable.victim = enemy
		-- 	ApplyDamage(damageTable)
		-- 	local soul_projectile = {
		-- 		Target = caster,
		-- 		Source = enemy,
		-- 		Ability = ability,
		-- 		EffectName = "particles/rebuild/spell/abadon_telent/abadon_souls.vpcf",
		-- 		bDodgeable = false,
		-- 		bProvidesVision = false,
		-- 		iMoveSpeed = 600,
		-- 		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		-- 		ExtraData = {}   --额外的数据
		-- 	}

		-- 	ProjectileManager:CreateTrackingProjectile(soul_projectile)	
		self.particle = {}
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/deep_sea/effect.vpcf", PATTACH_WORLDORIGIN,  caster  )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 0, 0 ) )
		table.insert(self.particle,nFXIndex)
				
			
		-- end

    end
end

function modifier_creeps_spell_Deep_sea_frenzy_triger:OnDestroy()
	if IsServer() then
		for _, index in ipairs(self.particle) do
			ParticleManager:DestroyParticle(index, false)
			ParticleManager:ReleaseParticleIndex( index)
		end

	end
end

function modifier_creeps_spell_Deep_sea_frenzy_triger:OnIntervalThink()
	self.turn_speed = self.turn_speed  +0.12
	self.next_step = self.next_step + self.turn_speed
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	local caster = self:GetCaster()
	caster:SetForwardVector( self.facing )

	self.timer = self.timer + FrameTime()
	if self.timer >=0.5 then
		self.timer = self.timer - 0.5
		self.radius = self.radius + self.bonus_radius *0.5
		self.time  = self.time  + 1
		local ability = self:GetAbility()

		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/deep_sea/effect.vpcf", PATTACH_WORLDORIGIN,  caster  )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 0, 0 ) )
		table.insert(self.particle,nFXIndex)


		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 3, caster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		caster:EmitSound("Ability.Ghostship.crash")

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			damage = caster:GetDamageMax()*ability:GetSpecialValueFor("damage_index_per_s")*0.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
		}
		for _, enemy in ipairs(units) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			enemy:AddNewModifier(caster,ability,"modifier_creeps_spell_Deep_sea_frenzy_slow",{	duration = 1,index = self.time })
		
		end
	end
end







modifier_creeps_spell_Deep_sea_frenzy_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_Deep_sea_frenzy_slow:IsHidden()	return true end
function modifier_creeps_spell_Deep_sea_frenzy_slow:IsDebuff()	return true end
function modifier_creeps_spell_Deep_sea_frenzy_slow:IsStunDebuff()	return false end
function modifier_creeps_spell_Deep_sea_frenzy_slow:IsPurgable()	return true end

function modifier_creeps_spell_Deep_sea_frenzy_slow:OnCreated( kv )
	-- references
	local ability=self:GetAbility()
	self.ms_slow = -ability:GetSpecialValueFor("slow")*0.5

	if not IsServer() then return end
	self:SetStackCount(kv.index+2)
end


function modifier_creeps_spell_Deep_sea_frenzy_slow:OnRefresh( kv )
	if not IsServer() then return end
	self:SetStackCount(kv.index+2)
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_Deep_sea_frenzy_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}

	return funcs
end


function modifier_creeps_spell_Deep_sea_frenzy_slow:GetModifierMoveSpeedBonus_Percentage()	return self.ms_slow*self:GetStackCount() end





