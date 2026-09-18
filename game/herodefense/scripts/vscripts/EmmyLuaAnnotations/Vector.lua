---@class Vector
Vector = 
{
	--X-axis
	---@type float
	x = nil;

	--Y-axis
	---@type float
	y = nil;

	--Z-axis
	---@type float
	z = nil;

}
--Overloaded +. Adds vectors together.
--available:both
---@param b Vector
---@return Vector
function Vector:__add(b)end

--Overloaded /. Divides vectors.
--available:both
---@param b Vector
---@return Vector
function Vector:__div(b)end

--Overloaded ==. Tests for Equality.
--available:both
---@param b Vector
---@return bool
function Vector:__eq(b)end

--Overloaded # returns the length of the vector.
--available:both
---@return float
function Vector:__len()end

--Overloaded * returns the vectors multiplied together. Can also be used to multiply with scalars.
--available:both
---@param b Vector|float
---@return Vector
function Vector:__mul(b)end

--Overloaded -. Subtracts vectors.
--available:both
---@param b Vector
---@return Vector
function Vector:__sub(b)end

--Overloaded .. Converts vectors to strings.
--available:both
---@return string
function Vector:__tostring()end

--Overloaded - operator. Reverses the vector.
--available:both
---@return Vector
function Vector:__unm()end

--Cross product of two vectors.
--available:both
---@param b Vector
---@return Vector
function Vector:Cross(b)end

--Dot product of two vectors.
--available:both
---@param b Vector
---@return float
function Vector:Dot(b)end

--Length of the Vector.
--available:both
---@return float
function Vector:Length()end

--Length of the Vector in the XY plane.
--available:both
---@return float
function Vector:Length2D()end

--Returns the vector normalized.
--available:both
---@return Vector
function Vector:Normalized()end

--Linearly interpolates between two vectors.\nThis is most commonly used to find a point some fraction of the way along a line between two endpoints.\nSame as `this + (b - this) * t`.
--available:both
---@param b Vector
---@param t float
---@return Vector
function Vector:Lerp(b,t)end

