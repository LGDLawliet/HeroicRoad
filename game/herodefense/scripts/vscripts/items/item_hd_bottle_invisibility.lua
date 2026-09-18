LinkLuaModifier("modifier_item_hd_bottle_invisibility", "items/item_hd_bottle_invisibility", LUA_MODIFIER_MOTION_NONE)
item_hd_bottle_invisibility = class({})

--------------------------------------------------------------------------------

-- function item_hd_bottle_invisibility:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_bottle_invisibility:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_item_hd_bottle_invisibility") then
		return
	end
	caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
	caster:AddNewModifier(caster, self, "modifier_item_hd_bottle_invisibility", {})
	self:SpendCharge(0)
end




modifier_item_hd_bottle_invisibility = class({})

function modifier_item_hd_bottle_invisibility:IsDebuff() return false end
function modifier_item_hd_bottle_invisibility:IsHidden() return true end
function modifier_item_hd_bottle_invisibility:IsPurgable() return false end
function modifier_item_hd_bottle_invisibility:IsPurgeException() return false end
function modifier_item_hd_bottle_invisibility:RemoveOnDeath() return false end