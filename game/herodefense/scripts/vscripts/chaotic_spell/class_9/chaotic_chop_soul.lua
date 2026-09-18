chaotic_chop_soul = class({})
LinkLuaModifier("modifier_chaotic_chop_soul", "chaotic_spell/class_9/chaotic_chop_soul", LUA_MODIFIER_MOTION_NONE)

function chaotic_chop_soul:GetIntrinsicModifierName() return "modifier_chaotic_chop_soul" end

function chaotic_chop_soul:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_chop_soul/eff_damage.vpcf", context )
end

function chaotic_chop_soul:GetBehavior()
	if self:GetRuneType()==1 then
		return  DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
end





modifier_chaotic_chop_soul = advanced_modifier({})

function modifier_chaotic_chop_soul:IsDebuff()			return false end
function modifier_chaotic_chop_soul:IsHidden() 		return true end
function modifier_chaotic_chop_soul:IsPurgable() 		return false end
function modifier_chaotic_chop_soul:IsPurgeException() return false end
function modifier_chaotic_chop_soul:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE, 
    }
end

function modifier_chaotic_chop_soul:OnCreated() 
	self.parent = self:GetParent()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_damage_max = self:GetAbility():GetSpecialValueFor("bonus_damage_max")*0.01

	self.rune_1_health_cost = self:GetAbility():GetSpecialValueFor("rune_1_health_cost")*0.01
	self.rune_1_gain = self:GetAbility():GetSpecialValueFor("rune_1_gain")*0.01


	
end

function modifier_chaotic_chop_soul:OnRefresh() 
	self.parent = self:GetParent()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_damage_max = self:GetAbility():GetSpecialValueFor("bonus_damage_max")*0.01

	self.rune_1_health_cost = self:GetAbility():GetSpecialValueFor("rune_1_health_cost")*0.01
	self.rune_1_gain = self:GetAbility():GetSpecialValueFor("rune_1_gain")*0.01

end

function modifier_chaotic_chop_soul:Advanced_GetModifierProcAttack_BonusDamage_Physical(keys)
	if not IsServer() then
		return
	end
	if self.parent:PassivesDisabled() then
        return 0
    end
	local ability = self:GetAbility()
	local damage = keys.target:GetMaxHealth() * self.bonus_damage
	local damage_max = self.parent:GetBaseDamageMax() * self.bonus_damage_max
	local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_chop_soul/eff_damage.vpcf", PATTACH_ABSORIGIN, keys.target)
	ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
	DestroyParticleByDelay(pfx,1)
	damage = math.min(damage,damage_max)
	if ability:GetAutoCastState() and ability:GetRuneType()==1 then
		local health = self.rune_1_health_cost * self.parent:GetHealth()
		self.parent:ModifyHealth(self.parent:GetHealth()-health,ability,false,0)
		damage = damage + health* self.rune_1_gain
		-- print("damage=",damage)
	end
	return damage
end

function modifier_chaotic_chop_soul:Advanced_GetModifierAttackArmor_Ignore()	
	if self.parent:PassivesDisabled() then
        return 0
    end  
	return self.armor_reduction
end