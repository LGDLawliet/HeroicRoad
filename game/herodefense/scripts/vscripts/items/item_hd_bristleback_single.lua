item_hd_bristleback_single = class({})
-- LinkLuaModifier("modifier_item_hd_bristleback_single_arua", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bristleback_single_arua_effect", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bristleback_single", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bristleback_single_active", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bristleback_single_active_standby", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bristleback_single_active_debuff", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_bristleback_single_thinker", "items/item_hd_bristleback_single", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_bristleback_single:GetIntrinsicModifierName()
	return "modifier_item_hd_bristleback_single"
end





modifier_item_hd_bristleback_single = class({})

function modifier_item_hd_bristleback_single:IsDebuff() return false end
function modifier_item_hd_bristleback_single:IsHidden() return true end
function modifier_item_hd_bristleback_single:IsPurgable() return false end
-- function modifier_item_hd_bristleback_single:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_bristleback_single:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_bristleback_single:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.str_index = self.ability:GetSpecialValueFor("str_index")
	

	self:StartIntervalThink(1)
end

function modifier_item_hd_bristleback_single:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_Bristle_Back") or self:GetCaster():FindAbilityByName("Middle_Bristle_Back") or self:GetCaster():FindAbilityByName("Advanced_Bristle_Back") then
		self.str_index = self.ability:GetSpecialValueFor("str_index_override")
	else
		self.str_index = self.ability:GetSpecialValueFor("str_index")
	end
	self.damage = self.str_index*self.parent:GetStrength()
end

function modifier_item_hd_bristleback_single:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量

		MODIFIER_EVENT_ON_TAKEDAMAGE,                     --受到伤害事件


	}
end



function modifier_item_hd_bristleback_single:OnTakeDamage(keys)
    if IsServer() then   
		if keys.unit == self:GetParent() and self:GetAbility():IsCooldownReady() then
			if keys.unit:GetTeamNumber()==keys.attacker:GetTeamNumber() then
				return
			end
			-- print("damage")
			self:GetAbility():UseResources(true, true, true,true)
			EmitSoundOn("Hero_Bristleback.QuillSpray.Cast", keys.unit)
			ApplyDamage({victim = keys.attacker, attacker = keys.unit, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
			
		end

    end 
end

