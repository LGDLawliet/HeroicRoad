LinkLuaModifier("modifier_smash_armor_debuff", "modifier/chaotic_era_artifact/modifier_smash_armor", LUA_MODIFIER_MOTION_NONE)

modifier_smash_armor = advanced_modifier({})

function modifier_smash_armor:IsHidden()return true end
function modifier_smash_armor:IsDebuff()return false end
function modifier_smash_armor:IsPurgable()return false end
function modifier_smash_armor:IsPurgeException() 	return false end
function modifier_smash_armor:RemoveOnDeath() return false end
function modifier_smash_armor:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_smash_armor:DestroyOnExpire() return false end
function modifier_smash_armor:GetTexture() return "chaotic_era_spell/the_omexe_arena" end
function modifier_smash_armor:OnCreated(keys)
  if IsServer() then
	local parent = self:GetParent()
    local armor_reduction = GetChaticEra_Artifact_Special(self,"armor_reduction")
  	local magical_reduction = GetChaticEra_Artifact_Special(self,"magical_reduction")
	local keys = {
		idKey = "smash_armor",
		icon = "file://{images}/custom_game/chaotic_era/hud/artifact/smash_armor.png",
		title = "smash_armor",
		text = "HUD_smash_armor_Info",
		keys={
			armor_reduction = {
				text= armor_reduction,
				bLocalize = 0,
			},
			magical_reduction = {
				text= magical_reduction,
				bLocalize = 0,
			},

		}
	}
	local parent = self:GetParent()
	chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
	-- 检测是否成功的回调
	function (data)
		if chaotic_era_spawner:CheckHaveSameIdKey(data, "smash_armor") then
			local nPlayerID = parent:GetPlayerOwnerID()
			SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
			return false
		end
		return true
	end,
	-- 是否清除(即仅能修饰一次)
	function ()
		return true
	end,
	-- 实例化修饰
	function (unit,attribute)
		unit:AddNewModifier(parent, nil, "modifier_smash_armor_debuff", {})
	end)
	self:Destroy()
  end
end

function modifier_smash_armor:ModifyFunction(unit,attribute)
	unit:AddNewModifier(parent, nil, "modifier_smash_armor_debuff", {})
end






modifier_smash_armor_debuff = advanced_modifier({})

function modifier_smash_armor_debuff:IsHidden()return false end
function modifier_smash_armor_debuff:IsDebuff()return true end
function modifier_smash_armor_debuff:IsPurgable()return false end
function modifier_smash_armor_debuff:IsPurgeException() 	return false end
function modifier_smash_armor_debuff:RemoveOnDeath() return false end
function modifier_smash_armor_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_smash_armor_debuff:DestroyOnExpire() return false end
function modifier_smash_armor_debuff:GetTexture() return "chaotic_era_spell/smash_armor" end
function modifier_smash_armor_debuff:OnCreated(keys)
	self.armor_reduction = -GetChaticEra_Artifact_Special("smash_armor","armor_reduction")
	self.magical_reduction = -GetChaticEra_Artifact_Special("smash_armor","magical_reduction")

end

function modifier_smash_armor_debuff:ADDeclareFunctions()
  	local funcs = {}
  	table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	  table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
  	return funcs
end

function modifier_smash_armor_debuff:Advanced_GetModifierPhysicalArmorBonus(keys)	
	return self.armor_reduction
end

function modifier_smash_armor_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_TOOLTIP,

	}
end
function modifier_smash_armor_debuff:GetModifierMagicalResistanceBonus() return self.magical_reduction end



function modifier_smash_armor_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 2 then
		return  self:GetModifierMagicalResistanceBonus()
	end
end

