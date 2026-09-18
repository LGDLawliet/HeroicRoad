Middle_reactive_armor = class({})

LinkLuaModifier("modifier_Middle_reactive_armor", "skills/Middle_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reactive_armor_active", "skills/Middle_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reactive_armor_active_physical", "skills/Middle_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reactive_armor_active_magical", "skills/Middle_reactive_armor", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
require('internal/timers')   --计时器功能
function Middle_reactive_armor:GetIntrinsicModifierName()
	return "modifier_Middle_reactive_armor"
end

modifier_Middle_reactive_armor = class({})

function modifier_Middle_reactive_armor:IsDebuff() return false end
function modifier_Middle_reactive_armor:IsHidden() return true end
function modifier_Middle_reactive_armor:IsPurgable() 		return false end
function modifier_Middle_reactive_armor:IsPurgeException() 	return false end
function modifier_Middle_reactive_armor:RemoveOnDeath()  return false end




function modifier_Middle_reactive_armor:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		

	}
end


function modifier_Middle_reactive_armor:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.target ==parent and not parent:PassivesDisabled() then
			
			local ModifierStatusGain =  parent:GetModifierDurationGainIndex(1)
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_Middle_reactive_armor_active", {duration = self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusGain})
			

		end
	end
end

function modifier_Middle_reactive_armor:OnTakeDamage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent and not parent:PassivesDisabled() then
			--过滤低伤害
			if keys.damage<=100 then
				return
			end
			--过滤不该触发的伤害
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	
			if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

			if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Middle_reactive_armor_active_physical", {duration = 10})
			end

			if keys.damage_type==DAMAGE_TYPE_MAGICAL then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Middle_reactive_armor_active_magical", {duration = 10})
			end
		end
	end
end




modifier_Middle_reactive_armor_active = advanced_modifier({})

function modifier_Middle_reactive_armor_active:IsDebuff() return false end
function modifier_Middle_reactive_armor_active:IsHidden() return false end
function modifier_Middle_reactive_armor_active:IsPurgable() return false end


function modifier_Middle_reactive_armor_active:GetModifierBonusStats_Intellect()	return 3*self:GetStackCount() end




function modifier_Middle_reactive_armor_active:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Middle_reactive_armor_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= self.ability:GetSpecialValueFor("max_stack") then
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

function modifier_Middle_reactive_armor_active:OnIntervalThink()
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
function modifier_Middle_reactive_armor_active:Advanced_GetModifierPhysicalArmorBonus() return self:GetStackCount() *self.ability:GetSpecialValueFor("bonus_armor") end 
function modifier_Middle_reactive_armor_active:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() *self.ability:GetSpecialValueFor("bonus_health_regeneration") end

function modifier_Middle_reactive_armor_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

modifier_Middle_reactive_armor_active_physical = class({})

function modifier_Middle_reactive_armor_active_physical:IsDebuff() return false end
function modifier_Middle_reactive_armor_active_physical:IsHidden() return false end
function modifier_Middle_reactive_armor_active_physical:IsPurgable() return false end
function modifier_Middle_reactive_armor_active_physical:GetTexture() return "shredder_reactive_armor_physical" end
function modifier_Middle_reactive_armor_active_physical:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)

		self.bonus_heal = self:GetStackCount()*0.005
		self.max_heal = 0.3

	end
end
function modifier_Middle_reactive_armor_active_physical:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self.bonus_heal >=self.max_heal then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			self.bonus_heal = self:GetStackCount()*0.005
		end
	end
end

function modifier_Middle_reactive_armor_active_physical:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				self.bonus_heal = self:GetStackCount()*0.005
			end
		end
	end
end



function modifier_Middle_reactive_armor_active_physical:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	
	}
end


function modifier_Middle_reactive_armor_active_physical:OnTakeDamage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent and not parent:PassivesDisabled() then
			--过滤低伤害
			if keys.damage<=100 then
				return
			end
			--过滤不该触发的伤害
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	
			if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

			if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
				--这是不被加强的治疗
				Timers:CreateTimer(0.2, function()
					parent:Heal(keys.damage*self.bonus_heal, self.ability)
				end)
			end

		end
	end
end





modifier_Middle_reactive_armor_active_magical = class({})

function modifier_Middle_reactive_armor_active_magical:IsDebuff() return false end
function modifier_Middle_reactive_armor_active_magical:IsHidden() return false end
function modifier_Middle_reactive_armor_active_magical:IsPurgable() return false end
function modifier_Middle_reactive_armor_active_magical:GetTexture() return "shredder_reactive_armor_magical" end
function modifier_Middle_reactive_armor_active_magical:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)

		self.bonus_heal = self:GetStackCount()*0.02
		self.max_heal = 0.3

	end
end
function modifier_Middle_reactive_armor_active_magical:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self.bonus_heal >=self.max_heal then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			self.bonus_heal = self:GetStackCount()*0.02
		end
	end
end

function modifier_Middle_reactive_armor_active_magical:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				self.bonus_heal = self:GetStackCount()*0.02
			end
		end
	end
end



function modifier_Middle_reactive_armor_active_magical:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	
	}
end


function modifier_Middle_reactive_armor_active_magical:OnTakeDamage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent and not parent:PassivesDisabled() then
			--过滤低伤害
			if keys.damage<=100 then
				return
			end
			--过滤不该触发的伤害
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	
			if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

			if keys.damage_type==DAMAGE_TYPE_MAGICAL then
				--这是不被加强的治疗
				Timers:CreateTimer(0.2, function()
					parent:Heal(keys.damage*self.bonus_heal, self.ability)
				end)
			end

		end
	end
end
