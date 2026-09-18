chaotic_summon_crazy = class({})
LinkLuaModifier("modifier_chaotic_summon_crazy_active", "chaotic_spell/class_8/chaotic_summon_crazy", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_crazy:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf", context )
end

function chaotic_summon_crazy:IsSummonSpell()return true end
function chaotic_summon_crazy:GetCooldown(iLevel)
    return self:GetSpecialValueFor("cooldown_time")
end
function chaotic_summon_crazy:OnSpellStart()
    local caster = self:GetCaster()
    local gain = caster:GetModifierDurationGainIndex(0.8)
    local duration = self:GetSpecialValueFor("duration")*gain
    local hp_cost = self:GetSpecialValueFor("hp_cost")*0.01
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
        if unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and unit:IsAlive() then
            unit:ModifyHealth(unit:GetHealth()*(1-hp_cost), self, false, 0)
            unit:AddNewModifier(caster, self, "modifier_chaotic_summon_crazy_active", {duration = duration})
            
            local random_response = RandomInt(1, 4)
            unit:EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
            unit:EmitSound("Hero_OgreMagi.Bloodlust.Target")
            EmitSoundOn( "Hero_LifeStealer.Rage", unit )
        end
    end
end


modifier_chaotic_summon_crazy_active = advanced_modifier({})

function modifier_chaotic_summon_crazy_active:IsDebuff() return false end
function modifier_chaotic_summon_crazy_active:IsHidden() return false end
function modifier_chaotic_summon_crazy_active:IsPurgable() 		return false end
function modifier_chaotic_summon_crazy_active:IsPurgeException() 	return false end
function modifier_chaotic_summon_crazy_active:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_chaotic_summon_crazy_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_summon_crazy_active:OnCreated(keys)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
    self.move = self:GetAbility():GetSpecialValueFor("move")
    self.steal = self:GetAbility():GetSpecialValueFor("steal")
	if IsServer() then
		self:StartIntervalThink(1.5)

        self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
    end
end

function modifier_chaotic_summon_crazy_active:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local random = math.random
    if 40 >= random(1,100) then
	    for i=0, parent:GetAbilityCount() - 1 do
		    local Ability = parent:GetAbilityByIndex(i)
		    if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
			    Ability:EndCooldown()
		    end
        end
	end
end

function modifier_chaotic_summon_crazy_active:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_CastPoint
    }
end

function modifier_chaotic_summon_crazy_active:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE_CONSTANT,
    }
end
function modifier_chaotic_summon_crazy_active:Advanced_GetModifierAttackSpeedPercentage()
    return self.speed
end
function modifier_chaotic_summon_crazy_active:GetModifierMoveSpeedBonus_Percentage()
    return self.move
end
function modifier_chaotic_summon_crazy_active:Advanced_GetModifier_LifeSteal_AttackDamage()
    return self.steal
end
function modifier_chaotic_summon_crazy_active:AdvancedGetModifierConstantManaRegen()
    return 200
end
function modifier_chaotic_summon_crazy_active:Advanced_GetModifierIncomingDamage_Percentage()
    return -50
end
function modifier_chaotic_summon_crazy_active:GetModifierModelScaleConstant()
    return 1.5
end
function modifier_chaotic_summon_crazy_active:Advanced_GetModifier_CastPoint()
    return 200
end