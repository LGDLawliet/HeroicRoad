creep_special_gain_enraged = class({})

LinkLuaModifier("modifier_creep_special_gain_enraged", "special_gain/creep_special_gain_enraged", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_enraged_buff", "special_gain/creep_special_gain_enraged", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_enraged:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_enraged"
end
---------------------------------------------------

modifier_creep_special_gain_enraged = advanced_modifier({})

function modifier_creep_special_gain_enraged:IsDebuff() return false end
function modifier_creep_special_gain_enraged:IsHidden() return false end
function modifier_creep_special_gain_enraged:IsPurgable() return false end
function modifier_creep_special_gain_enraged:IsPurgeException() return false end

function modifier_creep_special_gain_enraged:OnCreated(keys)
    self.ability = self:GetAbility()
	self.parent =self:GetParent()
	self.hp_line = self.ability:GetSpecialValueFor("hp_line")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self:StartIntervalThink(0.2)
end

function modifier_creep_special_gain_enraged:OnIntervalThink()
	if IsServer() then
		if self.parent:GetHealthPercent() <= self.hp_line and  self.ability:IsCooldownReady() then
			if self.parent:PassivesDisabled() then
				self.duration = 0.75*self.ability:GetSpecialValueFor("duration")
			end
			self.ability:UseResources(true, true, true, true)
			self.parent:Purge(false, true, false, true, true)  --强驱散
			local Gain = self.parent:GetModifierDurationGainIndex(0.5)
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_creep_special_gain_enraged_buff", {duration =self.duration*Gain})--词条传送门：狂暴，魔法免疫
		end
		
	end
end





modifier_creep_special_gain_enraged_buff = class({})

-----------------------------------------------------------------------------------------
function modifier_creep_special_gain_enraged_buff:IsDebuff() return false end
function modifier_creep_special_gain_enraged_buff:IsHidden() return false end
function modifier_creep_special_gain_enraged_buff:IsPurgable()
	return false
end

function modifier_creep_special_gain_enraged_buff:IsPurgeException() return true end
-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:OnCreated( kv )
	local ability = self:GetAbility()
	if not ability then
		self.enrage_movespeed_bonus = 0
		self.enrage_attack_speed_bonus = 0
		self.enrage_model_scale_bonus = 0
	else
		self.enrage_movespeed_bonus = ability:GetSpecialValueFor( "enrage_movespeed_bonus" )
		self.enrage_attack_speed_bonus = ability:GetSpecialValueFor( "enrage_attack_speed_bonus" )
		self.enrage_model_scale_bonus = ability:GetSpecialValueFor( "enrage_model_scale_bonus" )
	end
	

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Hero_LifeStealer.Rage", self:GetParent() )


	end
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:GetModifierMoveSpeedBonus_Constant( params )
	return self.enrage_movespeed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.enrage_attack_speed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:GetModifierModelScale( params )
	return self.enrage_model_scale_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creep_special_gain_enraged_buff:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------
