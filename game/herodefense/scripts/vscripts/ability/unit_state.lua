LinkLuaModifier( "modifier_unit_cooldownReduction", "ability/unit_state", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_cooldownReduction_sheild", "ability/unit_state", LUA_MODIFIER_MOTION_NONE )
if unit_state == nil then
	unit_state = class({})
end


function unit_state:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end

function unit_state:GetIntrinsicModifierName() return "modifier_unit_cooldownReduction" end

function unit_state:GetAbilityTextureName()
	if _G.GetUnitData_UnitEntIndex ~= -1 then
		local hUnit = EntIndexToHScript(_G.GetUnitData_UnitEntIndex)
		local sFunctionName = _G.GetUnitData_FunctionName
		_G.GetUnitData_UnitEntIndex = -1
		_G.GetUnitData_FunctionName = ""
		if IsValid(hUnit) and type(_G[sFunctionName]) == "function" then
			return tostring(_G[sFunctionName](hUnit))
		else
			return ""
		end
	end
	local tData = {}
	return json.encode(tData)
end
modifier_unit_cooldownReduction = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unit_cooldownReduction:IsHidden()return false end
function modifier_unit_cooldownReduction:IsDebuff()return false end
function modifier_unit_cooldownReduction:IsStunDebuff()return false end
function modifier_unit_cooldownReduction:IsPurgable()return false end
function modifier_unit_cooldownReduction:IsPurgeException() 	return false end
function modifier_unit_cooldownReduction:RemoveOnDeath() return false end
function modifier_unit_cooldownReduction:GetTexture() return "oracle/immortal/oracle_fortunes_end" end
function modifier_unit_cooldownReduction:OnCreated(table)
	-- if IsClient() then
	-- 	local parent = self:GetParent()
	-- 	self.effect_cast1 = ParticleManager:CreateParticle( "particles/test/hp.vpcf", PATTACH_OVERHEAD_FOLLOW, parent )
	-- 	ParticleManager:SetParticleControl( self.effect_cast1,1, Vector(15000,0,0) )
	-- 	ParticleManager:SetParticleControlEnt( self.effect_cast1, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetAbsOrigin(), true )
	-- 	-- ParticleManager:SetParticleControlForward(self.effect_cast1, 0,caster:GetForwardVector())  --方向
	-- 	self:AddParticle( self.effect_cast1, false, false, -1, true, false )
	-- 	self:StartIntervalThink(0.1)
		
	-- end
	
    if IsServer() then
		self.false_death_count = 0

		self.invulnerable_time = 0
        self.parent = self:GetParent()
		player:EachPlayer(function(n, playerID)
			local Targetplayer = PlayerResource:GetPlayer(playerID)
			if Targetplayer then
				local hero = Targetplayer:GetAssignedHero()
				if hero then
					if hero:CanEntityBeSeenByMyTeam(parent) then
						CustomGameEventManager:Send_ServerToAllClients(
							"elite_health_bar_create",
							{
								enemyIndex = parent:entindex()
							}
						)
						self.isShowHpBar = true
						return true
					end
				end
			end
		   
		end)

     
		if self.parent:IsRealHero() and self.parent:IsOwnedByAnyPlayer() then
			self:StartIntervalThink(0.5)

		end
    end
    
end
function modifier_unit_cooldownReduction:OnStart(keys)
    -- print("on start")
end


function modifier_unit_cooldownReduction:OnIntervalThink(table)
	-- if IsClient() then
	-- 	-- print("123",self:GetParent():GetHealthPercent())
	-- 	ParticleManager:SetParticleControl( self.effect_cast1,12, Vector(self:GetParent():GetHealthPercent(),0,0) )
	-- end
    if IsServer()  then
		


		local parent = self:GetParent()
		local main_attribute = GetPrimaryAttribute(self:GetParent(), {})
		if main_attribute==-1 then
			return
		end
		local current_main_attribute = parent:GetPrimaryAttribute()
		if current_main_attribute~=main_attribute then
			parent:SetPrimaryAttribute(main_attribute)
			main_attribute = current_main_attribute
		end

		-- 只有英雄才记录自动施法状态
		for i=0, self:GetParent():GetAbilityCount() - 1 do
			local Ability = self:GetParent():GetAbilityByIndex(i)
			if Ability ~= nil then
				-- print("Ability=",Ability:GetAbilityName())
				-- 如果没有进入自动施法 那么是不会记录到王彪得
				Ability:UpdateAutoCastState(Ability:GetAutoCastState() )
			end
		end
    end
    
end

function modifier_unit_cooldownReduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,  --常数生命值
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, --百分比生命值


		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,  --生命恢复
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,    --魔法恢复
		MODIFIER_PROPERTY_MANA_BONUS, --常数魔法值


        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE, --攻击距离覆写
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE,


		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,

		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --护甲
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL, --额外伤害
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,  --暴击
		-- MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE, --目标暴击
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,



		-- 攻击力相关
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, --基础攻击力
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, --攻击力百分比  （基于基础攻击力）
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,--攻击力百分比


		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	if self:GetParent():GetPlayerOwnerID()~=-1 then
		table.insert(funcs,MODIFIER_PROPERTY_FIXED_DAY_VISION)
		table.insert(funcs,MODIFIER_PROPERTY_FIXED_NIGHT_VISION)
		table.insert(funcs,MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING)
		table.insert(funcs,MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING)
		if self:GetParent():IsHero() then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
			table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
			table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
		end
	end




    return funcs
end



function modifier_unit_cooldownReduction:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},  --生命汲取
		MODIFIER_EVENT_ON_DEATH= {nil, self:GetParent()},
		MODIFIER_EVENT_ON_RESPAWN= {self:GetParent(), nil},
	}
	-- if self:GetParent():IsRealHero() then
	-- 	funcs[MODIFIER_EVENT_ON_DEATH]= {nil, self:GetParent()}
	-- 	funcs[MODIFIER_EVENT_ON_RESPAWN]= {nil, self:GetParent()}
	-- end
	return funcs
