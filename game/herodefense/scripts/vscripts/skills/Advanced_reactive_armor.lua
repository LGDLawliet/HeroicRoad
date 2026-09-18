Advanced_reactive_armor = class({})

LinkLuaModifier("modifier_Advanced_reactive_armor", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reactive_armor_active", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reactive_armor_active_physical", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reactive_armor_active_magical", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reactive_armor_unlock1", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reactive_armor_unlock3", "skills/Advanced_reactive_armor", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
require('internal/timers')   --计时器功能
function Advanced_reactive_armor:GetIntrinsicModifierName()
	return "modifier_Advanced_reactive_armor"
end
function Advanced_reactive_armor:CheckKV(key)
	local table = {

	


		bonus_armor = 0.05,
		bonus_health_regeneration = 0.1,

		duration = 0.5,



	}
	local value = table[key] or -1
	return value

end

function Advanced_reactive_armor:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})
	
	return true
end
function Advanced_reactive_armor:UnlockSecondCore(key)
	return true
end
function Advanced_reactive_armor:UnlockThirdCore(key)
	return true
end

function Advanced_reactive_armor:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/reactive_armor/unlock1.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reactive_armor_unlock1/effect_active.vpcf", context )
end




modifier_Advanced_reactive_armor = class({})

function modifier_Advanced_reactive_armor:IsDebuff() return false end
function modifier_Advanced_reactive_armor:IsHidden() return true end
function modifier_Advanced_reactive_armor:IsPurgable() 		return false end
function modifier_Advanced_reactive_armor:IsPurgeException() 	return false end
function modifier_Advanced_reactive_armor:RemoveOnDeath()  return false end
function modifier_Advanced_reactive_armor:IsAura()
	if IsServer() and self:GetAbility().unlock3 then
		return true
	end
	return false
end

function modifier_Advanced_reactive_armor:GetModifierAura()	return "modifier_Advanced_reactive_armor_unlock3" end
function modifier_Advanced_reactive_armor:GetAuraRadius()	return 500  end
function modifier_Advanced_reactive_armor:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_reactive_armor:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_reactive_armor:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end


function modifier_Advanced_reactive_armor:OnCreated(table)
	if IsServer() then
		self.advanced_level = 1
	end
end

function modifier_Advanced_reactive_armor:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		

	}
end


function modifier_Advanced_reactive_armor:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.advanced_level = self:GetAbility().advanced_level
		if keys.target ==parent and not parent:PassivesDisabled() then
			
			local ModifierStatusGain =  parent:GetModifierDurationGainIndex(1)
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_reactive_armor_active", {duration = self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusGain})

			--LV15解锁致命活性
			if self.advanced_level>=15 then
				local damagetable= {
					attacker = parent,
					victim =keys.attacker,
					damage = parent:GetPhysicalArmorValue(false)*5,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability =self:GetAbility(),
					damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT
					+DOTA_DAMAGE_FLAG_REFLECTION
					+DOTA_DAMAGE_FLAG_HPLOSS
					+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
				}
				ApplyDamage(damagetable)
			end
			

		end
	end
end

function modifier_Advanced_reactive_armor:OnTakeDamage(keys)
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
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_reactive_armor_active_physical", {duration = 10})
				--LV5解锁伤害适配+
				if self.advanced_level>=5 then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_reactive_armor_active_physical", {duration = 10})
				end
			end

			if keys.damage_type==DAMAGE_TYPE_MAGICAL then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_reactive_armor_active_magical", {duration = 10})
				--LV5解锁伤害适配+
				if self.advanced_level>=5 then
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_reactive_armor_active_magical", {duration = 10})
				end
			end
		end
	end
end




modifier_Advanced_reactive_armor_active = advanced_modifier({})

function modifier_Advanced_reactive_armor_active:IsDebuff() return false end
function modifier_Advanced_reactive_armor_active:IsHidden() return false end
function modifier_Advanced_reactive_armor_active:IsPurgable() return false end




function modifier_Advanced_reactive_armor_active:OnCreated(params)
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })

		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_reactive_armor_active:OnRefresh(params)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	if IsServer() then
		local dieTime = self:GetDieTime()
		local duration = 5 
		--LV10解锁超活性+
		if self.advanced_level>=10 then
			duration = 8
		end
		if self.ability.unlock2 then
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			return
		end
		
		if self:GetStackCount()>= self.ability:GetSpecialValueFor("max_stack")*2 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = GameRules:GetGameTime()+duration })


		else
			if self:GetStackCount()>= self.ability:GetSpecialValueFor("max_stack")	then
				--超活性使新添加的状态持续5秒
				table.insert(self.tData, {dieTime = GameRules:GetGameTime()+duration })
				self:IncrementStackCount()
				return
			end
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_reactive_armor_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
		--LV20解锁初始装配
		if self.advanced_level>=20 and self:GetStackCount()<12  then
			self:IncrementStackCount()
		end
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end
function modifier_Advanced_reactive_armor_active:Advanced_GetModifierPhysicalArmorBonus() return self:GetStackCount() *self.bonus_armor end 
function modifier_Advanced_reactive_armor_active:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() *self.bonus_health_regeneration end


