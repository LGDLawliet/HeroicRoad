---@class CScriptParticleManager
CScriptParticleManager = 
{
}
--Creates a new particle effect.
--available:both
---@param particleName string
---@param particleAttach ParticleAttachment_t
---@param owner CDOTA_BaseNPC|nil
---@return ParticleID
function CScriptParticleManager:CreateParticle(particleName,particleAttach,owner)end

--Creates a new particle effect that only plays for the specified player.
--available:both
---@param particleName string
---@param particleAttach ParticleAttachment_t
---@param owner CDOTA_BaseNPC|nil
---@param player CDOTAPlayer
---@return ParticleID
function CScriptParticleManager:CreateParticleForPlayer(particleName,particleAttach,owner,player)end

--Creates a new particle effect that only plays for the specified team.
--available:both
---@param particleName string
---@param particleAttach ParticleAttachment_t
---@param owner CDOTA_BaseNPC|nil
---@param team DOTATeam_t
---@return ParticleID
function CScriptParticleManager:CreateParticleForTeam(particleName,particleAttach,owner,team)end

--Destroy a particle, if bDestroyImmediately destroy it without playing end caps.
--available:both
---@param particle ParticleID
---@param immediate bool
---@return nil
function CScriptParticleManager:DestroyParticle(particle,immediate)end

--
--available:both
---@param particleName string
---@param hero CDOTA_BaseNPC_Hero|nil
---@return string
function CScriptParticleManager:GetParticleReplacement(particleName,hero)end

--Frees the specified particle index.
--available:both
---@param particle ParticleID
---@return nil
function CScriptParticleManager:ReleaseParticleIndex(particle)end

--
--available:both
---@param particle ParticleID
---@return nil
function CScriptParticleManager:SetParticleAlwaysSimulate(particle)end

--Set the control point data for a control on a particle effect.
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param value Vector
---@return nil
function CScriptParticleManager:SetParticleControl(particle,controlPoint,value)end

--
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param unit CDOTA_BaseNPC
---@param particleAttach ParticleAttachment_t
---@param attachment string
---@param offset Vector
---@param lockOrientation bool
---@return nil
function CScriptParticleManager:SetParticleControlEnt(particle,controlPoint,unit,particleAttach,attachment,offset,lockOrientation)end

--
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param vecPosition Vector
---@return nil
function CScriptParticleManager:SetParticleControlFallback(particle,controlPoint,vecPosition)end

--
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param forward Vector
---@return nil
function CScriptParticleManager:SetParticleControlForward(particle,controlPoint,forward)end

--Set the orientation for a control on a particle effect (NOTE: This is left handed -- bad!!).
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param forward Vector
---@param right Vector
---@param up Vector
---@return nil
function CScriptParticleManager:SetParticleControlOrientation(particle,controlPoint,forward,right,up)end

--Set the orientation for a control on a particle effect.
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param vecForward Vector
---@param vecLeft Vector
---@param vecUp Vector
---@return nil
function CScriptParticleManager:SetParticleControlOrientationFLU(particle,controlPoint,vecForward,vecLeft,vecUp)end

--
--available:both
---@param particle ParticleID
---@param controlPoint int
---@param controlPoint2 int
---@param radius float
---@return nil
function CScriptParticleManager:SetParticleFoWProperties(particle,controlPoint,controlPoint2,radius)end

--
--available:both
---@param particle ParticleID
---@param checkFoW bool
---@return bool
function CScriptParticleManager:SetParticleShouldCheckFoW(particle,checkFoW)end

