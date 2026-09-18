local RuneSync = require("internal/rune_sync")
require("internal/timers")
-- LinkLuaModifier("modifier_fakeDeathDebug", "modifier/modifier_fakeDeathDebug", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_melee_attack_effect", "modifier/modifier_hero_light", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
modifier_hero_light = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hero_light:IsHidden()return true end
function modifier_hero_light:IsDebuff()return false end
function modifier_hero_light:IsStunDebuff()return false end
function modifier_hero_light:IsPurgable()return false end
function modifier_hero_light:IsPurgeException() 	return false end
function modifier_hero_light:RemoveOnDeath() return false end
-- function modifier_hero_light:GetEffectName() return "particles/new_effect/player_deferred_light_rebuild.vpcf" end
-- function modifier_hero_light:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end



function modifier_hero_light:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
 end

function modifier_hero_light:GetModifierMagicalResistanceDirectModification() return -self:GetParent():GetIntellect(false)*0.1 end
function modifier_hero_light:GetModifierBaseAttack_BonusDamage()
    return  self.base_attack_damageFix or 0
end

function modifier_hero_light:GetModifierOverrideAbilitySpecial(keys) 
    -- if keys.ability:GetCaster()==self:GetParent() and self:GetParent():IsRealHero() then
    --     return 1
    -- end
    return 1
end

function modifier_hero_light:OnCreated(table)
    local parent = self:GetParent()
    self.light = ParticleManager:CreateParticle( "particles/new_effect/player_deferred_light_rebuild.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.light, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true )
    -- self:AddParticle( self.light, false, false, -1, true, false )

    if IsServer() then
        -- self.melee_attack_name
        self.apply_attack1 = false
        self.apply_attack2 = false
        self.base_attack_damageFix = 0
        self:SetHasCustomTransmitterData( true )
        self:StartIntervalThink(1)

      
        self.health_1_count = 0

        -- self:AddParticle( self.light, false, false, -1, true, false )
    end
end
function modifier_hero_light:OnIntervalThink()
    -- self:GetParent():CalculateStatBonus(true)
    -- if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_ALL  then
    --     self.base_attack_damageFix = -self:GetParent():GetPrimaryStatValue()*0.15
    -- else
    --     self.base_attack_damageFix = 0 
    -- end


    if self:GetParent():GetHealth()==1 then
        self.health_1_count = self.health_1_count + 1
        if self.health_1_count>=5 then
            ApplyDamage({
                ability = nil,
                attacker = self:GetParent(),
                victim = self:GetParent(),
                damage = 500,
                damage_type = DAMAGE_TYPE_PURE,
                
            })
            
        end
    else
        self.health_1_count = 0
    end

end


function modifier_hero_light:GetModifierOverrideAbilitySpecialValue( params )
    local ability = params.ability
	local caster = self:GetParent()
    
    local szSpecialValueName = params.ability_special_value
	local nSpecialLevel = params.ability_special_level

    local abilityName= ability:GetAbilityName()
    local baseValue = ability:GetLevelSpecialValueNoOverride(szSpecialValueName, nSpecialLevel)
    if string.match(abilityName, "Advanced_")  then
        local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..abilityName
        local key = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
        
        if key then
            local advanced_level = key.level
            if szSpecialValueName=="advanced_level" then
                return advanced_level
            end
            local value = 0
    
            if ability.CheckKV then
                value = ability:CheckKV(szSpecialValueName)
            end
            if ability.CheckKVFixedOverride then
                local fixed = ability:CheckKVFixedOverride(szSpecialValueName)
                if fixed~=-999999 then
                    return fixed
                end
            end
            if value~=0 and value~=-1 then
                advanced_level = advanced_level + GetAdvancedLevelBonus(caster, params)
                value = value *advanced_level + baseValue
                return value
            end
            return baseValue
        end
    elseif string.match(abilityName, "chaotic_")  then
        if ability.CheckKVFixedOverride then
            local fixed = ability:CheckKVFixedOverride(szSpecialValueName)
            if fixed~=-999999 then
                return fixed
            end
        end
        -- print("abilityName=",abilityName)
        -- print("szSpecialValueName=",szSpecialValueName)
        if not self[abilityName] then
            self[abilityName] = {}
        end
        if not self[abilityName][szSpecialValueName] then
            self[abilityName][szSpecialValueName] = 0
            local playerId = caster:GetPlayerOwnerID()
            if playerId>=0 then
                local data = RuneSync.GetEquipped(playerId, abilityName)
                -- DeepPrint(data)
                
                if data then
                    
                    
                    local kv = KeyValues.chaotic_spell_runeData[abilityName]
                    if kv then
                        kv = kv.special
                        local bonus = data.specicaValue[szSpecialValueName];
                        if bonus then
                            local level = tonumber(data.rarity)
                            local min_bonus = kv[szSpecialValueName].min_value.base + kv[szSpecialValueName].min_value.level_step * level;
                            local max_bonus = kv[szSpecialValueName].max_value.base + kv[szSpecialValueName].max_value.level_step * level;
                            local realBonusValue = math.floor((min_bonus+(max_bonus-min_bonus)*bonus)*100)/100;
                            if level==4 then
                                realBonusValue = math.floor(realBonusValue *1.6)
                            end
                            if kv[szSpecialValueName].Type==1 then
                                self[abilityName][szSpecialValueName] = baseValue * (realBonusValue*0.01)
                            elseif kv[szSpecialValueName].Type==2 then
                                self[abilityName][szSpecialValueName] = realBonusValue
                            elseif kv[szSpecialValueName].Type==3 then
                                self[abilityName][szSpecialValueName] = -baseValue * (realBonusValue*0.01)
                            else
                                self[abilityName][szSpecialValueName] = -realBonusValue
                            end
                            
                        end
                    end
                   
                end
            end
        end

    

        return baseValue + self[abilityName][szSpecialValueName]
              




        
    end


	return baseValue
end


function modifier_hero_light:Precache( context )
    PrecacheResource( "particle", "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/special_effect/top10_effect/001/energy.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl1.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl2.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl3.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_9/effect_flying.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_cursed/courier_cursed_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", context )

    PrecacheResource( "particle", "particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf", context )

    PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_void_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_int_2012/courier_trail_international_2012.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_trail_ruby/courier_trail_ruby.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_trail_earth/courier_trail_earth.vpcf", context )

    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_28/effect.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpc", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", context )

    PrecacheResource( "particle", "particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012.vpcf", context )

    
    PrecacheResource( "particle", "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves_b.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_38/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_38/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_38/effect_lv3.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_38/effect_lv4.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_43/effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/ti9/ti9_emblem_effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/ti8/ti8_hero_effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_47/effect_top_model.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/naga/naga_ti10_immortal_head/naga_ti10_immortal_song_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_49/effect_crystal.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_49/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_49/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/effect/econ/items/leshrac/leshrac_ti9_immortal_head/leshrac_ti9_immortal_ambient_hair.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_53/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_53/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_53/effect_lv3.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_babyroshan_winter18/courier_babyroshan_winter18_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_beetlejaw/courier_beetlejaw_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_beetlejaw_gold/courier_beetlejaw_gold_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_61/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_62/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_63/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_3.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_4.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_5.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_6.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_64/effect_7.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_72/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_74/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_74/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_73/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_76/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_77/effect_hadowshaman_shackle_net_fall20.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_77/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_77/effect_red_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_81/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuidl/particle_effect/attach_82/effect_drop.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_83/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_84/effect_cube.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_86/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_87/effectcoins.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_87/effect_lv2coins.vpcf", context )
    PrecacheResource( "particle", "particles/dev/curlnoise_test.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_90/effect_buff.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_91/effect.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_92/effect_lv2.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_92/effect_lv3.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_95/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_96/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_98/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_99/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_98/effect_lv2.vpcf", context )
    
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_98/effect_lv3.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_98/effect_lv4_goldambient.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/fall_2022/player/fall_2022_emblem_effect_player_base.vpcf", context )



    PrecacheResource( "particle", "particles/rebuild/particle_effect/melee_attack_1/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/melee_attack_2/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/particle_effect/melee_attack_3/effect.vpcf", context )

    PrecacheResource( "particle", "particles/rebuild/achievement/achievement_platinum_millionaire_parent.vpcf", context )

    

   
end
function modifier_hero_light:AddCustomTransmitterData( )
	return
	{
		base_attack_damageFix = self.base_attack_damageFix
	}
end

function modifier_hero_light:HandleCustomTransmitterData( data )
	self.base_attack_damageFix = data.base_attack_damageFix
end

-- 配置特效
function modifier_hero_light:attach_particle_1()
  

    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_2()

    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )

