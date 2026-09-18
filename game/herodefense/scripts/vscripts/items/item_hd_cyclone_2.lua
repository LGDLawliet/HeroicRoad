item_hd_cyclone_2 = class({})

LinkLuaModifier("modifier_item_hd_cyclone_2", "items/item_hd_cyclone_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_cyclone_2_active", "items/item_hd_cyclone_2", LUA_MODIFIER_MOTION_NONE)


function item_hd_cyclone_2:GetIntrinsicModifierName()
	return "modifier_item_hd_cyclone_2"
end
-------------------------------------------------------------------------------------------
function item_hd_cyclone_2:OnSpellStart()
	local target = self:GetCursorTarget()
		target:EmitSound("DOTA_Item.Cyclone.Activate")
		
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then

			target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_cyclone_2_active", {duration = self:GetSpecialValueFor("duration")})
		else
			target:Purge(false, true, false, false, false)
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_cyclone_2_active", {duration = self:GetSpecialValueFor("duration")})
		end

end

--------------------------------------------------------------------------------------------

modifier_item_hd_cyclone_2 = class({})

function modifier_item_hd_cyclone_2:IsDebuff() return false end
function modifier_item_hd_cyclone_2:IsHidden() return true end
function modifier_item_hd_cyclone_2:IsPurgable() return false end

function modifier_item_hd_cyclone_2:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

end



function modifier_item_hd_cyclone_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	
	}
end


function modifier_item_hd_cyclone_2:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_cyclone_2:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_cyclone_2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end






modifier_item_hd_cyclone_2_active = advanced_modifier({})
function modifier_item_hd_cyclone_2_active:IsHidden() return true end
function modifier_item_hd_cyclone_2_active:IsPurgable() return true end

function modifier_item_hd_cyclone_2_active:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_cyclone_2_active:GetEffectAttachType() return PATTACH_POINT end
-----------------------------------------------------------------------------------------
function modifier_item_hd_cyclone_2_active:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_item_hd_cyclone_2_active:GetOverrideAnimation() return ACT_DOTA_FLAIL end
-----------------------------------------------------------------------------------------
function modifier_item_hd_cyclone_2_active:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end
--------------------------------------------------------------------------------
--[[function modifier_item_hd_cyclone_2_active:GetModifierTurnRate_Percentage( params )
	return -self.storm_decreased_turn_rate
end]]
-----------------------------------------------------------------------------------------
function modifier_item_hd_cyclone_2_active:OnCreated( kv )
	

	if IsServer() then
		self.storm_move_speed = 100
		self.interval = FrameTime()
		self.vForward = self:GetParent():GetForwardVector()
		self.rotation = (360 / self:GetDuration()) * self.storm_move_speed
		self.next_step = 0
		self:StartIntervalThink(FrameTime())
	end
end
-----------------------------------------------------------------------------------------
function modifier_item_hd_cyclone_2_active:OnDestroy()
	self.effect = nil 
	if IsServer() then
		--self:GetParent():RemoveHorizontalMotionController( self )
		--self:GetParent():RemoveVerticalMotionController( self )

		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
		if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			self:GetParent():Purge(false, true, false, false, false)
		end
		self.storm_move_speed = nil 
		self.interval = nil 
		self.vForward = nil 
		self.rotation = nil 
		self.next_step = nil
	end
end

function modifier_item_hd_cyclone_2_active:OnIntervalThink()
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

function modifier_item_hd_cyclone_2_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,
		-- advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_item_hd_cyclone_2_active:Advanced_GetModifier_Flying()	
	return 1
end
