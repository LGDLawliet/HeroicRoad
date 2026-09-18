LinkLuaModifier("modifier_defending_the_weak_buff", "modifier/chaotic_era_artifact/modifier_defending_the_weak", LUA_MODIFIER_MOTION_NONE)

modifier_defending_the_weak = advanced_modifier({})

function modifier_defending_the_weak:IsHidden()return false end
function modifier_defending_the_weak:IsDebuff()return false end
function modifier_defending_the_weak:IsPurgable()return false end
function modifier_defending_the_weak:IsPurgeException() 	return false end
function modifier_defending_the_weak:RemoveOnDeath() return false end
function modifier_defending_the_weak:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_defending_the_weak:DestroyOnExpire() return false end
-- function modifier_defending_the_weak:GetTexture() return self.texture end
function modifier_defending_the_weak:GetTexture() return "magnataur_empower" end
function modifier_defending_the_weak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/defending_the_weak/main/effect.vpcf", context )
end



function modifier_defending_the_weak:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.interval = GetChaticEra_Artifact_Special(self,"interval")
    self.radius = GetChaticEra_Artifact_Special(self,"radius")
    self.duration = GetChaticEra_Artifact_Special(self,"duration")
    self:StartIntervalThink(0.2)
  end
end


function modifier_defending_the_weak:OnIntervalThink(keys)
  local parent = self:GetParent()
  if not parent:IsAlive() then
    return
  end
  if self:GetRemainingTime()>0 then
    return
  end
  local heroes = FindUnitsInRadius(
    parent:GetTeamNumber(),
    parent:GetAbsOrigin(),
    nil,
    self.radius,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false
  )
  local currentTarget

  for index, target in ipairs(heroes) do
    
    if target~=parent then
      if not currentTarget then
        currentTarget = target
      else
        local all_attribute = target:GetStrength() + target:GetAgility() + target:GetIntellect(false)
        if all_attribute<=(currentTarget:GetStrength() + currentTarget:GetAgility() + currentTarget:GetIntellect(false)) then
          currentTarget = target
        end
      end
     
    end
    
  end
  if currentTarget then
    self:SetDuration(self.interval, true)
    local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/artifact/defending_the_weak/main/effect.vpcf", PATTACH_CUSTOMORIGIN,currentTarget )
    currentTarget:EmitSound("Hero_Magnataur.Empower.Cast")
    ParticleManager:ReleaseParticleIndex( effect_cast )
    currentTarget:AddNewModifier(parent, nil, "modifier_defending_the_weak_buff", {duration=self.duration})
  end
end








modifier_defending_the_weak_buff = advanced_modifier({})

function modifier_defending_the_weak_buff:IsHidden()return false end
function modifier_defending_the_weak_buff:IsDebuff()return false end
function modifier_defending_the_weak_buff:IsPurgable()return false end
function modifier_defending_the_weak_buff:IsPurgeException() 	return false end
function modifier_defending_the_weak_buff:RemoveOnDeath() return false end
function modifier_defending_the_weak_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_defending_the_weak_buff:GetTexture() return "magnataur_empower" end
function modifier_defending_the_weak_buff:OnCreated(params)
  self.bonus_armor = GetChaticEra_Artifact_Special("defending_the_weak","bonus_armor")
  self.bonus_attribute = GetChaticEra_Artifact_Special("defending_the_weak","bonus_attribute")
	if IsServer() then
    
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_defending_the_weak_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
    table.insert(self.tData, {dieTime = dieTime })
    self:IncrementStackCount()
	end
end

function modifier_defending_the_weak_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


function modifier_defending_the_weak_buff:ADDeclareFunctions()
	local funcs = {
	}
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
  table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
  return funcs
end
function modifier_defending_the_weak_buff:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus_attribute  * self:GetStackCount()
end
function modifier_defending_the_weak_buff:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus_attribute  * self:GetStackCount()
end

function modifier_defending_the_weak_buff:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_attribute  * self:GetStackCount()
end
function modifier_defending_the_weak_buff:Advanced_GetModifierPhysicalArmorBonus()	
	return self.bonus_armor  * self:GetStackCount()
end

function modifier_defending_the_weak_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_defending_the_weak_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
  elseif self._tooltip==2 then
    return  self:Advanced_GetModifierBonusStats_Agility()
	end
end
