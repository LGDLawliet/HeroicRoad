item_hd_viigil_signet = class({})

LinkLuaModifier("modifier_item_hd_viigil_signet", "items/item_hd_viigil_signet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_viigil_signet_active", "items/item_hd_viigil_signet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_viigil_signet_debuff", "items/item_hd_viigil_signet", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_viigil_signet:GetIntrinsicModifierName()
	return "modifier_item_hd_viigil_signet"
end
-- function item_hd_viigil_signet:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/witch_crown/effect.vpcf", context )
-- end


modifier_item_hd_viigil_signet = advanced_modifier({})

function modifier_item_hd_viigil_signet:IsDebuff() return false end
function modifier_item_hd_viigil_signet:IsHidden() return true end
function modifier_item_hd_viigil_signet:IsPurgable() return false end
function modifier_item_hd_viigil_signet:IsPurgeException() return false end
function modifier_item_hd_viigil_signet:RemoveOnDeath() return false end

function modifier_item_hd_viigil_signet:OnCreated(keys)
	self.bonus_str =  self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_armor =  self:GetAbility():GetSpecialValueFor("bonus_armor")
end


function modifier_item_hd_viigil_signet:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,       
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_item_hd_viigil_signet:GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_viigil_signet:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()


		if keys.target == parent then
			keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_viigil_signet_debuff", {})
		end
	end
end

function modifier_item_hd_viigil_signet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_viigil_signet:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

modifier_item_hd_viigil_signet_debuff = advanced_modifier({})

function modifier_item_hd_viigil_signet_debuff:IsDebuff() return true end
function modifier_item_hd_viigil_signet_debuff:IsHidden() return false end
function modifier_item_hd_viigil_signet_debuff:IsPurgable() return false end
function modifier_item_hd_viigil_signet_debuff:IsPurgeException() return false end
function modifier_item_hd_viigil_signet_debuff:RemoveOnDeath() return false end

function modifier_item_hd_viigil_signet_debuff:OnCreated(keys)

	if IsServer() then
		-- particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf
		self:SetStackCount(1)
	end
end

function modifier_item_hd_viigil_signet_debuff:OnRefresh(keys)

	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_viigil_signet_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,         
	}
end
function modifier_item_hd_viigil_signet_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local bonus = math.min(5*self:GetStackCount(),35)
	if IsClient() then
		return bonus
	end
	if keys.damage>=10 then
		if bonus<=0 then
			self:SafeDestroy()
			return 0
		end
		self:DecrementStackCount()
		return bonus
	end
	return 0
end



function modifier_item_hd_viigil_signet_debuff:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end


function modifier_item_hd_viigil_signet_debuff:OnTooltip()
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end



