Primary_Ice_Vortex = class({})

LinkLuaModifier("modifier_Primary_Ice_Vortex_1", "skills/Primary_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Ice_Vortex_debuff", "skills/Primary_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)


function Primary_Ice_Vortex:IsHiddenWhenStolen()       return false end
function Primary_Ice_Vortex:IsStealable() 	            return true end
function Primary_Ice_Vortex:IsNetherWardStealable()    return true end
function Primary_Ice_Vortex:IsRefreshable() 			return true end
function Primary_Ice_Vortex:ProcsMagicStick() 			return true end
function Primary_Ice_Vortex:GetAOERadius() 			return self:GetSpecialValueFor("radius")end

function Primary_Ice_Vortex:OnSpellStart()
	local curpos = self:GetCursorPosition()
    local caster = self:GetCaster() 
    
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("life_duration")

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

    CreateModifierThinker(caster, self, "modifier_Primary_Ice_Vortex_1", {duration =duration}, curpos, caster:GetTeamNumber(), false) 
    Timers:CreateTimer(duration, function()
	ParticleManager:DestroyParticle( particle, false )
	ParticleManager:DestroyParticle( particle2, false )
	ParticleManager:DestroyParticle( particle3, false )
    return nil  end)



end


modifier_Primary_Ice_Vortex_1 = class({})
function modifier_Primary_Ice_Vortex_1:IsDebuff()				return true  end
function modifier_Primary_Ice_Vortex_1:IsPurgable() 			return false end
function modifier_Primary_Ice_Vortex_1:IsPurgeException()   	return false end
function modifier_Primary_Ice_Vortex_1:IsHidden()				return true  end
function modifier_Primary_Ice_Vortex_1:IsAura()                return true  end
function modifier_Primary_Ice_Vortex_1:GetAuraDuration()       return 0.1   end
function modifier_Primary_Ice_Vortex_1:GetModifierAura()       return "modifier_Primary_Ice_Vortex_debuff" end
function modifier_Primary_Ice_Vortex_1:GetAuraRadius()         return self.radius end
function modifier_Primary_Ice_Vortex_1:GetAuraSearchFlags()    return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Primary_Ice_Vortex_1:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_ENEMY  end
function modifier_Primary_Ice_Vortex_1:GetAuraSearchType()     return  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Ice_Vortex_1:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_Primary_Ice_Vortex_1:OnDestroy(  )

    UTIL_Remove(self:GetParent())
end




---------------------------------------------------------------------------------------------------------------
modifier_Primary_Ice_Vortex_debuff = class({})
function modifier_Primary_Ice_Vortex_debuff:IsDebuff()				return true  end
function modifier_Primary_Ice_Vortex_debuff:IsPurgable() 			return false end
function modifier_Primary_Ice_Vortex_debuff:IsPurgeException() 	return true end
function modifier_Primary_Ice_Vortex_debuff:IsHidden()				return false end
function modifier_Primary_Ice_Vortex_debuff:GetStatusEffectName()  return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_Primary_Ice_Vortex_debuff:StatusEffectPriority() return 20 end

function modifier_Primary_Ice_Vortex_debuff:OnCreated( table )
    local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self.speed_slow = 0
        return
	end
    self.speed_slow=self:GetAbility():GetSpecialValueFor("speed_slow")

end
function modifier_Primary_Ice_Vortex_debuff:OnDestroy(  )
    self.speed_slow=nil
    self.damage_bonus_in=nil

end
function modifier_Primary_Ice_Vortex_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,} end
function modifier_Primary_Ice_Vortex_debuff:GetModifierMoveSpeedBonus_Constant() return (0- self.speed_slow) end
