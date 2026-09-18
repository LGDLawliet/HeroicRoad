
modifier_thinker_INVULNERABLE = modifier_thinker_INVULNERABLE or class({})
function modifier_thinker_INVULNERABLE:IsHidden()	return false end
function modifier_thinker_INVULNERABLE:IsDebuff()	return false end
function modifier_thinker_INVULNERABLE:IsPurgable()	return false end
function modifier_thinker_INVULNERABLE:IsPurgeException()	return false end
function modifier_thinker_INVULNERABLE:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_thinker_INVULNERABLE:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVISIBLE] = true,

	}
end
