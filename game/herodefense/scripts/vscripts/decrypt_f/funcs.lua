function IncreaseAttackSpeedCap(unit, new_cap)

	-- Fetch original BAT if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit:GetBaseAttackTime()
	end
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed(new_cap)
	local as = unit:GetAttackSpeed(false) * 100
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)

	local current_as = math.min(as, new_cap)

	-- Should we reduce BAT?
	if current_as > MAXIMUM_ATTACK_SPEED then
		local new_bat = MAXIMUM_ATTACK_SPEED / current_as * unit:GetDefaultBAT()
		unit:SetBaseAttackTime(new_bat)
	else
		RevertAttackSpeedCap(unit)
	end
end

-- Returns a unit's attack speed cap
function RevertAttackSpeedCap( unit )

	-- Return to original BAT
	unit:SetBaseAttackTime(unit:GetDefaultBAT())

end
--获取两单位距离
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end


function CalculateDistance3D(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length()
	return distance
end



-- 判断一个handle是否为无效值
function IsValid(h)
	return h ~= nil and not h:IsNull()
end

--矢量夹角
function AngleBetween(v1, v2)
	local sin = v1.x * v2.y - v2.x * v1.y;
	local cos = v1.x * v2.x + v1.y * v2.y;
	local a = math.atan2(sin, cos) * (180 / math.pi)
	local sign = v1:Cross(v2):Normalized():Dot(v1:Normalized():Cross(v2:Normalized()))
	return a * sign
end
---计算方向
function CalculateDirection(ent1, ent2)
	if ent1 == nil or ent2 == nil then return vec3_invalid end
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = pos1 - pos2
	direction.z = 0
	return direction:Normalized()
end

function HDCanAutoCast(caster, ability)
	if ability:IsCooldownReady() 
		and ability:GetAutoCastState() 
		and not caster:IsChanneling() 
		and not caster:IsSilenced()
		and caster:GetCurrentActiveAbility()==nil 
		and not caster:HasModifier("modifier_heroTalent_npc_dota_hero_marci_3") then

    	return true
	end
	return false
end


function StringToVector(sString)

	local temp = {}
	for str in string.gmatch(sString, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end	
	




----------------------------------------------------------------------------
key = ""
function PrintTable(table , level)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end

  if key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
        PrintTable(v, level + 1)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)  
      end
  end
  print(indent .. "}")

end


function SetDamage_Fliter(damage,damagetype,unit)
    ----冰封路径伤害加深
    local have_modifier = unit:FindAllModifiersByName("modifier_Advanced_Ice_Path_debuff")
    if #have_modifier ~= 0  and damagetype == 2 then
        damage = damage * (1 + have_modifier[1]:GetAbility():GetSpecialValueFor("bonus_damage") *0.01)
    end
    --液态冰伤害加深
    have_modifier = unit:FindAllModifiersByName("modifier_Advanced_Liquid_Frost")
    if #have_modifier ~= 0 then
        damage = damage * (1 + have_modifier[1]:GetAbility():GetSpecialValueFor("bonus_damage") *0.01)
    end
    have_modifier = unit:FindAllModifiersByName("modifier_Advanced_Liquid_Frost_sub")
    if #have_modifier ~= 0 then
        damage = damage * (1 + have_modifier[1]:GetAbility():GetSpecialValueFor("bonus_damage") *0.005)
	end
	return damage
end




function SetCreatureHealth(unit, health, update_current_health)

	unit:SetBaseMaxHealth(health)
	unit:SetMaxHealth(health)

	if update_current_health then
		unit:SetHealth(health)
	end
end


function SetCreatureMana(unit, mana, update_current_mana)

	unit:SetMaxMana(mana)

	if update_current_mana then
		unit:SetMana(mana)
	end
end




function IsHardDisabled( unit )
	if unit:IsStunned() or unit:IsHexed() or unit:IsNightmared() or unit:IsOutOfGame() then
		return true
	end

	return false
end

function GetDistanceBetweenTwoUnit( unit1, unit2 )
    local pos_1 = unit1:GetAbsOrigin()
    local pos_2 = unit2:GetAbsOrigin()
    local x = pos_1.x - pos_2.x
	local y = pos_1.y - pos_2.y
	return  math.sqrt(x*x+y*y)
end




function IsInTable(enemy,enemies)
	for i=1, #enemies do	
	   if enemy== enemies[i] then
		   return true
	   end
 end
 return false
end


function IsInTableAndDel(enemy,enemies)
	for i=1, #enemies do	
	   if enemy== enemies[i] then
		   enemies[i] =nil
		   return true
	   end
 end
 return false
end

function IncreaseDamage(unit,damage)
	local mindamage = unit:GetBaseDamageMin()
	local maxdamage = unit:GetBaseDamageMax()
	-- print("damage="..maxdamage.." after damage="..maxdamage+damage)
	local after_max = maxdamage+damage
	local after_min = mindamage+damage
	unit:SetBaseDamageMax(after_max)
	unit:SetBaseDamageMin(after_min)
	

	
end

function IncreaseArmor(unit,armor)
	local base_armor = unit:GetPhysicalArmorBaseValue()
	unit:SetPhysicalArmorBaseValue(base_armor+armor)
end


function IncreaseHealth(unit, health)


	local base_health = unit:GetBaseMaxHealth()
	unit:SetBaseMaxHealth(base_health+health)
end

function CDOTA_BaseNPC:AddWearable(modelName,attach)
    self:RemoveWearable(modelName)
    local model = Entities:CreateByClassname( "wearable_item" )
    model:SetModel(modelName)
    model:SetTeam(self:GetTeam())
    --model:SetParent(self, nil)
	model:SetOwner( self )
	model:SetParent(Entities, attach)
    
    
	model:FollowEntity(self, true)
	print("finished")
    return model
end

function CDOTA_BaseNPC:RemoveWearable(modelName)
	local children = self:GetChildren()
	for _, child in pairs(children)do
		if child:GetModelName() == modelName then
            child:SetParent(nil,nil)
            child:Destroy()
        end
	end
	
    -- each(children,function (child)
    --     if child:GetModelName() == modelName then
    --         child:SetParent(nil,nil)
    --         child:Destroy()
    --     end
    -- end)
end



function GetAllRealHeroes()
    local rheroes = {}
    local heroes = HeroList:GetAllHeroes()
    
    for i=1,#heroes do
        if heroes[i]:IsRealHero() then
            table.insert(rheroes,heroes[i])
        end
    end
    return rheroes
end


function ForceToDay ()
	local current_time_difference = 0.25 - GameRules:GetTimeOfDay()
	--说明被强制黑夜了，在返回原本的时间时设置为强制黑夜
	-- -2代表返回时间时为强制黑夜
	-- -3代表距离白天第一个时间点很接近，要么有别的强制白天技能发生了，要么自然发生
	--    无论哪种都不需要任何处理

	if GameRules:GetTimeOfDay()-0.25 <0.15  then
		current_time_difference = -3
	end
	if GameRules:GetTimeOfDay() == 0 then
		current_time_difference = -2
	end
	GameRules:SetTimeOfDay(0.25)
	return current_time_difference

end

function ReturnTime(current_time_difference)
	--有其他技能或者自然发生导致的间隔太短 不做任何处理
	if current_time_difference == -3 then
		return
	end

	if GameRules:GetTimeOfDay()-current_time_difference>1 then
		GameRules:SetTimeOfDay(GameRules:GetTimeOfDay()-current_time_difference-1)
	else
		GameRules:SetTimeOfDay(GameRules:GetTimeOfDay()-current_time_difference)
		print(GameRules:GetTimeOfDay()+current_time_difference)
	end
	--如果是这个数值，说明当前是强制黑夜
	if current_time_difference  == -2 then
		GameRules:SetTimeOfDay(-1)
	end
end







function CDOTA_BaseNPC:UpdateOriginModel(overrideName)
	self.origin_model_scale = self:GetModelScale()
    if overrideName then
        self.origin_model_name =  overrideName
        self.overrideModelName = overrideName
    else
        self.origin_model_name =  self:GetModelName()
    end
    

end


function CDOTA_BaseNPC:HDSpendMana(amount,ability)
	self:SpendMana( amount, ability )
end



function CDOTA_Modifier_Lua:SafeDestroy()
	-- local modifier = self
	-- print("save")
	if self and not self:IsNull() then

		self:Destroy()
	end
end


--------------------------
--哈希表
Hashtables = Hashtables or {}
function CreateHashtable(new_hastable)
	new_hastable = new_hastable or {}
	local index = 1
	while Hashtables[index] ~= nil do
		index = index + 1
	end
	Hashtables[index] = new_hastable
	return new_hastable
end
function RemoveHashtable(hastable)
	local index
	if type(hastable) == "number" then
		index = hastable
	else
		index = GetHashtableIndex(hastable) or 0
	end
	Hashtables[index] = nil
end
function GetHashtableIndex(hastable)
	for index, h in pairs(Hashtables) do
		if h == hastable then
			return index
		end
	end
	return nil
end
function GetHashtableByIndex(index)
	return Hashtables[index]
end
function HashtableCount()
	local n = 0
	for index, h in pairs(Hashtables) do
		n = n + 1
	end
	return n
end

--
----



--[[
★获取距离。
--]]
function TG_Distance(fpos,spos)
	return ( fpos - spos):Length2D()
  end
  
  
  
  --[[
  ★获取方向。
  --]]
function TG_Direction(fpos,spos)
	local DIR=( fpos - spos):Normalized()
	DIR.z=0
	return DIR
  end
  
function TG_Direction2(fpos,spos)
	local DIR=( fpos - spos):Normalized()
	return DIR
end

--装备升级cy
function EquipUpgrade(target,equip,cost,max_lvl) -- 花谁的钱、哪一件装备、花费、装备最大等级
	if not IsServer() then
		return
	end
	local target = target
	local equip = equip
	local cost = cost
	local max_lvl = max_lvl
	
	if equip then
		local lvl = equip:GetLevel()
		if lvl < max_lvl then
			equip:SetLevel(math.min(lvl+1 , max_lvl))
			target:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem)-- 花钱
		end
	end
