modifier_true_sight_dummy = class({})
function modifier_true_sight_dummy:IsHidden() return true end
function modifier_true_sight_dummy:IsPurgable() return false end
function modifier_true_sight_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end

function modifier_true_sight_dummy:IsAura() return true end
function modifier_true_sight_dummy:GetAuraRadius()return self:GetStackCount() end
function modifier_true_sight_dummy:GetModifierAura() return "modifier_truesight" end
function modifier_true_sight_dummy:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_true_sight_dummy:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_true_sight_dummy:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
function modifier_true_sight_dummy:GetAuraDuration() return 0.5 end
function modifier_true_sight_dummy:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end


function modifier_true_sight_dummy:OnDestroy()
	if IsServer() then

		UTIL_Remove(self:GetParent())
		
	end
end
