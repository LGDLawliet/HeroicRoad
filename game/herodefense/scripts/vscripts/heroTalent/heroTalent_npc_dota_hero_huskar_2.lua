heroTalent_npc_dota_hero_huskar_2 =heroTalent_npc_dota_hero_huskar_2 or class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_huskar_2_already", "heroTalent/heroTalent_npc_dota_hero_huskar_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_huskar_2", "heroTalent/heroTalent_npc_dota_hero_huskar_2", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_huskar_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf", context )
end

function heroTalent_npc_dota_hero_huskar_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_huskar_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_huskar_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_huskar_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_huskar_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_huskar_2" end


modifier_heroTalent_npc_dota_hero_huskar_2 = modifier_heroTalent_npc_dota_hero_huskar_2 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_huskar_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_huskar_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_huskar_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_huskar_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_huskar_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_huskar_2:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end


function modifier_heroTalent_npc_dota_hero_huskar_2:OnCreated(keys)
    self.hp_lock = self:GetAbility():GetSpecialValueFor("hp_lock")
    self.maxHealth = self:GetParent():GetMaxHealth()*self.hp_lock*0.01
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    self.rise = 0
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self:StartIntervalThink(0.2)     
    end
end
function modifier_heroTalent_npc_dota_hero_huskar_2:OnIntervalThink()
    self.hp_lock = self:GetAbility():GetSpecialValueFor("hp_lock")
    self.maxHealth = self:GetParent():GetMaxHealth()*self.hp_lock*0.01
    self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
    if self:GetParent():GetHealthPercent() > self.hp_lock then
        self:GetParent():SetHealth(self.maxHealth)
    end

    if self:GetParent():GetMaxHealth() >= self:GetAbility():GetSpecialValueFor("line") then
       self.rise = 1 
    end
end

-- advanced_modifier

function modifier_heroTalent_npc_dota_hero_huskar_2:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_huskar_2:AdvancedGetModifierConstantHealthRegen()
    local regen = self:GetAbility():GetSpecialValueFor("hp_regen")*0.01
    local lost_hp = self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth()
    return lost_hp * regen
end

function modifier_heroTalent_npc_dota_hero_huskar_2:AdvancedGetModifierExtraHealthPercentage() return self.bonus_hp end

function modifier_heroTalent_npc_dota_hero_huskar_2:OnTakeDamage(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() or keys.unit:GetTeamNumber() == keys.attacker:GetTeamNumber()then
        return
    end
    if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    if self.rise == 1 then
        local modifier = keys.unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_huskar_2_already")
        if modifier then
            return
        end
        local damageTable = {
			attacker = keys.attacker,
			victim = keys.unit,
			damage = self:GetCaster():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("hp_damage")*0.01,
			damage_type =  self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
			hd_flags =  HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
        keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_huskar_2_already", {})
    end
end


modifier_heroTalent_npc_dota_hero_huskar_2_already = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_huskar_2_already:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_huskar_2_already:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_huskar_2_already:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_huskar_2_already:IsPurgeException() return false end