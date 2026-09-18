LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_5", "heroTalent/heroTalent_npc_dota_hero_axe_5.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_5_buff", "heroTalent/heroTalent_npc_dota_hero_axe_5.lua", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
heroTalent_npc_dota_hero_axe_5 = class({})

function heroTalent_npc_dota_hero_axe_5:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_axe_5"
end
function heroTalent_npc_dota_hero_axe_5:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", context )


end
---------------------------------------------------------------------


modifier_heroTalent_npc_dota_hero_axe_5 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_axe_5:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_axe_5:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_axe_5:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_axe_5:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_axe_5:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.level = self.ability:GetSpecialValueFor("level")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.chance_self = self.ability:GetSpecialValueFor("chance_self")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.chance_cd = self.ability:GetSpecialValueFor("chance_cd")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.line = self.ability:GetSpecialValueFor("line")
	self.cd = self.ability:GetSpecialValueFor("cd")*0.01

	self.talentgain_1 = self.ability:GetTalentGain(0.7)
	self.talentgain_2 = self.ability:GetTalentGain(2)

	self.chance_t = self.chance*self.talentgain_1
	self.chance_self_t = self.chance_self*self.talentgain_1
	self.bonus_damage_t = self.bonus_damage*self.talentgain_2
	self.chance_cd_t = self.chance_cd*self.talentgain_1

	if IsServer() then
		self.damageTable = {
			--victim = enemy,
			attacker = self.parent,
			--damage = dmg,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self.ability,
		}
	end
end

function modifier_heroTalent_npc_dota_hero_axe_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, nil},
	}
end

function modifier_heroTalent_npc_dota_hero_axe_5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_heroTalent_npc_dota_hero_axe_5:OnTooltip(keys)
	self.talentgain_1 = self.ability:GetTalentGain(0.7)
	self.talentgain_2 = self.ability:GetTalentGain(2)

	self.chance_t = self.chance*self.talentgain_1
	self.chance_self_t = self.chance_self*self.talentgain_1
	self.bonus_damage_t = self.bonus_damage*self.talentgain_2
	self.chance_cd_t = self.chance_cd*self.talentgain_1

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self.chance_t
	end
	if self._tooltip == 2 then
		return  self.chance_self_t
	end
	if self._tooltip == 3 then
		return  self.bonus_damage_t
	end
	if self._tooltip == 4 then
		return self.chance_cd_t
	end
end

