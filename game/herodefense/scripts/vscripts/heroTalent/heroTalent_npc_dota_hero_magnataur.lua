heroTalent_npc_dota_hero_magnataur = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur", "heroTalent/heroTalent_npc_dota_hero_magnataur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_skewer", "heroTalent/heroTalent_npc_dota_hero_magnataur", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff", "heroTalent/heroTalent_npc_dota_hero_magnataur", LUA_MODIFIER_MOTION_HORIZONTAL  )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_magnataur:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_magnataur"
end

function heroTalent_npc_dota_hero_magnataur:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_magnataur")
	if modifier then
		modifier:SpellToTarget( pos )
	end
	
end

modifier_heroTalent_npc_dota_hero_magnataur = class({})

function modifier_heroTalent_npc_dota_hero_magnataur:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_magnataur:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_magnataur:OnCreated()
	if IsServer() then
		self.currentOrder = 0
		self.currentPos = self:GetParent():GetAbsOrigin()
	end
end
-- function modifier_heroTalent_npc_dota_hero_magnataur:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_EVENT_ON_ORDER,
-- 	}
-- 	return funcs
-- end
-- function modifier_heroTalent_npc_dota_hero_magnataur:OnOrder( params )
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if not self:GetParent():IsRealHero() then
-- 		return false
-- 	end
-- 	if params.unit~=self:GetParent() then return end
-- 	local ability = self:GetAbility()

-- 	if not ability:IsCooldownReady() then
-- 		return
-- 	end
-- 	local parent = self:GetParent()
-- 	if parent:IsRooted() then
-- 		return  
-- 	end
-- 	if not ability:GetAutoCastState() then
-- 		return
-- 	end
-- 	-- right click
-- 	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
-- 		self.currentOrder = self.currentOrder +1
		
-- 		Timers:CreateTimer(0.2, function()
-- 			self.currentOrder = self.currentOrder - 1
-- 		end)
		
-- 		if self.currentOrder>=2 and CalculateDistance(self.currentPos,params.new_pos)<=30 then
-- 			-- self:GetAbility():UseResources(true, true, true,true)
-- 			-- print(ability:GetCooldown(ability:GetLevel()) * self:GetParent():GetCooldownReduction())
-- 			:UseResources(true, true, true, true)
-- 			self:SpellToTarget( params.new_pos )
-- 		end
-- 		self.currentPos = params.new_pos
		
-- 	end
-- end

function modifier_heroTalent_npc_dota_hero_magnataur:SpellToTarget(pos)
	if IsServer() then
		local caster = self:GetCaster()
		local maxrange = 1000 +  caster:GetCastRangeBonus()
		maxrange = math.min(maxrange,2000)
		local point = pos
		if point==caster:GetAbsOrigin() then
			point = point +caster:GetForwardVector()
		end
		local direction = point-caster:GetOrigin()
		local dis = direction:Length2D()
		direction.z = 0
		direction = direction:Normalized()
		if dis > maxrange then


			point = caster:GetOrigin() + direction * maxrange
		end
		local dir =( point-caster:GetOrigin()):Normalized()
		dir = VectorAngles(dir)
		caster:SetAngles(dir.x,dir.y,dir.z)
		
		-- add modifier
		caster:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_heroTalent_npc_dota_hero_magnataur_skewer", -- modifier name
			{
				duration =2.5,
				x = point.x,
				y = point.y,
			} -- kv
		)
	end

end











modifier_heroTalent_npc_dota_hero_magnataur_skewer = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:OnCreated( kv )
	-- references
	self.radius = 200
	self.speed = 1500


	if not IsServer() then return end

	-- get data
	self.origin = self:GetParent():GetOrigin()
	self.point = Vector( kv.x, kv.y, 0 )
	self.direction = self.point - self.origin
	self.distance = self.direction:Length2D()

	self.direction.z = 0
	self.direction = self.direction:Normalized()

	-- init
	self.enemies = {}

	-- motion
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	-- play effects
	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end


function modifier_heroTalent_npc_dota_hero_magnataur_skewer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:Advanced_GetModifierIncomingDamage_Percentage( params ) return -100 end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local target = origin + self.direction*self.speed*dt
	me:SetOrigin( target )



	-- check distance
	local dist = (target-self.origin):Length2D()
	if dist>self.distance then
		self:SafeDestroy()
	end
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end


function modifier_heroTalent_npc_dota_hero_magnataur_skewer:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end









--------------------------------------------------------------------------------
-- Aura Effects
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:IsAura()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff" end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraRadius()	return self.radius end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraDuration()	return 0.1 end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraSearchFlags()	return 0 end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end


function modifier_heroTalent_npc_dota_hero_magnataur_skewer:PlayEffects()
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




modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff = class({})

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:OnCreated( kv )
	if not IsServer() then return end

	self.dist = 200
	self.damage = self:GetCaster():GetStrength()*5+200


	-- apply motion
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	-- play effects
	local sound_cast = "Hero_Magnataur.Skewer.Target"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:OnRefresh( kv )
	
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:OnRemoved()
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:UpdateHorizontalMotion( me, dt )
	local caster = self:GetCaster()
	local target = caster:GetOrigin() + caster:GetForwardVector() * self.dist

	me:SetOrigin( target )
end

function modifier_heroTalent_npc_dota_hero_magnataur_skewer_debuff:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end