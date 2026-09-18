Advanced_tether = class({})
-- This modifier applies on Wisp and deals with giving the target heal and mana amp
LinkLuaModifier("modifier_Advanced_tether", "skills/Advanced_tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_tether_buff", "skills/Advanced_tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_tether_buff_target", "skills/Advanced_tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_tether_buff_unlock2", "skills/Advanced_tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_tether_buff_unlock3", "skills/Advanced_tether", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Advanced_tether:CheckKV(key)
	local table = {
		radius=20,
		tether_heal_amp=0.01,

	}
	local value = table[key] or -1
	return value

end
function Advanced_tether:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock1",{})
	return true
end
function Advanced_tether:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_tether:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock3",{})
	return true
end


function Advanced_tether:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if target == caster then
		return "#Spells_CustomCastError_NOT_SELF"
	end
	return "#Spells_CustomCastError_NOT_Enemy"
end

function Advanced_tether:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target == caster or target:GetTeamNumber()~=caster:GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end

function Advanced_tether:GetCastRange(vLocation, hTarget)
	local advanced_level = self:GetSpecialValueFor("advanced_level")

	local radius =self:GetSpecialValueFor("radius")

	return radius
end

function Advanced_tether:OnSpellStart()

	local caster 				= self:GetCaster()




	self.tether_ally 			= self:GetCursorTarget()
	self.target 				= self:GetCursorTarget()

	self.range = math.max(caster:GetCastRangeBonus() +self:GetSpecialValueFor("radius"),100)+150

	local NetTable_key = self:GetCaster():GetEntityIndex().."_Advanced_tether_cast_range"
	-- print(NetTable_key)
	CustomNetTables:SetTableValue( "spell_info", NetTable_key, {range =self.range-150 } )  --更新网表



	caster:AddNewModifier(self.target, self, "modifier_Advanced_tether", {})
	
	self.target:AddNewModifier(caster, self, "modifier_Advanced_tether_buff_target", {})

	caster:SwapAbilities("Advanced_tether", "Advanced_tether_break", false, true)
	local ability = caster:FindAbilityByName("Advanced_tether_break")
	ability:SetLevel(1)
	ability:StartCooldown(0.25)
	-- ability.father_spell = self
end



---------------------
-- TETHER MODIFIER --
---------------------

modifier_Advanced_tether = advanced_modifier({})

function modifier_Advanced_tether:IsHidden() return false end
function modifier_Advanced_tether:IsPurgable() return false end
function modifier_Advanced_tether:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_Advanced_tether:OnCreated(params)
	self.target 			= self:GetCaster()

	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	if IsServer() then 
		self.tData = {}
		self.radius 			= self:GetAbility().range
		self.advanced_level = self:GetAbility().advanced_level
		self.tether_heal_amp 	= self:GetAbility():GetSpecialValueFor("tether_heal_amp")


		self.update_timer 			= 0
		self.time_to_send 			= 1  --恢复提示信息间隔
		self:GetCaster():EmitSound("Hero_Wisp.Tether")

		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/units/heroes/hero_wisp/wisp_tether_2.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx,60,Vector(self.radius,self.radius+150,0))
		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())

		local caster = self:GetAbility():GetCaster()
		if not caster.tether_overload_readly then
			caster.tether_overload_readly = 1
		end

		self.heal_count = 0
		self.mana_count = 0

		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") then
			self.talent_index = 0.5
			if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"gay_chain_1") then
				self.talent_index = 0.6
			else
				self.record_wave = 0
			end
		end



	end
	
	self:StartIntervalThink(FrameTime())
end
function modifier_Advanced_tether:OnWaveEnd()
	if self.record_wave then
		self.record_wave = self.record_wave + 1
		if self.record_wave>=2 then
			local ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_wisp_2")
			if ability then
				ability:Unlockachievement()
			end
			
		end
	end
