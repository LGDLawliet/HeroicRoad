item_hd_penta_edged_sword = class({})
-- LinkLuaModifier("modifier_item_hd_penta_edged_sword_arua", "items/item_hd_penta_edged_sword", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_penta_edged_sword_arua_effect", "items/item_hd_penta_edged_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_penta_edged_sword", "items/item_hd_penta_edged_sword", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_penta_edged_sword:GetIntrinsicModifierName()
	return "modifier_item_hd_penta_edged_sword"
end





modifier_item_hd_penta_edged_sword = advanced_modifier({})

function modifier_item_hd_penta_edged_sword:IsDebuff() return false end
function modifier_item_hd_penta_edged_sword:IsHidden() return true end
function modifier_item_hd_penta_edged_sword:IsPurgable() return false end


function modifier_item_hd_penta_edged_sword:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	
end


function modifier_item_hd_penta_edged_sword:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临

	}
end


function modifier_item_hd_penta_edged_sword:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_penta_edged_sword:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and 0 or self.bonus_attack_range end

function modifier_item_hd_penta_edged_sword:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			if self:GetCaster():IsRangedAttacker() then
				return
			end
			self:GetAbility():UseResources(true, true, true,true)
			self:GetAbility():StartCooldown(3)

			local target =keys.target
			local pos = target:GetAbsOrigin()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			local pos_1 = pos + vDir * 800
			local caster = self:GetCaster()
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos, nil, 150,
    		DOTA_UNIT_TARGET_TEAM_ENEMY,
    		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
    		for i, hTarget in pairs(tTargets) do
        	--造成攻击
        		caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
				if i>=6 then
					break
				end
    		end
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
			-- local pos_2 = pos + vDir * -500
			local iPtclID = ParticleManager:CreateParticle('particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, pos_1)
			ParticleManager:SetParticleControl(iPtclID, 1, pos)
			ParticleManager:ReleaseParticleIndex(iPtclID)

		end
	end
end



function modifier_item_hd_penta_edged_sword:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end