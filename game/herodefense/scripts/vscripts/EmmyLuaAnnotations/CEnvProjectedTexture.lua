---@class CEnvProjectedTexture : CBaseEntity
CEnvProjectedTexture = 
{
}
--Set light maximum range.
--available:server
---@param range float
---@return nil
function CEnvProjectedTexture:SetFarRange(range)end

--Set light linear attenuation value.
--available:server
---@param atten float
---@return nil
function CEnvProjectedTexture:SetLinearAttenuation(atten)end

--Set light minimum range.
--available:server
---@param range float
---@return nil
function CEnvProjectedTexture:SetNearRange(range)end

--Set light quadratic attenuation value.
--available:server
---@param atten float
---@return nil
function CEnvProjectedTexture:SetQuadraticAttenuation(atten)end

--Turn on/off light volumetrics.
--available:server
---@param on bool
---@param intensity float
---@param noise float
---@param planes int
---@param planeOffset float
---@return nil
function CEnvProjectedTexture:SetVolumetrics(on,intensity,noise,planes,planeOffset)end