end


function modifier_unit_cooldownReduction:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		if unit==self:GetParent() then
			self.invulnerable_time = 0
			local data = GetReinacarnateModifier(unit,keys)
			if data then
				local modifier = data.modifier
				-- DeepPrint(data)
				if data.invulnerable_time then
					self.invulnerable_time = data.invulnerable_time
				end
				unit:GameTimer(0.1, function()
					local pos = unit:GetAbsOrigin()
					local delay = data.time or 0.03
					unit:SetTimeUntilRespawn(delay)
					unit:GameTimer(delay, function()
						if not unit:IsAlive() then --防止二次复活
							unit:RespawnHero(false,false)
							FindClearSpaceForUnit( unit, pos, true )
						end
					end)
				end)
				modifier:OnReincarnateTrigger(keys)
				-- body
			end

			local mana = unit:GetMana()
			if mana then
				unit.dead_mana = mana
			end
		end
	end
end

function modifier_unit_cooldownReduction:OnRespawn(keys)
	if IsServer() then
		local unit = keys.unit
		if self:GetParent() == unit and self.invulnerable_time>0 then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invulnerable", {duration=self.invulnerable_time}) --提供无敌防止死亡
			self.invulnerable_time = 0
		end

		if unit.dead_mana and Game_State:IsInBattle() then
            unit:SetMana(math.max(unit.dead_mana,unit:GetMaxMana()*0.2))
        end
	end
end






function modifier_unit_cooldownReduction:GetModifierHealthBonus() 
	local bonus = GetBonusHealth(self:GetParent(),{})
	return bonus
end



function modifier_unit_cooldownReduction:GetModifierExtraHealthPercentage() 
	return GetBonusHealth_Percentage(self:GetParent(),{})
