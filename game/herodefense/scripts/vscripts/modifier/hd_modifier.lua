

---@class advanced_modifier
advanced_modifier = {}

local mt = {}
-- 注意-生命周期  DeclareFunctions-OnCreated-ADDeclareFunctions-OnStart
-- 如果你用了ADDeclareFunctions里的属性，确保不要在OnCreated时就触发某些效果  例如无影拳攻击，需要将其放到OnStart
mt.__call = function(class_tbl, ...)
	local c = class(...)

	c.constructor = function(self)
		local _OnCreated = self.OnCreated
		if type(_OnCreated) == "function" then
			self.OnCreated = function(...)
				local result = _OnCreated(...)
				if type(advanced_modifier.OnCreated) == "function" then
					advanced_modifier.OnCreated(...)
                    
				end
				return result
			end
		else
			self.OnCreated = advanced_modifier.OnCreated
		end

		local _OnRefresh = self.OnRefresh
		if type(_OnRefresh) == "function" then
			self.OnRefresh = function(...)
				local result = _OnRefresh(...)
				if type(advanced_modifier.OnRefresh) == "function" then
					advanced_modifier.OnRefresh(...)
				end
				return result
			end
		else
			self.OnRefresh = advanced_modifier.OnRefresh
		end

		local _OnDestroy = self.OnDestroy
		if type(_OnDestroy) == "function" then
			self.OnDestroy = function(...)
				local result = _OnDestroy(...)
				if type(advanced_modifier.OnDestroy) == "function" then
					advanced_modifier.OnDestroy(...)
                   
				end
				return result
			end
		else
			self.OnDestroy = advanced_modifier.OnDestroy
		end
	end

	return c
end
setmetatable(advanced_modifier, mt)

-- 用于复写
function advanced_modifier:ADDeclareFunctions(bUnregister)
	return {}
end
function advanced_modifier:OnStart(params)
    
end
function advanced_modifier:OnCreated(params)
	if not self._bDestroy and not self._tDeclareFunction and type(self.ADDeclareFunctions) == "function" then

		self._tDeclareFunction = self:ADDeclareFunctions()

		local hParent = self:GetParent()
		self.parent = hParent
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() then
			hParent:CalculateGenericBonuses()
			fManaPercent = hParent:GetMana()/hParent:GetMaxMana()
		end

		if type(self._tDeclareFunction) ~= "table" then
			error("ADDeclareFunctions RETURN ERROR")
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				RegisterModifierProperty(hParent, self, iProperty)
				if IsServer() then
					if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
						bCalculateHealth = true
					end
					if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
						bCalculateMana = true
					end
				end
			elseif type(k) == "string" then
				local iProperty = advanced_modifier_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, v)
					if IsServer() then
						if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
							bCalculateHealth = true
						end
						if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
							bCalculateMana = true
						end
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						--print("event add")
						-- print("self=",self:GetName())
						-- print("self2=",self:GetParent():GetUnitName())
						AddModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end

		if type(self.OnStart) == "function" then
			self:OnStart(params)
		end
        
	end
end
function advanced_modifier:OnRefresh(params)
	if not self._bDestroy and type(self.ADDeclareFunctions) == "function" then
		self._tDeclareFunction = self:ADDeclareFunctions()

		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() then
			fManaPercent = hParent:GetMana()/hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				if IsServer() then
					if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
						bCalculateHealth = true
					end
					if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
						bCalculateMana = true
					end
				end
			elseif type(k) == "string" then
				local iProperty = advanced_modifier_PROPERTY_INDEXES[k]
				if iProperty ~= nil and v ~= nil then
					if IsServer() then
						if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
							bCalculateHealth = true
						end
						if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
							bCalculateMana = true
						end
					end
					SetModifierProperty(hParent, self, iProperty, v)
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
	end
end
function advanced_modifier:OnDestroy(params)
	self._bDestroy = true
	if self._tDeclareFunction then
		local hParent
		if self.parent then
			hParent = self.parent
		else
			hParent =  self:GetParent()
		end
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() and IsValid(hParent) and hParent:IsAlive() then
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				UnregisterModifierProperty(hParent, self, iProperty)
				if IsServer() and IsValid(hParent) and hParent:IsAlive() then
					if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
						bCalculateHealth = true
					end
					if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
						bCalculateMana = true
					end
				end
			elseif type(k) == "string" then
				local iProperty = advanced_modifier_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, nil)
					if IsServer()and IsValid(hParent)  and hParent:IsAlive() then
						if TableFindKey(UPDATE_HEALTH_PROPERTY, iProperty) ~= nil then
							bCalculateHealth = true
						end
						if TableFindKey(UPDATE_MANA_PROPERTY, iProperty) ~= nil then
							bCalculateMana = true
						end
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						RemoveModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer()and IsValid(hParent) and hParent:IsAlive() then
			if bCalculateHealth then
				hParent:CalculateHealth()
			end
			if bCalculateMana then
				hParent:CalculateGenericBonuses()
				hParent:SetMana(fManaPercent * hParent:GetMaxMana())
			end
		end

		self._tDeclareFunction = nil
	end
end


local ZERO_VALUE = 0.0000000001

-- 减法相乘（百分比）
function SubtractionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return (1 - (1 - a * 0.01) * (1 - b * 0.01)) * 100
end

-- 加法相乘（百分比）
function AdditionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return ((1 + a * 0.01) * (1 + b * 0.01) - 1) * 100
end

-- 最大值
function Maximum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.max(a, b)
end

-- 最小值
function Minimum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.min(a, b)
end

-- 优先前值
function First(a, b)
	if a == nil then
		return b
	else
		return a
	end
end

