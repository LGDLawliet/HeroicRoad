LinkLuaModifier( "modifier_chaotic_era_acid_attack_debuff", "modifier/chaotic_era_creep_buff/modifier_chaotic_era_acid_attack", LUA_MODIFIER_MOTION_NONE )
modifier_chaotic_era_acid_attack = advanced_modifier({})

function modifier_chaotic_era_acid_attack:IsHidden()return false end
function modifier_chaotic_era_acid_attack:IsDebuff()return false end
function modifier_chaotic_era_acid_attack:IsPurgable()return false end
function modifier_chaotic_era_acid_attack:IsPurgeException() 	return false end
function modifier_chaotic_era_acid_attack:RemoveOnDeath() return true end
function modifier_chaotic_era_acid_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_acid_attack:GetTexture() return self.texture end

function modifier_chaotic_era_acid_attack:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
	self.duration = GetChaticEraCreep_BuffSpecial(self,"value3")
    self.armor = GetChaticEraCreep_BuffSpecial(self,"value1")
    self.evasion = GetChaticEraCreep_BuffSpecial(self,"value2")
end

function modifier_chaotic_era_acid_attack:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
	return funcs
end

function modifier_chaotic_era_acid_attack:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	local StatusResistance = keys.target:GetHDStatusResistanceIndex(0.8)
    keys.target:AddNewModifier(keys.attacker, nil, "modifier_chaotic_era_acid_attack_debuff", {duration = self.duration*StatusResistance, stack = 1, armor = self.armor, evasion = self.evasion})
end

function modifier_chaotic_era_acid_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_acid_attack:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.armor
	elseif self._tooltip == 2 then
		return  self.evasion
    elseif self._tooltip == 3 then
		return  self.duration
	end
end

modifier_chaotic_era_acid_attack_debuff = advanced_modifier({})

function modifier_chaotic_era_acid_attack_debuff:IsHidden()return false end
function modifier_chaotic_era_acid_attack_debuff:IsDebuff()return true end
function modifier_chaotic_era_acid_attack_debuff:IsPurgable()return true end
function modifier_chaotic_era_acid_attack_debuff:RemoveOnDeath() return true end
function modifier_chaotic_era_acid_attack_debuff:GetTexture() return "morphling_adaptive_strike_str" end

function modifier_chaotic_era_acid_attack_debuff:OnCreated(keys)
    if IsServer() then 
        self.stack = keys.stack or 1
        self.armor = keys.armor or 2
        self.evasion = keys.evasion or 5
        self:SetStackCount(self.stack)
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_chaotic_era_acid_attack_debuff:OnRefresh(keys)
    if IsServer() then 
        self.armor = keys.armor or 2
        self.evasion = keys.evasion or 5
        if self.stack then
            self.stack = self.stack + keys.stack
            self:SetStackCount(self.stack)
        else
            self.stack = keys.stack or 1
            self:SetStackCount(self.stack)
        end
    end
end

function modifier_chaotic_era_acid_attack_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_chaotic_era_acid_attack_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return  -self.armor*self:GetStackCount()
end
function modifier_chaotic_era_acid_attack_debuff:GetModifierEvasion_Constant()
    return  -self.evasion*self:GetStackCount()
end
function modifier_chaotic_era_acid_attack_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_chaotic_era_acid_attack_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.armor*self:GetStackCount()
	elseif self._tooltip == 2 then
		return  self.evasion*self:GetStackCount()
	end
end

function modifier_chaotic_era_acid_attack_debuff:AddCustomTransmitterData( )
	return
	{
		armor = self.armor,
		evasion = self.evasion
	}
end

function modifier_chaotic_era_acid_attack_debuff:HandleCustomTransmitterData( data )
	self.armor = data.armor
	self.evasion = data.evasion
end