end




function modifier_unit_cooldownReduction:GetModifierManaBonus() 
	local bonus = GetBonusMana(self:GetParent(),{})
	return bonus
end







function modifier_unit_cooldownReduction:GetModifierConstantHealthRegen()
	return GetHealthRegen(self:GetParent(), {})
end

function modifier_unit_cooldownReduction:GetModifierConstantManaRegen()
	return GetManaRegen(self:GetParent(), {})
end





-- 仅用于显示护盾值
function modifier_unit_cooldownReduction:GetModifierIncomingDamageConstant(keys)
	if IsClient() then
		local value = GetTotalBlock(self:GetParent(),keys) + GetTotalBlockLowLevel(self:GetParent(),keys) + GetTotalBlockHightLevel(self:GetParent(),keys)
		-- 护盾值太大了会导致卡顿与显示不清
		return math.min(value,100000)
	end
end


function modifier_unit_cooldownReduction:GetModifierPercentageCooldown(keys) 
	local hUnit = self:GetParent()
	local value = GetCooldownReduction(hUnit, keys or {})
	-- print("cooldownReduction="..cooldownReduction)
	return value
	-- return (self:GetStackCount()/1000) 
end



function modifier_unit_cooldownReduction:GetModifierPercentageCasttime(keys)
    -- if IsServer() then
    --     return self:GetParent():GetHDCastPoint()
    -- end
	return  GetModifyCastPoint(self:GetParent(), keys)
end



function modifier_unit_cooldownReduction:GetModifierTotalDamageOutgoing_Percentage(keys)	


	local iDamageFlags = keys.damage_flags
	local iDamageType = keys.damage_type
	local iDamageCategory = keys.damage_category
	local fPercent = 100
	local hAttacker = keys.attacker
	local hTarget = keys.target
	local hAbility = keys.inflictor

	if not keys.target then
        keys.target = keys.unit
    end
	if iDamageCategory ~= DOTA_DAMAGE_CATEGORY_ATTACK then
		RECORD_SYSTEM_DUMMY.iLastRecord = keys.record
	end

	if IsValid(hAttacker) then

		fPercent = fPercent * (1 + GetTotalDamageOutgoing(hAttacker, keys) * 0.01)
		fPercent = fPercent *  (GetOutgoingDamagePercentFinal(hAttacker, keys)*0.01)
	end
	-- print("cooldownReduction="..cooldownReduction)
	-- print("final mul=",fPercent - 100)
	return fPercent - 100

end







function modifier_unit_cooldownReduction:GetModifierCastRangeBonusStacking(keys)	
	local hUnit = self:GetParent()
	local value = GetCastRangeBonus(hUnit, keys or {})
	-- print("cooldownReduction="..cooldownReduction)
	return value

end


function modifier_unit_cooldownReduction:GetModifierAttackRangeBonus(keys)	
	local hUnit = self:GetParent()
	local value = GetAttackRangeBonus(hUnit, keys or {})
	-- print("cooldownReduction="..cooldownReduction)
	return value

end
function modifier_unit_cooldownReduction:GetModifierAttackRangeBonusPercentage(keys)	
	local hUnit = self:GetParent()
	local value = GetAttackRangeBonusPercentage(hUnit, keys or {})
	-- print("cooldownReduction="..cooldownReduction)
	return value

end

function modifier_unit_cooldownReduction:GetModifierAttackRangeOverride(keys)	
	local hUnit = self:GetParent()
	local value = GetAttackRangeOverride(hUnit, keys or {})
	if value>0 then
		return value
	end
	return nil

end




function modifier_unit_cooldownReduction:GetModifierBonusStats_Strength(keys)	
	local hUnit = self:GetParent()
	local value = GetStrngthBonus(hUnit, keys or {})
	return value