-- 最小绝对值
local ZERO_VALUE_2 = 0.0000000002
function MinAbs(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE_2
	end
	if a == ZERO_VALUE_2 then
		return b
	end
	return math.min(math.abs(a), math.abs(b))
end


--[[查表:
	behavior:
		死亡后仍然也可以释放：DOTA_ABILITY_BEHAVIOR_UNRESTRICTED 
		眩晕也可以释放：DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
]]

--[[独立时长叠加modifier写法
modifier_Advanced_bash_of_the_deep_debuffArmor = modifier_Advanced_bash_of_the_deep_debuffArmor or advanced_modifier({})
function modifier_Advanced_bash_of_the_deep_debuffArmor:IsHidden()	return false end
function modifier_Advanced_bash_of_the_deep_debuffArmor:IsDebuff()	return true end
function modifier_Advanced_bash_of_the_deep_debuffArmor:IsPurgable()	return false end


function modifier_Advanced_bash_of_the_deep_debuffArmor:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_bash_of_the_deep_debuffArmor:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		

		if self:GetStackCount()>= 10 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_bash_of_the_deep_debuffArmor:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


function modifier_Advanced_bash_of_the_deep_debuffArmor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_bash_of_the_deep_debuffArmor:Advanced_GetModifierPhysicalArmorBonus()
    return  - self:GetStackCount()*3
end
]]

--local Gain = self.parent:GetModifierDurationGainIndex(1)
--local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
--local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
advanced_modifier_PROPERTIES = {
    -- 冷却时间
	advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION = { "Advanced_GetModifierCooldownReduction", SubtractionMultiplicationPercentage },

	-- 伤害减免
	advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = { "Advanced_GetModifierIncomingDamage_Percentage", AdditionMultiplicationPercentage },

	-- 天赋精通收益
	advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN = "Advanced_GetModifier_TalentEffectGain",  --精通
	advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN_MUL = {"Advanced_GetModifier_TalentEffectGain_Mul",AdditionMultiplicationPercentage},  --总增精通
	


	-- 冷却时间
	-- advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION = "Advanced_GetModifierCooldownReduction",

	-- 伤害
	advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE = "Advanced_GetModifierTotalDamageOutgoing_Percentage", --伤害增加[+]
	advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL =  { "Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul", AdditionMultiplicationPercentage }, -- 伤害总增[×]




	-- 攻击力相关
	advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE = "Advanced_GetModifierBaseAttack_BonusDamage", --基础攻击力加成

	advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = "Advanced_GetModifierPreAttack_BonusDamage",           --攻击力
	advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE = "Advanced_GetModifierBaseDamageOutgoing_Percentage", --攻击力百分比  （基于基础攻击力）


	advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE = "Advanced_GetModifierDamageOutgoing_Percentage", --攻击力百分比 


	advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL = "Advanced_GetModifierProcAttack_BonusDamage_Physical",  --额外物理伤害，不计入attacklanded的damage之内

	advanced_MODIFIER_PROPERTY_ARMOR_IGNORE = "Advanced_GetModifierAttackArmor_Ignore",  --攻击忽略护甲
	-- DeclareFunctions
	-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT = "GetModifierPreAttack_BonusDamagePostCrit" --可触发暴击，临时攻击力

	-- 攻击暴击
	advanced_MODIFIER_PROPERTY_CRITICALSTRIKE = { "Advanced_GetModifierCriticalStrike", Maximum },
	advanced_MODIFIER_PROPERTY_TARGET_CRITICALSTRIKE = { "Advanced_GetModifierTargetCriticalStrike", Maximum },
	advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE = "Advanced_GetModifierCriticalStrikeDamage", -- 额外暴击伤害
	advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET = "Advanced_GetModifierCriticalStrikeDamageTarget", -- 目标额外暴击伤害
	advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp = "Advanced_GetModifier_PhysicalCriticalAmp", --物理暴击增强
	advanced_MODIFIER_PROPERTY_INCOMING_CRITICALSTRIKE_PERCENT = "Advanced_GetModifierIncomingCriticalStrikePercent", -- 受到的暴击伤害总体乘一个百分比
	

		
	-- 攻速加成
	advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE  = "Advanced_GetModifierAttackSpeedPercentage",  --百分比 线性

	-- 移速相关


	-- 生命值
	advanced_MODIFIER_PROPERTY_HEALTH_BONUS = "AdvancedGetModifierHealthBonus", --生命值加成
	advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE  = "AdvancedGetModifierExtraHealthPercentage", --百分比生命值 线性
	advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH  = "AdvancedGetModifierTemporaryHealth", --百分比生命值 线性

	-- 魔法值
	advanced_MODIFIER_PROPERTY_MANA_BONUS = "AdvancedGetModifierManaBonus", --魔法值加成



	-- 生命恢复
	advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = "AdvancedGetModifierConstantHealthRegen", --生命恢复 常数
	advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = "AdvancedGetModifierConstantHealthRegenPercentage",  --百分比生命恢复


	advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE = "AdvancedGetModifierConstantHealthRegenAmpPercentage", --生命恢复增强 百分比
	advanced_MODIFIER_PROPERTY_HEALTH_REGEN_Zero_Override = "AdvancedGetModifierConstantHealthRegen_Zero_Override", --生命恢复归零
	
	

	-- 魔法恢复
	advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = "AdvancedGetModifierConstantManaRegen", --魔法恢复 常数
	advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE = "AdvancedGetModifierConstantManaRegenAmpPercentage", --魔法恢复增强 百分比
	
	
	advanced_MODIFIER_PROPERTY_MANA_REGEN_Zero_Override = "AdvancedGetModifierConstantManaRegen_Zero_Override", --魔法恢复归零
	
	
	-- 技能伤害
	advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS = "Advanced_GetModifierSpellAmplifyBonus",
	advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_UNIQUE = { "Advanced_GetModifierSpellAmplifyBonusUnique", Maximum },
	advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_PERCENTAGE_MUL =  { "Advanced_GetModifierSpellAmplifyBonusPercentageMUL", AdditionMultiplicationPercentage }, -- 最终技能伤害


	

	advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING = "Advanced_GetModifierCastRangeBonusStacking", -- 施法距离加成


	advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE = { "Advanced_GetModifierAttackRangeOverride", Maximum }, --攻击距离覆写
	advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS  = "Advanced_GetModifierAttackRangeBonus", --攻击距离加成
	advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE= "Advanced_GetModifierAttackRangeBonusPercentage", --攻击距离加成百分比


	advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE = "Advanced_GetModifierHealAMP_Percentage", -- 治疗增强
	advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE = "Advanced_GetModifierHealReceiveAMP_Percentage", -- 受到治疗增强



	advanced_MODIFIER_PROPERTY_DurationGain = "Advanced_GetModifier_DurationGain",   --正面状态增强
	advanced_MODIFIER_PROPERTY_NegativeDurationGain = "Advanced_GetModifier_NegativeDurationGain",   --负面状态增强
	advanced_MODIFIER_PROPERTY_StatusResistance = "Advanced_GetModifier_StatusResistance",   --状态抗性


	advanced_MODIFIER_PROPERTY_Summon_Intensity = "Advanced_GetModifier_Summon_Intensity", --召唤增强
	advanced_MODIFIER_PROPERTY_Summon_Intensity_Final_Percentage = "Advanced_GetModifier_Summon_Intensity_Final_Percentage",  --召唤增强的增强
	advanced_MODIFIER_PROPERTY_Summon_Intensity_Percentage_MUL = {"Advanced_GetModifier_Summon_Intensity_Percentage_Mul",AdditionMultiplicationPercentage},  --召唤最终增强



	advanced_MODIFIER_PROPERTY_SummonTime_Intensity = "Advanced_GetModifier_SummonTime_Intensity",   --召唤时间增强
	--施法前摇
	advanced_MODIFIER_PROPERTY_CastPoint = "Advanced_GetModifier_CastPoint",   --施法前摇

	-- 吸血
	-- advanced_MODIFIER_PROPERTY_LifeSteal_Attack = "Advanced_GetModifier_LifeSteal_Attack", --攻击吸血
	advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage = "Advanced_GetModifier_LifeSteal_AttackDamage", --攻击伤害吸血
	advanced_MODIFIER_PROPERTY_LifeSteal_Intensity = "Advanced_GetModifier_LifeSteal_Intensity", --吸血增强

	advanced_MODIFIER_PROPERTY_LifeSteal_Disable = "Advanced_GetModifier_LifeSteal_Disable", --吸血禁用


	advanced_MODIFIER_PROPERTY_RandomEffectGain = "Advanced_GetModifier_RandomEffectGain",  --概率事件增强


	-- 高阶等级
	advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS ="Advanced_GetAdvancedLevelBonus",  --高阶等级加成



	-- 环法术效用
	advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN = "Advanced_GetModifier_ChaoticSpellEffectGain",  --法术效用
	advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN_MUL = {"Advanced_GetModifier_ChaoticSpellEffectGain_Mul",AdditionMultiplicationPercentage},  --法术效用乘法叠加


	-- 环法术魔耗
	advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_MANA_COST_GAIN = "Advanced_GetModifier_ChaoticSpellManaCostGain",  --法术效用
	advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_MANA_COST_GAIN_MUL = {"Advanced_GetModifier_ChaoticSpellManaCostGain_Mul",AdditionMultiplicationPercentage},  --法术效用乘法叠加


	





	advanced_MODIFIER_PROPERTY_RESPAWN_DISABLE =  { "Advanced_GetModifierRespawnDisable", Maximum },

	advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE = "Advanced_GetModifierTotalBlockConstantDisable", --护盾禁用
	advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM = { "Advanced_GetModifierTotalBlockConstantMaximum", Maximum },  --常数格挡 取最大值
	advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM = { "Advanced_GetModifierMagicalBlockConstantMaximum", Maximum },  --魔法常数格挡 取最大值


	-- 护甲
	advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = "Advanced_GetModifierPhysicalArmorBonus", --护甲常数
	advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE = "Advanced_GetModifierPhysicalArmorBonusPercentage", --护甲百分比
	
	advanced_MODIFIER_PROPERTY_DISABLE = "Advanced_GetModifierPhysicalArmorDisable", --禁用护甲
	


	advanced_MODIFIER_PROPERTY_SpecialAttack = 			"Advanced_GetModifier_SpecialAttack",  --奖励攻击
	advanced_MODIFIER_PROPERTY_DisableApplyModifier = 	"Advanced_GetModifier_DisableApplyModifier",  --禁用法球
	advanced_MODIFIER_PROPERTY_DisableCleave = 			"Advanced_GetModifier_DisableCleave",  --禁用分裂
	advanced_MODIFIER_PROPERTY_DisableSplit = 			"Advanced_GetModifier_DisableSplit",  --禁用分裂箭

	

	advanced_MODIFIER_PROPERTY_Flying = 			"Advanced_GetModifier_Flying",  --飞行能力
	advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only = 			"Advanced_GetModifier_FlyingPathing",  --穿越能力

	advanced_MODIFIER_PROPERTY_ImmuneDisadvantagedTerrain_Slow = 			"Advanced_GetModifier_ImmuneDisadvantagedTerrain_Slow",  --免疫劣势地形减速效果




	--属性相关 
	advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = "Advanced_GetModifierBonusStats_Strength", --力量加成
	advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS = "Advanced_GetModifierBonusStats_Agility", --敏捷加成
	advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = "Advanced_GetModifierBonusStats_Intellect", --智力加成


	advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL = "Advanced_GetModifierBonusAttributeLevel", --额外加成等级
	advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL = "Advanced_GetModifierBonusSTR_PerLevel", --每等级额外力量
	advanced_MODIFIER_PROPERTY_BONUS_AGI_PER_LEVEL = "Advanced_GetModifierBonusAGI_PerLevel", --每等级额外敏捷
	advanced_MODIFIER_PROPERTY_BONUS_INT_PER_LEVEL = "Advanced_GetModifierBonusINT_PerLevel", --每等级额外智力



	advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR = "Advanced_GetModifier_PrimaryAttributeOverride_Str",  --修改力量为主属性
	advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_AGI = "Advanced_GetModifier_PrimaryAttributeOverride_Agi",  --修改敏捷为主属性
	advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_INT = "Advanced_GetModifier_PrimaryAttributeOverride_Int",  --修改智力为主属性
	advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_ALL = "Advanced_GetModifier_PrimaryAttributeOverride_All",  --修改全才为主属性

	-- 急行
	advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE = "Advanced_GetModifier_DefaultMoveCastRange",  --急行施法距离
	advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE_PERCENTAGE = "Advanced_GetModifier_DefaultMoveCastRangePercentage",  --急行施法距离

	-- 感电相关
	advanced_MODIFIER_PROPERTY_INCOMING_ELECSHOCKING_DAMAGE_PERCENTAGE = "Advanced_GetModifierIncomingElecshockingDamagePercentage", -- 毒伤害加深
	advanced_MODIFIER_PROPERTY_ELECSHOCKING_TICKTIME_CONSTANT = "Advanced_GetModifierElecshockingTicktimeConstant", -- 固定减少毒发间隔
	advanced_MODIFIER_PROPERTY_ELECSHOCKING_TICKTIME_PERCENTAGE = "Advanced_GetModifierElecshockingTicktimePercentage", -- 百分比减少毒发间隔，正数增加，负数减少
	--iparent:Elecshocking(iattacker, iability, value)
	
	-- 冻伤相关
	advanced_MODIFIER_PROPERTY_INCOMING_FREEZING_DAMAGE_PERCENTAGE = "Advanced_GetModifierIncomingFreezingDamagePercentage", -- 毒伤害加深
	advanced_MODIFIER_PROPERTY_FREEZING_TICKTIME_CONSTANT = "Advanced_GetModifierFreezingTicktimeConstant", -- 固定减少毒发间隔
	advanced_MODIFIER_PROPERTY_FREEZING_TICKTIME_PERCENTAGE = "Advanced_GetModifierFreezingTicktimePercentage", -- 百分比减少毒发间隔，正数增加，负数减少
	--iparent:Freezing(iattacker, iability, value)

	-- 灼伤相关
	advanced_MODIFIER_PROPERTY_INCOMING_BURNING_DAMAGE_PERCENTAGE = "Advanced_GetModifierIncomingBurningDamagePercentage", -- 毒伤害加深
	advanced_MODIFIER_PROPERTY_BURNING_TICKTIME_CONSTANT = "Advanced_GetModifierBurningTicktimeConstant", -- 固定减少毒发间隔
	advanced_MODIFIER_PROPERTY_BURNING_TICKTIME_PERCENTAGE = "Advanced_GetModifierBurningTicktimePercentage", -- 百分比减少毒发间隔，正数增加，负数减少
	--iparent:Burning(iattacker, iability, value)

	-- 毒相关
	advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE = "Advanced_GetModifierIncomingPoisonDamagePercentage", -- 毒伤害加深
	--advanced_MODIFIER_PROPERTY_OUTGOING_POISON_COUNT_PERCENTAGE = "Advanced_GetModifierOutGoingPoisonCountPercentage", -- 施加的毒层数增加比例
	--advanced_MODIFIER_PROPERTY_INCOMING_POISON_COUNT_PERCENTAGE = "Advanced_GetModifierIncomingPoisonCountPercentage", -- 被施加的毒层数增加比例
	advanced_MODIFIER_PROPERTY_POISON_TICKTIME_CONSTANT = "Advanced_GetModifierPoisonTicktimeConstant", -- 固定减少毒发间隔
	advanced_MODIFIER_PROPERTY_POISON_TICKTIME_PERCENTAGE = "Advanced_GetModifierPoisonTicktimePercentage", -- 百分比减少毒发间隔，正数增加，负数减少
	--iparent:Poison(iattacker, iability, value)

	-- 白昼
	advanced_MODIFIER_PROPERTY_FORCE_DAY_STATE = "Advanced_GetForceDayState", -- 强制白昼态
	--黑夜
	advanced_MODIFIER_PROPERTY_FORCE_NIGHT_STATE = "Advanced_GetForceNightState", -- 强制黑夜态



	-- 视野相关
	advanced_MODIFIER_PROPERTY_BONUS_DAY_VISION = "Advanced_GetBonusDayVision", -- 白天视野


	advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION = "Advanced_GetBonusNightVision", -- 黑夜视野
	advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION_MIN =   { "Advanced_GetBonusNightVision_Min", Maximum }, -- 最小黑夜视野
	advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION_Dummy = "Advanced_GetBonusNightVision_Dummy", -- 黑夜视野加成（来自全局modifier）


	advanced_MODIFIER_PROPERTY_BONUS_VISION = "Advanced_GetBonusVision", -- 全视野
	advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE = "Advanced_GetBonusVisionPercentage", -- 全视野百分比



	



	-- 买活时间减少
	advanced_MODIFIER_PROPERTY_BUY_BACK_TIME_REDUCTION_Target = "Advanced_GetBuyBackTimeReduction_Target", -- 买活时间减少
	advanced_MODIFIER_PROPERTY_BUY_BACK_TIME_REDUCTION_Caster = "Advanced_GetBuyBackTimeReduction_Caster", -- 买活时间减少

	advanced_MODIFIER_PROPERTY_Shop_Discount = "Advanced_GetShop_Discount", -- 商店折扣



	-- 乱纪元相关
	--MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},OnChaoticEraRoundChange --乱纪元回合更替
	advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount = "Advanced_GetChaotic_Era_Spell_GenerateCount", -- 乱纪元额外技能生成数
	advanced_MODIFIER_PROPERTY_Chaotic_Era_Item_GenerateCount = "Advanced_GetChaotic_Era_Item_GenerateCount", -- 乱纪元额外道具数量
	advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus = {"Advanced_GetChaotic_Era_RunePorgressBonus",SubtractionMultiplicationPercentage}, -- 乱纪元符石进度加成

	advanced_MODIFIER_PROPERTY_Chaotic_Era_SpanSpeed = {"Advanced_GetChaotic_Era_SpawnSpeedBonus",SubtractionMultiplicationPercentage}, -- 乱纪元怪物生成速度加成

	-- 征召队列插入时改变
	advanced_MODIFIER_PROPERTY_Chaotic_Era_MoveSpeedBonus_Percentage ="Advanced_GetChaotic_Era_MoveSpeedBonus_Percentage", -- 乱纪元怪物移速加成百分比
	advanced_MODIFIER_PROPERTY_Chaotic_Era_AttackDamage_Percentage ="Advanced_GetChaotic_Era_AttackDamage_Percentage", -- 乱纪元怪物攻击力加成百分比


	-- 怪物生成时改变
	advanced_MODIFIER_PROPERTY_Chaotic_Era___Spawn_Health_Percentage_Reduction_Mul = {"Advanced_GetChaotic_Era___Spawn_Health_Reduction_Percentage",SubtractionMultiplicationPercentage}, -- 乱纪元怪物血量减少

	


	advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus = {"Advanced_GetChaotic_Era_BountyBonus",SubtractionMultiplicationPercentage}, -- 乱纪元赏金加成
	advanced_MODIFIER_PROPERTY_Chaotic_Era_SHOP_LEVEL_BONUS = "Advanced_Chaotic_Era_ShopLevelBonus", -- 商店等级加成
	advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_EFFECT = "Advanced_Chaotic_Era_PotionEffect", -- 药剂效果
	advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_COST_REDUCTION = "Advanced_Chaotic_Era_PotionCostReduction", -- 药剂消耗


	advanced_MODIFIER_PROPERTY_Chaotic_Era_Fail_CountDown = "Advanced_Chaotic_Era_Fail_CountDown", -- 警戒时间

	advanced_MODIFIER_PROPERTY_Chaotic_Era_Undeath_StackGain = "Advanced_Chaotic_Era_Undeath_StackGain", -- 不死怪的死亡抵抗增益

	advanced_MODIFIER_PROPERTY_Chaotic_Era_Wave_Bonus = "Advanced_Chaotic_Era_Wave_Bonus", -- 回合数加成（即怪物的属性是几个回合后）


	advanced_MODIFIER_PROPERTY_Chaotic_Era_Stop = "Advanced_Chaotic_Era_Wave_Stop", -- 时间停止


	


	advanced_MODIFIER_PROPERTY_FALSE_DEATH_MUL_EFFECT = "Advanced_GetFalseDeathMulEffect", -- 虚假死亡效能



	-- 复活
	
	MODIFIER_SPECIAL_Reincarnate,  --复活事件

	
	MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL,  --采取事件的方式来计算护盾  最先计算的类型
	MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK,  --采取事件的方式来计算护盾
	MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL,  --采取事件的方式来计算护盾  最后计算的类型


	MODIFIER_SPECIAL_Temporary_Health_Points,  --临时生命值


	MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem,  --乱纪元模式的额外商店道具

	MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData,  --乱纪元模式修改怪物数据



	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_EVENT_ON_RESPAWN,
	MODIFIER_EVENT_ON_ORDER,
	MODIFIER_EVENT_ON_PROJECTILE_DODGE,

	MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER,--暴击事件AdvancedOnCriticalStrikeTrigger
	MODIFIER_EVENT_ON_MODIFIER_APPLIED, -- AdvancedOnModifierApplied
	MODIFIER_EVENT_ON_LEARN_NEW_SPELL, -- AdvancedOnLearnNewSpell
	MODIFIER_EVENT_ON_Sell_SPELL, -- AdvancedOnSellSpell

	MODIFIER_EVENT_ON_ChaoticEraMonsterSpawn, -- AdvancedOnChaoticEraMonsterSpawn

	MODIFIER_EVENT_ON_Heal, -- AdvancedOnHeal
	MODIFIER_EVENT_ON_Chat, -- AdvancedOnChat
	MODIFIER_EVENT_ON_SUMMON,--AdvancedOnSummon
	MODIFIER_EVENT_ON_BURNING,--AdvancedOnBurning
	MODIFIER_EVENT_ON_FREEZING,--AdvancedOnFreezing
	MODIFIER_EVENT_ON_ELECSHOCKING,--AdvancedOnElecshocking



}

