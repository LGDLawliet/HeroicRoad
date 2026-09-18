--特效优化 √
Advanced_Great_Cleave = class({})

LinkLuaModifier("modifier_Advanced_Great_Cleave_passive", "skills/Advanced_Great_Cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Great_Cleave_buff1", "skills/Advanced_Great_Cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Great_Cleave_buff2", "skills/Advanced_Great_Cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Great_Cleave_buff3", "skills/Advanced_Great_Cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Great_Cleave_debuff", "skills/Advanced_Great_Cleave", LUA_MODIFIER_MOTION_NONE)

function Advanced_Great_Cleave:IsHiddenWhenStolen() 	return false end
function Advanced_Great_Cleave:IsRefreshable() 		return true end
function Advanced_Great_Cleave:IsStealable() 			return true end
function Advanced_Great_Cleave:IsNetherWardStealable()	return true end
function Advanced_Great_Cleave:GetIntrinsicModifierName() return "modifier_Advanced_Great_Cleave_passive" end

function Advanced_Great_Cleave:CheckKV(key)
	local table = {

	
		cleave_pct =1.5,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Great_Cleave:UnlockFirstCore(key)
	return true
end
function Advanced_Great_Cleave:UnlockSecondCore(key)
	return true
end
function Advanced_Great_Cleave:UnlockThirdCore(key)
	return true
end


function Advanced_Great_Cleave:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/great_cleave/unlock1_effect/effect_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/great_cleave/unlock2_effect/effect_gods_strength_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/great_cleave/unlock3_effect/effect_crit.vpcf", context )

end

modifier_Advanced_Great_Cleave_passive = advanced_modifier({})

function modifier_Advanced_Great_Cleave_passive:IsDebuff()			return false end
function modifier_Advanced_Great_Cleave_passive:IsHidden() 			return true end
function modifier_Advanced_Great_Cleave_passive:IsPurgable() 		return false end
function modifier_Advanced_Great_Cleave_passive:IsPurgeException() 	return false end
function modifier_Advanced_Great_Cleave_passive:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.start_width = self.ability:GetSpecialValueFor("cleave_starting_width")
	self.end_width = self.ability:GetSpecialValueFor("cleave_ending_width")
	self.distance = self.ability:GetSpecialValueFor("cleave_distance")
	self.cleave = self.ability:GetSpecialValueFor("cleave_pct")*0.01
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.bonus_cleave = self.ability:GetSpecialValueFor("bonus_cleave")*0.01
end
function modifier_Advanced_Great_Cleave_passive:DeclareFunctions()
 return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
} 
end

