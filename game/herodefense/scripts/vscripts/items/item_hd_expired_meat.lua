
LinkLuaModifier("modifier_item_hd_expired_meat_active", "items/item_hd_expired_meat", LUA_MODIFIER_MOTION_NONE)

item_hd_expired_meat = class({})

--------------------------------------------------------------------------------

-- function item_hd_expired_meat:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_expired_meat:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		caster:EmitSoundParams( "Miniboss_Greevil.Attack", 0, 0.5, 0 )
		-- local target = self:GetCursorTarget()

		local healing =  HealWithGain(1000,caster,caster,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
		caster:AddNewModifier(caster, self, "modifier_item_hd_expired_meat_active", {duration = 120})

		-- self:SpendCharge(0)
	end
end



modifier_item_hd_expired_meat_active = advanced_modifier({})

function modifier_item_hd_expired_meat_active:IsDebuff() return true end
function modifier_item_hd_expired_meat_active:IsHidden() return false end
function modifier_item_hd_expired_meat_active:IsPurgable() return false end
function modifier_item_hd_expired_meat_active:GetTexture()return "item_expired_meat" end
function modifier_item_hd_expired_meat_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



-- advanced_modifier
function modifier_item_hd_expired_meat_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_expired_meat_active:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -20
end



