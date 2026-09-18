LinkLuaModifier( "modifier_Primary_Nightmare", "skills/Primary_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Nightmare_stun", "skills/Primary_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Primary_Nightmare == nil then
	Primary_Nightmare = class({})
end

function Primary_Nightmare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf", context )
end

function Primary_Nightmare:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.7)
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		target:AddNewModifier(caster, self, "modifier_Primary_Nightmare_stun",{ duration = duration*ModifierStatusNegativeGain})
	else
		target:AddNewModifier(caster, self, "modifier_Primary_Nightmare",{ duration = duration*ModifierStatusNegativeGain})
	end
end

function Primary_Nightmare:GetCustomCastErrorTarget(target)
	return "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
end

function Primary_Nightmare:CastFilterResultTarget(target)
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


modifier_Primary_Nightmare = advanced_modifier({})

function modifier_Primary_Nightmare:IsHidden()	return false end
function modifier_Primary_Nightmare:IsDebuff()	return true end
function modifier_Primary_Nightmare:IsPurgable()	return false end
function modifier_Primary_Nightmare:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Primary_Nightmare:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_Nightmare:OnCreated()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Primary_Nightmare:OnRefresh()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
end

function modifier_Primary_Nightmare:OnIntervalThink()
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

function modifier_Primary_Nightmare:ADDeclareFunctions()
	return {
	}
end

function modifier_Primary_Nightmare:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_Primary_Nightmare:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_active
end

function modifier_Primary_Nightmare:GetModifierMoveSpeedBonus_Constant()
	return self.move_active
end

--------------------对敌人------------------
modifier_Primary_Nightmare_stun = advanced_modifier({})

function modifier_Primary_Nightmare_stun:IsHidden()	return false end
function modifier_Primary_Nightmare_stun:IsDebuff()	return true end
function modifier_Primary_Nightmare_stun:IsPurgable()	return false end
function modifier_Primary_Nightmare_stun:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Primary_Nightmare_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_Nightmare_stun:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true
	}
end