function modifier_Advanced_Great_Cleave_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	local attacker = keys.attacker
	local caster =  self:GetCaster()
	local ability = self:GetAbility()
	local level = ability.advanced_level
	local random = math.random
	if caster:PassivesDisabled() then
		return
	end

	--LV15解锁七进七出
	if level>=15 then
		--被攻击
		local duration = 4
		if ability.unlock2 then
			duration = 9
		end
		if target==caster then
			-- caster:AddNewModifier(caster, ability, "modifier_Advanced_Great_Cleave_buff1", {duration = duration})
		--攻击
		elseif attacker==caster and not caster:IsInSpecialAttack() then   
			caster:AddNewModifier(caster, ability, "modifier_Advanced_Great_Cleave_buff2", {duration = duration})
		end

	end

	if attacker:IsDisableCleave() then
		return
	end
	if attacker:IsRangedAttacker()then
		return
	end

	if attacker ~= caster or target:IsBuilding() or target:IsOther()  or not target:IsAlive() then
		return
	end
	local attack_chance = self.chance
	--LV5解锁真·巨力挥舞+
	if level>=5 then
		attack_chance = 10
	end

	if ability.unlock1 then
		-- 奥义1
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
		nil, 	self.distance+150,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		FIND_ANY_ORDER, false)
		caster:EmitSound("Hero_Sven.GreatCleave.ti7")
		--真巨力挥舞
		if attack_chance >= random(1,100) then
			local modifierKeys = {
				duration = 0.1,
				iSpecialAttack = 0,
				iDisableApplyModifier = 0,
				iDisableCleave = 1,
				iDisableSplit = 1,
	
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifierKeys)
	

			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/great_cleave/unlock2_effect/effect_gods_strength_crit.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0,  caster:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
		
			local count = 0
			for i=1, #units do
				if units[i] ~= keys.target then
					caster:PerformAttack( units[i], true, true, true, true, false, false, true )
					count = count + 1
					if count>=10 then
						break
					end
				end
			end
			if pfx then
				ParticleManager:ReleaseParticleIndex(pfx)
			end
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end

		else
			-- 奥义一，真巨力挥舞未能触发：
			local dmg = keys.damage * self.cleave*(1+self.bonus_cleave)
			if level >= 10 then
				if 10 >= random(1,100) then
					dmg = dmg * 1.99
				end
			end
			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/great_cleave/unlock1_effect/effect_crit.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0,  caster:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
			if pfx then
				ParticleManager:ReleaseParticleIndex(pfx)
			end

			local count = 0
			for i=1, #units do
				if units[i] ~= keys.target then
					
					AttackCleaveDelay(attacker, units[i], ability, dmg)
					count = count + 1
					if count>=10 then
						break
					end
				end
			end


		end
	--附带音刃效果，奥义3
	elseif ability.unlock3 then

		local direction = GetDirection2D(keys.target:GetAbsOrigin(), caster:GetAbsOrigin())
		local units = FindUnitsInTrapezoid(caster:GetTeamNumber(), direction, GetGroundPosition(caster:GetAbsOrigin(), nil), self.start_width,
		self.end_width,
		self.distance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/great_cleave/unlock3_effect/effect_crit.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0,caster:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
		ParticleManager:ReleaseParticleIndex(pfx)

		if attack_chance >= random(1,100) then
			local modifierKeys = {
				duration = 0.1,
				iSpecialAttack = 0,
				iDisableApplyModifier = 0,
				iDisableCleave = 1,
				iDisableSplit = 1,
	
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifierKeys)
			local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0,caster:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			local count = 0
			for _, unit in ipairs(units) do
				if unit~=keys.target then
					unit:AddNewModifier(caster, ability, "modifier_Advanced_Great_Cleave_debuff", {duration = 10})
					caster:PerformAttack( unit, true, true, true, true, false, false, true )
					count = count + 1
					if count>=10 then
						break
					end
				end
			end


			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		else
			local dmg = keys.damage *self.cleave* (1+self.bonus_cleave)
			if level >= 10 then
				if 10 >= random(1,100) then
					dmg = dmg * 1.99
				end
			end
			local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0,caster:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)

			local count = 0
			for _, unit in ipairs(units) do
				if unit~=keys.target then
					unit:AddNewModifier(caster, ability, "modifier_Advanced_Great_Cleave_debuff", {duration = 10})
					AttackCleaveDelay(attacker, unit, ability, dmg)
					count = count + 1
					if count>=10 then
						break
					end
				end
			end

		end
	else
		--奥义2和常态
		if attack_chance >= random(1,100) then
			local modifierKeys = {
				duration = 0.1,
				iSpecialAttack = 0,
				iDisableApplyModifier = 0,
				iDisableCleave = 1,
				iDisableSplit = 1,
	
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifierKeys)

			local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
			DoTrueCleaveAttack(caster, keys.target, ability, 
				self.start_width,
				self.end_width, 
				self.distance, pfx)
				
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		else
			local dmg = keys.damage *self.cleave * (1+self.bonus_cleave)
			if level >= 10 then
				if 10 >= random(1,100) then
					dmg = dmg * 1.99
				end
			end
			local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
			DoIMBACleaveAttack(caster, keys.target, ability, dmg, 
				self.start_width,
				self.end_width, 
				self.distance, pfx)
			
		end
	end

	


end



function modifier_Advanced_Great_Cleave_passive:OnTakeDamage(keys)
	if IsServer() then   
		--LV20解锁一身是胆
		
		local attacker = keys.attacker
		local unit = keys.unit
		local ability = self:GetAbility()
		local level = ability.advanced_level
		local parent = self:GetParent()
		if level<20 then return end
		if attacker==parent or unit==parent then
			parent:AddNewModifier(parent, ability, "modifier_Advanced_Great_Cleave_buff3", {duration = 15})
		end
    end 
