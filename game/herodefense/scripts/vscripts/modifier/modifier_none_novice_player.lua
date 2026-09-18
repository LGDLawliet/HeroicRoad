
--------------------------------------------------------------------------------
modifier_none_novice_player = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_none_novice_player:IsHidden()return true end
function modifier_none_novice_player:IsDebuff()return false end
function modifier_none_novice_player:IsStunDebuff()return false end
function modifier_none_novice_player:IsPurgable()return false end
function modifier_none_novice_player:GetTexture() return "marci_unleash" end
function modifier_none_novice_player:IsPurgeException() 	return false end
function modifier_none_novice_player:RemoveOnDeath() return false end

