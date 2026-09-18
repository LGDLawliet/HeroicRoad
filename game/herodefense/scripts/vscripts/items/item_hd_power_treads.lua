item_hd_power_treads = class({})
-- LinkLuaModifier("modifier_item_hd_power_treads_arua", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_power_treads_arua_effect", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_agi", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_str", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_int", "items/item_hd_power_treads", LUA_MODIFIER_MOTION_NONE)

-- Item Passive

function item_hd_power_treads:GetIntrinsicModifierName()
	return "modifier_item_hd_power_treads"
end


function item_hd_power_treads:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		if not caster:IsHero() or caster:IsClone() then return end

		-- Switch tread attribute
		local modifiers1 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_str")
		local modifiers2 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_agi")
		local modifiers3 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_int")
		if #modifiers1>0 then
			modifiers1[1]:SafeDestroy()
			caster:AddNewModifier(caster, self, "modifier_item_hd_power_treads_agi", {})
		elseif #modifiers2>0 then
			modifiers2[1]:SafeDestroy()
			caster:AddNewModifier(caster, self, "modifier_item_hd_power_treads_int", {})
		elseif #modifiers3>0 then
			modifiers3[1]:SafeDestroy()
			caster:AddNewModifier(caster, self, "modifier_item_hd_power_treads_str", {})
		end
	end
end


modifier_item_hd_power_treads = class({})

function modifier_item_hd_power_treads:IsDebuff() return false end
function modifier_item_hd_power_treads:IsHidden() return true end
function modifier_item_hd_power_treads:IsPurgable() return false end



function modifier_item_hd_power_treads:OnCreated(keys)
    self.ability = self:GetAbility()
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_power_treads_agi", {})

	end

end

function modifier_item_hd_power_treads:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local modifiers1 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_str")
		local modifiers2 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_agi")
		local modifiers3 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_int")
		if #modifiers1>0 then	modifiers1[1]:SafeDestroy()	end
		if #modifiers2>0 then	modifiers2[1]:SafeDestroy()	end
		if #modifiers3>0 then	modifiers3[1]:SafeDestroy()	end
		
	end
end


function modifier_item_hd_power_treads:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度


	}
end


function modifier_item_hd_power_treads:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_item_hd_power_treads:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

modifier_item_hd_power_treads_str = class({})

function modifier_item_hd_power_treads_str:IsDebuff() return false end
function modifier_item_hd_power_treads_str:IsHidden() return false end
function modifier_item_hd_power_treads_str:IsPurgable() return true end
function modifier_item_hd_power_treads_str:GetTexture()return "item_power_treads_str" end
function modifier_item_hd_power_treads_str:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
	}
end
function modifier_item_hd_power_treads_str:GetModifierBonusStats_Strength()	return 10 end
function modifier_item_hd_power_treads_str:GetModifierMagicalResistanceBonus() return 10 end

modifier_item_hd_power_treads_agi = class({})

function modifier_item_hd_power_treads_agi:IsDebuff() return false end
function modifier_item_hd_power_treads_agi:IsHidden() return false end
function modifier_item_hd_power_treads_agi:IsPurgable() return true end
function modifier_item_hd_power_treads_agi:GetTexture()return "item_power_treads_agi" end
function modifier_item_hd_power_treads_agi:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
	}
end
function modifier_item_hd_power_treads_agi:GetModifierBonusStats_Agility()	return 10 end
function modifier_item_hd_power_treads_agi:GetModifierAttackSpeedBonus_Constant() return 20 end


modifier_item_hd_power_treads_int = advanced_modifier({})

function modifier_item_hd_power_treads_int:IsDebuff() return false end
function modifier_item_hd_power_treads_int:IsHidden() return false end
function modifier_item_hd_power_treads_int:IsPurgable() return true end
function modifier_item_hd_power_treads_int:GetTexture()return "item_power_treads_int" end
function modifier_item_hd_power_treads_int:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_int:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
	}
end
function modifier_item_hd_power_treads_int:GetModifierBonusStats_Intellect()	return 10 end
function modifier_item_hd_power_treads_int:Advanced_GetModifierSpellAmplifyBonus() return 8 end

function modifier_item_hd_power_treads_int:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end