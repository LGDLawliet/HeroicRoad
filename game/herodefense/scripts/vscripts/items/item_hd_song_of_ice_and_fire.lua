item_hd_song_of_ice_and_fire = class({})

LinkLuaModifier("modifier_item_hd_song_of_ice_and_fire", "items/item_hd_song_of_ice_and_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_of_ice_and_fire_active", "items/item_hd_song_of_ice_and_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_of_ice_and_fire_icedebuff", "items/item_hd_song_of_ice_and_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_of_ice_and_fire_disarm", "items/item_hd_song_of_ice_and_fire", LUA_MODIFIER_MOTION_NONE)

function item_hd_song_of_ice_and_fire:Precache( context )
    PrecacheResource( "particle", "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", context )--0 1 3 
    PrecacheResource( "particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/active_holy_ambient.vpcf", context )
end
function item_hd_song_of_ice_and_fire:GetIntrinsicModifierName()
	return "modifier_item_hd_song_of_ice_and_fire"
end
function item_hd_song_of_ice_and_fire:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_song_of_ice_and_fire_active", {duration = self:GetSpecialValueFor("duration")})
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_hd_song_of_ice_and_fire = advanced_modifier({})

function modifier_item_hd_song_of_ice_and_fire:IsDebuff() return false end
function modifier_item_hd_song_of_ice_and_fire:IsHidden() return true end
function modifier_item_hd_song_of_ice_and_fire:IsPurgable() return false end
function modifier_item_hd_song_of_ice_and_fire:GetTexture() return "item_song_of_ice_and_fire" end

function modifier_item_hd_song_of_ice_and_fire:OnCreated(keys)
    self:SetStackCount(0)
    self.ability = self:GetAbility()
	self.disarm_duration = self.ability:GetSpecialValueFor("disarm_duration")
    self.ice_damage = self.ability:GetSpecialValueFor("ice_damage")
    self.fire_damage = self.ability:GetSpecialValueFor("fire_damage")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.bonus_cooldown = self.ability:GetSpecialValueFor("bonus_cooldown")
end

function modifier_item_hd_song_of_ice_and_fire:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_item_hd_song_of_ice_and_fire:OnAttackLanded(keys)
    if IsServer() and not keys.attacker:IsInSpecialAttack() and not keys.attacker:FindModifierByName("modifier_item_hd_song_of_ice_and_fire_active") and not keys.attacker:IsRangedAttacker() then

        local ability_casting1 = keys.attacker:HasModifier("modifier_Advanced_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_Middle_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_Primary_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_chaotic_Omni_Slash_caster")
        local ability_casting2 = keys.attacker:HasModifier("modifier_Advanced_Focus_Fire") or keys.attacker:HasModifier("modifier_Middle_Focus_Fire") or keys.attacker:HasModifier("modifier_Primary_Focus_Fire") or keys.attacker:HasModifier("modifier_Advanced_Focus_Fire_effect") or keys.attacker:HasModifier("modifier_Middle_Focus_Fire_effect") or keys.attacker:HasModifier("modifier_Primary_Focus_Fire_effect")
        if ability_casting1 or ability_casting2 then
            return
        end
        if self:GetStackCount() == 0 then
            local damageTable = {
                victim = keys.target,
                attacker = keys.attacker,
                damage = keys.attacker:GetAverageTrueAttackDamage(nil) * self.ice_damage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility(), --Optional.
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
                --hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
            }
            ApplyDamage(damageTable)
            keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_item_hd_song_of_ice_and_fire_icedebuff",{})
            self:SetStackCount(1)

            local effect_ice = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, keys.target)
	        ParticleManager:SetParticleControl(effect_ice, 0, Vector(keys.target:GetAbsOrigin().x, keys.target:GetAbsOrigin().y, keys.target:GetAbsOrigin().z + 64))
	        ParticleManager:SetParticleControl(effect_ice, 2, Vector(100, 100, 100))
        else
            local damageTable = {
                --victim = keys.target,
                attacker = keys.attacker,
                damage = keys.attacker:GetAverageTrueAttackDamage(nil) * self.fire_damage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility(), --Optional.
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
            }
            local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for i,enemy in ipairs(enemies) do
                damageTable.victim = enemy
                ApplyDamage(damageTable)
            end
            keys.target:RemoveModifierByName("modifier_item_hd_song_of_ice_and_fire_icedebuff")

            local cd_index = self:GetAbility():GetSpecialValueFor("cd_index")
		    local cd_index_override =1-((1-self:GetCaster():GetCooldownReduction())*cd_index*0.01)
            local duration = self.disarm_duration*cd_index_override
            keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_item_hd_song_of_ice_and_fire_disarm",{duration = duration})
            self:SetStackCount(0)

            local effect_fire = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
	        ParticleManager:SetParticleControl(effect_fire, 0, keys.target:GetAbsOrigin())
	        ParticleManager:SetParticleControl(effect_fire, 3, Vector(keys.target:GetAbsOrigin().x, keys.target:GetAbsOrigin().y, keys.target:GetAbsOrigin().z + 64))
	        ParticleManager:ReleaseParticleIndex(effect_fire)
        end
    end
