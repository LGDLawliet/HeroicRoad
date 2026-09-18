---@class CBaseModelEntity : CBaseEntity
CBaseModelEntity = 
{
}
--Get the attachment id's angles as a p,y,r vector.
--available:server
---@param attachment int
---@return Vector
function CBaseModelEntity:GetAttachmentAngles(attachment)end

--Get the attachment id's forward vector.
--available:server
---@param attachment int
---@return Vector
function CBaseModelEntity:GetAttachmentForward(attachment)end

--Get the attachment id's origin vector.
--available:server
---@param attachment int
---@return Vector
function CBaseModelEntity:GetAttachmentOrigin(attachment)end

--Get the material group hash of this entity.
--available:server
---@return uint
function CBaseModelEntity:GetMaterialGroupHash()end

--Get the mesh group mask of this entity.
--available:server
---@return Uint64
function CBaseModelEntity:GetMaterialGroupMask()end

--Get scale of entity's model.
--available:server
---@return float
function CBaseModelEntity:GetModelScale()end

--Get the alpha modulation of this entity.
--available:both
---@return int
function CBaseModelEntity:GetRenderAlpha()end

--Get the render color of the entity.
--available:server
---@return Vector
function CBaseModelEntity:GetRenderColor()end

--Get the named attachment id.
--available:server
---@param attachmentName string
---@return int
function CBaseModelEntity:ScriptLookupAttachment(attachmentName)end

--Sets a bodygroup.
--available:server
---@param group int
---@param value int
---@return nil
function CBaseModelEntity:SetBodygroup(group,value)end

--Sets a bodygroup by name.
--available:server
---@param name string
---@param value int
---@return nil
function CBaseModelEntity:SetBodygroupByName(name,value)end

--Sets the light group of the entity.
--available:server
---@param lightGroup string
---@return nil
function CBaseModelEntity:SetLightGroup(lightGroup)end

--Set the material group of this entity.
--available:server
---@param materialGroup string
---@return nil
function CBaseModelEntity:SetMaterialGroup(materialGroup)end

--Set the material group hash of this entity.
--available:server
---@param hash uint
---@return nil
function CBaseModelEntity:SetMaterialGroupHash(hash)end

--Set the mesh group mask of this entity.
--available:server
---@param meshGroupMask Uint64
---@return nil
function CBaseModelEntity:SetMaterialGroupMask(meshGroupMask)end

--
--available:server
---@param modelName string
---@return nil
function CBaseModelEntity:SetModel(modelName)end

--Set scale of entity's model.
--available:server
---@param scale float
---@return nil
function CBaseModelEntity:SetModelScale(scale)end

--Set the alpha modulation of this entity.
--available:server
---@param alpha int
---@return nil
function CBaseModelEntity:SetRenderAlpha(alpha)end

--Sets the render color of the entity.
--available:server
---@param r int
---@param g int
---@param b int
---@return nil
function CBaseModelEntity:SetRenderColor(r,g,b)end

--Sets the render mode of the entity.
--available:server
---@param mode int
---@return nil
function CBaseModelEntity:SetRenderMode(mode)end

--Set a single mesh group for this entity.
--available:server
---@param meshGroupName string
---@return nil
function CBaseModelEntity:SetSingleMeshGroup(meshGroupName)end

--
--available:server
---@param mins Vector
---@param maxs Vector
---@return nil
function CBaseModelEntity:SetSize(mins,maxs)end

--
--available:server
---@param skin int
---@return nil
function CBaseModelEntity:SetSkin(skin)end