end
function modifier_unit_cooldownReduction:GetModifierBonusStats_Agility(keys)	
	local hUnit = self:GetParent()
	local value = GetAgilityBonus(hUnit, keys or {})
	return value
end
function modifier_unit_cooldownReduction:GetModifierBonusStats_Intellect(keys)	
	local hUnit = self:GetParent()
	local value = GetIntellectBonus(hUnit, keys or {})
	return value
end


function modifier_unit_cooldownReduction:GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		local victim = self:GetParent()
        local attacker = keys.attacker
        if not attacker then
            return
        end
        local damage = keys.original_damage
		-- 伤害统计功能
        if attacker:IsCreature() and victim:IsRealHero() and victim.GetPlayerOwnerID then
            local victimPlayerId = victim:GetPlayerOwnerID()
            if victimPlayerId and victimPlayerId >= 0 and damage>=0 then
                player_data_modify_value(victimPlayerId, "damageTaken", damage)
            end
        end
	end


	local parent = self:GetParent()
	local value = GetIncomingDamage_Percentage(parent, keys)
	-- print("value block = ",value)
	return value 
end

BLOCK_COLOR = {}
BLOCK_COLOR[1] = Vector(255,50,50)
BLOCK_COLOR[2] = Vector(50,100,255)
BLOCK_COLOR[4] = Vector(255,255,0)
-- 护盾效果
function modifier_unit_cooldownReduction:GetModifierTotal_ConstantBlock(keys)
	if IsServer() then
		local kv = keys
	
		local unit  = self:GetParent()
		local disabled = GetBlockDisable(unit, kv)
		kv.block_disabled = disabled
		local total_block = 0
		if keys.damage_type==DAMAGE_TYPE_MAGICAL then
			total_block =  total_block + GetMagicalBlockConstantMaximum(self:GetParent(),kv)
		end
		-- 先进入取最高常数减免
		total_block = total_block + GetBlockConstantMaximum(self:GetParent(),kv)
		kv.damage = kv.damage - total_block

		-- 进入叠加方式2
		-- TODO 可以导入一个优先度数值 DeclareFunctions时根据这个数值将修饰器放置对应位置 即初始化时排序好 这样就可以不用这个方式来做优先度判断了
		-- 并且可以随意填写数值来确保高度自定义顺序
		if kv.damage>0 then
			-- 先进入高优先度
			local block =  GetTotalBlockHightLevel(self:GetParent(),kv) 
			kv.damage = kv.damage - block
			total_block = total_block + block
			-- 还有伤害再进入中优先度
			if kv.damage>0 then
				local block =  GetTotalBlock(self:GetParent(),kv) 
				kv.damage = kv.damage - block
				total_block = total_block + block
				-- 还有伤害再进入低优先度
				if kv.damage>0 then
					local low_block =  GetTotalBlockLowLevel(self:GetParent(),kv) 
					kv.damage = kv.damage - low_block
					total_block = total_block + low_block
				end
				if kv.damage>0 then
					local temporaryHealthBlock =  GetTemporaryHealth(self:GetParent(),kv) 
					kv.damage = kv.damage - temporaryHealthBlock
					total_block = total_block + temporaryHealthBlock
				end
			end
		end

		-- if total_block>0 then
		-- 	local player = unit:GetPlayerOwner()
		-- 	if player then
		-- 		fHDSendCustomOverheadEventMessageForPlayer(player,"hd_block", unit, math.floor(total_block), 1, Vector(0,0,100),  BLOCK_COLOR[keys.damage_type]  or Vector(255,255,255), 7)
		-- 	end
			
		-- end
		


		return total_block
	end
	
end





function  modifier_unit_cooldownReduction:GetModifierPhysicalArmorBonus()
	local value = GetPhysicalArmor(self:GetParent(), {}) 


	
	return value
end



function modifier_unit_cooldownReduction:GetModifierProcAttack_BonusDamage_Physical( keys )
	if IsServer() then
		if keys.attacker == self:GetParent() then
			return GetProcAttack_BonusDamage_Physical(keys.attacker, keys)
		end
	end
