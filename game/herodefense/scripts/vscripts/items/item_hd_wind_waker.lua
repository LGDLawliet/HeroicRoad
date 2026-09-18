item_hd_wind_waker = class({})

LinkLuaModifier("modifier_item_hd_wind_waker", "items/item_hd_wind_waker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_waker_active", "items/item_hd_wind_waker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_waker_active_2", "items/item_hd_wind_waker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_waker_start", "items/item_hd_wind_waker", LUA_MODIFIER_MOTION_NONE)

function item_hd_wind_waker:GetIntrinsicModifierName()
	return "modifier_item_hd_wind_waker"
end

function item_hd_wind_waker:OnSpellStart()
	local target = self:GetCursorTarget()
	target:EmitSound("DOTA_Item.Cyclone.Activate")
	local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_wind_waker")
	if modifier then
		modifier:OnWaveStart()
	end
		
	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_wind_waker_active", {duration = self:GetSpecialValueFor("active_duration")})
	else
		target:Purge(false, true, false, false, false)
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_wind_waker_active_2", {duration = self:GetSpecialValueFor("active_duration")})
	end
end

--------

modifier_item_hd_wind_waker = advanced_modifier({})

function modifier_item_hd_wind_waker:IsDebuff() return false end
function modifier_item_hd_wind_waker:IsHidden() return true end
function modifier_item_hd_wind_waker:IsPurgable() return false end

function modifier_item_hd_wind_waker:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.max = self.ability:GetSpecialValueFor("max")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_wind_waker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_item_hd_wind_waker:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_Wave_Start = {}
	}
end

function modifier_item_hd_wind_waker:Advanced_GetModifierSpellAmplifyBonus()	return self.bonus_spell_amp end
function modifier_item_hd_wind_waker:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_wind_waker:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_wind_waker:GetModifierMoveSpeedBonus_Constant()	return self.bonus_move end
function modifier_item_hd_wind_waker:OnWaveStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  

   	for i, unit in pairs(units) do
		if unit ~= caster then
           unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_wind_waker_start", {duration = self.duration})
	   	    if i >= self.max then
			    break
		    end
		end
   	end
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_wind_waker_start", {duration = self.duration})
end
------------

modifier_item_hd_wind_waker_active = class({})
function modifier_item_hd_wind_waker_active:IsHidden() return true end
function modifier_item_hd_wind_waker_active:IsPurgable() return true end

function modifier_item_hd_wind_waker_active:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_wind_waker_active:GetEffectAttachType() return PATTACH_POINT end
-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_item_hd_wind_waker_active:GetOverrideAnimation() return ACT_DOTA_FLAIL end
-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end
--------------------------------------------------------------------------------
--[[function modifier_item_hd_wind_waker_active:GetModifierTurnRate_Percentage( params )
	return -self.storm_decreased_turn_rate
end]]
-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active:OnCreated( kv )
	

	if IsServer() then
		--[[if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end]]

		--[[if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end]]


		self.storm_move_speed = 100

		self.interval = FrameTime()
		self.vForward = self:GetParent():GetForwardVector()
		self.rotation = (360 / self:GetDuration()) * self.storm_move_speed
		self.next_step = 0
		
		self:StartIntervalThink(FrameTime())

		
	end
end

-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active:OnDestroy()
	self.effect = nil 
	if IsServer() then
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
		self.storm_move_speed = nil 
		self.interval = nil 
		self.vForward = nil 
		self.rotation = nil 
		self.next_step = nil
	end
end

function modifier_item_hd_wind_waker_active:OnIntervalThink()
	--vVelocity
	local height = 256
	local gravity_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0) / 2
	local vNewPos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	vNewPos.z = vNewPos.z - 4 * height * gravity_progress ^ 2 + 4 * height * gravity_progress
	--pos
	self:GetParent():SetAbsOrigin(vNewPos)
	self.vForward = RotatePosition(Vector(0, 0, 0), QAngle(0, self.interval * self.rotation, 0), self.vForward)
	--facing
	self.next_step = self.next_step + 25
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	self:GetParent():SetForwardVector( self.facing )

end



















modifier_item_hd_wind_waker_active_2 = class({})
function modifier_item_hd_wind_waker_active_2:IsHidden() return true end
function modifier_item_hd_wind_waker_active_2:IsPurgable() return true end

function modifier_item_hd_wind_waker_active_2:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_wind_waker_active_2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active_2:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	} 
end
function modifier_item_hd_wind_waker_active_2:GetVisualZDelta( params )
	return 512
end
function modifier_item_hd_wind_waker_active_2:GetOverrideAnimation() return ACT_DOTA_FLAIL end
-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active_2:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return state
end
--------------------------------------------------------------------------------
--[[function modifier_item_hd_wind_waker_active_2:GetModifierTurnRate_Percentage( params )
	return -self.storm_decreased_turn_rate
end]]
-----------------------------------------------------------------------------------------


function modifier_item_hd_wind_waker_active_2:GetModifierMoveSpeedOverride()return self:GetAbility():GetSpecialValueFor("active_move") end


-----------------------------------------------------------------------------------------
function modifier_item_hd_wind_waker_active_2:OnDestroy()
	self.effect = nil 
	if IsServer() then
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
		self:GetParent():Purge(false, true, false, false, false)
	end
end

-- function modifier_item_hd_wind_waker_active_2:OnCreated( kv )
	

-- 	if IsServer() then
-- 		--[[if self:ApplyHorizontalMotionController() == false then 
-- 			self:Destroy()
-- 			return
-- 		end]]

-- 		--[[if self:ApplyVerticalMotionController() == false then 
-- 			self:Destroy()
-- 			return
-- 		end]]


-- 		self.storm_move_speed = 100

-- 		self.interval = FrameTime()
-- 		self.vForward = self:GetParent():GetForwardVector()
-- 		self.rotation = (360 / self:GetDuration()) * self.storm_move_speed
-- 		self.next_step = 0
		
-- 		self:StartIntervalThink(FrameTime())

		
-- 	end
-- end


-- function modifier_item_hd_wind_waker_active_2:OnIntervalThink()
-- 	--vVelocity
-- 	-- local height = 512
-- 	local gravity_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0) / 2
-- 	-- local vNewPos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
-- 	-- vNewPos.z = vNewPos.z - 4 * height * gravity_progress ^ 2 + 4 * height * gravity_progress
-- 	--pos
-- 	-- self:GetParent():SetAbsOrigin(vNewPos)
-- 	self.vForward = RotatePosition(Vector(0, 0, 0), QAngle(0, self.interval * self.rotation, 0), self.vForward)
-- 	--facing
-- 	self.next_step = self.next_step + 25
-- 	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
-- 	self:GetParent():SetForwardVector( self.facing )

-- end





modifier_item_hd_wind_waker_start = advanced_modifier({})

function modifier_item_hd_wind_waker_start:IsDebuff() return false end
function modifier_item_hd_wind_waker_start:IsHidden() return false end
function modifier_item_hd_wind_waker_start:IsPurgable() return false end
function modifier_item_hd_wind_waker_start:GetTexture() return "item_wind_waker" end

function modifier_item_hd_wind_waker_start:DeclareFunctions(keys)
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

end
function modifier_item_hd_wind_waker_start:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("move")
end
function modifier_item_hd_wind_waker_start:GetModifierIgnoreMovespeedLimit()
	return 1
end