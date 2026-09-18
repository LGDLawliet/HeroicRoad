
modifier_iron_tree_branches_guard = advanced_modifier({})

function modifier_iron_tree_branches_guard:IsHidden()return true end
function modifier_iron_tree_branches_guard:IsDebuff()return false end
function modifier_iron_tree_branches_guard:IsPurgable()return false end
function modifier_iron_tree_branches_guard:IsPurgeException() 	return false end
function modifier_iron_tree_branches_guard:RemoveOnDeath() return false end
function modifier_iron_tree_branches_guard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end




function modifier_iron_tree_branches_guard:OnCreated(keys)
  -- self.value1 = GetChaticEra_Artifact_Special(self,"value1")
  if IsServer() then
    self.bonus_attribute = GetChaticEra_Artifact_Special(self,"bonus_attribute")
    self.cost = GetChaticEra_Artifact_Special(self,"cost")
  end
end




function modifier_iron_tree_branches_guard:ADDeclareFunctions()
  return 
  {
    MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem = {self:GetParent(),nil},
  }
end


function modifier_iron_tree_branches_guard:GetChaoticEraAdditionalShopItem(keys)
  -- print("1111111")
  local list = {}
  local data = {
    item_name = "item_hd_artifact_ironwood_tree",
    cost = self.cost,
    type = "special",
    level  = 1,
  }
  table.insert(list,data)
  -- print("gdsagasdgadsgsa")
  return list
end