end
function modifier_Advanced_tether:OnIntervalThink()
	self.difference			= 0


	if not IsServer() then return end
	local caster = self:GetCaster() --这个是释放的目标
	local ability_caster = self:GetAbility():GetCaster() --这个才是施法者
	-- print(self:GetAbility():GetCastRangeBonus(caster))
	-- 技能丢失或目标丢失则移除状态
	local ability = self:GetAbility()
	if not ability or not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local dis = (self.target:GetAbsOrigin() - ability_caster:GetAbsOrigin()):Length2D()
	
	self.update_timer = self.update_timer + FrameTime()
	-- 每过一秒给出一次恢复提升
	if self.update_timer > self.time_to_send then 
		local index = 1
		if dis> self.radius then
			if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") and not self:GetParent():PassivesDisabled() then
				index = self.talent_index
			else
				self:GetParent():RemoveModifierByName("modifier_Advanced_tether")
				return
			end
		end

		if ability.unlock1 then
			local fGameTime = GameRules:GetGameTime()
	
			for i = #self.tData, 1, -1 do
				if fGameTime >= self.tData[i].dieTime then
					table.remove(self.tData, i)
					self:DecrementStackCount()
				end
			end
		end
		
		local heal = ability_caster:GetHealthRegen()*self.tether_heal_amp * (1+self:GetStackCount()*0.1)*index
		local mana_gain = ability_caster:GetManaRegen()*self.tether_heal_amp* (1+self:GetStackCount()*0.1)*index
		-- print(caster:GetHealthRegen())
		-- print(mana_gain)
		--LV20解锁强流
		if self.advanced_level>=20 and ability_caster:GetRandomEffect(20,INT_TYPE,1) ==RandomInt(1, 100) then
			heal = heal *3
			mana_gain = mana_gain*3
		end
	
		local healing = HealWithGain(heal,ability_caster,self.target,ability)
		if ability.unlock2 and Game_State:IsInBattle() then
			self.heal_count = self.heal_count + healing
			local need = self.target:GetMaxHealth()
			if self.heal_count>=need then
				self.heal_count = self.heal_count - need
				self.target:AddNewModifier(ability_caster, ability, "modifier_Advanced_tether_buff_unlock2", {})
			end
		
		end
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, healing, nil)
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self.total_gained_health, nil)	
		if ability.unlock3 and Game_State:IsInBattle() then
			self.mana_count = self.mana_count + mana_gain
			local need = self.target:GetMaxMana()
			if self.mana_count>=need then
				self.mana_count = self.mana_count - need
				self.target:AddNewModifier(ability_caster, ability, "modifier_Advanced_tether_buff_unlock3", {})
			end
		
		end
		self.target:GiveMana(mana_gain)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, mana_gain, nil)

		self.update_timer 			= 0
	end


	if ability_caster.tether_overload_readly==1 and self.target:GetHealthPercent()<=30  then
		ability_caster.tether_overload_readly = 0
		--超负荷冷却
		Timers:CreateTimer(25, function()
			ability_caster.tether_overload_readly = 1
		end)
		local gain = ability_caster:GetModifierDurationGainIndex(1)
		local duration = 7
		--LV5解锁超负荷+
		if self.advanced_level>=5 then
			duration = duration +4
		end
		self.target:AddNewModifier(ability_caster, ability, "modifier_Advanced_tether_buff", {duration = duration*gain})
		local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, self.target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end


	
	if not self.target:IsAlive() or not ability_caster:IsAlive() then  --打断

		ability_caster:RemoveModifierByName("modifier_Advanced_tether")
		return
	end



	if dis <= self.radius then
		return
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") and not self:GetParent():PassivesDisabled() then
		return
	end
	ability_caster:RemoveModifierByName("modifier_Advanced_tether")
end

function modifier_Advanced_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
	if self:GetUnlock(1)==1 then
		table.insert(decFuncs,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST)
	end

	return decFuncs
end


function modifier_Advanced_tether:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move_speed
end

-- function modifier_Advanced_tether:GetModifierMoveSpeed_Limit()
-- 	return self.target_speed
-- end

function modifier_Advanced_tether:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_Advanced_tether:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx,false)
		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("Advanced_tether_break", "Advanced_tether", false, true)
		if self.target:HasModifier("modifier_Advanced_tether_buff_target") then
			self.target:RemoveModifierByName("modifier_Advanced_tether_buff_target")
		end
	end
end



function modifier_Advanced_tether:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end
	self:IncrementStackCount()
	table.insert(self.tData, { dieTime =  GameRules:GetGameTime()+30*self:GetCaster():GetModifierDurationGainIndex(1) })


end
function modifier_Advanced_tether:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end


Advanced_tether_break = class({})

function Advanced_tether_break:OnSpellStart()
	self:GetCaster():RemoveModifierByName("modifier_Advanced_tether")
end


function Advanced_tether_break:GetCastRange()
	
	--去拿施法时的施法距离
	local NetTable_key = self:GetCaster():GetEntityIndex().."_Advanced_tether_cast_range"
	local range = CustomNetTables:GetTableValue( "spell_info", NetTable_key).range
	local caster =self:GetCaster()
	return range - caster:GetCastRangeBonus()

end

--用上面的写法比较好
-- function Advanced_tether_break:GetCastRangeBonus(caster)
-- 	return 0
-- end






modifier_Advanced_tether_buff = advanced_modifier({})

function modifier_Advanced_tether_buff:IsDebuff() return false end
function modifier_Advanced_tether_buff:IsHidden() return false end
function modifier_Advanced_tether_buff:IsPurgable() return true end


