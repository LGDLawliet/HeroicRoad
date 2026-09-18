
modifier_the_more_the_better = advanced_modifier({})

function modifier_the_more_the_better:IsHidden()return false end
function modifier_the_more_the_better:IsDebuff()return false end
function modifier_the_more_the_better:IsPurgable()return false end
function modifier_the_more_the_better:IsPurgeException() 	return false end
function modifier_the_more_the_better:RemoveOnDeath() return false end
function modifier_the_more_the_better:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_the_more_the_better:DestroyOnExpire() return false end
function modifier_the_more_the_better:GetTexture() return "chaotic_era_spell/the_more_the_better" end
function modifier_the_more_the_better:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local time_require = 30

  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(1)
	local keys = {
		idKey = "the_more_the_better",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/the_more_the_better.png",
		title = "the_more_the_better",
		text = "HUD_the_more_the_better_Info",
		keys={
			time_require = {
				text= time_require,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "the_more_the_better") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
		if kv then
			if kv.interval>=time_require then
				local nPlayerID = parent:GetPlayerOwnerID()
				SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
				return false
			end
		end
		
		data.count = 0 + data.count * 2
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
	-- 	unit:AddNewModifier(parent, nil, "modifier_the_more_the_better_debuff", {})
	-- end)
	)
	-- self:Destroy()
	
  end
end

