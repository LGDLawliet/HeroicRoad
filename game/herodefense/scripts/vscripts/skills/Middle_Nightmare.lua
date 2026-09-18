LinkLuaModifier( "modifier_Middle_Nightmare", "skills/Middle_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Nightmare_stun", "skills/Middle_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Nightmare_auto", "skills/Middle_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Middle_Nightmare == nil then
	Middle_Nightmare = class({})
end

function Middle_Nightmare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf", context )
end

function Middle_Nightmare:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.7)
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		target:AddNewModifier(caster, self, "modifier_Middle_Nightmare_stun",{ duration = duration*ModifierStatusNegativeGain})
	else
		if self:GetAutoCastState() then
			if not target:FindModifierByName("modifier_Middle_Nightmare_auto") then
				target:AddNewModifier(caster, self, "modifier_Middle_Nightmare_auto",{ duration = duration*ModifierStatusNegativeGain})
			end
		end
		target:AddNewModifier(caster, self, "modifier_Middle_Nightmare",{ duration = duration*ModifierStatusNegativeGain})
	end
end

function Middle_Nightmare:GetCustomCastErrorTarget(target)
	return "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
end

function Middle_Nightmare:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
				return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
end
---------------------------------------------------------------------
modifier_Middle_Nightmare = advanced_modifier({})

function modifier_Middle_Nightmare:IsHidden()	return false end
function modifier_Middle_Nightmare:IsDebuff()	return true end
function modifier_Middle_Nightmare:IsPurgable()	return false end
function modifier_Middle_Nightmare:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Middle_Nightmare:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Middle_Nightmare:OnCreated()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Middle_Nightmare:OnRefresh()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
end

function modifier_Middle_Nightmare:OnIntervalThink()
	local damage = self:GetParent():GetHealth() * self.hp_damage_pct
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags =  DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = self:GetAbility(),
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT ,
	}
	ApplyDamage(damageTable)
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST , false)
	if not self:GetParent():IsAttacking() then
		if #units>0 then
			self:GetParent():MoveToTargetToAttack(units[1])
		end
	end
end

function modifier_Middle_Nightmare:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_Middle_Nightmare:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_active
end

function modifier_Middle_Nightmare:GetModifierMoveSpeedBonus_Constant()
	return self.move_active
end

---------------------------------------------------------------------
modifier_Middle_Nightmare_auto = advanced_modifier({})

function modifier_Middle_Nightmare_auto:IsHidden()	return false end
function modifier_Middle_Nightmare_auto:IsDebuff()	return true end
function modifier_Middle_Nightmare_auto:IsPurgable()	return false end

function modifier_Middle_Nightmare_auto:OnCreated()
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
end

function modifier_Middle_Nightmare_auto:OnRefresh()
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
end

function modifier_Middle_Nightmare_auto:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_Middle_Nightmare_auto:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_Middle_Nightmare_auto:GetModifierEvasion_Constant()
	return self.evasion_active
end
--------------------对敌人------------------
modifier_Middle_Nightmare_stun = advanced_modifier({})

function modifier_Middle_Nightmare_stun:IsHidden()	return false end
function modifier_Middle_Nightmare_stun:IsDebuff()	return true end
function modifier_Middle_Nightmare_stun:IsPurgable()	return false end
function modifier_Middle_Nightmare_stun:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Middle_Nightmare_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Middle_Nightmare_stun:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true
	}
end