---@class Uint64
Uint64 = 
{
}
--
--available:server
---@param b Uint64
---@return bool
function Uint64:__eq(b)end

--Overloaded .. Converts Uint64s to strings.
--available:server
---@return string
function Uint64:__tostring()end

--Performs bitwise AND between two integers.
--available:server
---@param operand Uint64
---@return Uint64
function Uint64:BitwiseAnd(operand)end

--Performs bitwise OR between two integers.
--available:server
---@param operand Uint64
---@return Uint64
function Uint64:BitwiseOr(operand)end

--Performs bitwise XOR between two integers.
--available:server
---@param operand Uint64
---@return Uint64
function Uint64:BitwiseXor(operand)end

--Performs bitwise NOT.
--available:server
---@return Uint64
function Uint64:BitwiseNot()end

--Sets the specified bit.
--available:server
---@param bitvalue int
---@return nil
function Uint64:SetBit(bitvalue)end

--Clears the specified bit.
--available:server
---@param bitvalue int
---@return int
function Uint64:ClearBit(bitvalue)end

--Checks if bit is set.
--available:server
---@param bitvalue int
---@return int,nil
function Uint64:IsBitSet(bitvalue)end

--Toggles the specified bit.
--available:server
---@param bitvalue int
---@return int
function Uint64:ToggleBit(bitvalue)end

--Returns a hexadecimal string representation of the integer.
--available:server
---@return string
function Uint64:ToHexString()end