end

function modifier_item_hd_song_of_ice_and_fire:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_hd_song_of_ice_and_fire:GetModifierAttackSpeedBonus_Constant() 	
	return self:GetStackCount()*300
end
function modifier_item_hd_song_of_ice_and_fire:Advanced_GetModifierCooldownReduction() 	
	return self.bonus_cooldown
end
function modifier_item_hd_song_of_ice_and_fire:Advanced_GetModifierPreAttack_BonusDamage() 	
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_hd_song_of_ice_and_fire_active = advanced_modifier({})

function modifier_item_hd_song_of_ice_and_fire_active:IsDebuff() return false end
function modifier_item_hd_song_of_ice_and_fire_active:IsHidden() return false end
function modifier_item_hd_song_of_ice_and_fire_active:IsPurgable() return false end
function modifier_item_hd_song_of_ice_and_fire_active:GetTexture() return "item_song_of_ice_and_fire" end
function modifier_item_hd_song_of_ice_and_fire_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_song_of_ice_and_fire_active:GetEffectName() return "particles/rebuild/items/song_of_ice_and_fire/active_holy_ambient.vpcf" end

function modifier_item_hd_song_of_ice_and_fire_active:OnCreated(keys)
    self:SetStackCount(0)
    self.ability = self:GetAbility()
	self.disarm_duration_active = self.ability:GetSpecialValueFor("disarm_duration_active")
    self.ice_damage = self.ability:GetSpecialValueFor("ice_damage")
    self.fire_damage = self.ability:GetSpecialValueFor("fire_damage")
    self.radius_active = self.ability:GetSpecialValueFor("radius_active")
end


