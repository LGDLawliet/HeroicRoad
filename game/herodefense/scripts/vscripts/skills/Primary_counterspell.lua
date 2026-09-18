Primary_counterspell = class({})
-- LinkLuaModifier("modifier_Primary_counterspell_arua", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_arua_effect", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_counterspell", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_counterspell_effect", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_effect", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_effect2", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_active_standby", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_debuff", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_counterspell_thinker", "skills/Primary_counterspell", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function Primary_counterspell:GetIntrinsicModifierName()
	return "modifier_Primary_counterspell"
end
function Primary_counterspell:Precache( context )
	-- PrecacheResource( "particle", ""particles/rebuild/spell/counterspell/centaur_return.vpcf"", context )
	PrecacheResource( "particle", "particles/rebuild/spell/counterspell/centaur_return.vpcf", context )

	
	
end


function Primary_counterspell:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Primary_counterspell:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Primary_counterspell:OnToggle()

end



modifier_Primary_counterspell = advanced_modifier({})

function modifier_Primary_counterspell:IsDebuff() return false end
function modifier_Primary_counterspell:IsHidden() return true end
function modifier_Primary_counterspell:IsPurgable() 		return false end
function modifier_Primary_counterspell:IsPurgeException() 	return false end
function modifier_Primary_counterspell:RemoveOnDeath()  return false end




function modifier_Primary_counterspell:OnCreated(keys)
    self.ability = self:GetAbility()
	self.radius = self:GetAbility():GetSpecialValueFor("range")
	self.bonus_magic_res = self.ability:GetSpecialValueFor("bonus_magic_resistance")
 
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.6)

end



function modifier_Primary_counterspell:OnRefresh(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("range")
	self.bonus_magic_res = self.ability:GetSpecialValueFor("bonus_magic_resistance")
end


function modifier_Primary_counterspell:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		

	}
end


function modifier_Primary_counterspell:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or  self.bonus_magic_res end



function modifier_Primary_counterspell:OnIntervalThink()
	local parent = self:GetParent()
	if not parent or not parent:IsAlive() then
		return
	end
	if parent:IsInvulnerable() then
		return
	end
	local ability = self:GetAbility()
	if not ability:GetToggleState() then
		return
	end
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--print(#units,"个单位")
	for _, unit in ipairs(units) do
		if unit:HasModifier("modifier_Primary_counterspell") or unit:HasModifier("modifier_Middle_counterspell") or unit:HasModifier("modifier_Advanced_counterspell") then
			goto continue
		end
		if  unit ~= self:GetParent() then
			unit:AddNewModifier(parent, ability, "modifier_Primary_counterspell_effect", { duration = 1.0 })
		end
		::continue::
	end
end

modifier_Primary_counterspell_effect = advanced_modifier({})

function modifier_Primary_counterspell_effect:IsDebuff()			return false end
function modifier_Primary_counterspell_effect:IsHidden() 			return false end
function modifier_Primary_counterspell_effect:IsPurgable() 		return false end
function modifier_Primary_counterspell_effect:IsPurgeException() 	return false end

function modifier_Primary_counterspell_effect:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end
--受到伤害时检测是否是友军，是则将伤害转移到自己身上
function modifier_Primary_counterspell_effect:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	local target = self:GetCaster()
	local ability = self:GetAbility()
	if not ability:GetToggleState() then
		return
	end
	if not ability or ability:IsNull() then
		return
	end
	if not target or target:IsNull() or not target:IsAlive() then
		return 0
	end
	local damage = keys.damage
	if damage<=0 then
		return 0
	end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS  ) == DOTA_DAMAGE_FLAG_HPLOSS  then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   then
		return 0
	end
	--仅在是魔法单位时格挡伤害
	if  keys.damage_type ==DAMAGE_TYPE_MAGICAL then
			-- print("now is magic")
		local current_magic_resis = target:Script_GetMagicalArmorValue(	false,nil)
		damage = damage*math.min(current_magic_resis,1)  --最大格挡所有伤害
		-- print("current_magic_resis",current_magic_resis,"damage",damage)
		if damage<=0 then
			return 0 --魔抗为负数时不格挡
		end
		local damage_flags =  keys.damage_flags +DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS   ) == DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION   ) == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL   ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
		end

		local damageTable = {

			attacker =keys.attacker, --伤害来源
			victim = target,
			damage = damage,
			damage_type = keys.damage_type,
			ability = ability, 
			damage_flags = damage_flags,
		}
		ApplyDamage(damageTable)
		self:PlayEffects( keys.attacker )
		return damage
	end
	return 0 --表示不格挡
end


function modifier_Primary_counterspell_effect:PlayEffects( target )
	local caster = self:GetCaster()
	local particle_cast = "particles/rebuild/spell/counterspell/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  caster)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
end