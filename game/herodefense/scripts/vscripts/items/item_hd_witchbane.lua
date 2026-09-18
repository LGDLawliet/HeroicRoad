item_hd_witchbane = class({})

LinkLuaModifier("modifier_item_hd_witchbane", "items/item_hd_witchbane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_witchbane_active", "items/item_hd_witchbane", LUA_MODIFIER_MOTION_NONE)

function item_hd_witchbane:GetIntrinsicModifierName()
	return "modifier_item_hd_witchbane"
end




function item_hd_witchbane:Precache( context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_purge.vpcf", context )

end



function item_hd_witchbane:OnSpellStart()

	-- local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	target:Purge(false, true, false, true, false)
	target:EmitSound("n_creep_SatyrTrickster.Cast")
	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_purge.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	DestroyParticleByDelay(particle,2)


end





modifier_item_hd_witchbane = modifier_item_hd_witchbane or class({})

function modifier_item_hd_witchbane:IsDebuff() return false end
function modifier_item_hd_witchbane:IsHidden() return true end
function modifier_item_hd_witchbane:IsPurgable() 		return false end
function modifier_item_hd_witchbane:IsPurgeException() 	return false end
function modifier_item_hd_witchbane:RemoveOnDeath()  return false end


function modifier_item_hd_witchbane:OnCreated(keys)
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_item_hd_witchbane:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end


function modifier_item_hd_witchbane:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_witchbane:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end





function modifier_item_hd_witchbane:GetModifierProcAttack_BonusDamage_Magical(params) 
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return self:GetParent():GetMana()*0.05
end



