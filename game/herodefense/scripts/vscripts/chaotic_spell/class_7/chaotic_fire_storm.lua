LinkLuaModifier("modifier_chaotic_fire_storm_thinker", "chaotic_spell/class_7/chaotic_fire_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_fire_storm_buff", "chaotic_spell/class_7/chaotic_fire_storm", LUA_MODIFIER_MOTION_NONE)

chaotic_fire_storm = class({})

function chaotic_fire_storm:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", context )
end
function chaotic_fire_storm:GetAOERadius()
	local radius = self:GetSpecialValueFor("width")
	return radius 
end
function chaotic_fire_storm:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()
	self:PlayEffects( point )
	return true 
end

function chaotic_fire_storm:OnAbilityPhaseInterrupted()
	self:StopEffects()
end

function chaotic_fire_storm:OnSpellStart()
	self:StopEffects()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_chaotic_fire_storm_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

function chaotic_fire_storm:PlayEffects( point )
    local caster = self:GetCaster()
	local particle_cast = "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm.Start"
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 2, 2, 2 ) )

	EmitSoundOnLocationWithCaster( point, sound_cast, caster)
end

function chaotic_fire_storm:StopEffects()
    ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

----------------------------------
modifier_chaotic_fire_storm_thinker = advanced_modifier({})
function modifier_chaotic_fire_storm_thinker:IsHidden() return true end
function modifier_chaotic_fire_storm_thinker:IsPurgable()return false end

function modifier_chaotic_fire_storm_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.base_damage = self.ability:GetSpecialValueFor("base_damage")
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.radius = self.ability:GetSpecialValueFor("width")
    self.count = self.ability:GetSpecialValueFor("count")
	self.interval = self.ability:GetSpecialValueFor("cooldown_reduction")
    self.burning_bonus = self.ability:GetSpecialValueFor("burning_bonus")*0.01
	self.damage = self.base_damage + caster:HDGetPrimaryStatValue()*self.bonus_damage
    self.type = self.ability:GetRuneType()

    if self.type == 1 then
        self.burning_bonus = self.burning_bonus*(1-self.ability:GetSpecialValueFor("rune_1_bonus")*0.01)
    end
    if self.type == 2 then
        self.rune_2_index = self.ability:GetSpecialValueFor("rune_2_index")*0.01
        self.rune_2_duration = self.ability:GetSpecialValueFor("rune_2_duration")
    end
    if self.type == 3 then
        self.rune_3_count = self.ability:GetSpecialValueFor("rune_3_count")*0.01
        self.rune_3_interval = self.ability:GetSpecialValueFor("rune_3_interval")*0.01
        self.count = self.count*(1+self.rune_3_count)
        self.interval = self.interval*(1-self.rune_3_interval)
    end
    
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		--damage = self.damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
        hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE
	}

	self:StartIntervalThink(self.interval)
	self:OnIntervalThink()
end

function modifier_chaotic_fire_storm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end


function modifier_chaotic_fire_storm_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	if not self:GetAbility() then self:Destroy() return end
    
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local center_pos = self.parent:GetOrigin() + RandomVector(RandomInt(-(self.radius-30), (self.radius-30)))
    if self.wave == 0 or self.type == 1 then
        center_pos = self.parent:GetOrigin()
    end
    if self.type == 2 then
        target_team = DOTA_UNIT_TARGET_TEAM_BOTH
    end

    self:PlayEffects(center_pos)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		center_pos,
		nil,
		self.radius,
		target_team,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
    self.damage = self.base_damage + caster:HDGetPrimaryStatValue()*self.bonus_damage
	for _,enemy in pairs(enemies) do
        if IsEnemy(caster, enemy) then
            if self.type ~= 3 then
                self.damageTable.victim = enemy
                self.damageTable.damage = self.damage
                ApplyDamage(self.damageTable)
            else
                enemy:Burning(caster, self.ability, self.damage)
            end

            if enemy:IsAlive() then
                local burning = enemy:FindModifierByName("modifier_hd_burning")
                if burning then
                    enemy:Burning(caster, self.ability, burning:GetStackCount()*self.burning_bonus)
                end
            end
        else
            enemy:AddNewModifier(caster, self:GetAbility(), "modifier_chaotic_fire_storm_buff", {duration = self.rune_2_duration, attack = self.damage*self.rune_2_index})
        end
	end

	self.wave = self.wave + 1
	if self.wave >= self.count then
		self:Destroy()
	end
end


function modifier_chaotic_fire_storm_thinker:PlayEffects(pos)
    if not pos then
        pos = self.parent:GetOrigin()
    end

	local particle_cast = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector(self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self.parent )
end


----------------------------------
modifier_chaotic_fire_storm_buff = advanced_modifier({})
function modifier_chaotic_fire_storm_buff:IsDebuff() return false end
function modifier_chaotic_fire_storm_buff:IsHidden() return false end
function modifier_chaotic_fire_storm_buff:IsPurgable()return false end
function modifier_chaotic_fire_storm_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_fire_storm_buff:GetEffectName()return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf" end
function modifier_chaotic_fire_storm_buff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.attack)
    end
end
function modifier_chaotic_fire_storm_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_chaotic_fire_storm_buff:Advanced_GetModifierPreAttack_BonusDamage()
    if not self:GetAbility() then self:Destroy() return end
    return self:GetStackCount()
end