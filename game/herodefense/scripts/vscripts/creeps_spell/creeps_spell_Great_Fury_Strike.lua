creeps_spell_Great_Fury_Strike = class({})

LinkLuaModifier("modifier_creeps_spell_Great_Fury_Strike_slow", "creeps_spell/creeps_spell_Great_Fury_Strike", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Great_Fury_Strike:IsHiddenWhenStolen() 		return false end
function creeps_spell_Great_Fury_Strike:IsRefreshable() 			return true  end
function creeps_spell_Great_Fury_Strike:IsStealable() 			return true  end

function creeps_spell_Great_Fury_Strike:Spawn()
	self.bonus_radius = 0
	self.bonus_damage = 0
end
function creeps_spell_Great_Fury_Strike:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") end

function creeps_spell_Great_Fury_Strike:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name = "particles/units/heroes/hero_monkey_king/monkey_king_jump_stomp_rebuild.vpcf"
	local sound_name = {
		"n_creep_Centaur.Stomp",
		"n_creep_Thunderlizard_Big.Stomp"
	}
	caster:SetSkin(RandomInt(0, 1))
	caster:EmitSound(sound_name[RandomInt(1, 2)])
	local radius = self:GetSpecialValueFor("radius")+self.bonus_radius
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 60, Vector(radius/200,0,0))
	ParticleManager:SetParticleControl(pfx, 61, Vector(radius,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = (self:GetSpecialValueFor("damage")+self.bonus_damage) * self:GetCaster():GetBaseDamageMax()
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
        ApplyDamage(damageTable)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_creeps_spell_Great_Fury_Strike_slow", {duration = self:GetSpecialValueFor("duration")*StatusResistance})

		
	end
	if #enemies==0 then
		self.bonus_radius = self.bonus_radius+50
		self.bonus_damage  = self.bonus_damage +0.4
	end
end

modifier_creeps_spell_Great_Fury_Strike_slow = class({})

function modifier_creeps_spell_Great_Fury_Strike_slow:IsDebuff()			return true end
function modifier_creeps_spell_Great_Fury_Strike_slow:IsHidden() 			return false end
function modifier_creeps_spell_Great_Fury_Strike_slow:IsPurgable() 			return true end
function modifier_creeps_spell_Great_Fury_Strike_slow:IsPurgeException() 	return true end
function modifier_creeps_spell_Great_Fury_Strike_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_Great_Fury_Strike_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow or 0 end


function modifier_creeps_spell_Great_Fury_Strike_slow:OnCreated(table)
	self.slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	if not IsServer() then
		return
	end
	-- local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	-- self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
end

function modifier_creeps_spell_Great_Fury_Strike_slow:OnRefresh(table)
	if not IsServer() then
		return
	end
	-- local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	-- self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
end

