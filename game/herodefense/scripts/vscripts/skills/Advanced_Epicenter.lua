--特效优化 √
Advanced_Epicenter = class({})

LinkLuaModifier("modifier_Advanced_Epicenter", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_2", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_slow", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_debuff", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_motion", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_passtive", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_unlock2", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Epicenter_unlock2_thinker", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Epicenter_unlock3", "skills/Advanced_Epicenter", LUA_MODIFIER_MOTION_NONE)
function Advanced_Epicenter:CheckKV(key)
	local table = {


		damage = 4,
		bonus_damage = 0.04,

	}
	local value = table[key] or -1
	return value

end
function Advanced_Epicenter:UnlockFirstCore(key)
	return true
end
function Advanced_Epicenter:UnlockSecondCore(key)

	local caster = self:GetCaster()

	self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Epicenter_unlock2",{})
	return true
end
function Advanced_Epicenter:UnlockThirdCore(key)
	local caster = self:GetCaster()
	if caster:HasAbility("heroTalent_npc_dota_hero_sand_king") then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	caster:AddNewModifier(caster,self,"modifier_Advanced_Epicenter_unlock3",{})
	return true
end

function Advanced_Epicenter:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET+ DOTA_ABILITY_BEHAVIOR_AOE+ DOTA_ABILITY_BEHAVIOR_CHANNELLED +DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
	end

	
	return self.BaseClass.GetBehavior(self)

end


function Advanced_Epicenter:IsHiddenWhenStolen() 		return false end
function Advanced_Epicenter:IsRefreshable() 			return true end
function Advanced_Epicenter:IsStealable() 				return true end
function Advanced_Epicenter:IsNetherWardStealable()	return true end
function Advanced_Epicenter:GetChannelAnimation() return ACT_DOTA_CAST_ABILITY_4 end
function Advanced_Epicenter:GetIntrinsicModifierName()   return "modifier_Advanced_Epicenter_passtive" end

function Advanced_Epicenter:OnSpellStart()
	local caster = self:GetCaster()
	
	if self.modifier and self:GetAutoCastState() then
		self.modifier:SafeDestroy()
		self.modifier = nil
		local target_point 	=caster:GetOrigin()
		local thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Epicenter_unlock2_thinker", 
			{}, -- kv
			target_point,
			caster:GetTeamNumber(),
			false
		)
	else
		if self:GetAutoCastState() and caster:GetGold()>=18000 then
			caster:ModifyGoldFiltered(-18000,true,DOTA_ModifyGold_PurchaseItem  )  --金币
			local target_point 	=caster:GetOrigin()
			local thinker = CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_Epicenter_unlock2_thinker", 
				{}, -- kv
				target_point,
				caster:GetTeamNumber(),
				false
			)
		end

	end




	caster:EmitSound("Ability.SandKing_Epicenter.spell")
	self.max_stack = self:GetSpecialValueFor("max_pulses")
	if self.unlock1 then
		self.max_stack = 17
	end
	self.think_time = self:GetChannelTime() / self.max_stack
	self.buff = caster:AddNewModifier(caster, self, "modifier_Advanced_Epicenter", {})
	if self.buff then
		self.buff:IncrementStackCount()
	end
	self.totaltime = 0
	self.think = 0
	---interval 0.8 1.8
end

function Advanced_Epicenter:OnChannelThink(time)

	self.totaltime = self.totaltime + time
	self.think = self.think + time
	for i=1, 4 do
		if self.totaltime <= i and i <= self.totaltime + time then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(275 + i*100,1,1))
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
	if not self.buff or self.buff:IsNull() then
		return
	end
	if self.think >= self.think_time and self.totaltime<(self.max_stack*self.think_time) then
	-- if self.think <= self.think_time and self.think_time <= self.think + time then
		local stack = math.min(self.buff:GetStackCount() + 1, self.max_stack)
		self.buff:SetStackCount(stack)
		self.think = 0
	end
end



function Advanced_Epicenter:OnChannelFinish(b)
	if not self.buff or self.buff:IsNull() then
		return
	end
	local stack = self.buff:GetStackCount()
	local interval = self:GetSpecialValueFor("pulse_duration") / stack
	if stack == 0 then
		interval = 0.1
	else
		if self.unlock1 then
			local heroes = GetAllRealHeroes()
			local caster = self:GetCaster()
			for _, unit in ipairs(heroes) do
				if caster~=unit then
					local ability = unit:FindAbilityByName("Advanced_Epicenter")
					if ability then
						ability:Unlock1BeTrigger(stack)
					end
				end
			end
		end
	end

	self.buff:StartIntervalThink(interval)
	self:GetCaster():EmitSound("Ability.SandKing_Epicenter")
	
	
