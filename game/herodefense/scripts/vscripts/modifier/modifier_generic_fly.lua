modifier_generic_fly = class({})

function modifier_generic_fly:IsHidden()	return true end
function modifier_generic_fly:IsDebuff()	return true end
function modifier_generic_fly:IsPurgable() 		    return false end
function modifier_generic_fly:IsPurgeException() return false end
function modifier_generic_fly:RemoveOnDeath() return false end

function modifier_generic_fly:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = IsServer(), 
    }
end

function modifier_generic_fly:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_generic_fly:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_generic_fly:OnCreated(keys)
    if IsServer() then
        self.turn = keys.turn
        self.height = keys.height
		self.forward = self:GetParent():GetForwardVector()
		self.next_step = 0
        self:StartIntervalThink(FrameTime())
    end
end


function modifier_generic_fly:OnIntervalThink()
    local unit = self:GetParent()

	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self.height
	local next_pos = GetGroundPosition(unit:GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)


	self.next_step = self.next_step + 33
	

    if self.turn == true then
        self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, self.next_step ,0 ), Vector(0,1,0) )
	    unit:SetForwardVector( self.facing )
    end
end


function modifier_generic_fly:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin(),true)
		self:GetParent():SetForwardVector( self.forward )
    end
end