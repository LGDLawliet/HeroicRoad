Advanced_Vampiric_Spirit = class({})
LinkLuaModifier( "modifier_Advanced_Vampiric_Spirit", "skills/Advanced_Vampiric_Spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vampiric_Spirit_effect", "skills/Advanced_Vampiric_Spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Vampiric_Spirit_buff", "skills/Advanced_Vampiric_Spirit", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function Advanced_Vampiric_Spirit:GetIntrinsicModifierName()
	return "modifier_Advanced_Vampiric_Spirit"
end
function Advanced_Vampiric_Spirit:CheckKV(key)
	local table = {
        bonus_life_steal=0.05,
		bonus_life_steal_constant = 1,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Vampiric_Spirit:UnlockFirstCore(key)
	local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Burrow_Strike_unlock1",{})
	self.unlock1_value = 0
	self.modifier = caster:FindModifierByName("modifier_Advanced_Vampiric_Spirit")
	if self.modifier then
		self.modifier:ForceRefresh()
	else
		self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Vampiric_Spirit",{})
	end
	return true
end
function Advanced_Vampiric_Spirit:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
--unlock3效果写在目标技能里了
function Advanced_Vampiric_Spirit:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end
function Advanced_Vampiric_Spirit:ModifyUnlock1Value(value)
	self.unlock1_value = self.unlock1_value + value
	if self.modifier and not self.modifier:IsNull() then
		self.modifier:SetStackCount(self.unlock1_value)
	else
		self.modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Vampiric_Spirit")
	end
end
function Advanced_Vampiric_Spirit:Unlock1Update()
	self.unlock1_value = self.unlock1_value *0.99
	if self.modifier and not self.modifier:IsNull() then
		self.modifier:SetStackCount(self.unlock1_value)
	else
		self.modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Vampiric_Spirit")
	end
end
function Advanced_Vampiric_Spirit:GetUnlock1Stack()
	return self.unlock1_value
end
-- function Advanced_Vampiric_Spirit:GetUnlock1HealEffect(value)
-- 	local heal = self.unlock1_value
-- 	if value>=self.unlock1_value then
		
-- 		self.unlock1_value = 0
-- 	else
-- 		self.unlock1_value = self.unlock1_value - value
-- 		heal = value
-- 	end
-- 	return heal
-- end

modifier_Advanced_Vampiric_Spirit = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Vampiric_Spirit:IsHidden()	return not self.unlock1 end
function modifier_Advanced_Vampiric_Spirit:IsDebuff()	return false end
function modifier_Advanced_Vampiric_Spirit:IsPurgable() 		return false end
function modifier_Advanced_Vampiric_Spirit:IsPurgeException() 	return false end
function modifier_Advanced_Vampiric_Spirit:RemoveOnDeath()  return false end
function modifier_Advanced_Vampiric_Spirit:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Vampiric_Spirit:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Vampiric_Spirit:GetModifierAura()	return "modifier_Advanced_Vampiric_Spirit_effect" end
function modifier_Advanced_Vampiric_Spirit:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Advanced_Vampiric_Spirit:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Vampiric_Spirit:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Vampiric_Spirit:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Vampiric_Spirit:OnCreated(keys)
	if self:GetAbility():GetUnlock(1)==1 then
		self.unlock1 = true
		if IsServer() then
			self:StartIntervalThink(1)
		end
	end

end
function modifier_Advanced_Vampiric_Spirit:OnRefresh(keys)
	if self:GetAbility():GetUnlock(1)==1 then
		self.unlock1 = true
		if IsServer() then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_Advanced_Vampiric_Spirit:OnIntervalThink()
	self:GetAbility():Unlock1Update()

end


modifier_Advanced_Vampiric_Spirit_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Vampiric_Spirit_effect:IsHidden()	return false end
function modifier_Advanced_Vampiric_Spirit_effect:IsDebuff()	return false end
function modifier_Advanced_Vampiric_Spirit_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Vampiric_Spirit_effect:IsPurgable()	return false end
function modifier_Advanced_Vampiric_Spirit_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
	return funcs
end

function modifier_Advanced_Vampiric_Spirit_effect:OnCreated(table)
	self:StartIntervalThink(1)
	self.advanced_level = 1

	if IsServer() then
		self.bonus_health = self:GetCaster():HDGetPrimaryStatValue()*5

		
		
	end
end
function modifier_Advanced_Vampiric_Spirit_effect:OnIntervalThink(table)

	local ability = self:GetAbility()
	if not ability then
		return
	end
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")

	if IsServer() then
		local index = 5
		if self:GetAbility().advanced_level>=5 then
			index = 8
	
		end
		self.bonus_health = self:GetCaster():HDGetPrimaryStatValue()*index
	end


end






function modifier_Advanced_Vampiric_Spirit_effect:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit

		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
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

		local ability = self:GetAbility()
		if not ability then
			return
		end

		if Attacker:GetHealthPercent()>=100 then
			local bonus_life_steal = 0.01
			local index = 0.02
			local duration = 5
			if self.advanced_level>=10 then
				index = 0.035
				duration = 10
		
			end
			local gain = (100+Attacker:GetModifierLifeStealGain(1))*index
			local flLifesteal =( flDamage * bonus_life_steal)*gain
			flLifesteal = flLifesteal-flLifesteal%1
			if flLifesteal<=0 then
				return
			end

			Attacker:AddNewModifier(Attacker, ability, "modifier_Advanced_Vampiric_Spirit_buff", {duration = duration,stack = flLifesteal})
		else

			local bonus_life_steal = ability:GetSpecialValueFor("bonus_life_steal")*0.01
			local gain = Attacker:GetModifierLifeStealGain(1)
			local flLifesteal =( flDamage * bonus_life_steal+ability:GetSpecialValueFor("bonus_life_steal_constant"))*gain
			if flLifesteal<=0 then
				return
			end
			Attacker:Heal( flLifesteal, self:GetAbility() )
			self:PlayEffects( Attacker )
		end
		
	end

	return 0.0

end
function modifier_Advanced_Vampiric_Spirit_effect:GetModifierHealthBonus() return self:GetParent():IsRealHero() and self.bonus_health or 0 end
function modifier_Advanced_Vampiric_Spirit_effect:Advanced_GetModifierPhysicalArmorBonus() 
	if self.advanced_level>=20 and self:GetParent():GetHealthPercent()>=100 then
		return 60
	end
	return  0 
end

function modifier_Advanced_Vampiric_Spirit_effect:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_Advanced_Vampiric_Spirit_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


modifier_Advanced_Vampiric_Spirit_buff = advanced_modifier({})

function modifier_Advanced_Vampiric_Spirit_buff:IsDebuff() return false end
function modifier_Advanced_Vampiric_Spirit_buff:IsHidden() return false end
function modifier_Advanced_Vampiric_Spirit_buff:IsPurgable() return false end

function modifier_Advanced_Vampiric_Spirit_buff:DeclareFunctions()
	local funcs = {

	}
	if self:GetParent():IsRealHero() and self:GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
	end

	return funcs
end

function modifier_Advanced_Vampiric_Spirit_buff:GetModifierBonusStats_Strength()	return self.bonus_attribute end
function modifier_Advanced_Vampiric_Spirit_buff:GetModifierBonusStats_Intellect()	return self.bonus_attribute end
function modifier_Advanced_Vampiric_Spirit_buff:GetModifierBonusStats_Agility()	return self.bonus_attribute end
function modifier_Advanced_Vampiric_Spirit_buff:Advanced_GetModifierSpellAmplifyBonus()	return self.bonus_spell_damage end
function modifier_Advanced_Vampiric_Spirit_buff:Advanced_GetModifierIncomingDamage_Percentage()	return self.damage_reduction end
-- function modifier_Advanced_Vampiric_Spirit_buff:GetModifierTotalDamageOutgoing_Percentage()	return self.bonus_damage end






function modifier_Advanced_Vampiric_Spirit_buff:OnCreated(keys)
	self.bonus_attribute = 0
	self.bonus_spell_damage = 0
	self.damage_reduction = 0
	self.bonus_damage = 0
	self.bonus_status_resistance = 0

	self:StartIntervalThink(0.2)
	if IsServer() then

		
		local ability = self:GetAbility()
		if ability.unlock1 then
			ability:ModifyUnlock1Value(keys.stack)
		else
			self:SetStackCount(keys.stack)
		end
		
	end
end
function modifier_Advanced_Vampiric_Spirit_buff:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			ability:ModifyUnlock1Value(keys.stack)
		else
			self:SetStackCount(self:GetStackCount()+ keys.stack)
		end
		
	end
end

function modifier_Advanced_Vampiric_Spirit_buff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if self:GetParent():IsRealHero() and ability:GetUnlock(2)==2 then
		self.bonus_attribute = 0
		self.bonus_spell_damage = 0
		self.damage_reduction = 0
		self.bonus_damage = 0
		local stack = self:GetStackCount()
		local parent_health = self:GetParent():GetMaxHealth()
		if stack>=parent_health then
			self.bonus_attribute = 20
			if stack>=parent_health*5 then
				self.bonus_attribute = 40
				if stack>=parent_health*10 then
					self.bonus_spell_damage = 40
					if stack>=parent_health*20 then
						self.damage_reduction = -10
						if stack>=parent_health*40 then
							self.bonus_damage = 60
						end
					end
				end
			end
		end
	end
	
	local parent = self:GetParent()
	local stack = self:GetStackCount()
	if ability:GetUnlock(1)==1 then
		stack = ability:GetUnlock1Stack()
	end
	if ability:GetSpecialValueFor("advanced_level")>=15 then
		if stack>=parent:GetMaxHealth()*0.4 then
			self.bonus_status_resistance = 50
		else
			self.bonus_status_resistance = 0
		end
	end
	if IsServer() then
		-- local hParent = self:GetParent()
	


		if ability.unlock1 then
			if parent:GetHealthPercent()<100 then
				local health = parent:GetMaxHealth()-parent:GetHealth()
				health = health-health%1
				
				if stack>health then
					parent:SetHealth(parent:GetMaxHealth())
					-- self:SetStackCount(self:GetStackCount()-health)
					ability:ModifyUnlock1Value(-health)
				else
					parent:SetHealth(parent:GetHealth()+stack)
					ability:ModifyUnlock1Value(-stack)
					-- self:SafeDestroy()
				end
			end
	
		else
			
			if not ability.unlock3 then
				
				if parent:GetHealthPercent()<100 then
					local health = parent:GetMaxHealth()-parent:GetHealth()
					health = health-health%1
					
					if stack>health then
						parent:SetHealth(parent:GetMaxHealth())
						self:SetStackCount(self:GetStackCount()-health)
					else
						parent:SetHealth(parent:GetHealth()+stack)
						self:SafeDestroy()
					end
				end
			end
			
	

		end
		




	end
end


-- advanced_modifier
function modifier_Advanced_Vampiric_Spirit_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_StatusResistance,
    }

	if self:GetParent():IsRealHero() and self:GetUnlock(2)==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS)
	end
	if self:GetUnlock(3)==3 then
		funcs["MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK"] = {nil, self:GetParent()}
	end
	return funcs

end
function modifier_Advanced_Vampiric_Spirit_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.bonus_damage
end



function modifier_Advanced_Vampiric_Spirit_buff:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return  self:GetStackCount()
	end
	-- if keys.block_disabled then
    --     return 0 
    -- end
	-- if not IsServer() then
	-- 	return
	-- end
	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end

function modifier_Advanced_Vampiric_Spirit_buff:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end
