item_hd_anger_coat = class({})

LinkLuaModifier("modifier_item_hd_anger_coat", "items/item_hd_anger_coat", LUA_MODIFIER_MOTION_NONE)

function item_hd_anger_coat:GetIntrinsicModifierName()
	return "modifier_item_hd_anger_coat"
end



modifier_item_hd_anger_coat = advanced_modifier({})

function modifier_item_hd_anger_coat:IsDebuff() return false end
function modifier_item_hd_anger_coat:IsHidden() return true end
function modifier_item_hd_anger_coat:IsPurgable() 		return false end
function modifier_item_hd_anger_coat:IsPurgeException() 	return false end
function modifier_item_hd_anger_coat:RemoveOnDeath()  return false end

function modifier_item_hd_anger_coat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.bonus_base_damage = self.ability:GetSpecialValueFor("bonus_base_damage")
	self.damage_index = self.ability:GetSpecialValueFor("damage_index")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_item_hd_anger_coat:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}
end

function modifier_item_hd_anger_coat:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true, true, true,true)
			local caster = self:GetCaster()
			local target =keys.target
			local pfx_name = "particles/units/heroes/hero_monkey_king/monkey_king_jump_stomp.vpcf"
			local sound_name = {
				"n_creep_Centaur.Stomp",
				"n_creep_Thunderlizard_Big.Stomp"
			}
			target:EmitSound(sound_name[RandomInt(1, 2)])
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local damage =  self:GetCaster():GetAverageTrueAttackDamage(nil) * self.damage_index
			local damagetype = DAMAGE_TYPE_PURE
			for _, enemy in pairs(enemies) do
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = damagetype,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
					}
				ApplyDamage(damageTable)	
			end

		end
	end
end

function modifier_item_hd_anger_coat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_anger_coat:Advanced_GetModifierBaseAttack_BonusDamage()
    return self.bonus_base_damage
end
function modifier_item_hd_anger_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end