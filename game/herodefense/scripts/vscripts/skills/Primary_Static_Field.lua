Primary_Static_Field = class({})
LinkLuaModifier("modifier_Primary_Static_Field", "skills/Primary_Static_Field.lua", LUA_MODIFIER_MOTION_NONE)







function Primary_Static_Field:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field/effect.vpcf", context )
end




function Primary_Static_Field:IsHiddenWhenStolen() 
    return false 
end

function Primary_Static_Field:IsStealable() 
    return false 
end

function Primary_Static_Field:IsNetherWardStealable() 
    return false 
end


function Primary_Static_Field:GetIntrinsicModifierName() 
    return "modifier_Primary_Static_Field" 
end
function Primary_Static_Field:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

modifier_Primary_Static_Field = class({})

function modifier_Primary_Static_Field:IsPassive()
	return true
end

function modifier_Primary_Static_Field:IsBuff()				
    return true 
end

function modifier_Primary_Static_Field:IsPurgable() 		return false end
function modifier_Primary_Static_Field:IsPurgeException() 	return false end
function modifier_Primary_Static_Field:RemoveOnDeath()  return false end

function modifier_Primary_Static_Field:IsHidden()				
    return false 
end


function modifier_Primary_Static_Field:OnAbilityExecuted(keys)  
    if IsServer() then
        if keys.ability:GetCooldown(keys.ability:GetLevel()) < 1 or keys.unit ~= self:GetParent() then
            return
        end
        if self:GetParent():PassivesDisabled() then
            return
        end
	    self:GetParent():EmitSound("Hero_Zuus.StaticField")
	    local radius = self:GetAbility():GetSpecialValueFor("radius")
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        local damage = self:GetAbility():GetSpecialValueFor("spell_damage") * self:GetCaster():GetIntellect(false)
        if keys.ability:GetCooldown(keys.ability:GetLevel()) < 3 and keys.ability:GetManaCost(keys.ability:GetLevel()) <= 50 then
            damage = damage * 0.3
        end
        local number = self:GetAbility():GetSpecialValueFor("effect_amount")
        local i = 0
        for _,target in pairs(enemies) do
		    if target ~= nil and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
                self:PlayEffect(self:GetParent(),target)
                local damage= {
                    victim = target,
                    attacker = self:GetParent(),
                    damage = damage,
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    damage_flags =DOTA_UNIT_TARGET_FLAG_NONE, 
                    ability = self:GetAbility(),
                    hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
                }
	    	    ApplyDamage(damage)
                i = i + 1 
                if i>=number then
                    break
                end
            end
        end
    end
end

function modifier_Primary_Static_Field:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end


function modifier_Primary_Static_Field:PlayEffect(source,target)
    local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/static_field/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(head_particle, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    DestroyParticleByDelay(head_particle,1)
    

end