end
function modifier_hero_light:attach_particle_3()

    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/special_effect/top10_effect/001/energy.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )

end


function modifier_hero_light:attach_particle_4()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl1.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_5()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_6()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_7()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_8()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_9()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_9/effect_flying.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 10, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_10()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_11()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_12()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_13()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_14()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_cursed/courier_cursed_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_15()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_16()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_17()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_void_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_18()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_19()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_20()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_int_2012/courier_trail_international_2012.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_21()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_22()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_ruby/courier_trail_ruby.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 16, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_23()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_24()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_25()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_26()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_earth/courier_trail_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_27()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_28()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_28/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 2, Vector(255,255,255))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_29()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_28/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 2, Vector(0,186,255))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_30()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_28/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 2, Vector(255,153,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_31()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_28/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 2, Vector(0,255,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_32()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_33()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_34()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )

    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_35()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_36()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_37()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves_b.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_38()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_38/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_39()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_38/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_40()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_38/effect_lv3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_41()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_38/effect_lv4.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_42()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_43()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_43/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 5, Vector(0.8,0.8,0.8))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_44()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/ti9/ti9_emblem_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_45()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/ti8/ti8_hero_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_46()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end




function modifier_hero_light:attach_particle_47()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_47/effect_top_model.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_48()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/naga/naga_ti10_immortal_head/naga_ti10_immortal_song_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_49()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_49/effect_crystal.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_50()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_49/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_51()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_49/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_52()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/effect/econ/items/leshrac/leshrac_ti9_immortal_head/leshrac_ti9_immortal_ambient_hair.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_53()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_53/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(150,0,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_54()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_53/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(150,0,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_55()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_53/effect_lv3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )

    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(150,0,0))
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_56()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_babyroshan_winter18/courier_babyroshan_winter18_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 7, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 8, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 9, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 10, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_57()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_beetlejaw/courier_beetlejaw_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_58()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_beetlejaw_gold/courier_beetlejaw_gold_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_59()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_60()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_61()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_61/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_62()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_62/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_63()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_63/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )

    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_64()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_b.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(150,0,0))
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 6, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 7, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 8, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 9, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 10, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 4, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_65()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_66()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_67()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_4.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_68()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_5.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_69()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_6.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_70()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_64/effect_7.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_72()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_72/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_73()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_73/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_74()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_74/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(300,0,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_75()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_74/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.attach_particle, 1, Vector(300,0,0))
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_76()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_76/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_77()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_77/effect_hadowshaman_shackle_net_fall20.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_78()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_77/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_79()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_77/effect_red_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_80()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_81()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_81/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_82()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuidl/particle_effect/attach_82/effect_drop.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_83()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_83/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_84()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_84/effect_cube.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_85()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_84/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end




