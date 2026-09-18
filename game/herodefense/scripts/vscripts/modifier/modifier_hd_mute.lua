
modifier_hd_mute = class({})

--------------------------------------------------------------------------------

function modifier_hd_mute:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hd_mute:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hd_mute:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end



--------------------------------------------------------------------------------

function modifier_hd_mute:CheckState()
	local state =
	{

		[MODIFIER_STATE_MUTED] = true,

	}

	return state
end
