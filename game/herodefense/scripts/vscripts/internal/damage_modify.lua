--------------------------------------------------------------------------------伤害flag------------------------------------------------------------------------------
-- DOTA_DAMAGE_FLAG_NONE = 0
-- DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR = 1
-- DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR = 2
-- DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY = 4
-- DOTA_DAMAGE_FLAG_BYPASSES_BLOCK = 8
-- DOTA_DAMAGE_FLAG_REFLECTION = 16
-- DOTA_DAMAGE_FLAG_HPLOSS = 32 -- 生命移除
-- DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT = 64 -- 不计算额外伤害加深（但是该伤害还走GetModifierTotalDamageOutgoing_Percentage等事件）
-- DOTA_DAMAGE_FLAG_NON_LETHAL = 128 -- 不致死伤害
-- DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS = 512 -- 伤害不走GetModifierTotalDamageOutgoing_Percentage事件
-- DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION = 1024 -- 不受技能伤害影响
-- DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN = 2048
-- DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL = 4096 -- 没有法术吸血
-- DOTA_DAMAGE_FLAG_PROPERTY_FIRE = 8192
-- DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR = 16384
------------------------------------------------------------------------------自定义伤害flag------------------------------------------------------------------------------
HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY = 1 -- 不吃大多数伤害加成效果(主要包含物理、魔法、纯粹、全伤害四种泛类型加成，ps:例如毒伤害拥有此flag，但是还是能收到毒伤害加成效果)
HD_DAMAGE_FLAG_SPELL_CRIT = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY * 2 -- 技能暴击(√)2
HD_DAMAGE_FLAG_POISON = HD_DAMAGE_FLAG_SPELL_CRIT * 2 -- 异常·毒伤害4
HD_DAMAGE_FLAG_DOT = HD_DAMAGE_FLAG_POISON * 2 -- 持续伤害(√)8
HD_DAMAGE_FLAG_NO_SPELL_CRIT = HD_DAMAGE_FLAG_DOT * 2 -- 不会触发技能暴击(√)16

HD_DAMAGE_FLAG_LIGHTING_DAMAGE = HD_DAMAGE_FLAG_NO_SPELL_CRIT * 2 -- 雷属性伤害32
HD_DAMAGE_FLAG_FIRE_DAMAGE = HD_DAMAGE_FLAG_LIGHTING_DAMAGE * 2 -- 火属性伤害64
HD_DAMAGE_FLAG_HOLY_DAMAGE = HD_DAMAGE_FLAG_FIRE_DAMAGE * 2 --光属性伤害128
HD_DAMAGE_FLAG_ICE_DAMAGE = HD_DAMAGE_FLAG_HOLY_DAMAGE * 2 --水属性伤害256
HD_DAMAGE_FLAG_DARK_DAMAGE = HD_DAMAGE_FLAG_ICE_DAMAGE * 2 --暗属性伤害512
HD_DAMAGE_FLAG_PHY_DAMAGE = HD_DAMAGE_FLAG_DARK_DAMAGE * 2 --武技伤害1024
HD_DAMAGE_FLAG_BURNING_DAMAGE = HD_DAMAGE_FLAG_PHY_DAMAGE * 2 --异常·灼伤伤害2048
HD_DAMAGE_FLAG_FREEZING_DAMAGE = HD_DAMAGE_FLAG_BURNING_DAMAGE * 2 --异常·冻伤伤害4096
HD_DAMAGE_FLAG_ELECSHOCKING_DAMAGE = HD_DAMAGE_FLAG_FREEZING_DAMAGE * 2 --异常·电击伤害8192
HD_DAMAGE_FLAG_MERGE = HD_DAMAGE_FLAG_ELECSHOCKING_DAMAGE * 2 --合并伤害

-- 无法暴击
function Cannotcrit(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_NO_SPELL_CRIT) then
		return true
	end
	return false
end
-- 属性伤害
function IsElementDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_LIGHTING_DAMAGE,HD_DAMAGE_FLAG_FIRE_DAMAGE,HD_DAMAGE_FLAG_HOLY_DAMAGE,HD_DAMAGE_FLAG_ICE_DAMAGE,HD_DAMAGE_FLAG_DARK_DAMAGE) then
		return true
	end
	return false
