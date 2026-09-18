Middle_Phantom_Strike = class({})

LinkLuaModifier("modifier_Middle_Phantom_Strike", "skills/Middle_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Phantom_Strike_buff", "skills/Middle_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')
function Middle_Phantom_Strike:IsHiddenWhenStolen() 		return false end
function Middle_Phantom_Strike:IsRefreshable() 			return true end
function Middle_Phantom_Strike:IsStealable() 			return true end
function Middle_Phantom_Strike:IsNetherWardStealable()	return true end

function Middle_Phantom_Strike:CastFilterResultTarget(target)
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target == self:GetCaster() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end
end

function Middle_Phantom_Strike:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function Middle_Phantom_Strike:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_PhantomAssassin.Strike.Start", caster)
	local target = self:GetCursorTarget()
	-- if target:TriggerStandardTargetSpell(self) then
	-- 	return
	-- end
	if  target:GetTeamNumber() ~= caster:GetTeamNumber() and  target:TriggerSpellAbsorb(self) then
		return
	end
	local startpos = caster:GetAbsOrigin()
	local endpos = target:GetAbsOrigin() + (target:GetForwardVector() * -1) * 100
	FindClearSpaceForUnit(caster, endpos, true)
	local pfx_name1 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_blur.vpcf"
	local pfx_name2 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
	
	local pfx1 = ParticleManager:CreateParticle(pfx_name1, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx1, 0, startpos)
	ParticleManager:ReleaseParticleIndex(pfx1)
	local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, endpos)
	ParticleManager:ReleaseParticleIndex(pfx2)


	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Middle_Phantom_Strike", {duration = self:GetSpecialValueFor("buff_duration")*ModifierStatusGain})
	caster:AddNewModifier(caster, self, "modifier_Middle_Phantom_Strike_buff", {duration = 1*ModifierStatusGain})
	--caster:SetMaximumAttackSpeed(caster:GetMaximumAttackSpeed() + self:GetAbility():GetSpecialValueFor("bonus_attack_speed"))
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		-- caster:SetAttacking(target)
		-- caster:SetForceAttackTarget(target)
		caster:MoveToTargetToAttack(target)
		-- Timers:CreateTimer(0.5, function()
		-- 	caster:SetForceAttackTarget(nil)
		-- end)
	end
	
	--local enemies = FindUnitsInLine(caster:GetTeamNumber(), startpos, endpos, nil, 128, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS)
	-- local ability = caster:FindAbilityByName("imba_phantom_assassin_coup_de_grace")
	-- if ability and ability:GetLevel() > 0 then
	-- 	for i=1, #enemies do
	-- 		for j=1, ability:GetSpecialValueFor("crit_increase") do
	-- 			buff = caster:AddNewModifier(caster, ability, "modifier_imba_coup_de_grace_stacks", {duration = ability:GetSpecialValueFor("crit_increase_duration")})
	-- 			buff:SetStackCount(buff:GetStackCount() + 1)
	-- 		end
	-- 	end
	-- end
	caster:EmitSound("Hero_PhantomAssassin.Strike.End")
end

modifier_Middle_Phantom_Strike = class({})

function modifier_Middle_Phantom_Strike:IsDebuff()			return false end
function modifier_Middle_Phantom_Strike:IsHidden() 			return false end
function modifier_Middle_Phantom_Strike:IsPurgable() 			return true end
function modifier_Middle_Phantom_Strike:IsPurgeException() 	return true end
function modifier_Middle_Phantom_Strike:DeclareFunctions() 
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,} end
	function modifier_Middle_Phantom_Strike:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

--function modifier_Middle_Phantom_Strike:GetModifierBaseAttackTimeConstant() return 0.2 end
modifier_Middle_Phantom_Strike_buff = class({})

function modifier_Middle_Phantom_Strike_buff:IsDebuff()			return false end
function modifier_Middle_Phantom_Strike_buff:IsHidden() 			return true end
function modifier_Middle_Phantom_Strike_buff:IsPurgable()     	return false end
function modifier_Middle_Phantom_Strike_buff:IsPurgeException() 	return false end
function modifier_Middle_Phantom_Strike_buff:DeclareFunctions() return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_Middle_Phantom_Strike_buff:GetModifierBaseAttackTimeConstant() return 0.7 end