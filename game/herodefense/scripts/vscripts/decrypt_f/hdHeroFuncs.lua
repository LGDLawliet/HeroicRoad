local RuneSync = require("internal/rune_sync")
-- 英雄之路专用的函数
if IsServer() then


    
    

    function CDOTA_BaseNPC:CheckBlockDisabled()

        if self:IsBlockDisabled() then
            if self:HasModifier("modifier_Advanced_dragon_blood_unlock3_passive") then
                return false
            end
            if self:HasModifier("modifier_item_hd_mythrienss_ring") then
                return false            
            end
            return true
        end
        return false
    end


    -- 寻找不在背包的装备
    function CDOTA_BaseNPC:HDFindItemByNameNotInBag(itemName)
        local item = self:FindItemInInventory(itemName) 
        if item then
            for i = 0, 5, 1 do
                local slotItem = self:GetItemInSlot(i)
                if item==slotItem then
                    return item
                end
            end
            return nil
        end
        return nil
    end


    function CDOTA_BaseNPC:HDGetDebuffDurationGain(index1,index2)
        return self:GetHDStatusResistanceIndex(index1)*self:GetModifierStatusNegativeGainIndex(index2)
    end




    


    function DestroyParticleByDelay(index,delay)
        if not index then
            return
        end
        if not delay then
            delay = 0
        end
        Timers:CreateTimer(delay, function()
            ParticleManager:DestroyParticle(index,true)
            ParticleManager:ReleaseParticleIndex(index)
        end)
    end
    function DestroyParticleByDelayButNotImmediately(index,delay)
        Timers:CreateTimer(delay, function()
            ParticleManager:DestroyParticle(index,false)
            ParticleManager:ReleaseParticleIndex(index)
        end)
    end



    function CDOTA_Item:GetItemType()
        return self.itemType or nil
    end



    -- 奖励攻击
    -- 禁用法球
    -- 禁用分裂攻击
    -- 禁用分裂箭攻击
    function CDOTA_BaseNPC:AddAttackEffectModifier(ability,keys)
        keys.duration = keys.duration or 0.1
        keys.iSpecialAttack = keys.iSpecialAttack or 0
        keys.iDisableApplyModifier = keys.iDisableApplyModifier or 0
        keys.iDisableCleave =keys.iDisableCleave or 0
        keys.iDisableSplit = keys.iDisableSplit or 1
        local modifier = self:AddNewModifier(self, ability, "modifier_attack_effect", keys 	)
        return modifier
    end





    function CDOTA_BaseNPC:IsInSpecialAttack()
        local value = GetSpecialAttack(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end
    function CDOTA_BaseNPC:IsDisableApplyModifier()
        local value = GetDisableApplyModifier(self, {})
        if value>0 then
            return true
        else
            return false

        end
    end

    function CDOTA_BaseNPC:IsApplyModifier()
        local value = GetDisableApplyModifier(self, {})
        if value>0 then
            return false
        else
            return true

        end
    end






    function CDOTA_BaseNPC:IsDisableCleave()
        local value = GetDisableCleave(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end

    function CDOTA_BaseNPC:IsDisableSplit()
        local value = GetDisableSplit(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end


    function CDOTA_BaseNPC:HDGetPrimaryStatValue()
        if self:IsRealHero() then
            local value = self:GetPrimaryStatValue()
            if self:GetPrimaryAttribute()==DOTA_ATTRIBUTE_ALL  then
                value = self:GetStrength()
                local agility = self:GetAgility()
                if value<agility then
                    value = agility
                end
                local int = self:GetIntellect(false)
                if value<int then
                    value = int            
                end
            end
            return value
        else
            return self:GetDamageMax()*0.8
        end
        
    end





    function IsNewPlayer(spells)

        local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
        local level15_exp = spellsXPTable[15]   --最高等级的经验值
        local count = 0
        local lv15Count = 0
        -- print(level15_exp)
        for key, value in pairs(spells) do
            -- print(key)
            -- print(value)
            if tonumber(value)>=level15_exp then
                lv15Count = lv15Count + 1
                
            end
            count = count + 1
        end
        if count>=70 and lv15Count>=15 then
            -- print("不是新手")
            return false
        end

        return true

    end


    function GetSpellCount(spells)

        local spellsXPTable = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellsXPTable  --获取到经验表
        local count = 0
        for key, value in pairs(spells) do
            count = count + 1
        end
        return count

    end



    -- 更新自动施法状态
    function CDOTABaseAbility:UpdateAutoCastState(bEnable)
        if not self.record_autoCastState then
            self.record_autoCastState = false
        end
        if self.record_autoCastState~=bEnable then
            self.record_autoCastState = bEnable
            ClientDataSYN_AbilityCustomValue(self,"record_autoCastState", self.record_autoCastState and 1 or 0)

        end
    end
    function CDOTABaseAbility:GetEffectGain(rate)
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
            rate = rate or 1,
        }
        local value = GetChaoticSpellEffectGain(caster,keys)
        return value
    end
    --天赋，精通cy
    function CDOTABaseAbility:GetTalentGain(rate)
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
            rate = rate or 1,
        }
        local value = GetTalentEffectGain(caster,keys)
        return value
    end

    function CDOTABaseAbility:GetManaCostGain()
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
        }
        local value = GetChaoticSpellManaCostGain(caster,keys)
        return value
    end

    function CDOTABaseAbility:IsSpellCanBeSell()
        return true
    end



    -- 是否飞行单位
    function CDOTA_BaseNPC:IsFlying()
        local value = GetFlying(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end


    function CDOTA_BaseNPC:IsFlyingPathing()
        local value = GetFlyingPathing(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end

    -- Only Server
    function CDOTA_BaseNPC:IsGiant()
        local pos1 = self:GetAbsOrigin()
        local pos2 = self:GetAttachmentOrigin( self:ScriptLookupAttachment( "attach_hitloc" ) )
        if (pos2.z - pos1.z)>=200 then
            return true
        end

        return false
     
    end

    function CDOTA_BaseNPC:GetBodyScale()
        local pos1 = self:GetAbsOrigin()
        local pos2 = self:GetAttachmentOrigin( self:ScriptLookupAttachment( "attach_hitloc" ) )
        return math.abs(pos2.z - pos1.z)
     
    end


    -- 免疫劣势地形
    function CDOTA_BaseNPC:IsImmuneDisadvantagedTerrain()
        if self:IsFlying() or self:IsFlyingPathing() or self:IsGiant() then
            return true
        end
        return false
    end

    -- 免疫劣势地形减速
    function CDOTA_BaseNPC:IsImmuneDisadvantagedTerrain_Slow()
        if GetImmuneDisadvantagedTerrain_Slow(self)>=1 then
            return true
        end
        if self:IsFlying() or self:IsFlyingPathing() or self:IsGiant() then
            return true
        end
        return false
    end


    --[[		计时器
		sContextName，计时器索引，可缺省
		fInterval，第一次运行延迟
		funcThink，回调函数，函数返回number将会再次延迟运行
		例：
		hUnit:GameTimer(0.5, function()
			hUnit:SetModelScale(1.5)
		end)
		GameRules:GetGameModeEntity():GameTimer(0.5, function()
			print(math.random())
			return 0.5
		end)
	]]
	--
    function CBaseEntity:Timer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("Timer")
		end
		self:SetContextThink(
		sContextName,
		function()
			local result = funcThink()
			if type(result) == "number" then
				result = math.max(FrameTime(), result)
			end
			return result
		end,
		fInterval
		)
		return sContextName
	end
	--[[		游戏计时器，游戏暂停会停下
	]]
	--
	function CBaseEntity:GameTimer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("GameTimer")
		end
		local fTime = GameRules:GetGameTime() + math.max(FrameTime(), fInterval)
		return self:Timer(
		sContextName,
		fInterval,
		function()
			if GameRules:GetGameTime() >= fTime then
				local result = funcThink()
				if type(result) == "number" then
					fTime = fTime + math.max(FrameTime(), result)
				end
				return result
			end
			return 0
		end
		)
	end
	--[[		暂停计时器，包括游戏计时器
	]]
	--
	function CBaseEntity:StopTimer(sContextName)
		self:SetContextThink(sContextName, nil, 0)
	end

    -- 感电函数集锦-------------------------------------------------------------------------------------
    function CDOTA_BaseNPC:Elecshocking(hCaster, hAbility, iCount,Markers)
		local iElecshockingStack = math.min(iCount, MAX_ELECSHOCKING_STACK) -- 感电层数
		local hElecshockingModifier = self:AddNewModifier(hCaster, hAbility, "modifier_hd_elecshocking", {})
        if hElecshockingModifier then
            local table = {
                attacker = hCaster,
                inflictor = hAbility,
                target = self,
                value = iElecshockingStack,
            }
            FireElecshockingEvent(table)
           return hElecshockingModifier:ApplyElecshockingStack(iElecshockingStack,hCaster,hAbility)
        end
        return 0
	end

    function CDOTA_BaseNPC:GetElecshockingCount()
        local tModifiers = self:FindAllModifiers()
        local table = {}
        local count = 0
        -- print("查找buff")
        for _, hModifier in pairs(tModifiers) do
     
            if hModifier.IsElecshockingDeBuff ~= nil and not table[hModifier:GetName()] then
                -- print("触发结算")
                table[hModifier:GetName()] = true
                count = count + 1
    
            end
        end
        return count
    end

    function FireElecshockingEvent(keys)
        -- [MODIFIER_EVENT_ON_ELECSHOCKING] = "AdvancedOnElecshocking",(attacker, target, inflictor, value)

        if IsValid(keys.attacker) and keys.attacker.tSourceModifierEvents and keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING] then
            local tModifiers = keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.attacker) and IsValid(hModifier) and hModifier.AdvancedOnElecshocking then
                    hModifier:AdvancedOnElecshocking(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING] then
            local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnElecshocking then
                    hModifier:AdvancedOnElecshocking(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ELECSHOCKING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnElecshocking then
                    hModifier:AdvancedOnElecshocking(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    --------------------------------------------------------------------------------------------------
    -- 冻伤函数集锦-------------------------------------------------------------------------------------
    function CDOTA_BaseNPC:Freezing(hCaster, hAbility, iCount,Markers)
		local iFreezingStack = math.min(iCount, MAX_FREEZING_STACK)*(1+hCaster:GetSpellAmplification(false)) -- 冻伤层数
		local hFreezingModifier = self:AddNewModifier(hCaster, hAbility, "modifier_hd_freezing", { duration = FREEZING_DURATION})
        if hFreezingModifier then
            local table = {
                attacker = hCaster,
                inflictor = hAbility,
                target = self,
                value = iFreezingStack,
            }
            FireFreezingEvent(table)
           return hFreezingModifier:ApplyFreezingStack(iFreezingStack,hCaster,hAbility)
        end
        return 0
	end

    function CDOTA_BaseNPC:ActiveFreezing(hCaster, hAbility, damageIndex,iFlags)
		local modifier_hd_freezing = self:FindModifierByName("modifier_hd_freezing")
		if modifier_hd_freezing then
            local stack = modifier_hd_freezing:GetFreezingStackCount()
            return ApplyFreezingDamage(hCaster,hAbility,self,stack*damageIndex)
        end
        return -1
	end

    function ApplyFreezingDamage(attacker,ability,victim,damage)
        local keys = {
            attacker = attacker,
            ability=ability,
            victim = victim,
            damage = damage,
        }
        damage = damage * (1+GetIncomingFreezingDamagePercentage(victim,keys)*0.01)
        if damage<=0 then
            return 0
        end
        local damageTable = {
            ability = ability,
            attacker = attacker,
            victim = victim,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags =  DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_FREEZING_DAMAGE,
        }

        if attacker then
            local jakiro_3 = attacker:FindModifierByName("modifier_heroTalent_npc_dota_hero_jakiro_3")
            if jakiro_3 and attacker:GetLevel() >= jakiro_3.level then
                damageTable.hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_FREEZING_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE
            end
        end

        local function ApplyFreezing(table)
            if not table then return end
            local freezing_damage = ApplyDamage(table)
            local target = table.victim
            local attacker = table.attacker
            local ability = table.ability

            if target:IsAlive() then
                if not target.freezing_accumulated then target.freezing_accumulated = 0 end
                if not target.freezing_threshold then target.freezing_threshold = 0.1 end
                target.freezing_accumulated = target.freezing_accumulated + freezing_damage

                local threshold_value = target:GetMaxHealth() * target.freezing_threshold
                if target.freezing_accumulated >= threshold_value then
                    target:AddNewModifier(attacker, ability, "modifier_hd_freezing_frozen", {duration = 3})
                    target.freezing_accumulated = 0
                    target.freezing_threshold = target.freezing_threshold * 2
                end
            end
            return freezing_damage
        end

        return ApplyFreezing(damageTable)
    end

    function CDOTA_BaseNPC:GetFreezingCount()
    
        local tModifiers = self:FindAllModifiers()
        local table = {}
        local count = 0
        -- print("查找buff")
        for _, hModifier in pairs(tModifiers) do
     
            if hModifier.IsFreezingDeBuff ~= nil and not table[hModifier:GetName()] then
                -- print("触发结算")
                table[hModifier:GetName()] = true
                count = count + 1
    
            end
        end
        return count
    end

    function FireFreezingEvent(keys)
        -- [MODIFIER_EVENT_ON_FREEZING] = "AdvancedOnFreezing",(attacker, target, inflictor, value)

        if IsValid(keys.attacker) and keys.attacker.tSourceModifierEvents and keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_FREEZING] then
            local tModifiers = keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_FREEZING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.attacker) and IsValid(hModifier) and hModifier.AdvancedOnFreezing then
                    hModifier:AdvancedOnFreezing(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_FREEZING] then
            local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_FREEZING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnFreezing then
                    hModifier:AdvancedOnFreezing(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_FREEZING] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_FREEZING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnFreezing then
                    hModifier:AdvancedOnFreezing(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    ----------------------------------------------------------------------
    -- 点燃函数集锦---------------------------------------------------------
    function CDOTA_BaseNPC:Burning(hCaster, hAbility, iCount,Markers)
		local iBurningStack = math.min(iCount, MAX_BURNING_STACK)*(1+hCaster:GetSpellAmplification(false)) -- 灼伤层数
		local hBurningModifier = self:AddNewModifier(hCaster, hAbility, "modifier_hd_burning", { duration = BURNING_DURATION})
        if hBurningModifier then
            local table = {
                attacker = hCaster,
                inflictor = hAbility,
                target = self,
                value = iBurningStack,
            }
            FireBurningEvent(table)
            return hBurningModifier:ApplyBurningStack(iBurningStack,hCaster,hAbility)
        end
        return 0	
	end

    function CDOTA_BaseNPC:ActiveBurning(hCaster, hAbility, damageIndex,iFlags)
		local modifier_hd_burning = self:FindModifierByName("modifier_hd_burning")
        local damageIndex = damageIndex or 1

		if modifier_hd_burning then
            local stack = modifier_hd_burning:GetBurningStackCount()
            local damage = ApplyBurningDamage(hCaster,hAbility,self,stack*damageIndex)

            return damage
        end
        return -1
	end

    function ApplyBurningDamage(attacker,ability,victim,damage)
        local keys = {
            attacker = attacker,
            ability=ability,
            victim = victim,
            damage = damage,
        }
        damage = damage * (1+GetIncomingBurningDamagePercentage(victim,keys)*0.01)
        if damage<=0 then
            return 0
        end
        local damageTable = {
            ability = ability,
            attacker = attacker,
            victim = victim,
            damage = damage*1.2,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags =  DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_BURNING_DAMAGE,
        }

        if attacker then
            local jakiro_3 = attacker:FindModifierByName("modifier_heroTalent_npc_dota_hero_jakiro_3")
            if jakiro_3 and attacker:GetLevel() >= jakiro_3.level then
                damageTable.hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_BURNING_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE
            end
        end

        return ApplyDamage(damageTable)
    end

    function CDOTA_BaseNPC:GetBurningCount()
    
        local tModifiers = self:FindAllModifiers()
        local table = {}
        local count = 0
        -- print("查找buff")
        for _, hModifier in pairs(tModifiers) do
     
            if hModifier.IsBurningDeBuff ~= nil and not table[hModifier:GetName()] then
                -- print("触发结算")
                table[hModifier:GetName()] = true
                count = count + 1
    
            end
        end
        return count
    end

    function FireBurningEvent(keys)
        -- [MODIFIER_EVENT_ON_BURNING] = "AdvancedOnBurning",(attacker, target, inflictor, value)

        if IsValid(keys.attacker) and keys.attacker.tSourceModifierEvents and keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_BURNING] then
            local tModifiers = keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_BURNING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.attacker) and IsValid(hModifier) and hModifier.AdvancedOnBurning then
                    hModifier:AdvancedOnBurning(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_BURNING] then
            local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_BURNING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnBurning then
                    hModifier:AdvancedOnBurning(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_BURNING] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_BURNING]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnBurning then
                    hModifier:AdvancedOnBurning(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    ---------------------------------------------------------------------------------
    -- 中毒函数集锦
    function CDOTA_BaseNPC:Poison(hCaster, hAbility, iCount,Markers)
		-- self:PoisonApplied(hCaster, hAbility, iCount,Markers)
		-- if iCount > 0 then
		-- 	iCount = iCount * (1 + GetOutgoingPoisonCountPercent(hCaster) * 0.01) * (1 + GetIncomingPoisonCountPercent(self) * 0.01)
		-- end
		local iPoisonStack = math.min(iCount, MAX_POISON_STACK) -- 毒层数
		local hPoisonModifier = self:AddNewModifier(hCaster, hAbility, "modifier_hd_poison", { duration = POISON_DURATION})
        if hPoisonModifier then
           return hPoisonModifier:ApplyPoisonStack(iPoisonStack,hCaster,hAbility)
        end
        return 0
	end

    function CDOTA_BaseNPC:ActivePoison(hCaster, hAbility, damageIndex,iFlags)
		local modifier_hd_poison = self:FindModifierByName("modifier_hd_poison")
		if modifier_hd_poison then
            local stack = modifier_hd_poison:GetPoisonStackCount()
            return ApplyPoisonDamage(hCaster,hAbility,self,stack*damageIndex)
        end
        return -1
	end

    function ApplyPoisonDamage(attacker,ability,victim,damage)
        local keys = {
            attacker = attacker,
            ability=ability,
            victim = victim,
            damage = damage,
        }
        damage = damage * (1+GetIncomingPoisonDamagePercentage(victim,keys)*0.01)
        if damage<=0 then
            return 0
        end
        local damageTable = {
            ability = ability,
            attacker = attacker,
            victim = victim,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
            hd_flags = HD_DAMAGE_FLAG_POISON + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
        }
        if victim:HasModifier("modifier_Primary_Poison_Nova") or victim:HasModifier("modifier_Middle_Poison_Nova")  or victim:HasModifier("modifier_Advanced_Poison_Nova") then
            damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NON_LETHAL
        end
        local dark_modifier = attacker:FindModifierByName("modifier_item_act2_leshrac")
        if dark_modifier and dark_modifier.dark_posion then
            damageTable.hd_flags = HD_DAMAGE_FLAG_POISON + HD_DAMAGE_FLAG_DOT  + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_DARK_DAMAGE
        end

        return ApplyDamage(damageTable)
    end



    function CDOTA_BaseNPC:IsInDayTime()
        if GetUnitForceDayState(self)>0 then
            return true
        end
        if GameRules:IsDaytime() then
            return true
        else
            return false
        end
    end
    function CDOTA_BaseNPC:IsInNightTime()
        if GetUnitForceNightState(self)>0 then
            return true
        end
        if GameRules:IsDaytime() then
            return false
        else
            return true
        end
    end


    function CDOTA_BaseNPC:MakeCustomIllusion(pos)
        if not pos then
            pos = self:GetAbsOrigin()
        end
        local illusion =	CreateUnitByName( "npc_hd_double", pos, true, nil, nil, self:GetTeamNumber() )
        if illusion then
    
            illusion:SetOriginalModel(self.origin_model_name)
            illusion:SetModelScale(self:GetModelScale())
            local hModel = self:FirstMoveChild()
            while hModel ~= nil do
                if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
                    local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = illusion:GetAbsOrigin() })
                    -- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
                    hWearable:FollowEntity(illusion, true)
                end
                hModel = hModel:NextMovePeer()
            end
            local angle = self:GetAngles()
            illusion:SetAngles(angle.x, angle.y, angle.z)
            FindClearSpaceForUnit(illusion, pos, true)
            return illusion
        end
        
    end



    function CDOTA_BaseNPC:IsInInvisibilityCooldown()
        if self:HasModifier("modifier_chaotic_aura_invisibility_cooldown") or self:HasModifier("modifier_chaotic_aura_invisibility_cooldown") then
            return true
        end
        return false
        
    end



    if CDOTA_BaseNPC.ForceKill_Engine == nil then
        CDOTA_BaseNPC.ForceKill_Engine = CDOTA_BaseNPC.ForceKill
    end
    ---Kill this unit immediately.
    ---@param bReincarnate boolean
    ---@return void
    function CDOTA_BaseNPC:ForceKill(bReincarnate)
        self:ForceKill_Engine(bReincarnate)
        FireGameEvent("entity_killed", {
                damagebits = -1,
                entindex_killed = self:entindex(),
                entindex_attacker = -1,
                entindex_inflictor = -1,
        })
    end
    


    if CDOTA_BaseNPC.AddNewModifier_Engine == nil then
        CDOTA_BaseNPC.AddNewModifier_Engine = CDOTA_BaseNPC.AddNewModifier
    end
    ---Kill this unit immediately.
    ---@param bReincarnate boolean
    ---@return void
    function CDOTA_BaseNPC:AddNewModifier(caster,ability,modifierName,keys)
        local modifier = self:AddNewModifier_Engine(caster,ability,modifierName,keys)
        if modifier then
            xpcall(function() 
                local keys= {
                    caster = caster,
                    target = self,
                    ability = ability,
                    modifierName = modifierName,
                    modifierKeys = keys,
                }
                if IsValid(keys.caster) and keys.caster.tSourceModifierEvents and keys.caster.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED] then
                    local tModifiers = keys.caster.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED]
                    for i = #tModifiers, 1, -1 do
                        local hModifier = tModifiers[i]
                        if IsValid(keys.caster) and IsValid(hModifier) and hModifier.AdvancedOnModifierApplied then
                            hModifier:AdvancedOnModifierApplied(keys)
                        else
                            table.remove(tModifiers, i)
                        end
                    end
                end
                if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED] then
                    local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED]
                    for i = #tModifiers, 1, -1 do
                        local hModifier = tModifiers[i]
                        if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnModifierApplied then
                            hModifier:AdvancedOnModifierApplied(keys)
                        else
                            table.remove(tModifiers, i)
                        end
                    end
                end
                if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED] then
                    local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_APPLIED]
                    for i = #tModifiers, 1, -1 do
                        local hModifier = tModifiers[i]
                        if IsValid(hModifier) and hModifier.AdvancedOnModifierApplied then
                            hModifier:AdvancedOnModifierApplied(keys)
                        else
                            table.remove(tModifiers, i)
                        end
                    end
                end 
                
            end, function(err)
                print("Error in AddNewModifier event handler:", err)
                print(debug.traceback())
            end)
            -- end, debug.traceback)
           
        end
        return modifier
    end
    




    if CDOTA_BaseNPC.AddItemByName_Engine == nil then
        CDOTA_BaseNPC.AddItemByName_Engine = CDOTA_BaseNPC.AddItemByName
    end
    function CDOTA_BaseNPC:AddItemByName(itemName)

        local count = 0
        for itemSlot = 0, 8 do
            local item = self:GetItemInSlot(itemSlot)
            if item  then
                count = count + 1
            end
        end

        if count>=9 then
            local hItem = CreateItem(itemName, self, self)
            local hContainer = CreateItemOnPositionForLaunch(self:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0), hItem)
            if hContainer then
                return hContainer:GetContainedItem()
            end
        else
            local hTargetItem = self:AddItemByName_Engine(itemName)
            return hTargetItem

        end


        -- local hItem = CreateItem(itemName, self, self)
        -- -- hItem:SetPurchaseTime(0)

        -- local hTargetItem = self:AddItem(hItem)
        -- -- local hTargetItem = self:AddItemByName_Engine(itemName)
        -- if not IsValid(hTargetItem) then
        --     local hContainer = CreateItemOnPositionForLaunch(self:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0), itemName)

        --     -- local hitem = CreateItemOnPosition(self:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0), itemName)
        --     if hContainer then
        --         return hContainer:GetContainedItem()
        --     end
        -- else
        --     return hTargetItem
        -- end
       
    end


    

    function CDOTA_BaseNPC_Hero:GetStrengthGain()
        if self.originStrGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originStrGain = math.max(kv["AttributeStrengthGain"] or 0,0)
            else
                self.originStrGain = 0
            end
        end
        return self.originStrGain 
    end
    function CDOTA_BaseNPC_Hero:GetAgilityGain()
        if self.originAgiGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originAgiGain = math.max(kv["AttributeAgilityGain"] or 0,0)
            else
                self.originAgiGain = 0
            end
        end
        return self.originAgiGain 
    end
    function CDOTA_BaseNPC_Hero:GetIntellectGain()
        if self.originIntGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originIntGain = math.max(kv["AttributeIntelligenceGain"] or 0,0)
            else
                self.originIntGain = 0
            end
        end
        return self.originIntGain 
    end



	
    function FireCritHitEvent(keys)
        -- print("insert table")
		if bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[keys.record], ATTACK_STATE_CRIT) ~= ATTACK_STATE_CRIT then
			RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[keys.record] = RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[keys.record] + ATTACK_STATE_CRIT
		end

        if IsValid(keys.attacker) and keys.attacker.tSourceModifierEvents and keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER] then
            local tModifiers = keys.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.attacker) and IsValid(hModifier) and hModifier.AdvancedOnCriticalStrikeTrigger then
                    hModifier:AdvancedOnCriticalStrikeTrigger(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if IsValid(keys.unit) and keys.unit.tTargetModifierEvents and keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER] then
            local tModifiers = keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnCriticalStrikeTrigger then
                    hModifier:AdvancedOnCriticalStrikeTrigger(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnCriticalStrikeTrigger then
                    hModifier:AdvancedOnCriticalStrikeTrigger(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    --寒霜传送门
    function FireVitalityEvent(keys)

        print("正常运作")
        if IsValid(keys.unit) and keys.unit.tTargetModifierEvents and keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_VITALITY] then
            local tModifiers = keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_VITALITY]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnVitality then
                    hModifier:AdvancedOnVitality(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_VITALITY] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_VITALITY]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnVitality then
                    hModifier:AdvancedOnVitality(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    
    function FireDeathAgainEvent(keys)
        if keys.mulEffect then
            keys.mul_index = 1 + GetFalseDeathMulEffect(keys.unit,keys) *0.01
        else
            keys.mul_index = 1
        end
        if IsValid(keys.unit) and keys.unit.tTargetModifierEvents and keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH_AGAIN] then
            local tModifiers = keys.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH_AGAIN]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnDeathAgain then
                    hModifier:AdvancedOnDeathAgain(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DEATH_AGAIN] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DEATH_AGAIN]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnDeathAgain then
                    hModifier:AdvancedOnDeathAgain(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        -- 增加死亡单位触发的虚假死亡次数
        if IsValid(keys.unit) then
            local modifier = keys.unit:FindModifierByName("modifier_unit_cooldownReduction")
            if modifier then
                modifier:IncreaseFalseDeathCount(1)
            end
        end


    end

    function GetFalseDeathCount(unit)
        local modifier = unit:FindModifierByName("modifier_unit_cooldownReduction")
        if modifier then
            return modifier:GetFalseDeathCount()
        end
        return 0
    end










    function FireSummonEvent(keys)
        -- [MODIFIER_EVENT_ON_SUMMON] = "AdvancedOnSummon",

        if IsValid(keys.unit) and keys.unit.tSourceModifierEvents and keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SUMMON] then
            local tModifiers = keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SUMMON]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnSummon then
                    hModifier:AdvancedOnSummon(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SUMMON] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SUMMON]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnSummon then
                    hModifier:AdvancedOnSummon(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end



    function FireSpellLearnEvent(keys)
        if IsValid(keys.unit) and keys.unit.tSourceModifierEvents and keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_LEARN_NEW_SPELL] then
            local tModifiers = keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_LEARN_NEW_SPELL]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnLearnNewSpell then
                    hModifier:AdvancedOnLearnNewSpell(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_LEARN_NEW_SPELL] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_LEARN_NEW_SPELL]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnLearnNewSpell then
                    hModifier:AdvancedOnLearnNewSpell(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    function FireSpellSellEvent(keys)
        if IsValid(keys.unit) and keys.unit.tSourceModifierEvents and keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Sell_SPELL] then
            local tModifiers = keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Sell_SPELL]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnSellSpell then
                    hModifier:AdvancedOnSellSpell(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_Sell_SPELL] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_Sell_SPELL]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnSellSpell then
                    hModifier:AdvancedOnSellSpell(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end

    function FireHealEvent(keys)
        if IsValid(keys.unit) and keys.unit.tSourceModifierEvents and keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Heal] then
            local tModifiers = keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Heal]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnHeal then
                    hModifier:AdvancedOnHeal(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_Heal] then
            local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_Heal]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnHeal then
                    hModifier:AdvancedOnHeal(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end

        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_Heal] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_Heal]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnHeal then
                    hModifier:AdvancedOnHeal(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end

    function FirePlayerChatEvent(keys)
        if IsValid(keys.unit) and keys.unit.tSourceModifierEvents and keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Chat] then
            local tModifiers = keys.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_Chat]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(keys.unit) and IsValid(hModifier) and hModifier.AdvancedOnChat then
                    hModifier:AdvancedOnChat(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
        -- if IsValid(keys.target) and keys.target.tTargetModifierEvents and keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_Chat] then
        --     local tModifiers = keys.target.tTargetModifierEvents[MODIFIER_EVENT_ON_Chat]
        --     for i = #tModifiers, 1, -1 do
        --         local hModifier = tModifiers[i]
        --         if IsValid(keys.target) and IsValid(hModifier) and hModifier.AdvancedOnChat then
        --             hModifier:AdvancedOnChat(keys)
        --         else
        --             table.remove(tModifiers, i)
        --         end
        --     end
        -- end

        if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_Chat] then
            local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_Chat]
            for i = #tModifiers, 1, -1 do
                local hModifier = tModifiers[i]
                if IsValid(hModifier) and hModifier.AdvancedOnChat then
                    hModifier:AdvancedOnChat(keys)
                else
                    table.remove(tModifiers, i)
                end
            end
        end
    end
    


    ATTACK_STATE_CRIT = 1 -- 暴击
    function AttackFilter(iRecord, ...)
		local bool = false
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] ~= nil then
			for i, iAttackState in pairs({ ... }) do
				bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] or 0, iAttackState) == iAttackState)
			end
		end
		return bool
	end

    function CDOTA_BaseNPC:GetRuneType(abilityName)

        if abilityName.GetAbilityName then
            abilityName = abilityName:GetAbilityName()
        end
		local nPlayerID = self:GetPlayerOwnerID()

        if chaotic_era.runeEquip__Nettable[nPlayerID] then
            local data = chaotic_era.runeEquip__Nettable[nPlayerID][abilityName]
            if data then
                return tonumber(data.runeType)
            end
        end
		return 0
	end


    function CDOTABaseAbility:GetRuneType()
        
        if not self.runetType then
            local caster = self:GetCaster()
            self.runetType = caster:GetRuneType(self)
        end
        return  self.runetType
    end


    function CDOTA_BaseNPC:GetHDStatusResistanceIndex(effectRate)
        local value = GetStatusResistance(self, {})
        local index = effectRate or 1
        return (100 - value*index)*0.01
    end




    
    function CDOTA_BaseNPC:GetModifierDurationGainIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            -- target = target,
            caster = self,
        }
        local value = GetDurationGain(self, tParams)
        value = math.max(value*index,-100)
        return (100 + value)*0.01
    end

    function CDOTA_BaseNPC:GetModifierStatusNegativeGainIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            caster = self,
        }
        local value = GetNegativeDurationGain(self, tParams)
        value = math.max(value*index,-100)



        return (100 + value)*0.01
        
    end




    function CDOTA_BaseNPC:GetModifierLifeStealGain(effectRate)
    
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            -- target = target,
            caster = self,
        }
        if GetLifeStealDisable(self, tParams)>=1 then
            return 0
        end
        local value = GetLifeStealIntensity(self, tParams)
        value = math.max(value*index,-100)
        return (100 + value)*0.01
    end



    function CDOTA_BaseNPC:GetSummonIntensityIndex(effectRate,unit)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            target = unit,
            caster = self,
        }
        local value = GetSummonIntensity(self, tParams)
        value = math.max(value*index,-95)
        return (100 + value)*0.01
    end


    function CDOTA_BaseNPC:GetSummonTimeAmpIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            -- target = target,
            caster = self,
        }
        local value = GetSummonTimeIntensity(self, tParams)
        value = math.max(value*index,-100)

        return 1+(value*0.01)
    end





    function CDOTA_BaseNPC:GetModifierRandomEffectGain(effectRate) 
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            -- target = target,
            caster = self,
        }
        local value = GetRandomEffectGain(self, tParams)
        value = math.max(value,-100)
        -- print("value=",value)
        return (100 + value)*0.01
        
    end

    --生成一个受到加成影响的值
    function CDOTA_BaseNPC:GetRandomEffect(max,type,gainIndex) 
        local gain = self:GetModifierRandomEffectGain(gainIndex)
        if not gain then
            print("Erro:无法获取到单位的加成值")
            return -1
        end
        local number = max * gain
        if type==INT_TYPE then
            number = number-number%1
        end
        return number
    end
    function CDOTA_BaseNPC:RollRandom(chance,gainIndex) 
        local gain = self:GetModifierRandomEffectGain(gainIndex)
        if not gain then
            gain = 0
        end
        local number = chance * gain
        if number>=RandomFloat(1, 100) then
            return true
        end
        return false
    end



    function CDOTA_BaseNPC:GetCriticalAmpIndex(effectRate)

        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            -- target = target,
            caster = self,
        }
        local value = GetPhysicalCriticalAmp(self, tParams)
        value = math.max(value,-100)

        return (100 + value)*0.01
    end

    function CDOTA_BaseNPC:GetPotionEffectIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            caster = self,
        }
        local value = GetGloabal_ChaoticEra__PotionEffect(self, tParams)
        return (100 + value)*0.01
    end
    function CDOTA_BaseNPC:GetPotionCostIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            caster = self,
        }
        local value = GetGloabal_ChaoticEra__CostReduction(self, tParams)
        return (100 - value)*0.01
    end






    

    ----------
    --流血性质伤害加成
    --可以无限大 但最小为-100
    --关键字 ModifierBleedingAmp
    function CDOTA_BaseNPC:UpDateModifierBleedingAmp(modifier,number)
        if self.BleedingAmpClass == nil then
            self.BleedingAmpClass = {}
        end
        for i=1,  #self.BleedingAmpClass*0.5 do
            if self.BleedingAmpClass[2*i-1] == modifier then
                if self.BleedingAmpClass[2*i] == number then
                    return
                else
                    self.BleedingAmpClass[2*i] = number
                    local Gain = 0
                    for i=1,  #self.BleedingAmpClass*0.5 do
                        Gain = Gain + self.BleedingAmpClass[2*i]
                    end
                    if Gain<(-100) then
                        Gain = -100
                    end
                    self.ModifierBleedingAmp = Gain
                    return
                end
            end
        end
        local index= #self.BleedingAmpClass+1
        table.insert (self.BleedingAmpClass, index, modifier)
        table.insert (self.BleedingAmpClass, index+1, number)
        local Gain = 0
        for i=1,  #self.BleedingAmpClass*0.5 do
            Gain = Gain + self.BleedingAmpClass[2*i]
        end
        if Gain<(-100) then
            Gain = -100
        end
        self.ModifierBleedingAmp = Gain
    end
    function CDOTA_BaseNPC:RemoveModifierBleedingAmp(modifier)
        if self.BleedingAmpClass == nil then
            self.BleedingAmpClass = {}
        end
        for i=1,  #self.BleedingAmpClass*0.5 do
            if self.BleedingAmpClass[2*i-1] == modifier then
                table.remove(self.BleedingAmpClass,2*i)
                table.remove(self.BleedingAmpClass,2*i-1)
                break
            end
        end
        local Gain = 0
        for i=1,  #self.BleedingAmpClass*0.5 do
            Gain = Gain + self.BleedingAmpClass[2*i]
        end
        if Gain<(-100) then
            Gain = -100
        end
        self.ModifierBleedingAmp = Gain
    end

    function CDOTA_BaseNPC:GetBleedingAmp()
        return self.ModifierBleedingAmp or 0
    end
    function CDOTA_BaseNPC:GetBleedingAmpIndex()
        local amp = self.ModifierBleedingAmp or 0
        local index = (100+amp)*0.01
        return index
    end

    function CDOTA_Buff:GetUnlock(key)
        if not self or self:IsNull() then
            print("Error: buff不合法")
            return -1
        end
        local ability = self:GetAbility()
        if not ability then
            print("Error: 技能不存在")
            return -1
        end
    
    
        if ability.unlock1 and key==1 then
            return 1
        end
    
        if ability.unlock2 and key==2 then
    
            return 2
        end
    
        if ability.unlock3 and key==3 then
            return 3
        end
        return 0
    end
    
    function CDOTABaseAbility:GetElementAttribue(key)
        return ABILITY_ELEMENT_TYPE_NONE
    end
    function CDOTABaseAbility:GetUnlock(key)
        if not self or self:IsNull() then
            print("Error: 技能不合法")
            return -1
        end
        if self.unlock1 and key==1 then
            return 1
        end
        if self.unlock2 and key==2 then
            return 2
        end
        if self.unlock3 and key==3 then
            return 3
        end
    
        return 0
    end
    
    
    
    
    
    function CDOTA_BaseNPC:GetPoisonCount()
    
        local tModifiers = self:FindAllModifiers()
        local table = {}
        local count = 0
        -- print("查找buff")
        for _, hModifier in pairs(tModifiers) do
     
            if hModifier.IsPoisonDeBuff ~= nil and not table[hModifier:GetName()] then
                -- print("触发结算")
                table[hModifier:GetName()] = true
                count = count + 1
    
            end
        end
        return count
    end
    

    -- 获取乱纪元技能类型
    function CDOTABaseAbility:GetChaoticSpellType()
        if not self.ChaoticSpellType then
            self.ChaoticSpellType = "nil"
            local kv =  KeyValues.ability_bonus_info[self:GetAbilityName()]
            if kv and kv.IsChaoticEraSpell and kv.IsChaoticEraSpell==1 then
                local type = kv.ChaoticSpellType
                if type then
                    self.ChaoticSpellType = string.sub(type, 2)
                end
            end
        end

        

        return self.ChaoticSpellType
    end
    -- 是否是乱纪元技能
    function CDOTABaseAbility:IsChaoticEraSpell()
        if not self.bIsChaoticEraSpell then
            self.bIsChaoticEraSpell =0
            local kv =  KeyValues.ability_bonus_info[self:GetAbilityName()]
            if kv and kv.IsChaoticEraSpell and kv.IsChaoticEraSpell==1 then
                self.bIsChaoticEraSpell = 1
            end
        end
        if self.bIsChaoticEraSpell==1 then
            return true
        end
        return false
    end
    -- 是否火焰技能
    function CDOTABaseAbility:IsFireSpell(key)
        if not self.bIsFireSpell then
            self.bIsFireSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.FireAttribute  then
                self.bIsFireSpell = kv.FireAttribute
            end
        end
        if self.bIsFireSpell==1 then
            return true
        end
        return false
        
    end
    -- 是否冰技能
    function CDOTABaseAbility:IsIceSpell(key)
        if not self.bIsIceSpell then
            self.bIsIceSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.IceAttribute then
                self.bIsIceSpell = kv.IceAttribute
            end
        end
        if self.bIsIceSpell==1 then
            return true
        end
        return false
        
    end
    -- 是否闪电技能
    function CDOTABaseAbility:IsLightningSpell(key)
        if not self.bIsLightningSpell then
            self.bIsLightningSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.LightningAttribute then
                self.bIsLightningSpell =  kv.LightningAttribute
            end
        end
        if self.bIsLightningSpell==1 then
            return true
        end
        return false
        
    end
    -- 是否神圣技能
    function CDOTABaseAbility:IsHolySpell(key)
        if not self.bIsHolySpell then
            self.bIsHolySpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.HolyAttribute then
                self.bIsHolySpell =  kv.HolyAttribute
            end
        end
        if self.bIsHolySpell==1 then
            return true
        end
        return false
        
    end 
    -- 是否暗影技能
    function CDOTABaseAbility:IsDarkSpell(key)
        if not self.bIsDarkSpell then
            self.bIsDarkSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.DarkAttribute then
                self.bIsDarkSpell =  kv.DarkAttribute
            end
        end
        if self.bIsDarkSpell==1 then
            return true
        end
        return false
        
    end 

    -- 获取环等级
    function CDOTABaseAbility:GetAbilityClassLevel()
        if not self.iChaoticEraSpellClassLevel then
            self.iChaoticEraSpellClassLevel = -1 
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.ChaoticSpell_ClassLevel then
                self.iChaoticEraSpellClassLevel = kv.ChaoticSpell_ClassLevel
            end
        end
      
        return self.iChaoticEraSpellClassLevel
    end
   
    function CDOTA_Buff:RemoveOnSell()
       return true
    end


    function CDOTA_BaseNPC:IsChaoticEraElite()
        if not self.bIsChaoticEraElite then
            self.bIsChaoticEraElite = 0
            local id = self.sChaoticEraID or ""
            local kv =  KeyValues.chaotic_era_creep_attribute[id]
            if kv then
                if kv.interval>=30 then
                    self.bIsChaoticEraElite = 1
                end
                -- 词条：超级精英
			    local heroes = GetAllRealHeroes()
			    for _, hero in pairs(heroes) do
				    if hero:HasModifier("modifier_super_elite_debuff") then
                        self.bIsChaoticEraElite = 1
                        break
                    end
				end
            end
        end
        if  self.bIsChaoticEraElite==1 then
            return true
        else
            return false
        end
    end
    function CDOTA_BaseNPC:IsChaoticEraBoss()
        if self:GetUnitName() == "npc_monster_boss_chaoc_form_real_one" then
            return true
        end
        return false
    end

    
    function CDOTA_BaseNPC:ImmuneForceAttack()
        if self:HasModifier("modifier_creeps_spell_barr_thunder_passive") then
            return true
        end
        return false
    end

    function IsChaoticEraElite(id)
        local kv =  KeyValues.chaotic_era_creep_attribute[id]
        if kv then
            if kv.interval>=30 then
                return true
            end
        end
        return false
    end

    -- 更新最大数量
    function UpdateSummonMaxCount(summonList,count)
        local updateTable = {}
        for i, unit in ipairs(summonList) do
            if IsValid(unit) and unit:IsAlive() then
                table.insert(updateTable,unit)
            end
        end
        summonList = updateTable
        if #summonList>=count then
            local bonus_count = #summonList-count+1
            for i, unit in ipairs(summonList) do
                if IsValid(unit) and unit:IsAlive() then
                    bonus_count = bonus_count - 1
                    TrueKill(nil, unit, self)
                    if bonus_count<=0 then
                        break
                    end
                end
            end
        end
    end



    -- 是否为昆虫
    function CDOTA_BaseNPC:IsInsect()
        if self.bIsInsectCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsInsectCreature = kv["IsInsectCreature"] or 0
            else
                self.bIsInsectCreature = 0
            end
            
        end
        return self.bIsInsectCreature==1
    end

    -- 是否为恶魔
    function CDOTA_BaseNPC:IsDemon()
        if self.bIsDemonCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsDemonCreature = kv["IsDemonCreature"] or 0
            else
                self.bIsDemonCreature = 0
            end
            
        end
        return self.bIsDemonCreature==1
    end

    -- 是否为不死者
    function CDOTA_BaseNPC:IsUndead()
        if self.bIsUndyingCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsUndyingCreature = kv["IsUndyingCreature"] or 0
            else
                self.bIsUndyingCreature = 0
            end
            
        end
        return self.bIsUndyingCreature==1
    end

    function IsUndead(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsUndyingCreature = kv["IsUndyingCreature"] or 0
            return bIsUndyingCreature==1
        end
        return false
    end
    function CDOTA_BaseNPC:IsCustomWard()
        if self.bIsWardCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsWardCreature = kv["IsWardCreature"] or 0
            else
                self.bIsWardCreature = 0
            end
            
        end
        return self.bIsWardCreature==1
    end
    function IsCustomWard(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsWardCreature = kv["IsWardCreature"] or 0
            return bIsWardCreature==1
        end
        return false
    end

    -- 是否为娜迦族
    function CDOTA_BaseNPC:IsNaga()
        if self.bIsNagaCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsNagaCreature = kv["IsNagaCreature"] or 0
            else
                self.bIsNagaCreature = 0
            end
            
        end
        return self.bIsNagaCreature==1
    end
    function IsNagaCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsNagaCreature = kv["IsNagaCreature"] or 0
            return bIsNagaCreature==1
        end
        return false
    end

    -- 是否为植物系怪物
    function CDOTA_BaseNPC:IsBotanicalCreature()
        if self.bIsBotanicalCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsBotanicalCreature = kv["IsBotanicalCreature"] or 0
            else
                self.bIsBotanicalCreature = 0
            end
            
        end
        return self.bIsBotanicalCreature==1
    end
    function IsBotanicalCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsBotanicalCreature = kv["IsBotanicalCreature"] or 0
            return bIsBotanicalCreature==1
        end
        return false
    end

    
    -- 是否为混沌生物
    function CDOTA_BaseNPC:IsChaosCreature()
        if self.bIsChaosCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsChaosCreature = kv["IsChaosCreature"] or 0
            else
                self.bIsChaosCreature = 0
            end
            
        end
        return self.bIsChaosCreature==1
    end
    function IsChaosCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsChaosCreature = kv["IsChaosCreature"] or 0
            return bIsChaosCreature==1
        end
        return false
    end


    -- 是否为y元素生物
    function CDOTA_BaseNPC:IsElementCreature()
        if self.bIsElementCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsElementCreature = kv["IsElementCreature"] or 0
            else
                self.bIsElementCreature = 0
            end
            
        end
        return self.bIsElementCreature==1
    end
    function IsElementCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsElementCreature = kv["IsElementCreature"] or 0
            return bIsElementCreature==1
        end
        return false
    end

    -- 是否为契约召唤
    function CDOTA_BaseNPC:IsIndentureSummon()
        if self.bIsIndentureSummon==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsIndentureSummon = kv["IsIndentureSummon"] or 0
            else
                self.bIsIndentureSummon = 0
            end
            
        end
        return self.bIsIndentureSummon==1
    end
    function IsIndentureSummon(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsIndentureSummon = kv["IsIndentureSummon"] or 0
            return bIsIndentureSummon==1
        end
        return false
    end

    -- 是否是精灵召唤
    function CDOTA_BaseNPC:IsSpriteSummon()
        if self.bIsSpriteSummon==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsSpriteSummon = kv["IsSpriteSummon"] or 0
            else
                self.bIsSpriteSummon = 0
            end
            
        end
        return self.bIsSpriteSummon==1
    end
    
    function IsSpriteSummon(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsSpriteSummon = kv["IsSpriteSummon"] or 0
            return bIsSpriteSummon==1
        end
        return false
    end

    function CDOTA_Buff:RemoveStackDuration(iRemoveStack)
		if iRemoveStack <= 0 then
			return
		end
		if type(self._tStackData_) == "table" then
			local iStack = self:GetStackCount()
			local iOriginalStack = self:GetOriginalStackCount()
			local i = 1
			while i <= #self._tStackData_ do
				local t = self._tStackData_[i]
				if iRemoveStack > t.iStackCount then
					iStack = iStack - t.iStackCount
					iRemoveStack = iRemoveStack - t.iStackCount
					table.remove(self._tStackData_, i)
				else
					iStack = iStack - iRemoveStack
					t.iStackCount = t.iStackCount - iRemoveStack
					if t.iStackCount == 0 then
						table.remove(self._tStackData_, i)
					end
					break
				end
			end

			self:SetStackCount(iStack)
			self._iStack_ = self:GetStackCount() -  iOriginalStack
			-- print("self._iStack_=",self._iStack_)
		end
	end
    function CDOTA_Buff:GetOriginalStackCount()
		return self:GetStackCount() - math.floor(self._iStack_ or 0)
	end
	function CDOTA_Buff:SetOriginalStackCount(iStack)
		self:SetStackCount(iStack + math.floor(self._iStack_ or 0))
	end

    --- 使buff增加一定层数，每次增加的层数独立计算时间
	--- @param iAddStack number 层数
	--- @param fDuration number 持续时间
	--- @param iMaxAddStack number|nil 最大总层数
	function CDOTA_Buff:AddStackDuration(iAddStack, fDuration, iMaxAddStack)
		if iAddStack <= 0 then
			return
		end
		if fDuration < 0 then
			return
		end
		if self._tStackData_ == nil then
			self._tStackData_ = {}
		end
		if self._iStack_ == nil then
			self._iStack_ = 0
		end
		local iOriginalStack = self:GetOriginalStackCount()
		local iStack = self._iStack_ + iAddStack
		if type(iMaxAddStack) == "number" and iMaxAddStack > 0 and iStack > iMaxAddStack then
			local iOverflowStack = iStack - iMaxAddStack
			local i = 1
			while i <= #self._tStackData_ do
				local t = self._tStackData_[i]
				if iOverflowStack > t.iStackCount then
					iStack = iStack - t.iStackCount
					iOverflowStack = iOverflowStack - t.iStackCount
					table.remove(self._tStackData_, i)
				else
					iStack = iStack - iOverflowStack
					t.iStackCount = t.iStackCount - iOverflowStack
					if t.iStackCount == 0 then
						table.remove(self._tStackData_, i)
					end
					break
				end
			end
		end
		self._iStack_ = iStack
		self:SetStackCount(iOriginalStack + self._iStack_)

		local fDieTime = GameRules:GetGameTime() + fDuration
		local index = #self._tStackData_ + 1
		for i = #self._tStackData_, 1, -1 do
			if fDieTime >= self._tStackData_[i].fDieTime then
				break
			else
				index = i
			end
		end
		table.insert(self._tStackData_, index, {
			fDieTime = fDieTime,
			iStackCount = iAddStack,
		})
		if index == 1 then
			local hParent = self:GetParent()
			hParent:GameTimer(self:GetName() .. "add_stack_timer", fDuration, function()
				local hModifier = self
				if not IsValid(hModifier) then return end
				local fGameTime = GameRules:GetGameTime()
				local index = 1
				while index <= #hModifier._tStackData_ do
					if fGameTime >= hModifier._tStackData_[index].fDieTime then
						local fDieTime = hModifier._tStackData_[index].fDieTime
						local iOriginalStack = hModifier:GetOriginalStackCount()
						hModifier._iStack_ = hModifier._iStack_ - hModifier._tStackData_[index].iStackCount
						hModifier:SetStackCount(iOriginalStack + hModifier._iStack_)
						table.remove(hModifier._tStackData_, index)
					else
						local fDuration = hModifier._tStackData_[index].fDieTime - fGameTime
						return fDuration
					end
				end
			end)
		end
	end

	function CDOTA_Buff:RefreshAllStacksDuration(maxDuration)
		local current_stack = self._iStack_
		self:RemoveStackDuration(current_stack)
		self:AddStackDuration(current_stack, maxDuration,nil)
		self:SetDuration(maxDuration, true)
	end

    --- 增加buff每个层数的持续时间
	--- @param bonusDuration number 增加的持续时间（秒）
	function CDOTA_Buff:AddDurationToAllStacks(bonusDuration)
		if bonusDuration <= 0 then
			return
		end
		if type(self._tStackData_) == "table" and #self._tStackData_ > 0 then
			local currentDuration = self:GetRemainingTime()
			self:SetDuration(currentDuration + bonusDuration, true)
			for i = 1, #self._tStackData_ do
				self._tStackData_[i].fDieTime = self._tStackData_[i].fDieTime + bonusDuration
				--print("第"..i.."层buff原定注销时点为"..self._tStackData_[i].fDieTime.."，增加持续时间"..bonusDuration.."秒，到期时点为"..self._tStackData_[i].fDieTime)
			end
			
			self:SendBuffRefreshToClients()
		end
	end


    -- 施加一次合并伤害
    
    -- local keys = {
    --     damage = 0,
    --     apply_damage_init = true, --在第一次施加时立即结算第一次伤害
    --     apply_damage_interval = 0.2, --伤害结算间隔
    --     ability = nil, --伤害来源
    --     attacker = caster, --伤害来源
    --     damage_type = DAMAGE_TYPE_PHYSICAL, --伤害类型
    --     damage_flags = DOTA_DAMAGE_FLAG_NONE, --伤害标志
    --     hd_flags = 0, --HD_DAMAGE_FLAG_NONE,
    --     margin_key = "default", --合并伤害的唯一标识，用于区分不同的合并伤害 不填会采用技能名
    -- }
    function CDOTA_BaseNPC:ApplyMergeDamage(keys)
        local damage = keys.damage
        if not damage or damage<=0 then
            return
        end
   
        local ability_source = keys.ability
        local margin_key = "default"
        local attacker = keys.attacker or self
        local damage_type = keys.damage_type or DAMAGE_TYPE_PHYSICAL  -- 同个合并伤害 要求伤害类型一致 否则都取最后施加的为最终伤害类型
        local damage_flags = keys.damage_flags or DOTA_DAMAGE_FLAG_NONE  --同上
        local hd_flags = keys.hd_flags or 0
        local apply_damage_interval = keys.apply_damage_interval or 0.2
		


        if self._tMergeDamage_ == nil then
            self._tMergeDamage_ = {}
        end

        if not keys.margin_key then
            if ability_source then
                margin_key = ability_source:GetAbilityName()
            end  
        else
            margin_key = keys.margin_key
        end

        local time = GameRules:GetGameTime()
        local apply_damage = false

        local index = 1
		for key, value in pairs(self._tMergeDamage_) do
            index = index + 1
        end

        if self._tMergeDamage_[margin_key] == nil then
            self._tMergeDamage_[margin_key] = {
                last_damage_time = time,
                damage_record = 0,
                damage_type = damage_type,
                damage_flags = damage_flags,
                hd_flags = hd_flags,
                attacker = attacker,
                ability_source = ability_source,
                margin_key = margin_key,
                apply_damage_interval = apply_damage_interval or 0.2,
                del_key_time = time  +apply_damage_interval * 2 +0.1,
                
            }
            local apply_damage_init = true
            if keys.apply_damage_init ~= nil then
                apply_damage_init = keys.apply_damage_init
            end
            if apply_damage_init==true then
                apply_damage = true
            end

            -- print("self._tMergeDamage_[margin_key].interval",self._tMergeDamage_[margin_key].apply_damage_interval)
        end
        -- print("apply_damage=",apply_damage)


        self._tMergeDamage_[margin_key].damage_record = self._tMergeDamage_[margin_key].damage_record + damage


        if apply_damage==true then

            local damageTable = {
                victim = self,
                attacker = attacker,
                damage = self._tMergeDamage_[margin_key].damage_record,
                damage_type = damage_type,
                damage_flags = damage_flags,
                hd_flags = hd_flags + HD_DAMAGE_FLAG_MERGE,
                ability = ability_source,
            }
            self._tMergeDamage_[margin_key].damage_record = 0
            self._tMergeDamage_[margin_key].last_damage_time = time
            self._tMergeDamage_[margin_key].del_key_time = time  +apply_damage_interval * 2 +0.1
            local damage = ApplyDamage(damageTable)
            if keys.on_damage_callback then
                damageTable.final_damage = damage
                xpcall(function() 
                    keys.on_damage_callback(damageTable)
                end, function (msg)
                    print(msg)
                    return ""
                    --   return debug.traceback()
                end)
        

            end
            if keys.on_kill_callback then
                if IsValid(self) and not self:IsAlive() then
                    damageTable.final_damage = damage
                    xpcall(function() 
                        keys.on_kill_callback(damageTable)
                    end, function (msg)
                        print(msg)
                        return ""
                        --   return debug.traceback()
                    end)
                end
            end
        end


        if index == 1 then
            -- print("开启一个计时器")
			local hParent = self
            if not IsValid(hParent) then
                return
            end
			hParent:GameTimer(hParent:GetUnitName() .. "_merge_damage_timer", FrameTime(), function()
				if not IsValid(self) then return end
                local pass = false
                local currentTime = GameRules:GetGameTime()

                for key, data in pairs(self._tMergeDamage_) do
                    -- print("key",key)
                    pass = true
                    if data.damage_record>0  then
                        -- print("data.last_damage_time + data.apply_damage_interval=",data.last_damage_time + data.apply_damage_interval)
                        if (data.last_damage_time + data.apply_damage_interval) < currentTime then
                            local damageTable = {
                                victim = self,
                                attacker = data.attacker,
                                damage = data.damage_record,
                                damage_type = data.damage_type,
                                damage_flags = data.damage_flags,
                                hd_flags = data.hd_flags + HD_DAMAGE_FLAG_MERGE,
                                ability = data.ability_source,
                            }
                            local damage = ApplyDamage(damageTable)
                          
                   
                            if keys.on_damage_callback then
                                damageTable.final_damage = damage
                                xpcall(function() 
                                    keys.on_damage_callback(damageTable)
                                end, function (msg)
                                     print(msg)
                                    -- return debug.traceback()
                                    return ""
                                end)
                            end
                            if keys.on_kill_callback and IsValid(self) and not self:IsAlive() then
                                damageTable.final_damage = damage
                                xpcall(function() 
                                    keys.on_kill_callback(damageTable)
                                end, function (msg)
                                     print(msg)
                                    -- return debug.traceback()
                                    return ""
                                end)
                            end
                            data.last_damage_time = currentTime
                            data.del_key_time = currentTime  +data.apply_damage_interval * 2 +0.1
                            data.damage_record = 0
                            -- print("apply_damage")
                        end
                    else
                        -- print("data.del_key_time",data.del_key_time)
                        -- print("time",currentTime)
                        if data.del_key_time < currentTime then
                            -- print("清除一个表")
                            self._tMergeDamage_[key] = nil
                        end
                    end
                end
                if pass then
                    return FrameTime()
                end

               

			
			end)
		end

        keys.unit = self
        --FireModifierEvent(MODIFIER_EVENT_ON_APPLY_MERGE_DAMAGE, keys, keys.attacker, keys.unit)

     

		
	end

    -- local keys = {
    --     attakcer = caster,
    --     ability_source = ability,
    --     damage = damage,
    -- }
    function CDOTA_BaseNPC:ApplyCleaveDamage(keys)

        keys.damage_type = keys.damage_type or DAMAGE_TYPE_PHYSICAL
        keys.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
        keys.apply_damage_interval = 0.03  --保证溅射伤害合并算即可
        keys.margin_key = string.format("cleave_%d", keys.attacker:entindex())
        keys.apply_damage_init = false


        self:ApplyMergeDamage(keys)


    end

    --caster
    --ability
    --height选填，默认150
    --duration
    --turn选填，转圈
    function CDOTA_BaseNPC:FlyAway(keys)
        self:RemoveModifierByName("modifier_generic_fly")
        local defaultKeys = {
            height = keys.height or 150,
            duration = keys.duration or 0.5,
            turn = keys.turn or false,
        }
        local modifier = self:AddNewModifier(keys.caster, keys.ability, "modifier_generic_fly", defaultKeys)
        return modifier
    end

    -- 击退目标(以给速度的方式，不会打断其他运动)
    function CDOTA_BaseNPC:GiveSpeed(caster, ability, dir, distance, speed, bIsKnockBack,bFindPath)
        if not bFindPath then
            bFindPath = true
        else
            bFindPath = false
        end
        if not ability then
            print("Error:givespeed 需要技能实体")
            return
        end
        if not self.__speed_modifier then
            self.__speed_modifier = {}
        end
        local duration = distance / speed

        if not IsValid(self.__speed_modifier[ability]) then
            self.__speed_modifier[ability] = self:AddNewModifier(caster, ability, "modifier_generic_dir_speed", {
                duration = math.max(duration,FrameTime()+0.01)
            })
        else
            self.__speed_modifier[ability]:SetDuration(math.max(duration,FrameTime()+0.01), false)
        end
        if IsValid(self.__speed_modifier[ability]) then
            self.__speed_modifier[ability]:InitKnockBack(dir, speed)
            self.__speed_modifier[ability]:SetShouldFindPath(bFindPath)
        end

        return modifier
    end
end


if IsClient() then
    -- function C_DOTA_BaseNPC_Hero:HDGetPrimaryStatValue()
    --     local value = self:GetPrimaryStatValue()
    --     if GetPrimaryAttribute(self, nil)==DOTA_ATTRIBUTE_ALL  then
    --         value = self:GetStrength()
    --         local agility = self:GetAgility()
    --         if value<agility then
    --             value = agility
    --         end
    --         local int = self:GetIntellect(false)
    --         if value<int then
    --             value = int            
    --         end
    --     end
    --     return value
    -- end

    function C_DOTA_BaseNPC:IsFlying()
        local value = GetFlying(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end

    function C_DOTA_BaseNPC:IsFlyingPathing()
        local value = GetFlyingPathing(self, {})
        if value>0 then
            return true
        else
            return false
        end
    end


    -- 客户端无法判断是不是巨人单位
    function C_DOTA_BaseNPC:IsGiant()
        return false
    end

    function C_DOTA_BaseNPC:IsImmuneDisadvantagedTerrain_Slow()
        if GetImmuneDisadvantagedTerrain_Slow(self)>=1 then
            return true
        end
        if self:IsFlying() or self:IsFlyingPathing()  then
            return true
        end
        return false
    end

    function C_DOTA_BaseNPC:IsInInvisibilityCooldown()
        if self:HasModifier("modifier_chaotic_aura_invisibility_cooldown") or self:HasModifier("modifier_chaotic_aura_invisibility_cooldown") then
            return true
        end
        return false
        
    end



    function C_BaseEntity:Timer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("Timer")
		end
		self:SetContextThink(
		sContextName,
		function()
			local result = funcThink()
			if type(result) == "number" then
				result = math.max(FrameTime(), result)
			end
			return result
		end,
		fInterval
		)
		return sContextName
	end
	-- 游戏计时器
	function C_BaseEntity:GameTimer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("GameTimer")
		end
		local fTime = GameRules:GetGameTime() + math.max(FrameTime(), fInterval)
		return self:Timer(
		sContextName,
		fInterval,
		function()
			if GameRules:GetGameTime() >= fTime then
				local result = funcThink()
				if type(result) == "number" then
					fTime = fTime + math.max(FrameTime(), result)
				end
				return result
			end
			return 0
		end
		)
	end
	-- 暂停计时器
	function C_BaseEntity:StopTimer(sContextName)
		self:SetContextThink(sContextName, nil, 0)
	end

  
    
    function C_DOTA_BaseNPC_Hero:GetStrengthGain()
        if self.originStrGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originStrGain = math.max(kv["AttributeStrengthGain"] or 0,0)
            else
                self.originStrGain = 0
            end
        end
        return self.originStrGain 
    end
    function C_DOTA_BaseNPC_Hero:GetAgilityGain()
        if self.originAgiGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originAgiGain = math.max(kv["AttributeAgilityGain"] or 0,0)
            else
                self.originAgiGain = 0
            end
        end
        return self.originAgiGain 
    end
    function C_DOTA_BaseNPC_Hero:GetIntellectGain()
        if self.originIntGain==nil then
            -- 这样就不用每次都读表了
            local kv = KeyValues.UnitKV[self:GetUnitName()]
            if not kv then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            end
            if kv then
                self.originIntGain = math.max(kv["AttributeIntelligenceGain"] or 0,0)
            else
                self.originIntGain = 0
            end
        end
        return self.originIntGain 
    end




    function C_DOTABaseAbility:GetEffectGain(rate)
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
            rate = rate or 1,
        }
        local value = GetChaoticSpellEffectGain(caster,keys)
        return value
    end

    --天赋，精通cy
    function C_DOTABaseAbility:GetTalentGain(rate)
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
            rate = rate or 1,
        }
        local value = GetTalentEffectGain(caster,keys)
        return value
    end

    function C_DOTABaseAbility:GetManaCostGain()
        local caster = self:GetCaster()
        local keys = {
            ability=self,
            caster = caster,
        }
        local value = GetChaoticSpellManaCostGain(caster,keys)
        return value
    end



    function C_DOTA_BaseNPC:GetRuneType(abilityName)
		local nPlayerID = self:GetPlayerOwnerID()
        if abilityName.GetAbilityName then
            abilityName = abilityName:GetAbilityName()
        end
		

        local data = RuneSync.GetEquipped(nPlayerID, abilityName)
        if data then return tonumber(data.runeType) or 0 end


		return 0
	
	end


    function C_DOTABaseAbility:GetRuneType()
        
        if not self.runetType then
            local caster = self:GetCaster()
            self.runetType = caster:GetRuneType(self)
        end
        return  self.runetType
    end



    function C_DOTA_BaseNPC:GetManaPercent()
        if self.GetMana then
            local max_mana = self:GetMaxMana()
            if max_mana>0 then
                return self:GetMana()/ max_mana *100
            end
        end
		return 0
	
	end


    
    function C_DOTABaseAbility:GetAutoCastState()
        if not self.record_autoCastState then
            self.record_autoCastState = 0
        end
        return self.record_autoCastState==1
    end



    function CDOTA_Buff:GetUnlock(key)
        if not self or self:IsNull() then
            print("Error: buff不合法")
            return -1
        end
        local ability = self:GetAbility()
        if not ability then
            print("Error: 技能不存在")
            return -1
        end
        return ability:GetUnlock(key)
    
    end
    --客户端只能获取一个等级 无法获取多重解锁
    --有多重获取效果走服务端
    function C_DOTABaseAbility:GetUnlock(key)
        if not self or self:IsNull() then
            print("Error: 技能不合法")
            return -1
        end
        local caster = self:GetCaster()
        if not caster or caster:IsNull() then
            print("Error: 施法者不合法")
            return -1
        end
        if not caster:IsRealHero() then
            print("Error:只有英雄才能使用这个API")
            return -1
        end
           --该技能需要从网表拿等级数据 自定义变量拿不到该值
        local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
        local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
        if coreUnlockKV then
            return coreUnlockKV.coreUnlock
        end
    
        return 0
    end

    function C_DOTABaseAbility:GetChaoticSpellType()
        if not self.ChaoticSpellType then
            self.ChaoticSpellType = "nil"
            local kv =  KeyValues.ability_bonus_info[self:GetAbilityName()]
            if kv and kv.IsChaoticEraSpell and kv.IsChaoticEraSpell==1 then
                local type = kv.ChaoticSpellType
                if type then
                    self.ChaoticSpellType = string.sub(type, 2)
                end
            end
        end

        

        return self.ChaoticSpellType
    end


    -- 是否是乱纪元技能
    function C_DOTABaseAbility:IsChaoticEraSpell()
        if not self.bIsChaoticEraSpell then
            self.bIsChaoticEraSpell =0
            local kv =  KeyValues.ability_bonus_info[self:GetAbilityName()]
            if kv and kv.IsChaoticEraSpell and kv.IsChaoticEraSpell==1 then
                self.bIsChaoticEraSpell = 1
            end
        end
        if self.bIsChaoticEraSpell==1 then
            return true
        end
        return false
    end
    -- 是否火焰技能
    function C_DOTABaseAbility:IsFireSpell(key)
        if not self.bIsFireSpell then
            self.bIsFireSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.FireAttribute then
                self.bIsFireSpell = 1
            end
        end
        if self.bIsFireSpell==1 then
            return true
        end
        return false
        
    end
    -- 是否冰技能
    function C_DOTABaseAbility:IsIceSpell(key)
        if not self.bIsIceSpell then
            self.bIsIceSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.IceAttribute then
                self.bIsIceSpell = 1
            end
        end
        if self.bIsIceSpell==1 then
            return true
        end
        return false
        
    end
    -- 是否闪电技能
    function C_DOTABaseAbility:IsLightningSpell(key)
        if not self.bIsLightningSpell then
            self.bIsLightningSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.LightningAttribute then
                self.bIsLightningSpell = 1
            end
        end
        if self.bIsLightningSpell==1 then
            return true
        end
        return false
        
    end 
    -- 是否神圣技能
    function C_DOTABaseAbility:IsHolySpell(key)
        if not self.bIsHolySpell then
            self.bIsHolySpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.HolyAttribute then
                self.bIsHolySpell = 1
            end
        end
        if self.bIsHolySpell==1 then
            return true
        end
        return false
        
    end 
    -- 是否暗影技能
    function C_DOTABaseAbility:IsDarkSpell(key)
        if not self.bIsDarkSpell then
            self.bIsDarkSpell = 0
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.DarkAttribute then
                self.bIsDarkSpell = 1
            end
        end
        if self.bIsDarkSpell==1 then
            return true
        end
        return false
        
    end 

    -- 获取环等级
    function C_DOTABaseAbility:GetAbilityClassLevel()
        if not self.iChaoticEraSpellClassLevel then
            self.iChaoticEraSpellClassLevel = -1 
            local abilityName = self:GetAbilityName()
            local kv = KeyValues.ability_bonus_info[abilityName]
            if kv and kv.ChaoticSpell_ClassLevel then
                self.iChaoticEraSpellClassLevel = kv.ChaoticSpell_ClassLevel
            end
        end
      
        return self.iChaoticEraSpellClassLevel
    end






    -- 是否为昆虫
    function C_DOTA_BaseNPC:IsInsect()
        if self.bIsInsectCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsInsectCreature = kv["IsInsectCreature"] or 0
            else
                self.bIsInsectCreature = 0
            end
            
        end
        return self.bIsInsectCreature==1
    end

    -- 是否为恶魔
    function C_DOTA_BaseNPC:IsDemon()
        if self.bIsDemonCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsDemonCreature = kv["IsDemonCreature"] or 0
            else
                self.bIsDemonCreature = 0
            end
            
        end
        return self.bIsDemonCreature==1
    end

    -- 是否为不死者
    function C_DOTA_BaseNPC:IsUndead()
        if self.bIsUndyingCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsUndyingCreature = kv["IsUndyingCreature"] or 0
            else
                self.bIsUndyingCreature = 0
            end
            
        end
        return self.bIsUndyingCreature==1
    end
    function IsUndead(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsUndyingCreature = kv["IsUndyingCreature"] or 0
            return bIsUndyingCreature==1
        end
        return false
    end

    -- 是否为娜迦族
    function C_DOTA_BaseNPC:IsNaga()
        if self.bIsNagaCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsNagaCreature = kv["IsNagaCreature"] or 0
            else
                self.bIsNagaCreature = 0
            end
            
        end
        return self.bIsNagaCreature==1
    end
    function IsNagaCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsNagaCreature = kv["IsNagaCreature"] or 0
            return bIsNagaCreature==1
        end
        return false
    end

    -- 是否为植物系怪物
    function C_DOTA_BaseNPC:IsBotanicalCreature()
        if self.bIsBotanicalCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsBotanicalCreature = kv["IsBotanicalCreature"] or 0
            else
                self.bIsBotanicalCreature = 0
            end
            
        end
        return self.bIsBotanicalCreature==1
    end
    function IsBotanicalCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsBotanicalCreature = kv["IsBotanicalCreature"] or 0
            return bIsBotanicalCreature==1
        end
        return false
    end


    -- 是否为混沌生物
    function C_DOTA_BaseNPC:IsChaosCreature()
        if self.bIsChaosCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsChaosCreature = kv["IsChaosCreature"] or 0
            else
                self.bIsChaosCreature = 0
            end
            
        end
        return self.bIsChaosCreature==1
    end
    function IsChaosCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsChaosCreature = kv["IsChaosCreature"] or 0
            return bIsChaosCreature==1
        end
        return false
    end


    -- 是否为y元素生物
    function C_DOTA_BaseNPC:IsElementCreature()
        if self.bIsElementCreature==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsElementCreature = kv["IsElementCreature"] or 0
            else
                self.bIsElementCreature = 0
            end
            
        end
        return self.bIsElementCreature==1
    end
    function IsElementCreature(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsElementCreature = kv["IsElementCreature"] or 0
            return bIsElementCreature==1
        end
        return false
    end

    -- 是否为契约召唤
    function C_DOTA_BaseNPC:IsIndentureSummon()
        if self.bIsIndentureSummon==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsIndentureSummon = kv["IsIndentureSummon"] or 0
            else
                self.bIsIndentureSummon = 0
            end
            
        end
        return self.bIsIndentureSummon==1
    end
    function IsIndentureSummon(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsIndentureSummon = kv["IsIndentureSummon"] or 0
            return bIsIndentureSummon==1
        end
        return false
    end

    -- 是否为精灵召唤
    function C_DOTA_BaseNPC:IsSpriteSummon()
        if self.bIsSpriteSummon==nil then
            -- 这样就不用每次都读表了
            local kv
            if self:IsHero() then
                kv = KeyValues.HeroKV[self:GetUnitName()]
            else
                kv = KeyValues.UnitKV[self:GetUnitName()]
            end
            if kv then
                self.bIsSpriteSummon = kv["IsSpriteSummon"] or 0
            else
                self.bIsSpriteSummon = 0
            end
            
        end
        return self.bIsSpriteSummon==1
    end
    function IsSpriteSummon(unitName)
        local kv = KeyValues.UnitKV[unitName]
        if kv then
            local bIsSpriteSummon = kv["IsSpriteSummon"] or 0
            return bIsSpriteSummon==1
        end
        return false
    end




    function C_DOTA_BaseNPC:GetPotionEffectIndex(effectRate)
        local index = effectRate or 1
        local tParams = {
            effectRate = index,
            caster = self,
        }
        local value = GetGloabal_ChaoticEra__PotionEffect(self, tParams)
        return (100 + value)*0.01
    end

    -- 获取主属性数值  如果是全才 则返回其最高项
    function C_DOTA_BaseNPC:HDGetPrimaryStatValue()
        if self:IsRealHero() then
            local value = 0
            local parimaryValue = GetPrimaryAttribute(self, nil)
            if parimaryValue == DOTA_ATTRIBUTE_ALL then
                value = self:GetStrength()
                local agility = self:GetAgility()
                if value < agility then
                    value = agility
                end
                local int = self:GetIntellect(false)
                if value < int then
                    value = int
                end
            else
                if parimaryValue == DOTA_ATTRIBUTE_STRENGTH then
                    value = self:GetStrength()
                elseif parimaryValue == DOTA_ATTRIBUTE_AGILITY then
                    value = self:GetAgility()
                elseif parimaryValue == DOTA_ATTRIBUTE_INTELLECT then
                    value = self:GetIntellect()
                end
            end
            return value
        else
            return self:GetDamageMax() * 0.8
        end

    end

end





-- 获取游戏玩家数
-- 只要这个玩家尝试去拉数据了 那就算一个
function GetPlayerCount()
    return _G.GAME_PLAYER_number or 0;
end


-- 获取成功载入的玩家数量
function GetLoginPlayerCount()
	return GAME_LOGIN_SUCCESS_INDEX or 0
end







-- 所有玩家都登录成功了吗？
function IsAllPlayerLoginFinish()
    local playerCount = GetPlayerCount()
	if not playerCount or not GAME_LOGIN_SUCCESS_INDEX then
		return false
	end
	if playerCount<=0 then
		return false
	end
	if GAME_LOGIN_SUCCESS_INDEX<=0 then
		return false
	end
	if playerCount==GAME_LOGIN_SUCCESS_INDEX then
		return true
	end
	return false
end


function GetChallengeDifficulty()
	return GAME_CHANLLENGE_DIFFICULTY or 0
end

function SetChallengeDifficulty(value)
	GAME_CHANLLENGE_DIFFICULTY = math.min(value,3)

    UpdateChallenge_Difficulty()
end


function GetCurrentRound()
    return GAME_ROUND or -1
end

function SetCurrentRound(value)
    _G.GAME_ROUND = tonumber(value)
    UpdateGameRound()
end







function IsEnemy(unit1, unit2)
	if unit1:GetTeamNumber() == unit2:GetTeamNumber() then
		return false
	else
		return true
	end
end





-- function SnapToGrid(size, location)
--     if size % 2 ~= 0 then
--         location.x = SnapToGrid32(location.x)
--         location.y = SnapToGrid32(location.y)
--     else
--         location.x = SnapToGrid64(location.x)
--         location.y = SnapToGrid64(location.y)
--     end
-- end

-- function SnapToGrid64(coord)
--     return 64*math.floor(0.5+coord/64)
-- end

-- function SnapToGrid32(coord)
--     return 32+64*math.floor(coord/64)
-- end

-- 坐标标准化
function SnapToGrid(radius, location)
    local newVector = Vector(0,0,0)
    radius = radius * 2
    newVector.x =   radius*math.floor(0.5+location.x/radius)
    newVector.y = radius*math.floor(0.5+location.y/radius)
    newVector.z = location.z
    return newVector
end

-- 获取药剂的KV
function GetPotionSpecial(potion,key)
    local potionName
    if type(potion) == "table" then
        potionName = string.sub(potion:GetName(),10,70)
    else
        potionName = potion
    end
    local kv = KeyValues.game_shop_chaotic_era_potion[potionName]
    if kv then
        if kv.AbilityValues then
            return kv.AbilityValues[key] or 0
        end
    end

    return 0 
end

function GetPotionTexture(potion)
    local potionName
    if type(potion) == "table" then
        potionName = string.sub(potion:GetName(),10,70)
    else
        potionName = potion
    end
    local kv = KeyValues.game_shop_chaotic_era_potion[potionName]
    if kv then
        return kv.texture or ""
    end

    return 0 
end

function GetPotionDuration(potion)
    local potionName
    if type(potion) == "table" then
        potionName = string.sub(potion:GetName(),10,70)
    else
        potionName = potion
    end
    local kv = KeyValues.game_shop_chaotic_era_potion[potionName]
    if kv then
        if kv.AbilityValues then
            return kv.AbilityValues["duration"] or 0
        end
    end

    return 0 
end



-- 获取乱纪元Buff KV
function GetChaticEraCreep_BuffSpecial(ChaticEraCreep_Buff,key)
    local ChaticEraCreep_BuffName
    if type(ChaticEraCreep_Buff) == "table" then
        ChaticEraCreep_BuffName = ChaticEraCreep_Buff:GetName()
    else
        ChaticEraCreep_BuffName = ChaticEraCreep_Buff
    end
    local kv = KeyValues.chatic_era_creep_buff[ChaticEraCreep_BuffName]
    if kv then
        if kv.AbilityValues then
            return kv.AbilityValues[key] or 0
        end
    end

    return 0 
end


function GetChaticEraCreep_BuffTexture(ChaticEraCreep_Buff)
    local ChaticEraCreep_BuffName
    if type(ChaticEraCreep_Buff) == "table" then

        ChaticEraCreep_BuffName =ChaticEraCreep_Buff:GetName()
    else
        ChaticEraCreep_BuffName = ChaticEraCreep_Buff
    end

    local kv = KeyValues.chatic_era_creep_buff[ChaticEraCreep_BuffName]
    if kv then
        return kv.texture or ""
    end

    return 0 
end



-- 获取乱纪元词条KV
function GetChaticEra_BuffCardSpecial(buff,key,level)
    local _BuffName
    if type(buff) == "table" then
        _BuffName = string.sub(buff:GetName(),10,70)
    else
        _BuffName = buff
    end
    local kv = KeyValues.map_effect[_BuffName]
    -- print("_BuffName=",_BuffName)
    -- PrintTable(KeyValues.map_effect)
    if kv then
        -- print("level=",level)
        local keyList = {
            "AbilityValues_Primary",
            "AbilityValues_Middle",
            "AbilityValues_Advanced",
        }
        local keyName = keyList[level]
        -- print("keyName=",keyName)
        if kv[keyName] then
            return kv[keyName][key] or 0
        end
    end

    return 0 
end


function IsInHardMode(unit)
    if unit:HasModifier("modifier_item_hd_chaotic_demon") or unit:HasModifier("modifier_item_hd_chaotic_demon_summon") then
        return true
    end
end

function IsEnemy(unit1, unit2)
	if unit1:GetTeamNumber() == unit2:GetTeamNumber() then
		return false
	else
		return true
	end
end


function GetChaticEra_Artifact_Special(buff,key)
    local _BuffName
    if type(buff) == "table" then
        _BuffName = string.sub(buff:GetName(),10,70)
    else
        _BuffName = buff
    end
    local kv = KeyValues.artifact[_BuffName]
    if kv then
        if kv["AbilityValues"] then
            return kv["AbilityValues"][key] or 0
        end
    end

    return 0 
end






function GetWhitelist(nPlayerID)
    if  IsInToolsMode() or tostring(PlayerResource:GetSteamID(nPlayerID))=="76561198284686620" or tostring(PlayerResource:GetSteamID(nPlayerID))=="76561198828335572"  then
        -- GameRules:SendCustomMessage("我开挂了", DOTA_TEAM_GOODGUYS, nPlayerID)
        -- local gameEvent = {}
        -- gameEvent["player_id"] = nPlayerID
        -- gameEvent["teamnumber"] =-1
        -- gameEvent["message"] = "#HUD_DEBUG_NOTE"
        -- FireGameEvent( "dota_combat_event_message", gameEvent )

        return true
    end
    return false
end

print("ServertoClientProperty123")
function CDOTA_Modifier_Lua:ServertoClientProperty(PropertyName)
    self:SetHasCustomTransmitterData(true)
	   
	if IsServer() then
		self.customTransmitterData = self.customTransmitterData or {}
		if type(PropertyName) == "string" then
			self.customTransmitterData[PropertyName] = self[PropertyName]  -- value is the table {Property = value}
			print("PropertyName: " .. PropertyName .. " value: " .. self[PropertyName])
		elseif type(PropertyName) == "table" then
			for key, val in pairs(PropertyName) do
				self.customTransmitterData[key] = self[key]  -- value is the table {Property = value}
			end
		end
	end

    if IsServer() then
        function self:AddCustomTransmitterData()
            return self.customTransmitterData
        end
    end
	
    if IsClient() then
        function self:HandleCustomTransmitterData(tData)
            for key, val in pairs(tData) do
                self[key] = val
            end
        end
    end
end


function GetChaoticEraClass(target)
    if not IsServer() then return end
    if not target then return end
    if target:HasModifier("modifier_item_chaotic_class_range_phy") then
        return 1
    elseif target:HasModifier("modifier_item_chaotic_class_melee_phy") then
        return 2 
    -- elseif target:HasModifier("modifier_item_chaotic_class_tank") then
    --     return 3
    elseif target:HasModifier("modifier_item_chaotic_class_ass") then
        return 4
    -- elseif target:HasModifier("modifier_item_chaotic_class_spell") then
    --     return 5
    elseif target:HasModifier("modifier_item_chaotic_class_summon") then
        return 6
    end
    return 0
end

function GetIceSpellCount(target)
    if not IsServer() then return end
    if not target then return end
    
    local parent = target
    local number = 0

    for i=0, parent:GetAbilityCount() - 1 do
        local Ability = parent:GetAbilityByIndex(i)
        if Ability ~= nil and Ability:IsIceSpell() then
            number = number + 1
        end
    end
    -- 圣物：急冻冰晶
    local artifact_69 = target:FindModifierByName("modifier_item_hd_snow_piece_effects")
    if artifact_69 and artifact_69.level >= 30 then
        number = number + artifact_69.stack_3
    end
    
    -- print("冰属性技能个数="..number)
    return number
end

--act3所用函数合集
function GetAdaptDamage(fullattack, fullattack_index, atb, atb_index)
    local table = {
        damage = 0,
        type = DAMAGE_TYPE_PHYSICAL,
    }

    if fullattack and fullattack_index and atb and atb_index then
        local attack_damage = fullattack * fullattack_index
        local attribute_damage = atb * atb_index
        table.damage = math.max(attack_damage, attribute_damage)
        print("攻击伤害："..attack_damage.." 属性伤害："..attribute_damage.." 最终伤害："..table.damage)
        if attack_damage >= attribute_damage then
            table.type = DAMAGE_TYPE_PHYSICAL
        else
            table.type = DAMAGE_TYPE_MAGICAL
        end
    end

    return table
end

--@param keys.target 目标单位
--@param keys.ability 被减cd的技能
--@param keys.cdr 冷却减少的秒数
--@param keys.unrefresh_pct 不可刷新刷新冷却减少效率
function CooldownReduce_Seconds(keys)
    local target = keys.target
    local ability = keys.ability
    local cd = keys.cdr
    local unrefresh_pct = keys.unrefresh_pct or 0
    if not target or not ability or not cd then return end
    if not IsServer() then return end

    if not ability:IsCooldownReady() then
        local cd_reduce = ability:IsRefreshable() and cd or cd*unrefresh_pct*0.01
        if cd_reduce > 0 then
            local newcooldown = ability:GetCooldownTimeRemaining() - cd_reduce
            ability:EndCooldown()
            ability:StartCooldown(newcooldown)
        end
    end
end
--@param keys.target 目标单位
--@param keys.ability 被减cd的技能
--@param keys.cdr 冷却减少百分比
--@param keys.unrefresh_pct 不可刷新刷新冷却减少效率
function CooldownReduce_Pct(keys)
    local target = keys.target
    local ability = keys.ability
    local cd = keys.cdr*0.01
    local unrefresh_pct = keys.unrefresh_pct or 0
    if not target or not ability or not cd then return end
    if not IsServer() then return end

    if not ability:IsCooldownReady() then
        local cd_reduce = ability:IsRefreshable() and cd or cd*unrefresh_pct*0.01
        if cd_reduce > 0 then
            local newcooldown = ability:GetCooldownTimeRemaining()*(1-cd_reduce)
            ability:EndCooldown()
            ability:StartCooldown(newcooldown)
        end
    end
end