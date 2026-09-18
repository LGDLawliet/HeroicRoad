
modifier_cut_the_crap = advanced_modifier({})

function modifier_cut_the_crap:IsHidden()return false end
function modifier_cut_the_crap:IsDebuff()return false end
function modifier_cut_the_crap:IsPurgable()return false end
function modifier_cut_the_crap:IsPurgeException() 	return false end
function modifier_cut_the_crap:RemoveOnDeath() return false end
function modifier_cut_the_crap:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_cut_the_crap:DestroyOnExpire() return false end
-- function modifier_cut_the_crap:GetTexture() return "terrorblade_conjure_image_alt1" end
function modifier_cut_the_crap:OnCreated(keys)
--   self.attribute_reduction = -GetChaticEra_Artifact_Special(self,"attribute_reduction")
  if IsServer() then
    local level8_chance = GetChaticEra_Artifact_Special(self,"level8_chance")
	local level9_chance = GetChaticEra_Artifact_Special(self,"level9_chance")
	local playerID = self:GetParent():GetPlayerOwnerID()
	chaotic_era_shop:ModifySpellLevelMinChance(playerID,8,level8_chance)
	chaotic_era_shop:ModifySpellLevelMinChance(playerID,9,level9_chance)
	self:Destroy()
  end
end
