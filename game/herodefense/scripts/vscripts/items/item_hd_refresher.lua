LinkLuaModifier("modifier_item_hd_refresher", "items/item_hd_refresher", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_refresher_buff", "items/item_hd_refresher", LUA_MODIFIER_MOTION_NONE)
item_hd_refresher = class({})

function item_hd_refresher:GetIntrinsicModifierName()
    return "modifier_item_hd_refresher"
end
function item_hd_refresher:Precache( context )
	PrecacheResource( "particle", "particles/items2_fx/refresher.vpcf", context )
end
function item_hd_refresher:IsRefreshable() return false end
function item_hd_refresher:OnSpellStart()
	self:Refresh(self:GetCaster())
end
function item_hd_refresher:Refresh(unit)
	local caster = unit
    self.cd = self:GetSpecialValueFor("cd")*0.01
	for i=0, 11 do
		local Ability = caster:GetAbilityByIndex(i)
		if Ability ~= nil and Ability~=self then
            if Ability:IsRefreshable() then
			    Ability:EndCooldown()
            else
                local newcooldown = Ability:GetCooldownTimeRemaining() * (1-self.cd)
                Ability:EndCooldown()
                Ability:StartCooldown(newcooldown)
            end
		end
	end

	for i=0, 8 do
		local Ability = caster:GetItemInSlot(i)
		if Ability ~= nil and not Ability:IsCooldownReady()  then
			if Ability:IsRefreshable() then
			    Ability:EndCooldown()
            else
                local newcooldown = Ability:GetCooldownTimeRemaining() * (1-self.cd)
                Ability:EndCooldown()
                Ability:StartCooldown(newcooldown)
            end
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	caster:EmitSound("DOTA_Item.Refresher.Activate")

	return false
end
---------------------------------------------------------------------
modifier_item_hd_refresher = advanced_modifier({})

function modifier_item_hd_refresher:IsHidden()return true end
function modifier_item_hd_refresher:IsPurgable()return false end

function modifier_item_hd_refresher:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.health = self.ability:GetSpecialValueFor("health")
	self.mana  = self.ability:GetSpecialValueFor("mana")
end

-- function modifier_item_hd_refresher:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_EVASION_CONSTANT,
--     }
-- end

function modifier_item_hd_refresher:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS
    }
end

function modifier_item_hd_refresher:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end
function modifier_item_hd_refresher:AdvancedGetModifierHealthBonus(keys)
	return self.health
end
function modifier_item_hd_refresher:AdvancedGetModifierManaBonus(keys)
	return self.mana
end
--
-- modifier_item_hd_refresher_buff = advanced_modifier({})

-- function modifier_item_hd_refresher_buff:IsHidden()return false end
-- function modifier_item_hd_refresher_buff:IsPurgable()return false end

-- function modifier_item_hd_refresher_buff:OnCreated()
--     self.parent = self:GetParent()
--     self.ability = self:GetAbility()
--     self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
-- end

-- -- function modifier_item_hd_refresher:DeclareFunctions()
-- --     return{
-- --         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
-- --     }
-- -- end

-- function modifier_item_hd_refresher_buff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
--     }
-- end

-- function modifier_item_hd_refresher_buff:Advanced_GetModifier_TalentEffectGain()
-- 	if not self:GetAbility() then self:Destroy() return end
--     return self.bonus_profic
-- end


