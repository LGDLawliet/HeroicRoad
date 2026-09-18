LinkLuaModifier("modifier_Advanced_split_shot", "skills/Advanced_split_shot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_split_shot_apply", "skills/Advanced_split_shot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_split_shot_buff", "skills/Advanced_split_shot", LUA_MODIFIER_MOTION_NONE)

Advanced_split_shot = class({})


function Advanced_split_shot:CheckKV(key)
	local table = {
		bonus_damage=1.5,
	}
	local value = table[key] or -1
	return value

end

function Advanced_split_shot:OnUpgrade()
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end


function Advanced_split_shot:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_split_shot:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_split_shot:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_split_shot", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_split_shot", self:GetCaster())
	end
end

modifier_Advanced_split_shot_apply	= advanced_modifier({})

function modifier_Advanced_split_shot_apply:IsHidden()	return true end
function modifier_Advanced_split_shot_apply:IsPurgable()	return false end

modifier_Advanced_split_shot	= advanced_modifier({})

function modifier_Advanced_split_shot:IsHidden()	return false end
function modifier_Advanced_split_shot:IsPurgable()	return false end
function modifier_Advanced_split_shot:OnCreated(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
		local talent3 = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_medusa_3")
		if talent3 then
			self.split_shot = self.split_shot + talent3:GetSpecialValueFor("bonus_split")
		end
	end
end

function modifier_Advanced_split_shot:OnRefresh(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
		local talent3 = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_medusa_3")
		if talent3 then
			self.split_shot = self.split_shot + talent3:GetSpecialValueFor("bonus_split")
		end
	end
end

function modifier_Advanced_split_shot:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ORDER
    }
end

function modifier_Advanced_split_shot:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end

function modifier_Advanced_split_shot:Advanced_GetModifierAttackSpeedPercentage()
	return -self:GetAbility():GetSpecialValueFor("attack_speed_down")
end

function modifier_Advanced_split_shot:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if not self:GetParent():IsRangedAttacker() then
		return
	end
	if self:GetParent():IsDisableSplit() then  --分裂箭无效化
		return    
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local attacker = keys.attacker

	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
		local apply_modifiers = false
		local apply_cd = self:GetAbility():GetSpecialValueFor("interval")

		local no_miss = false
		if self:GetAbility().advanced_level >= 5 then
			no_miss = true
		end
		if self:GetAbility().advanced_level >= 15 then
			apply_cd = 0.3
		end
		

		-- Mark 禁用添加修饰器
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 1,
			iDisableCleave =1,
			iDisableSplit = 1,
		}
	
		if not keys.attacker:HasModifier("modifier_Advanced_split_shot_apply") then
			apply_modifiers = true
			modifier_keys.iDisableApplyModifier = 0
			keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_Advanced_split_shot_apply",{duration = apply_cd})
		end


		local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self:GetParent().split_shot_target = true
				self:GetParent():PerformAttack(enemy, apply_modifiers, apply_modifiers, true, true, true, false, no_miss)
				self:GetParent().split_shot_target = false
				
				target_number = target_number + 1
				
				if target_number >= self.split_shot then
					break
				end
			end
		end

		if target_number>=1 then
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			if self:GetAbility().advanced_level >= 10 then
				duration = 12
			end
			duration = duration * attacker:GetModifierDurationGainIndex(1)
			
			attacker:AddNewModifier(
				attacker,
				self:GetAbility(),
				"modifier_Advanced_split_shot_buff", {duration=duration,stack=target_number,stack_time=duration}
			)
		end

		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
	end
end

function modifier_Advanced_split_shot:Advanced_GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	if self:GetParent().split_shot_target then
		return -(100-self:GetAbility():GetSpecialValueFor("bonus_damage"))
	else
		return 0
	end
end



------------------
modifier_Advanced_split_shot_buff = advanced_modifier({})

function modifier_Advanced_split_shot_buff:IsDebuff() return false end
function modifier_Advanced_split_shot_buff:IsHidden() return false end
function modifier_Advanced_split_shot_buff:IsPurgable() 		return false end
function modifier_Advanced_split_shot_buff:IsPurgeException() 	return false end
function modifier_Advanced_split_shot_buff:RemoveOnDeath()  return false end

function modifier_Advanced_split_shot_buff:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,       --攻击速度
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
	}
end

function modifier_Advanced_split_shot_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_Advanced_split_shot_buff:OnTooltip()
	return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
end

function modifier_Advanced_split_shot_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	if not self:GetAbility() then self:Destory() return end
	local max = self:GetAbility():GetSpecialValueFor("bonus_attack_max")
	return math.min(self:GetStackCount() ,max)
end

function modifier_Advanced_split_shot_buff:Advanced_GetModifierAttackArmor_Ignore()
	if not self:GetAbility() then self:Destory() return end
	if self:GetAbility():GetSpecialValueFor("advanced_level") and self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("bonus_attack_max") then
		return 18
	end
	return
end

function modifier_Advanced_split_shot_buff:OnCreated(keys)
	if not self:GetAbility() then self:Destory() return end
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
		
	end
end
function modifier_Advanced_split_shot_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_Advanced_split_shot_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end