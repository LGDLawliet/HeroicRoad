Middle_Blade_Dance = class({})
LinkLuaModifier( "modifier_Middle_Blade_Dance", "skills/Middle_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Blade_Dance_speed", "skills/Middle_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Blade_Dance_middle", "skills/Middle_Blade_Dance", LUA_MODIFIER_MOTION_NONE )
function Middle_Blade_Dance:GetIntrinsicModifierName()
	return "modifier_Middle_Blade_Dance"
end

-----------------------------------
modifier_Middle_Blade_Dance = advanced_modifier({})


function modifier_Middle_Blade_Dance:IsHidden() return true end
function modifier_Middle_Blade_Dance:IsPurgable() 		return false end
function modifier_Middle_Blade_Dance:IsPurgeException() 	return false end
function modifier_Middle_Blade_Dance:RemoveOnDeath()  return false end

function modifier_Middle_Blade_Dance:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_Middle_Blade_Dance:OnRefresh( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_Middle_Blade_Dance:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_Middle_Blade_Dance:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if keys.attacker ~= self:GetParent() then
			return
		end

		local pct = self.crit_chance
		local random = math.random
		if pct > random(0,100) then
			EmitSoundOn( "Hero_Juggernaut.BladeDance", keys.target )
			self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
			self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
			self.record = keys.record
			keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Blade_Dance_speed", {duration = self.duration})

			local middle_pct = self:GetAbility():GetSpecialValueFor("middle_chance")
			local middle_stack = self:GetAbility():GetSpecialValueFor("middle_stack")
			if middle_pct > random(0,100) and not self:GetParent():HasModifier("modifier_Middle_Blade_Dance_middle") then
				keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Blade_Dance_middle", {duration = 3,stack = middle_stack})
			end
			return self.crit_mult
		end
	end
end
function modifier_Middle_Blade_Dance:OnAttackLanded( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end

------------------------------------------
modifier_Middle_Blade_Dance_speed = advanced_modifier({})

function modifier_Middle_Blade_Dance_speed:IsHidden() return false end
function modifier_Middle_Blade_Dance_speed:IsPurgable() 		return false end
function modifier_Middle_Blade_Dance_speed:IsPurgeException() 	return false end

function modifier_Middle_Blade_Dance_speed:OnCreated()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not IsServer() then
		return
	end
end

function modifier_Middle_Blade_Dance_speed:OnRefresh()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not IsServer() then
		return
	end
end

function modifier_Middle_Blade_Dance_speed:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_Middle_Blade_Dance_speed:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

------------------------------------------
modifier_Middle_Blade_Dance_middle = advanced_modifier({})

function modifier_Middle_Blade_Dance_middle:IsHidden() return true end
function modifier_Middle_Blade_Dance_middle:IsPurgable() 		return false end
function modifier_Middle_Blade_Dance_middle:IsPurgeException() 	return false end

function modifier_Middle_Blade_Dance_middle:OnCreated(keys)
	self.attack_speed = 700
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self.stack)
end

function modifier_Middle_Blade_Dance_middle:OnRefresh(keys)
	self.attack_speed = 700
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self.stack)
end

function modifier_Middle_Blade_Dance_middle:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_Middle_Blade_Dance_middle:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_Middle_Blade_Dance_middle:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end

function modifier_Middle_Blade_Dance_middle:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
	self:SetStackCount(self:GetStackCount()-1)
	if self:GetStackCount() <= 0 then
		self:SafeDestroy()
	end
end