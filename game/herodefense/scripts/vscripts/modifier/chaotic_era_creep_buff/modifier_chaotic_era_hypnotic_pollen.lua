LinkLuaModifier("modifier_chaotic_era_hypnotic_pollen_debuff", "modifier/chaotic_era_creep_buff/modifier_chaotic_era_hypnotic_pollen", LUA_MODIFIER_MOTION_NONE)


modifier_chaotic_era_hypnotic_pollen = advanced_modifier({})

function modifier_chaotic_era_hypnotic_pollen:IsHidden()return false end
function modifier_chaotic_era_hypnotic_pollen:IsDebuff()return false end
function modifier_chaotic_era_hypnotic_pollen:IsPurgable()return false end
function modifier_chaotic_era_hypnotic_pollen:IsPurgeException() 	return false end
function modifier_chaotic_era_hypnotic_pollen:RemoveOnDeath() return true end
function modifier_chaotic_era_hypnotic_pollen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_hypnotic_pollen:GetTexture() return self.texture end
function modifier_chaotic_era_hypnotic_pollen:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_untouchable_creep.vpcf", context )
end
function modifier_chaotic_era_hypnotic_pollen:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
	self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
	self.bonus3 = GetChaticEraCreep_BuffSpecial(self,"value3")
	self.distance = GetChaticEraCreep_BuffSpecial(self,"distance")
    if IsServer() then
		-- self:SetStackCount(GetChaticEraCreep_BuffSpecial(self,"value1"))
    end
end



function modifier_chaotic_era_hypnotic_pollen:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent()},
	}

	return funcs
end

function modifier_chaotic_era_hypnotic_pollen:OnAttackLanded(keys)
	
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end

	local attacker = keys.attacker
	local target = keys.target

	if attacker:IsMagicImmune() then
		return
	end
	if keys.damage<=0 then
		return
	end
	self:IncrementStackCount()
	if CalculateDistance(target,attacker)<=self.distance then
		local StatusResistance = attacker:GetHDStatusResistanceIndex(0.8)
		attacker:AddNewModifier(target, nil, "modifier_chaotic_era_hypnotic_pollen_debuff", {duration=self.bonus1*StatusResistance})	
	end
	



end


function modifier_chaotic_era_hypnotic_pollen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_hypnotic_pollen:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self.distance
	elseif self._tooltip == 2 then
		return  self.bonus2
	elseif self._tooltip == 3 then
		return  self.bonus3
	elseif self._tooltip == 4 then
		return  self.bonus1
	end
end







modifier_chaotic_era_hypnotic_pollen_debuff = advanced_modifier({})

function modifier_chaotic_era_hypnotic_pollen_debuff:IsDebuff()			return true end
function modifier_chaotic_era_hypnotic_pollen_debuff:IsHidden() 			return false end
function modifier_chaotic_era_hypnotic_pollen_debuff:IsPurgable() 			return true end
-- function modifier_chaotic_era_hypnotic_pollen_debuff:IsPurgeException() 	return false end
function modifier_chaotic_era_hypnotic_pollen_debuff:GetTexture() return self.texture end
function modifier_chaotic_era_hypnotic_pollen_debuff:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable_creep.vpcf"
end
function modifier_chaotic_era_hypnotic_pollen_debuff:OnCreated(keys)
	self.texture = GetChaticEraCreep_BuffTexture("modifier_chaotic_era_hypnotic_pollen")
    self.bonus2 = -GetChaticEraCreep_BuffSpecial("modifier_chaotic_era_hypnotic_pollen","value2")
    self.bonus3 = -GetChaticEraCreep_BuffSpecial("modifier_chaotic_era_hypnotic_pollen","value3")
	-- self.bonus2 = -GetChaticEraCreep_BuffSpecial("modifier_chaotic_era_chaotic_executive","value2")
end




function modifier_chaotic_era_hypnotic_pollen_debuff:Advanced_GetModifierAttackSpeedPercentage()
    return self.bonus2
end


function modifier_chaotic_era_hypnotic_pollen_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE}
	return funcs
end



function modifier_chaotic_era_hypnotic_pollen_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end


function modifier_chaotic_era_hypnotic_pollen_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.bonus3
end




function modifier_chaotic_era_hypnotic_pollen_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierAttackSpeedPercentage()
	elseif self._tooltip == 2 then
		return  self:GetModifierMoveSpeedBonus_Constant()
	end
end
