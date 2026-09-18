LinkLuaModifier("modifier_artifact_ashe_buff", "modifier/chaotic_era_artifact/modifier_artifact_ashe", LUA_MODIFIER_MOTION_NONE)

modifier_artifact_ashe = advanced_modifier({})

function modifier_artifact_ashe:IsHidden()return false end
function modifier_artifact_ashe:IsDebuff()return false end
function modifier_artifact_ashe:IsPurgable()return false end
function modifier_artifact_ashe:IsPurgeException() 	return false end
function modifier_artifact_ashe:RemoveOnDeath() return false end
function modifier_artifact_ashe:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_artifact_ashe:GetTexture() return "lina_flame_cloak" end
function modifier_artifact_ashe:DestroyOnExpire() return false end







function modifier_artifact_ashe:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", context )
	-- PrecacheResource( "particle", "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", context )

end

function modifier_artifact_ashe:OnCreated(keys)
  -- self.bonus_move =  GetChaticEra_Artifact_Special(self,"bonus_move")
  self.bonus_damage = GetChaticEra_Artifact_Special(self,"bonus_damage")
  if IsServer() then
    self.radius = GetChaticEra_Artifact_Special(self,"radius")
    self.cooldown = GetChaticEra_Artifact_Special(self,"cooldown")
    self.duration = GetChaticEra_Artifact_Special(self,"duration")
    self.damage_index = GetChaticEra_Artifact_Special(self,"damage_index")
    self.cooldown_require= GetChaticEra_Artifact_Special(self,"cooldown_require")
  
    self.timer = GameRules:GetGameTime()

  end
end
function modifier_artifact_ashe:OnRefresh(keys)
  if IsServer() then
    self:IncrementStackCount()
  end
end
function modifier_artifact_ashe:ADDeclareFunctions()
  return 
  {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
    advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

  }
end



function modifier_artifact_ashe:OnAbilityFullyCast(keys)
  local parent = self:GetParent()
	if keys.unit ~= parent then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<self.cooldown_require then
		return
	end

  if self:GetRemainingTime()>0 then
    return
  end
  if keys.ability:IsFireSpell() and keys.ability:IsChaoticEraSpell() then
    local level = keys.ability:GetAbilityClassLevel()
    if level>=1 then
      local pos = self:GetParent():GetAbsOrigin()
      if keys.target then
        pos = keys.target:GetAbsOrigin()
      end
      if keys.new_pos and not keys.new_pos==Vector(0,0,0) then
        pos = keys.new_pos
      end
      parent:AddNewModifier(parent, nil, "modifier_artifact_ashe_buff", {duration=self.duration})

      
      self:SetDuration(self.cooldown, false)
      local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
      local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_CUSTOMORIGIN,nil )
      ParticleManager:SetParticleControl( effect_cast, 5, pos )
      -- ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,0,0) )
      parent:EmitSound("Hero_Batrider.Flamebreak.Impact")
      ParticleManager:ReleaseParticleIndex( effect_cast )
      local damage = parent:HDGetPrimaryStatValue()*self.damage_index * level
      local damageTable = {
          attacker = parent,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL,
          -- damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
          -- ability = self, --Optional.
          hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
      }
      for i,enemy in pairs(units) do
          damageTable.victim = enemy
          ApplyDamage(damageTable)
      end
      
    end
  end

end

function modifier_artifact_ashe:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
    if DamageFilter(keys.record,HD_DAMAGE_FLAG_FIRE_DAMAGE) then
      return self.bonus_damage*self:GetStackCount()
    end
	end
	return 0
end

function modifier_artifact_ashe:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_artifact_ashe:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.bonus_damage*self:GetStackCount()
	end
end




modifier_artifact_ashe_buff = advanced_modifier({})

function modifier_artifact_ashe_buff:IsHidden()return true end
function modifier_artifact_ashe_buff:IsDebuff()return false end
function modifier_artifact_ashe_buff:IsPurgable()return false end
function modifier_artifact_ashe_buff:IsPurgeException() 	return false end
function modifier_artifact_ashe_buff:RemoveOnDeath() return false end
function modifier_artifact_ashe_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_artifact_ashe_buff:GetTexture() return self.texture end
function modifier_artifact_ashe_buff:DestroyOnExpire() return false end
function modifier_artifact_ashe_buff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end

function modifier_artifact_ashe_buff:OnDeath(keys)
  if not IsServer() then
      return
  end
	local attacker = keys.attacker
	local target = keys.unit
  if self.disable then
    return
  end
  if attacker == self:GetParent() and IsEnemy(attacker,target) then
    self.disable = true
    attacker:AddNewModifier(attacker, nil, "modifier_artifact_ashe", {})
    self:Destroy()
  end
end

