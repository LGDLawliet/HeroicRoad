heroTalent_npc_dota_hero_legion_commander_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_legion_commander_3", "heroTalent/heroTalent_npc_dota_hero_legion_commander_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_legion_commander_3_effect", "heroTalent/heroTalent_npc_dota_hero_legion_commander_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_legion_commander_3_death", "heroTalent/heroTalent_npc_dota_hero_legion_commander_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_legion_commander_3_active", "heroTalent/heroTalent_npc_dota_hero_legion_commander_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_legion_commander_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", context )
end

function heroTalent_npc_dota_hero_legion_commander_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_legion_commander_3"
end

--------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_legion_commander_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:IsAura() return true end

function modifier_heroTalent_npc_dota_hero_legion_commander_3:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_legion_commander_3_effect" end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:GetAuraRadius()	return -1  end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_heroTalent_npc_dota_hero_legion_commander_3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_heroTalent_npc_dota_hero_legion_commander_3:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3:OnDeath(keys)
    if not IsServer() then
        return
    end
    local heros = GetAllRealHeroes()
    for _,hero in pairs(heros) do
        hero:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_legion_commander_3_death", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        EmitSoundOn("Hero_LegionCommander.Overwhelming.Buff", hero)
    end
    
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then
        return
    end
    keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_legion_commander_3_active", {duration = self:GetAbility():GetSpecialValueFor("active_duration")})
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3:AdvancedOnDeathAgain(keys)
    if not IsServer() then
        return
    end
    local heros = GetAllRealHeroes()
    for _,hero in pairs(heros) do
        hero:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_legion_commander_3_death", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        EmitSoundOn("Hero_LegionCommander.Overwhelming.Buff", hero)
    end
end

--------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_legion_commander_3_death = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:GetEffectName() return "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf" end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:OnRefresh()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_death:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
--------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_legion_commander_3_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:OnCreated()
	self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:OnRefresh()
	self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_active:Advanced_GetModifier_StatusResistance()
	return self.bonus_status
end

--------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_legion_commander_3_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:OnCreated()
	self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
end
function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:OnRefresh()
	self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_legion_commander_3_effect:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.bonus_attack
end

