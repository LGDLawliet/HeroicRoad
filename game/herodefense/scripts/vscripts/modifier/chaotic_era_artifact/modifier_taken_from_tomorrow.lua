
modifier_taken_from_tomorrow = advanced_modifier({})

function modifier_taken_from_tomorrow:IsHidden()return true end
function modifier_taken_from_tomorrow:IsDebuff()return false end
function modifier_taken_from_tomorrow:IsPurgable()return false end
function modifier_taken_from_tomorrow:IsPurgeException() 	return false end
function modifier_taken_from_tomorrow:RemoveOnDeath() return false end
function modifier_taken_from_tomorrow:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_taken_from_tomorrow:GetTexture() return self.texture end

function modifier_taken_from_tomorrow:OnCreated(keys)
  if IsServer() then
    self.bonus = GetChaticEra_Artifact_Special(self,"value1")-1
    if not self.already then
      for i = 0, self.bonus, 1 do
        self:GetParent():HeroLevelUp(true)
      end
      self.already = true
    end
  end

end

