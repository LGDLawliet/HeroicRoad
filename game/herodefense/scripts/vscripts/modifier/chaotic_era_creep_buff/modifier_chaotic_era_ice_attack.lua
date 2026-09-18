LinkLuaModifier( "modifier_chaotic_era_ice_attack_debuff", "modifier/chaotic_era_creep_buff/modifier_chaotic_era_ice_attack", LUA_MODIFIER_MOTION_NONE )
modifier_chaotic_era_ice_attack = advanced_modifier({})

function modifier_chaotic_era_ice_attack:IsHidden()return false end
function modifier_chaotic_era_ice_attack:IsDebuff()return false end
function modifier_chaotic_era_ice_attack:IsPurgable()return false end
function modifier_chaotic_era_ice_attack:IsPurgeException() 	return false end
function modifier_chaotic_era_ice_attack:RemoveOnDeath() return true end
function modifier_chaotic_era_ice_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_ice_attack:GetTexture() return self.texture end

function modifier_chaotic_era_ice_attack:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
	self.duration = GetChaticEraCreep_BuffSpecial(self,"value2")
    self.incoming = GetChaticEraCreep_BuffSpecial(self,"value1")
end

function modifier_chaotic_era_ice_attack:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
	return funcs
end

function modifier_chaotic_era_ice_attack:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	local StatusResistance = keys.target:GetHDStatusResistanceIndex(0.8)
    keys.target:AddNewModifier(keys.attacker, nil, "modifier_chaotic_era_ice_attack_debuff", {duration = self.duration*StatusResistance, incoming = self.incoming})
end

function modifier_chaotic_era_ice_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_ice_attack:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.incoming
	elseif self._tooltip == 2 then
		return  self.duration
    end
end

modifier_chaotic_era_ice_attack_debuff = advanced_modifier({})

function modifier_chaotic_era_ice_attack_debuff:IsHidden()return false end
function modifier_chaotic_era_ice_attack_debuff:IsDebuff()return true end
function modifier_chaotic_era_ice_attack_debuff:IsPurgable()return false end
function modifier_chaotic_era_ice_attack_debuff:RemoveOnDeath() return true end
function modifier_chaotic_era_ice_attack_debuff:GetTexture() return "ancient_apparition_ice_blast_release" end

function modifier_chaotic_era_ice_attack_debuff:OnCreated(keys)
    if IsServer() then 
        self.incoming = keys.incoming or 0
        self:SetStackCount(self.incoming)
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_chaotic_era_ice_attack_debuff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end
function modifier_chaotic_era_ice_attack_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    return  self:GetStackCount()
end

function modifier_chaotic_era_ice_attack_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_ice_attack_debuff:OnTooltip()
	return self:GetStackCount()
end

function modifier_chaotic_era_ice_attack_debuff:AddCustomTransmitterData( )
	return
	{
		incoming = self.incoming,
	}
end

function modifier_chaotic_era_ice_attack_debuff:HandleCustomTransmitterData( data )
	self.incoming = data.incoming
end