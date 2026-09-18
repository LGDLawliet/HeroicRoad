---@class CPointClientUIWorldPanel : CBaseModelEntity
CPointClientUIWorldPanel = 
{
}
--Tells the panel to accept user input.
--available:server
---@return nil
function CPointClientUIWorldPanel:AcceptUserInput()end

--Adds CSS class(es) to the panel.
--available:server
---@param classes string
---@return nil
function CPointClientUIWorldPanel:AddCSSClasses(classes)end

--Tells the panel to ignore user input.
--available:server
---@return nil
function CPointClientUIWorldPanel:IgnoreUserInput()end

--Returns whether this entity is grabbable.
--available:server
---@return bool
function CPointClientUIWorldPanel:IsGrabbable()end

--Remove CSS class(es) from the panel.
--available:server
---@param classes string
---@return nil
function CPointClientUIWorldPanel:RemoveCSSClasses(classes)end

