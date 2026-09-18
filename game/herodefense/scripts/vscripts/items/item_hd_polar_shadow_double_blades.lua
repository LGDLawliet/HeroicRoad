item_hd_polar_shadow_double_blades = class({})
-- LinkLuaModifier("modifier_item_hd_polar_shadow_double_blades_arua", "items/item_hd_polar_shadow_double_blades", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_polar_shadow_double_blades_arua_effect", "items/item_hd_polar_shadow_double_blades", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_polar_shadow_double_blades", "items/item_hd_polar_shadow_double_blades", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_polar_shadow_double_blades_active", "items/item_hd_polar_shadow_double_blades", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_polar_shadow_double_blades:GetIntrinsicModifierName()
	return "modifier_item_hd_polar_shadow_double_blades"
end






modifier_item_hd_polar_shadow_double_blades = class({})

function modifier_item_hd_polar_shadow_double_blades:IsDebuff() return false end
function modifier_item_hd_polar_shadow_double_blades:IsHidden() return true end
function modifier_item_hd_polar_shadow_double_blades:IsPurgable() return false end



function modifier_item_hd_polar_shadow_double_blades:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end



function modifier_item_hd_polar_shadow_double_blades:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end



function modifier_item_hd_polar_shadow_double_blades:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_polar_shadow_double_blades:GetModifierPreAttack_BonusDamage() return self.bonus_damage end



function modifier_item_hd_polar_shadow_double_blades:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_item_hd_polar_shadow_double_blades_active") and  20>=RandomInt(1, 100)then
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_polar_shadow_double_blades_active", {duration = 5})
	end
	



end



if modifier_item_hd_polar_shadow_double_blades_active == nil then
	modifier_item_hd_polar_shadow_double_blades_active = class({})
end
function modifier_item_hd_polar_shadow_double_blades_active:IsHidden()return true end
function modifier_item_hd_polar_shadow_double_blades_active:IsDebuff()return false end
function modifier_item_hd_polar_shadow_double_blades_active:IsPurgable()return false end
function modifier_item_hd_polar_shadow_double_blades_active:IsPurgeException()return false end
function modifier_item_hd_polar_shadow_double_blades_active:AllowIllusionDuplicate()return false end
function modifier_item_hd_polar_shadow_double_blades_active:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end



function modifier_item_hd_polar_shadow_double_blades_active:GetModifierAttackSpeedBonus_Constant()	
	return 200
end

function modifier_item_hd_polar_shadow_double_blades_active:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent()  then
		return
	end
	if self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
		return
	end

	self:SafeDestroy()
end