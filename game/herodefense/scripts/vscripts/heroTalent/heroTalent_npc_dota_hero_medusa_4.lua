LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_4", "heroTalent/heroTalent_npc_dota_hero_medusa_4", LUA_MODIFIER_MOTION_NONE )


heroTalent_npc_dota_hero_medusa_4 = class({})

function heroTalent_npc_dota_hero_medusa_4:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_initial.vpcf", context )
end

function heroTalent_npc_dota_hero_medusa_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_medusa_4"
end
--------------------
modifier_heroTalent_npc_dota_hero_medusa_4 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_medusa_4:RemoveOnDeath()return false end
function modifier_heroTalent_npc_dota_hero_medusa_4:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_medusa_4:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_medusa_4:GetPriority()return MODIFIER_PRIORITY_ULTRA end -- 因为涉及到天赋弹道

function modifier_heroTalent_npc_dota_hero_medusa_4:OnCreated(table)
    self.speed_down = self:GetAbility():GetSpecialValueFor("speed_down")
    self.int = self:GetAbility():GetSpecialValueFor("int")
    self.mana_attack = self:GetAbility():GetSpecialValueFor("mana_attack")
    if IsServer() then 
        self:StartIntervalThink(1)
    end
end

function modifier_heroTalent_npc_dota_hero_medusa_4:OnIntervalThink()
    local mana = self:GetParent():GetMaxMana()
    self.bonus_attack = math.floor(mana/100) *self.mana_attack
    self:SetStackCount(self.bonus_attack)
end

function modifier_heroTalent_npc_dota_hero_medusa_4:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_medusa_4:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_BONUS_INT_PER_LEVEL,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_heroTalent_npc_dota_hero_medusa_4:CheckState()
    return{
        [MODIFIER_STATE_CANNOT_MISS] = true,
    }
end
function modifier_heroTalent_npc_dota_hero_medusa_4:Advanced_GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_medusa_4:OnTooltip()
    return self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_medusa_4:Advanced_GetModifierBonusINT_PerLevel()
    return self.int
end

function modifier_heroTalent_npc_dota_hero_medusa_4:GetModifierAttackSpeedPercentage()
    return -self.speed_down
end

function modifier_heroTalent_npc_dota_hero_medusa_4:GetModifierProjectileName()
	return	"particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_initial.vpcf" -- 特效：普通攻击弹道
end

function modifier_heroTalent_npc_dota_hero_medusa_4:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.inflictor then return 0 end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end


	local damageTable = {
		victim = keys.target,
		attacker = self:GetParent(),
		damage = keys.original_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( damageTable )
	return -200
end