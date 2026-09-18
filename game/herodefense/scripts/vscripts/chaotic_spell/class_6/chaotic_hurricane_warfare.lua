LinkLuaModifier("modifier_chaotic_hurricane_warfare", "chaotic_spell/class_6/chaotic_hurricane_warfare", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_hurricane_warfare_aura", "chaotic_spell/class_6/chaotic_hurricane_warfare", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_hurricane_warfare_out_pull", "chaotic_spell/class_6/chaotic_hurricane_warfare", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)




chaotic_hurricane_warfare = class({})
function chaotic_hurricane_warfare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_hurricane_warfare/wind_effect/effect_item_cyclone_v2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_hurricane_warfare/chaotic_hurricane_warfare_debuffe_landing.vpcf", context )

end
function chaotic_hurricane_warfare:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_hurricane_warfare:OnSpellStart()

	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()

	self.point = point
	
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * ModifierStatusNegativeGain

	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = duration + FrameTime() * 2}, point, caster:GetTeamNumber(), false)



	self.thinker:AddNewModifier(caster, self, "modifier_chaotic_hurricane_warfare", {duration = duration})

end


modifier_chaotic_hurricane_warfare = modifier_chaotic_hurricane_warfare or advanced_modifier({})


function modifier_chaotic_hurricane_warfare:IsAura()	return true end
function modifier_chaotic_hurricane_warfare:GetModifierAura()	return "modifier_chaotic_hurricane_warfare_aura" end
function modifier_chaotic_hurricane_warfare:GetAuraRadius()	return self.radius end
function modifier_chaotic_hurricane_warfare:GetAuraDuration()	return 0.1 end
function modifier_chaotic_hurricane_warfare:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_chaotic_hurricane_warfare:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_hurricane_warfare:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_chaotic_hurricane_warfare:OnCreated( kv )
	self:GetParent().hurricane_warface = self
	self.effect_gain = self:GetAbility():GetEffectGain()

	if not IsServer() then return end
	

	self:PlayEffects(self:GetCaster():GetAbsOrigin())

	self.radius = self:GetAbility():GetAOERadius()

	self:StartIntervalThink(0.3)

end


function modifier_chaotic_hurricane_warfare:OnIntervalThink()

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
end

function modifier_chaotic_hurricane_warfare:PlayEffects( loc )
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_hurricane_warfare/wind_effect/effect_item_cyclone_v2.vpcf"
	self.thinkerParticle = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( self.thinkerParticle, 0, loc )
	ParticleManager:SetParticleControl( self.thinkerParticle, 1, loc )
	ParticleManager:SetParticleControl( self.thinkerParticle, 3, Vector(self:GetAbility():GetAOERadius(),0,0) )
	ParticleManager:SetParticleControl( self.thinkerParticle, 9, Vector(self:GetAbility():GetAOERadius() / 400,0,0) )
	ParticleManager:SetParticleControl( self.thinkerParticle, 10, Vector(5,0,0) )
	self:AddParticle(self.thinkerParticle,  false, false, 15,  false, false)
	local sound_location = "Ability.Windrun"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
	self:GetParent():EmitSound("chaotic_hurricane_warfare_cast")

end

modifier_chaotic_hurricane_warfare_aura = advanced_modifier({})

function modifier_chaotic_hurricane_warfare_aura:IsDebuff()			return true end
function modifier_chaotic_hurricane_warfare_aura:IsHidden() 			return true end
function modifier_chaotic_hurricane_warfare_aura:IsPurgable() 			return false end
function modifier_chaotic_hurricane_warfare_aura:IsPurgeException() 	return false end
function modifier_chaotic_hurricane_warfare_aura:IsStunDebuff()		return true end
function modifier_chaotic_hurricane_warfare_aura:CheckState() 
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true, 
		[MODIFIER_STATE_STUNNED] = true, 
		[MODIFIER_STATE_ROOTED] = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true, 
	} 
end
function modifier_chaotic_hurricane_warfare_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_chaotic_hurricane_warfare_aura:OnCreated()
	if IsServer() then

		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()

		self.interval = FrameTime()
		self.vForward = self.parent:GetForwardVector()
		self.rotation = (360 / self:GetDuration()) * 100
		self.next_step = 0
		self.height = 0

		self.fly_height = self:GetAbility():GetSpecialValueFor("fly_height")* self:GetAuraOwner().hurricane_warface.effect_gain
		self.damage_index = self.ability:GetSpecialValueFor("bonus_damage") * self:GetAuraOwner().hurricane_warface.effect_gain

		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_chaotic_hurricane_warfare_aura:OnIntervalThink()


	local ability = self.ability
	local distance = (self.parent:GetAbsOrigin() - ability.point):Length2D()
	local in_pull = 25
	local new_pos = GetGroundPosition(RotatePosition(ability.point, QAngle(0,1.5,0), self.parent:GetAbsOrigin()), self.parent)
	if distance > 20 then
		local direction = (ability.point - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
	end

	self.height = self.height + self.fly_height / (1.0 / FrameTime())

	local vNewPos = GetGroundPosition(new_pos, nil)
	vNewPos.z = vNewPos.z + self.height
	
	--pos
	self.parent:SetAbsOrigin(vNewPos)
	self.vForward = RotatePosition(Vector(0, 0, 0), QAngle(0, self.interval * self.rotation, 0), self.vForward)
	--facing
	self.next_step = self.next_step + 25
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	self.parent:SetForwardVector( self.facing )

end

function modifier_chaotic_hurricane_warfare_aura:OnDestroy()
	if IsServer() then

		FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)

		if not self.parent:IsAlive() then
			return
		end

		local damage = self.damage_index * self.caster:GetAverageTrueAttackDamage(nil)

		local damage_higt = self.ability:GetSpecialValueFor("damage_higt")

		local bonus_max = self.ability:GetSpecialValueFor("bonus_max")

		local bonus_damage = math.min(damage * (self.height / damage_higt) , damage * bonus_max)

		local debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")

		local duration = math.min(debuff_duration * (self.height / damage_higt) , debuff_duration * bonus_max)

		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = bonus_damage,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, 
			ability = self.ability,
			hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
		}
		ApplyDamage(damageTable)
		local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = self.parent:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = duration*StatusResistance})
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_hurricane_warfare/chaotic_hurricane_warfare_debuffe_landing.vpcf", PATTACH_CUSTOMORIGIN,self.parent )
		ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(100,100,0))
		DestroyParticleByDelay(effect_cast,2)

		self.parent:EmitSound("Hero_Techies.StickyBomb.Detonate")

	end
end

function modifier_chaotic_hurricane_warfare_aura:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_Flying,
		

    }
	if self:GetAbility():GetRuneType()~=1 then
		funcs["MODIFIER_EVENT_ON_ATTACK_START"] = {nil,self:GetParent()}
	end
    return funcs
   
end

function modifier_chaotic_hurricane_warfare_aura:Advanced_GetModifier_Flying()	
	return 1
end

function modifier_chaotic_hurricane_warfare_aura:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_chaotic_hurricane_warfare_aura:OnAttackStart(keys)
	if IsServer() then

		if not IsServer() then
			return 
		end

		if keys.target ~= self:GetParent() then
			return
		end

		if keys.attacker:Script_GetAttackRange() < self.height then
			keys.attacker:Stop()
		end

	end
end