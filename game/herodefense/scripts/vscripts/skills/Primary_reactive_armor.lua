Primary_reactive_armor = class({})
-- LinkLuaModifier("modifier_Primary_reactive_armor_arua", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_reactive_armor_arua_effect", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_reactive_armor", "skills/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_reactive_armor_active", "skills/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vitality", "skills/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_steady", "skills/Middle_Bulwark", LUA_MODIFIER_MOTION_NONE )

-- LinkLuaModifier("modifier_Primary_reactive_armor_effect", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_reactive_armor_effect2", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_reactive_armor_active_standby", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_reactive_armor_debuff", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_reactive_armor_thinker", "items/Primary_reactive_armor", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function Primary_reactive_armor:GetIntrinsicModifierName()
	return "modifier_Primary_reactive_armor"
end

modifier_Primary_reactive_armor = class({})

function modifier_Primary_reactive_armor:IsDebuff() return false end
function modifier_Primary_reactive_armor:IsHidden() return true end
function modifier_Primary_reactive_armor:IsPurgable() 		return false end
function modifier_Primary_reactive_armor:IsPurgeException() 	return false end
function modifier_Primary_reactive_armor:RemoveOnDeath()  return false end




function modifier_Primary_reactive_armor:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end


function modifier_Primary_reactive_armor:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.target ==parent and not parent:PassivesDisabled() then
			
			local ModifierStatusGain =  parent:GetModifierDurationGainIndex(1)
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_Primary_reactive_armor_active", {duration = self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusGain})
			

		end
	end
end





modifier_Primary_reactive_armor_active = advanced_modifier({})

function modifier_Primary_reactive_armor_active:IsDebuff() return false end
function modifier_Primary_reactive_armor_active:IsHidden() return false end
function modifier_Primary_reactive_armor_active:IsPurgable() return false end


function modifier_Primary_reactive_armor_active:GetModifierBonusStats_Intellect()	return 3*self:GetStackCount() end




function modifier_Primary_reactive_armor_active:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		self.VitalityCD = false
		self.healthbonus = 0
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Primary_reactive_armor_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= self.ability:GetSpecialValueFor("max_stack") then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

			--判断活力添加的cd
			print(self.VitalityCD)
			if self.VitalityCD == false then
				local table = {
					unit = self:GetParent(),
					modifier = self,
					ability = self:GetAbility()
				}
				FireVitalityEvent(table)
				self.VitalityCD = true
				Timers:CreateTimer(10,function ()
					self.VitalityCD = false
				end)
			end

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			
		end
	end
end

function modifier_Primary_reactive_armor_active:OnIntervalThink()
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
function modifier_Primary_reactive_armor_active:Advanced_GetModifierPhysicalArmorBonus() return self:GetStackCount() *self.ability:GetSpecialValueFor("bonus_armor") end 
function modifier_Primary_reactive_armor_active:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() *self.ability:GetSpecialValueFor("bonus_health_regeneration") end


function modifier_Primary_reactive_armor_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_VITALITY = {nil,self:GetParent()},
    }
end
function modifier_Primary_reactive_armor_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end
function modifier_Primary_reactive_armor_active:AdvancedOnVitality()
	local parent = self:GetParent()
	if parent:FindModifierByName("modifier_vitality") then
		local modifier_origin = parent:FindModifierByName("modifier_vitality") 
		
		if parent:FindModifierByName("modifier_steady") then
			local steady_modifier_origin = parent:FindModifierByName("modifier_steady")
			if steady_modifier_origin and steady_modifier_origin:GetStackCount() >= 10 then
				local stack = steady_modifier_origin:GetStackCount()
				modifier_origin:SetStackCount(math.floor(stack/5)*parent:GetMaxHealth()*0.01)
				steady_modifier_origin:Destroy()
			end
		else
			modifier_origin:IncrementStackCount()
		end
		
	else
		local modifier_origin = parent:AddNewModifier(parent, self:GetAbility(), "modifier_vitality", {duration = -1})
		if parent:FindModifierByName("modifier_steady") then
			local steady_modifier_origin = parent:FindModifierByName("modifier_steady")
			if steady_modifier_origin and steady_modifier_origin:GetStackCount() >= 10 then
				local stack = steady_modifier_origin:GetStackCount()
				modifier_origin:SetStackCount(math.floor(stack/5)*parent:GetMaxHealth()*0.01)
				steady_modifier_origin:Destroy()
			end
		else
			modifier_origin:IncrementStackCount()
		end
	end

	
end

-----------------------------------------------------------------------

--基础活力buff
modifier_vitality = advanced_modifier({})

function modifier_vitality:IsDebuff() return false end
function modifier_vitality:IsHidden() return false end
function modifier_vitality:IsPurgable() return false end
function modifier_vitality:RemoveOnDeath()  return false end
function modifier_vitality:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_vitality:GetModifierHealthBonus()
	return self:GetStackCount()
end

-------------------------------------------------------------------------