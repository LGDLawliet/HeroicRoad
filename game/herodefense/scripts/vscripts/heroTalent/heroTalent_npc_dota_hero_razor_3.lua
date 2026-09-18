heroTalent_npc_dota_hero_razor_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_thinker", "heroTalent/heroTalent_npc_dota_hero_razor_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_thinker2", "heroTalent/heroTalent_npc_dota_hero_razor_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_debuff", "heroTalent/heroTalent_npc_dota_hero_razor_3_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_link", "heroTalent/heroTalent_npc_dota_hero_razor_3_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_debuff", "heroTalent/heroTalent_npc_dota_hero_razor_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_3_buff", "heroTalent/heroTalent_npc_dota_hero_razor_3", LUA_MODIFIER_MOTION_NONE )



function heroTalent_npc_dota_hero_razor_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/razor_3/main_effect/effect.vpcf", context )

end


function heroTalent_npc_dota_hero_razor_3:OnSpellStart()
	-- local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Ability.static.start")
	-- target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_razor_3_link", {duration =10})
	CreateModifierThinker(caster, self, "modifier_heroTalent_npc_dota_hero_razor_3_thinker", {duration = 50}, self:GetCursorPosition()+Vector(0,0,4048), caster:GetTeamNumber(), false)
end
function heroTalent_npc_dota_hero_razor_3:GetAOERadius()
	return 700
end

modifier_heroTalent_npc_dota_hero_razor_3_thinker = modifier_heroTalent_npc_dota_hero_razor_3_thinker or class({})
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:IsAura()return true end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:GetAuraRadius()return 700 end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:GetModifierAura()return "modifier_heroTalent_npc_dota_hero_razor_3_debuff" end
function modifier_heroTalent_npc_dota_hero_razor_3_thinker:OnCreated(params)
	if IsServer() then
		self.start_time 				= GameRules:GetGameTime()
		self.spirit_summon_interval 	= 0.1
		self.max_spirits				= 10
		self.collision_radius			= 0
		self.explosion_radius			= 0
		self.spirit_radius 				= 0
		self.spirit_min_radius			= 700
		self.spirit_max_radius			= 700
		self.spirit_movement_rate 		= 1000
		self.spirit_turn_rate			= 80
		self:StartIntervalThink(0.03)
		self.spirits_spiritsSpawned = {}
		self.spirits_num_spirits = 0
		self.spirits_movementFactor = 1
		self.center_pos = self:GetParent():GetAbsOrigin() - Vector(0,0,3000)
	end
end

function modifier_heroTalent_npc_dota_hero_razor_3_thinker:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if not parent then
			return
		end
		local caster 					= self:GetCaster()
		local caster_position 			= self.center_pos
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval

		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)

		if self.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_thinker", caster_position, false, caster, caster, caster:GetTeam())


			local pfx = ParticleManager:CreateParticle("particles/rebuild/talent/razor_3/main_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			ParticleManager:SetParticleControlEnt( pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( pfx, 0, newSpirit, PATTACH_POINT_FOLLOW, nil, newSpirit:GetAbsOrigin(), true )



			newSpirit.spirit_pfx = pfx
	

			
			--增加数量记录
			local spiritIndex = self.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			self.spirits_num_spirits = spiritIndex
			self.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_heroTalent_npc_dota_hero_razor_3_thinker2", 
				{ 
					duraiton 			= -1,
					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,

				}
			)
		end
		
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




function modifier_heroTalent_npc_dota_hero_razor_3_thinker:OnDestroy(keys)
	if IsServer() then
		local thinker = self:GetParent()
		for _, unit in ipairs(self.spirits_spiritsSpawned) do
			if unit and not unit:IsNull() then
				local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_razor_3_thinker2")
				if modifier then
					modifier:SetDuration(1,false)
				end
				-- unit:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_razor_3_thinker2")
			end
		end
		UTIL_Remove(self:GetParent())
	end
end
















modifier_heroTalent_npc_dota_hero_razor_3_thinker2 = class({})
function modifier_heroTalent_npc_dota_hero_razor_3_thinker2:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}

	return state
end

function modifier_heroTalent_npc_dota_hero_razor_3_thinker2:OnCreated(params)
	if IsServer() then

		-- self.cooldownTime = GameRules:GetGameTime()
		-- self.currentRadius = 150
		-- self:StartIntervalThink(0.2)
	end
end

function modifier_heroTalent_npc_dota_hero_razor_3_thinker2:OnRemoved()
	if IsServer() then
		local spirit	= self:GetParent()
		if spirit.spirit_pfx~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx, false)
		end
		UTIL_Remove(spirit)
	end
end







modifier_heroTalent_npc_dota_hero_razor_3_debuff = modifier_heroTalent_npc_dota_hero_razor_3_debuff or advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:IsDebuff()return true end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:IsPurgeException()return false end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
		self:SetStackCount(math.min(self:GetStackCount()+5,35))
	end
end

function modifier_heroTalent_npc_dota_hero_razor_3_debuff:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount()+1,35))
end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:OnDestroy()
	if IsServer() then
		if not self:GetParent():IsAlive() then
			local caster = self:GetCaster()
			caster:AddNewModifier( caster,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_razor_3_buff", {stack=self:GetStackCount()*0.8})

		end
	end
end

function modifier_heroTalent_npc_dota_hero_razor_3_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_heroTalent_npc_dota_hero_razor_3_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_heroTalent_npc_dota_hero_razor_3_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_razor_3_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()
end


modifier_heroTalent_npc_dota_hero_razor_3_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_razor_3_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:OnCreated(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax()*2,4000)
        self:SetStackCount(math.min(keys.stack,max_stack))     
        self:StartIntervalThink(0.5)
    end
end

function modifier_heroTalent_npc_dota_hero_razor_3_buff:OnRefresh(keys)
    if IsServer() then
        local max_stack = math.min(self:GetParent():GetDamageMax()*2,4000)
        self:SetStackCount(math.min(self:GetStackCount()+keys.stack,max_stack))     
    end
end

function modifier_heroTalent_npc_dota_hero_razor_3_buff:OnIntervalThink()
    local max_stack = math.min(self:GetParent():GetDamageMax()*2,4000)
    self:SetStackCount(math.min(self:GetStackCount(),max_stack))   
end

function modifier_heroTalent_npc_dota_hero_razor_3_buff:DeclareFunctions() return {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
} end
function modifier_heroTalent_npc_dota_hero_razor_3_buff:GetModifierPreAttack_BonusDamage( params ) return self:GetStackCount() end


function modifier_heroTalent_npc_dota_hero_razor_3_buff:OnWaveEnd()
    self:SafeDestroy()
    return 1
end

function modifier_heroTalent_npc_dota_hero_razor_3_buff:OnWaveStart()
    self:SafeDestroy()
    return 1
end

function modifier_heroTalent_npc_dota_hero_razor_3_buff:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end


