item_hd_soul_booster = class({})
-- LinkLuaModifier("modifier_item_hd_soul_booster_arua", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_arua_effect", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_soul_booster", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_active", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_effect", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_effect2", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_active_standby", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_debuff", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_booster_thinker", "items/item_hd_soul_booster", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_soul_booster:GetIntrinsicModifierName()
	return "modifier_item_hd_soul_booster"
end

-- GetCastRange()
-- return self.BaseClass.GetCastRange(self, ...) - caster:GetCastRangeBonus()

-- function item_hd_soul_booster:CastFilterResult()
-- 	-- check nohammer
-- 	if IsClient() then
-- 		return
-- 	end
-- 	local time = GameRules:GetTimeOfDay()
-- 	if  _G.GAME_CHANGING_TIME_OF_DAY then
-- 		return UF_FAIL_CUSTOM
-- 	end
-- 	if time>=0.25 and time <=0.75 then
-- 		return UF_FAIL_CUSTOM
-- 	end
-- 	return UF_SUCCESS
-- end

-- function item_hd_soul_booster:GetCustomCastError()
-- 	if IsClient() then
-- 		return
-- 	end
-- 	local time = GameRules:GetTimeOfDay()
-- 	if _G.GAME_CHANGING_TIME_OF_DAY then
-- 		return "当前世界时间正处于强制变更中"
-- 	end

-- 	if time>=0.25 and time <=0.75 then
-- 		return "当前已经是白天"
-- 	end
-- 	return ""
-- end





-- modifier_item_hd_soul_booster_arua = class({})

-- function modifier_item_hd_soul_booster_arua:IsHidden() return true end
-- function modifier_item_hd_soul_booster_arua:IsAura() return true end
-- function modifier_item_hd_soul_booster_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_soul_booster_arua:GetModifierAura() return "modifier_item_hd_soul_booster_arua_effect" end
-- function modifier_item_hd_soul_booster_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_soul_booster_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_soul_booster_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_soul_booster_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_soul_booster = class({})

function modifier_item_hd_soul_booster:IsDebuff() return false end
function modifier_item_hd_soul_booster:IsHidden() return true end
function modifier_item_hd_soul_booster:IsPurgable() return false end
-- function modifier_item_hd_soul_booster:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_soul_booster:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_item_hd_soul_booster:IsAura() return true end
-- function modifier_item_hd_soul_booster:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_soul_booster:GetModifierAura() return "modifier_item_hd_soul_booster_active" end
-- function modifier_item_hd_soul_booster:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_soul_booster:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_soul_booster:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_item_hd_soul_booster:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_item_hd_soul_booster:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end


function modifier_item_hd_soul_booster:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	-- self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	-- self.bonus_cooldown  = self.ability:GetSpecialValueFor("bonus_cooldown")

	-- self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	-- self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	-- self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")

	-- self.bonus_manacost_per = self.ability:GetSpecialValueFor("bonus_manacost_per")


	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	-- self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	-- self.bonus_casttime = self.ability:GetSpecialValueFor("bonus_casttime")
	-- self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_heal_receive_amplification = self.ability:GetSpecialValueFor("bonus_heal_receive_amplification")
	-- self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	-- self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")
	-- self.bonus_StatusGain = self.ability:GetSpecialValueFor("bonus_StatusGain")
	-- self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
	-- self.BONUS_DAY_VISION = self.ability:GetSpecialValueFor("BONUS_DAY_VISION")
	-- self.BONUS_NIGHT_VISION = self.ability:GetSpecialValueFor("BONUS_NIGHT_VISION")
	-- self.bonus_turn_rate_per = self.ability:GetSpecialValueFor("self.bonus_turn_rate_per")
	-- self.bonus_per_attack_mana_break = self.ability:GetSpecialValueFor("bonus_per_attack_mana_break")
	-- self.crit_chance = self.ability:GetSpecialValueFor( "blade_dance_crit_chance" )
	-- self.crit_mult = self.ability:GetSpecialValueFor( "blade_dance_crit_mult" )
		-- self.bonus_Magical_ConstantBlock = self.ability:GetSpecialValueFor( "bonus_Magical_ConstantBlock" ) --魔法伤害抵挡


    if IsServer() then

	end
end


function modifier_item_hd_soul_booster:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		-- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,              --冷却时间


		-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		-- MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
		-- MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		-- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
		-- MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比

		-- MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,--额外受到攻击伤害（物理）
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,   --技能消耗（可增加）
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗
		
		-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,        --施法距离
		-- MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,              --施法前摇
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		-- MODIFIER_EVENT_ON_ATTACK,                           --攻击事件
		-- MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,      	   --基础移速覆写
		-- MODIFIER_PROPERTY_MODEL_CHANGE,                     --改变模型
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
		-- MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,             --转身速率
		-- MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,         --致命一击

		-- MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		-- MODIFIER_EVENT_ON_DEATH_PREVENTED,                  --死亡阻挡 跟Ontakedamage差不多  对应OnDeathPrevented
		-- MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,  --额外魔法攻击力伤害
		-- MODIFIER_EVENT_ON_ATTACK_RECORD,                    --攻击被记录
		-- MODIFIER_EVENT_ON_DEATH,                            --死亡
		

	}
