heroTalent_npc_dota_hero_lich = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lich", "heroTalent/heroTalent_npc_dota_hero_lich", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_lich:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lich"
end
function heroTalent_npc_dota_hero_lich:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova_burst.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", context )
end

function heroTalent_npc_dota_hero_lich:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_lich:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_lich")
	if IsValid(modifier) then
		modifier:ForceRefresh()
	end
end

modifier_heroTalent_npc_dota_hero_lich = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lich:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_lich:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_lich:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_lich:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_lich:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lich:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.int_damage = self.ability:GetSpecialValueFor("int_damage")
	self.bonus = self.ability:GetSpecialValueFor("bonus")*0.01

	self.talent_gain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talent_gain
	self.int_damage_t = self.int_damage*self.talent_gain
	self.bonus_t = self.bonus*self.talent_gain
end

function modifier_heroTalent_npc_dota_hero_lich:OnRefresh(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.int_damage = self.ability:GetSpecialValueFor("int_damage")
	self.bonus = self.ability:GetSpecialValueFor("bonus")*0.01

	self.talent_gain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talent_gain
	self.int_damage_t = self.int_damage*self.talent_gain
	self.bonus_t = self.bonus*self.talent_gain
end


function modifier_heroTalent_npc_dota_hero_lich:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
    }
end

function modifier_heroTalent_npc_dota_hero_lich:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local victim = keys.unit
    if not victim then return end
    if not IsEnemy(victim, self.caster) then return end


    if (attacker and attacker == self.caster)then
        local keys = {
            target = victim,
            ignore_dis = 1,
        }
        self:FrostBlast(keys)
    else
        local keys = {
            target = victim,
            ignore_dis = 0,
        }
        self:FrostBlast(keys)
    end
end

--target 中心
--ignore_dis 1/0 无视距离
function modifier_heroTalent_npc_dota_hero_lich:FrostBlast(keys)
    if not IsServer() then return end
    local target = keys.target
    local caster = self.caster
    local ignore_dis = keys.ignore_dis
    if not target then
        return 0
    end

    if ignore_dis ~= 1 and CalculateDistance(target, caster) > self.radius then return end

	self.talent_gain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talent_gain
	self.int_damage_t = self.int_damage*self.talent_gain
	self.bonus_t = self.bonus*self.talent_gain
	
	
	self:PlayEffects(target:GetOrigin())
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.damage_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #enemies <= 0 then return end
	local damage = self.damage_t + self.int_damage_t*self.parent:GetIntellect(false)
	local damagetable = {
			attacker = self.caster,
			damage = damage,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}

	for _,enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_hd_freezing") then
			damage = damage* (1+self.bonus_t)
		end
		
		enemy:ApplyMergeDamage(damagetable)
	end
end

function modifier_heroTalent_npc_dota_hero_lich:PlayEffects(pos)
	local caster = self.caster
    local particle_cast = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
    local sound_cast = "Hero_Lich.SinisterGaze.Target"

	local casterID = tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID()))
	if casterID == "76561198828335572" then
		particle_cast = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf"
	end

    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, pos)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.damage_radius, self.damage_radius, self.damage_radius))
    ParticleManager:SetParticleControl(effect_cast, 2, Vector(self.damage_radius, self.damage_radius, self.damage_radius))

    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOn(sound_cast, caster)
end

function modifier_heroTalent_npc_dota_hero_lich:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_lich:OnTooltip()
	self.talent_gain = self.ability:GetTalentGain(0.8)
	self.damage_t = self.damage*self.talent_gain
	self.int_damage_t = self.int_damage*self.talent_gain
	self.bonus_t = self.bonus*self.talent_gain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.damage_t + self.int_damage_t*self:GetCaster():GetIntellect(false)
    elseif self._tooltip == 2 then
        return self.bonus_t*100
    end
end