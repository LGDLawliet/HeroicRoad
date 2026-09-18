--[[
	给一个在某个方向上的速度  如果处于任何motion_controller中 则停止

]] 



modifier_generic_dir_speed = advanced_modifier({})


function modifier_generic_dir_speed:IsHidden() return true end
function modifier_generic_dir_speed:IsDebuff() return true end
function modifier_generic_dir_speed:IsPurgable() return false end
function modifier_generic_dir_speed:IsPurgeException() return false end
function modifier_generic_dir_speed:AllowIllusionDuplicate() return false end
function modifier_generic_dir_speed:RemoveOnDeath() return false end
function modifier_generic_dir_speed:GetMotionPriority() return MODIFIER_PRIORITY_LOW  end
function modifier_generic_dir_speed:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_generic_dir_speed:InitKnockBack(dir,speed)
    self.speed = speed
    self.dir = dir
    self:StartIntervalThink(0)
end
function modifier_generic_dir_speed:SetShouldFindPath(bFindPath)
    self.bFindPath = bFindPath
end

function modifier_generic_dir_speed:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
        if self.callback then
            self.callback()
        end
	end
end


function modifier_generic_dir_speed:OnIntervalThink()
	local me = self:GetParent()
    if me:IsCurrentlyHorizontalMotionControlled() or me:IsCurrentlyVerticalMotionControlled() then
        self:SetDuration(0.1, false)
        return
    end
    if me:IsOutOfGame() then
        self:SetDuration(0.1, false)
        return
    end
    if me:IsInvulnerable() then
        self:SetDuration(0.1, false)
        return
    end
    self:UpdateHorizontalMotion(me,FrameTime())
end

function modifier_generic_dir_speed:UpdateHorizontalMotion(me, dt)
    local new_pos = me:GetAbsOrigin() + self.dir * (self.speed / (1.0 / dt))  
    new_pos = GetGroundPosition(new_pos, nil)   
    if self.bFindPath==true then
        if GridNav:CanFindPath(me:GetOrigin(), new_pos) then
            me:SetOrigin(new_pos)  
        end
    else
        me:SetOrigin(new_pos)  
    end


   
    ResolveNPCPositions(new_pos, 70)

end
function modifier_generic_dir_speed:OnHorizontalMotionInterrupted()

end

function modifier_generic_dir_speed:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_generic_dir_speed:SetCallback(callback)
    self.callback = callback
end