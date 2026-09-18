item_hd_eagle_ring = class({})

LinkLuaModifier("modifier_item_hd_eagle_ring", "items/item_hd_eagle_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_eagle_ring_active", "items/item_hd_eagle_ring", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_eagle_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_eagle_ring"
end
function item_hd_eagle_ring:OnSpellStart()
	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_hd_eagle_ring_active") then
		return
	end
	caster:EmitSound("ui.npe_objective_given")
	caster:AddNewModifier(caster, self, "modifier_item_hd_eagle_ring_active", {})
	self:SpendCharge(0)
end


modifier_item_hd_eagle_ring = advanced_modifier({})

function modifier_item_hd_eagle_ring:IsDebuff() return false end
function modifier_item_hd_eagle_ring:IsHidden() return true end
function modifier_item_hd_eagle_ring:IsPurgable() return false end
function modifier_item_hd_eagle_ring:IsPurgeException() return false end
function modifier_item_hd_eagle_ring:RemoveOnDeath() return false end

function modifier_item_hd_eagle_ring:OnCreated(keys)
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")

end

function modifier_item_hd_eagle_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,                    

	}
end
function modifier_item_hd_eagle_ring:GetModifierBonusStats_Agility()return self.bonus_agi end


-- advanced_modifier
function modifier_item_hd_eagle_ring:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
    }
end
function modifier_item_hd_eagle_ring:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return 30
end




modifier_item_hd_eagle_ring_active = advanced_modifier({})

function modifier_item_hd_eagle_ring_active:IsDebuff() return false end
function modifier_item_hd_eagle_ring_active:IsHidden() return false end
function modifier_item_hd_eagle_ring_active:IsPurgable() return false end
function modifier_item_hd_eagle_ring_active:IsPurgeException() return false end
function modifier_item_hd_eagle_ring_active:RemoveOnDeath() return false end
function modifier_item_hd_eagle_ring_active:GetTexture() return "item_eagle_ring" end

function modifier_item_hd_eagle_ring_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
    }
end
function modifier_item_hd_eagle_ring_active:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return 10
end