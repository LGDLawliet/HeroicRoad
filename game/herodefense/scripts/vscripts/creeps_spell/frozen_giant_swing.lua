frozen_giant_swing = class( {} )
LinkLuaModifier( "modifier_frozen_giant_swing", "creeps_spell/frozen_giant_swing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_absolute_no_cc", "modifier/modifier_absolute_no_cc", LUA_MODIFIER_MOTION_NONE )
---------------------------------------------------------------

function frozen_giant_swing:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
end

-----------------------------------------------------------------------------

function frozen_giant_swing:GetPlaybackRateOverride()
	return 1
end

---------------------------------------------------------------

function frozen_giant_swing:OnAbilityPhaseStart()
	-- self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
	self.pre_spell = ParticleManager:CreateParticle( "particles/rebuild/alert/alert_1/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.pre_spell, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( self.pre_spell, 1, Vector(7,0,0) )
	-- ParticleManager:ReleaseParticleIndex( nFXIndex )
	self.pre_spell2 = ParticleManager:CreateParticle( "particles/rebuild/alert/alert_1/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.pre_spell2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( self.pre_spell2, 1, Vector(7,0,0) )
	-- ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end

---------------------------------------------------------------

function frozen_giant_swing:OnAbilityPhaseInterrupted()
	if self.pre_spell then
		ParticleManager:DestroyParticle(self.pre_spell, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell )
		self.pre_spell = nil
	end
	if self.pre_spell2 then
		ParticleManager:DestroyParticle(self.pre_spell2, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell2 )
		self.pre_spell2 = nil
	end

end

---------------------------------------------------------------

function frozen_giant_swing:OnSpellStart()
	if self.pre_spell then
		ParticleManager:DestroyParticle(self.pre_spell, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell )
		self.pre_spell = nil
	end
	if self.pre_spell2 then
		ParticleManager:DestroyParticle(self.pre_spell2, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell2 )
		self.pre_spell2 = nil
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/alert/alert_1/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(0.3,0,0) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_frozen_giant_swing", { duration = 0.30 } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_absolute_no_cc", { duration =0.30 } )
end

---------------------------------------------------------------




modifier_frozen_giant_swing = class ({})

--------------------------------------------------------------------------------

function modifier_frozen_giant_swing:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_swing:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_swing:OnCreated( kv )
	if IsServer() then
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )*self:GetCaster():GetDamageMax()
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.knockback_distance  = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_duration  = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
		self.hHitTargets = {}

		self.hAttachment = self:GetParent():ScriptLookupAttachment( "attach_staff" )
		self.vLastInitialDamageCenter = nil
		self.vLastSecondaryDamageCenter = nil

		self:StartIntervalThink( 0.01 )
	end
end

--------------------------------------------------------------------------------


function modifier_frozen_giant_swing:OnIntervalThink()
	if IsServer() == false then 
		return 
	end
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
	
	local vDamageCenter = self:GetParent():GetAttachmentOrigin( self.hAttachment )
	vDamageCenter = GetGroundPosition(vDamageCenter,nil)
	-- DebugDrawCircle( vDamageCenter, Vector( 0, 255, 0 ), 255, self.damage_radius, false, 1.0 )

	local vDamageCenter2 = vDamageCenter - ( self:GetParent():GetForwardVector() * 400 )
	vDamageCenter2 = GetGroundPosition(vDamageCenter2,nil)
	-- DebugDrawCircle( vDamageCenter2, Vector( 0, 255, 0 ), 255, self.damage_radius * 0.75, false, 1.0 )


	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vDamageCenter, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local enemies2 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vDamageCenter2, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy2 in pairs ( enemies2 ) do 
		table.insert( enemies, enemy2 )
	end
	

	-- if self.vLastInitialDamageCenter ~= nil then 
	-- 	local flDist = ( self.vLastInitialDamageCenter - vDamageCenter ):Length2D()
	-- 	local vDamageCenter3 = vDamageCenter + ( self.vLastInitialDamageCenter - vDamageCenter ):Normalized() * flDist / 2
	-- 	--DebugDrawCircle( vDamageCenter3, Vector( 255, 0, 0 ), 255, self.damage_radius, false, 1.0 )
	-- 	local enemies3 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vDamageCenter3, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	-- 	for _,enemy3 in pairs ( enemies3 ) do 
	-- 		table.insert( enemies, enemy3 )
	-- 	end
	-- end

	-- if self.vLastSecondaryDamageCenter ~= nil then 
	-- 	local flDist = ( self.vLastSecondaryDamageCenter - vDamageCenter ):Length2D()
	-- 	local vDamageCenter4 = vDamageCenter2 + ( self.vLastSecondaryDamageCenter - vDamageCenter2 ):Normalized() * flDist / 2
	-- --DebugDrawCircle( vDamageCenter4, Vector( 255, 0, 0 ), 255, self.damage_radius  * 0.75, false, 1.0 )
	-- 	local enemies4 = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vDamageCenter4, self:GetCaster(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	-- 	for _,enemy4 in pairs ( enemies4 ) do 
	-- 		table.insert( enemies, enemy4 )
	-- 	end
	-- end


	if #enemies > 0 then
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and not enemy:IsNull() and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
				self:AddHitTarget( enemy )
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetParent(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}

				ApplyDamage( damageInfo )
				if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
				else
					local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					local kv = 
					{
						center_x = self:GetParent():GetAbsOrigin().x,
						center_y = self:GetParent():GetAbsOrigin().y,
						center_z = self:GetParent():GetAbsOrigin().z,
						duration = self.stun_duration*StatusResistance,
						should_stun = true, 
						knockback_duration = self.knockback_duration,
						knockback_distance = self.knockback_distance,
						knockback_height = 0,
					}

					enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
					EmitSoundOn( "Roshan.Attack.Post", enemy )
				end
			end
		end
	end

	-- self.vLastInitialDamageCenter = vDamageCenter
	-- self.vLastSecondaryDamageCenter = vDamageCenter2
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_swing:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_swing:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end
	
	