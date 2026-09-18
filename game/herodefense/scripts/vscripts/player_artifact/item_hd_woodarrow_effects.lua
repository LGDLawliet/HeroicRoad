-- 重写完成
item_hd_woodarrow_effects = class({})
LinkLuaModifier("modifier_item_hd_woodarrow_effects", "player_artifact/item_hd_woodarrow_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_woodarrow_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_woodarrow_effects"
end

modifier_item_hd_woodarrow_effects = advanced_modifier({})

function modifier_item_hd_woodarrow_effects:IsDebuff() return false end
function modifier_item_hd_woodarrow_effects:IsHidden() return true end
function modifier_item_hd_woodarrow_effects:IsPurgable() return false end
function modifier_item_hd_woodarrow_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.bonus_attack_1 = self.ability:GetArtifactSpecialValueFor("bonus_attack_1")
    self.bonus_attack_speed_3 = 0
    self.bonus_no_armor_4 = 0
    self.attack_speed_7  = self.ability:GetArtifactSpecialValueFor("attack_speed_7")
    self.max_10 = self.ability:GetArtifactSpecialValueFor("max_10")
    self.damage_10 = self.ability:GetArtifactSpecialValueFor("damage_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_woodarrow_effects")
    if self.level >= 10 then
        self.bonus_damage = self.bonus_damage + self.bonus_attack_1
    end
    if self.level >= 30 then
        self.bonus_attack_speed_3 = self.ability:GetArtifactSpecialValueFor("bonus_attack_speed_3")
    end
    if self.level >= 40 then
        self.bonus_no_armor_4 = self.ability:GetArtifactSpecialValueFor("bonus_no_armor_4")
    end
    if self.level >= 70 then
        self.bonus_attack_speed_3 = self.bonus_attack_speed_3 + self.attack_speed_7
    end
    if self.level >= 100 then
        self.max = self.max_10
    end
end

function modifier_item_hd_woodarrow_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.bonus_attack_1 = self.ability:GetArtifactSpecialValueFor("bonus_attack_1")
    self.bonus_attack_speed_3 = 0
    self.bonus_no_armor_4 = 0
    self.attack_speed_7  = self.ability:GetArtifactSpecialValueFor("attack_speed_7")
    self.max_10 = self.ability:GetArtifactSpecialValueFor("max_10")
    self.damage_10 = self.ability:GetArtifactSpecialValueFor("damage_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_woodarrow_effects")
    if self.level >= 10 then
        self.bonus_damage = self.bonus_damage + self.bonus_attack_1
    end
    if self.level >= 30 then
        self.bonus_attack_speed_3 = self.ability:GetArtifactSpecialValueFor("bonus_attack_speed_3")
    end
    if self.level >= 40 then
        self.bonus_no_armor_4 = self.ability:GetArtifactSpecialValueFor("bonus_no_armor_4")
    end
    if self.level >= 70 then
        self.bonus_attack_speed_3 = self.bonus_attack_speed_3 + self.attack_speed_7
    end
    if self.level >= 100 then
        self.max = self.max_10
    end
end

function modifier_item_hd_woodarrow_effects:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_hd_woodarrow_effects:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed_3
end

function modifier_item_hd_woodarrow_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_hd_woodarrow_effects:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_item_hd_woodarrow_effects:Advanced_GetModifierAttackArmor_Ignore()
    return self.bonus_no_armor_4
end

function modifier_item_hd_woodarrow_effects:OnAttack(keys)
	if not IsServer() then
		return 
	end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then
		return
	end
	if not attacker:IsRangedAttacker() then
		return
	end
	if attacker:IsInSpecialAttack() then return end
	
	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and self:GetAbility():IsTrained() then	

		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange()+100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
        local apply = false
        
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 1,
			iDisableCleave =1,
			iDisableSplit = 1,
		}
		if self.level >= 40 then
            apply = true
            modifier_keys.iDisableApplyModifier = 0
        end
		local attackEffectRecord =attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				attacker.split_shot_target = true
				attacker:PerformAttack(enemy, apply, apply, true, false, true, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
				attacker.split_shot_target = false
					
				target_number = target_number + 1
				
				if target_number >= self.max then
					break
				end
			end
		end
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end

		return
	end
end

function modifier_item_hd_woodarrow_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if not IsServer() then return end
	if self:GetParent().split_shot_target then
        if self.level >= 100 then
            return self.damage_10 - 100
        end
		return -50
	else
		return 0
	end
end