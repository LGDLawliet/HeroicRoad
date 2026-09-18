creep_special_gain_pierce_the_veil = class({})

LinkLuaModifier("modifier_creep_special_gain_pierce_the_veil", "special_gain/creep_special_gain_pierce_the_veil", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_pierce_the_veil:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_pierce_the_veil"
end



modifier_creep_special_gain_pierce_the_veil = modifier_creep_special_gain_pierce_the_veil or advanced_modifier({})

function modifier_creep_special_gain_pierce_the_veil:IsHidden()	return false end
function modifier_creep_special_gain_pierce_the_veil:IsDebuff()	return false end
function modifier_creep_special_gain_pierce_the_veil:IsPurgable()	return false end




function modifier_creep_special_gain_pierce_the_veil:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL, -- allow attack ethereal units
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK, 

	}

	return funcs
end


function modifier_creep_special_gain_pierce_the_veil:GetOverrideAttackMagical( params )
	return 1
end

-- function modifier_creep_special_gain_pierce_the_veil:GetModifierTotalDamageOutgoing_Percentage( params )
-- 	if params.inflictor then return 0 end
-- 	if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
-- 	if params.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end


-- 	local damageTable = {
-- 		victim = params.target,
-- 		attacker = self:GetParent(),
-- 		damage = params.original_damage*0.1,
-- 		damage_type = DAMAGE_TYPE_MAGICAL,
-- 		damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
-- 		ability = self:GetAbility(), --Optional.
-- 	}
-- 	if params.target:IsMagicImmune() then
-- 		damageTable.damage= damageTable.damage*0.2
-- 	end
-- 	ApplyDamage( damageTable )
-- 	EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", params.target )

-- 	return -1000
-- end

function modifier_creep_special_gain_pierce_the_veil:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_creep_special_gain_pierce_the_veil:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- advanced_modifier
function modifier_creep_special_gain_pierce_the_veil:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_creep_special_gain_pierce_the_veil:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return
	end
	if keys.inflictor then return 0 end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end


	local damageTable = {
		victim = keys.target,
		attacker = self:GetParent(),
		damage = keys.original_damage*0.1,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self:GetAbility(), --Optional.
	}
	if keys.target:IsMagicImmune() then
		damageTable.damage= damageTable.damage*0.2
	end
	ApplyDamage( damageTable )
	EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", keys.target )

	return -1000
end