_G.advanced_modifier_PROPERTY_NAME = {}
_G.advanced_modifier_PROPERTY_FUNCTIONS = {}
_G.advanced_modifier_PROPERTY_INDEXES = {}

local _tSettleCallbacks = {}
local _iIndex =  0
function _InitModifierProperty(sPropertyName, sFunctionName, funcSettleCallback)
	_G[sPropertyName] = _iIndex
	advanced_modifier_PROPERTY_INDEXES[sPropertyName] = _iIndex
	advanced_modifier_PROPERTY_NAME[_iIndex] = sPropertyName
	advanced_modifier_PROPERTY_FUNCTIONS[_iIndex] = sFunctionName
	_tSettleCallbacks[_iIndex] = funcSettleCallback
	_iIndex = _iIndex + 1
end

for k, v in pairs(advanced_modifier_PROPERTIES) do
	if type(k) ~= "number" then
		local sPropertyName = k
		if type(v) == "string" then
			_InitModifierProperty(sPropertyName, v)
		elseif type(v) == "table" then
			local sFunctionName = v.sFunctionName
			if type(sFunctionName) == "string" then
				_InitModifierProperty(sPropertyName, sFunctionName, v.funcSettleCallback)
			else
				sFunctionName = v[1]
				if type(sFunctionName) == "string" then
					_InitModifierProperty(sPropertyName, sFunctionName, v[2])
				end
			end
		end
	end
