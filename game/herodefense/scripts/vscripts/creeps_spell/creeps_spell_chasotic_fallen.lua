creeps_spell_chasotic_fallen = class({})
LinkLuaModifier("modifier_creeps_spell_chasotic_fallen_effect", "creeps_spell/creeps_spell_chasotic_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_chasotic_fallen_delay", "creeps_spell/creeps_spell_chasotic_fallen", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_chasotic_fallen:GetIntrinsicModifierName() return "modifier_creeps_spell_chasotic_fallen_effect" end


modifier_creeps_spell_chasotic_fallen_effect = class({})
function modifier_creeps_spell_chasotic_fallen_effect:IsHidden() return true end
function modifier_creeps_spell_chasotic_fallen_effect:IsDebuff() return false end
function modifier_creeps_spell_chasotic_fallen_effect:IsPurgable() return false end
function modifier_creeps_spell_chasotic_fallen_effect:IsPurgeException() return false end
function modifier_creeps_spell_chasotic_fallen_effect:IsStunDebuff() return false end
function modifier_creeps_spell_chasotic_fallen_effect:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_chasotic_fallen_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end





function modifier_creeps_spell_chasotic_fallen_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.3)
    local ability = self:GetAbility()
    if ability:IsCooldownReady() then
        local parent = self:GetParent()
        local enemies = FindUnitsInRadius(parent:GetTeamNumber(),parent:GetAbsOrigin(), nil,
        1000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        for _, unit in ipairs(enemies) do
            ability:UseResources(true, true, true,true)
            local pos = unit:GetAbsOrigin()
            parent:AddNewModifier(parent, ability, "modifier_creeps_spell_chasotic_fallen_delay", {duration=0.4,x=pos.x,y=pos.y,z=pos.z})
            break
        end

    end
end








modifier_creeps_spell_chasotic_fallen_delay = class({})

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_chasotic_fallen_delay:IsPurgable()
	return false
end
function modifier_creeps_spell_chasotic_fallen_delay:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_chasotic_fallen_delay:OnCreated( kv )
	if IsServer() then

        self.pos = Vector(kv.x,kv.y,kv.z)
        local caster = self:GetCaster()
        local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/unlock1/effect.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle_main_fx, 0, self.pos)
        ParticleManager:ReleaseParticleIndex(particle_main_fx)
		self:GetParent():AddNoDraw()
        

	end
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_chasotic_fallen_delay:OnDestroy()
	if IsServer() then
        local caster = self:GetCaster()
		if caster and caster:IsAlive() then
			FindClearSpaceForUnit( caster, self.pos, true )
			
		end
        self:GetCaster():RemoveNoDraw()
        caster:EmitSound("Hero_DoomBringer.Devour")
        local particle_main_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle_main_fx, 0, self.pos)
        ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(500, 0, 0))
        ParticleManager:ReleaseParticleIndex(particle_main_fx)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),self.pos, nil,
        500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        local ability = self:GetAbility()
        local damageTable = {
            attacker = caster,
            damage = caster:GetDamageMax()*ability:GetSpecialValueFor("damage_index"),
            damage_type = ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = ability, --Optional.
            }

        for _, unit in ipairs(enemies) do
            damageTable.victim = unit
            ApplyDamage(damageTable)
        end
	end
end


-----------------------------------------------------------------------------------------