
modifier_divine_punishment = advanced_modifier({})

function modifier_divine_punishment:IsHidden()return false end
function modifier_divine_punishment:IsDebuff()return false end
function modifier_divine_punishment:IsPurgable()return false end
function modifier_divine_punishment:IsPurgeException() 	return false end
function modifier_divine_punishment:RemoveOnDeath() return false end
function modifier_divine_punishment:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_divine_punishment:DestroyOnExpire() return false end
function modifier_divine_punishment:GetTexture() return "chaotic_era_spell/divine_punishment" end
function modifier_divine_punishment:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local lost_hp = 20
  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(2)
	local keys = {
		idKey = "divine_punishment",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/divine_punishment.png",
		title = "divine_punishment",
		text = "HUD_divine_punishment_Info",
		keys={
			lost_hp = {
				text= lost_hp,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "divine_punishment") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end


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
	function (unit,attribute)
		unit:SetHealth(unit:GetHealth()*(1-lost_hp*0.01))
	end)
	-- self:Destroy()
	
  end
end



