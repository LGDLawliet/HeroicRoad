item_hd_holy_cross_battlefield = class({})
-- LinkLuaModifier("modifier_item_hd_holy_cross_battlefield_arua", "items/item_hd_holy_cross_battlefield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_holy_cross_battlefield_arua_effect", "items/item_hd_holy_cross_battlefield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_cross_battlefield", "items/item_hd_holy_cross_battlefield", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_holy_cross_battlefield:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_cross_battlefield"
end






modifier_item_hd_holy_cross_battlefield = advanced_modifier({})

function modifier_item_hd_holy_cross_battlefield:IsDebuff() return false end
function modifier_item_hd_holy_cross_battlefield:IsHidden() return true end
function modifier_item_hd_holy_cross_battlefield:IsPurgable() return false end


function modifier_item_hd_holy_cross_battlefield:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()
	
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	


end


function modifier_item_hd_holy_cross_battlefield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end


function modifier_item_hd_holy_cross_battlefield:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_holy_cross_battlefield:GetModifierBonusStats_Intellect()	return self.bonus_int end

function modifier_item_hd_holy_cross_battlefield:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			local ability = self:GetAbility()
			ability:UseResources(true, true, true, true)
			ability:StartCooldown(1)
			local caster = self:GetCaster()
			local target =keys.target
			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		   if target then
				self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(self.particle, 0, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.particle)
				target:EmitSound("Hero_Omniknight.HammerOfPurity.Crit")
				local damageTable = {
					victim = target,
					attacker = caster,
					damage = caster:GetStrength()*2,
					damage_type = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = ability, --Optional.
					}
				ApplyDamage(damageTable)
				
		   end
		   local heal = caster:GetStrength()*2
		   local number = 0
			for _, unit in pairs(units) do
				if  unit:GetHealthPercent() ~= 100 then
					number = number + 1
					HealWithGain(heal,caster,unit,ability)
					if number>=5 then
						break
					end
				   end
				end

		end
	end
end


-- advanced_modifier
function modifier_item_hd_holy_cross_battlefield:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_holy_cross_battlefield:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end


