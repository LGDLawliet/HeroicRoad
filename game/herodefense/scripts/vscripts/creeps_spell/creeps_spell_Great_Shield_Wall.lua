------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_Great_Shield_Wall = class({})

LinkLuaModifier("modifier_creeps_spell_Great_Shield_Wall_passive", "creeps_spell/creeps_spell_Great_Shield_Wall", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_creeps_spell_Great_Shield_Wall_effect", "creeps_spell/creeps_spell_Great_Shield_Wall", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_creeps_spell_Great_Shield_Wall_effect_count", "creeps_spell/creeps_spell_Great_Shield_Wall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Great_Shield_Wall_active", "creeps_spell/creeps_spell_Great_Shield_Wall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Great_Shield_Wall_aura", "creeps_spell/creeps_spell_Great_Shield_Wall", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Great_Shield_Wall:GetIntrinsicModifierName() return "modifier_creeps_spell_Great_Shield_Wall_passive" end

modifier_creeps_spell_Great_Shield_Wall_passive = advanced_modifier({})

function modifier_creeps_spell_Great_Shield_Wall_passive:IsHidden() return true end
function modifier_creeps_spell_Great_Shield_Wall_passive:IsAura() 
	if self:GetParent():PassivesDisabled() then
        return false
    end
	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_creeps_spell_Great_Shield_Wall_active")
		if modifier then
			return false
		end
    end
	return true
end
function modifier_creeps_spell_Great_Shield_Wall_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Great_Shield_Wall_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Great_Shield_Wall_passive:RemoveOnDeath()  return false end

function modifier_creeps_spell_Great_Shield_Wall_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Great_Shield_Wall_passive:GetModifierAura() return "modifier_creeps_spell_Great_Shield_Wall_aura" end

function modifier_creeps_spell_Great_Shield_Wall_passive:GetAuraRadius() 
	if self:GetParent():PassivesDisabled() then
        return 0
    end
	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_creeps_spell_Great_Shield_Wall_active")
		if modifier then
			return 0
		end
    end
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_creeps_spell_Great_Shield_Wall_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Great_Shield_Wall_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Great_Shield_Wall_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_creeps_spell_Great_Shield_Wall_passive:OnCreated()
    self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	
end

function modifier_creeps_spell_Great_Shield_Wall_passive:OnRefresh()
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
end

function modifier_creeps_spell_Great_Shield_Wall_passive:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_creeps_spell_Great_Shield_Wall_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self:GetParent():PassivesDisabled() then
        return 0
    end
	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_creeps_spell_Great_Shield_Wall_active")
		if modifier then
			return 0
		end
    end
	return -self.incoming_down
end

function modifier_creeps_spell_Great_Shield_Wall_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	if keys.unit:PassivesDisabled() then
		return
	end

	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		local modifier = unit:FindModifierByName("modifier_creeps_spell_Great_Shield_Wall_active")
		if modifier ~= nil then
			return
		end
	end

	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_creeps_spell_Great_Shield_Wall_active",{duration = self:GetAbility():GetSpecialValueFor("duration")})
end
-------------------------------------------------------------------------
modifier_creeps_spell_Great_Shield_Wall_active = advanced_modifier({})

function modifier_creeps_spell_Great_Shield_Wall_active:IsHidden() return false end
function modifier_creeps_spell_Great_Shield_Wall_active:IsDebuff() return true end
function modifier_creeps_spell_Great_Shield_Wall_active:IsPurgable() 		return false end
function modifier_creeps_spell_Great_Shield_Wall_active:IsPurgeException() 	return false end
function modifier_creeps_spell_Great_Shield_Wall_active:RemoveOnDeath()  return false end
function modifier_creeps_spell_Great_Shield_Wall_active:OnCreated()
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
	
end

function modifier_creeps_spell_Great_Shield_Wall_active:OnRefresh()
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
end

function modifier_creeps_spell_Great_Shield_Wall_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,}
	return funcs
end

function modifier_creeps_spell_Great_Shield_Wall_active:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move
end

function modifier_creeps_spell_Great_Shield_Wall_active:CheckState()
	return {
		--[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
	}
end

-------------------------------------------------------------------
modifier_creeps_spell_Great_Shield_Wall_aura = advanced_modifier({})

function modifier_creeps_spell_Great_Shield_Wall_aura:IsDebuff()			return false end
function modifier_creeps_spell_Great_Shield_Wall_aura:IsHidden() 			return true end
function modifier_creeps_spell_Great_Shield_Wall_aura:IsPurgable() 			return false end
function modifier_creeps_spell_Great_Shield_Wall_aura:IsPurgeException() 	return false end
function modifier_creeps_spell_Great_Shield_Wall_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creeps_spell_Great_Shield_Wall_aura:OnCreated()
    self.incoming_down_aura = self:GetAbility():GetSpecialValueFor("incoming_down_aura")
	
end

function modifier_creeps_spell_Great_Shield_Wall_aura:OnRefresh()
    self:GetAbility():OnCreated()
end

function modifier_creeps_spell_Great_Shield_Wall_aura:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_creeps_spell_Great_Shield_Wall_aura:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self.incoming_down_aura
end

-------------------重制，暂时废弃-----------------------------------
modifier_creeps_spell_Great_Shield_Wall_effect = advanced_modifier({})

function modifier_creeps_spell_Great_Shield_Wall_effect:IsDebuff()			return false end
function modifier_creeps_spell_Great_Shield_Wall_effect:IsHidden() 			return true end
function modifier_creeps_spell_Great_Shield_Wall_effect:IsPurgable() 			return false end
function modifier_creeps_spell_Great_Shield_Wall_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Great_Shield_Wall_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_creeps_spell_Great_Shield_Wall_effect:OnCreated()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Great_Shield_Wall_effect_count", {})
    end
end

function modifier_creeps_spell_Great_Shield_Wall_effect:OnRefresh()
    if IsServer() then

        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Great_Shield_Wall_effect_count", {})
    end
end

-------------------重制，暂时废弃-----------------------------------
modifier_creeps_spell_Great_Shield_Wall_effect_count = advanced_modifier({})

function modifier_creeps_spell_Great_Shield_Wall_effect_count:IsDebuff()			return false end
function modifier_creeps_spell_Great_Shield_Wall_effect_count:IsHidden() 			return false end
function modifier_creeps_spell_Great_Shield_Wall_effect_count:IsPurgable() 			return false end
function modifier_creeps_spell_Great_Shield_Wall_effect_count:IsPurgeException() 	return false end


function modifier_creeps_spell_Great_Shield_Wall_effect_count:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_creeps_spell_Great_Shield_Wall_effect_count:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Great_Shield_Wall_effect")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end


function modifier_creeps_spell_Great_Shield_Wall_effect_count:GetTexture()
    return "mars_bulwark"
end


function modifier_creeps_spell_Great_Shield_Wall_effect_count:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_creeps_spell_Great_Shield_Wall_effect_count:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_creeps_spell_Great_Shield_Wall_effect_count:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_creeps_spell_Great_Shield_Wall_effect_count:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local reduce = math.max(-10* self:GetStackCount(),-95)
	if self:GetParent():PassivesDisabled() then
        return reduce*0.5
    end

	return reduce


end



