

modifier_Respawn_weak_target = class({})


function modifier_Respawn_weak_target:IsHidden()return false end
function modifier_Respawn_weak_target:IsDebuff()return true end
function modifier_Respawn_weak_target:IsStunDebuff()return false end
function modifier_Respawn_weak_target:IsPurgable()return false end
function modifier_Respawn_weak_target:GetTexture() return "bane_enfeeble" end
function modifier_Respawn_weak_target:IsPurgeException() 	return false end
function modifier_Respawn_weak_target:RemoveOnDeath() return false end
function modifier_Respawn_weak_target:GetAttributes() 	
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

