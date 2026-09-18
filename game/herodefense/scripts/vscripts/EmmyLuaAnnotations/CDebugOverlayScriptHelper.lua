---@class CDebugOverlayScriptHelper
CDebugOverlayScriptHelper = 
{
}
--Draws an axis. Specify origin + orientation in world space.
--available:both
---@param arg1 Vector
---@param arg2 Quaternion
---@param arg3 float
---@param arg4 bool
---@param arg5 float
---@return nil
function CDebugOverlayScriptHelper:Axis(arg1,arg2,arg3,arg4,arg5)end

--Draws a world-space axis-aligned box. Specify bounds in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:Box(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws an oriented box at the origin. Specify bounds in local space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@param arg4 Quaternion
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:BoxAngles(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws a capsule. Specify base in world space.
--available:both
---@param arg1 Vector
---@param arg2 Quaternion
---@param arg3 float
---@param arg4 float
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:Capsule(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws a circle. Specify center in world space.
--available:both
---@param arg1 Vector
---@param arg2 Quaternion
---@param arg3 float
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:Circle(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a circle oriented to the screen. Specify center in world space.
--available:both
---@param arg1 Vector
---@param arg2 float
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:CircleScreenOriented(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws a wireframe cone. Specify endpoint and direction in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@param arg4 float
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:Cone(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws a screen-aligned cross. Specify origin in world space.
--available:both
---@param arg1 Vector
---@param arg2 float
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:Cross(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws a world-aligned cross. Specify origin in world space.
--available:both
---@param arg1 Vector
---@param arg2 float
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:Cross3D(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws an oriented cross. Specify origin in world space.
--available:both
---@param arg1 Vector
---@param arg2 Quaternion
---@param arg3 float
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:Cross3DOriented(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a dashed line. Specify endpoints in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:DrawTickMarkedLine(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws the attachments of the entity.
--available:both
---@param arg1 ehandle
---@param arg2 float
---@param arg3 float
---@return nil
function CDebugOverlayScriptHelper:EntityAttachments(arg1,arg2,arg3)end

--Draws the axis of the entity origin.
--available:both
---@param arg1 ehandle
---@param arg2 float
---@param arg3 bool
---@param arg4 float
---@return nil
function CDebugOverlayScriptHelper:EntityAxis(arg1,arg2,arg3,arg4)end

--Draws bounds of an entity.
--available:both
---@param arg1 ehandle
---@param arg2 int
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 bool
---@param arg7 float
---@return nil
function CDebugOverlayScriptHelper:EntityBounds(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--Draws the skeleton of the entity.
--available:both
---@param arg1 ehandle
---@param arg2 float
---@return nil
function CDebugOverlayScriptHelper:EntitySkeleton(arg1,arg2)end

--Draws text on an entity.
--available:both
---@param arg1 ehandle
---@param arg2 int
---@param arg3 string
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:EntityText(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws a screen-space filled 2D rectangle. Coordinates are in pixels.
--available:both
---@param arg1 Vector2D
---@param arg2 Vector2D
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 float
---@return nil
function CDebugOverlayScriptHelper:FilledRect2D(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--Draws a horizontal arrow. Specify endpoints in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:HorzArrow(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a line between two points.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:Line(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws a line between two points in screenspace.
--available:both
---@param arg1 Vector2D
---@param arg2 Vector2D
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 float
---@return nil
function CDebugOverlayScriptHelper:Line2D(arg1,arg2,arg3,arg4,arg5,arg6,arg7)end

--Pops the identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
--available:both
---@return nil
function CDebugOverlayScriptHelper:PopDebugOverlayScope()end

--Pushes an identifier used to group overlays. Deletes all existing overlays using this overlay id.
--available:both
---@param arg1 string
---@return nil
function CDebugOverlayScriptHelper:PushAndClearDebugOverlayScope(arg1)end

--Pushes an identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
--available:both
---@param arg1 string
---@return nil
function CDebugOverlayScriptHelper:PushDebugOverlayScope(arg1)end

--Removes all overlays marked with a specific identifier, regardless of their lifetime.
--available:both
---@param arg1 string
---@return nil
function CDebugOverlayScriptHelper:RemoveAllInScope(arg1)end

--Draws a solid cone. Specify endpoint and direction in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@param arg4 float
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:SolidCone(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws a wireframe sphere. Specify center in world space.
--available:both
---@param arg1 Vector
---@param arg2 float
---@param arg3 int
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 bool
---@param arg8 float
---@return nil
function CDebugOverlayScriptHelper:Sphere(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)end

--Draws a swept box. Specify endpoints in world space and the bounds in local space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@param arg4 Vector
---@param arg5 Quaternion
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 int
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:SweptBox(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws 2D text. Specify origin in world space.
--available:both
---@param arg1 Vector
---@param arg2 int
---@param arg3 string
---@param arg4 float
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:Text(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a screen-space texture. Coordinates are in pixels.
--available:both
---@param arg1 string
---@param arg2 Vector2D
---@param arg3 Vector2D
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 Vector2D
---@param arg9 Vector2D
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:Texture(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

--Draws a filled triangle. Specify vertices in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 Vector
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:Triangle(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Toggles the overlay render type, for unit tests.
--available:both
---@return nil
function CDebugOverlayScriptHelper:UnitTestCycleOverlayRenderType()end

--Draws 3D text. Specify origin + orientation in world space.
--available:both
---@param arg1 Vector
---@param arg2 Quaternion
---@param arg3 string
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:VectorText3D(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a vertical arrow. Specify endpoints in world space.
--available:both
---@param arg1 Vector
---@param arg2 Vector
---@param arg3 float
---@param arg4 int
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 bool
---@param arg9 float
---@return nil
function CDebugOverlayScriptHelper:VertArrow(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)end

--Draws a arrow associated with a specific yaw. Specify endpoints in world space.
--available:both
---@param arg1 Vector
---@param arg2 float
---@param arg3 float
---@param arg4 float
---@param arg5 int
---@param arg6 int
---@param arg7 int
---@param arg8 int
---@param arg9 bool
---@param arg10 float
---@return nil
function CDebugOverlayScriptHelper:YawArrow(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)end