function modifier_item_hd_song_of_ice_and_fire_active:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_item_hd_song_of_ice_and_fire_active:OnAttackLanded(keys)
    if IsServer() and not keys.attacker:IsInSpecialAttack() and not keys.attacker:IsRangedAttacker() then

        local ability_casting1 = keys.attacker:HasModifier("modifier_Advanced_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_Middle_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_Primary_Omni_Slash_caster") or keys.attacker:HasModifier("modifier_chaotic_Omni_Slash_caster")
        local ability_casting2 = keys.attacker:HasModifier("modifier_Advanced_Focus_Fire") or keys.attacker:HasModifier("modifier_Middle_Focus_Fire") or keys.attacker:HasModifier("modifier_Primary_Focus_Fire") or keys.attacker:HasModifier("modifier_Advanced_Focus_Fire_effect") or keys.attacker:HasModifier("modifier_Middle_Focus_Fire_effect") or keys.attacker:HasModifier("modifier_Primary_Focus_Fire_effect")
        if ability_casting1 or ability_casting2 then
            return
        end

        if self:GetStackCount() == 0 and not keys.attacker:IsRangedAttacker() then
            local damageTable = {
                victim = keys.target,
                attacker = keys.attacker,
                damage = keys.attacker:GetAverageTrueAttackDamage(nil) * self.ice_damage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility(), --Optional.
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
            }
            ApplyDamage(damageTable)
            keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_item_hd_song_of_ice_and_fire_icedebuff",{})
            self:SetStackCount(1)
            local effect_ice = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, keys.target)
	        ParticleManager:SetParticleControl(effect_ice, 0, Vector(keys.target:GetAbsOrigin().x, keys.target:GetAbsOrigin().y, keys.target:GetAbsOrigin().z + 64))
	        ParticleManager:SetParticleControl(effect_ice, 2, Vector(600, 600, 600))
        end
    
        if self:GetStackCount() == 1 then
            local damageTable = {
                --victim = keys.target,
                attacker = keys.attacker,
                damage = keys.attacker:GetAverageTrueAttackDamage(nil) * self.fire_damage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility(), --Optional.
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
            }
            local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius_active, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for i,enemy in ipairs(enemies) do
                damageTable.victim = enemy
                ApplyDamage(damageTable)
            end
            keys.target:RemoveModifierByName("modifier_item_hd_song_of_ice_and_fire_icedebuff")

            local cd_index = self:GetAbility():GetSpecialValueFor("cd_index")
		    local cd_index_override =1-((1-self:GetCaster():GetCooldownReduction())*cd_index*0.01)
            local duration = self.disarm_duration_active*cd_index_override
            keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_item_hd_song_of_ice_and_fire_disarm",{duration = duration})
            self:SetStackCount(0)

            local effect_fire = ParticleManager:CreateParticle("particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	        ParticleManager:SetParticleControl(effect_fire, 0, keys.target:GetAbsOrigin())
	        ParticleManager:SetParticleControl(effect_fire, 1, Vector(self.radius, self.radius, self.radius))
            --ParticleManager:SetParticleControl(effect_fire, 3, Vector(self.radius, self.radius, self.radius))
	        ParticleManager:ReleaseParticleIndex(effect_fire)
            EmitSoundOnLocationWithCaster( keys.target:GetOrigin(), "Ability.LightStrikeArray", keys.target )
        end
    end
end

-------------------------

modifier_item_hd_song_of_ice_and_fire_icedebuff = advanced_modifier({})

function modifier_item_hd_song_of_ice_and_fire_icedebuff:IsDebuff() return true end
function modifier_item_hd_song_of_ice_and_fire_icedebuff:IsHidden() return true end
function modifier_item_hd_song_of_ice_and_fire_icedebuff:IsPurgable() return false end
function modifier_item_hd_song_of_ice_and_fire_icedebuff:GetTexture() return "item_song_of_ice_and_fire" end
function modifier_item_hd_song_of_ice_and_fire_icedebuff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_song_of_ice_and_fire_icedebuff:Advanced_GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("ice_bonus_incoming")
end

-------------------------

modifier_item_hd_song_of_ice_and_fire_disarm = advanced_modifier({})

function modifier_item_hd_song_of_ice_and_fire_disarm:IsDebuff() return true end
function modifier_item_hd_song_of_ice_and_fire_disarm:IsHidden() return true end
function modifier_item_hd_song_of_ice_and_fire_disarm:IsPurgable() return false end
function modifier_item_hd_song_of_ice_and_fire_disarm:GetTexture() return "item_song_of_ice_and_fire" end
function modifier_item_hd_song_of_ice_and_fire_disarm:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_song_of_ice_and_fire_disarm:Advanced_GetModifierIncomingDamage_Percentage()
    if self:GetCaster():HasModifier("modifier_item_hd_song_of_ice_and_fire_active") then
        return  -self:GetAbility():GetSpecialValueFor("incoming_active")
    end
    return -self:GetAbility():GetSpecialValueFor("incoming_down")
end
function modifier_item_hd_song_of_ice_and_fire_disarm:CheckState()
    return{
        [MODIFIER_STATE_DISARMED] = true,
    }
end