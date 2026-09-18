--[[
用于玩家数量提升的难度提升（base）
]]
--------------------------------------------------------------------------------
modifier_creeps_gain_base_player_number = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_gain_base_player_number:IsHidden()return true end
function modifier_creeps_gain_base_player_number:IsDebuff()return false end
function modifier_creeps_gain_base_player_number:IsStunDebuff()return false end
function modifier_creeps_gain_base_player_number:IsPurgable()return false end
function modifier_creeps_gain_base_player_number:IsPurgeException() 	return false end

function modifier_creeps_gain_base_player_number:GetTexture()
    return "mars_bulwark"
end


function modifier_creeps_gain_base_player_number:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end


function modifier_creeps_gain_base_player_number:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end



function modifier_creeps_gain_base_player_number:AdvancedGetModifierExtraHealthPercentage()
    local gain={
        10,
        20,
        30,
        50,
        80,
    }
	return gain[self:GetStackCount()]
end