modifier_hd_trigger = advanced_modifier({})
function modifier_hd_trigger:GetTexture()
	return "action_lock_green"
end
function modifier_hd_trigger:IsHidden() return false end
function modifier_hd_trigger:IsDebuff() return false end
function modifier_hd_trigger:IsPurgable() return false end
function modifier_hd_trigger:IsPurgeException() return false end
function modifier_hd_trigger:RemoveOnDeath() return false end
function modifier_hd_trigger:DestroyOnExpire() return false end
function modifier_hd_trigger:IsStunDebuff() return false end
function modifier_hd_trigger:AllowIllusionDuplicate() return false end
function modifier_hd_trigger:OnCreated(keys)
	if IsServer() then
		self.cost_get = keys.cost_get or 0
        self:SetStackCount(self:GetStackCount() + self.cost_get)
	end
end
function modifier_hd_trigger:OnRefresh(keys)
	if IsServer() then
		self.cost_get = keys.cost_get or 0
        self:SetStackCount(self:GetStackCount() + self.cost_get)
	end
end