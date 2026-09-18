Primary_Multiple_overlapping_waves = class ({})

LinkLuaModifier("modifier_Primary_Multiple_overlapping_waves", "skills/Primary_Multiple_overlapping_waves", LUA_MODIFIER_MOTION_NONE)



function Primary_Multiple_overlapping_waves:IsHiddenWhenStolen()       return false end
function Primary_Multiple_overlapping_waves:IsRefreshable()            return true end
function Primary_Multiple_overlapping_waves:IsStealable()              return true end
function Primary_Multiple_overlapping_waves:IsNetherWardStealable()    return true end
function Primary_Multiple_overlapping_waves:GetAOERadius()             return self:GetSpecialValueFor("radius") end

function Primary_Multiple_overlapping_waves:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    caster:EmitSound("Hero_Sven.StormBolt")
    local pfxname = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_tgw_bolt_child_b.vpcf"
    local info = {
                  Target = target,
                  Source = caster,
                  Ability = self,
                  EffectName = pfxname,
                  iMoveSpeed = 1000,
                  vSourceLoc = caster:GetAbsOrigin(),
                  DrawsOnMinimapb = false,
                  bDodgeable = true,
                  bIsAttack = false,
                  bVisibleToEnemies = true,
                  bReplaceExisting = false,
                  flExpireTime = GameRules:GetGameTime() + 5,
                  bProvidesVision = false 
                 }
    ProjectileManager:CreateTrackingProjectile(info)
end

function Primary_Multiple_overlapping_waves:OnProjectileHit(Target,location)
    if IsServer() then
        if Target ~= nil then
            local caster = self:GetCaster()
            Target:EmitSound("Hero_Sven.StormBoltImpact")
            local radius = self:GetSpecialValueFor("radius")
            local dmg = self:GetSpecialValueFor("Damage") + caster:GetAttackCapability() * self:GetSpecialValueFor("Attack2")
            local dmg2 = dmg * 0.5
            local Count = self:GetSpecialValueFor("Number")
            local pfx = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_melee001_lvl3_rings.vpcf",PATTACH_CUSTOMORIGIN,Target)
            local pos = Target:GetAttachmentOrigin(Target:ScriptLookupAttachment(""))
            ParticleManager:SetParticleControl(pfx, 0, pos)
            ParticleManager:ReleaseParticleIndex(pfx)
            local enemies = FindUnitsInRadius(
                                                caster:GetTeamNumber(), 
                                                Target:GetAbsOrigin(), 
                                                nil, 
                                                radius, 
                                                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                                DOTA_UNIT_TARGET_FLAG_NONE, 
                                                FIND_ANY_ORDER,
                                                false
                                             )
            local damageTable = {
                victim = Target ,
                attacker = caster ,
                damage = dmg ,
                damage_type = self:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE ,
                ability = self
            }
            
            ApplyDamage(damageTable)

            damageTable.damage = dmg2

            for i , enemy in pairs(enemies) do
                if enemy ~= Target then
                    damageTable.victim = enemy
                    ApplyDamage(damageTable)
                        if i > Count then
                            break
                        end
                    else
                        i = i - 1
                end
                
            end
            local buff = caster:FindModifierByName("modifier_Primary_Multiple_overlapping_waves")
            if buff then
                buff:SafeDestroy()
            end
            local modifierStatusgain = self:GetCaster():GetModifierDurationGainIndex(1)
            caster:AddNewModifier(caster, self, "modifier_Primary_Multiple_overlapping_waves", {duration = self:GetSpecialValueFor("duration")*modifierStatusgain})
            caster:Purge(false, true, false, true, false)
    
         
        else
            return
        end
    end
end

modifier_Primary_Multiple_overlapping_waves = class ({})

function modifier_Primary_Multiple_overlapping_waves:IsDebuff()			return false end
function modifier_Primary_Multiple_overlapping_waves:IsHidden() 		return false end
function modifier_Primary_Multiple_overlapping_waves:IsPurgable() 		return false end
function modifier_Primary_Multiple_overlapping_waves:IsPurgeException() return false end

function modifier_Primary_Multiple_overlapping_waves:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end

function modifier_Primary_Multiple_overlapping_waves:GetModifierPreAttack_BonusDamage() 
   return self.bonus_damage
end 

function modifier_Primary_Multiple_overlapping_waves:OnCreated()
    local Ability = self:GetAbility()
    self.bonus_damage = (Ability:GetSpecialValueFor("bonus_attack"))

    if IsServer() then
        local caster = self:GetParent()
        local heal = Ability:GetSpecialValueFor("heal")
        local healing = HealWithGain(heal,caster,caster,Ability)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
    end
end