function modifier_Advanced_tether_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(self:GetCaster():GetStrength())
	end
end

function modifier_Advanced_tether_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end
function modifier_Advanced_tether_buff:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() end




modifier_Advanced_tether_buff_target = advanced_modifier({})

function modifier_Advanced_tether_buff_target:IsDebuff() return false end
function modifier_Advanced_tether_buff_target:IsHidden() return false end
function modifier_Advanced_tether_buff_target:IsPurgable() return false end

function modifier_Advanced_tether_buff_target:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_Advanced_tether_buff_target:OnCreated(keys)
	self.heal_recevie_gain = 30
	self.state_gain = 20
	--LV10解锁善意+
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		self.heal_recevie_gain = self.heal_recevie_gain *1.5
		self.state_gain = self.state_gain*1.5
	end
	self.bonus_status_resistance = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		self.bonus_status_resistance = 35
	end
	if IsServer() then

		if self:GetAbility().unlock1 then
			self.target_modifier = self:GetCaster():FindModifierByName("modifier_Advanced_tether")
			self:StartIntervalThink(0.1)
		end
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") then
			self.bonus_spell_damage = self:GetCaster():GetSpellAmplification(false)*20
			self:SetHasCustomTransmitterData( true )
		end

	
	end
end

function modifier_Advanced_tether_buff_target:OnIntervalThink()
	if self.target_modifier then
		self:SetStackCount(self.target_modifier:GetStackCount())
	end
end


function modifier_Advanced_tether_buff_target:DeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
		
	end
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") then
		table.insert(funcs,MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE)
	end

	return funcs

end
function modifier_Advanced_tether_buff_target:GetModifierConstantHealthRegen()return self:GetStackCount()*3 end

function modifier_Advanced_tether_buff_target:GetModifierBaseAttack_BonusDamage() 
	return  math.min(self:GetCaster():GetBaseDamageMax()*0.2,500) 
end


function modifier_Advanced_tether_buff_target:AddCustomTransmitterData( )
	return
	{
		bonus_spell_damage = self.bonus_spell_damage
	}
end

function modifier_Advanced_tether_buff_target:HandleCustomTransmitterData( data )
	self.bonus_spell_damage = data.bonus_spell_damage
end


function modifier_Advanced_tether_buff_target:Advanced_GetModifierSpellAmplifyBonus() 
	if IsServer() then
		self.bonus_spell_damage = self:GetCaster():GetSpellAmplification(false)*20
		return self.bonus_spell_damage
	end
	return  self.bonus_spell_damage or 0
end



function modifier_Advanced_tether_buff_target:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_StatusResistance,
    }
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS)
	end

	
    return funcs
    
end
function modifier_Advanced_tether_buff_target:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.heal_recevie_gain
end


function modifier_Advanced_tether_buff_target:Advanced_GetModifier_DurationGain(keys)
	return self.state_gain
end





function modifier_Advanced_tether_buff_target:Advanced_GetModifier_NegativeDurationGain(keys)
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		return 20
	end

end


function modifier_Advanced_tether_buff_target:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


















modifier_Advanced_tether_buff_unlock2 = advanced_modifier({})

function modifier_Advanced_tether_buff_unlock2:IsHidden()	return false end
function modifier_Advanced_tether_buff_unlock2:IsDebuff()	return false end
function modifier_Advanced_tether_buff_unlock2:IsPurgable() 		    return false end
function modifier_Advanced_tether_buff_unlock2:IsPurgeException() return false end
function modifier_Advanced_tether_buff_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_tether_buff_unlock2:GetTexture() return "wisp_tether" end
function modifier_Advanced_tether_buff_unlock2:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_tether_buff_unlock2:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,100))
	end
end
function modifier_Advanced_tether_buff_unlock2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end


function modifier_Advanced_tether_buff_unlock2:AdvancedGetModifierExtraHealthPercentage()	return self:GetStackCount() end




modifier_Advanced_tether_buff_unlock3 = class({})

function modifier_Advanced_tether_buff_unlock3:IsHidden()	return false end
function modifier_Advanced_tether_buff_unlock3:IsDebuff()	return false end
function modifier_Advanced_tether_buff_unlock3:IsPurgable() 		    return false end
function modifier_Advanced_tether_buff_unlock3:IsPurgeException() return false end
function modifier_Advanced_tether_buff_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_tether_buff_unlock3:GetTexture() return "wisp_tether" end
function modifier_Advanced_tether_buff_unlock3:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_tether_buff_unlock3:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,150))
	end
end
function modifier_Advanced_tether_buff_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,

	}
	return funcs
end

function modifier_Advanced_tether_buff_unlock3:GetModifierExtraManaPercentage()	return self:GetStackCount() end



