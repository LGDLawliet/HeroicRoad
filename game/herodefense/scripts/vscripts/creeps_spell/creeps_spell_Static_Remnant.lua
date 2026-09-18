LinkLuaModifier("modifier_creeps_spell_Static_Remnant_thinker", "creeps_spell/creeps_spell_Static_Remnant", LUA_MODIFIER_MOTION_NONE)
--Abilities
if creeps_spell_Static_Remnant == nil then
    creeps_spell_Static_Remnant = class({})
end

function creeps_spell_Static_Remnant:OnSpellStart()
    local hCaster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    local hRemnant = CreateUnitByName("npc_dota_thinker", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
    -- hRemnant:ResistSpawneNeutral(false)
    hRemnant:AddNewModifier(hCaster, self, "modifier_creeps_spell_Static_Remnant_thinker", { duration = duration })
    hRemnant:SetForwardVector(hCaster:GetForwardVector())

    hCaster:EmitSound("Hero_StormSpirit.StaticRemnantPlant")
end

function creeps_spell_Static_Remnant:IsHiddenWhenStolen()return false end
---------------------------------------------------------------------
--Modifiers
if modifier_creeps_spell_Static_Remnant_thinker == nil then
    modifier_creeps_spell_Static_Remnant_thinker = class({})
end
function modifier_creeps_spell_Static_Remnant_thinker:IsHidden()return false end
function modifier_creeps_spell_Static_Remnant_thinker:IsDebuff()return false end
function modifier_creeps_spell_Static_Remnant_thinker:IsPurgable()return false end
function modifier_creeps_spell_Static_Remnant_thinker:IsPurgeException()return false end
function modifier_creeps_spell_Static_Remnant_thinker:IsStunDebuff()return false end
function modifier_creeps_spell_Static_Remnant_thinker:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Static_Remnant_thinker:IsAura()return true end
function modifier_creeps_spell_Static_Remnant_thinker:GetAuraEntityReject(hEntity)
    if self.bCanDamage then
        self:SafeDestroy()
    end
    return true
end
function modifier_creeps_spell_Static_Remnant_thinker:GetAuraRadius()
    return self.static_remnant_radius
end
function modifier_creeps_spell_Static_Remnant_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_creeps_spell_Static_Remnant_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_creeps_spell_Static_Remnant_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_creeps_spell_Static_Remnant_thinker:OnCreated(params)

    if IsServer() then
        self.static_remnant_radius = self:GetAbility():GetSpecialValueFor("radius")
        self.static_remnant_damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
        self.static_remnant_delay = self:GetAbility():GetSpecialValueFor("delay")
        self.static_remnant_damage = self:GetAbility():GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()
        local hCaster = self:GetCaster()
        local hParent = self:GetParent()

        hParent:SetOriginalModel(hCaster:GetModelName())
        hParent:SetModelScale(hCaster:GetModelScale())
        hParent:SetShouldDoFlyHeightVisual(false)

        -- local vRBG = Vector(128, 128, 204)
        -- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)

        local hModel = hCaster:FirstMoveChild()
        while hModel ~= nil do
            if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
                local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hParent:GetAbsOrigin() })
                -- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
                hWearable:FollowEntity(hParent, true)
            end
            hModel = hModel:NextMovePeer()
        end

        hParent:StartGesture(ACT_DOTA_CAST_ABILITY_1)

        local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", PATTACH_ABSORIGIN, hParent)
        ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
        self:AddParticle(iParticleID, false, false, -1, false, false)

        self.bCanDamage = false
        self:StartIntervalThink(self.static_remnant_delay)
        self.fAttackTime = GameRules:GetGameTime()
    end
end
function modifier_creeps_spell_Static_Remnant_thinker:OnDestroy()
    if IsServer() then
        local hParent = self:GetParent()
        local hCaster = self:GetCaster()
        local hAbility = self:GetAbility()

        local vPosition = hParent:GetAbsOrigin()
        EmitSoundOnLocationWithCaster(vPosition, "Hero_StormSpirit.StaticRemnantExplode", hCaster)
        hParent:RemoveSelf()


        if not IsValid(hCaster) or not IsValid(hAbility) then
            return
        end
        local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, self.static_remnant_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        for n, hTarget in pairs(tTargets) do
            local tDamageTable =             {
                ability = hAbility,
                attacker = hCaster,
                victim = hTarget,
                damage = self.static_remnant_damage,
                damage_type = hAbility:GetAbilityDamageType()
            }
            ApplyDamage(tDamageTable)
        end
    end
end
function modifier_creeps_spell_Static_Remnant_thinker:OnIntervalThink()
    if IsServer() then
        local hParent = self:GetParent()
        local hCaster = self:GetCaster()
        local hAbility = self:GetAbility()
        if not IsValid(hCaster) or not IsValid(hAbility) then
            self:SafeDestroy()
            return
        end
        if self.bCanDamage then
            return
        else
            self.bCanDamage = true
            self.fAttackTime = GameRules:GetGameTime() + 1 / 30
            self:StartIntervalThink(0)
        end
    end
end
function modifier_creeps_spell_Static_Remnant_thinker:CheckState()
    return {
        [MODIFIER_STATE_FLYING] = true, --thinker不用管
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
end