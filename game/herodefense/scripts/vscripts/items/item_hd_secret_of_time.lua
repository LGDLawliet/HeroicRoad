item_hd_secret_of_time = class({})
-- LinkLuaModifier("modifier_item_hd_secret_of_time_arua", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_arua_effect", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_secret_of_time", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_secret_of_time_active", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_effect", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_effect2", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_active_standby", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_debuff", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_secret_of_time_thinker", "items/item_hd_secret_of_time", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_secret_of_time:GetIntrinsicModifierName()
	return "modifier_item_hd_secret_of_time"
end




function item_hd_secret_of_time:OnSpellStart()

	local caster    =   self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_hd_secret_of_time_active", {duration = 20})

end





modifier_item_hd_secret_of_time = advanced_modifier({})

function modifier_item_hd_secret_of_time:IsDebuff() return false end
function modifier_item_hd_secret_of_time:IsHidden() return true end
function modifier_item_hd_secret_of_time:IsPurgable() return false end

function modifier_item_hd_secret_of_time:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
	self.bonus_StatusGain = self.ability:GetSpecialValueFor("bonus_StatusGain")

end


function modifier_item_hd_secret_of_time:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain
    }
end
function modifier_item_hd_secret_of_time:Advanced_GetModifier_DurationGain(keys)
	return self.bonus_StatusGain
end


function modifier_item_hd_secret_of_time:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end



modifier_item_hd_secret_of_time_active = advanced_modifier({})

function modifier_item_hd_secret_of_time_active:IsDebuff() return false end
function modifier_item_hd_secret_of_time_active:IsHidden() return false end
function modifier_item_hd_secret_of_time_active:IsPurgable() return false end
function  modifier_item_hd_secret_of_time_active:GetTexture()return "item_secret_of_time" end
-- function  modifier_item_hd_secret_of_time_active:GetEffectName() return "particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf" end
-- function  modifier_item_hd_secret_of_time_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_secret_of_time_active:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

    if IsServer() then


		self:StartIntervalThink(0.3)
	end
end

function modifier_item_hd_secret_of_time_active:OnIntervalThink()
	if IsServer() then
		for i = 0, self:GetParent():GetAbilityCount() - 1 do
			local current_ability = self:GetParent():GetAbilityByIndex(i)
			if current_ability and not current_ability:IsCooldownReady() then
				local cd = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				current_ability:StartCooldown( cd + 0.3 )
			end
		end
	end
end


-- advanced_modifier
function modifier_item_hd_secret_of_time_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_item_hd_secret_of_time_active:Advanced_GetModifier_DurationGain(keys)
	return 100
end



function modifier_item_hd_secret_of_time_active:Advanced_GetModifier_NegativeDurationGain(keys)
	return 100
end
