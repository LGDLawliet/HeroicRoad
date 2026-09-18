LinkLuaModifier("modifier_Middle_split_shot", "skills/Middle_split_shot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_split_shot_apply", "skills/Middle_split_shot", LUA_MODIFIER_MOTION_NONE)
Middle_split_shot = class({})

function Middle_split_shot:OnUpgrade()
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end


function Middle_split_shot:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Middle_split_shot:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Middle_split_shot:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_split_shot", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_split_shot", self:GetCaster())
	end
end

modifier_Middle_split_shot_apply	= advanced_modifier({})

function modifier_Middle_split_shot_apply:IsHidden()	return true end
function modifier_Middle_split_shot_apply:IsPurgable()	return false end

modifier_Middle_split_shot	= advanced_modifier({})

function modifier_Middle_split_shot:IsHidden()	return false end
function modifier_Middle_split_shot:IsPurgable()	return false end
function modifier_Middle_split_shot:OnCreated(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
		local talent3 = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_medusa_3")
		if talent3 then
			self.split_shot = self.split_shot + talent3:GetSpecialValueFor("bonus_split")
		end
	end
end

function modifier_Middle_split_shot:OnRefresh(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
		local talent3 = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_medusa_3")
		if talent3 then
			self.split_shot = self.split_shot + talent3:GetSpecialValueFor("bonus_split")
		end
	end
end

function modifier_Middle_split_shot:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ORDER
    }
end

function modifier_Middle_split_shot:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end

function modifier_Middle_split_shot:Advanced_GetModifierAttackSpeedPercentage()
	return -self:GetAbility():GetSpecialValueFor("attack_speed_down")
end

function modifier_Middle_split_shot:OnAttack(keys)
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
	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
		local apply_modifiers = false
		local apply_cd = self:GetAbility():GetSpecialValueFor("interval")

		

		-- Mark 禁用添加修饰器
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 1,
			iDisableCleave =1,
			iDisableSplit = 1,
		}
	
		if not keys.attacker:HasModifier("modifier_Middle_split_shot_apply") then
			apply_modifiers = true
			modifier_keys.iDisableApplyModifier = 0
			keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_Middle_split_shot_apply",{duration = apply_cd})
		end


		local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self:GetParent().split_shot_target = true
				self:GetParent():PerformAttack(enemy, apply_modifiers, apply_modifiers, true, true, true, false, false)
				self:GetParent().split_shot_target = false
				
				target_number = target_number + 1
				
				if target_number >= self.split_shot then
					break
				end
			end
		end
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
	end
end

function modifier_Middle_split_shot:Advanced_GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	if self:GetParent().split_shot_target then
		return -(100-self:GetAbility():GetSpecialValueFor("bonus_damage"))
	else
		return 0
	end
end
