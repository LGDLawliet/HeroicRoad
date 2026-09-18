
modifier_artifact_barracks = advanced_modifier({})

function modifier_artifact_barracks:IsHidden()return false end
function modifier_artifact_barracks:IsDebuff()return false end
function modifier_artifact_barracks:IsPurgable()return false end
function modifier_artifact_barracks:IsPurgeException() 	return false end
function modifier_artifact_barracks:RemoveOnDeath() return false end
function modifier_artifact_barracks:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_artifact_barracks:DestroyOnExpire() return false end
function modifier_artifact_barracks:GetTexture() return "abyssal_underlord_dark_rift" end
function modifier_artifact_barracks:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local interval_reduction = GetChaticEra_Artifact_Special(self,"interval_reduction")
  	-- local grow = GetChaticEra_Artifact_Special(self,"grow")
	local gold_down = GetChaticEra_Artifact_Special(self,"gold_down")
	self:SetStackCount(GetChaticEra_Artifact_Special(self,"count"))
	local keys = {
		idKey = "artifact_barracks",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/artifact_barracks.png",
		title = "artifact_barracks",
		text = "HUD_artifact_barracks_Info",
		keys={
			interval_reduction = {
				text= interval_reduction,
				bLocalize = 0,
			},
			-- grow = {
			-- 	text= grow,
			-- 	bLocalize = 0,
			-- },
			gold_down = {
				text= gold_down,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "artifact_barracks") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		-- 如果返回true那就必定成功了
		if data.interval<1 then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
			return false
		end
		data.interval = data.interval * (1-interval_reduction*0.01)
		data.attribute.bounty = data.attribute.bounty * (1-gold_down*0.01)
		data.attribute.bonusBounty = data.attribute.bonusBounty * (1-gold_down*0.01)
		-- data.attribute.bonusHealth = data.attribute.bonusHealth * (1+grow*0.01)
		-- data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage * (1+grow*0.01)

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
	-- 	unit:AddNewModifier(parent, nil, "modifier_artifact_barracks_debuff", {})
	-- end)
	)
	-- self:Destroy()
	
  end
end

