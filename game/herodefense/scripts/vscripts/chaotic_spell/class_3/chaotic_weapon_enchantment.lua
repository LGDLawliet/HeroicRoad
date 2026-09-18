
chaotic_weapon_enchantment = class({})
LinkLuaModifier("modifier_chaotic_weapon_enchantment", "chaotic_spell/class_3/chaotic_weapon_enchantment", LUA_MODIFIER_MOTION_NONE)



function chaotic_weapon_enchantment:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_weapon_enchantment/effect/effect_lvl2.vpcf", context )

end




function chaotic_weapon_enchantment:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetRuneType() == 1 then
		duration = duration * (1-self:GetSpecialValueFor("rune_1_duration")*0.01)
	end

	EmitSoundOn("chaotic_weapon_enchantment_target", caster)    
	self:ApplyModifier(caster, duration)
end

function chaotic_weapon_enchantment:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_weapon_enchantment/effect/effect_lvl2.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	ParticleManager:SetParticleControl(particle_cast_fx, 2, target:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_weapon_enchantment", {duration = duration*gain})

end



modifier_chaotic_weapon_enchantment = advanced_modifier({})

function modifier_chaotic_weapon_enchantment:IsHidden() return false end
function modifier_chaotic_weapon_enchantment:IsPurgable() return true end
function modifier_chaotic_weapon_enchantment:IsDebuff() return false end

function modifier_chaotic_weapon_enchantment:OnCreated(keys)
	self.armor_reducetion = self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.rune_1_incoming = self:GetAbility():GetSpecialValueFor("rune_1_incoming")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*self:GetCaster():HDGetPrimaryStatValue()
		self:SetStackCount(bonus)
	end
end
function modifier_chaotic_weapon_enchantment:OnRefresh(keys)
	self.armor_reducetion = self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.rune_1_incoming = self:GetAbility():GetSpecialValueFor("rune_1_incoming")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*self:GetCaster():HDGetPrimaryStatValue()
		self:SetStackCount(bonus)
	end
end


function modifier_chaotic_weapon_enchantment:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_weapon_enchantment:OnTooltip() return self:Advanced_GetModifierProcAttack_BonusDamage_Physical() end
function modifier_chaotic_weapon_enchantment:Advanced_GetModifierProcAttack_BonusDamage_Physical()	
	return self:GetStackCount()
end

function modifier_chaotic_weapon_enchantment:Advanced_GetModifierAttackArmor_Ignore()	
	return self.armor_reducetion
end
function modifier_chaotic_weapon_enchantment:Advanced_GetModifierIncomingDamage_Percentage()	
	if not IsServer() then return end
	if self:GetParent():IsAttacking() then
		return -self.rune_1_incoming
	end
	return 0
end

function modifier_chaotic_weapon_enchantment:ADDeclareFunctions()
    local funcs =  
    {
        advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,  --攻击忽略护甲
    }
	if self:GetAbility():GetRuneType() == 1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end

