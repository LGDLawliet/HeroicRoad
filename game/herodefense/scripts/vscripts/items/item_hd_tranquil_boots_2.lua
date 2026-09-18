item_hd_tranquil_boots_2 = class({})
-- LinkLuaModifier("modifier_item_hd_tranquil_boots_2_arua", "items/item_hd_tranquil_boots_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_tranquil_boots_2_arua_effect", "items/item_hd_tranquil_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tranquil_boots_2", "items/item_hd_tranquil_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tranquil_boots_2_active", "items/item_hd_tranquil_boots_2", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_tranquil_boots_2:GetIntrinsicModifierName()
	return "modifier_item_hd_tranquil_boots_2"
end






-- modifier_item_hd_tranquil_boots_2_arua = class({})

-- function modifier_item_hd_tranquil_boots_2_arua:IsHidden() return true end
-- function modifier_item_hd_tranquil_boots_2_arua:IsAura() return true end
-- function modifier_item_hd_tranquil_boots_2_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_tranquil_boots_2_arua:GetModifierAura() return "modifier_item_hd_tranquil_boots_2_arua_effect" end
-- function modifier_item_hd_tranquil_boots_2_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_tranquil_boots_2_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_tranquil_boots_2_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_tranquil_boots_2_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_tranquil_boots_2 = advanced_modifier({})

function modifier_item_hd_tranquil_boots_2:IsDebuff() return false end
function modifier_item_hd_tranquil_boots_2:IsHidden() return true end
function modifier_item_hd_tranquil_boots_2:IsPurgable() return false end



function modifier_item_hd_tranquil_boots_2:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	-- self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_Mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_tranquil_boots_2_active", {})
		self:StartIntervalThink(0.3)


	end
end
function modifier_item_hd_tranquil_boots_2:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			self:SetStackCount(15)
		else
			self:SetStackCount(0)
		end
	end
end
function modifier_item_hd_tranquil_boots_2:OnDestroy()
	if IsServer() then

		self.modifier:SafeDestroy()
	end
end


function modifier_item_hd_tranquil_boots_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end



function modifier_item_hd_tranquil_boots_2:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_item_hd_tranquil_boots_2:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end


function modifier_item_hd_tranquil_boots_2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

function modifier_item_hd_tranquil_boots_2:Advanced_GetModifierSpellAmplifyBonus()   return self:GetStackCount() end



function modifier_item_hd_tranquil_boots_2:OnTakeDamage(keys)
    if IsServer() then   
		if keys.unit == self:GetParent() and keys.damage >50 then
			-- print("damage")
			self:GetAbility():UseResources(true, true, true,true)
		end

    end 
end

function modifier_item_hd_tranquil_boots_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}

    }
end

modifier_item_hd_tranquil_boots_2_active = advanced_modifier({})

function modifier_item_hd_tranquil_boots_2_active:IsDebuff() return false end
function modifier_item_hd_tranquil_boots_2_active:IsHidden() return false end
function modifier_item_hd_tranquil_boots_2_active:IsPurgable() return false end


function modifier_item_hd_tranquil_boots_2_active:OnCreated(table)
	if IsServer() then
		self.pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(1)
	end
end


function modifier_item_hd_tranquil_boots_2_active:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:GetAbsOrigin()==self.pos then
			if self:GetStackCount()<30 then
				self:IncrementStackCount()	
			end
		else
			self:SetStackCount(0)
			self.pos= parent:GetAbsOrigin()
		end
	end
end

function modifier_item_hd_tranquil_boots_2_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_tranquil_boots_2_active:Advanced_GetModifierSpellAmplifyBonus()   return self:GetStackCount() end