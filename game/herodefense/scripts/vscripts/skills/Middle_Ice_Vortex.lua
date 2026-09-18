Middle_Ice_Vortex = class({})

LinkLuaModifier("modifier_Middle_Ice_Vortex_1", "skills/Middle_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ice_Vortex_debuff", "skills/Middle_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_normal_stun", "skills/skills_effect/modifier_normal_stun", LUA_MODIFIER_MOTION_NONE)

function Middle_Ice_Vortex:IsHiddenWhenStolen()       return false end
function Middle_Ice_Vortex:IsStealable() 	            return true end
function Middle_Ice_Vortex:IsNetherWardStealable()    return true end
function Middle_Ice_Vortex:IsRefreshable() 			return true end
function Middle_Ice_Vortex:ProcsMagicStick() 			return true end
function Middle_Ice_Vortex:GetAOERadius() 			return self:GetSpecialValueFor("radius")end

function Middle_Ice_Vortex:OnSpellStart()
	local curpos = self:GetCursorPosition()
    local caster = self:GetCaster() 
    local pos = TG_Direction(curpos,caster:GetAbsOrigin())
    local damage = self:GetSpecialValueFor("basic_damage")+ caster:GetIntellect(false) * self:GetSpecialValueFor("intelligence_index")
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("life_duration")
    local stun = self:GetSpecialValueFor("stun_duration")
    EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", caster)

    local particle = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/ice_windrun.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle, 0, curpos+caster:GetUpVector()*90)
	ParticleManager:SetParticleControl( particle, 3, Vector(radius,0,0))
    ParticleManager:SetParticleControl( particle, 60, Vector(radius*1.2,0,0))
	local particle3 = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/ice_windrun.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle3, 0, curpos+caster:GetUpVector()*180)
    ParticleManager:SetParticleControl( particle3, 60, Vector(radius*1.2,0,0))
	local particle2 = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/new_ice_wind_dust.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle2, 0, curpos+caster:GetUpVector()*100)
    ParticleManager:SetParticleControl( particle2, 60, Vector(radius*1.2,0,0))
    CreateModifierThinker(caster, self, "modifier_Middle_Ice_Vortex_1", {duration =duration}, curpos, caster:GetTeamNumber(), false) 
    Timers:CreateTimer(duration, function()
	ParticleManager:DestroyParticle( particle, false )
	ParticleManager:DestroyParticle( particle2, false )
	ParticleManager:DestroyParticle( particle3, false )
    return nil  end)

local particle4 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf", 
                                                 PATTACH_WORLDORIGIN, caster) 
ParticleManager:SetParticleControl( particle4, 0,curpos)

local dis=100
local dis_min=500
local pos2=curpos.z+1000
local ability = self
Timers:CreateTimer(4, function()
    pos2=pos2-dis
    ParticleManager:SetParticleControl( particle4, 3,Vector(curpos.x,curpos.y,pos2))
    if pos2<=dis_min then
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle( particle2, false )
            ParticleManager:DestroyParticle( particle4, false )
            ParticleManager:ReleaseParticleIndex( particle2 )
            ParticleManager:ReleaseParticleIndex( particle4 )
        end)
        if not ability or ability:IsNull() then
            return
        end
        local particle2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, caster) 
        ParticleManager:SetParticleControl( particle2, 0,curpos)
        ParticleManager:SetParticleControl( particle2, 3,curpos)

        EmitSoundOnLocationWithCaster(curpos, "Hero_Ancient_Apparition.IceBlast.Target", caster)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), curpos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
        for _,target in pairs(enemies) do
                if not target:IsMagicImmune() then         
                    local damageTable = {
                        attacker = caster,
                        victim = target,
                        damage = damage,
                        damage_type = self:GetAbilityDamageType(),
                        ability = self,
                        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
                    }
                    local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
                    local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
                    target:AddNewModifier(caster, self, "modifier_normal_stun", {duration =stun*StatusResistance})
                    ApplyDamage(damageTable) 
                end
        end

         
        return nil
    else
        return FrameTime()
    end
end
)


end

modifier_Middle_Ice_Vortex_1 = class({})
function modifier_Middle_Ice_Vortex_1:IsDebuff()				return true  end
function modifier_Middle_Ice_Vortex_1:IsPurgable() 			return false end
function modifier_Middle_Ice_Vortex_1:IsPurgeException()   	return false end
function modifier_Middle_Ice_Vortex_1:IsHidden()				return true  end
function modifier_Middle_Ice_Vortex_1:IsAura()                return true  end
function modifier_Middle_Ice_Vortex_1:GetAuraDuration()       return 0.1   end
function modifier_Middle_Ice_Vortex_1:GetModifierAura()       return "modifier_Middle_Ice_Vortex_debuff" end
function modifier_Middle_Ice_Vortex_1:GetAuraRadius()         return self.radius end
function modifier_Middle_Ice_Vortex_1:GetAuraSearchFlags()    return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Middle_Ice_Vortex_1:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_ENEMY  end
function modifier_Middle_Ice_Vortex_1:GetAuraSearchType()     return  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Middle_Ice_Vortex_1:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_Middle_Ice_Vortex_1:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end



---------------------------------------------------------------------------------------------------------------
modifier_Middle_Ice_Vortex_debuff = class({})
function modifier_Middle_Ice_Vortex_debuff:IsDebuff()				return true  end
function modifier_Middle_Ice_Vortex_debuff:IsPurgable() 			return false end
function modifier_Middle_Ice_Vortex_debuff:IsPurgeException() 	return true end
function modifier_Middle_Ice_Vortex_debuff:IsHidden()				return false end
function modifier_Middle_Ice_Vortex_debuff:GetStatusEffectName()  return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_Middle_Ice_Vortex_debuff:StatusEffectPriority() return 20 end

function modifier_Middle_Ice_Vortex_debuff:OnCreated( table )
    local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self.speed_slow = 0
        return
	end
    self.speed_slow=self:GetAbility():GetSpecialValueFor("speed_slow")
   
end


function modifier_Middle_Ice_Vortex_debuff:OnDestroy(  )
    self.speed_slow=nil
    self.damage_bonus_in=nil
end
function modifier_Middle_Ice_Vortex_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,} end
function modifier_Middle_Ice_Vortex_debuff:GetModifierMoveSpeedBonus_Constant() return (0- self.speed_slow) end
