
LinkLuaModifier( "modifier_Middle_rage", "skills/Middle_rage", LUA_MODIFIER_MOTION_NONE )


Middle_rage						= Middle_rage or class({})


function Middle_rage:OnSpellStart()

	
	
	local caster =self:GetCaster()
	EmitSoundOn( "Hero_LifeStealer.Rage", caster )
	caster:Purge(false, true, false, true, true)  --强驱散
	local Gain = caster:GetModifierDurationGainIndex(0.5)
	caster:AddNewModifier(caster, self, "modifier_Middle_rage", {duration =self:GetSpecialValueFor("duration")*Gain})
end



function Middle_rage:IsRefreshable() return false end

modifier_Middle_rage = class({})

-----------------------------------------------------------------------------------------
function modifier_Middle_rage:IsDebuff() return false end
function modifier_Middle_rage:IsHidden() return false end
function modifier_Middle_rage:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:OnCreated( kv )
	self.enrage_movespeed_bonus = self:GetAbility():GetSpecialValueFor( "bonus_move" )

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		


	end
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH ,

	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:GetModifierMoveSpeedBonus_Percentage( params )
	return self.enrage_movespeed_bonus
end



-----------------------------------------------------------------------------------------

function modifier_Middle_rage:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------

function modifier_Middle_rage:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.attacker == self:GetParent() then
        keys.attacker:Heal(keys.attacker:GetMaxHealth()*0.1, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, keys.attacker:GetMaxHealth()*0.1, nil)
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_loadout.vpcf", PATTACH_POINT_FOLLOW,keys.attacker)
		-- ParticleManager:SetParticleControl(particle, 0, keys.unit:GetAbsOrigin())
		-- ParticleManager:SetParticleControl(particle, 1, keys.attacker:GetAbsOrigin())
		-- ParticleManager:ReleaseParticleIndex(particle)
		keys.attacker:EmitSound("Hero_LifeStealer.Infest")
    end
   
end
