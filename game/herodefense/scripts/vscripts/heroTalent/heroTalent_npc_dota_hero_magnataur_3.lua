heroTalent_npc_dota_hero_magnataur_3 = class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_3", "heroTalent/heroTalent_npc_dota_hero_magnataur_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_3_skewer", "heroTalent/heroTalent_npc_dota_hero_magnataur_3", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff", "heroTalent/heroTalent_npc_dota_hero_magnataur_3", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_3_debuff", "heroTalent/heroTalent_npc_dota_hero_magnataur_3", LUA_MODIFIER_MOTION_NONE  )

require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_magnataur_3:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_magnataur_3"
-- end

function heroTalent_npc_dota_hero_magnataur_3:OnSpellStart( )
	-- unit identifier
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self, "modifier_heroTalent_npc_dota_hero_magnataur_3_skewer",{duration = 10} )
	
	
end





modifier_heroTalent_npc_dota_hero_magnataur_3_skewer = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:OnCreated( kv )
	

	if not IsServer() then return end

	self:PlayEffects()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = 1500

	self.turn_speed = 120

	self.radius = 200
	self.tree_radius = 100
	self.height = 50
	self.timer = GameRules:GetGameTime()+2
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true
	self.start_pos = self.parent:GetOrigin()
	self:StartIntervalThink(FrameTime()) 

	

end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:OnDestroy()
	if not IsServer() then return end
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
end


function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		ExecuteOrderFromTable({
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION,
			Position = params.new_pos,
		})
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetModifierDisableTurning()
	return 1
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if self.parent:IsRooted() or self.parent:IsStunned() then
		self:Destroy()
		return
	end
	if GameRules:GetGameTime()>=self.timer then
		self.timer = self.timer +0.1
		self.parent:AddNewModifier(self.parent,self.ability, "modifier_heroTalent_npc_dota_hero_magnataur_3_debuff",{duration = 30} )
	
		
		if self.parent:GetStrength()<=10 then
			self:SafeDestroy()
			return
		end
	end
	
	self:TurnLogic( FrameTime() )

	local nextpos = self.parent:GetOrigin() + self.parent:GetForwardVector() * self.speed*FrameTime()
	nextpos = GetGroundPosition(nextpos, nil)
	if CalculateDistance(self.start_pos,self.parent:GetOrigin())>=2000 then
		FindClearSpaceForUnit( self.parent, nextpos, true )
		self.start_pos = self.parent:GetOrigin()
		
	else
		self.parent:SetOrigin(nextpos)  --Sets the location of this entity
	end
	
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
	
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetModifierMoveSpeed_Limit()
	return 0.1
end



-- function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetModifierIncomingDamage_Percentage( params ) return -1000 end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end


function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:Advanced_GetModifier_FlyingPathing()	
	return 1
end







--------------------------------------------------------------------------------
-- Aura Effects
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:IsAura()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff" end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraRadius()	return self.radius end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraDuration()	return 0.1 end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraSearchFlags()	return 0 end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end


function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
	local sound_cast = "Hero_Magnataur.Skewer.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_horn",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, self:GetParent():GetForwardVector() )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end




modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff = class({})

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnCreated( kv )
	if not IsServer() then return end

	self.dist = 200
	-- self.damage = self:GetCaster():GetStrength()*5+200


	-- apply motion
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetMaxHealth()*0.25,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(self.damageTable)

	self:StartIntervalThink(2)

	local sound_cast = "Hero_Magnataur.Skewer.Target"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnRefresh( kv )
	
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnRemoved()
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )	
end
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnIntervalThink()
	self.damageTable.damage = self:GetCaster():GetMaxMana()*0.1
	ApplyDamage(self.damageTable)
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:UpdateHorizontalMotion( me, dt )
	local caster = self:GetCaster()
	local target = caster:GetOrigin() + caster:GetForwardVector() * self.dist

	me:SetOrigin( target )
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_skewer_debuff:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end








modifier_heroTalent_npc_dota_hero_magnataur_3_debuff = class({})

function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:OnCreated()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end


function modifier_heroTalent_npc_dota_hero_magnataur_3_debuff:GetModifierBonusStats_Strength()	return -self:GetStackCount() end