function modifier_hero_light:attach_particle_86()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_86/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_87()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_87/effectcoins.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end




function modifier_hero_light:attach_particle_88()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_87/effect_lv2coins.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_89()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/dev/curlnoise_test.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_90()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_90/effect_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_91()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_91/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end



function modifier_hero_light:attach_particle_92()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_93()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_92/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_94()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_92/effect_lv3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_95()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_91/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_96()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_96/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.attach_particle, 3, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_98()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_98/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_99()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_99/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_101()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_98/effect_lv2.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_hero_light:attach_particle_102()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_98/effect_lv3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end

function modifier_hero_light:attach_particle_103()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/particle_effect/attach_98/effect_lv4_goldambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_104()
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW,nil, parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_105()
  

    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_2022/player/fall_2022_emblem_effect_player_base.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end


function modifier_hero_light:attach_particle_platinum_millionaire()
  

    local parent = self:GetParent()
    self.achievement_particle = ParticleManager:CreateParticle( "particles/rebuild/achievement/achievement_platinum_millionaire_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.achievement_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
    self:AddParticle( self.achievement_particle, false, false, -1, true, false )
end













function modifier_hero_light:OnAttackStart(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() then
		return
	end

    if self.melee_attack_name and not keys.attacker:IsRangedAttacker() then
        if self.melee_modifier and not self.melee_modifier:IsNull() then
            self.melee_modifier:SetDuration(0.5, false)
        else
            self.melee_modifier =  keys.attacker:AddNewModifier(keys.attacker, nil, "modifier_melee_attack_effect", {duration =0.5})
            if self.melee_modifier and not self.melee_modifier:IsNull() then
                self.melee_modifier:InitParticle(self.melee_attack_name,self.apply_attack1,self.apply_attack2)
            end
        end
        
    end
	
	
end


function modifier_hero_light:melee_attack_1()
    self.melee_attack_name = "particles/rebuild/particle_effect/melee_attack_1/effect.vpcf"
    self.apply_attack1 = true
    self.apply_attack2 = true
end

function modifier_hero_light:melee_attack_2()
    self.melee_attack_name = "particles/rebuild/particle_effect/melee_attack_2/effect.vpcf"
    self.apply_attack1 = true
    self.apply_attack2 = true
end
function modifier_hero_light:melee_attack_3()
    self.melee_attack_name = "particles/rebuild/particle_effect/melee_attack_3/effect.vpcf"
    -- self.apply_attack1 = true
    self.apply_attack2 = true
end



modifier_melee_attack_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_melee_attack_effect:IsHidden()return true end
function modifier_melee_attack_effect:IsDebuff()return false end
function modifier_melee_attack_effect:IsStunDebuff()return false end
function modifier_melee_attack_effect:IsPurgable()return false end
function modifier_melee_attack_effect:IsPurgeException() 	return false end
function modifier_melee_attack_effect:RemoveOnDeath() return false end
function modifier_melee_attack_effect:InitParticle(melee_attack_name,attack1,attack2)
    local parent = self:GetParent()
    -- print("init")
    if attack1  then
        local attach = parent:HDGetMeleeAttachMent(true)
        -- print("attach="..attach)
        if parent:HDHasAttachMent(attach) then
            self.meleeattack_particle1 = ParticleManager:CreateParticle( melee_attack_name, PATTACH_ABSORIGIN_FOLLOW,parent )
            ParticleManager:SetParticleControlEnt( self.meleeattack_particle1, 0, parent, PATTACH_POINT_FOLLOW, attach, parent:GetAbsOrigin(), true )
            -- self:AddParticle( self.meleeattack_particle1, false, false, -1, true, false )
        end

    end
    if attack2  then
        local attach = parent:HDGetMeleeAttachMent(false)
        -- print("attach="..attach)
        if parent:HDHasAttachMent(attach) then
            self.meleeattack_particle2 = ParticleManager:CreateParticle( melee_attack_name, PATTACH_ABSORIGIN_FOLLOW,parent )
            ParticleManager:SetParticleControlEnt( self.meleeattack_particle2, 0, parent, PATTACH_POINT_FOLLOW, attach, parent:GetAbsOrigin(), true )
            -- self:AddParticle( self.meleeattack_particle1, false, false, -1, true, false )
        end
    end
end

function modifier_melee_attack_effect:OnDestroy()
    if IsServer() then
        if self.meleeattack_particle1 then
            ParticleManager:DestroyParticle(self.meleeattack_particle1,false)
            ParticleManager:ReleaseParticleIndex(self.meleeattack_particle1)
            -- self.meleeattack_particle1 = nil
        end
        if self.meleeattack_particle2 then
            ParticleManager:DestroyParticle(self.meleeattack_particle2,false)
            ParticleManager:ReleaseParticleIndex(self.meleeattack_particle2)
            -- self.meleeattack_particle2 = nil
        end
    end
end




function modifier_hero_light:Del(type)
    if type =="2001"or type==-1 or type==2001  then
        if self.attach_particle then
            ParticleManager:DestroyParticle(self.attach_particle,true)
            ParticleManager:ReleaseParticleIndex(self.attach_particle)
            self.attach_particle = nil
        end
    end
    if type =="2002"or type==-1 or type==2002  then
        -- if self.meleeattack_particle1 then
        --     ParticleManager:DestroyParticle(self.meleeattack_particle1,true)
        --     ParticleManager:ReleaseParticleIndex(self.meleeattack_particle1)
        --     self.meleeattack_particle1 = nil
        -- end
        -- if self.meleeattack_particle2 then
        --     ParticleManager:DestroyParticle(self.meleeattack_particle2,true)
        --     ParticleManager:ReleaseParticleIndex(self.meleeattack_particle2)
        --     self.meleeattack_particle2 = nil
        -- end
        
        self.melee_attack_name = nil
        self.apply_attack1 = false
        self.apply_attack2 = false
    end
end