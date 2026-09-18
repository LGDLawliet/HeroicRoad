---@class GridNav
GridNav = 
{
}
--Determine if it is possible to reach the specified end point from the specified start point. bool.
--available:server
---@param start Vector
---@param _end Vector
---@return bool
function GridNav:CanFindPath(start,_end)end

--Destroy all trees in the area(vPosition, flRadius, bFullCollision.
--available:server
---@param arg1 Vector
---@param arg2 float
---@param arg3 bool
---@return nil
function GridNav:DestroyTreesAroundPoint(arg1,arg2,arg3)end

--Find a path between the two points an return the length of the path. If there is not a path between the points the returned value will be -1.
--available:server
---@param start Vector
---@param _end Vector
---@return float
function GridNav:FindPathLength(start,_end)end

--Returns a table full of tree HSCRIPTS.
--available:server
---@param position Vector
---@param radius float
---@param fullCollision bool
---@return CDOTA_MapTree[]
function GridNav:GetAllTreesAroundPoint(position,radius,fullCollision)end

--Get the X position of the center of a given X index.
--available:server
---@param arg1 int
---@return float
function GridNav:GridPosToWorldCenterX(arg1)end

--Get the Y position of the center of a given Y index.
--available:server
---@param arg1 int
---@return float
function GridNav:GridPosToWorldCenterY(arg1)end

--Checks whether the given position is blocked.
--available:server
---@param arg1 Vector
---@return bool
function GridNav:IsBlocked(arg1)end

--Checks whether there are any trees overlapping the given point.
--available:server
---@param position Vector
---@param radius float
---@param checkFullTreeRadius bool
---@return bool
function GridNav:IsNearbyTree(position,radius,checkFullTreeRadius)end

--Checks whether the given position is traversable.
--available:server
---@param arg1 Vector
---@return bool
function GridNav:IsTraversable(arg1)end

--Causes all trees in the map to regrow.
--available:server
---@return nil
function GridNav:RegrowAllTrees()end

--Get the X index of a given world X position.
--available:server
---@param arg1 float
---@return int
function GridNav:WorldToGridPosX(arg1)end

--Get the Y index of a given world Y position.
--available:server
---@param arg1 float
---@return int
function GridNav:WorldToGridPosY(arg1)end

