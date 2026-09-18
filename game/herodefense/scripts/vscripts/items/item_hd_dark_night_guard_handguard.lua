item_hd_dark_night_guard_handguard = class({})
-- LinkLuaModifier("modifier_item_hd_dark_night_guard_handguard_arua", "items/item_hd_dark_night_guard_handguard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_dark_night_guard_handguard_arua_effect", "items/item_hd_dark_night_guard_handguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dark_night_guard_handguard", "items/item_hd_dark_night_guard_handguard", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_dark_night_guard_handguard:GetIntrinsicModifierName()
	return "modifier_item_hd_dark_night_guard_handguard"
end



function item_hd_dark_night_guard_handguard:OnProjectileHit(target, location)
    if not IsServer() then
        return
    end
	if target then
        target:EmitSound("Hero_Luna.MoonGlaive.Impact")
        local damageTable = {
            victim = target,
            attacker = self:GetCaster(),
            damage = self:GetCaster():GetBaseDamageMax()*0.5,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
            ability = self, --Optional.
            }
        local damage2 = ApplyDamage(damageTable)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE , target, damage2, nil)
	end
end

function item_hd_dark_night_guard_handguard:GlaiveAttck(target,target2)
	local info = 
	{
		Target = target,
		Source = target2,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_luna/luna_moon_glaive.vpcf",
		iMoveSpeed = (self:GetCaster():IsRangedAttacker() and self:GetCaster():GetProjectileSpeed() or 900),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

modifier_item_hd_dark_night_guard_handguard = class({})

function modifier_item_hd_dark_night_guard_handguard:IsDebuff() return false end
function modifier_item_hd_dark_night_guard_handguard:IsHidden() return true end
function modifier_item_hd_dark_night_guard_handguard:IsPurgable() return false end


function modifier_item_hd_dark_night_guard_handguard:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

end



function modifier_item_hd_dark_night_guard_handguard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end


function modifier_item_hd_dark_night_guard_handguard:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_dark_night_guard_handguard:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_dark_night_guard_handguard:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_dark_night_guard_handguard:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and  keys.attacker:IsRangedAttacker() and self:GetAbility():IsCooldownReady() and self:GetCaster():GetRandomEffect(30,INT_TYPE,1) >=RandomInt(1, 100) then
			if self:GetParent():IsDisableSplit() then  --分裂箭无效化
				return    
			end
			self:GetAbility():UseResources(true, true, true,true)
			local caster = self:GetCaster()
			local target =keys.target
			-- print(caster:Script_GetAttackRange())
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, caster:Script_GetAttackRange(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		   for _, enemy in pairs(enemies) do
			   if enemy ~= target then
				   target = enemy
				   break
			   end
		   end
		   if target == keys.target then
				return
			end
			self:GetAbility():GlaiveAttck(target,keys.target)
		
		end
	end
end
