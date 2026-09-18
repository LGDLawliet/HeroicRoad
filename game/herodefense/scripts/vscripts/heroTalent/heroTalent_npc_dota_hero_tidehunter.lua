heroTalent_npc_dota_hero_tidehunter = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tidehunter", "heroTalent/heroTalent_npc_dota_hero_tidehunter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tidehunter_effect", "heroTalent/heroTalent_npc_dota_hero_tidehunter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tidehunter_damage_count", "heroTalent/heroTalent_npc_dota_hero_tidehunter", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_tidehunter:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tidehunter"
end

function heroTalent_npc_dota_hero_tidehunter:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf", context)
    PrecacheResource("particle", "particles/rebuild/spell/tidehunter_gush/great_effect.vpcf", context)
end

--start_pos，可选，初始位置，默认caster
--end_pos，必填，结束位置
function heroTalent_npc_dota_hero_tidehunter:CreateGreatGush(keys)
    if not IsServer() then return end
    if not keys.end_pos then return end

    local caster = self:GetCaster()
    local start_pos = keys.start_pos or caster:GetAbsOrigin()
    local end_pos = keys.end_pos
    local dir = CalculateDirection(end_pos, start_pos)

    local speed_scepter = 1100
    local distance = 6000
	local radius = 500
    end_pos = start_pos + dir * distance
    local duration = distance / speed_scepter

    local particle = ParticleManager:CreateParticle("particles/rebuild/spell/tidehunter_gush/great_effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, start_pos)
    ParticleManager:SetParticleControlForward(particle, 0, dir)
    ParticleManager:SetParticleControl(particle, 1, dir*speed_scepter)
    ParticleManager:SetParticleControl(particle, 3, Vector(radius-260,0,0))
    ParticleManager:SetParticleControl(particle, 60, Vector(radius,0,0))
    ParticleManager:SetParticleShouldCheckFoW(particle, false)
    EmitSoundOnLocationWithCaster(start_pos, "Ability.GushCast", caster)
    caster:GameTimer(duration, function()
        ParticleManager:DestroyParticle(particle, false)
        ParticleManager:ReleaseParticleIndex(particle)
    end)

    local projectile = {
        Ability = self,
        EffectName = "",
        vSpawnOrigin = start_pos,
        fDistance = distance,
        fStartRadius = radius,
        fEndRadius = radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        fExpireTime = GameRules:GetGameTime() + 20.0,
        bDeleteOnHit = false,
        vVelocity = dir * speed_scepter,
        bProvidesVision = false,
        ExtraData = {
        },

    }
    ProjectileManager:CreateLinearProjectile(projectile)
end

function heroTalent_npc_dota_hero_tidehunter:OnProjectileHit_ExtraData(target, location, data)
    if not target then return end
    
    local caster = self:GetCaster()
    self:ApplyEffect({
        target = target,   
    })    
    return false
end


--target，必填，目标
--damage_pct，选填，百分比，默认100
function heroTalent_npc_dota_hero_tidehunter:ApplyEffect(keys)
    local caster = self:GetCaster()
    local target = keys.target
	local talentgain = self:GetTalentGain(0.6)
    local damage = (self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*0.01 * caster:HDGetPrimaryStatValue()) * talentgain
    local duration = self:GetSpecialValueFor("duration")
	local armor = self:GetSpecialValueFor("armor") * talentgain
	local mrs_down  = self:GetSpecialValueFor("mrs_down") * talentgain

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
    target:EmitSoundParams("Ability.GushImpact", 0, 0.3, 0)

    local damage_table = {
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self,	
		apply_damage_init = false,
		apply_damage_interval = 0.1,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
    }

	if target:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_damage_count") then
		damage_table.damage = damage * 0.1
	end
    target:ApplyMergeDamage(damage_table)
    

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
    local debuff_duration = duration *StatusResistance
    if debuff_duration > 0 then
        target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_tidehunter_effect", {
			duration = debuff_duration,
			armor = armor,
			mrs_down = mrs_down,
		})
    end
	target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_tidehunter_damage_count", {
		duration = 0.11,
	})
end

function heroTalent_npc_dota_hero_tidehunter:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_tidehunter")
	if modifier then
		modifier:ForceRefresh()
	end
end