end


modifier_Advanced_Great_Cleave_buff1 = advanced_modifier({})

function modifier_Advanced_Great_Cleave_buff1:IsDebuff() return false end
function modifier_Advanced_Great_Cleave_buff1:IsHidden() return false end
function modifier_Advanced_Great_Cleave_buff1:IsPurgable() return false end

function modifier_Advanced_Great_Cleave_buff1:Advanced_GetModifierPhysicalArmorBonus()	return 2*self:GetStackCount() end
function modifier_Advanced_Great_Cleave_buff1:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.max = 7
		if self.ability.unlock2 then
			self.max = 35
		end
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	

	end
end
function modifier_Advanced_Great_Cleave_buff1:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= self.max then
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

function modifier_Advanced_Great_Cleave_buff1:OnIntervalThink()
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

function modifier_Advanced_Great_Cleave_buff1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


modifier_Advanced_Great_Cleave_buff2 = advanced_modifier({})

function modifier_Advanced_Great_Cleave_buff2:IsDebuff() return false end
function modifier_Advanced_Great_Cleave_buff2:IsHidden() return false end
function modifier_Advanced_Great_Cleave_buff2:IsPurgable() return false end
function modifier_Advanced_Great_Cleave_buff2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力
	

	}
end

function modifier_Advanced_Great_Cleave_buff2:Advanced_GetModifierBaseAttack_BonusDamage()	return 20*self:GetStackCount() end
function modifier_Advanced_Great_Cleave_buff2:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.max = 9
		if self.ability.unlock2 then
			self.max = 99
		end
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		

	end
end
function modifier_Advanced_Great_Cleave_buff2:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= self.max then
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




function modifier_Advanced_Great_Cleave_buff2:OnIntervalThink()
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








modifier_Advanced_Great_Cleave_buff3 = advanced_modifier({})

function modifier_Advanced_Great_Cleave_buff3:IsDebuff() return false end
function modifier_Advanced_Great_Cleave_buff3:IsHidden() return false end
function modifier_Advanced_Great_Cleave_buff3:IsPurgable() return false end
function modifier_Advanced_Great_Cleave_buff3:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,       --攻击速度
	
	}
end

function modifier_Advanced_Great_Cleave_buff3:Advanced_GetModifierBaseAttack_BonusDamage()
	if not self:GetAbility() then self:Destroy() return end
	return 2*self:GetStackCount() 
end
function modifier_Advanced_Great_Cleave_buff3:Advanced_GetModifierPhysicalArmorBonus()	
	if not self:GetAbility() then self:Destroy() return end
	return 0.2*self:GetStackCount()
end
function modifier_Advanced_Great_Cleave_buff3:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end
end


function modifier_Advanced_Great_Cleave_buff3:OnIntervalThink()
	if IsServer() then
		-- local stack = self:GetStackCount()
		-- if stack<200 then    
		-- 	self:IncrementStackCount()	
		-- 	self:StartIntervalThink(2-stack*0.01)
		-- else
		-- 	self:StartIntervalThink(-1)
		-- end
		

		self:SetStackCount(math.min(self:GetStackCount()+1 , 100))
	end
end









modifier_Advanced_Great_Cleave_debuff = advanced_modifier({})

function modifier_Advanced_Great_Cleave_debuff:IsDebuff() return true end
function modifier_Advanced_Great_Cleave_debuff:IsHidden() return false end
function modifier_Advanced_Great_Cleave_debuff:IsPurgable() return false end
function modifier_Advanced_Great_Cleave_debuff:IsPurgeException() return false end
function modifier_Advanced_Great_Cleave_debuff:Advanced_GetModifierPhysicalArmorBonus()	return -2*self:GetStackCount() end
function modifier_Advanced_Great_Cleave_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	

	end
end
function modifier_Advanced_Great_Cleave_debuff:OnRefresh(params)
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

function modifier_Advanced_Great_Cleave_debuff:OnIntervalThink()
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

function modifier_Advanced_Great_Cleave_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end