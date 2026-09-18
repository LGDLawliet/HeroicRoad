---@class CBodyComponent
CBodyComponent = 
{
}
--Apply an impulse at a worldspace position to the physics.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@return nil
function CBodyComponent:AddImpulseAtPosition(arg1,arg2)end

--Add linear and angular velocity to the physics object.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@return nil
function CBodyComponent:AddVelocity(arg1,arg2)end

--Detach from its parent.
--available:both
---@return nil
function CBodyComponent:DetachFromParent()end

--Returns the active sequence.
--available:both
---@return unknown
function CBodyComponent:GetSequence()end

--Is attached to parent.
--available:both
---@return bool
function CBodyComponent:IsAttachedToParent()end

--Returns a sequence id given a name.
--available:both
---@param arg1 string
---@return unknown
function CBodyComponent:LookupSequence(arg1)end

--Returns the duration in seconds of the specified sequence.
--available:both
---@param arg1 string
---@return float
function CBodyComponent:SequenceDuration(arg1)end

--
--available:both
---@param arg1 Vector
---@return nil
function CBodyComponent:SetAngularVelocity(arg1)end

--Pass string for the animation to play on this model.
--available:both
---@param arg1 string
---@return nil
function CBodyComponent:SetAnimation(arg1)end

--
--available:both
---@param arg1 string
---@return nil
function CBodyComponent:SetMaterialGroup(arg1)end

--
--available:both
---@param arg1 Vector
---@return nil
function CBodyComponent:SetVelocity(arg1)end