end


-- 物理暴击
function modifier_unit_cooldownReduction:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		local hAttacker = keys.attacker
		local hTarget = keys.target
		if hAttacker == self:GetParent() then
			local crit_damage = GetCriticalStrike(hAttacker, keys)
			if crit_damage > 100 then
				local value =  (crit_damage + GetCriticalStrikeDamage(hAttacker) + GetCriticalStrikeDamageTarget(hTarget)) * GetIncomingCriticalStrikePercent(hTarget, keys) * (100 + GetPhysicalCriticalAmp(hAttacker, keys))*0.01
				local event_data = {
					attacker =hAttacker,  
					unit = hTarget, 
					original_crit_damage = crit_damage,
					crit_damage = value,
					record =keys.record,
				}
				FireCritHitEvent(event_data)
				return value
			end
		end
	end
end

function modifier_unit_cooldownReduction:GetModifierAttackSpeedPercentage(keys)	
	return GetAttackSpeed_Percentage(self:GetParent(),keys)
end


function modifier_unit_cooldownReduction:GetFixedDayVision()
	if IsServer() then
		local parent = self:GetParent()
		local value =  GetUnitVision(parent)
		parent:SetDayTimeVisionRange(value)
		return value
	end
end

function modifier_unit_cooldownReduction:GetFixedNightVision()
	if IsServer() then

		local parent = self:GetParent()
		local value =  GetUnitVision(parent)
		parent:SetNightTimeVisionRange(value)
		return value
	end
end


function modifier_unit_cooldownReduction:CheckState()
	local state = 
	{
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	local parent = self:GetParent()
	if parent:IsFlying() then
		state[MODIFIER_STATE_FLYING] = true
	end
	if parent:IsFlyingPathing() then
		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	end

	

	return state
end




function modifier_unit_cooldownReduction:GetModifierBaseAttack_BonusDamage(keys) 

	local value = HDGetModifier_BaseDamageBonus(self:GetParent(), keys)
	return value
end






function modifier_unit_cooldownReduction:GetModifierPreAttack_BonusDamage(keys) 

	local value = HDGetModifierPreAttack_BonusDamage(self:GetParent(), keys)
	return value
end



function modifier_unit_cooldownReduction:GetModifierBaseDamageOutgoing_Percentage(keys) 

	local value = HDGetModifierBaseDamageOutgoing_Percentage(self:GetParent(), keys)
	return value
end


function modifier_unit_cooldownReduction:GetModifierDamageOutgoing_Percentage(keys) 

	local value = HDGetModifierDamageOutgoing_Percentage(self:GetParent(), keys)
	-- print("value=",value)
	return value
end




function modifier_unit_cooldownReduction:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		-- print("bug验证：flDamage=",flDamage)
		local feast_aiblity = self:GetAbility()

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end

		local life_steal = 0
		if params.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
			life_steal = life_steal + GetLifeSteal_AttackDamage(Attacker, params)
		end

		if life_steal>0 then
			local gain = Attacker:GetModifierLifeStealGain(1)
			local flLifesteal = flDamage * life_steal*0.01*gain
			if flLifesteal>0 then
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				Attacker:Heal( flLifesteal, self:GetAbility() )
			end
		end
	end
	return 0.0
end



function modifier_unit_cooldownReduction:GetModifierStatusResistanceStacking()
	local value = GetStatusResistance(self:GetParent(), {})
	return value
end





function modifier_unit_cooldownReduction:GetModifierSpellAmplify_Percentage(params)
	return GetSpellAmplify(self:GetParent(), params)
end







function modifier_unit_cooldownReduction:IncreaseFalseDeathCount(count)
	self.false_death_count = self.false_death_count + count
end



function modifier_unit_cooldownReduction:GetFalseDeathCount()
	return self.false_death_count
end


