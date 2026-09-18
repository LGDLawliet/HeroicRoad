
creeps_spell_cyclops_smash = class({})
LinkLuaModifier("modifier_cyclops_smash_thinker", "creeps_spell/creeps_spell_cyclops_smash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_cyclops_smash_move", "creeps_spell/creeps_spell_cyclops_smash", LUA_MODIFIER_MOTION_HORIZONTAL )
-----------------------------------------------------------------------------

function creeps_spell_cyclops_smash:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
end


function creeps_spell_cyclops_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function creeps_spell_cyclops_smash:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, self:GetLevel() ) / self:GetCaster():GetHasteFactor() 
end

-----------------------------------------------------------------------------

function creeps_spell_cyclops_smash:GetPlaybackRateOverride()
	return math.min( 2.0, math.max( self:GetCaster():GetHasteFactor(), 1.0 ) )
end

-----------------------------------------------------------------------------

function creeps_spell_cyclops_smash:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		EmitSoundOn( "OgreTank.Grunt", caster )
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" ) / self:GetPlaybackRateOverride()
		local vToTarget = self:GetCursorPosition() - caster:GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget =caster:GetOrigin() + vToTarget * self:GetCastRange(caster:GetOrigin(), nil )

		local hThinker = CreateModifierThinker( caster, self, "modifier_cyclops_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
		caster:AddNewModifier(caster, self, "modifier_cyclops_smash_move", {duration = 0.6})
		
	end
end








modifier_cyclops_smash_thinker = class({})
function modifier_cyclops_smash_thinker:OnCreated( kv )
	if IsServer() then
		self.impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) * self:GetCaster():GetDamageMax()

		self.bCancelled = false

		self:StartIntervalThink( 0.01 )
	end
end

-----------------------------------------------------------------------------

function modifier_cyclops_smash_thinker:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_cyclops_smash_thinker:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local nOrderType = params.order_type

		if hOrderedUnit == nil or hOrderedUnit ~= self:GetCaster() then
			return
		end

		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_DIRECTION and
			nOrderType ~= DOTA_UNIT_ORDER_ATTACK_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_ATTACK_MOVE and
			nOrderType ~= DOTA_UNIT_ORDER_STOP and
			nOrderType ~= DOTA_UNIT_ORDER_HOLD_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_POSITION and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_NO_TARGET and
			nOrderType ~= DOTA_UNIT_ORDER_CAST_POSITION then

			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit == self:GetCaster() then
			self.bCancelled = true
			UTIL_Remove( self:GetParent() )

			return
		end
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_cyclops_smash_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false or self:GetCaster():IsStunned() then
			--print( string.format( "Caster is nil, dead, or stunned, removing smash thinker" ) )
			UTIL_Remove( self:GetParent() )
			return -1
		end
	end
end

-----------------------------------------------------------------------------

function modifier_cyclops_smash_thinker:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		if caster ~= nil and caster:IsAlive() and self.bCancelled == false then

			local pos1 = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack1" ) )
			local pos2 = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack2" ) )
			local dir = CalculateDirection(pos1,pos2)
			local vTarget = pos1 - dir * CalculateDistance(pos1,pos2)*0.5

			EmitSoundOnLocationWithCaster( vTarget, "OgreTank.GroundSmash", caster )
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  caster  )
			ParticleManager:SetParticleControl( nFXIndex, 0, vTarget )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nTeamFlags = DOTA_UNIT_TARGET_TEAM_ENEMY


			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vTarget, self:GetParent(), self.impact_radius, nTeamFlags, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

			for _,enemy in pairs( enemies ) do
				if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = caster,
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -caster:GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
					elseif not ( enemy:IsNull() ) and enemy ~= nil then
						local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
						enemy:AddNewModifier( caster, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration *StatusResistance} )
					end
				end
			end

			ScreenShake( vTarget, 10.0, 100.0, 0.5, 1300.0, 0, true )
		end

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------







modifier_cyclops_smash_move = class({})


function modifier_cyclops_smash_move:IsHidden()	return true end
function modifier_cyclops_smash_move:IsDebuff()	return false end
function modifier_cyclops_smash_move:IsPurgable()	return false end
function modifier_cyclops_smash_move:IsPurgeException() return false end
function modifier_cyclops_smash_move:RemoveOnDeath() return false end

function modifier_cyclops_smash_move:OnCreated( kv )



	if not IsServer() then return end


	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

end

function modifier_cyclops_smash_move:UpdateHorizontalMotion( me, dt )
	
	local pos = me:GetOrigin() + me:GetForwardVector() * 200 * dt
	pos = GetGroundPosition( pos, me )
	me:SetOrigin( pos )
end

function modifier_cyclops_smash_move:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end
