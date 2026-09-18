
modifier_revtel_investments = advanced_modifier({})

function modifier_revtel_investments:IsHidden()return false end
function modifier_revtel_investments:IsDebuff()return false end
function modifier_revtel_investments:IsPurgable()return false end
function modifier_revtel_investments:IsPurgeException() 	return false end
function modifier_revtel_investments:RemoveOnDeath() return false end
function modifier_revtel_investments:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_revtel_investments:DestroyOnExpire() return false end
function modifier_revtel_investments:GetTexture() return "alchemist_goblins_greed" end
function modifier_revtel_investments:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local bonus_bounty = GetChaticEra_Artifact_Special(self,"bonus_bounty")
  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(GetChaticEra_Artifact_Special(self,"count"))
	local keys = {
		idKey = "revtel_investments",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/revtel_investments.png",
		title = "revtel_investments",
		text = "HUD_revtel_investments_Info",
		keys={
			bonus_bounty = {
				text= bonus_bounty,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "revtel_investments") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		-- 如果返回true那就必定成功了
		if data.attribute.bounty<1 then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
			return false
		end
		data.attribute.bonusBounty = data.attribute.bonusBounty* (1+bonus_bounty*0.01)
		data.attribute.bounty = data.attribute.bounty * (1+bonus_bounty*0.01)

		return true
	end,
	-- 是否清除(即仅能修饰一次)
	function ()
		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:Destroy()
			return true
		end
		return false
	end,
	-- 实例化修饰
	nil
	-- function (unit,attribute)
	-- 	unit:AddNewModifier(parent, nil, "modifier_revtel_investments_debuff", {})
	-- end)
	)
	-- self:Destroy()
	
  end
end