end


-- function modifier_item_hd_soul_booster:GetModifierBonusStats_Strength()	return self.bonus_str end
-- function modifier_item_hd_soul_booster:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_soul_booster:GetModifierBonusStats_Intellect()	return self.bonus_int end
-- function modifier_item_hd_soul_booster:GetModifierHealthBonus()	return self.bonus_health end
-- function modifier_item_hd_soul_booster:GetModifierHealthRegenPercentage() return 0 end

-- function modifier_item_hd_soul_booster:GetModifierHPRegenAmplify_Percentage() 	return self.bonus_regeneration_amplification end
-- function modifier_item_hd_soul_booster:GetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
-- function modifier_item_hd_soul_booster:GetModifierManaBonus()	return self.bonus_mana end
-- function modifier_item_hd_soul_booster:GetModifierMPRegenAmplify_Percentage() 	return self.bonus_Mana_regeneration end
-- function modifier_item_hd_soul_booster:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
-- function modifier_item_hd_soul_booster:GetModifierPercentageCooldown()    return self.bonus_cooldown end
-- function modifier_item_hd_soul_booster:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
-- function modifier_item_hd_soul_booster:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
-- function modifier_item_hd_soul_booster:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_move end
-- function modifier_item_hd_soul_booster:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
-- function modifier_item_hd_soul_booster:GetModifierEvasion_Constant() return self:GetStackCount()==2 and self.bonus_evasion or 0 end
-- function modifier_item_hd_soul_booster:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
-- function modifier_item_hd_soul_booster:GetModifierBaseDamageOutgoing_Percentage() return self:GetStackCount()==1 and self.bonus_damage_per or 0 end
-- function modifier_item_hd_soul_booster:GetModifierPercentageManacostStacking() return self.bonus_manacost_per end
-- function modifier_item_hd_soul_booster:GetModifierPhysicalArmorBonus() return self.bonus_armor end
-- function modifier_item_hd_soul_booster:GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end
-- function modifier_item_hd_soul_booster:GetModifierCastRangeBonusStacking() return self.bonus_spell_range end
-- function modifier_item_hd_soul_booster:GetModifierPercentageCasttime()   return self:GetAbility():IsCooldownReady() and self.bonus_casttime or 0  end  --self.bonus_casttime
-- function modifier_item_hd_soul_booster:GetBonusDayVision()   return self.BONUS_DAY_VISION  end
-- function modifier_item_hd_soul_booster:GetBonusNightVision()   return self.BONUS_NIGHT_VISION  end
-- function modifier_item_hd_soul_booster:GetModifierTurnRate_Percentage()   return self.bonus_turn_rate_per  end
-- function modifier_item_hd_soul_booster:GetModifierMagical_ConstantBlock()   return self.bonus_Magical_ConstantBlock  end
--
-- function modifier_item_hd_soul_booster:OnTakeDamage(keys)
-- 	if IsServer() then   
-- 		local attacker = keys.attacker
-- 		local unit = keys.unit

