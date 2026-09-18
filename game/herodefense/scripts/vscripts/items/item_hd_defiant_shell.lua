
LinkLuaModifier("modifier_item_hd_defiant_shell_buff", "items/item_hd_defiant_shell.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_defiant_shell_thinker", "items/item_hd_defiant_shell.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_defiant_shell_aura_debuff", "items/item_hd_defiant_shell.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_defiant_shell_aura_attack_debuff", "items/item_hd_defiant_shell.lua", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
item_hd_defiant_shell= item_hd_defiant_shell or class({})
function item_hd_defiant_shell:GetIntrinsicModifierName() 
    return "modifier_item_hd_defiant_shell_buff" 
end
function item_hd_defiant_shell:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
end


function item_hd_defiant_shell:OnProjectileHit(target, location)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end


end




modifier_item_hd_defiant_shell_buff=advanced_modifier({})

-- function modifier_item_hd_defiant_shell_buff:IsPassive()			return true end
function modifier_item_hd_defiant_shell_buff:IsDebuff() return false end
function modifier_item_hd_defiant_shell_buff:IsHidden() 		return true end
function modifier_item_hd_defiant_shell_buff:IsPurgable() 		return false end
function modifier_item_hd_defiant_shell_buff:IsPurgeException() return false end
function modifier_item_hd_defiant_shell_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_defiant_shell_buff:DestroyOnExpire() return false end
function modifier_item_hd_defiant_shell_buff:OnCreated()

    local ability = self:GetAbility()
	self.bonusa_armor = ability:GetSpecialValueFor("bonusa_armor")
    self.bonus_all_attribute = ability:GetSpecialValueFor("bonus_all_attribute")


end
function modifier_item_hd_defiant_shell_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end


function modifier_item_hd_defiant_shell_buff:GetModifierBonusStats_Strength()	return self.bonus_all_attribute end
function modifier_item_hd_defiant_shell_buff:GetModifierBonusStats_Agility()	return self.bonus_all_attribute end
function modifier_item_hd_defiant_shell_buff:GetModifierBonusStats_Intellect()	return self.bonus_all_attribute end

function modifier_item_hd_defiant_shell_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if keys.target==parent then
		local ability = self:GetAbility()
	if not ability:IsCooldownReady() or not self:GetParent():IsAlive() then
		return
	end

		if ability:IsCooldownReady() then

			if parent:IsRangedAttacker() then
				local info = 
				{
					Target = keys.attacker,
					Source = parent,
					Ability = ability,	
					EffectName = parent:GetRangedProjectileName(),
					iMoveSpeed = parent:GetProjectileSpeed(),
					bDrawsOnMinimap = false,  --？？
					bDodgeable = true,   --可躲闪
					bIsAttack = false,   --攻击效果
					bVisibleToEnemies = true,  --对敌人可视
					bReplaceExisting = false, --替换现有的
					flExpireTime = GameRules:GetGameTime() + 10, --存在时间
					bProvidesVision = false, --提供视野
					ExtraData = {}   --额外的数据
				}
				ProjectileManager:CreateTrackingProjectile(info)
			else
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
				local attackEffectRecord = parent:AddAttackEffectModifier(ability,modifier_keys)
				parent:PerformAttack(keys.attacker, false, true, true, false, false, false, true)
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			end
			ability:UseResources(true, true, true, true)
			
		end
	end
	
end


function modifier_item_hd_defiant_shell_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_defiant_shell_buff:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end