-------------
modifier_heroTalent_npc_dota_hero_tidehunter = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tidehunter:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tidehunter:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tidehunter:OnCreated(keys)
	local caster = self:GetParent()
	self.ability = self:GetAbility()
	self.talentgain = self.ability:GetTalentGain(0.6)
    self.damage = (self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("bonus_damage")*0.01 * caster:HDGetPrimaryStatValue()) * self.talentgain
    self.duration = self.ability:GetSpecialValueFor("duration")
	self.armor = self.ability:GetSpecialValueFor("armor") * self.talentgain
	self.mrs_down  = self.ability:GetSpecialValueFor("mrs_down") * self.talentgain
	self.num = self.ability:GetSpecialValueFor("num")
	if IsServer() then
		self:StartIntervalThink(0.1)	
	end
end

function modifier_heroTalent_npc_dota_hero_tidehunter:OnRefresh(keys)
	local caster = self:GetParent()
	self.ability = self:GetAbility()
	self.talentgain = self.ability:GetTalentGain(0.6)
    self.damage = (self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("bonus_damage")*0.01 * caster:HDGetPrimaryStatValue()) * self.talentgain
    self.duration = self.ability:GetSpecialValueFor("duration")
	self.armor = self.ability:GetSpecialValueFor("armor") * self.talentgain
	self.mrs_down  = self.ability:GetSpecialValueFor("mrs_down") * self.talentgain
	self.num = self.ability:GetSpecialValueFor("num")
end

function modifier_heroTalent_npc_dota_hero_tidehunter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_tidehunter:OnTooltip()
	local caster = self:GetParent()
	self.talentgain = self.ability:GetTalentGain(0.6)
    self.damage = (self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("bonus_damage")*0.01 * caster:HDGetPrimaryStatValue()) * self.talentgain
	self.armor = self.ability:GetSpecialValueFor("armor") * self.talentgain
	self.mrs_down  = self.ability:GetSpecialValueFor("mrs_down") * self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.damage
    elseif self._tooltip == 2 then
        return self.armor
    elseif self._tooltip == 3 then
        return self.mrs_down
    end
end

function modifier_heroTalent_npc_dota_hero_tidehunter:OnIntervalThink()
	if not Game_State:IsInBattle() then return end
	local caster = self:GetParent()
	if not caster:IsAlive() then return end
	if not self.ability:IsCooldownReady() then return end
	local pos = (Vector(-300,-1053,896)) --房间中心
	local num = self.num

	self.ability:UseResources(true, false, false, true)
	-- 计算从中间角度均分num个方向作为end_pos
	for i = 1, num do
		local angle = (2 * math.pi / num) * (i - 1)  -- 均匀分布在360度内
		local distance = 1000  -- 可以根据需要调整距离
		local offset = Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
		local end_pos = pos + offset

		--start_pos，可选，初始位置，默认caster
		--end_pos，必填，结束位置
		self.ability:CreateGreatGush({
			start_pos = pos,
			end_pos = end_pos,
		})
	end
end


modifier_heroTalent_npc_dota_hero_tidehunter_damage_count = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tidehunter_damage_count:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tidehunter_damage_count:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_tidehunter_damage_count:IsPurgable()	return false end



modifier_heroTalent_npc_dota_hero_tidehunter_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_tidehunter_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter_effect:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.freezing_incoming = self.ability:GetSpecialValueFor("freezing_incoming")
    if IsServer() then
		self.armor = keys.armor
		self.mrs_down = keys.mrs_down
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:OnRefresh(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.freezing_incoming = self.ability:GetSpecialValueFor("freezing_incoming")
    if IsServer() then
		self.armor = keys.armor
		self.mrs_down = keys.mrs_down
	end
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:AddCustomTransmitterData( )
	return
	{
        armor = self.armor,
		mrs_down = self.mrs_down,
	}
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:HandleCustomTransmitterData( data )
    self.armor = data.armor
	self.mrs_down = data.mrs_down
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_FREEZING_DAMAGE_PERCENTAGE
    }
end

function modifier_heroTalent_npc_dota_hero_tidehunter_effect:GetModifierMagicalResistanceBonus() return -self.mrs_down end
function modifier_heroTalent_npc_dota_hero_tidehunter_effect:Advanced_GetModifierPhysicalArmorBonus() return -self.armor end
function modifier_heroTalent_npc_dota_hero_tidehunter_effect:Advanced_GetModifierIncomingFreezingDamagePercentage() return self.freezing_incoming end


function modifier_heroTalent_npc_dota_hero_tidehunter_effect:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.armor
    elseif self._tooltip == 2 then
        return self.mrs_down
    elseif self._tooltip == 3 then
        return self.freezing_incoming
    end
end