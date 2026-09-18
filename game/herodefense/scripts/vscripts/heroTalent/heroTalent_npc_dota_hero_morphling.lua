heroTalent_npc_dota_hero_morphling = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_morphling", "heroTalent/heroTalent_npc_dota_hero_morphling", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_morphling_buff", "heroTalent/heroTalent_npc_dota_hero_morphling", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_morphling:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_morphling"
end
function heroTalent_npc_dota_hero_morphling:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )

end
function heroTalent_npc_dota_hero_morphling:OnProjectileHit_ExtraData(target, location, extraData)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_morphling_buff", {duration = extraData.duration})
	return false
end

modifier_heroTalent_npc_dota_hero_morphling = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_morphling:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_morphling:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_morphling:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_morphling:OnCreated()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.str = self.ability:GetSpecialValueFor("str")
    self.agi = self.ability:GetSpecialValueFor("agi")
    self.duration = self.ability:GetSpecialValueFor("duration")

	self.talentgain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talentgain
	self.duration_t = self.duration*self.talentgain

	if IsServer() then
		self.info = {
			Source = self:GetCaster(),
			Ability = self.ability,
			--vSpawnOrigin = caster:GetAbsOrigin(),
			bDeleteOnHit = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
			fDistance = 1000,
			fStartRadius = 200,
			fEndRadius = 200,
			--vVelocity = caster:GetForwardVector() * 1200,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {}
		}

		self.damagetable = {
			--victim = self:GetParent(),
			attacker = caster,
			--damage = ,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self.ability,
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
		}
	end
end

function modifier_heroTalent_npc_dota_hero_morphling:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_heroTalent_npc_dota_hero_morphling:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_morphling:OnTooltip(keys)
	self.talentgain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talentgain
	self.duration_t = self.duration*self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.damage_t
	end
	if self._tooltip == 2 then
		return  self.duration_t
	end
end

function modifier_heroTalent_npc_dota_hero_morphling:OnAttack(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local caster = self:GetCaster()
	local target = keys.target
	local random = math.random

	if attacker ~= caster then return end
	if attacker:IsInSpecialAttack() then return end
	if not self.ability:IsCooldownReady() then return end
	
	if self.chance >= random(1,100) then
		self.talentgain = self.ability:GetTalentGain(0.8)
		self.damage_t = self.damage*self.talentgain
		self.duration_t = self.duration*self.talentgain

		-- 获取攻击方向
		local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		self.info.vVelocity = direction * caster:GetProjectileSpeed()
		self.info.vSpawnOrigin = caster:GetAbsOrigin()
		self.info.ExtraData.duration = self.duration_t
		ProjectileManager:CreateLinearProjectile(self.info)
		caster:EmitSoundParams("Hero_Morphling.Waveform", 0, 0.4, 0)
		self.superattack = true

		self.ability:UseResources(true, true, true, true)
	end
end

function modifier_heroTalent_npc_dota_hero_morphling:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local caster = self:GetCaster()
	local target = keys.target

	if attacker ~= caster then return end
	if attacker:IsInSpecialAttack() then return end
	if not self.superattack then return end
	if not target:IsAlive() then return end
	
	local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlForward(pfx, 1, target:GetForwardVector())  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	target:EmitSoundParams("Hero_Morphling.AdaptiveStrikeAgi.Target", 0, 0.4, 0)

	self.damagetable.victim = target
	self.damagetable.damage = caster:GetAverageTrueAttackDamage(nil)*self.damage_t
	ApplyDamage(self.damagetable)

	
	self.superattack = nil
end



modifier_heroTalent_npc_dota_hero_morphling_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_morphling_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_morphling_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_morphling_buff:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_morphling_buff:IsPurgeException() 	return false end

function modifier_heroTalent_npc_dota_hero_morphling_buff:ADDeclareFunctions() 
	return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	} 
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:OnCreated(params)
	self.ability = self:GetAbility()
	self.str = self.ability:GetSpecialValueFor("str")
	self.agi = self.ability:GetSpecialValueFor("agi")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_morphling_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:Advanced_GetModifierBonusStats_Strength() 
	return math.min(self:GetStackCount()*self.str,300)
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:Advanced_GetModifierBonusStats_Agility() 
	return math.min(self:GetStackCount()*self.agi,300)
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_morphling_buff:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength() 
	end
	if self._tooltip == 2 then
		return  self:Advanced_GetModifierBonusStats_Agility() 
	end
end



