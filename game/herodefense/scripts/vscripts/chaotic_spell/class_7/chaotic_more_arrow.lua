LinkLuaModifier("modifier_chaotic_more_arrow", "chaotic_spell/class_7/chaotic_more_arrow", LUA_MODIFIER_MOTION_NONE)
chaotic_more_arrow = class({})

function chaotic_more_arrow:OnUpgrade()
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end

function chaotic_more_arrow:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_more_arrow:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_more_arrow:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_more_arrow", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_chaotic_more_arrow", self:GetCaster())
	end
end
-----------------------------------------------------------------------------------------------------------------------------

modifier_chaotic_more_arrow	= advanced_modifier({})

function modifier_chaotic_more_arrow:IsHidden()	return true end
function modifier_chaotic_more_arrow:IsPurgable()	return false end
function modifier_chaotic_more_arrow:OnCreated(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
        self.chance = self:GetAbility():GetSpecialValueFor("chance")
        if self:GetAbility():GetRuneType()==1 then
			self.rune_1 = true
        end

        if self:GetParent():HasAbility("Primary_split_shot") or self:GetParent():HasAbility("Middle_split_shot") or self:GetParent():HasAbility("Advanced_split_shot") then
            self:SetStackCount(0)
        else
            self:SetStackCount(self:GetAbility():GetSpecialValueFor("rune_2_evasion"))
        end
	end
end

function modifier_chaotic_more_arrow:OnRefresh(keys)
	if IsServer() then
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
        self.chance = self:GetAbility():GetSpecialValueFor("chance")
        if self:GetAbility():GetRuneType()==1 then
			self.rune_1 = true
        end
        
        if self:GetParent():HasAbility("Primary_split_shot") or self:GetParent():HasAbility("Middle_split_shot") or self:GetParent():HasAbility("Advanced_split_shot") then
            self:SetStackCount(0)
        else
            self:SetStackCount(self:GetAbility():GetSpecialValueFor("rune_2_evasion"))
        end
	end
end

function modifier_chaotic_more_arrow:DeclareFunctions()
    local funcs =  {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ORDER,
    }
    if self:GetAbility():GetRuneType()==2 then
        table.insert(funcs,MODIFIER_PROPERTY_EVASION_CONSTANT)
    end
    return funcs
end

function modifier_chaotic_more_arrow:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_chaotic_more_arrow:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if not self:GetParent():IsRangedAttacker() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
    if keys.attacker:HasAbility("Primary_split_shot") or keys.attacker:HasAbility("Middle_split_shot") or keys.attacker:HasAbility("Advanced_split_shot") then
        return
    end
	if keys.attacker:IsInSpecialAttack() then return end
	
	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		self.split_shot = self:GetAbility():GetSpecialValueFor("arrow_count")
        local random = math.random

		if self.rune_1 then
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			local target_number = 0
	
	
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
			}
		
			local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			for _, enemy in pairs(enemies) do
				if enemy ~= keys.target then
					self:GetParent().split_shot_target = true
					self:GetParent():PerformAttack(enemy, true, true, true, true, true, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
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

			return
		else
        	if self.chance >= random(1,100) then
				local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
				local target_number = 0
		
		
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
				}
			
				local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				for _, enemy in pairs(enemies) do
					if enemy ~= keys.target then
						self:GetParent().split_shot_target = true
						self:GetParent():PerformAttack(enemy, true, true, true, true, true, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
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
	end
end

function modifier_chaotic_more_arrow:Advanced_GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	if self:GetParent().split_shot_target then
        self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
        if self:GetAbility():GetRuneType()==3 then
            self.bonus_damage = self.bonus_damage* (1+self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage")*0.01)
        end
		return -(100-self.bonus_damage)
	else
		return 0
	end
end

function modifier_chaotic_more_arrow:GetModifierEvasion_Constant()
    return self:GetStackCount()
end