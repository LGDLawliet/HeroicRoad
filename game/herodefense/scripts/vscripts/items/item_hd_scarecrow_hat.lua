item_hd_scarecrow_hat = class({})

LinkLuaModifier("modifier_item_hd_scarecrow_hat", "items/item_hd_scarecrow_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_scarecrow_hat_aura_active", "items/item_hd_scarecrow_hat", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_scarecrow_hat_debuff", "items/item_hd_scarecrow_hat", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_scarecrow_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_scarecrow_hat"
end


function item_hd_scarecrow_hat:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/scarecorw_hat/effect_aura.vpcf", context )

end









function item_hd_scarecrow_hat:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Nightstalker.CripplingFear.Aura.TI10")
	caster:AddNewModifier(caster, self, "modifier_item_hd_scarecrow_hat_aura_active", {duration = 10})

end




modifier_item_hd_scarecrow_hat =modifier_item_hd_scarecrow_hat or class({})

function modifier_item_hd_scarecrow_hat:IsDebuff() return false end
function modifier_item_hd_scarecrow_hat:IsHidden() return true end
function modifier_item_hd_scarecrow_hat:IsPurgable() return false end
function modifier_item_hd_scarecrow_hat:IsPurgeException() return false end
function modifier_item_hd_scarecrow_hat:RemoveOnDeath() return false end
function modifier_item_hd_scarecrow_hat:DestroyOnExpire() return false end
function modifier_item_hd_scarecrow_hat:OnCreated(keys)

	self.bonus_int =  self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_mana =  self:GetAbility():GetSpecialValueFor("bonus_mana")

	if IsServer() then
	

	end
end

function modifier_item_hd_scarecrow_hat:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_hd_scarecrow_hat:GetModifierBonusStats_Intellect()return self.bonus_int end
function modifier_item_hd_scarecrow_hat:GetModifierManaBonus()return self.bonus_mana end






modifier_item_hd_scarecrow_hat_aura_active =modifier_item_hd_scarecrow_hat_aura_active or class({})

function modifier_item_hd_scarecrow_hat_aura_active:IsDebuff() return false end
function modifier_item_hd_scarecrow_hat_aura_active:IsHidden() return false end
function modifier_item_hd_scarecrow_hat_aura_active:IsPurgable() return false end
function modifier_item_hd_scarecrow_hat_aura_active:IsPurgeException() return false end
function modifier_item_hd_scarecrow_hat_aura_active:IsAura() return true end
function modifier_item_hd_scarecrow_hat_aura_active:GetAuraDuration() return 2 end
function modifier_item_hd_scarecrow_hat_aura_active:GetModifierAura() return "modifier_item_hd_scarecrow_hat_debuff" end
function modifier_item_hd_scarecrow_hat_aura_active:GetAuraRadius() return 1000 end
function modifier_item_hd_scarecrow_hat_aura_active:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_scarecrow_hat_aura_active:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_scarecrow_hat_aura_active:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_scarecrow_hat_aura_active:GetEffectName() return "particles/rebuild/items/scarecorw_hat/effect_aura.vpcf" end


modifier_item_hd_scarecrow_hat_debuff = modifier_item_hd_scarecrow_hat_debuff or class({})

function modifier_item_hd_scarecrow_hat_debuff:IsDebuff() return true end
function modifier_item_hd_scarecrow_hat_debuff:IsHidden() return false end
function modifier_item_hd_scarecrow_hat_debuff:IsPurgable() return false end
function modifier_item_hd_scarecrow_hat_debuff:IsPurgeException() return false end

function modifier_item_hd_scarecrow_hat_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	

	}
end

function modifier_item_hd_scarecrow_hat_debuff:GetModifierIncomingPhysicalDamage_Percentage(keys)
	if IsServer() then
		if keys.damage>=100 then
			self:SetStackCount(math.min(60,self:GetStackCount()+1))
		end
	end
	
	return 0.5*self:GetStackCount()

end

