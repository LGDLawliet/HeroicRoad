chaotic_finriers_teeth = class({})
LinkLuaModifier("modifier_chaotic_finriers_teeth", "chaotic_spell/class_6/chaotic_finriers_teeth", LUA_MODIFIER_MOTION_NONE)

function chaotic_finriers_teeth:GetIntrinsicModifierName() return "modifier_chaotic_finriers_teeth" end



function chaotic_finriers_teeth:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_finriers_teeth/effect_cast/kalia_swordcraft.vpcf", context )

end



modifier_chaotic_finriers_teeth = advanced_modifier({})

function modifier_chaotic_finriers_teeth:IsDebuff()			return false end
function modifier_chaotic_finriers_teeth:IsHidden() 		return true end
function modifier_chaotic_finriers_teeth:IsPurgable() 		return false end
function modifier_chaotic_finriers_teeth:IsPurgeException() return false end


function modifier_chaotic_finriers_teeth:OnCreated(keys) 
	if IsServer() then
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.life_steal = self:GetAbility():GetSpecialValueFor("life_steal")
	
	end
end

function modifier_chaotic_finriers_teeth:OnRefresh(keys) 
   	self:OnCreated(keys) 
end


function modifier_chaotic_finriers_teeth:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage, -- = "Advanced_GetModifier_LifeSteal_AttackDamage", --攻击伤害吸血

    }
end

function modifier_chaotic_finriers_teeth:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if AttackFilter(keys.record, ATTACK_STATE_CRIT) then
			local parent = self:GetParent()
			if parent:PassivesDisabled() then
				return
			end
			return self.bonus_damage
		end
	end
	return 0
end

function modifier_chaotic_finriers_teeth:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	if IsServer() then
		if AttackFilter(keys.record, ATTACK_STATE_CRIT) then
			local parent = self:GetParent()
			if parent:PassivesDisabled() then
				return
			end
			
			return self.life_steal
		end
	end
	return 0
end
