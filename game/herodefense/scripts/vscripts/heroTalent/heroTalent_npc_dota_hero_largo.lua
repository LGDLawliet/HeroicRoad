LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_largo", "heroTalent/heroTalent_npc_dota_hero_largo.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_largo_song_1", "heroTalent/heroTalent_npc_dota_hero_largo.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_largo_song_2", "heroTalent/heroTalent_npc_dota_hero_largo.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_largo_song_3", "heroTalent/heroTalent_npc_dota_hero_largo.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_largo = class({})

function heroTalent_npc_dota_hero_largo:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_largo"
end
function heroTalent_npc_dota_hero_largo:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_fightsong_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_heal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_doubletime_buff.vpcf", context )
end
function heroTalent_npc_dota_hero_largo:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_largo")
	if IsValid(modifier) then
		modifier:ForceRefresh()
	end
end
modifier_heroTalent_npc_dota_hero_largo = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_largo:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_largo:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_largo:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_largo:OnCreated(params)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.posi = self.ability:GetSpecialValueFor("posi")
	if IsServer() then
		self.songtable = {
			"heroTalent_npc_dota_hero_largo_song_1",
			"heroTalent_npc_dota_hero_largo_song_2",
			"heroTalent_npc_dota_hero_largo_song_3"
		}
		self.caster:GameTimer(0.03,function()
			for _,sAbilityName in pairs(self.songtable) do
				local ability = self.caster:AddAbility(sAbilityName)
				if IsValid(ability) then
					ability:SetLevel(1)
					PassiveAbilitySwap(self.caster,sAbilityName) 
					ability:SetHidden(true)
				end
			end
		end)
		self:StartIntervalThink(0.33)
	end
end
function modifier_heroTalent_npc_dota_hero_largo:OnRefresh(params)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.posi = self.ability:GetSpecialValueFor("posi")
end
function modifier_heroTalent_npc_dota_hero_largo:OnIntervalThink()
	if self.parent:IsAlive() and self.ability:IsCooldownReady() then
		self.ability:UseResources(true,true,true,true)
		local random = math.random(1, #self.songtable)
		local random_song = self.caster:FindAbilityByName(self.songtable[random])
		if IsValid(random_song) then
			local song_keys = {
				duration = self.duration*self.caster:GetModifierDurationGainIndex(0.45),
			}
			random_song:CastEffect(song_keys)
		end
	end
end
function modifier_heroTalent_npc_dota_hero_largo:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_largo:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_DurationGain
	}
end
function modifier_heroTalent_npc_dota_hero_largo:Advanced_GetModifier_DurationGain()
	return self.posi
end
-- function modifier_heroTalent_npc_dota_hero_largo:OnModifierAdded(keys)
-- 	if not IsServer() then return end
-- 	local unit = keys.unit
-- 	local buff = keys.added_buff
-- 	local Ability = buff:GetAbility()
-- 	local Caster = buff:GetCaster()
-- 	--自身施加的
-- 	if Caster == nil or Caster ~= self.caster or not self.caster:IsAlive() then return end
-- 	--目标为其他友军
-- 	if IsEnemy(unit, self.caster) or unit == self.caster then return end
-- 	--正面状态
-- 	if buff:IsDebuff() then return end
-- 	--来自主动技能(非切换，非被动)
-- 	if Ability == nil or Ability:GetBehavior() == DOTA_ABILITY_BEHAVIOR_PASSIVE or Ability:GetBehavior() == DOTA_ABILITY_BEHAVIOR_TOGGLE then return end
-- 	if not self.ability:IsCooldownReady() then return end
		
