---@class QAngle
QAngle = 
{
	--Pitch angle
	---@type float
	x = nil;

	--Yaw angle
	---@type float
	y = nil;

	--Roll angle
	---@type float
	z = nil;

}
--Overloaded +. Adds angles together.
--available:both
---@param b QAngle
---@return QAngle
function QAngle:__add(b)end

--Overloaded ==. Tests for Equality.
--available:both
---@param b QAngle
---@return bool
function QAngle:__eq(b)end

--Overloaded .. Converts the QAngles to strings.
--available:both
---@return string
function QAngle:__tostring()end

--Returns the forward vector.
--available:both
---@return Vector
function QAngle:Forward()end

--Returns the left vector.
--available:both
---@return Vector
function QAngle:Left()end

--Returns the up vector.
--available:both
---@return Vector
function QAngle:Up()end