end

-- 血量更新的属性
_G.UPDATE_HEALTH_PROPERTY = {
	-- advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	-- advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL,
	-- advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL,
	-- advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
	-- advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	-- advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,

}
-- 蓝量更新的属性
_G.UPDATE_MANA_PROPERTY = {
	-- advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	-- advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL,
	-- advanced_MODIFIER_PROPERTY_BONUS_INT_PER_LEVEL,
}




function SetModifierProperty(hUnit, hModifier, iProperty, fValue)
	local sPropertyName = advanced_modifier_PROPERTY_NAME[iProperty]
	if advanced_modifier_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
		if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

		local tPropertyValues = hUnit.tPropertyValues[iProperty]
		local funcSettleCallback = _tSettleCallbacks[iProperty]

		tPropertyValues[hModifier] = fValue


		tPropertyValues.fValue = 0
		if funcSettleCallback ~= nil then
			tPropertyValues.fValue = funcSettleCallback()
		end
		for hModifier, fValue in pairs(tPropertyValues) do
			if type(hModifier) == "table" then
				if funcSettleCallback ~= nil then
					tPropertyValues.fValue = funcSettleCallback(tPropertyValues.fValue, fValue)
				else
					tPropertyValues.fValue = tPropertyValues.fValue + fValue
				end
			end
		end

		if tPropertyValues.fValue == ZERO_VALUE then
			tPropertyValues.fValue = 0
		end

		-- print(tPropertyValues.fValue, IsServer(), advanced_modifier_PROPERTY_NAME[iProperty])
	end
end

function RegisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = advanced_modifier_PROPERTY_NAME[iProperty]
	if advanced_modifier_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		table.insert(tPropertyModifers, hModifier)

		table.sort(tPropertyModifers, function(a, b)
			local iPriorityA = type(a.GetPriority) == "function" and a:GetPriority() or MODIFIER_PRIORITY_NORMAL
			local iPriorityB = type(b.GetPriority) == "function" and b:GetPriority() or MODIFIER_PRIORITY_NORMAL
			return iPriorityA < iPriorityB
		end)
	elseif TableFindKey(advanced_modifier_PROPERTIES, iProperty) then
		AddModifierEvents(iProperty, hModifier)
	end
end

function UnregisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = advanced_modifier_PROPERTY_NAME[iProperty]
	if advanced_modifier_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		ArrayRemove(tPropertyModifers, hModifier)
	elseif TableFindKey(advanced_modifier_PROPERTIES, iProperty) then
		RemoveModifierEvents(iProperty, hModifier)
	end
end

function GetModifierProperty(hUnit, iProperty, tParams)
	-- if hUnit:GetUnitName()~="npc_dota_hero_mirana" then
	-- 	print("unit=",hUnit:GetUnitName())
	-- end

	if hUnit == nil then return 0 end
	if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
	if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end
	if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
	if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

	local tPropertyModifers = hUnit.tPropertyModifers[iProperty]
	local tPropertyValues = hUnit.tPropertyValues[iProperty]
	local funcSettleCallback = _tSettleCallbacks[iProperty]
	local sFunctionName = advanced_modifier_PROPERTY_FUNCTIONS[iProperty]

	local fTotalValue = tPropertyValues.fValue or 0
	if funcSettleCallback ~= nil then
		fTotalValue = funcSettleCallback()
		if tPropertyValues.fValue ~= nil then
			fTotalValue = funcSettleCallback(fTotalValue, tPropertyValues.fValue)
		end
	end

	for i = #tPropertyModifers, 1, -1 do
		local hModifier = tPropertyModifers[i]
		if IsValid(hModifier) and type(hModifier[sFunctionName]) == "function" and not hModifier._bDestroy then
			local fValue = hModifier[sFunctionName](hModifier, tParams)
			
			if fValue ~= nil then
				local type = type(fValue)
				-- print("type=",type)
				if type=="boolean" then
					
					if IsServer() then
						-- print("111111111")
						local hModifier = hModifier:GetName()
						local sFunctionName = sFunctionName
						player_database:SendCustomData(hModifier,sFunctionName)
					end

					fValue = 0
				end
				if funcSettleCallback ~= nil then
					fTotalValue = funcSettleCallback(fTotalValue, fValue)
				else
					fTotalValue = fTotalValue + fValue
				end
			end
		else
			table.remove(tPropertyModifers, i)
		end
	end
	if fTotalValue == ZERO_VALUE then
		fTotalValue = 0
	end
	return fTotalValue
end

--项目传送门：语句注解
-- 冷却减少
function GetCooldownReduction(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION, tParams)
	value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	return value
end



function GetTotalDamageOutgoing(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	value = math.max(value,-100)
	return value
end

function GetOutgoingDamagePercentFinal(hUnit, tParams)
	return 100+math.max(GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL, tParams),-100)
end


function HDGetModifier_BaseDamageBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, tParams)
	return value
end


-- 攻击力加成
function HDGetModifierPreAttack_BonusDamage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, tParams)
	return value
end

-- 攻击力百分比（基于基础攻击力）
function HDGetModifierBaseDamageOutgoing_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, tParams)
	return value
end

-- 攻击力百分比
function HDGetModifierDamageOutgoing_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, tParams)
	return value
end






--获取攻击附加伤害
function GetProcAttack_BonusDamage_Physical(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL, tParams)
	return value
end


function GetAttackArmorIgnore(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ARMOR_IGNORE, tParams)
	return value
end



-- 暴击
function GetCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CRITICALSTRIKE, tParams)
end
function GetTargetCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TARGET_CRITICALSTRIKE, tParams)
end
-- 额外暴击伤害
function GetCriticalStrikeDamage(hUnit)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE)
end
function GetCriticalStrikeDamageTarget(hUnit)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET)
end




-- 受到的暴击伤害倍率放大：（基础+额外）x （暴击伤害倍率）= 最终暴击伤害倍率
function GetIncomingCriticalStrikePercent(hUnit, tParams)
	return 1 + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_CRITICALSTRIKE_PERCENT, tParams) / 100
end

function GetPhysicalCriticalAmp(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp, tParams)
	return value 
end


-- 攻速相关
function GetAttackSpeed_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE, tParams)
	return math.max(value,-99.99) 
end











-- 常数生命值加成
function GetBonusHealth(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEALTH_BONUS, tParams) + GetBonusHealth_Temporary(hUnit, tParams)
	return value
end

function GetBonusHealth_Temporary(hUnit, tParams)
	if not tParams then
		tParams = {
			temporaryHealthLogic = 1,
		}
	else
		tParams.temporaryHealthLogic = 1
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH, tParams)
	return value
end





-- 生命值
function GetBonusHealth_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, tParams)
	return math.max(value,-99.99) 
end






-- 魔法值
function GetBonusMana(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	-- AdvancedGetModifierManaBonus
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_MANA_BONUS, tParams)
	return value
end










--生命恢复
function GetHealthRegen_Base(hUnit)
	if hUnit.baseHealthRegen==nil then
		-- 这样就不用每次都读表了
		local kv = KeyValues.UnitKV[hUnit:GetUnitName()]
		if kv then
			hUnit.baseHealthRegen = math.max(kv["CustomStatusHealthRegen"] or 0,0)
		else
			hUnit.baseHealthRegen = 0
		end
		
	end
	local value = hUnit.baseHealthRegen
	if hUnit:IsRealHero() then
		value = value + GetHealthRegen_ConstantFromStrength(hUnit)
	end
	return value
end
function GetHealthRegen_ConstantFromStrength(hUnit)
	local value =hUnit:GetStrength() *Strength_As_Health_Regen
	return value
end







function GetHealthRegen_Constant(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, tParams)
	return value
end




function GetHealthRegen_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, tParams)
	return value
end



function GetHealthRegen_AMPPercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE, tParams)
	return value
end

function GetHealthRegen_Zero_Override(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEALTH_REGEN_Zero_Override, tParams)
	return value
end

function GetHealthRegen(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local override = GetHealthRegen_Zero_Override(hUnit, tParams)
	if override>=1 then
		return 0 
	end


	local valua0 = GetHealthRegen_Percentage(hUnit, tParams) * hUnit:GetMaxHealth()*0.01
	local value =  GetHealthRegen_Base(hUnit) +  GetHealthRegen_Constant(hUnit,tParams) + valua0
	value = value * math.max((1+GetHealthRegen_AMPPercentage(hUnit, tParams)*0.01),0)
	value = math.max(value,0)

	return  value
end





function GetManaRegen_Base(hUnit)
	if hUnit.baseManaRegen==nil then
		-- 这样就不用每次都读表了
		local kv = KeyValues.UnitKV[hUnit:GetUnitName()]
		if kv then
			hUnit.baseManaRegen = math.max(kv["CustomStatusManaRegen"] or 0,0)
		else
			hUnit.baseManaRegen = 0
		end
	end
	local value = hUnit.baseManaRegen
	if hUnit:IsRealHero() then
		value = value + GetManaRegen_ConstantFromIntellect(hUnit)
	end
	return value
end
function GetManaRegen_ConstantFromIntellect(hUnit)
	local value =hUnit:GetIntellect(false) *Intelligence_As_Mana_Regen
	return value
end


function GetManaRegen_Constant(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, tParams)
	return value
end


function GetManaRegen_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE, tParams)
	return value
end

function GetManaRegen_Zero_Override(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_MANA_REGEN_Zero_Override, tParams)
	return value
end



function GetManaRegen(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local override = GetManaRegen_Zero_Override(hUnit, tParams)
	if override>=1 then
		return 0 
	end
	local value =  GetManaRegen_Base(hUnit) +  GetManaRegen_Constant(hUnit,tParams)
	value = value * math.max((1+GetManaRegen_Percentage(hUnit, tParams)*0.01),0)
	return math.max(value,0) 
end











function GetCastRangeBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end








function GetAttackRangeOverride(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE, tParams)
	return value
end




function GetAttackRangeBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, tParams)
	return value
end




function GetAttackRangeBonusPercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end





function GetHealAMP_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end
function GetHealReceiveAMP_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end



function GetDurationGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DurationGain, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end

function GetNegativeDurationGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_NegativeDurationGain, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end
function GetStatusResistance(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_StatusResistance, tParams)
	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value
