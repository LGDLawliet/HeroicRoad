item_hd_poison_coat = class({})

LinkLuaModifier("modifier_item_hd_poison_coat", "items/item_hd_poison_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_poison_coat_debuff", "items/item_hd_poison_coat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_poison_coat_thinker", "items/item_hd_poison_coat", LUA_MODIFIER_MOTION_NONE)

function item_hd_poison_coat:GetIntrinsicModifierName()
	return "modifier_item_hd_poison_coat"
end

function item_hd_poison_coat:OnSpellStart()

	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	local poison = caster:GetMaxHealth()*self:GetSpecialValueFor("hp_poison")*0.01

	caster:Poison(caster,self,poison)
	CreateModifierThinker(caster, self, "modifier_item_hd_poison_coat_thinker", 
	{duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
end
-------------------------------------------------------------------------
modifier_item_hd_poison_coat = advanced_modifier({})

function modifier_item_hd_poison_coat:IsDebuff() return false end
function modifier_item_hd_poison_coat:IsHidden() return true end
function modifier_item_hd_poison_coat:IsPurgable() return false end

function modifier_item_hd_poison_coat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_poison_res = self.ability:GetSpecialValueFor("bonus_poison_res")

end

function modifier_item_hd_poison_coat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_poison_coat:AdvancedGetModifierHealthBonus()
    return self.bonus_health
end
function modifier_item_hd_poison_coat:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_poison_coat:Advanced_GetModifierIncomingPoisonDamagePercentage()
    return -self.bonus_poison_res
end
-----------------------------------------------------------------------
modifier_item_hd_poison_coat_thinker = advanced_modifier({})

function modifier_item_hd_poison_coat_thinker:RemoveOnDeath() return true end

function modifier_item_hd_poison_coat_thinker:OnCreated(keys)
    if IsServer() then
		local ability = self:GetAbility()
		self.poison = self:GetAbility():GetSpecialValueFor("poison_damage")*0.01 * self:GetCaster():GetMaxHealth()
        self.radius = self:GetAbility():GetSpecialValueFor("radius")
        self:StartIntervalThink(0.5)
        self.caster = ability:GetCaster()
        self.ability = ability
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_nethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
        ParticleManager:SetParticleControl(pfx, 3, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 15, false, false)
        self.team = self.caster:GetTeamNumber()
		self:GetParent():EmitSound("Hero_Viper.NetherToxin.TI8")
	end
end

function modifier_item_hd_poison_coat_thinker:OnDestroy(keys)
    if IsServer() then
		self:GetParent():StopSound("Hero_Viper.NetherToxin.TI8")
		UTIL_Remove(self:GetParent())
	end
end

function modifier_item_hd_poison_coat_thinker:OnIntervalThink()
	local caster = self.caster
    local ability = self.ability

	local enemy = FindUnitsInRadius(self.team, self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	
    for i=1, #enemy do
		enemy[i]:Poison(caster,ability,self.poison)
        --enemy[i]:AddNewModifier(caster, ability, "modifier_item_hd_poison_coat_debuff", {duration = 1})
	end
end

--------------------------------------
modifier_item_hd_poison_coat_debuff= class({})

function modifier_item_hd_poison_coat_debuff:IsDebuff()			   return true end
function modifier_item_hd_poison_coat_debuff:IsHidden() 			return false end
function modifier_item_hd_poison_coat_debuff:IsPurgable() 	        return true end
function modifier_item_hd_poison_coat_debuff:IsPurgeException() 	return true end
function modifier_item_hd_poison_coat_debuff:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end--破坏被动
function modifier_item_hd_poison_coat_debuff:GetTexture()
    return "item_poison_coat"
end