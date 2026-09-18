creeps_spell_razor_unstable_current =  creeps_spell_razor_unstable_current or class({})



LinkLuaModifier( "modifier_creeps_spell_razor_unstable_current", "creeps_spell/creeps_spell_razor_unstable_current", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')

function creeps_spell_razor_unstable_current:GetIntrinsicModifierName() return "modifier_creeps_spell_razor_unstable_current" end
--------------------------------------------------------------------------------


function creeps_spell_razor_unstable_current:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/ambient/razor_weapon/effect.vpcf", context )
end


modifier_creeps_spell_razor_unstable_current = modifier_creeps_spell_razor_unstable_current or class({})
function modifier_creeps_spell_razor_unstable_current:IsHidden() return true end
function modifier_creeps_spell_razor_unstable_current:IsDebuff() return false end
function modifier_creeps_spell_razor_unstable_current:IsPurgable() 		return false end
function modifier_creeps_spell_razor_unstable_current:IsPurgeException() 	return false end
function modifier_creeps_spell_razor_unstable_current:RemoveOnDeath()  return false end
function modifier_creeps_spell_razor_unstable_current:IsStunDebuff() return false end
function modifier_creeps_spell_razor_unstable_current:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_razor_unstable_current:OnCreated(keys)
	if IsServer() then
		-- print()
		Timers:CreateTimer(0.03, function()
			local caster = self:GetCaster()
			if not caster or caster:IsNull() or not caster:IsAlive() then
				return
			end

			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/ambient/razor_weapon/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip1", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip2", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip3", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip4", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip5", self:GetCaster():GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end)
		
	end
end
function modifier_creeps_spell_razor_unstable_current:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end


function modifier_creeps_spell_razor_unstable_current:GetModifierMoveSpeedBonus_Percentage()
	return 40
end

function modifier_creeps_spell_razor_unstable_current:CheckState()
	local state = {

		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
	

end
