LinkLuaModifier("modifier_word_bulky_debuff", "modifier/chaotic_era_artifact/modifier_word/modifier_word_bulky", LUA_MODIFIER_MOTION_NONE)

modifier_word_bulky = advanced_modifier({})

function modifier_word_bulky:IsHidden()return false end
function modifier_word_bulky:IsDebuff()return false end
function modifier_word_bulky:IsPurgable()return false end
function modifier_word_bulky:IsPurgeException() 	return false end
function modifier_word_bulky:RemoveOnDeath() return false end
function modifier_word_bulky:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_word_bulky:DestroyOnExpire() return false end
function modifier_word_bulky:GetTexture() return "chaotic_era_spell/word_bulky" end
function modifier_word_bulky:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local upgrade_value = 140
	local progress_bonus = 70
	local no_armor = 15
	local status = 40
  	-- local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	self:SetStackCount(1)
	local keys = {
		idKey = "word_bulky",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/word_bulky.png",
		title = "word_bulky",
		text = "HUD_word_bulky_Info",
		keys={
			upgrade_value = {
				text= upgrade_value,
				bLocalize = 0,
			},
			progress_bonus = {
				text= progress_bonus,
				bLocalize = 0,
			},
			no_armor = {
				text= no_armor,
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
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "word_bulky") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
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
		unit:AddNewModifier(parent, nil, "modifier_word_bulky_debuff", {})
	end)
	-- self:Destroy()
	
  end
end





modifier_word_bulky_debuff = advanced_modifier({})

function modifier_word_bulky_debuff:IsHidden()return false end
function modifier_word_bulky_debuff:IsDebuff()return true end
function modifier_word_bulky_debuff:IsPurgable()return false end
function modifier_word_bulky_debuff:IsPurgeException() 	return false end
function modifier_word_bulky_debuff:RemoveOnDeath() return false end
function modifier_word_bulky_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_word_bulky_debuff:DestroyOnExpire() return false end
function modifier_word_bulky_debuff:GetTexture() return "chaotic_era_spell/word_bulky" end

function modifier_word_bulky_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
end

function modifier_word_bulky_debuff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
end

function modifier_word_bulky_debuff:Advanced_GetModifierAttackArmor_Ignore()
	return 15
end

function modifier_word_bulky_debuff:Advanced_GetModifier_StatusResistance()
	return 40
end

function modifier_word_bulky_debuff:GetModifierModelScale()
	return 50
end
