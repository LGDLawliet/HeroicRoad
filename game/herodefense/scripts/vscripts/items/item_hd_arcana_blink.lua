item_hd_arcana_blink =item_hd_arcana_blink or  class({})
-- LinkLuaModifier("modifier_item_hd_arcana_blink_arua", "items/item_hd_arcana_blink", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_arcana_blink_arua_effect", "items/item_hd_arcana_blink", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_arcana_blink", "items/item_hd_arcana_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcana_blink_active", "items/item_hd_arcana_blink", LUA_MODIFIER_MOTION_NONE)


-- function item_hd_arcana_blink:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", context )

-- end
-- function item_hd_arcana_blink:GetIntrinsicModifierName()
-- 	return "modifier_item_hd_arcana_blink"
-- end
function item_hd_arcana_blink:OnSpellStart()
	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_hd_arcana_blink_active") then
		return
	end
	caster:EmitSound("ui.npe_objective_given")
	caster:AddNewModifier(caster, self, "modifier_item_hd_arcana_blink_active", {})
	self:SpendCharge(0)
end


modifier_item_hd_arcana_blink_active = modifier_item_hd_arcana_blink_active or class({})

function modifier_item_hd_arcana_blink_active:IsDebuff() return false end
function modifier_item_hd_arcana_blink_active:IsHidden() return false end
function modifier_item_hd_arcana_blink_active:IsPurgable() return false end
function modifier_item_hd_arcana_blink_active:IsPurgeException() return false end
function modifier_item_hd_arcana_blink_active:RemoveOnDeath() return false end
function modifier_item_hd_arcana_blink_active:DestroyOnExpire() return false end
function modifier_item_hd_arcana_blink_active:GetTexture()  return "item_es_arcana_blink" end