-- 		if not keys.inflictor then return end
-- 		if attacker~=self:GetParent() then	return end

-- 		if keys.damage<=100 then return	end
		

-- 		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
	
-- 		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

-- 		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

-- 		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


-- 		if self:GetAbility():IsCooldownReady() and 20>=RandomInt(1, 100) then
-- 			local cooldown_time = keys.damage/(5*attacker:GetIntellect(false))
-- 			if cooldown_time>5 then cooldown_time=5 end
-- 			if cooldown_time<0.1 then cooldown_time=0.1 end
-- 			self:GetAbility():StartCooldown(keys.damage/(10*attacker:GetIntellect(false)))
-- 			local damage = keys.damage *0.5

-- 			local damageTable = {
-- 								victim = unit,
-- 								attacker = attacker,
-- 								damage = damage,
-- 								damage_type = keys.damage_type,
-- 								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
-- 								ability = keys.inflictor, --Optional.
-- 								}
-- 			local applydamage = ApplyDamage(damageTable)
-- 			if applydamage<=0 then
-- 				return
-- 			end
-- 			fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
-- 		end
		

 
--     end 
-- end



-- function modifier_item_hd_soul_booster:GetModifierIncomingDamage_Percentage(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	local parent = self:GetParent()
-- 	if keys.damage >=  parent:GetHealth()*0.5 then
-- 		self:Destroy()
-- 		return 0
-- 	end
-- 	return -1000
-- end
-- function modifier_item_hd_soul_booster:OnAttack(keys)
-- 	if IsServer() then
-- 		if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() then
-- 			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_soul_booster_effect", {duration = 3})

-- 		end
-- 	end
-- end


-- function modifier_item_hd_soul_booster:GetModifierPreAttack_BonusDamagePostCrit(params) 
-- 	if 6>RandomInt(0, 9) then
-- 		return 30
-- 	end
-- 	return 0
-- end


-- function modifier_item_hd_soul_booster:OnAttackLanded(keys)
-- 	if IsServer() then

-- 		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
-- 			self:GetAbility():UseResources(true, true, true,true)
-- 			local caster = self:GetCaster()
-- 			local target =keys.target
-- 			local pfx_name = "particles/units/heroes/hero_monkey_king/monkey_king_jump_stomp.vpcf"
-- 			local sound_name = {
-- 				"n_creep_Centaur.Stomp",
-- 				"n_creep_Thunderlizard_Big.Stomp"
-- 			}
-- 			target:EmitSound(sound_name[RandomInt(1, 2)])
-- 			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
-- 			ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
-- 			ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
-- 			ParticleManager:ReleaseParticleIndex(pfx)
-- 			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
-- 			local damage =  self:GetCaster():GetBaseDamageMax()*0.5
-- 			local damagetype = self:GetAbility():GetAbilityDamageType()
-- 			for _, enemy in pairs(enemies) do
-- 				local damageTable = {
-- 					victim = enemy,
-- 					attacker = caster,
-- 					damage = damage,
-- 					damage_type = damagetype,
-- 					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
-- 					ability = self, --Optional.
-- 					}
-- 				ApplyDamage(damageTable)	
-- 			end

-- 		end
-- 	end
-- end





-- function modifier_item_hd_soul_booster:OnAbilityFullyCast(keys)

-- 	if IsServer() then
-- 		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
-- 			return 
-- 		end
-- 		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 2 then
-- 			return
-- 		end
-- 		if self:GetAbility():IsCooldownReady() then
-- 			self:GetAbility():UseResources(true, true, true,true)
-- 		end
-- 		-- self:GetAbility():UseResources(true, true, true,true)
	
-- 		-- if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
-- 		-- 	return 
-- 		-- end
-- 		-- if 25>=RandomInt(1, 100) then
-- 		-- 	return
-- 		-- end
-- 		-- if keys.unit:HasModifier("modifier_item_hd_soul_booster_active") then
-- 		-- 	return
-- 		-- end

-- 		-- keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_item_hd_soul_booster_active",{duration = 50})	
	
	
		
-- 	end
-- end


-- function modifier_item_hd_soul_booster:GetModifierProcAttack_BonusDamage_Magical(keys)
-- 	for _, record in pairs(self.pierce_records) do	
-- 		if record == keys.record then
-- 			table.remove(self.pierce_records, _)

-- 			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
-- 				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
-- 				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, 150, nil)
				
