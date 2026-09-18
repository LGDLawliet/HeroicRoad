heroTalent_npc_dota_hero_visage = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_visage_aura", "heroTalent/heroTalent_npc_dota_hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_visage_effect", "heroTalent/heroTalent_npc_dota_hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_visage_finish", "heroTalent/heroTalent_npc_dota_hero_visage", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_visage:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_visage:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_visage:IsStealable() 				return true end
function heroTalent_npc_dota_hero_visage:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_visage:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_visage_aura" end
function heroTalent_npc_dota_hero_visage:GetCastRange()		return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus() end
------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_visage_aura = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_visage_aura:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_visage_aura:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_visage_aura:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_visage_aura:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_visage_aura:RemoveOnDeath()  return false end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_visage_aura:IsAura()
	return true
end

function modifier_heroTalent_npc_dota_hero_visage_aura:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_visage_effect" end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_heroTalent_npc_dota_hero_visage_aura:OnCreated()
    self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.line3 = self:GetAbility():GetSpecialValueFor("line3")
end


function modifier_heroTalent_npc_dota_hero_visage_aura:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
    return funcs
end
function modifier_heroTalent_npc_dota_hero_visage_aura:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
    return funcs
end


function modifier_heroTalent_npc_dota_hero_visage_aura:Advanced_GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()*self.bonus_attack
end
function modifier_heroTalent_npc_dota_hero_visage_aura:GetModifierAttackSpeedBonus_Constant()
    if self:GetStackCount()>=self:GetAbility():GetSpecialValueFor("line1") then
        return self.bonus_attack_speed
    end
    return 0
end
function modifier_heroTalent_npc_dota_hero_visage_aura:Advanced_GetModifierAttackRangeBonus()
    if self:GetStackCount()>=self:GetAbility():GetSpecialValueFor("line2") then
        return self.bonus_attack_range
    end
    return 0
end

function modifier_heroTalent_npc_dota_hero_visage_aura:OnAttackLanded(keys)
    if IsServer() and self:GetStackCount() >= self.line3 then
        local target = keys.target
        if not target:IsAlive() then return end
        
        local modifier =target:HasModifier("modifier_heroTalent_npc_dota_hero_visage_finish")
        if not modifier then
            target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_visage_finish",{})
            EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_ObsidianDestroyer.projectileImpact", self:GetCaster())
	        local damage = self:GetAbility():GetSpecialValueFor("maxhp_damage")*0.01 *target:GetMaxHealth()
	        
            target:ModifyHealth(target:GetHealth()-damage, self:GetAbility(), false, 0)
        end
    end
end
------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_visage_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_visage_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_visage_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_visage_effect:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_visage_effect:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_visage_effect:RemoveOnDeath()  return false end
function modifier_heroTalent_npc_dota_hero_visage_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_visage_effect:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_Wave_End = {},
    }
end
function modifier_heroTalent_npc_dota_hero_visage_effect:OnDeath(params)
    if IsServer() then
        local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_visage_aura")
        if modifier:GetStackCount() < _G.GAME_ROUND*self:GetAbility():GetSpecialValueFor("turn_max") then
            modifier:SetStackCount(math.min((modifier:GetStackCount() + 1),self:GetAbility():GetSpecialValueFor("max")))
            self:PlayEffects(params.unit)
        end
        
    end
end

function modifier_heroTalent_npc_dota_hero_visage_effect:PlayEffects(target)
	-- Get Resources
	local projectile_name = "particles/rebuild/spell/abadon_telent/abadon_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetCaster(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 1000,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_visage_finish = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_visage_finish:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_visage_finish:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_visage_finish:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_visage_finish:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_visage_finish:RemoveOnDeath()  return false end