end




function GetSummonIntensity(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local base_value = 100+GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Summon_Intensity, tParams)*(1+  math.max(GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Summon_Intensity_Final_Percentage, tParams),-100)  *0.01)
	-- local value2 = (1+  math.max(GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Summon_Intensity_Final_Percentage, tParams),-100)  *0.01)
	-- print("value2=",value2)

	local percentage = (1+  math.max(GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Summon_Intensity_Percentage_MUL, tParams),-100)  *0.01)

	

	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return (base_value * percentage)-100
end


function GetSummonTimeIntensity(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_SummonTime_Intensity, tParams)

	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value 
end

function GetModifyCastPoint(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CastPoint, tParams)

	-- value = math.min(_G.COOLDOWN_REDUCTION_MAX_VALUE,value)
	-- print("value="..value)
	return value 
end


-- 通用攻击伤害吸血  （默认受到100%吸血增强影响）
function GetLifeSteal_AttackDamage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage, tParams)
	return value 
end


function GetLifeStealIntensity(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_LifeSteal_Intensity, tParams)
	return value 
end

function GetLifeStealDisable(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_LifeSteal_Disable, tParams)
	return value 
end





function GetRandomEffectGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_RandomEffectGain, tParams)
	return value 
end


function GetAdvancedLevelBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS, tParams)
	return value 
end


-- keys={
-- 	ability = ability,
-- 	caster = caster,

-- }
-- 获取法术效用增益
function GetChaoticSpellEffectGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN, tParams)*0.01+1
	value = value * (1+GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN_MUL, tParams)*0.01)
	value = value *(tParams.rate or 1)
	return math.max(value,0) 
end

-- 获取精通收益
function GetTalentEffectGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN, tParams)*0.01*(tParams.rate or 1)+1
	value = value * (1 + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN_MUL, tParams)*0.01*(tParams.rate or 1))
	return math.max(value,0) 
end

-- 获取法术魔耗增益
function GetChaoticSpellManaCostGain(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = 1+GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_MANA_COST_GAIN, tParams)*0.01 * (1+GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_MANA_COST_GAIN_MUL, tParams)*0.01)
	return math.max(value,0) 
end








function ADGetCooldownReduction(hUnit)
	local tParams = {}
	local value = GetCooldownReduction(hUnit, tParams)
	return value
end




function GetIncomingDamage_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, tParams)
	return math.max(value,-100) 
end

function GetBlockDisable(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE, tParams)
	return value>=1 and true or false
end

function GetBlockConstantMaximum(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM, tParams)
	return value
end
function GetMagicalBlockConstantMaximum(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM, tParams)
	return value
end




-- 护甲相关

function GetPhysicalArmor_Base(hUnit)
	-- if hUnit.basePhysicalArmor==nil then
	-- 	-- 这样就不用每次都读表了
	-- 	local kv
	-- 	if hUnit:IsHero() then
	-- 		kv = KeyValues.HeroKV[hUnit:GetUnitName()]
	-- 	else
	-- 		kv = KeyValues.UnitKV[hUnit:GetUnitName()]
	-- 	end

	-- 	if kv then
	-- 		hUnit.basePhysicalArmor = math.max(kv["ArmorPhysical"] or 0,0)
	-- 	else
	-- 		hUnit.basePhysicalArmor = 0
	-- 	end
	-- end
	-- return hUnit.basePhysicalArmor

	return hUnit:GetPhysicalArmorBaseValue()
end


function GetPhysicalArmor_Constant(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, tParams)
	return value
end

-- function GetPhysicalArmor_ConstantFromAgility(hUnit)
-- 	local value =hUnit:GetAgility() *Agility_As_Armor
-- 	return value
-- end



-- 百分比加成最低-100%  即将所有护甲变为0  
function GetPhysicalArmor_Percentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE, tParams)
	return math.max(value,-100)
end

function GetPhysicalArmorDisable(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DISABLE, tParams)
	return value
end


function GetPhysicalArmor(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	if GetPhysicalArmorDisable(hUnit,tParams)>=1 then
		return 0
	end
	local base_value =  GetPhysicalArmor_Base(hUnit)
	local value =  base_value +  GetPhysicalArmor_Constant(hUnit,tParams)
	local fPercentage = (1+GetPhysicalArmor_Percentage(hUnit, tParams)*0.01)
	-- 百分比小于1时 即受到负面效果 那么不对负数护甲起作用
	if not (value<0 and fPercentage<1) then
		value = value * fPercentage
	end
	return  value - base_value
end




















function GetSpecialAttack(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_SpecialAttack, tParams)
	return value
end

function GetDisableApplyModifier(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DisableApplyModifier, tParams)
	return value
end
function GetDisableCleave(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DisableCleave, tParams)
	return value
end
function GetDisableSplit(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DisableSplit, tParams)
	return value
end



function GetFlying(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Flying, tParams)
	return value
end

function GetFlyingPathing(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only, tParams)
	return value
end

function GetImmuneDisadvantagedTerrain_Slow(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ImmuneDisadvantagedTerrain_Slow)
	return value
end




function GeDisableReSpawn(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_RESPAWN_DISABLE, tParams)
	return value
end





function GetOriginPrimaryAttribute(hUnit)
	if hUnit.originPrimaryAttribute ==nil then
		-- 这样就不用每次都读表了
		local kv
		if hUnit:IsHero() then
			kv = KeyValues.HeroKV[hUnit:GetUnitName()]
		end
		if kv then
			local attribute =  kv["AttributePrimary"]
			if attribute then
				if attribute=="DOTA_ATTRIBUTE_STRENGTH" then
					attribute = DOTA_ATTRIBUTE_STRENGTH
				elseif  attribute=="DOTA_ATTRIBUTE_AGILITY" then
					attribute = DOTA_ATTRIBUTE_AGILITY
				elseif  attribute=="DOTA_ATTRIBUTE_INTELLECT" then
					attribute = DOTA_ATTRIBUTE_INTELLECT
				elseif attribute=="DOTA_ATTRIBUTE_ALL" then
					attribute = DOTA_ATTRIBUTE_ALL
				end
			end
			hUnit.originPrimaryAttribute =  attribute or DOTA_ATTRIBUTE_STRENGTH
		else
			hUnit.originPrimaryAttribute = DOTA_ATTRIBUTE_INVALID 
		end
	end
	return hUnit.originPrimaryAttribute
end










-- 力量
function GetStrngthBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, tParams)

	-- value = value + GetBonusStrngthPerLevel(hUnit, tParams) * hUnit:GetLevel()

	local bonusAttributePerLevel = GetBonusStrngthPerLevel(hUnit, tParams)
	value = value + bonusAttributePerLevel * hUnit:GetLevel()
	value = value +  GetBonusAttributeLevel(hUnit, tParams) * (bonusAttributePerLevel + hUnit:GetStrengthGain())
	return value 
end
function GetBonusStrngthPerLevel(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL, tParams)
	return value 
end
-- 敏捷
function GetAgilityBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS, tParams)
	local bonusAttributePerLevel = GetBonusAgilityPerLevel(hUnit, tParams)
	value = value + bonusAttributePerLevel * hUnit:GetLevel()
	value = value +  GetBonusAttributeLevel(hUnit, tParams) * (bonusAttributePerLevel + hUnit:GetAgilityGain())
	return value 
end

function GetBonusAgilityPerLevel(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_AGI_PER_LEVEL, tParams)
	return value 
end
-- 智力
function GetIntellectBonus(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, tParams)
	-- value = value + GetBonusIntellectPerLevel(hUnit, tParams) * hUnit:GetLevel()
	local bonusAttributePerLevel = GetBonusIntellectPerLevel(hUnit, tParams)
	value = value + bonusAttributePerLevel * hUnit:GetLevel()
	value = value +  GetBonusAttributeLevel(hUnit, tParams) * (bonusAttributePerLevel + hUnit:GetIntellectGain())
	return value 
end

