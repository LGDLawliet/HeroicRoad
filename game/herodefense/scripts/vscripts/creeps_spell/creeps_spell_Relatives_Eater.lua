------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_Relatives_Eater = class({})

LinkLuaModifier("modifier_creeps_spell_Relatives_Eater_passive", "creeps_spell/creeps_spell_Relatives_Eater", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Relatives_Eater_effect", "creeps_spell/creeps_spell_Relatives_Eater", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Relatives_Eater_refresh", "creeps_spell/creeps_spell_Relatives_Eater", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function creeps_spell_Relatives_Eater:GetIntrinsicModifierName() return "modifier_creeps_spell_Relatives_Eater_passive" end

modifier_creeps_spell_Relatives_Eater_passive = class({})

function modifier_creeps_spell_Relatives_Eater_passive:IsHidden() return true end
function modifier_creeps_spell_Relatives_Eater_passive:IsAura() return true end
function modifier_creeps_spell_Relatives_Eater_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Relatives_Eater_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Relatives_Eater_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Relatives_Eater_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Relatives_Eater_passive:GetModifierAura() return "modifier_creeps_spell_Relatives_Eater_effect" end
function modifier_creeps_spell_Relatives_Eater_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Relatives_Eater_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Relatives_Eater_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Relatives_Eater_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_creeps_spell_Relatives_Eater_passive:OnCreated(table)
	if IsServer() then
		self:GetAbility().max_bonus = 3000
		Timers:CreateTimer(2, function()
			self:GetAbility().max_bonus = self:GetCaster():GetMaxHealth()*12
			print(self.max_bonus)

		end)
	end
end


function modifier_creeps_spell_Relatives_Eater_passive:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,       --攻击速度


	}
end


function modifier_creeps_spell_Relatives_Eater_passive:GetModifierBaseAttack_BonusDamage() 	return self:GetStackCount() end



modifier_creeps_spell_Relatives_Eater_effect = class({})

function modifier_creeps_spell_Relatives_Eater_effect:IsDebuff()			return false end
function modifier_creeps_spell_Relatives_Eater_effect:IsHidden() 			return true end
function modifier_creeps_spell_Relatives_Eater_effect:IsPurgable() 			return false end
function modifier_creeps_spell_Relatives_Eater_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Relatives_Eater_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creeps_spell_Relatives_Eater_effect:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(5)
	end
end

function modifier_creeps_spell_Relatives_Eater_effect:OnIntervalThink(table)
	if IsServer() then
	
		local unit = self:GetParent()
		if not unit:IsAlive() then
			return
		end
		if unit:PassivesDisabled() then
			return
		end
		if unit:GetUnitName()=="npc_monster_wave_4_1" or unit:GetUnitName()=="npc_monster_wave_4_1_1" then
			-- print("power up")
			local caster = self:GetAbility():GetCaster()
			local ability = self:GetAbility()
			local bonus_damage =ability:GetSpecialValueFor("bonus_damage") 
			local bonus_armor =ability:GetSpecialValueFor("bonus_armor")
			local bonus_health = ability:GetSpecialValueFor("bonus_health")

			-- IncreaseHealth(unit,-bonus_health)
			-- IncreaseArmor(unit,-bonus_armor)
			-- IncreaseDamage(unit,-bonus_damage)
	
			local heal = caster:GetMaxHealth()* ability:GetSpecialValueFor("healing") *0.01
			local healing = HealWithGain(heal,caster,caster,self:GetAbility())

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, healing, nil) 

			if caster:GetMaxHealth()>=self:GetAbility().max_bonus then
				return
			end
			-- print("power up finished")
			IncreaseHealth(caster,bonus_health)
			IncreaseArmor(caster,bonus_armor)
			-- IncreaseDamage(caster,bonus_damage)
			local modifier = caster:FindModifierByName("modifier_creeps_spell_Relatives_Eater_passive")
			if modifier then
				modifier:SetStackCount(modifier:GetStackCount()+bonus_damage)
			end


			caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Relatives_Eater_refresh", {duration=0.1})
		end
	
	end
end


modifier_creeps_spell_Relatives_Eater_refresh = class({})

function modifier_creeps_spell_Relatives_Eater_refresh:IsDebuff()			return false end
function modifier_creeps_spell_Relatives_Eater_refresh:IsHidden() 			return true end
function modifier_creeps_spell_Relatives_Eater_refresh:IsPurgable() 		return false end
function modifier_creeps_spell_Relatives_Eater_refresh:IsPurgeException() 	return false end
function modifier_creeps_spell_Relatives_Eater_refresh:RemoveOnDeath() 	    return false end

