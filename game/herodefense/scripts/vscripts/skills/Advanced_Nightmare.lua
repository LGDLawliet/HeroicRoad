LinkLuaModifier( "modifier_Advanced_Nightmare", "skills/Advanced_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Nightmare_stun", "skills/Advanced_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Nightmare_auto", "skills/Advanced_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Nightmare_dreamend", "skills/Advanced_Nightmare.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if Advanced_Nightmare == nil then
	Advanced_Nightmare = class({})
end

function Advanced_Nightmare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf", context )
end
function Advanced_Nightmare:GetIntrinsicModifierName()
	return "modifier_Advanced_marksmanship"
end
function Advanced_Nightmare:CheckKV(key)
	local table = {
		duration = 0.1,
		attack_speed_active = 10,
		move_active = 10,
		-- hp_damage_pct = 0.4
	}
	local value = table[key] or -1
	return value
end

function Advanced_Nightmare:UnlockFirstCore(key)
	return false
end
function Advanced_Nightmare:UnlockSecondCore(key)
	return false
end
function Advanced_Nightmare:UnlockThirdCore(key)
	return false
end

function Advanced_Nightmare:GetCustomCastErrorTarget(target)
	return "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
end

function Advanced_Nightmare:CastFilterResultTarget(target)
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
-----------------------------------------------------------------------------------------------------------------------------------------
function Advanced_Nightmare:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.7)
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		target:AddNewModifier(caster, self, "modifier_Advanced_Nightmare_stun",{ duration = duration*ModifierStatusNegativeGain})
	else
		if self:GetAutoCastState() then
			if not target:FindModifierByName("modifier_Advanced_Nightmare_auto") then
				target:AddNewModifier(caster, self, "modifier_Advanced_Nightmare_auto",{ duration = duration*ModifierStatusNegativeGain})
			end
		end
		target:AddNewModifier(caster, self, "modifier_Advanced_Nightmare",{ duration = duration*ModifierStatusNegativeGain})
	end
end
---------------------------------------------------------------------
modifier_Advanced_Nightmare = advanced_modifier({})

function modifier_Advanced_Nightmare:IsHidden()	return false end
function modifier_Advanced_Nightmare:IsDebuff()	return true end
function modifier_Advanced_Nightmare:IsPurgable()	return false end
function modifier_Advanced_Nightmare:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Advanced_Nightmare:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_Nightmare:OnCreated()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Nightmare:OnRefresh()
	self.attack_speed_active = self:GetAbility():GetSpecialValueFor("attack_speed_active")
	self.move_active = self:GetAbility():GetSpecialValueFor("move_active")
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.hp_damage_pct = self:GetAbility():GetSpecialValueFor("hp_damage_pct")*0.001
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_Nightmare:OnDestroy()
	if IsServer() and self.advanced_level >= 5 then
		self:GetParent():Purge(false, true, false, false,true)
	end
end

function modifier_Advanced_Nightmare:OnIntervalThink()
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
	self:GetParent():Purge(false, true, false, false,false)
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST , false)
	if not self:GetParent():IsAttacking() then
		if #units>0 then
			if self.advanced_level >= 20 then
				local attack_range = self:GetParent():Script_GetAttackRange()
				local pos = units[1]:GetAbsOrigin() + RandomVector( RandomFloat( attack_range-1,attack_range ) )
				self:SpellToTarget( pos )
			end
			self:GetParent():MoveToTargetToAttack(units[1])
		end
	end
end

function modifier_Advanced_Nightmare:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

-- function modifier_Advanced_Nightmare:ADDeclareFunctions()
-- 	return {
-- 		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
-- 	}
-- end

-- function modifier_Advanced_Nightmare:OnTakeDamage()
-- 	if IsServer() and self.advanced_level >= 15 then
-- 		self:GetParent():Purge(false, true, false, false,true)
-- 	end
-- end

function modifier_Advanced_Nightmare:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_active
end

function modifier_Advanced_Nightmare:GetModifierMoveSpeedBonus_Constant()
	return self.move_active
end

function modifier_Advanced_Nightmare:SpellToTarget(pos)
	if IsServer() then
		local parent = self:GetParent()
		local point = pos
		local origin = parent:GetOrigin()
		local min_dist = 1
		local max_dist = 100000 --不能用-1
		local direction = (point-origin)
		local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
		direction.z = 0
		direction = direction:Normalized()
	
		local target = GetGroundPosition( origin + direction*dist, nil )
		FindClearSpaceForUnit( parent, target, true )
	end
end
---------------------------------------------------------------------
modifier_Advanced_Nightmare_auto = advanced_modifier({})

function modifier_Advanced_Nightmare_auto:IsHidden()	return false end
function modifier_Advanced_Nightmare_auto:IsDebuff()	return true end
function modifier_Advanced_Nightmare_auto:IsPurgable()	return false end

function modifier_Advanced_Nightmare_auto:OnCreated()
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.base_attack_time = self:GetAbility():GetSpecialValueFor("base_attack_time")
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self:SetStackCount(0)
end

function modifier_Advanced_Nightmare_auto:OnRefresh()
	self.evasion_active = self:GetAbility():GetSpecialValueFor("evasion_active")
	self.base_attack_time = self:GetAbility():GetSpecialValueFor("base_attack_time")
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_Nightmare_auto:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
end

function modifier_Advanced_Nightmare_auto:GetModifierBaseAttackTimeConstant()
	return self.base_attack_time
end

function modifier_Advanced_Nightmare_auto:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_Advanced_Nightmare_auto:GetModifierEvasion_Constant()
	return self.evasion_active
end

function modifier_Advanced_Nightmare_auto:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_Advanced_Nightmare_auto:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if not self:GetParent():IsAlive() then
		if self.advanced_level >= 10 then
			self:SetStackCount(math.min(self:GetStackCount()+1,20))
		end
		self:GetParent():SetHealth(1)
	end
end

function modifier_Advanced_Nightmare_auto:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("death_damage")
end

function modifier_Advanced_Nightmare_auto:OnDestroy()
	if not IsServer() then
		return
	end
	self:SetStackCount(0)
	
	if self:GetParent():IsAlive() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Nightmare_dreamend",{ duration = self:GetAbility():GetSpecialValueFor("over_duration")})
	end
end
--------------------对敌人------------------
modifier_Advanced_Nightmare_stun = advanced_modifier({})

function modifier_Advanced_Nightmare_stun:IsHidden()	return false end
function modifier_Advanced_Nightmare_stun:IsDebuff()	return true end
function modifier_Advanced_Nightmare_stun:IsPurgable()	return false end
function modifier_Advanced_Nightmare_stun:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Advanced_Nightmare_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_Nightmare_stun:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true
	}
end
--------------------梦之终结------------------
modifier_Advanced_Nightmare_dreamend = advanced_modifier({})

function modifier_Advanced_Nightmare_dreamend:IsHidden()	return false end
function modifier_Advanced_Nightmare_dreamend:IsDebuff()	return true end
function modifier_Advanced_Nightmare_dreamend:IsPurgable()	return false end
function modifier_Advanced_Nightmare_dreamend:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end

function modifier_Advanced_Nightmare_dreamend:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_Nightmare_dreamend:CheckState()
	return{
		[MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED ] = true,
		[MODIFIER_STATE_STUNNED ] = true,
		[MODIFIER_STATE_BLOCK_DISABLED  ] = true,
		[MODIFIER_STATE_EVADE_DISABLED  ] = true,
	}
end

