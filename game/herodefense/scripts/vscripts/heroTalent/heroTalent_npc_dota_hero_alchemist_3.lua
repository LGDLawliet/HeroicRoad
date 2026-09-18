LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_alchemist_3", "heroTalent/heroTalent_npc_dota_hero_alchemist_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_alchemist_3_active", "heroTalent/heroTalent_npc_dota_hero_alchemist_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_alchemist_3_active_update", "heroTalent/heroTalent_npc_dota_hero_alchemist_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_alchemist_3 == nil then
	heroTalent_npc_dota_hero_alchemist_3 = class({})
end
function heroTalent_npc_dota_hero_alchemist_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_alchemist_3"
end
function heroTalent_npc_dota_hero_alchemist_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Acid_Sparay",costKeys)
			end
		end)
	end
end
---------------------------------------------------------------------
--Modifiers

modifier_heroTalent_npc_dota_hero_alchemist_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_alchemist_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_alchemist_3:OnCreated(params)
	if IsServer() then
		
	end
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.time = self.time or self:GetAbility():GetSpecialValueFor("duration")
	self:SetStackCount(1)
	self:StartIntervalThink(1)
end
function modifier_heroTalent_npc_dota_hero_alchemist_3:OnIntervalThink()
	if not IsServer() then
		return 1
	end
	
	self.Activeted = self.Activeted or false
	local parent = self:GetParent()
	--获取所有npc_dota_thinker类的单位
	local entity_list = Entities:FindAllByClassnameWithin("npc_dota_thinker", parent:GetAbsOrigin(), 5000)
	local self_acid_ability = parent:FindAbilityByName("Primary_Acid_Sparay") or parent:FindAbilityByName("Advanced_Acid_Sparay") or parent:FindAbilityByName("Middle_Acid_Sparay")
	for key, entity in pairs(entity_list) do
		--从npc_dota_thinker类的单位的表里挑选出酸雾技能的thinker单位(就是那个酸雾)
		if entity:FindModifierByName("modifier_Primary_Acid_Sparay_thinker") then
			--从酸雾生成的thinker里获取酸雾技能本身
			local ability = entity:FindModifierByName("modifier_Primary_Acid_Sparay_thinker"):GetAbility()
			--获取酸雾的持续时间
			local duration = ability:GetSpecialValueFor("duration")
			---吞掉其他人技能的部分---
			--如果技能不是自己的 就执行吃掉的命令
			if ability:GetCaster() ~= parent then
				entity:RemoveSelf()
				self:SetStackCount(math.min(self:GetStackCount() + 1,self.max+1)) --添加这个天赋的层数
				self.time = self:GetAbility():GetSpecialValueFor("duration") --获得这个酸雾技能的持续时间
				self_acid_ability:EndCooldown()	--刷新技能
			end

			---传送并且提高攻击距离的部分---
			--这个Activeted是防止重复触发效果的
			if self.Activeted == false then
				--同样 把自己酸雾技能生成的thinker单位记录
				self:GetAbility().acid_thinker = entity:FindModifierByName("modifier_Primary_Acid_Sparay_thinker")
				parent:SetAbsOrigin(entity:GetAbsOrigin()) --把自己传送过去
				--判断人物等级 添加升级前后的modifier执行不同的效果
				if parent:GetLevel() < self.line then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active", {duration = duration})
					self.Activeted = true
				else
					-- print("update")
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active_update", {duration = duration})
					self.Activeted = true
					--创建一个间隔为FrameTime()也就是服务器刷新时间的循环 用来把酸雾tp过去
					Timers:CreateTimer(function()
						entity:SetAbsOrigin(parent:GetAbsOrigin())	
						if self.Activeted == true then
							return FrameTime()
						else
							return nil --返回nil结束这个循环 因为Activeted==false表示技能持续时间已经结束了
						end
					end)
					
				end
				Timers:CreateTimer(duration,function()
					self.Activeted = false --持续时间和技能相同 用来防止重复触发
				end)
	
			end
			
		end
		--参考第一部分
		if entity:FindModifierByName("modifier_Advanced_Acid_Sparay_thinker") then
			local ability = entity:FindModifierByName("modifier_Advanced_Acid_Sparay_thinker"):GetAbility()
			
			local duration = ability:GetSpecialValueFor("duration")
			--吞掉其他人技能的部分
			if ability:GetCaster() ~= parent then
				entity:RemoveSelf()
				self:SetStackCount(math.min(self:GetStackCount() + 1,self.max+1))
				self.time = self:GetAbility():GetSpecialValueFor("duration")
			end

			--传送并且提高攻击距离的部分
			if self.Activeted == false then
				self:GetAbility().acid_thinker = entity:FindModifierByName("modifier_Advanced_Acid_Sparay_thinker")
				parent:SetAbsOrigin(entity:GetAbsOrigin())
				if parent:GetLevel() < self.line then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active", {duration = duration})
					self.Activeted = true
				else
					-- print("update")
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active_update", {duration = duration})
					self.Activeted = true
					Timers:CreateTimer(function()
						entity:SetAbsOrigin(parent:GetAbsOrigin())	
						if self.Activeted == true then
							return FrameTime()
						else
							return nil
						end
					end)
				end
				Timers:CreateTimer(duration,function()
					self.Activeted = false
				end)
			end
			

		end

		if entity:FindModifierByName("modifier_Middle_Acid_Sparay_thinker") then
			local ability = entity:FindModifierByName("modifier_Middle_Acid_Sparay_thinker"):GetAbility()
			local duration = ability:GetSpecialValueFor("duration")
			--吞掉其他人技能的部分
			if ability:GetCaster() ~= parent then
				entity:RemoveSelf()
				self:SetStackCount(math.min(self:GetStackCount() + 1,self.max+1))
				self.time = self:GetAbility():GetSpecialValueFor("duration")
			end

			--传送并且提高攻击距离的部分
			if self.Activeted == false then
				self:GetAbility().acid_thinker = entity:FindModifierByName("modifier_Middle_Acid_Sparay_thinker")
				parent:SetAbsOrigin(entity:GetAbsOrigin())
				if parent:GetLevel() < self.line then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active", {duration = duration})
					self.Activeted = true
				else
					-- print("update.."..tostring(self.Activeted))
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_alchemist_3_active_update", {duration = duration})
					self.Activeted = true
					-- print("update2.."..tostring(self.Activeted))
					Timers:CreateTimer(function()
						entity:SetAbsOrigin(parent:GetAbsOrigin())	
						if self.Activeted == true then
							return FrameTime()
						else
							return nil
						end
					end)
				end
				Timers:CreateTimer(duration,function()
					self.Activeted = false
				end)
	
			end	
			
		end
	end


	self.time = math.max(self.time - 1,0)
	if self.time == 0 then
		self.time = self:GetAbility():GetSpecialValueFor("duration")
		self:SetStackCount(math.max(self:GetStackCount() - 1,1))
	end
	return 1
end
function modifier_heroTalent_npc_dota_hero_alchemist_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_alchemist_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_alchemist_3:DeclareFunctions()
	return {
	}
end
-------------------------------------------------------------------------
if modifier_heroTalent_npc_dota_hero_alchemist_3_active == nil then
	modifier_heroTalent_npc_dota_hero_alchemist_3_active = class({})
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active:CheckState()
	return{
		[MODIFIER_STATE_ROOTED] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active:GetModifierAttackRangeBonus()
	if not IsServer() then
		return 
	end
		self.radius = self:GetAbility().acid_thinker.radius or self.radius
		-- print(self.radius)
	return self.radius
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
--------------------
if modifier_heroTalent_npc_dota_hero_alchemist_3_active_update == nil then
	modifier_heroTalent_npc_dota_hero_alchemist_3_active_update = class({})
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active_update:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
end
function modifier_heroTalent_npc_dota_hero_alchemist_3_active_update:GetModifierAttackRangeBonus()
	if not IsServer() then
		return 
	end
	self.radius = self:GetAbility().acid_thinker.radius or self.radius
	return self.radius
end

function modifier_heroTalent_npc_dota_hero_alchemist_3_active_update:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end