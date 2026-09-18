LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_winter_wyvern_3", "heroTalent/heroTalent_npc_dota_hero_winter_wyvern_3", LUA_MODIFIER_MOTION_NONE )
--Abilities

heroTalent_npc_dota_hero_winter_wyvern_3 = class({})
function heroTalent_npc_dota_hero_winter_wyvern_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/winter_wyvern/curse.vpcf" , context )
end
function heroTalent_npc_dota_hero_winter_wyvern_3:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")

    target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_winter_wyvern_3", {duration = duration})
end
-----------------------------
modifier_heroTalent_npc_dota_hero_winter_wyvern_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:OnTakeDamage(params)
	if not IsServer() then return end
	if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
    if params.attacker == self:GetParent() then
        local attacker = params.attacker
        local original_damage = params.damage
        local ability = self:GetAbility()
        local radius = ability:GetSpecialValueFor("radius")
        local max_targets = ability:GetSpecialValueFor("max_targets")
        local damage_percent = ability:GetSpecialValueFor("damage_percent")

        local nearby_units = FindUnitsInRadius(
            attacker:GetTeamNumber(),
            attacker:GetAbsOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
		local damageTable = {
			--victim = unit,
			attacker = self:GetCaster(),
			--damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
		}
        local affected_count = 0
        for _, unit in pairs(nearby_units) do
            if affected_count < max_targets then
				damageTable.victim = unit
                damageTable.damage = math.min(original_damage * damage_percent / 100 + self:GetCaster():GetIntellect(false)*self:GetAbility():GetSpecialValueFor("damage"), ability:GetSpecialValueFor("damage_max"))
				if unit == self:GetParent() then
					damageTable.damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
                else
                    damageTable.damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
                end
                ApplyDamage(damageTable)
                affected_count = affected_count + 1
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:GetEffectName()
    return "particles/rebuild/talent/winter_wyvern/curse.vpcf"
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_3:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end