-- 				return 150
-- 			end
-- 		end
-- 	end
-- end

-- function modifier_item_hd_soul_booster:OnAttackRecord(keys)
-- 	if keys.attacker == self:GetParent() then
-- 		if self.pierce_proc then
-- 			table.insert(self.pierce_records, keys.record)
-- 			self.pierce_proc = false
-- 		end
-- 		-- print("attack")
	
-- 		if not keys.target:IsMagicImmune() and 20>=RandomInt(1, 100) then  --由此触发了无视闪避
-- 			self.pierce_proc = true
-- 		end
-- 	end
-- end

-- function modifier_item_hd_soul_booster:OnDeath(keys)
--     if not IsServer() then
--         return
--     end

--     if keys.unit == self:GetParent() then
-- 		local pos = keys.unit:GetAbsOrigin()
--         CreateModifierThinker(keys.unit, self:GetAbility(), "modifier_item_hd_soul_booster_thinker", 
--         {duration = 5}, pos, keys.unit:GetTeamNumber(), false)

--     end
   
-- end


-- modifier_item_hd_soul_booster_active = class({})

-- function modifier_item_hd_soul_booster_active:IsDebuff() return false end
-- function modifier_item_hd_soul_booster_active:IsHidden() return false end
-- function modifier_item_hd_soul_booster_active:IsPurgable() return false end
-- function modifier_item_hd_soul_booster_active:GetTexture()return "item_sparkle" end
-- function modifier_item_hd_soul_booster_active:GetEffectName() return "particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf" end
-- function modifier_item_hd_soul_booster_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_item_hd_soul_booster_active:DeclareFunctions()
-- 	return {
-- 			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
	

-- 	}
-- end
-- function modifier_item_hd_soul_booster_active:GetModifierBaseDamageOutgoing_Percentage()return -15 end



-- function modifier_item_hd_soul_booster_active:OnCreated(keys)
--     self.ability = self:GetAbility()
-- 	-- print("555555")
--     -- self.caster = self:GetCaster()
--     local parent = self:GetParent()


--     if IsServer() then
-- 		self:SetStackCount(keys.index)
-- 	end
-- end

-- function modifier_item_hd_soul_booster_active:OnRefresh(keys)
-- 	if IsServer() then
-- 		self:SetStackCount(keys.index)
-- 	end
-- end


-- function modifier_item_hd_soul_booster_active:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
-- 	}
-- end


-- function modifier_item_hd_soul_booster_active:GetModifierAttackSpeedBonus_Constant() 	return 30 end
-- function modifier_item_hd_soul_booster_active:GetModifierMoveSpeedBonus_Percentage()	return 7 end


--


--携带特效
-- function modifier_item_hd_phase_boots_2_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
-- function modifier_item_hd_phase_boots_2_active:GetEffectName() 	  return "particles/econ/events/ti9/phase_boots_ti9.vpcf" end

