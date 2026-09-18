item_hd_faded_broach = class({})
-- LinkLuaModifier("modifier_item_hd_faded_broach_arua", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_faded_broach_arua_effect", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_faded_broach", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_faded_broach_active", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_faded_broach_active_standby", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_faded_broach_active_debuff", "items/item_hd_faded_broach", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_faded_broach:GetIntrinsicModifierName()
	return "modifier_item_hd_faded_broach"
end



-- function item_hd_faded_broach:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_faded_broach_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_faded_broach_arua = class({})

-- function modifier_item_hd_faded_broach_arua:IsHidden() return true end
-- function modifier_item_hd_faded_broach_arua:IsAura() return true end
-- function modifier_item_hd_faded_broach_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_faded_broach_arua:GetModifierAura() return "modifier_item_hd_faded_broach_arua_effect" end
-- function modifier_item_hd_faded_broach_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_faded_broach_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_faded_broach_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_faded_broach_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_faded_broach = class({})

function modifier_item_hd_faded_broach:IsDebuff() return false end
function modifier_item_hd_faded_broach:IsHidden() return true end
function modifier_item_hd_faded_broach:IsPurgable() return false end
-- function modifier_item_hd_faded_broach:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_faded_broach:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_faded_broach:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")

    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_faded_broach_active_standby", {duration = 20})
		self:StartIntervalThink(1)

	end
end
function modifier_item_hd_faded_broach:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():GetRandomEffect(10,INT_TYPE,0.5) >=RandomInt(1, 100) then
			for i=1, self:GetCaster():GetAbilityCount() - 1 do
				local Ability = self:GetCaster():GetAbilityByIndex(i)
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
					local newCooldown = Ability:GetCooldownTimeRemaining() - 2
					Ability:EndCooldown()
					Ability:StartCooldown(newCooldown)
					local nFXIndex = ParticleManager:CreateParticle( "particles/new_effect/new_effect/new_item_hd_faded_broach.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
					ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					break
				end
			end

		end
		-- self:SetHasCustomTransmitterData(true)
	end
end





function modifier_item_hd_faded_broach:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANA_BONUS,                     --魔法值
		

	}
end
function modifier_item_hd_faded_broach:GetModifierManaBonus()	return self.bonus_mana end






