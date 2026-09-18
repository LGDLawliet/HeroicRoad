item_hd_soul_of_orc = class({})

LinkLuaModifier("modifier_item_hd_soul_of_orc", "items/item_hd_soul_of_orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_soul_of_orc_active", "items/item_hd_soul_of_orc", LUA_MODIFIER_MOTION_NONE)


function item_hd_soul_of_orc:GetIntrinsicModifierName()
	return "modifier_item_hd_soul_of_orc"
end


function item_hd_soul_of_orc:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Visage.SoulAssumption.Cast")
	self:StartCooldown(5)
	local modifier = caster:FindAllModifiersByName("modifier_item_hd_soul_of_orc_active")
	if #modifier>0 then
		modifier[1]:SafeDestroy()
		return
	end

	caster:AddNewModifier(caster, self, "modifier_item_hd_soul_of_orc_active", {})
end

----------------------------------------------------------------------------------------


modifier_item_hd_soul_of_orc = class({})

function modifier_item_hd_soul_of_orc:IsDebuff() return false end
function modifier_item_hd_soul_of_orc:IsHidden() return true end
function modifier_item_hd_soul_of_orc:IsPurgable() return false end




function modifier_item_hd_soul_of_orc:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	-- self.PrimaryAttribute =parent:GetPrimaryAttribute()
	-- self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


    if IsServer() then

	end
end
function modifier_item_hd_soul_of_orc:OnDestroy()
	if IsServer() then

		local modifier = self:GetParent():FindAllModifiersByName("modifier_item_hd_soul_of_orc_active")
		if #modifier>0 then
			modifier[1]:SafeDestroy()
			return
		end
	end
end


function modifier_item_hd_soul_of_orc:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力


	}
end


-- function modifier_item_hd_soul_of_orc:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_soul_of_orc:GetModifierBonusStats_Intellect()	return self.bonus_int end




modifier_item_hd_soul_of_orc_active = advanced_modifier({})

function modifier_item_hd_soul_of_orc_active:IsDebuff() return false end
function modifier_item_hd_soul_of_orc_active:IsHidden() return false end
function modifier_item_hd_soul_of_orc_active:IsPurgable() return false end
function modifier_item_hd_soul_of_orc_active:GetTexture()return "item_soul_of_orc" end
function modifier_item_hd_soul_of_orc_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_soul_of_orc_active:GetEffectName() 	  return "particles/units/heroes/hero_visage/visage_soul_assumption_bolt_energy.vpcf" end
function modifier_item_hd_soul_of_orc_active:Advanced_GetModifierSpellAmplifyBonus()return 25 end
function modifier_item_hd_soul_of_orc_active:Advanced_GetModifierIncomingDamage_Percentage() return 50 end


function modifier_item_hd_soul_of_orc_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
	return funcs

end