-- function modifier_item_hd_soul_booster_active:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end
-- State
-- MODIFIER_STATE_ROOTED = 0  
-- MODIFIER_STATE_DISARMED = 1
-- MODIFIER_STATE_ATTACK_IMMUNE = 2
-- MODIFIER_STATE_SILENCED = 3
-- MODIFIER_STATE_MUTED = 4
-- MODIFIER_STATE_STUNNED = 5
-- MODIFIER_STATE_HEXED = 6  --妖术
-- MODIFIER_STATE_INVISIBLE = 7     --透明
-- MODIFIER_STATE_INVULNERABLE = 8  --无敌
-- MODIFIER_STATE_MAGIC_IMMUNE = 9   --魔免
-- MODIFIER_STATE_PROVIDES_VISION = 10  --提供视野
-- MODIFIER_STATE_NIGHTMARED = 11   --噩梦
-- MODIFIER_STATE_EVADE_DISABLED = 13     
-- MODIFIER_STATE_UNSELECTABLE = 14 --不可选中
-- MODIFIER_STATE_CANNOT_TARGET_ENEMIES = 15  
-- MODIFIER_STATE_CANNOT_MISS = 16  --必中
-- MODIFIER_STATE_SPECIALLY_DENIABLE = 17
-- MODIFIER_STATE_FROZEN = 18  --冻结
-- MODIFIER_STATE_COMMAND_RESTRICTED = 19
-- MODIFIER_STATE_NOT_ON_MINIMAP = 20  --小地图不显示
-- MODIFIER_STATE_LOW_ATTACK_PRIORITY = 21 --低攻击优先度
-- MODIFIER_STATE_NO_HEALTH_BAR = 22  --不显示生命条
-- MODIFIER_STATE_FLYING = 23  --飞行
-- MODIFIER_STATE_NO_UNIT_COLLISION = 24  --无视碰撞
-- MODIFIER_STATE_NO_TEAM_MOVE_TO = 25
-- MODIFIER_STATE_NO_TEAM_SELECT = 26
-- MODIFIER_STATE_PASSIVES_DISABLED = 27  --被动破坏
-- MODIFIER_STATE_DOMINATED = 28    --被支配
-- MODIFIER_STATE_BLIND = 29  --失明
-- MODIFIER_STATE_OUT_OF_GAME = 30  --游戏外
-- MODIFIER_STATE_FAKE_ALLY = 31  --假友军
-- MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY = 32  --无视地形
-- MODIFIER_STATE_TRUESIGHT_IMMUNE = 33  --无视真视
-- MODIFIER_STATE_UNTARGETABLE = 34
-- MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS = 35
-- MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES = 36  --穿越树木
-- MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES = 37
-- MODIFIER_STATE_UNSLOWABLE = 38
-- MODIFIER_STATE_TETHERED = 39  --束缚
-- MODIFIER_STATE_IGNORING_STOP_ORDERS = 40
-- MODIFIER_STATE_FEARED = 41
-- MODIFIER_STATE_TAUNTED = 42
-- MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED = 43
-- MODIFIER_STATE_FORCED_FLYING_VISION = 44
-- MODIFIER_STATE_ATTACK_ALLIES = 45
-- MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS = 46
-- MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE = 47
-- MODIFIER_STATE_SPECIALLY_UNDENIABLE = 48
-- MODIFIER_STATE_LAST = 49
-- GameRules:GetGameTime()


-- caster:EmitSound("compendium_levelup")
-- 		caster:AddNewModifier(caster, self, "modifier_item_hd_risk_dice_active", {})
-- 		self.particle = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10_godray.vpcf", PATTACH_POINT_FOLLOW, caster)
-- 		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
-- 		ParticleManager:ReleaseParticleIndex(self.particle)




-- local particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe_vortex_core.vpcf", PATTACH_POINT_FOLLOW, caster)
-- ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
-- ParticleManager:ReleaseParticleIndex(particle)




-- local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf", PATTACH_POINT_FOLLOW, self.parent)
-- ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControl(shackle_particle, 2, Vector(2000,0,0))
-- ParticleManager:SetParticleControlEnt(shackle_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
-- self:AddParticle(shackle_particle, true, false, -1, true, false)