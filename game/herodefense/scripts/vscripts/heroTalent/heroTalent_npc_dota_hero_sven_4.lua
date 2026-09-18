--
heroTalent_npc_dota_hero_sven_4 = heroTalent_npc_dota_hero_sven_4 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sven_4", "heroTalent/heroTalent_npc_dota_hero_sven_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sven_4_phantom", "heroTalent/heroTalent_npc_dota_hero_sven_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack", "heroTalent/heroTalent_npc_dota_hero_sven_4", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_sven_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sven_4"
end

-- function heroTalent_npc_dota_hero_sven_4:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_impact_b.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/sven_2/effect_crit.vpcf", context )

-- end


modifier_heroTalent_npc_dota_hero_sven_4 = modifier_heroTalent_npc_dota_hero_sven_4 or class({})

function modifier_heroTalent_npc_dota_hero_sven_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sven_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sven_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_sven_4:OnCreated(params)
	if IsServer() then
		self.start_time 				=GameRules:GetGameTime()
		self.spirit_summon_interval 	= 0.3
		self.max_spirits				= 3
		self.spirit_radius 				= 150
		self.spirit_min_radius			= 150
		self.spirit_max_radius			= 300
		self.spirit_movement_rate 		=100
		self.spirit_turn_rate			= 180
		self.spirits_num_spirits = 0
		self.spirits_spiritsSpawned = {}
		self.spirits_movementFactor = 1
		self:StartIntervalThink(0.03)
	end
end

function modifier_heroTalent_npc_dota_hero_sven_4:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval




		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)
		if self.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_hd_sven_sword_ghost", caster_position, false, caster, caster, caster:GetTeam())



			
			--增加数量记录
			local spiritIndex = self.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			self.spirits_num_spirits = spiritIndex
			self.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_sven_4_phantom", { })
		end
		
		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius	= self.spirit_radius

		local deltaRadius 	= self.spirits_movementFactor * self.spirit_movement_rate * 0.03
		currentRadius 		= currentRadius + deltaRadius
		-- currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		if currentRadius<= self.spirit_min_radius then
			self.spirits_movementFactor = 1
		end
		if currentRadius>= self.spirit_max_radius then
			self.spirits_movementFactor = -1
		end
		self.spirit_radius 	= currentRadius


		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, currentRadius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)
				spirit:SetAbsOrigin(absPos)

			end
		end
	end
end


-- npc_hd_sven_sword_ghost



modifier_heroTalent_npc_dota_hero_sven_4_phantom = modifier_heroTalent_npc_dota_hero_sven_4_phantom or class({})
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:OnCreated(keys)
	if IsServer() then
		self.bonus_move = 0
		self:StartIntervalThink(0.03)
		self.timer = GameRules:GetGameTime()
	end
end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom:OnIntervalThink()
	local parent = self:GetParent()
	if parent:HasModifier("modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack") then
		return
	else
		parent:SetForwardVector(self:GetCaster():GetForwardVector())
	end
	
	local time = GameRules:GetGameTime()
	if time>=self.timer then
		local caster = self:GetCaster()
		if caster:IsAttacking() then
			local target = caster:GetAggroTarget()
			if target then
				self.timer = time +RandomFloat(-0.15, 0.15)+2
				local modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack", {duration=1})
				if modifier then
					modifier:InitTarget(target)					
				end
				parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1)
			end
		end
	-- else
	-- 	self.timer = self.timer-(self.timer-time)*0.1
	-- 	print(self.timer)

	end
end

function modifier_heroTalent_npc_dota_hero_sven_4_phantom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end






function modifier_heroTalent_npc_dota_hero_sven_4_phantom:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker==self:GetCaster() then
			if keys.attacker:IsInSpecialAttack() then
				return
			end
			local time = GameRules:GetGameTime()
			if time<self.timer then
				self.timer = self.timer-(self.timer-time)*0.1
			end
		end
	end
end




function modifier_heroTalent_npc_dota_hero_sven_4_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end





function modifier_heroTalent_npc_dota_hero_sven_4_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end







modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack = modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack or class({})
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:InitTarget(target)	
	-- if IsServer() then
	-- self.speed = 1/self:GetRemainingTime()
	self.target = target
	self.timer = 0
	self.attackDone = false
	self:StartIntervalThink(0.03)
	-- end
	
end
function modifier_heroTalent_npc_dota_hero_sven_4_phantom_attack:OnIntervalThink()
	self.timer = self.timer +FrameTime()
	if self.target:IsNull() then
		return
	end
	if not self.attackDone and self.timer>=0.4 then
		local caster = self:GetAbility():GetCaster()
		local target = caster:GetAggroTarget()
		if target and target==self.target then
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =0,
				iDisableSplit = 0,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)

			caster:PerformAttack(target, false, true, true, true, false, false, true)--对一单位执行攻击。
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		
		end
		self.attackDone = true
	end
	local dir = CalculateDirection(self.target,self:GetParent())
	self:GetParent():SetForwardVector(dir)

end
