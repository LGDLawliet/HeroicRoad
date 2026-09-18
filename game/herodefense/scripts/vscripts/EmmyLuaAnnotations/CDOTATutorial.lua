---@class CDOTATutorial
CDOTATutorial = 
{
}
--Add a computer controlled bot.
--available:server
---@param heroName string
---@param arg2 string
---@param arg3 string
---@param arg4 bool
---@return bool
function CDOTATutorial:AddBot(heroName,arg2,arg3,arg4)end

--Add a quest to the quest log.
--available:server
---@param arg1 string
---@param arg2 int
---@param arg3 string
---@param arg4 string
---@return nil
function CDOTATutorial:AddQuest(arg1,arg2,arg3,arg4)end

--Add an item to the shop whitelist.
--available:server
---@param itemName string
---@return nil
function CDOTATutorial:AddShopWhitelistItem(itemName)end

--Complete a quest,.
--available:server
---@param arg1 string
---@return nil
function CDOTATutorial:CompleteQuest(arg1)end

--Add a task to move to a specific location.
--available:server
---@param arg1 Vector
---@return nil
function CDOTATutorial:CreateLocationTask(arg1)end

--Alert the player when a creep becomes agro to their hero.
--available:server
---@param arg1 bool
---@return nil
function CDOTATutorial:EnableCreepAggroViz(arg1)end

--Enable the tip to alert players how to find their hero.
--available:server
---@param arg1 bool
---@return nil
function CDOTATutorial:EnablePlayerOffscreenTip(arg1)end

--Alert the player when a tower becomes agro to their hero.
--available:server
---@param arg1 bool
---@return nil
function CDOTATutorial:EnableTowerAggroViz(arg1)end

--End the tutorial.
--available:server
---@return nil
function CDOTATutorial:FinishTutorial()end

--Force the start of the game.
--available:server
---@return nil
function CDOTATutorial:ForceGameStart()end

--Is our time frozen?
--available:server
---@return bool
function CDOTATutorial:GetTimeFrozen()end

--Is this item currently in the white list.
--available:server
---@param itemName string
---@return bool
function CDOTATutorial:IsItemInWhiteList(itemName)end

--Remove an item from the shop whitelist.
--available:server
---@param itemName string
---@return nil
function CDOTATutorial:RemoveShopWhitelistItem(itemName)end

--Select a hero for the local player.
--available:server
---@param heroName string
---@return nil
function CDOTATutorial:SelectHero(heroName)end

--Select the team for the local player.
--available:server
---@param arg1 string
---@return nil
function CDOTATutorial:SelectPlayerTeam(arg1)end

--Set the current item guide.
--available:server
---@param arg1 string
---@return nil
function CDOTATutorial:SetItemGuide(arg1)end

--Set gold amount for the tutorial player.
--available:server
---@param goldAmount int
---@param setNotModify bool
---@return nil
function CDOTATutorial:SetOrModifyPlayerGold(goldAmount,setNotModify)end

--Set players quick buy item.
--available:server
---@param itemName string
---@return nil
function CDOTATutorial:SetQuickBuy(itemName)end

--Set the shop open or closed.
--available:server
---@param open bool
---@return nil
function CDOTATutorial:SetShopOpen(open)end

--Set if we should freeze time or not.
--available:server
---@param timeFrozen bool
---@return nil
function CDOTATutorial:SetTimeFrozen(timeFrozen)end

--Set a tutorial convar.
--available:server
---@param arg1 string
---@param arg2 string
---@return nil
function CDOTATutorial:SetTutorialConvar(arg1,arg2)end

--Set the UI to use a reduced version to focus attention to specific elements.
--available:server
---@param arg1 int
---@return nil
function CDOTATutorial:SetTutorialUI(arg1)end

--Set if we should whitelist shop items.
--available:server
---@param whiteListEnabled bool
---@return nil
function CDOTATutorial:SetWhiteListEnabled(whiteListEnabled)end

--Initialize Tutorial Mode.
--available:server
---@return nil
function CDOTATutorial:StartTutorialMode()end

--Upgrade a specific ability for the local hero.
--available:server
---@param abilityName string
---@return nil
function CDOTATutorial:UpgradePlayerAbility(abilityName)end

