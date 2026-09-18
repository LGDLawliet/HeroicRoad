
--------------------------------------------------------------------------------
modifier_novice_player = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_novice_player:IsHidden()return false end
function modifier_novice_player:IsDebuff()return false end
function modifier_novice_player:IsStunDebuff()return false end
function modifier_novice_player:IsPurgable()return false end
function modifier_novice_player:GetTexture() return "marci_unleash" end
function modifier_novice_player:IsPurgeException() 	return false end
function modifier_novice_player:RemoveOnDeath() return false end
--oncreated
function modifier_novice_player:OnCreated( kv )
    if IsServer() then
       --给玩家赠送一件装备item_random_skill_for_novice
        -- local hero = self:GetParent()
        -- local item = CreateItem("item_random_skill_for_novice", hero, hero)
        -- hero:AddItem(item)
        -- print("AddTestItem","item_random_skill_for_novice",item)
    end
end
--onrefresh
function modifier_novice_player:OnRefresh( kv )
end