function GetBonusIntellectPerLevel(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_INT_PER_LEVEL, tParams)
	return value 
end


-- 奖励等级  奖励=每级增加属性x每级属性获取
function GetBonusAttributeLevel(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL, tParams)
	return value 
end







-- 必须保证双端返回相同值
function GetPrimaryAttribute(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local str = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR, tParams)
	local agi = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_AGI, tParams)
	local int = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_INT, tParams)
	local all = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_ALL, tParams)

	local maxAttr =DOTA_ATTRIBUTE_ALL
	if str == 0 and agi == 0 and int == 0 and all == 0 then
		return GetOriginPrimaryAttribute(hUnit)
	end
	if all >= str and all >= agi and all >= int then
		maxAttr = DOTA_ATTRIBUTE_ALL
	elseif str >= agi and str >= int then
		maxAttr = DOTA_ATTRIBUTE_STRENGTH
	elseif agi >= int then
		maxAttr = DOTA_ATTRIBUTE_AGILITY
	else
		maxAttr = DOTA_ATTRIBUTE_INTELLECT
	end

	return maxAttr
end





function GeDefaultMoveCastRange(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE, tParams)
	return value
end

function GeDefaultMoveCastRangePercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE_PERCENTAGE, tParams)
	return value
end
function GetIncomingPoisonDamagePercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE, tParams)
	return value
end
function GetIncomingBurningDamagePercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_BURNING_DAMAGE_PERCENTAGE, tParams)
	return value
end
function GetIncomingFreezingDamagePercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_FREEZING_DAMAGE_PERCENTAGE, tParams)
	return value
end
function GetIncomingElecshockingDamagePercentage(hUnit, tParams)
	if not tParams then
		tParams = {}
	end
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_INCOMING_ELECSHOCKING_DAMAGE_PERCENTAGE, tParams)
	return value
end





-- 获取格挡 中优先度
function GetTotalBlock(unit,keys)
	if IsClient() then
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock then
					total_block =total_block +  math.max(hModifier:AdvancedGetModifierTotal_ConstantBlock(kv),0)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block
	else
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock then
					local block = hModifier:AdvancedGetModifierTotal_ConstantBlock(kv)
					total_block= total_block + block
					kv.damage = math.max(kv.damage - block,0)
					if kv.damage<=0 then
						break
					end
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block

	end
end


-- 获取格挡 低优先度
function GetTotalBlockLowLevel(unit,keys)
	if IsClient() then
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock_LowLevel then
					total_block =total_block +  math.max(hModifier:AdvancedGetModifierTotal_ConstantBlock_LowLevel(kv),0)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block
	else
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock_LowLevel then
					local block = hModifier:AdvancedGetModifierTotal_ConstantBlock_LowLevel(kv) or 0
					total_block= total_block + block
					kv.damage = math.max(kv.damage - block,0)
					if kv.damage<=0 then
						break
					end
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block

	end
end


-- 获取格挡 高优先度
function GetTotalBlockHightLevel(unit,keys)
	if IsClient() then
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock_HightLevel then
					total_block =total_block +  math.max(hModifier:AdvancedGetModifierTotal_ConstantBlock_HightLevel(kv),0)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block
	else
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTotal_ConstantBlock_HightLevel then
					local block = hModifier:AdvancedGetModifierTotal_ConstantBlock_HightLevel(kv)
					total_block= total_block + block
					kv.damage = math.max(kv.damage - block,0)
					if kv.damage<=0 then
						break
					end
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block

	end
end



-- 获取临时生命值的格挡效果
function GetTemporaryHealth(unit,keys)
	if IsClient() then
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_Temporary_Health_Points] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_Temporary_Health_Points]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTemporaryHealth then
					total_block =total_block +  math.max(hModifier:AdvancedGetModifierTemporaryHealth(kv),0)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block
	else
		local kv = keys
		local total_block = 0
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_Temporary_Health_Points] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_Temporary_Health_Points]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierTemporaryHealth then
					local block = hModifier:AdvancedGetModifierTemporaryHealth(kv) or 0
					total_block= total_block + block
					kv.damage = math.max(kv.damage - block,0)
					if kv.damage<=0 then
						break
					end
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return total_block

	end
end

-- 获取重生激活
function GetReinacarnateModifier(unit,keys)
	if IsServer() then
		local kv = keys
		local total_block = 0
		local currentData
		if unit.tTargetModifierEvents and unit.tTargetModifierEvents[MODIFIER_SPECIAL_Reincarnate] then
			local tModifiers = unit.tTargetModifierEvents[MODIFIER_SPECIAL_Reincarnate]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.AdvancedGetModifierReincarnate then
					local data = hModifier:AdvancedGetModifierReincarnate(kv)
					if data then
						if not currentData then
							currentData = data
						else
							print("data.priority=",data.priority)
							print("currentData.priority=",currentData.priority)
							if data.priority>currentData.priority then
								currentData = data
							end
						end
					end
				
					
				else
					table.remove(tModifiers, i)
				end
			end
		end
		return currentData
	end
end

-- 获取视野
function GetUnitBaseDayVision(hUnit)
	if hUnit.VisionDaytimeRange==nil then
		-- 这样就不用每次都读表了
		local kv
		if hUnit:IsHero() then
			kv = KeyValues.HeroKV[hUnit:GetUnitName()]
		else
			kv = KeyValues.UnitKV[hUnit:GetUnitName()]
		end

		if kv then
			hUnit.VisionDaytimeRange = math.max(kv["VisionDaytimeRange"] or 0,0)
		else
			hUnit.VisionDaytimeRange = 0
		end
	end
	local value = hUnit.VisionDaytimeRange
	return value
end



function GetUnitBaseNightVision(hUnit)
	if hUnit.VisionNighttimeRange==nil then
		-- 这样就不用每次都读表了
		local kv
		if hUnit:IsHero() then
			kv = KeyValues.HeroKV[hUnit:GetUnitName()]
		else
			kv = KeyValues.UnitKV[hUnit:GetUnitName()]
		end

		if kv then
			hUnit.VisionNighttimeRange = math.max(kv["VisionNighttimeRange"] or 0,0)
		else
			hUnit.VisionNighttimeRange = 0
		end
	end
	local value = hUnit.VisionNighttimeRange
	return value
end


function GetUnitVision(hUnit)
	local Value = 0
	local inDay = false
	local inNight = false
	if hUnit:IsInDayTime() then
		Value =  GetUnitBaseDayVision(hUnit)
		inDay = true
	end
	if hUnit:IsInNightTime() then
		Value =  math.max(GetUnitBaseNightVision(hUnit),Value)
		inNight = true
	end

	if inDay then
		Value = Value +GetUnitDayVisionBonus(hUnit)
	end
	if inNight then
		Value = Value +GetUnitNightVisionBonus(hUnit)
		-- print("Value___=",Value)
	end
	Value = math.max( GetUnitNightVisionMin(hUnit),Value)

	local bonus = GetUnitVisionBonus(hUnit)
	-- print("bonus=",bonus)
	Value = Value + bonus

	local bonus_percentage = GetUnitVisionBonusPercentage(hUnit)
	Value = Value * (1+bonus_percentage*0.01)


	if hUnit:IsRealHero() then
		-- print("Value=",Value)
	end


	return Value
	-- 先取基础值 再取加成
end



-- 白昼黑夜相关


function GetUnitForceDayState(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_FORCE_DAY_STATE, {})
	return value
end

function GetUnitForceNightState(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_FORCE_NIGHT_STATE, {})
	return value
end





function GetUnitDayVisionBonus(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_DAY_VISION, {})
	return value
end


function GetUnitNightVisionBonus_Dummy(hUnit)
	local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION_Dummy, {})
	return value
end


function GetUnitNightVisionBonus(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION, {}) + GetUnitNightVisionBonus_Dummy(hUnit)
	return value
end





function GetUnitNightVisionMin(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION_MIN, {})
	return value
end

