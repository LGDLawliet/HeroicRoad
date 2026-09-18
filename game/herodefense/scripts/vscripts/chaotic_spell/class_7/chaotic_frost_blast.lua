LinkLuaModifier( "modifier_chaotic_frost_blast_rune_1", "chaotic_spell/class_7/chaotic_frost_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chaotic_frost_blast_slow", "chaotic_spell/class_7/chaotic_frost_blast.lua", LUA_MODIFIER_MOTION_NONE)

chaotic_frost_blast = class({})

function chaotic_frost_blast:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova_burst.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", context )
end

function chaotic_frost_blast:GetIntrinsicModifierName()
    if self:GetRuneType() == 1 then
        return "modifier_chaotic_frost_blast_rune_1"
    end
end

function chaotic_frost_blast:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function chaotic_frost_blast:OnSpellStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local aoe_radius = self:GetAOERadius()

    -- 爆发主目标
    self:FrostBlast(target, 1, true)

    -- 对周围敌人造成冻伤和减速
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        aoe_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in pairs(enemies) do
        if enemy ~= target then
            self:FrostBlast(enemy, 1, false)
        end
    end
end

function chaotic_frost_blast:FrostBlast(target, index, is_main)
    if not IsServer() then return end
    if not target then return end

    local caster = self:GetCaster()
    local index = index or 1

    local damage = (self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*index
    local freezing = (self:GetSpecialValueFor("freezing") + self:GetSpecialValueFor("bonus_freezing")*caster:HDGetPrimaryStatValue())*index
	local freezing_index = self:GetSpecialValueFor("freezing_apply")*0.01
    local duration = self:GetSpecialValueFor("duration")

	
	if is_main then
        self:PlayEffects(target)
        local target_freezing = target:FindModifierByName("modifier_hd_freezing")
        if target_freezing then
            local apply_stack = target_freezing:GetStackCount()*freezing_index
            ApplyFreezingDamage(caster, self, target, apply_stack)
            target_freezing:SetStackCount(target_freezing:GetStackCount() - apply_stack)
        end
		    
		if target:IsAlive() then
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self,
				hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
			}
			ApplyDamage(damageTable)
		end
		if target:IsAlive() then
			target:AddNewModifier(caster, self, "modifier_chaotic_frost_blast_slow", {duration = duration})
		end
	else
		target:Freezing(caster, self, freezing)
		target:AddNewModifier(caster, self, "modifier_chaotic_frost_blast_slow", {duration = duration})
	end
	
end

function chaotic_frost_blast:PlayEffects(target)
    local particle_cast = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
    local sound_cast = "Hero_Lich.SinisterGaze.Target"

    local casterID = tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID()))
	if casterID == "76561198828335572" then
		particle_cast = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf"
	end

    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self:GetAOERadius(), self:GetAOERadius(), self:GetAOERadius()))
    ParticleManager:SetParticleControl(effect_cast, 2, Vector(self:GetAOERadius(), self:GetAOERadius(), self:GetAOERadius()))
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOn(sound_cast, target)
end

-------------

modifier_chaotic_frost_blast_slow = advanced_modifier({})
function modifier_chaotic_frost_blast_slow:IsDebuff() return true end
function modifier_chaotic_frost_blast_slow:IsHidden() return false end
function modifier_chaotic_frost_blast_slow:IsPurgable() return false end
function modifier_chaotic_frost_blast_slow:OnCreated(kv)
    self.move = self:GetAbility():GetSpecialValueFor("move")
    self.attack_slow = self:GetAbility():GetSpecialValueFor("attack_slow")
end
function modifier_chaotic_frost_blast_slow:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
end
function modifier_chaotic_frost_blast_slow:GetModifierMoveSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
    return -self.move
end
function modifier_chaotic_frost_blast_slow:GetModifierAttackSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
    return -self.attack_slow
end

-- 不朽Ⅰ：寒霜领域
modifier_chaotic_frost_blast_rune_1 = advanced_modifier({})
function modifier_chaotic_frost_blast_rune_1:IsDebuff() return false end
function modifier_chaotic_frost_blast_rune_1:IsHidden() return true end
function modifier_chaotic_frost_blast_rune_1:IsPurgable() return false end
function modifier_chaotic_frost_blast_rune_1:IsPurgeException() return false end
function modifier_chaotic_frost_blast_rune_1:OnCreated(keys)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.radius = self.ability:GetCastRange(self.caster:GetAbsOrigin(),self.caster)
    self.interval = self.ability:GetSpecialValueFor("rune_1_interval")
	self.rune_1_interval_2 = self.ability:GetSpecialValueFor("rune_1_interval_2")
    self.index = self.ability:GetSpecialValueFor("rune_1_index") * 0.01
    if IsServer() then
		self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_chaotic_frost_blast_rune_1:OnIntervalThink()
	local count_line = self.interval
	if self.caster:IsChanneling() then
		count_line = self.rune_1_interval_2
	end
	self:SetStackCount(self:GetStackCount()+1)

	if self:GetStackCount() >= count_line then
        self.radius = self.ability:GetCastRange(self.caster:GetAbsOrigin(),self.caster)
		self:SetStackCount(0)
		local units = FindUnitsInRadius(
        self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    	)
		for _, unit in pairs(units) do
			if unit:IsAlive() then
				self.ability:FrostBlast(unit, self.index, true)
                local enemies = FindUnitsInRadius(
                    self.caster:GetTeamNumber(),
                    unit:GetAbsOrigin(),
                    nil,
                    self.ability:GetAOERadius(),
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_ANY_ORDER,
                    false
                )
                for _, enemy in pairs(enemies) do
                    if enemy ~= unit then
                        self.ability:FrostBlast(enemy, self.index, false)
                    end
                end
				break
			end
		end
	end
    
end