function modifier_Advanced_reactive_armor_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end
modifier_Advanced_reactive_armor_active_physical = class({})

function modifier_Advanced_reactive_armor_active_physical:IsDebuff() return false end
function modifier_Advanced_reactive_armor_active_physical:IsHidden() return false end
function modifier_Advanced_reactive_armor_active_physical:IsPurgable() return false end
function modifier_Advanced_reactive_armor_active_physical:GetTexture() return "shredder_reactive_armor_physical" end
function modifier_Advanced_reactive_armor_active_physical:OnCreated(keys)
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
function modifier_Advanced_reactive_armor_active_physical:OnRefresh(params)
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

function modifier_Advanced_reactive_armor_active_physical:OnIntervalThink()
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



function modifier_Advanced_reactive_armor_active_physical:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	
	}
end


function modifier_Advanced_reactive_armor_active_physical:OnTakeDamage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent and not parent:PassivesDisabled() then
			--过滤低伤害
			if keys.damage<=100 then
				return
			end
			if not parent:IsAlive() then
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
				
				-- print(keys.damage*self.bonus_heal)
			end

		end
	end
end





modifier_Advanced_reactive_armor_active_magical = class({})

function modifier_Advanced_reactive_armor_active_magical:IsDebuff() return false end
function modifier_Advanced_reactive_armor_active_magical:IsHidden() return false end
function modifier_Advanced_reactive_armor_active_magical:IsPurgable() return false end
function modifier_Advanced_reactive_armor_active_magical:GetTexture() return "shredder_reactive_armor_magical" end
function modifier_Advanced_reactive_armor_active_magical:OnCreated(keys)
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
function modifier_Advanced_reactive_armor_active_magical:OnRefresh(params)
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

function modifier_Advanced_reactive_armor_active_magical:OnIntervalThink()
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



function modifier_Advanced_reactive_armor_active_magical:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	
	}
end


function modifier_Advanced_reactive_armor_active_magical:OnTakeDamage(keys)
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
					if not self.ability or self.ability:IsNull() then
						return
					end
					parent:Heal(keys.damage*self.bonus_heal, self.ability)
				end)
			end

		end
	end
end










modifier_Advanced_reactive_armor_unlock1 = advanced_modifier({})

function modifier_Advanced_reactive_armor_unlock1:IsDebuff()			return false end
function modifier_Advanced_reactive_armor_unlock1:IsHidden() 			return true end
function modifier_Advanced_reactive_armor_unlock1:IsPurgable() 		return false end
function modifier_Advanced_reactive_armor_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_reactive_armor_unlock1:RemoveOnDeath() return false end



function modifier_Advanced_reactive_armor_unlock1:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_reactive_armor_unlock1:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end

	-- if keys.block_disabled then
    --     return 0 
    -- end
	local parent = self:GetParent()
	-- if parent:PassivesDisabled() then
	-- 	return
	-- end
	local health = parent:GetMaxHealth()*0.03
	if keys.damage>=health then
		
		parent:EmitSound("hd_electric.hit")
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/reactive_armor_unlock1/effect_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		-- ParticleManager:SetParticleControl(effect_cast, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(effect_cast, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex( effect_cast )
		DestroyParticleByDelay(effect_cast,1)
		return keys.damage - health
	end
	return 0 
end



modifier_Advanced_reactive_armor_unlock3 = advanced_modifier({})
function modifier_Advanced_reactive_armor_unlock3:IsHidden()	return false end
function modifier_Advanced_reactive_armor_unlock3:IsDebuff()	return true end
function modifier_Advanced_reactive_armor_unlock3:IsPurgable()	return false end
-- function modifier_Advanced_reactive_armor_unlock3:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_reactive_armor_unlock3:OnCreated(keys)
	if IsServer() then
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_reactive_armor_active")
		if modifier then
			self:SetStackCount(modifier:GetStackCount())
		end
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_reactive_armor_unlock3:OnIntervalThink()
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_reactive_armor_active")
	if modifier then
		self:SetStackCount(modifier:GetStackCount())
	end

end

function modifier_Advanced_reactive_armor_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_Advanced_reactive_armor_unlock3:Advanced_GetModifierPhysicalArmorBonus() return -self:GetStackCount() *self:GetAbility():GetSpecialValueFor("bonus_armor")*0.7 end 