end


function Advanced_Epicenter:SandKingEffect()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_Epicenter_2")
	if modifier then
		modifier:SetStackCount(modifier:GetStackCount()+1)
	else
		self.buff2 = caster:AddNewModifier(caster, self, "modifier_Advanced_Epicenter_2", {})
		if self.buff2 and not self.buff2:IsNull() then
			self.buff2:StartIntervalThink(0)
		end
		
	end
end

function Advanced_Epicenter:Unlock1BeTrigger(count)
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_Epicenter_2")
	if modifier then
		modifier:SetStackCount(modifier:GetStackCount()+count)
	else
		self.buff2 = caster:AddNewModifier(caster, self, "modifier_Advanced_Epicenter_2", {})
		if self.buff2 and not self.buff2:IsNull() then
			self.buff2:SetStackCount(count)
			self.buff2:StartIntervalThink(0.1)
		end
		
	end
end

modifier_Advanced_Epicenter = class({})

function modifier_Advanced_Epicenter:IsDebuff()			return false end
function modifier_Advanced_Epicenter:IsHidden() 		return false end
function modifier_Advanced_Epicenter:IsPurgable() 		return false end
function modifier_Advanced_Epicenter:IsPurgeException() return false end
function modifier_Advanced_Epicenter:RemoveOnDeath() 	return false end
function modifier_Advanced_Epicenter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Epicenter:OnIntervalThink()
	local caster = self:GetCaster()
	EpicenterTriggerAfterShock(caster)  --触发余震逻辑
	caster:EmitSound("Hero_Sandking.EpiPulse")
	self.radius = self.radius or self:GetAbility():GetSpecialValueFor('base_radius')
	self:DecrementStackCount()
	local pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/newr_epicenter_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius+1000,1,1))
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(self.radius+650,1,1))
	ParticleManager:ReleaseParticleIndex(pfx2)
	local damage = self.damage
	local wave = RandomInt(1, 2)
	if wave==1 then
		damage=damage*self.bonus_damage_index
	end
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local duration =self:GetAbility():GetSpecialValueFor("slow_duration")
	print("damage1=="..damage)
	for i, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_slow", {duration = duration *StatusResistance})
		--LV15解锁脑波
		if self.advanced_level>=15 then
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = 0.25 *StatusResistance})
			--LV20解锁共振
			if self.advanced_level>=20 then
				enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_debuff", {duration = 30 *StatusResistance})
			end
		end
		if wave==2 and (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("pull_strength") * 2.0 then
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_motion", {duration = 0.05})
		end
		if i>=10 then
			break
		end
	end
	-- if self:GetCaster():HasAbility("imba_sandking_treacherous_sands") and self:GetCaster():FindAbilityByName("imba_sandking_treacherous_sands"):GetToggleState() then
	-- 	local pull_radius = self:GetCaster():HasScepter() and self:GetAbility():GetSpecialValueFor("pull_radius_scepter") or self:GetAbility():GetSpecialValueFor("pull_radius")
	-- 	local enemies_pull = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _, enemy in pairs(enemies_pull) do
	-- 		if (enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("pull_strength") * 2.0 then
	-- 			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Epicenter_motion", {duration = 0.05})
	-- 		end
	-- 	end
	-- end
	-- self.radius = self.radius + self:GetAbility():GetSpecialValueFor("step_radius")
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end
function modifier_Advanced_Epicenter:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.advanced_level = ability.advanced_level
		self.damage = ability:GetSpecialValueFor("damage") + (ability:GetSpecialValueFor("bonus_damage"))*self:GetCaster():HDGetPrimaryStatValue()
		self.bonus_damage_index = 1.5
		--LV5解锁波+
		if self.advanced_level>=5 then
			self.bonus_damage_index = 1.8
		end
	end
end
function modifier_Advanced_Epicenter:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Sandking.EpiPulse")
		self.radius = nil
	end
end

modifier_Advanced_Epicenter_slow = class({})

function modifier_Advanced_Epicenter_slow:IsDebuff()			return true end
function modifier_Advanced_Epicenter_slow:IsHidden() 			return false end
function modifier_Advanced_Epicenter_slow:IsPurgable() 			return true end
function modifier_Advanced_Epicenter_slow:IsPurgeException() 	return true end
function modifier_Advanced_Epicenter_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Advanced_Epicenter_slow:GetModifierMoveSpeedBonus_Constant() return self.m_slow end
function modifier_Advanced_Epicenter_slow:GetModifierAttackSpeedBonus_Constant() return self.a_slow end


function modifier_Advanced_Epicenter_slow:OnCreated()
	self.m_slow = - self:GetAbility():GetSpecialValueFor("slow_ms")
	self.a_slow = - self:GetAbility():GetSpecialValueFor("slow_as")
end
function modifier_Advanced_Epicenter_slow:OnRefresh(table)
	self.m_slow = - self:GetAbility():GetSpecialValueFor("slow_ms")
	self.a_slow = - self:GetAbility():GetSpecialValueFor("slow_as")
end
modifier_Advanced_Epicenter_motion = class({})

function modifier_Advanced_Epicenter_motion:IsDebuff()				return false end
function modifier_Advanced_Epicenter_motion:IsHidden() 				return true end
function modifier_Advanced_Epicenter_motion:IsPurgable() 			return false end
function modifier_Advanced_Epicenter_motion:IsPurgeException() 		return false end
function modifier_Advanced_Epicenter_motion:IsMotionController() return true end
function modifier_Advanced_Epicenter_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Advanced_Epicenter_motion:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Epicenter_motion:OnIntervalThink()
	local distance = self:GetAbility():GetSpecialValueFor("pull_strength")
	--LV5解锁波+
	if self:GetAbility().advanced_level>=5 then
		distance = distance *1.5
	end
	distance = distance / (self:GetDuration() / FrameTime())
	local next_pos = self:GetParent():GetAbsOrigin() + (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized() * distance
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Advanced_Epicenter_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end


modifier_Advanced_Epicenter_passtive = class({})

function modifier_Advanced_Epicenter_passtive:IsDebuff()			return false end
function modifier_Advanced_Epicenter_passtive:IsHidden() 		return true end
function modifier_Advanced_Epicenter_passtive:IsPurgable() 		return false end
function modifier_Advanced_Epicenter_passtive:IsPurgeException() return false end
-- function modifier_Advanced_Epicenter_passtive:RemoveOnDeath() 	return false end

function modifier_Advanced_Epicenter_passtive:OnCreated()

	if not IsServer() then
		return
	end

	local need_str = 500
	local internal = self:GetCaster():HDGetPrimaryStatValue()/need_str
	if internal>1.5 then
		internal = 1.5
	end
	internal = 4-internal 
	self:StartIntervalThink(internal)
end

function modifier_Advanced_Epicenter_passtive:OnRefresh(table)
	if not IsServer() then
		return
	end
	local need_str = 500
	--LV10解锁地震源+
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		need_str= 350
	end
	local internal = self:GetCaster():HDGetPrimaryStatValue()/need_str
	if internal>1.5 then
		internal = 1.5
	end
	internal = 4-internal 
	self:StartIntervalThink(internal)
end

function modifier_Advanced_Epicenter_passtive:OnIntervalThink()
	local caster = self:GetCaster()
	local ability =  self:GetAbility()
	if not ability then
		return
	end
	if caster:GetHealth()<=0 then
		return
	end
	
	local buff = self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_2", {})
	buff:SetStackCount(1)
	buff:StartIntervalThink(0)
	self:OnRefresh()


end





modifier_Advanced_Epicenter_2 = class({})

function modifier_Advanced_Epicenter_2:IsDebuff()			return false end
function modifier_Advanced_Epicenter_2:IsHidden() 		return false end
function modifier_Advanced_Epicenter_2:IsPurgable() 		return false end
function modifier_Advanced_Epicenter_2:IsPurgeException() return false end
function modifier_Advanced_Epicenter_2:RemoveOnDeath() 	return false end
function modifier_Advanced_Epicenter_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Epicenter_2:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	EpicenterTriggerAfterShock(caster)  --触发余震逻辑
	caster:EmitSound("Hero_Sandking.EpiPulse")
	self.radius = self.radius or self:GetAbility():GetSpecialValueFor('base_radius')
	self:DecrementStackCount()
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(400,1,1))
	ParticleManager:ReleaseParticleIndex(pfx2)

	local ability = self:GetAbility()
	self.advanced_level = ability.advanced_level
	self.damage = ability:GetSpecialValueFor("damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:HDGetPrimaryStatValue()
	self.damage = self.damage *0.8
	self.bonus_damage_index = 1.5
	--LV5解锁波+
	if self.advanced_level>=5 then
		self.bonus_damage_index = 1.8
	end

	local damage = self.damage
	local wave = RandomInt(1, 2)
	if wave==1 then
		damage=damage*self.bonus_damage_index
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local duration =self:GetAbility():GetSpecialValueFor("slow_duration")
	print("damage2=="..damage)
	for i, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_slow", {duration = duration *StatusResistance})
		--LV15解锁脑波
		if self.advanced_level>=15 then
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = 0.25 *StatusResistance})
			--LV20解锁共振
			if self.advanced_level>=20 then
				enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Epicenter_debuff", {duration = 30 *StatusResistance})
			end
		end
		if wave==2 and (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("pull_strength") * 2.0 then
			enemy:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Epicenter_motion", {duration = 0.05})
		end
		if i>=10 then
			break
		end
	end

	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end

function modifier_Advanced_Epicenter_2:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Sandking.EpiPulse")
		self.radius = nil
	end
end



modifier_Advanced_Epicenter_debuff = advanced_modifier({})

function modifier_Advanced_Epicenter_debuff:IsDebuff() return true end
function modifier_Advanced_Epicenter_debuff:IsHidden() return false end
function modifier_Advanced_Epicenter_debuff:IsPurgable() return false end
function modifier_Advanced_Epicenter_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

	}
end
function modifier_Advanced_Epicenter_debuff:GetModifierMagicalResistanceBonus()	return -self:GetStackCount() end
function modifier_Advanced_Epicenter_debuff:Advanced_GetModifierPhysicalArmorBonus()	return -0.5*self:GetStackCount() end







function modifier_Advanced_Epicenter_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		

	end
end
function modifier_Advanced_Epicenter_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 50 then
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



function modifier_Advanced_Epicenter_debuff:OnIntervalThink()
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

function modifier_Advanced_Epicenter_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
modifier_Advanced_Epicenter_unlock2 = class({})

function modifier_Advanced_Epicenter_unlock2:IsDebuff()			return false end
function modifier_Advanced_Epicenter_unlock2:IsHidden() 			return true end
function modifier_Advanced_Epicenter_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Epicenter_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Epicenter_unlock2:RemoveOnDeath() return false end




modifier_Advanced_Epicenter_unlock2_thinker= modifier_Advanced_Epicenter_unlock2_thinker or class({})

function modifier_Advanced_Epicenter_unlock2_thinker:IsHidden()		return true end
function modifier_Advanced_Epicenter_unlock2_thinker:IsPurgable()		return false end
function modifier_Advanced_Epicenter_unlock2_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Epicenter_unlock2_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self:GetParent():AddNewModifier(self:GetCaster(),ability,"modifier_Advanced_Epicenter_passtive",{})
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Epicenter_unlock2_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
	end
end

function modifier_Advanced_Epicenter_unlock2_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end



modifier_Advanced_Epicenter_unlock3 = class({})

function modifier_Advanced_Epicenter_unlock3:IsDebuff()			return false end
function modifier_Advanced_Epicenter_unlock3:IsHidden() 			return false end
function modifier_Advanced_Epicenter_unlock3:IsPurgable() 		    return false end
function modifier_Advanced_Epicenter_unlock3:IsPurgeException() return false end
function modifier_Advanced_Epicenter_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Epicenter_unlock3:DestroyOnExpire() return false end
function modifier_Advanced_Epicenter_unlock3:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(0.85)     

    end
end
function modifier_Advanced_Epicenter_unlock3:OnIntervalThink()
    local ability = self:GetAbility()
  

    self.dis =self.dis+ CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    self.currentPos = self.parent:GetAbsOrigin()
    if self.dis>=700 then
        local cooldown = self:GetRemainingTime()
        if cooldown>=10 then
            return
        end
		local add_time = 1.5* self:GetParent():GetCooldownReduction()
        self:SetDuration(math.max(cooldown+add_time,add_time), true)
        self.dis = 0
        ability:SandKingEffect()
    end
end
