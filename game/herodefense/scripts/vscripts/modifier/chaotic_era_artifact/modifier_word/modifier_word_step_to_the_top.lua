LinkLuaModifier("modifier_word_step_to_the_top_debuff", "modifier/chaotic_era_artifact/modifier_word/modifier_word_step_to_the_top", LUA_MODIFIER_MOTION_NONE)
modifier_word_step_to_the_top = advanced_modifier({})

function modifier_word_step_to_the_top:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf", context )
end

function modifier_word_step_to_the_top:IsHidden()return false end
function modifier_word_step_to_the_top:IsDebuff()return false end
function modifier_word_step_to_the_top:IsPurgable()return false end
function modifier_word_step_to_the_top:IsPurgeException() 	return false end
function modifier_word_step_to_the_top:RemoveOnDeath() return false end
function modifier_word_step_to_the_top:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_word_step_to_the_top:DestroyOnExpire() return false end
function modifier_word_step_to_the_top:GetTexture() return "axe_berserkers_call_ti9" end
function modifier_word_step_to_the_top:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local upgrade_value = 120
	local progress_bonus = 60
	local outgoing = 15
	local status = 30
  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(1)
	local keys = {
		idKey = "step_to_the_top",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/step_to_the_top.png",
		title = "step_to_the_top",
		text = "HUD_step_to_the_top_Info",
		keys={
			upgrade_value = {
				text= upgrade_value,
				bLocalize = 0,
			},
			progress_bonus = {
				text= progress_bonus,
				bLocalize = 0,
			},
			outgoing = {
				text= outgoing,
				bLocalize = 0,
			},
			status = {
				text= status,
				bLocalize = 0,
			},
		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "step_to_the_top") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		-- 如果返回true那就必定成功了
		-- if data.attribute.bounty<=7 then
		-- 	local nPlayerID = parent:GetPlayerOwnerID()
		-- 	SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
		-- 	return false
		-- end
		data.attribute.baseHealth = data.attribute.baseHealth* (1+upgrade_value*0.01)
		data.attribute.bonusHealth = data.attribute.bonusHealth* (1+upgrade_value*0.01)
		data.attribute.baseAttackDamage = data.attribute.baseAttackDamage* (1+upgrade_value*0.01)
		data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage* (1+upgrade_value*0.01)

		data.runeProgress.level1 =  data.runeProgress.level1 * (1+progress_bonus*0.01)
		data.runeProgress.level2 =  data.runeProgress.level2 * (1+progress_bonus*0.01)
		data.runeProgress.level3 =  data.runeProgress.level3 * (1+progress_bonus*0.01)
		data.runeProgress.level4 =  data.runeProgress.level4 * (1+progress_bonus*0.01)
		data.runeProgress.level5 =  data.runeProgress.level5 * (1+progress_bonus*0.01)

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
		unit:AddNewModifier(parent, nil, "modifier_word_step_to_the_top_debuff", {})
	end)
	
	-- self:Destroy()
  	end
end

modifier_word_step_to_the_top_debuff = advanced_modifier({})

function modifier_word_step_to_the_top_debuff:IsHidden()return true end
function modifier_word_step_to_the_top_debuff:IsDebuff()return true end
function modifier_word_step_to_the_top_debuff:IsPurgable()return false end
function modifier_word_step_to_the_top_debuff:IsPurgeException() 	return false end
function modifier_word_step_to_the_top_debuff:RemoveOnDeath() return true end
function modifier_word_step_to_the_top_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_word_step_to_the_top_debuff:DestroyOnExpire() return false end
function modifier_word_step_to_the_top_debuff:GetEffectName() 
    return "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf" 
end
function modifier_word_step_to_the_top_debuff:GetEffectAttachType() 
    return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_word_step_to_the_top_debuff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
end

function modifier_word_step_to_the_top_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return 15
end

function modifier_word_step_to_the_top_debuff:Advanced_GetModifier_StatusResistance()
	return 30
end