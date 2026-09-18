item_hd_balnocks_furnace = class({})
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_arua", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_arua_effect", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_balnocks_furnace", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_active", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_effect", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_effect2", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_active_standby", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_debuff", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnocks_furnace_thinker", "items/item_hd_balnocks_furnace", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_balnocks_furnace:GetIntrinsicModifierName()
	return "modifier_item_hd_balnocks_furnace"
end



modifier_item_hd_balnocks_furnace = advanced_modifier({})

function modifier_item_hd_balnocks_furnace:IsDebuff() return false end
function modifier_item_hd_balnocks_furnace:IsHidden() return true end
function modifier_item_hd_balnocks_furnace:IsPurgable() return false end


function modifier_item_hd_balnocks_furnace:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")

end



function modifier_item_hd_balnocks_furnace:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法

	}
end


function modifier_item_hd_balnocks_furnace:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_balnocks_furnace:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end


function modifier_item_hd_balnocks_furnace:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_balnocks_furnace:OnAbilityFullyCast(keys)

	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		local manacost = keys.ability:GetManaCost(keys.ability:GetLevel())
		if manacost < 20 then
			return
		end
		local caster = self:GetCaster()
		if caster:GetRandomEffect(30,INT_TYPE,1)>=RandomInt(1, 100) then
	
			caster:GiveMana(manacost*1.5)
			caster:EmitSound("Hero_Antimage.ManaVoidCast")
			self.particle = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_streaks.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)
		end
		
	
		
	end
end

