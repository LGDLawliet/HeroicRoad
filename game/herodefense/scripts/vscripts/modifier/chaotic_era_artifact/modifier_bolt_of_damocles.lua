
modifier_bolt_of_damocles = advanced_modifier({})

function modifier_bolt_of_damocles:IsHidden()return false end
function modifier_bolt_of_damocles:IsDebuff()return false end
function modifier_bolt_of_damocles:IsPurgable()return false end
function modifier_bolt_of_damocles:IsPurgeException() 	return false end
function modifier_bolt_of_damocles:RemoveOnDeath() return false end
function modifier_bolt_of_damocles:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_bolt_of_damocles:GetTexture() return "zuus_thundergods_wrath" end




function modifier_bolt_of_damocles:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context )

end







function modifier_bolt_of_damocles:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    if not _G.bolt_of_damocles_timer then
      _G.bolt_of_damocles_timer = 0
    end
    self.radius = GetChaticEra_Artifact_Special(self,"radius")
    self.interval = GetChaticEra_Artifact_Special(self,"interval")
    self.stun_duration = GetChaticEra_Artifact_Special(self,"stun_duration")
    self.health_damage = GetChaticEra_Artifact_Special(self,"health_damage")*0.01
    self.cooldown_time = GetChaticEra_Artifact_Special(self,"cooldown_time")*60
    self:StartIntervalThink(1)
  end
end
function modifier_bolt_of_damocles:OnIntervalThink()
  -- self:SetStackCount(math.max(0,self:GetStackCount()-self.lose))
  if chaotic_era_spawner:IsWarning() then
    if self:GetRemainingTime()>0 then
      return
    end
    local fGameTime = GameRules:GetGameTime()
    if fGameTime>=_G.bolt_of_damocles_timer then
      _G.bolt_of_damocles_timer = fGameTime + self.interval
      self:SetDuration(self.cooldown_time, true)
      local parent = self:GetParent()
      local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
      local thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
      ParticleManager:SetParticleControlEnt( thundergod_spell_cast, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
      ParticleManager:SetParticleControlEnt( thundergod_spell_cast, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
      ParticleManager:SetParticleControlEnt( thundergod_spell_cast, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true )
      DestroyParticleByDelay(thundergod_spell_cast,2)

      parent:EmitSound("Hero_Zuus.GodsWrath")
      ParticleManager:ReleaseParticleIndex( thundergod_spell_cast )

      local damageTable = {
          attacker = parent,
          -- damage = damage,
          damage_type = DAMAGE_TYPE_PURE,
          hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
          damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
          -- ability = self, --Optional.
      }
      local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
      for i,unit in pairs(units) do
        if i<=15 then
          local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
          local pos = unit:GetAbsOrigin()
          ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
          ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
          ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
          ParticleManager:ReleaseParticleIndex(particle)
        end
        
        local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        unit:AddNewModifier(parent, nil, "modifier_stunned", {duration = self.stun_duration * StatusResistance})
        unit:EmitSound("Hero_Zuus.GodsWrath.Target")
        damageTable.damage = unit:GetMaxHealth()*self.health_damage 
        damageTable.victim = unit
        ApplyDamage(damageTable)

          
      end
    end
  end


end