end
--分裂攻击
function DoIMBACleaveAttack(hAttacker, hTarget, hAbility, fDamage, fStartRadius, fEndRadius, fDistance, sHitEffect)
	local target = hAttacker:IsRangedAttacker() and hTarget or hAttacker
	local direction = GetDirection2D(hTarget:GetAbsOrigin(), hAttacker:GetAbsOrigin())
	local enemy = FindUnitsInTrapezoid(hAttacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local pfx = nil
	if sHitEffect then
		pfx = ParticleManager:CreateParticle(sHitEffect, PATTACH_CUSTOMORIGIN, hAttacker)
		ParticleManager:SetParticleControl(pfx, 0, hAttacker:IsRangedAttacker() and hTarget:GetAbsOrigin() or hAttacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (hTarget:GetAbsOrigin() - hAttacker:GetAbsOrigin()):Normalized())
	end
	for i=1, #enemy do
		if enemy[i] ~= hTarget then

			AttackCleaveDelay(hAttacker, enemy[i], hAbility, fDamage)

			-- ApplyDamage({attacker = hAttacker, victim = enemy[i], ability = hAbility, damage = fDamage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			-- hd_flags =  HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY, })
			if pfx then
				ParticleManager:SetParticleControlEnt(pfx, i + 16, enemy[i], PATTACH_POINT, "attach_hitloc", enemy[i]:GetAbsOrigin(), true)
			end
		end
	end
	if pfx then
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

--带有个数的分裂攻击(以目标为起点)
function DoIMBACleaveAttackForNum(hAttacker, hTarget, hAbility, fDamage, fStartRadius, fEndRadius, fDistance, sHitEffect, Number)
	local target = hAttacker:IsRangedAttacker() and hTarget or hAttacker
	local direction = GetDirection2D(hTarget:GetAbsOrigin(), hAttacker:GetAbsOrigin())
	local enemy = FindUnitsInTrapezoid(hAttacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local pfx = nil
	if sHitEffect then
		pfx = ParticleManager:CreateParticle(sHitEffect, PATTACH_CUSTOMORIGIN, hAttacker)
		ParticleManager:SetParticleControl(pfx, 0, hAttacker:IsRangedAttacker() and hTarget:GetAbsOrigin() or hAttacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (hTarget:GetAbsOrigin() - hAttacker:GetAbsOrigin()):Normalized())
	end
	for i=1, #enemy do
		if enemy[i] ~= hTarget then
			
			AttackCleaveDelay(hAttacker, enemy[i], hAbility, fDamage)
			if pfx then
				ParticleManager:SetParticleControlEnt(pfx, i + 16, enemy[i], PATTACH_POINT, "attach_hitloc", enemy[i]:GetAbsOrigin(), true)
			end
			if Number then
				if i > Number then
					break
				end
			end
		end
	end
	if pfx then
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

--轰拳伤害（包括目标，纯粹,起点是目标）
function DoIMBACleaveDamage(hAttacker, hTarget, hAbility, fDamage, fStartRadius, fEndRadius, fDistance, sHitEffect)
	local target = hAttacker:IsRangedAttacker() and hTarget or hAttacker
	local direction = GetDirection2D(hTarget:GetAbsOrigin(), hAttacker:GetAbsOrigin())
	local enemy = FindUnitsInTrapezoid(hAttacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local pfx = nil
	if sHitEffect then
		pfx = ParticleManager:CreateParticle(sHitEffect, PATTACH_CUSTOMORIGIN, hAttacker)
		ParticleManager:SetParticleControl(pfx, 0, hAttacker:IsRangedAttacker() and hTarget:GetAbsOrigin() or hAttacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (hTarget:GetAbsOrigin() - hAttacker:GetAbsOrigin()):Normalized())
	end
	for i=1, #enemy do
		--if enemy[i] ~= hTarget then
			ApplyDamage({attacker = hAttacker, victim = enemy[i], ability = hAbility, damage = fDamage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL })
			if pfx then
				ParticleManager:SetParticleControlEnt(pfx, i + 16, enemy[i], PATTACH_POINT, "attach_hitloc", enemy[i]:GetAbsOrigin(), true)
			end
		--end
	end
	if pfx then
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

--分裂攻击（真攻击）
function DoTrueCleaveAttack(hAttacker, hTarget, hAbility, fStartRadius, fEndRadius, fDistance, sHitEffect)
    -- print("hTarget=2=",hTarget)
	local target = hAttacker:IsRangedAttacker() and hTarget or hAttacker
	local direction = GetDirection2D(hTarget:GetAbsOrigin(), hAttacker:GetAbsOrigin())
	local enemy = FindUnitsInTrapezoid(hAttacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local pfx = nil
	if sHitEffect then
		pfx = ParticleManager:CreateParticle(sHitEffect, PATTACH_CUSTOMORIGIN, hAttacker)
		ParticleManager:SetParticleControl(pfx, 0, hAttacker:IsRangedAttacker() and hTarget:GetAbsOrigin() or hAttacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (hTarget:GetAbsOrigin() - hAttacker:GetAbsOrigin()):Normalized())
	end
	for i=1, #enemy do
		if enemy[i] ~= hTarget then
			hAttacker:PerformAttack( enemy[i], true, true, true, true, false, false, true )
			if pfx then
				ParticleManager:SetParticleControlEnt(pfx, i + 16, enemy[i], PATTACH_POINT, "attach_hitloc", enemy[i]:GetAbsOrigin(), true)
			end
		end
	end
	if pfx then
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
--分裂函数（延迟结算）
function AttackCleaveDelay(hAttacker, hTarget, hAbility, hDamage)
	if not IsServer() then return end

	if hAttacker and (hTarget and hTarget:IsAlive() ) and (hDamage and hDamage > 0) then
		local modifier = hTarget:AddNewModifier(hAttacker, hAbility, "modifier_hd_cleave_damage", {damage = hDamage})
		if modifier then
			modifier:RefreshEnt(hAttacker, hAbility)
		end
	end
end

function FindUnitsInTrapezoid(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local circle_r = math.sqrt(math.pow(endRadius / 2, 2) + math.pow(flLength, 2))
	local enemy = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, circle_r, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local ta = {}
	local vStartPoint = {RotatePosition(vPosition, QAngle(0,90,0), vPosition + vDirection * (startRadius / 2)), RotatePosition(vPosition, QAngle(0,-90,0), vPosition + vDirection * (startRadius / 2))}
	local vEndPoint = {RotatePosition(vPosition + vDirection * flLength, QAngle(0,90,0), (vPosition + vDirection * flLength) + vDirection * (endRadius / 2)), RotatePosition(vPosition + vDirection * flLength, QAngle(0,-90,0), (vPosition + vDirection * flLength) + vDirection * (endRadius / 2))}
	local A = vStartPoint[1]
	local B = vEndPoint[1]
	local C = vEndPoint[2]
	local D = vStartPoint[2]
	if GameRules:IsCheatMode() then  --测试模式
		DebugDrawLine(A, B, 255, 0, 0, true, 5)
		DebugDrawLine(B, C, 255, 0, 0, true, 5)
		DebugDrawLine(C, D, 255, 0, 0, true, 5)
		DebugDrawLine(D, A, 255, 0, 0, true, 5)
	end
	for i=1, #enemy do
		local pos = enemy[i]:GetAbsOrigin()
		local a = (B.x - A.x) * (pos.y - A.y) - (B.y - A.y) * (pos.x - A.x)
		local b = (C.x - B.x) * (pos.y - B.y) - (C.y - B.y) * (pos.x - B.x)
		local c = (D.x - C.x) * (pos.y - C.y) - (D.y - C.y) * (pos.x - C.x)
		local d = (A.x - D.x) * (pos.y - D.y) - (A.y - D.y) * (pos.x - D.x)
		if (a >= 0 and b >= 0 and c >= 0 and d >= 0) or (a <= 0 and b <= 0 and c <= 0 and d <= 0) then
			table.insert(ta, enemy[i])
		end
	end
	return ta
end

function GetDirection2D(vEndPoint, vStartPoint)
	vEndPoint.z = 0
	vStartPoint.z = 0
	local direction = (vEndPoint - vStartPoint):Normalized()
	direction.z = 0
	return direction
end




--[[
★坐标转换。
--]]
function ToVector(string)
	local temp = {}
	for str in string.gmatch(string, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end





--传入数值 施法者 目标 治疗目标 技能 标签 如果有传入因数 将以比例计算gain值  基础治疗增强与基础受到治疗增强

function HealWithGain(heal,caster,target,ability,flag,fhealIndex,fheallReceiveGainIndex,baseHealGain,baseHealReceiveGain)
	local gainIdex = fhealIndex or 1
	local healreceiveIdex = fheallReceiveGainIndex or 1
	local baseHGain = baseHealGain or 0
	local baseHRGain = baseHealReceiveGain or 0
	-- if fhealIndex then gainIdex = fhealIndex	end
	-- if fheallReceiveGainIndex then healreceiveIdex = fheallReceiveGainIndex	end
	
	local keys = {
		unit = caster,    --治疗发出者
		target = target,  --治疗接收者
		inflictor = ability,  --治疗的技能
		heal = heal,      --治疗量
		heal_flags = flag,  --标签
		fhealIndex = fhealIndex,
		fheallReceiveGainIndex = fheallReceiveGainIndex,
		-- pre_health = health_pre,
		-- effective_heal = target:GetHealth()-health_pre,
	}
	local caster_healAMP = GetHealAMP_Percentage(caster, keys)
	local heal_receiveAMP = GetHealReceiveAMP_Percentage(caster, keys)
	-- print("caster_healAMP=",caster_healAMP)
	-- print("heal_receiveAMP=",heal_receiveAMP)

	local gain = (100+(caster_healAMP+baseHGain)*gainIdex)*0.01*(100+(heal_receiveAMP+baseHRGain)*healreceiveIdex)*0.01

	local healing = heal *gain
	local health_pre = target:GetHealth()
	if target:IsCustomWard() then
		healing = math.min(2,healing)
	end
	target:Heal(healing, ability)

	local flag = flag or 0
	local table = {
		unit = caster,    --治疗发出者
		target = target,  --治疗接收者
		inflictor = ability,  --治疗的技能
		heal = healing,      --治疗量
		heal_flags = flag,  --标签
		pre_health = health_pre,
		effective_heal = target:GetHealth()-health_pre,
	}

	if bit.band( flag, DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEAL ) ~= DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEAL then 
		local tModifiers = caster:FindAllModifiers()
		for _, hModifier in pairs(tModifiers) do
			--print(hModifier:GetName())
			if hModifier.OnCustomModifierFunction_Heal ~= nil then
				hModifier:OnCustomModifierFunction_Heal(table) --触发发出治疗
			end
		end
	end
	-- if bit.band( flag, DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEALRECEIVE ) ~= DOTA_CUSTOM_HEAL_FLAG_NO_FUNCTION_HEALRECEIVE then 
	-- 	local tModifiers = target:FindAllModifiers()
	-- 	for _, hModifier in pairs(tModifiers) do
	-- 		--print(hModifier:GetName())
	-- 		if hModifier.OnCustomModifierFunction_HealReceive ~= nil then
	-- 			hModifier:OnCustomModifierFunction_HealReceive(table) --触发受到治疗
	-- 		end
	-- 	end
	-- end
	FireHealEvent(table)
	return healing
end

function GiveMana(keys)
	-- keys.target
	-- keys.caster
	keys.target:GiveMana(keys.value)
	return keys.value
end

--召唤单位
--单位名(必须)  
--持续时间(不填永久)
--技能（可为空） 
--flag 
--生命值魔法值 攻击力 护甲（必须） 
--summon_intensity_gain继承系数(不填为1)
--time_index继承系数(不填为1)
function CDOTA_BaseNPC:SummonUnit(unit_name,duration,pos,ForwardVector,ability,flag,health,mana,damage,armor,intensity_gain_index,time_index)
	local unit = CreateUnitByName(unit_name, self:GetAbsOrigin(), true, self, self, self:GetTeamNumber())
	if unit.GetPlayerOwnerID then
		unit:SetControllableByPlayer(self:GetPlayerOwnerID(), false)
	end

	local MulTime = time_index or 1
	local MulIntensity = intensity_gain_index or 1
	if pos then
		FindClearSpaceForUnit( unit, pos, true )
	end
	if ForwardVector then
		unit:SetForwardVector(ForwardVector)
	else
		unit:SetForwardVector(self:GetForwardVector())
	end



	--触发召唤事件 此时还没添加好属性
	local flag = flag or 0
	local tModifiers = self:FindAllModifiers()
	local table = {
		unit = self,    --召唤者
		target = unit,  --召唤物
		inflictor = ability,  --使用的技能

	}

	if bit.band( flag, DOTA_CUSTOM_SUMMON_FLAG_NO_FUNCTION_CALLED ) ~= DOTA_CUSTOM_SUMMON_FLAG_NO_FUNCTION_CALLED and
		bit.band( flag, DOTA_CUSTOM_SUMMON_FLAG_NO_CALL_SUMMON ) ~= DOTA_CUSTOM_SUMMON_FLAG_NO_CALL_SUMMON
	then 
		for _, hModifier in pairs(tModifiers) do
			--print(hModifier:GetName())
			if hModifier.OnSummonUnit ~= nil then
				hModifier:OnSummonUnit(table) --触发召唤单位
			end
		end
		FireSummonEvent(table)
	end








	local life_time = -1
	if duration then

		life_time = duration * self:GetSummonTimeAmpIndex(MulTime)
		unit:AddNewModifier(self, ability or nil, "modifier_kill", {duration = life_time}) --召唤持续时间
	end
	local summon_intensity_gain = self:GetSummonIntensityIndex(MulIntensity,unit)
	--设置属性
	-- 召唤兽最大属性设置
	health = health*summon_intensity_gain
	
	damage = damage*summon_intensity_gain

	armor = armor *summon_intensity_gain

	SetCreatureHealth(unit, health, true)
	if mana then
		mana = mana*summon_intensity_gain
		SetCreatureMana(unit, mana, true)
	end
	
	unit:SetBaseDamageMax(damage)
	unit:SetBaseDamageMin(damage)
	unit:SetPhysicalArmorBaseValue(armor)


    unit.hdIsSummoned = true



	--触发召唤完成事件 此时属性添加完成

	local table = {
		unit = self,    --召唤者
		target = unit,  --召唤物
		inflictor = ability,  --使用的技能
		duration = life_time,

	}

	if bit.band( flag, DOTA_CUSTOM_SUMMON_FLAG_NO_FUNCTION_CALLED ) ~= DOTA_CUSTOM_SUMMON_FLAG_NO_FUNCTION_CALLED and
		bit.band( flag, DOTA_CUSTOM_SUMMON_FLAG_NO_CALL_SUMMON_FINISHED ) ~= DOTA_CUSTOM_SUMMON_FLAG_NO_CALL_SUMMON_FINISHED
	then 
		
		for _, hModifier in pairs(tModifiers) do
			--print(hModifier:GetName())
			if hModifier.OnSummonUnitFinished ~= nil then
				hModifier:OnSummonUnitFinished(table) --触发召唤单位完成
			end
		end
	end

	local event_data = {
		unit = self:entindex(),    --召唤者
		target = unit:entindex(),  --召唤物
		duration = life_time,
	}
    if ability then
        event_data.inflictor = ability:entindex()  --使用的技能
    end

	FireGameEvent( "dota_on_summon", event_data )


	return unit
	

end


function CDOTA_BaseNPC:GetSpecialSummonedList(type)
	local unitTable = {}
	if not self.unitTable then
		self.unitTable = {}
	end
	if not self.unitTable[type] then

		self.unitTable[type] = {}
	end
	for _, unit in ipairs(self.unitTable[type]) do
		if not unit:IsNull() and unit:IsAlive() then
			table.insert(unitTable,unit)
		end
	end
	self.unitTable[type] = unitTable

	return unitTable
end


function CDOTA_BaseNPC:InsertSpecialSummonedList(type,unit)
	if not self.unitTable then
		self.unitTable = {}
	end
	if not self.unitTable[type] then
		self.unitTable[type] = {}
	end
	table.insert(self.unitTable[type],unit)
end

function CDOTA_BaseNPC:SetSpecialSummoned(enable)
	self.specialUnit = enable
end
function CDOTA_BaseNPC:IsSpecialSummoned()
	return self.specialUnit and true or false
end

function CDOTA_BaseNPC:IsHDSummoned()
	return self.hdIsSummoned and true or false
end
function CDOTA_BaseNPC:ModifySummonedDuration(duration)
	if self:IsHDSummoned() then
		local modifier = self:FindModifierByName("modifier_kill")
		if modifier then
			modifier:SetDuration(duration, true)
		else
			self:AddNewModifier(self, nil, "modifier_kill", {duration = duration})
		end
	end
end



function table.shallowCopy(tb)
    local copy = {}
    for k, v in pairs(tb) do
        copy[k] = v
    end
    return copy
end
-- Lua table deep copy
function table.deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then		--非table直接返回
            return object
        elseif lookup_table[object] then	--找过的就不用再找了
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)	--递归遍历table的元素
        end
        return setmetatable(new_table, getmetatable(object))	--拷贝目标的元表的数据
    end
    return _copy(object)
end




--为目标添加修饰器
--可以传入受到的状态抗性以及负面状态增强影响 默认皆为1
function CDOTA_BaseNPC:HDAddNewBadModifier(caster,ability,modifierName,modifierTable,flag,NegativeGain_index,resistance_index)

	if not self or self:IsNull() then
		print("error:目标不存在")
		return nil
	end
	if not caster or caster:IsNull() then
		print("error:没有施法者不能调用这个API")
		return nil
	end
	local MulNegativeGain = NegativeGain_index or 1
	local Mulresistance = resistance_index or 1
	local modifierFlag = flag or 0
	local modifiertable = modifierTable or {}

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = self:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

	if modifiertable and modifiertable.duration then
		modifiertable.duration = modifiertable.duration *StatusResistance
	end

	local modifier = self:AddNewModifier(caster,ability,modifierName,modifiertable)
	


	return modifier
	

end




--寻找范围内最强壮的敌人
function FindStrongestEnemyInRangeAndPosition( entity,pos, range,flag )
	local target_flag = flag
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(),pos, entity, range,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, target_flag, 0, false )

	local maxHp = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		-- local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (maxHp == nil or HP > maxHp) then
			maxHp = HP
			target = enemy

		end
	end

	return target
end



function FinDWeakestEnemyInRange( entity, range,flag )
	local target_flag = flag
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, target_flag, 0, false )

	local minHP = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
			minHP = HP
			target = enemy

		end
	end

	return target
end

function FinDWeakestEnemyHeroInRange( entity, range,flag )
	local target_flag = flag
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO, target_flag, 0, false )

	local minHP = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
			minHP = HP
			target = enemy

		end
	end

	return target
end
--寻找当前生命值最低的友军
function FinDWeakestAllyInRange( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,unit in pairs(enemies) do
		local distanceTounit = (entity:GetOrigin() - unit:GetOrigin()):Length()
		local HP = unit:GetHealth()
		if unit~=entity and  unit:IsAlive() and (minHP == nil or HP < minHP) and distanceTounit < range then
			minHP = HP
			target = unit
		end
	end

	return target
end

--寻找当前生命值百分比最低的其他友军 都为满时返回nil
function FinDLowestHealthPerAllyInRange( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,unit in pairs(enemies) do
		local distanceTounit = (entity:GetOrigin() - unit:GetOrigin()):Length()
		local HP = unit:GetHealthPercent()
		if unit~=entity and  unit:IsAlive() and (minHP == nil or HP < minHP) and distanceTounit < range then
			minHP = HP
			target = unit
		end
	end
	if minHP==100 then
		return nil
	end

	return target
end
--寻找当前生命值百分比最低的其他友军英雄 都为满时返回nil
function FinDLowestHealthPerAllyHeroInRange( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,unit in pairs(enemies) do
		local distanceTounit = (entity:GetOrigin() - unit:GetOrigin()):Length()
		local HP = unit:GetHealthPercent()
		if unit~=entity and  unit:IsAlive() and (minHP == nil or HP < minHP) and distanceTounit < range then
			minHP = HP
			target = unit
		end
	end
	if minHP==100 then
		return nil
	end

	return target
end


--寻找当前生命值百分比最低的友军 都为满时返回nil
--可以为自身
function FinDLowestHealthPerAllyInRange_includeself( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,unit in pairs(enemies) do
		local distanceTounit = (entity:GetOrigin() - unit:GetOrigin()):Length()
		local HP = unit:GetHealthPercent()
		if unit:IsAlive() and (minHP == nil or HP < minHP) and distanceTounit < range then
			minHP = HP
			target = unit
		end
	end
	if minHP==100 then
		return nil
	end

	return target
end

--寻找当前生命值百分比最低的友军英雄 都为满时返回nil
--可以为自身
function FinDLowestHealthPerHeroInRange_includeself( entity, range )
	local enemies = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

	local minHP = nil
	local target = nil

	for _,unit in pairs(enemies) do
		local distanceTounit = (entity:GetOrigin() - unit:GetOrigin()):Length()
		local HP = unit:GetHealthPercent()
		if unit:IsAlive() and (minHP == nil or HP < minHP) and distanceTounit < range then
			minHP = HP
			target = unit
		end
	end
	if minHP==100 then
		return nil
	end

	return target
end


--分割字符串
function Split(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
    	local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
   		if not nFindLastIndex then  
     	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
     	break  
    end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
    	nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray   
end



--比较时间 格式需要为 2021-08-30  20:55:33
--如果传入的第一个时间在第二个时间的未来 返回true
function Comparison_time(time1,time2)

            --设置服务器时间
    local list= Split(time1, " ")
    local day_list =  Split(list[1], "-")
    local sec_list =  Split(list[2], ":")
    local time1_list = {
        year = 0,
        mon = 0,
        day = 0,
        hour = 0,
        min = 0,
        sec = 0,
    }
	local time2_list = {
        year = 0,
        mon = 0,
        day = 0,
        hour = 0,
        min = 0,
        sec = 0,
    }

    time1_list.year = day_list[1]
    time1_list.mon = day_list[2]
    time1_list.day = day_list[3]
    time1_list.hour = sec_list[1]
    time1_list.min = sec_list[2]
    time1_list.sec = sec_list[3]

	local list= Split(time2, " ")
    local day_list =  Split(list[1], "-")
    local sec_list =  Split(list[2], ":")

	time2_list.year = day_list[1]
    time2_list.mon = day_list[2]
    time2_list.day = day_list[3]
    time2_list.hour = sec_list[1]
    time2_list.min = sec_list[2]
    time2_list.sec = sec_list[3]
	--
	-- PrintTable(time1_list)
	-- PrintTable(time2_list)
	--比较年份
	if time1_list.year>time2_list.year then
		return true
	else
		if time1_list.year==time2_list.year then
			--年份相等
			--比较月份
			if time1_list.mon>time2_list.mon then
				return true
	
			else
				if time1_list.mon==time2_list.mon then
					--月份相等 比较日
					if time1_list.day>time2_list.day then
						return true
					else
						if time1_list.day==time2_list.day then
							--比较时
							if time1_list.hour>time2_list.hour then
								return true
							else
								if time1_list.hour==time2_list.hour then
									--比较分
									if time1_list.min>time2_list.min then
										return true
									else
										if time1_list.min==time2_list.min then
											return true
									    else
											return false
										end
									end

								else
									--时小于
									return false
								end
							end

						else
							return false
						end
					end
				
				else
					--月份小于
					return false
				end

			end
			
		else
			--年份小于
			return false
		end

	end
	
end









--DPS用
function player_data_set_value(playerID, key, value)
    local data = GameRules.GLOBAL_PLAYER_DATA[playerID]
    if not data then
        GameRules.GLOBAL_PLAYER_DATA[playerID] = {}
        data = GameRules.GLOBAL_PLAYER_DATA[playerID]
    end
    if not data.values then 
        data.values = {} 
    end
	data.values[key] = value
end

--DPS用
function player_data_get_value(playerID, key)
    local data = GameRules.GLOBAL_PLAYER_DATA[playerID]
    if data then
        local values = data.values
        if values then
            local value = values[key]
            if value then
                return value
            end
        end
    end
	return 0
end

--DPS用
function player_data_modify_value(playerID, key, value)
	local new_value = player_data_get_value(playerID, key) + value
	player_data_set_value(playerID, key, new_value)
	return new_value
end
--DPS用
function formated_number(number)
    local as_string = tostring(math.floor(number))
    if number < 1000 then
        return as_string
    end

    if number<1000000 then
        local len = as_string:len()
        local split_point = len - 3
    
        return as_string:sub(1, split_point) .. "." .. as_string:sub(split_point + 1, len - 2) .. "K"

    end
    if number<1000000000 then
        local len = as_string:len()
        local split_point = len - 6

        return as_string:sub(1, split_point) .. "." .. as_string:sub(split_point + 1, len - 5) .. "M"
    end
    local len = as_string:len()
    local split_point = len - 9

    return as_string:sub(1, split_point) .. "." .. as_string:sub(split_point + 1, len - 8) .. "G"
end


--寻找除了目标外的其他最富有的英雄
function FindOtherRichestHero(hHero)
	local heroes = GetAllRealHeroes()
	local currentHero;
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() and hero~=hHero then
            
			if not currentHero then
				currentHero = hero
			else
				if currentHero:GetGold()<hero:GetGold() then
					currentHero = hero
				end
			end
        end
    end
	return currentHero
end





-- 获取数组里随机一个值
function GetRandomElement(table)
	return table[RandomInt(1, #table)]
end


-- 以逆时针方向旋转
function Rotation2D(vVector, radian)
	local fLength2D = vVector:Length2D()
	local vUnitVector2D = vVector / fLength2D
	local fCos = math.cos(radian)
	local fSin = math.sin(radian)
	return Vector(vUnitVector2D.x * fCos - vUnitVector2D.y * fSin, vUnitVector2D.x * fSin + vUnitVector2D.y * fCos, vUnitVector2D.z) * fLength2D
end







function randomTable(_table, _num) 
    local _result = {}
    local _index = 1
    local _num = _num or #_table
    while #_table ~= 0 do
        local ran = math.random(0, #_table)
        if _table[ran] ~= nil then
            _result[_index] = _table[ran]
            table.remove(_table,ran)
            _index = _index + 1
            if _index > _num then 
                break
            end 
        end
    end
    return _result
end

LinkLuaModifier("modifier_emitsound_thinker", "modifier/modifier_emitsound_thinker", LUA_MODIFIER_MOTION_NONE)
function HdEmitSoundOnLocation(caster,location,sound,duration)
	
	local thinker =CreateModifierThinker(caster,nil,"modifier_emitsound_thinker",{duration = duration},location,caster:GetTeamNumber(),false)
	
	if thinker then
		local modifier = thinker:FindModifierByName("modifier_emitsound_thinker")
		if modifier then
			modifier:ModifierEmitSound(sound)
		else
			print("error no modifier")
		end
		
	
	else
		print("error no thinker")
	end
	return false
end



function IsLastWaveOrBonusWave()
	if _G.GAME_ROUND==9 or _G.GAME_ROUND==19 or _G.GAME_ROUND>=_G.GAME_END_WAVE then
        return true
    end
	return false
end


function SendCustomErrorToPlayer(playerid,message,sound)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "SendCustomErroMessage", {message = message ,sound=sound})
end


function EmitClientSound(playerid,sound)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "PlayClientSound", {sound=sound})
end




function CDOTA_BaseNPC:IncreaseBaseDamageByModifier(count)
	self:AddNewModifier( self, nil, "modifier_base_attack_damage_bonus", {stack=count} )
end




function CDOTA_BaseNPC:CreateDouble(vPos,vForward)
	local caster = self
	local pos = vPos or caster:GetOrigin()
	local forward = vForward or caster:GetForwardVector()
	local unit  = CreateUnitByName("npc_hd_double", pos, true, caster, caster, caster:GetTeamNumber())
	unit:SetForwardVector(forward)
	unit:SetOriginalModel(caster.origin_model_name)
	unit:SetModelScale(caster:GetModelScale())
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = unit:GetAbsOrigin() })
			hWearable:FollowEntity(unit, true)
		end
		hModel = hModel:NextMovePeer()
	end

    return unit
end







function AddModifierToAllHero(caster,ability,modifierName,modifierTable)


    local heroes = GetAllRealHeroes()
    for _, unit in pairs(heroes) do
        if unit:IsAlive() then
			print("添加")
            unit:AddNewModifier(caster, ability, modifierName, modifierTable)
        else
            print("英雄死亡 延后添加")
            Timers:CreateTimer(0.5, function()
                if unit:IsAlive() then
                    print("添加成功")
                    unit:AddNewModifier(caster, ability, modifierName, modifierTable)
                else
                    return 1
                end	
			end)
        end

    end
end



function fSendCustomOverheadEventMessage(szMessageType, targetEntity, iValue, fDuration, vOffset, vColor, iPos)
    local szPath = "particles/msg_fx/msg_" .. szMessageType .. ".vpcf"

    local hParticle = ParticleManager:CreateParticle(szPath, PATTACH_OVERHEAD_FOLLOW, targetEntity)

	vOffset = vOffset or Vector(0,0,0)
	vColor = vColor or Vector(0,0,0)
	iPos = iPos or nil
	fDuration = fDuration or 1.0
    local index = tostring(math.floor(iValue))
	local iLength = string.len(index) + 1
	if iPos == nil then iLength = iLength - 1 end
	--print(iLength)
	ParticleManager:SetParticleControl(hParticle, 0, vOffset)
    ParticleManager:SetParticleControl(hParticle, 1, Vector(nil, iValue, iPos))
    ParticleManager:SetParticleControl(hParticle, 2, Vector(fDuration, iLength, 0))
    ParticleManager:SetParticleControl(hParticle, 3, vColor)
end


function fHDSendCustomOverheadEventMessage(szMessageType, targetEntity, iValue, fDuration, vOffset, vColor, iPos)
    local szPath = "particles/msg_fx/".. szMessageType .. ".vpcf"

    local hParticle = ParticleManager:CreateParticle(szPath, PATTACH_OVERHEAD_FOLLOW, targetEntity)

	vOffset = vOffset or Vector(0,0,0)
	vColor = vColor or Vector(0,0,0)
	iPos = iPos or nil
	fDuration = fDuration or 1.0
    local index = tostring(math.floor(iValue))
	local iLength = string.len(index) + 1
	if iPos == nil then iLength = iLength - 1 end
	--print(iLength)
	ParticleManager:SetParticleControl(hParticle, 0, vOffset)
    ParticleManager:SetParticleControl(hParticle, 1, Vector(nil, iValue, iPos))
    ParticleManager:SetParticleControl(hParticle, 2, Vector(fDuration, iLength, 0))
    ParticleManager:SetParticleControl(hParticle, 3, vColor)
end
function fHDSendCustomOverheadEventMessageForPlayer(player,szMessageType, targetEntity, iValue, fDuration, vOffset, vColor, iPos)
    local szPath = "particles/msg_fx/".. szMessageType .. ".vpcf"
	local hParticle = ParticleManager:CreateParticleForPlayer( szPath, PATTACH_OVERHEAD_FOLLOW, targetEntity, player )


	vOffset = vOffset or Vector(0,0,0)
	vColor = vColor or Vector(0,0,0)
	iPos = iPos or 0
	fDuration = fDuration or 1.0
    local index = tostring(math.floor(iValue))
	local iLength = string.len(index) + 1
	if iPos == 0 then iLength = iLength - 1 end
	--print(iLength)
	ParticleManager:SetParticleControl(hParticle, 0, vOffset)
    ParticleManager:SetParticleControl(hParticle, 1, Vector(nil, iValue, iPos))
    ParticleManager:SetParticleControl(hParticle, 2, Vector(fDuration, iLength, 0))
    ParticleManager:SetParticleControl(hParticle, 3, vColor)
end




function CDOTA_BaseNPC:HDHasAttachMent(attach)
	if self:ScriptLookupAttachment( attach )~=0  then
        return true
    end
    return false
end

-- Hero_MeleeAtttach1={
--     npc_dota_hero_sven = "attach_sword",
--     npc_dota_hero_juggernaut = "attach_sword",
--     npc_dota_hero_monkey_king = "attach_weapon_bot",
-- }
-- Hero_MeleeAtttach2={
--     npc_dota_hero_sven = "attach_sword_end",
--     npc_dota_hero_juggernaut = "blade_attachment",
--     npc_dota_hero_monkey_king = "attach_weapon_top",
-- }
Hero_MeleeAtttach1={
    -- models_heroes_sven_sven_vmdl = "attach_sword",
    -- models_heroes_juggernaut_juggernaut_vmdl = "attach_sword",
    -- models_heroes_juggernaut_juggernaut_arcana_vmdl = "attach_sword",
    -- models_heroes_monkey_king_monkey_king_vmdl = "attach_weapon_bot",
    -- models_heroes_faceless_void_faceless_void_vmdl = "attach_attack1",
    -- models_items_faceless_void_faceless_void_arcana_faceless_void_arcana_base_vmdl = "attach_attack1",
    -- models_heroes_void_spirit_void_spirit_vmdl = "attach_weapon_bot",
    -- models_heroes_axe_axe_vmdl = "attach_weapon",
    -- models_heroes_centaur_centaur_vmdl = "attach_weapon_base",
    -- models_heroes_tuskarr_tuskarr_prop_vmdl = "attach_weapon",
    -- models_heroes_kunkka_kunkka_vmdl = "attach_sword",
    -- models_heroes_mars_mars_vmdl = "attach_weapon",
    -- models_heroes_dawnbreaker_dawnbreaker_vmdl = "attach_weapon_core_fx",
    -- models_items_lycan_ultimate_blood_moon_hunter_shapeshift_form_blood_moon_hunter_shapeshift_form_vmdl = "attach_mouth",
}
Hero_MeleeAtttach2={
    -- models_heroes_sven_sven_vmdl = "attach_sword_end",
    -- models_heroes_juggernaut_juggernaut_vmdl = "blade_attachment",
    -- models_heroes_juggernaut_juggernaut_arcana_vmdl = "blade_attachment",
    -- models_heroes_monkey_king_monkey_king_vmdl = "attach_weapon_top",
    -- models_heroes_faceless_void_faceless_void_vmdl = "attach_weapon_glow",
    -- models_items_faceless_void_faceless_void_arcana_faceless_void_arcana_base_vmdl = "attach_weapon_glow",
    -- models_heroes_void_spirit_void_spirit_vmdl = "attach_weapon_top",
    -- models_heroes_axe_axe_vmdl = "attach_axe_head",
    -- models_heroes_shredder_shredder_vmdl = "attach_saw",
    -- models_heroes_centaur_centaur_vmdl = "attach_weapon",
    -- models_heroes_rattletrap_rattletrap_vmdl = "attach_weapon",
    -- models_heroes_tuskarr_tuskarr_prop_vmdl = "attach_axe",
    -- models_heroes_kunkka_kunkka_vmdl = "attach_tidebringer_2",
    -- models_heroes_chaos_knight_chaos_knight_vmdl= "attach_weapon",
    -- models_heroes_doom_doom_vmdl= "attach_weapon_blur",
    -- models_heroes_tidehunter_tidehunter_vmdl ="attach_impact",
    -- models_heroes_mars_mars_vmdl = "attach_shield",
    -- models_heroes_phantom_lancer_phantom_lancer_vmdl = "attach_weapon",
    -- models_items_warlock_golem_warlock_the_infernal_master_golem_warlock_the_infernal_master_golem_vmdl = "attach_hand_left_fx",
    
}
InitModelFinished = false
function InitModel()
    Hero_MeleeAtttach1["models/heroes/sven/sven.vmdl"] =  "attach_sword"
    Hero_MeleeAtttach1["models/heroes/juggernaut/juggernaut.vmdl"] =  "attach_sword"
    Hero_MeleeAtttach1["models/heroes/juggernaut/juggernaut_arcana.vmdl"] =  "attach_sword"
    Hero_MeleeAtttach1["models/heroes/monkey_king/monkey_king.vmdl"] =  "attach_weapon_bot"
    Hero_MeleeAtttach1["models/heroes/void_spirit/void_spirit.vmdl"] =  "attach_weapon_bot"
    Hero_MeleeAtttach1["models/heroes/axe/axe.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach1["models/heroes/shredder/shredder.vmdl"] =  "attach_saw"
    Hero_MeleeAtttach1["models/heroes/centaur/centaur.vmdl"] =  "attach_weapon_base"
    Hero_MeleeAtttach1["models/heroes/rattletrap/rattletrap.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach1["models/heroes/tuskarr/tuskarr.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach1["models/heroes/kunkka/kunkka.vmdl"] =  "attach_sword"
    Hero_MeleeAtttach1["models/heroes/mars/mars.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach1["models/heroes/dawnbreaker/dawnbreaker.vmdl"] =  "attach_weapon_core_fx"
    Hero_MeleeAtttach1["models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"] =  "attach_mouth"



    Hero_MeleeAtttach2["models/heroes/sven/sven.vmdl"] =  "attach_sword_end"
    Hero_MeleeAtttach2["models/heroes/juggernaut/juggernaut.vmdl"] =  "blade_attachment"
    Hero_MeleeAtttach2["models/heroes/juggernaut/juggernaut_arcana.vmdl"] =  "blade_attachment"
    Hero_MeleeAtttach2["models/heroes/monkey_king/monkey_king.vmdl"] =  "attach_weapon_top"
    Hero_MeleeAtttach2["models/heroes/faceless_void/faceless_void.vmdl"] =  "attach_weapon_glow"
    Hero_MeleeAtttach2["models/items/faceless_void/faceless_void_arcana/faceless_void_arcana_base.vmdl"] =  "attach_weapon_glow"
    Hero_MeleeAtttach2["models/heroes/void_spirit/void_spirit.vmdl"] =  "attach_weapon_top"
    Hero_MeleeAtttach2["models/heroes/axe/axe.vmdl"] =  "attach_axe_head"
    Hero_MeleeAtttach2["models/heroes/shredder/shredder.vmdl"] =  "attach_saw"
    Hero_MeleeAtttach2["models/heroes/centaur/centaur.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach2["models/heroes/rattletrap/rattletrap.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach2["models/heroes/tuskarr/tuskarr.vmdl"] =  "attach_axe"
    Hero_MeleeAtttach2["models/heroes/kunkka/kunkka.vmdl"] =  "attach_tidebringer_2"
    Hero_MeleeAtttach2["models/heroes/chaos/knight/chaos_knight.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach2["models/heroes/doom/doom.vmdl"] =  "attach_weapon_blur"
    Hero_MeleeAtttach2["models/heroes/tidehunter/tidehunter.vmdl"] =  "attach_impact"
    Hero_MeleeAtttach2["models/heroes/mars/mars.vmdl"] =  "attach_shield"
    Hero_MeleeAtttach2["models/heroes/phantom/lancer/phantom_lancer.vmdl"] =  "attach_weapon"
    Hero_MeleeAtttach2["models/items/warlock/golem/warlock_the_infernal_master_golem/warlock_the_infernal_master_golem.vmdl"] =  "attach_hand_left_fx"
    InitModelFinished = true
end

InitModel()
function ModelPathChange(str)
    str = string.gsub(str, "/", "_") 
    str = string.gsub(str, ".", "_") 
    return str
end
function CDOTA_BaseNPC:HDGetMeleeAttachMent(close)
    -- if not InitModelFinished then
    --     InitModel()
    -- end
    local modelName = self:GetModelName()
    -- print(modelName)
    -- modelName = ModelPathChange(modelName)
    -- print(modelName)
    if close then

        if Hero_MeleeAtttach1[modelName] then
            return Hero_MeleeAtttach1[modelName]
        else
            return "attach_attack1"
        end
    else
        -- local modelName = self:GetModelName()
        -- modelName = ModelPathChange(modelName)
        if Hero_MeleeAtttach2[modelName] then
            return Hero_MeleeAtttach2[modelName]
        else
            return "attach_attack2"
        end
    end
	
end





function CDOTA_BaseNPC:FindDebuffCount()
    local modifiers = self:FindAllModifiers()
    local count = 0
    for _, modifier in ipairs(modifiers) do
        if  modifier.IsDebuff and modifier:IsDebuff() then
            count = count+ 1
        end
        
    end
    return count
end



function CDOTA_BaseNPC:ModifyGoldGainPercentage(value)
    if not self.bonus_GoldPercentage then
        self.bonus_GoldPercentage = 0
    end
    self.bonus_GoldPercentage = self.bonus_GoldPercentage + value
end
function CDOTA_BaseNPC:GetGoldGainPercentage()
    if not self.bonus_GoldPercentage then
        self.bonus_GoldPercentage = 0
    end
    return self.bonus_GoldPercentage
end




function CDOTA_BaseNPC:GetGoldInChallenge038()
	local gold = 0
	local modifiers = self:FindAllModifiersByName("modifier_ChallengeInfo_040_1")
	for _, modifier in ipairs(modifiers) do
		gold = gold + modifier:GetStackCount()
	end
	local modifiers = self:FindAllModifiersByName("modifier_ChallengeInfo_040_2")
	for _, modifier in ipairs(modifiers) do
		gold = gold + modifier:GetStackCount()
	end
	local modifiers = self:FindAllModifiersByName("modifier_ChallengeInfo_040_3")
	for _, modifier in ipairs(modifiers) do
		gold = gold + modifier:GetStackCount()
	end
	local modifiers = self:FindAllModifiersByName("modifier_ChallengeInfo_040_4")
	for _, modifier in ipairs(modifiers) do
		gold = gold + modifier:GetStackCount()
	end
	local modifiers = self:FindAllModifiersByName("modifier_ChallengeInfo_040_5")
	for _, modifier in ipairs(modifiers) do
		gold = gold + modifier:GetStackCount()
	end
	return gold
end


function GetWave()
	-- if not IsServer() then return end
	local turn = 0
		if Game_State:IsInChaoticEra() then
			turn = chaotic_era_spawner:GetCurrentWave()
			-- print("乱回合"..turn)
		else
			turn = _G.GAME_ROUND
			-- print("普通回合"..turn)
		end
	return turn
end


function IsEntityValidAndAlive(entity)
    if not entity then
        return false
    end
    if entity:IsNull() then
        return false
    end
    if not entity:IsAlive() then
        return false
    end
    return true
end



-- 除了经常变动的变量 不然不要用这两个办法！！！！！！
-- 因为玩家重连游戏后无法获取到当前的数据！！！
-- 同步全局变量
function ClientDataSYN(a,b)
    print("send event")
	local event_data = {
		data_name =a,  
		value = b,  
	}
	FireGameEvent( "hd_data_syn", event_data )
end
-- 同步技能的自定义属性
function ClientDataSYN_AbilityCustomValue(ability,a,b)
    print("send event AbilityCustomValue")
	local event_data = {
		ability = ability:entindex(),
		data_name =a,  
		value = b,  
	}
	FireGameEvent( "hd_data_syn_abilityCustomValue", event_data )
end



-- std_devIndex为方差
-- 生成一个正态分布数值
function GenerateNumber_BaseOn_NormalDistribution(min_value,max_value, std_devIndex)
    local u1 = math.random()
    local u2 = math.random()
	local average = (min_value + max_value) / 2
	local std_dev = (max_value - min_value) / (std_devIndex or 5)  --标准差  加大std_devIndex则数字更分散  更小则集中在中间
    local z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)


	local random_value = average + std_dev * z
	random_value = math.max(min_value, random_value)
    random_value = math.min(max_value, random_value)
    
    return random_value
end


-- keys ={
--  origin : 原始伤害值
--  limit  (number): 阈值上限
--  index (number, 可选): 衰减系数。默认为 30。
--   系数越高，超出部分保留的伤害越多。
-- 	}

-- 返回final_value: 处理后的最终伤害值
function SqrtPercentage(keys)
    local origin_val = tonumber(keys.origin) or 0
    local limit_val = tonumber(keys.limit) or 0
	if limit_val <= 0 then
        return origin_val
    end

    -- 系数建议值：30 ~ 100。默认为 30。超出部分的数值开根号后，会放大 30 倍加回去。
    local coef = tonumber(keys.index) or 30 

    if origin_val <= limit_val then
        return origin_val
    end

    -- 最终值 = 阈值 + (√溢出值 * 系数)
    local excess = origin_val - limit_val
    local diminished_excess = math.sqrt(excess) * coef
    local final_value = limit_val + diminished_excess

    -- 打印衰减情况
    -- print(string.format("SoftCap: Origin[%.0f] -> Limit[%.0f] + Excess[%.0f] -> Final[%.0f]", origin_val, limit_val, diminished_excess, final_value))
    return final_value
end
