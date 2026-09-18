
LinkLuaModifier("modifier_item_hd_soul", "items/item_hd_soul_1", LUA_MODIFIER_MOTION_NONE)


item_hd_soul_1 = class({})
function item_hd_soul_1:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "Hero_ShadowDemon.Soul_Catcher", 0, 0.5, 0 )
		local target = self:GetCursorTarget()
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_soul", {index=1})
		self:SpendCharge(0)
	end
end
item_hd_soul_2 = class({})
function item_hd_soul_2:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "Hero_ShadowDemon.Soul_Catcher", 0, 0.5, 0 )
		local target = self:GetCursorTarget()
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_soul", {index=3})
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_soul = class({})

function modifier_item_hd_soul:IsDebuff() return false end
function modifier_item_hd_soul:IsHidden() return false end
function modifier_item_hd_soul:IsPurgable() return false end
function modifier_item_hd_soul:IsPurgeException() return false end
function modifier_item_hd_soul:GetTexture()return "item_soul" end
function modifier_item_hd_soul:RemoveOnDeath() return false end
function modifier_item_hd_soul:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_item_hd_soul:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.index)
	end
end


function modifier_item_hd_soul:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力

	}
end

function modifier_item_hd_soul:GetModifierPreAttack_BonusDamage() return self:GetStackCount()*10 end