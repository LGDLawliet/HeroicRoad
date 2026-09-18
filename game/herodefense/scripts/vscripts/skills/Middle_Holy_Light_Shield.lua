Middle_Holy_Light_Shield = class({})

LinkLuaModifier("modifier_Middle_Holy_light_shield", "skills/Middle_Holy_light_shield", LUA_MODIFIER_MOTION_NONE)
function Middle_Holy_Light_Shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/holy_light_shield/effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/fall_2022/mjollnir/mjollnir_shield_fall2022.vpcf", context )
end
function Middle_Holy_Light_Shield:OnSpellStart()
    local target = self:GetCaster()
    local buff = target:FindModifierByName("modifier_Middle_Holy_light_shield")
    if buff then
        buff:SetStackCount(0)
        buff:SafeDestroy()
    end
    local modifierStatusgain = self:GetCaster():GetModifierDurationGainIndex(1)
    target:AddNewModifier(self:GetCaster(),self,"modifier_Middle_Holy_light_shield",{duration = self:GetSpecialValueFor("duration")*modifierStatusgain})
    target:Purge(false, true, false, true, false)
end

modifier_Middle_Holy_light_shield = advanced_modifier({})

function modifier_Middle_Holy_light_shield:IsDebuff()          return false end
function modifier_Middle_Holy_light_shield:IsHidden()          return false end
function modifier_Middle_Holy_light_shield:IsPurgable()        return false  end
function modifier_Middle_Holy_light_shield:IsPurgeException()  return false  end

function modifier_Middle_Holy_light_shield:OnCreated()
    if IsServer() then
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        local parent = self:GetParent()
        local shield = ability:GetSpecialValueFor("hp_shield")*caster:GetMaxHealth()
        self:SetStackCount(shield)
        EmitSoundOn("Hero_Sven.WarCry.Shield",parent)
        local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_2022/mjollnir/mjollnir_shield_fall2022.vpcf",PATTACH_POINT_FOLLOW,parent)
        ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
        self:AddParticle(pfx, false, false, 15, false, false)

        self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/holy_light_shield/effect.vpcf",PATTACH_POINT_FOLLOW,parent)
        ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
        local ex = parent:GetModelScale() * 100
        ParticleManager:SetParticleControl(self.pfx, 1, Vector(ex,ex,ex))
        self:AddParticle(self.pfx, false, false, 15, false, false)
    end
end


function modifier_Middle_Holy_light_shield:OnDestroy()
    if IsServer() then
        if self:GetStackCount() > 0 then
            -- local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_destruction_rings.vpcf",PATTACH_CUSTOMORIGIN,self:GetParent())
            -- local pos = self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment(""))
            -- ParticleManager:SetParticleControl(pfx, 0, pos)
            -- ParticleManager:SetParticleControl(pfx, 5, pos)
            -- ParticleManager:ReleaseParticleIndex(pfx)
            ParticleManager:DestroyParticle(self.pfx,false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            local ability = self:GetAbility()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local damage = ability:GetSpecialValueFor("damage_hp")*self:GetStackCount()
            -- StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
            EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)

            local enemies = FindUnitsInRadius(
                                              caster:GetTeamNumber(), 
                                              parent:GetAbsOrigin(), 
                                              nil, 
                                              ability:GetSpecialValueFor("radius"), 
                                              DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                              DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
                                              DOTA_UNIT_TARGET_FLAG_NONE, 
                                              FIND_ANY_ORDER, 
                                              false
                                            )
            local damagetable = {
                attacker = caster,
                damage = damage,
                damage_type = ability:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
            }
        


            for i, enemy in pairs(enemies)do

               damagetable.victim = enemy

                ApplyDamage(damagetable)
                if i > 10 then
                    break
                end
            end
        else
           
            local Ability = self:GetAbility()
            local Cooldown = Ability:GetSpecialValueFor("cooldown_reduction")
            local newCooldown = Ability:GetCooldownTimeRemaining() - Cooldown
            Ability:EndCooldown()
            if newCooldown > 0 then
                Ability:StartCooldown(newCooldown)
            end
                
               
        end
        

        

    end
end





function modifier_Middle_Holy_light_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_Middle_Holy_light_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack
end