-- 	self.ability:UseResources(true,true,true, true)
-- 	local random = math.random(1, #self.songtable)
-- 	local random_song = self.caster:FindAbilityByName(self.songtable[random])
-- 	if IsValid(random_song) then
-- 		local song_keys = {
-- 			duration = self.duration*self.caster:GetModifierDurationGainIndex(0.7),
-- 		}
-- 		random_song:CastEffect(song_keys)
-- 	end
-- end

---
heroTalent_npc_dota_hero_largo_song_1 = class({})

function heroTalent_npc_dota_hero_largo_song_1:CastEffect(keys)
	local caster = self:GetCaster()
	local radius_t = self:GetSpecialValueFor("radius")*self:GetTalentGain(0.4)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius_t, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		local keys = {
			duration = keys.duration,
			caster = caster,
			ability = self,
			target = ally,
			buffName = "modifier_heroTalent_npc_dota_hero_largo_song_1",
		}
		keys.target:AddNewModifier(keys.caster, keys.ability, keys.buffName, {duration = keys.duration})
	end
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:EmitSound("n_frogs.WaterBubble.Target")
	local particle = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_aoe.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius_t, 0, 0))
	ParticleManager:SetParticleControl(effect_cast, 3, Vector(0, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)
	caster:GameTimer(0.8,function()
		caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	end)
end

modifier_heroTalent_npc_dota_hero_largo_song_1 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_largo_song_1:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_largo_song_1:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

	self.talentgain = self.ability:GetTalentGain(0.25)
	self.attack_t = self.attack*self.talentgain
	self.spell_amp_t = self.spell_amp*self.talentgain

	if IsServer() then
		self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())
		
		local particle_cast = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_fightsong_buff.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(effect_cast,0,self.parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		self:AddParticle(effect_cast, false, false, -1, false, false)
	end
end

function modifier_heroTalent_npc_dota_hero_largo_song_1:OnRefresh(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

	self.talentgain = self.ability:GetTalentGain(0.25)
	self.attack_t = self.attack*self.talentgain
	self.spell_amp_t = self.spell_amp*self.talentgain

	if IsServer() then
        self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())
    end
end

function modifier_heroTalent_npc_dota_hero_largo_song_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_largo_song_1:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_largo_song_1:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*self.attack_t
end
function modifier_heroTalent_npc_dota_hero_largo_song_1:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()*self.spell_amp_t
end
function modifier_heroTalent_npc_dota_hero_largo_song_1:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
	end
end
---
heroTalent_npc_dota_hero_largo_song_2 = class({})

function heroTalent_npc_dota_hero_largo_song_2:CastEffect(keys)
	local caster = self:GetCaster()
	local radius_t = self:GetSpecialValueFor("radius")*self:GetTalentGain(0.4)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius_t, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		local keys = {
			duration = keys.duration,
			caster = caster,
			ability = self,
			target = ally,
			buffName = "modifier_heroTalent_npc_dota_hero_largo_song_2",
		}
		keys.target:AddNewModifier(keys.caster, keys.ability, keys.buffName, {duration = keys.duration})
	end
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:EmitSound("n_frogs.WaterBubble.Target")
	local particle = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_aoe.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius_t, 0, 0))
	ParticleManager:SetParticleControl(effect_cast, 3, Vector(3, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)

	caster:GameTimer(0.8,function()
		caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	end)
end

modifier_heroTalent_npc_dota_hero_largo_song_2 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_largo_song_2:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_largo_song_2:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.cds = self.ability:GetSpecialValueFor("cds")*0.01*0.5
	self.move = self.ability:GetSpecialValueFor("move")

	self.talentgain = self.ability:GetTalentGain(0.25)
	self.attack_speed_t = self.attack_speed*self.talentgain
	self.cds_t = self.cds*self.talentgain
	self.move_t = self.move*self.talentgain

	if IsServer() then
		self:StartIntervalThink(0.5)
		self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())

		local particle_cast = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_doubletime_buff.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(effect_cast,0,self.parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		self:AddParticle(effect_cast, false, false, -1, false, false)
	end
end

function modifier_heroTalent_npc_dota_hero_largo_song_2:OnRefresh(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.cds = self.ability:GetSpecialValueFor("cds")*0.01*0.5
	self.move = self.ability:GetSpecialValueFor("move")

	self.talentgain = self.ability:GetTalentGain(0.12)
	self.attack_speed_t = self.attack_speed*self.talentgain
	self.cds_t = self.cds*self.talentgain
	self.move_t = self.move*self.talentgain

	if IsServer() then
		self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())
	end
end
function modifier_heroTalent_npc_dota_hero_largo_song_2:OnIntervalThink()
    for i=0, self.parent:GetAbilityCount() - 1 do
		local Ability = self.parent:GetAbilityByIndex(i)
		if Ability ~= nil and (not Ability:IsCooldownReady()) and Ability:IsRefreshable() and (Ability:GetAbilityName() ~= "heroTalent_npc_dota_hero_largo") then
			if Ability ~= self:GetAbility()	then
				local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - self.cds_t,0)
				Ability:EndCooldown()
				Ability:StartCooldown(new_cooldown)
			end
		end
	end
