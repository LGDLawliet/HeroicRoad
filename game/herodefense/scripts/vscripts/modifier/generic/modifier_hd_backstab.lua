
modifier_hd_backstab = advanced_modifier({})

function modifier_hd_backstab:OnCreated(params)
	self.always_backstab = false
end

function modifier_hd_backstab:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_hd_backstab:DeclareFunctions()
return {
	MODIFIER_PROPERTY_TOOLTIP,
}
end

function modifier_hd_backstab:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then
				return 
			end
			if (self:IsBackstab(params.attacker, params.target) or self.always_backstab) and self:GetStackCount() >= 0 then
				local backstab_multiplier = 25 + self:GetStackCount()
				self:SetStackCount(math.max(self:GetStackCount()-1,0))
				return	backstab_multiplier
			end
		end
	end
end

function modifier_hd_backstab:IsBackstab(attacker, target)
	if not attacker or not target then
		return false
	end
	local angle = 90
	local attacker_forward_vector = attacker:GetForwardVector()
	local victim_forward_vector = target:GetForwardVector()
	local nAngle = math.abs(AngleDiff(VectorToAngles(attacker_forward_vector).y, VectorToAngles(victim_forward_vector).y))
	-- print( nAngle <= angle)
	if nAngle <= angle then
		return true
	end
	return false 
end

function modifier_hd_backstab:OnTooltip()
	return 25 + self:GetStackCount()
end

function modifier_hd_backstab:AlwaysBackstab(duration)
	self.always_backstab = true
	Timers:CreateTimer(duration, function()
		self.always_backstab = false
	end)
end
------------------------------------------------