end
--光属性
function IsHolyDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_HOLY_DAMAGE) then
		return true
	end
	return false
end
--暗属性
function IsDarkDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_DARK_DAMAGE) then
		return true
	end
	return false
end
--火属性
function IsFireDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_FIRE_DAMAGE) then
		return true
	end
	return false
end
--雷属性
function IsLightningDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_LIGHTING_DAMAGE) then
		return true
	end
	return false
end
--冰属性
function IsIceDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_ICE_DAMAGE) then
		return true
	end
	return false
end
--武技属性
function IsPhysicalSkillDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_PHY_DAMAGE) then
		return true
	end
	return false
end
--中毒
function IsPoisonDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_POISON) then
		return true
	end
	return false
end
--灼伤
function IsBurningDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_BURNING_DAMAGE) then
		return true
	end
	return false
end
--冻伤
function IsFreezingDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_FREEZING_DAMAGE) then
		return true
	end
	return false
end
--持续伤害
function IsDotDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_DOT) then
		return true
	end
	return false
end
--非直接伤害(反甲，生命移除，无额外效果，dot均属于此类)
function IsNotDirectDamage(keys)
	local damage_flags = keys.damage_flags
	if bit.band( damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION 
    or bit.band( damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS 
    or bit.band( damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT 
    or IsDotDamage(keys) then 
		return true 
	end

	return false
end
-- 合并伤害
function IsMergeDamage(keys)
	if DamageFilter(keys.record,HD_DAMAGE_FLAG_MERGE) then
		return true
	end
	return false
end


------------------------------------------------------------------------------伤害系统------------------------------------------------------------------------------
-- 获取下次record
function GetNextRecord()
	if RECORD_SYSTEM_DUMMY.iLastRecord == nil then
		RECORD_SYSTEM_DUMMY.iLastRecord = 0
	end
	if RECORD_SYSTEM_DUMMY.iLastRecord and RECORD_SYSTEM_DUMMY.iLastRecord >= 255 then
		RECORD_SYSTEM_DUMMY.iLastRecord = RECORD_SYSTEM_DUMMY.iLastRecord - 256
	end
	return RECORD_SYSTEM_DUMMY.iLastRecord + 1
end
-- 重写官方的造成伤害API
if ApplyDamage_Engine == nil then
	ApplyDamage_Engine = ApplyDamage
end
function ApplyDamage(tDamageTable)
	local iHDFlag = 0
	if tDamageTable.hd_flags ~= nil then
		iHDFlag = tDamageTable.hd_flags
	end

	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then
		RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {}
	end

	local iNextRecord = GetNextRecord()
	RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iNextRecord] = iHDFlag

	return ApplyDamage_Engine(tDamageTable)
end
-- 只要有参数中的任何一个HD_DAMAGE_FLAG就返回true
function DamageFilter(iRecord, ...)
	local bool = false
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM ~= nil then
		for i, iFlag in pairs({ ... }) do
			bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] or 0, iFlag) == iFlag)
		end
	end
	return bool
end
function GetDamageFlag(iRecord)
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM ~= nil then
		return RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] or 0
	end
	return 0
end
-- 在法术暴击效果里插入
function _SpellCrit(iRecord)
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = 0 end

	if bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord], HD_DAMAGE_FLAG_SPELL_CRIT) ~= HD_DAMAGE_FLAG_SPELL_CRIT then
		RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] + HD_DAMAGE_FLAG_SPELL_CRIT
	end
end
-- 在转换伤害效果里插入
function _BeforeTransformedDamage(iRecord)
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
	if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = 0 end

	if bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord], HD_DAMAGE_FLAG_BEFORE_TRANSFORMED_DAMAGE) ~= HD_DAMAGE_FLAG_BEFORE_TRANSFORMED_DAMAGE then
		RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] + HD_DAMAGE_FLAG_BEFORE_TRANSFORMED_DAMAGE
	end
end