end
function modifier_heroTalent_npc_dota_hero_largo_song_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_heroTalent_npc_dota_hero_largo_song_2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end
function modifier_heroTalent_npc_dota_hero_largo_song_2:Advanced_GetModifierAttackSpeedPercentage()
	return self:GetStackCount()*self.attack_speed_t
end
function modifier_heroTalent_npc_dota_hero_largo_song_2:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()*self.move_t
end
function modifier_heroTalent_npc_dota_hero_largo_song_2:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
    elseif self._tooltip == 2 then
        return self:GetStackCount()*self.cds_t*100/0.5
    elseif self._tooltip == 3 then
        return self:GetModifierMoveSpeedBonus_Constant()
	end
end
---
heroTalent_npc_dota_hero_largo_song_3 = class({})

function heroTalent_npc_dota_hero_largo_song_3:CastEffect(keys)
	local caster = self:GetCaster()
	local radius_t = self:GetSpecialValueFor("radius")*self:GetTalentGain(0.4)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius_t, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		local keys = {
			duration = keys.duration,
			caster = caster,
			ability = self,
			target = ally,
			buffName = "modifier_heroTalent_npc_dota_hero_largo_song_3",
		}
		keys.target:AddNewModifier(keys.caster, keys.ability, keys.buffName, {duration = keys.duration})
	end
	caster:EmitSound("n_frogs.WaterBubble.Target")
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local particle = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_aoe.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius_t, 0, 0))
	ParticleManager:SetParticleControl(effect_cast, 3, Vector(1, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)
	caster:GameTimer(0.8,function()
		caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	end)
end

modifier_heroTalent_npc_dota_hero_largo_song_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_largo_song_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_largo_song_3:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.heal = self.ability:GetSpecialValueFor("heal")
	self.status = self.ability:GetSpecialValueFor("status")

	self.talentgain = self.ability:GetTalentGain(0.5)
	self.heal_t = self.heal*self.talentgain
	self.status_t = self.status*self.talentgain

	if IsServer() then
		self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())
		
		local health = self.caster:HDGetPrimaryStatValue()*self.heal_t
		local healing = HealWithGain(health, self.caster,self.parent,self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)

		local particle_cast = "particles/units/heroes/hero_largo/largo_amphibian_rhapsody_heal.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(effect_cast,0,self.parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		ParticleManager:ReleaseParticleIndex(effect_cast)
	end
end

function modifier_heroTalent_npc_dota_hero_largo_song_3:OnRefresh(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.heal = self.ability:GetSpecialValueFor("heal")
	self.status = self.ability:GetSpecialValueFor("status")

	self.talentgain = self.ability:GetTalentGain(0.5)
	self.heal_t = self.heal*self.talentgain
	self.status_t = self.status*self.talentgain

	if IsServer() then
		self:AddStackDuration(keys.stack or 1, self:GetRemainingTime())

		local health = self.caster:HDGetPrimaryStatValue()*self.heal_t
		local healing = HealWithGain(health, self.caster,self.parent,self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
	end
end

function modifier_heroTalent_npc_dota_hero_largo_song_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_largo_song_3:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
end
function modifier_heroTalent_npc_dota_hero_largo_song_3:Advanced_GetModifier_StatusResistance()
	return self:GetStackCount()*self.status_t
end

function modifier_heroTalent_npc_dota_hero_largo_song_3:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifier_StatusResistance()
	end
end