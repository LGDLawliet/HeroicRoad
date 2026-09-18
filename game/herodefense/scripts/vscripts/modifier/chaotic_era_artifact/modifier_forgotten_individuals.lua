
modifier_forgotten_individuals = advanced_modifier({})

function modifier_forgotten_individuals:IsHidden()return false end
function modifier_forgotten_individuals:IsDebuff()return false end
function modifier_forgotten_individuals:IsPurgable()return false end
function modifier_forgotten_individuals:IsPurgeException() 	return false end
function modifier_forgotten_individuals:RemoveOnDeath() return false end
function modifier_forgotten_individuals:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_forgotten_individuals:DestroyOnExpire() return false end
function modifier_forgotten_individuals:GetTexture() return "chaotic_era_spell/forgotten_individuals" end
function modifier_forgotten_individuals:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local duration = GetChaticEra_Artifact_Special(self,"duration")
  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(GetChaticEra_Artifact_Special(self,"count"))
	local keys = {
		idKey = "forgotten_individuals",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/forgotten_individuals.png",
		title = "forgotten_individuals",
		text = "HUD_forgotten_individuals_Info",
		keys={
			duration = {
				text= duration,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "forgotten_individuals") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		-- 如果返回true那就必定成功了
		data.disableTimer = GameRules:GetGameTime() + duration

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
	-- 	unit:AddNewModifier(parent, nil, "modifier_forgotten_individuals_debuff", {})
	-- end)
	)
	-- self:Destroy()
	
  end
end

