modifier_item_set_storm_active = advanced_modifier({})

function modifier_item_set_storm_active:IsDebuff()return true end
function modifier_item_set_storm_active:IsHidden()return false end
function modifier_item_set_storm_active:IsPurgable()return false end
function modifier_item_set_storm_active:RemoveOnDeath()return false end
function modifier_item_set_storm_active:GetTexture() return "disruptor_static_storm" end

function modifier_item_set_storm_active:OnCreated(keys)
	if IsServer() then
        --if not keys.stack==nil then
		    self:SetStackCount(keys.stack)
        --end
	end
end

function modifier_item_set_storm_active:OnRefresh(keys)
	if IsServer() then
        --if not keys.stack==nil then
		    self:SetStackCount(keys.stack)
        --end
	end
end

function modifier_item_set_storm_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_item_set_storm_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() and IsLightningDamage(keys) then
		return self:GetStackCount()
	end
	return 0
end

function modifier_item_set_storm_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_set_storm_active:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()
	end
end