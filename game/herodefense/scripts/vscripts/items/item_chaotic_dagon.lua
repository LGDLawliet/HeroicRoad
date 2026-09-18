item_chaotic_dagon = class({})

LinkLuaModifier("modifier_item_chaotic_dagon", "items/item_chaotic_dagon", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_dagon:GetIntrinsicModifierName()
    return "modifier_item_chaotic_dagon"
end

function item_chaotic_dagon:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", context )
end

function item_chaotic_dagon:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if not IsValid(target) then return end

    local radius = self:GetSpecialValueFor("radius")
    local max_targets = self:GetSpecialValueFor("max")
    local damage_pct = self:GetSpecialValueFor("damage")
    local burning_idx = self:GetSpecialValueFor("burning")

    local damage_value = caster:HDGetPrimaryStatValue() * damage_pct
    local damagetable = {
        --victim = enemy,
        attacker = caster,
        damage = damage_value,
        damage_type = self:GetAbilityDamageType(),
        ability = self,
        hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
    }

    damagetable.victim = target
    self:PlayEffect(target)
    ApplyDamage(damagetable)

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i, enemy in ipairs(enemies) do
        if enemy ~= target then
            damagetable.victim = enemy
            self:PlayEffect(target)
            ApplyDamage(damagetable)
            if i >= max_targets then break end
        end
    end

    -- 若主目标死亡，施加灼伤
    if not target:IsAlive() then
        for _, enemy in ipairs(enemies) do
            enemy:Burning(caster, self, caster:HDGetPrimaryStatValue() * burning_idx)
        end
    end
end

function item_chaotic_dagon:PlayEffect(target)
    if not IsServer() then return end
    if not target then return end

	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local sound_cast = "Hero_Lion.FingerOfDeathImpact"
	local caster = self:GetCaster()
	local direction = (caster:GetOrigin()-target:GetOrigin()):Normalized()


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	local attach = "attach_attack1"
	if caster:ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() + direction )
	ParticleManager:SetParticleControlForward( effect_cast, 3, -direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end
--------------------------------------------------------------------------------
modifier_item_chaotic_dagon = advanced_modifier({})

function modifier_item_chaotic_dagon:IsDebuff() return false end
function modifier_item_chaotic_dagon:IsHidden() return true end
function modifier_item_chaotic_dagon:IsPurgable() return false end

function modifier_item_chaotic_dagon:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
end

function modifier_item_chaotic_dagon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_item_chaotic_dagon:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end


