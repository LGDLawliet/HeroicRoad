item_hd_moonrift_longbow = class({})
-- LinkLuaModifier("modifier_item_hd_moonrift_longbow_arua", "items/item_hd_moonrift_longbow", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_moonrift_longbow_arua_effect", "items/item_hd_moonrift_longbow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_moonrift_longbow", "items/item_hd_moonrift_longbow", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_moonrift_longbow:GetIntrinsicModifierName()
	return "modifier_item_hd_moonrift_longbow"
end




modifier_item_hd_moonrift_longbow = advanced_modifier({})

function modifier_item_hd_moonrift_longbow:IsDebuff() return false end
function modifier_item_hd_moonrift_longbow:IsHidden() return true end
function modifier_item_hd_moonrift_longbow:IsPurgable() return false end



function modifier_item_hd_moonrift_longbow:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")

end


function modifier_item_hd_moonrift_longbow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	}
end



function modifier_item_hd_moonrift_longbow:GetModifierBonusStats_Intellect()	return self.bonus_int end

function modifier_item_hd_moonrift_longbow:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end

function modifier_item_hd_moonrift_longbow:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end


function modifier_item_hd_moonrift_longbow:OnAttackLanded(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if keys.attacker == self:GetParent() and ability:IsCooldownReady() then
			
			ability:UseResources(true, true, true, true)
			ability:StartCooldown(1)
			local caster = self:GetCaster()
			local target =keys.target
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(pfx)
			Timers:CreateTimer(0.57, function()
				if ability:IsNull() then
					return
				end
				local damageTable = {
							victim = target,
							attacker = caster,
							damage = caster:GetIntellect(false)*3,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
				ApplyDamage(damageTable)
				target:EmitSound("Ability.StarfallImpact")

	

			end)

		end
	end
end


function modifier_item_hd_moonrift_longbow:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	
    }
end