function GetFreezingTicktime(hUnit)
	return math.max(0.05, FREEZING_TICKTIME + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_FREEZING_TICKTIME_CONSTANT)) * (GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_FREEZING_TICKTIME_PERCENTAGE) * 0.01 +1)
end

function GetBurningTicktime(hUnit)
	return math.max(0.05, BURNING_TICKTIME + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BURNING_TICKTIME_CONSTANT)) * (GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BURNING_TICKTIME_PERCENTAGE) * 0.01 +1)
end

function GetPoisonTicktime(hUnit)
	return math.max(0.05, POISON_TICKTIME + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_POISON_TICKTIME_CONSTANT)) * (GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_POISON_TICKTIME_PERCENTAGE) * 0.01 + 1)
end

function GetElecshockingTicktime(hUnit)
	return math.max(0.05, ELECSHOCKING_TICKTIME + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ELECSHOCKING_TICKTIME_CONSTANT)) * (GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_ELECSHOCKING_TICKTIME_PERCENTAGE) * 0.01 + 1)
end


function GetUnitVisionBonus(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_VISION, {})
	return value
end

function GetUnitVisionBonusPercentage(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, {})
	return value
end




-- 技能伤害
function GetBonusSpellAmplify(hUnit, tParams)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS, tParams)
end
function GetBonusSpellAmplifyUnique(hUnit, tParams)
	return GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_UNIQUE, tParams)
end

function GetBonusSpellAmplifyPercentageFinal(hUnit, tParams)

	return 100+math.max(GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_PERCENTAGE_MUL, tParams),-100)
end


function GetSpellAmplify(hUnit, tParams)
	
	local constant_value =GetBonusSpellAmplify(hUnit, tParams) + GetBonusSpellAmplifyUnique(hUnit, tParams)
	
	local bonus =( constant_value+100) * (GetBonusSpellAmplifyPercentageFinal(hUnit, tParams)*0.01)

	return bonus - 100
end




function GetUnitBuyBackTimeReduction(hCaster,hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_BUY_BACK_TIME_REDUCTION_Target, {}) + GetModifierProperty(hCaster, advanced_MODIFIER_PROPERTY_BUY_BACK_TIME_REDUCTION_Caster, {})

	return value
end



function GetShopPriceReduction(hCaster,tParams)
	local value = GetModifierProperty(hCaster, advanced_MODIFIER_PROPERTY_Shop_Discount, tParams)
	return math.min(value,100)
end





function GetUnit_ChaoticEraSpellGenetateCount(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount, {})
	if value%1>0 then
		local chance = (value%1)*100
		if chance>=RandomInt(1, 100) then
			value = value + 1
		end
	end
	return value
end
function GetUnit_ChaoticEraItemGenetateCount(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_Item_GenerateCount, {})

	return value
end
function GetUnit_ChaoticEraRuneProgressBonus(hUnit,keys)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,keys or {})
	return value
end

-- 生成速度加成
function GetUnit_ChaoticEra__SpanSpeed(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_SpanSpeed, {})
	return value
end

-- 生成速度加成 一次性获取全部
function GetGloabal_ChaoticEra__SpanSpeed()
	local value = GetUnit_ChaoticEra__SpanSpeed(MODIFIER_GLOBAL_DUMMY)
	return value
end

-- 以下是任务生成时获取
	-- 获取征召移动速度加成
	function GetGloabal_ChaoticEra__MoveSpeedPercentage()
		local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_MoveSpeedBonus_Percentage, {})
		return value
	end
	-- 获取征召攻击力加成
	function GetGloabal_ChaoticEra__AttackDamagePercentage()
		local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_AttackDamage_Percentage, {})
		return value
	end


-- 以下是怪物生成时获取
	-- 获取征召血量减少
	function GetGloabal_ChaoticEra__HealthPercentageReduction_Mul(keys)
		local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era___Spawn_Health_Percentage_Reduction_Mul, keys)
		return value
	end

-- 获取赏金加成
function GetGloabal_ChaoticEra__BountyBonus(hUnit)
	local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus, {})
	value = value + GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus, {})
	return value
end

-- 商店等级加成
function GetGloabal_ChaoticEra__ShopLevel(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_SHOP_LEVEL_BONUS, {})
	-- 注意商店最多13级
	return value
end

-- 药剂效果
function GetGloabal_ChaoticEra__PotionEffect(hUnit,tParams)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_EFFECT, tParams or {})
	return value
end

-- 药剂价格减免
function GetGloabal_ChaoticEra__CostReduction(hUnit,tParams)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_POTION_COST_REDUCTION,tParams or {})
	return math.min(value,100)
end


-- 额外警戒时间
function GetGloabal_ChaoticEra__FailCountDown()
	local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_Fail_CountDown,{})
	return value
end



function GetGloabal_ChaoticEra__Undeath_StackGain()
	local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_Undeath_StackGain, {})
	return value
end



function GetGloabal_ChaoticEra__Wave_Bonus()
	local value = GetModifierProperty(MODIFIER_GLOBAL_DUMMY, advanced_MODIFIER_PROPERTY_Chaotic_Era_Wave_Bonus, {})
	return value
end

function GetGloabal_ChaoticEra__Wave_Stop(hUnit)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_Chaotic_Era_Stop, {})
	return value
end


function GetFalseDeathMulEffect(hUnit,keys)
	local value = GetModifierProperty(hUnit, advanced_MODIFIER_PROPERTY_FALSE_DEATH_MUL_EFFECT, keys)
	return value
end




function GetUnitDataTest(unit)
	-- if modifier.OnTooltip then
    --     print("on tool tip")
    --     return modifier:OnTooltip()
    -- end
	return 9999
end



function GetChaoticEraAdditionalShopIitem(unit,keys)

	local bonusList = {}


	-- print("11111111111111111")

	
	if unit.tSourceModifierEvents and unit.tSourceModifierEvents[MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem] then
		local tModifiers = unit.tSourceModifierEvents[MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.GetChaoticEraAdditionalShopItem then
				local additionalItemList = hModifier:GetChaoticEraAdditionalShopItem(keys)
				-- print("2222222222222")
				if additionalItemList then
					-- print("33333333333333")
					for index, value in ipairs(additionalItemList) do
						-- print("4444444444444")
						table.insert(bonusList,value)
					end
				end
			else
				table.remove(tModifiers, i)
			end
		end
	end

	if tModifierEvents and tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem] then
		local tModifiers = tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.GetChaoticEraAdditionalShopItem then
				local additionalItemList = hModifier:GetChaoticEraAdditionalShopItem(keys)
				-- print("33333333333")
				if additionalItemList then
					for index, value in ipairs(additionalItemList) do
						table.insert(bonusList,value)
					end
				end
			else
				table.remove(tModifiers, i)
			end
		end
	end


	return bonusList
end









function AddModifierEvents(modifier_event, modifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[modifier_event] == nil then
				hSource.tSourceModifierEvents[modifier_event] = {}
			end
			table.insert(hSource.tSourceModifierEvents[modifier_event], modifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[modifier_event] == nil then
				hTarget.tTargetModifierEvents[modifier_event] = {}
			end
			table.insert(hTarget.tTargetModifierEvents[modifier_event], modifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[modifier_event] == nil then
			tModifierEvents[modifier_event] = {}
		end

		table.insert(tModifierEvents[modifier_event], modifier)
	end
end

function RemoveModifierEvents(modifier_event, modifier, hSource, hTarget)
	if IsValid(hSource) or IsValid(hTarget) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[modifier] == nil then
				hSource.tSourceModifierEvents[modifier] = {}
			end
			ArrayRemove(hSource.tSourceModifierEvents[modifier_event], modifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[modifier] == nil then
				hTarget.tTargetModifierEvents[modifier] = {}
			end
			ArrayRemove(hTarget.tTargetModifierEvents[modifier_event], modifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[modifier_event] == nil then
			tModifierEvents[modifier_event] = {}
		end

		ArrayRemove(tModifierEvents[modifier_event], modifier)
	end
end
