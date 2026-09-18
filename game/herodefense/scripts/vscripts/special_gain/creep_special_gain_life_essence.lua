creep_special_gain_life_essence = class({})

LinkLuaModifier("modifier_creep_special_gain_life_essence", "special_gain/creep_special_gain_life_essence", LUA_MODIFIER_MOTION_NONE)


function creep_special_gain_life_essence:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_life_essence"
end
--------------------------
modifier_creep_special_gain_life_essence = advanced_modifier({})

function modifier_creep_special_gain_life_essence:IsDebuff() return false end
function modifier_creep_special_gain_life_essence:IsHidden() return false end
function modifier_creep_special_gain_life_essence:IsPurgable() return false end
function modifier_creep_special_gain_life_essence:GetEffectName() return "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_ambient.vpcf" end
function modifier_creep_special_gain_life_essence:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creep_special_gain_life_essence:OnCreated(keys)
    self.ability = self:GetAbility()
	self.parent =self:GetParent()
	self.life_essence_used = false
	self.hp_max_index = self.ability:GetSpecialValueFor("hp_max_index")*0.01
end
function modifier_creep_special_gain_life_essence:ADDeclareFunctions(keys)
    return{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_creep_special_gain_life_essence:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	if self.life_essence_used == true then
		return
	end
	
	self:SetStackCount(math.min(self.hp_max_index * keys.attacker:GetMaxHealth(),self:GetParent():GetMaxHealth()))
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_nullfield_defensive_tsest.vpcf", PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	self.parent:EmitSound("Hero_Warlock.ShadowWordCastGood")
	self.life_essence_used = true
end

function modifier_creep_special_gain_life_essence:AdvancedGetModifierHealthBonus()
	return self:GetStackCount()
end