function modifier_heroTalent_npc_dota_hero_axe_5:OnTakeDamage(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local unit = keys.unit
	local random = math.random

	if not self.ability:IsCooldownReady() then return end
	if keys.damage <= 0 then return end
	if keys.inflictor == self.ability then return end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
	if bit.band(keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	if not self.parent:IsAlive() then return end
	if self.parent:PassivesDisabled() then return end
	
	self.talentgain_1 = self.ability:GetTalentGain(0.7)
	self.talentgain_2 = self.ability:GetTalentGain(2)

	self.chance_t = self.chance*self.talentgain_1
	self.chance_self_t = self.chance_self*self.talentgain_1
	self.bonus_damage_t = self.bonus_damage*self.talentgain_2
	self.chance_cd_t = self.chance_cd*self.talentgain_1
	
	if self.parent:GetLevel() < self.level then
		if unit == self.parent then
			if self.chance_t >= random(1,100) then
				self:Rolling()
				self.ability:UseResources(true, true, true, true)
			end
		end
	else
		if unit == self.parent or attacker == self.parent then
			if unit == self.parent then
				if self.chance_t >= random(1,100) then
					self:Rolling()
					self.ability:UseResources(true, true, true, true)
				end
			else
				if self.chance_self_t >= random(1,100) then
					self:Rolling()
					self.ability:UseResources(true, true, true, true)
				end
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_axe_5:Rolling()
	if not IsServer() then return end
	
	local random = math.random
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(pfx1)
	ParticleManager:ReleaseParticleIndex(pfx2)
	self.parent:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")

	local damage = self.damage + self.parent:GetStrength()*self.bonus_damage_t
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
	if (not self.ability:GetAutoCastState()) and (not self.parent:IsChanneling()) then
		if enemies[1] then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_axe_5_buff", {duration = 2})
			self:Rolling_Cast(enemies[1])
		end
	end

	for i,enemy in ipairs(enemies) do
		self.damageTable.damage = damage
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
	end

	if self.chance_cd_t*10 >= random(1,1000) then
		local ability_num = self.parent:GetAbilityCount()
		local ability_refreshTable = {}
		for i=0, ability_num-1 do
			local ability = self.parent:GetAbilityByIndex(i)
			if ability and ability:IsRefreshable() and not ability:IsCooldownReady() and ability:GetCooldownTimeRemaining() > self.line then
				table.insert(ability_refreshTable, ability)
			end
		end
		local ability_refreshed = ability_refreshTable[random(1, #ability_refreshTable)]
		if not ability_refreshed then return end
		local current_cd = ability_refreshed:GetCooldownTimeRemaining()
		ability_refreshed:EndCooldown()
		ability_refreshed:StartCooldown(current_cd*(1-self.cd))
	end
end

function modifier_heroTalent_npc_dota_hero_axe_5:Rolling_Cast(target)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()
	local playerid = caster:GetPlayerID()
	local target_pos = target:GetAbsOrigin()
	local caster_pos = caster:GetAbsOrigin()
	local ability_num = caster:GetAbilityCount()

	local abilityTable = {}
	for i=0, ability_num-1 do
		local ability = caster:GetAbilityByIndex(i)
		if ability and ability:IsFullyCastable() and not ability:IsPassive() and ability:GetAbilityName() ~= "Default_Move" and ability:IsCooldownReady() then
			local behavior = ability:GetBehaviorInt()
			local target_team = ability:GetAbilityTargetTeam()
			-- 排除只能对友军的技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
				if bit.band(target_team, DOTA_UNIT_TARGET_TEAM_ENEMY) == 0 then
					goto continue
				end
			end
			-- 排除引导技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED then
				goto continue
			end
			table.insert(abilityTable, ability)
			::continue::
		end
	end

	local castAbility = abilityTable[1]
	if not castAbility then return end
	
	table.remove(abilityTable,1)
	local behavior = castAbility:GetBehaviorInt()
	local range
	local newPositon = target_pos
	--点释放类技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
		range = castAbility:GetCastRange(caster:GetAbsOrigin(),caster)
		if (target_pos-caster_pos):Length2D() >= range then
			local ratio = range/(target_pos-caster_pos):Length2D()	--如果释放的点在技能施放范围外，则将释放点移动到技能施放范围边缘 下面同
			newPositon = target_pos:Lerp(caster_pos,1-ratio)
			caster:CastAbilityOnPosition(newPositon, castAbility, playerid)
		else
			caster:CastAbilityOnPosition(newPositon, castAbility, playerid)
		end
	end

	--无目标技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		caster:CastAbilityNoTarget(castAbility, playerid)
	end

	--目标技能--
	if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		range = castAbility:GetCastRange(caster:GetAbsOrigin(),caster)
		if (target_pos-caster_pos):Length2D() >= range then
			local ratio = range/(target_pos-caster_pos):Length2D()
			newPositon = target_pos:Lerp(caster_pos,1-ratio)
		end
		if target:IsAlive() then
			caster:CastAbilityOnTarget(target, castAbility, playerid)
		else
			return
		end
	end

end

modifier_heroTalent_npc_dota_hero_axe_5_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_axe_5_buff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_axe_5_buff:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_axe_5_buff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_axe_5_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_axe_5_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_CastPoint
	}
end
function modifier_heroTalent_npc_dota_hero_axe_5_buff:Advanced_GetModifier_CastPoint()
	return 1000
end