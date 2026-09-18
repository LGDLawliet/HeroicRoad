
modifier_artifact_oil = advanced_modifier({})

function modifier_artifact_oil:IsHidden()return true end
function modifier_artifact_oil:IsDebuff()return false end
function modifier_artifact_oil:IsPurgable()return false end
function modifier_artifact_oil:IsPurgeException() 	return false end
function modifier_artifact_oil:RemoveOnDeath() return false end
function modifier_artifact_oil:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_artifact_oil:GetTexture() return self.texture end
function modifier_artifact_oil:DestroyOnExpire() return false end


function modifier_artifact_oil:GetEffectName() return "particles/rebuild/artifact/artifact_oil/effect.vpcf" end





function modifier_artifact_oil:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/artifact_oil/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", context )

end

function modifier_artifact_oil:OnCreated(keys)
  --self.bonus_move =  GetChaticEra_Artifact_Special(self,"bonus_move")
  if IsServer() then
    self.radius = GetChaticEra_Artifact_Special(self,"radius")
    self.cooldown = GetChaticEra_Artifact_Special(self,"cooldown")
    self.health_damage = GetChaticEra_Artifact_Special(self,"health_damage")*0.01
    --self.cooldown_require= GetChaticEra_Artifact_Special(self,"cooldown_require")
    self.distance= GetChaticEra_Artifact_Special(self,"distance")
    self.timer = GameRules:GetGameTime()

  end
end
function modifier_artifact_oil:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { nil,nil },

  }
end



function modifier_artifact_oil:OnAbilityFullyCast(keys)
  local parent = self:GetParent()
	if keys.unit ~= parent then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	-- if keys.ability:GetCooldown(keys.ability:GetLevel())<self.cooldown_require then
	-- 	return
	-- end
  if self:GetRemainingTime()>0 then
    return
  end
  if keys.ability:IsFireSpell() then
    if CalculateDistance(keys.unit,parent)<=self.distance then
      self:SetDuration(self.cooldown, false)
      local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
      local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_CUSTOMORIGIN,nil )
      ParticleManager:SetParticleControl( effect_cast, 0, parent:GetAbsOrigin() )
      ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,0,0) )
      parent:EmitSound("Hero_Techies.Suicide")
      ParticleManager:ReleaseParticleIndex( effect_cast )
      local damage = parent:GetMaxHealth()*self.health_damage
      local damageTable = {
          attacker = parent,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL,
          -- damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
          -- ability = self, --Optional.
          hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
      }
      for i,enemy in pairs(units) do
          damageTable.victim = enemy
          ApplyDamage(damageTable)
      end
      
      


    end
  end

end
