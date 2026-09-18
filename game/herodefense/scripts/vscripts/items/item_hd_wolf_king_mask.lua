item_hd_wolf_king_mask = class({})
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_arua", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_arua_effect", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wolf_king_mask", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_active", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wolf_king_mask_effect", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_effect2", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_active_standby", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_debuff", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wolf_king_mask_thinker", "items/item_hd_wolf_king_mask", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_wolf_king_mask:GetIntrinsicModifierName()
	return "modifier_item_hd_wolf_king_mask"
end

function item_hd_wolf_king_mask:IsSummonSpell()return true end



function item_hd_wolf_king_mask:OnSpellStart()

	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	-- caster:EmitSound("n_creep_Ursa.Clap")
	caster:EmitSound("Hero_Lycan.Howl.Team")

	local theward = {}

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = caster:GetMaxHealth()*0.6
	local armor = caster:GetPhysicalArmorValue(false)*0.6
	local damage = caster:GetBaseDamageMax()*0.6

	local summon_number = 3
	local number_gain = caster:GetIntellect(false)*0.01
	summon_number = summon_number + number_gain-number_gain%1
	for i = 1, summon_number, 1 do
		local unit = caster:SummonUnit("npc_hd_blood_wolf",life_duration,
		self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((summon_number - 1) / 2))),
		self:GetCaster():GetForwardVector(),
		self,0,heal,0,damage,armor,1,1)
		table.insert(theward, unit)
		unit:AddNewModifier(caster, self, "modifier_item_hd_wolf_king_mask_effect", {})
	end
	


	-- Timers:CreateTimer(FrameTime(), function()
	-- 	for _, ward in pairs(theward) do
	-- 		FindClearSpaceForUnit(ward, ward:GetAbsOrigin(), true)
	-- 		-- local pos = ward:GetAbsOrigin()
	-- 		-- local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- 		-- ParticleManager:SetParticleControl(pfx, 0, pos)
	-- 		-- ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
	-- 		-- ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
	-- 		-- ParticleManager:ReleaseParticleIndex(pfx)
	-- 	end
	-- 	return nil
	-- end
	-- )
end






modifier_item_hd_wolf_king_mask = advanced_modifier({})

function modifier_item_hd_wolf_king_mask:IsDebuff() return false end
function modifier_item_hd_wolf_king_mask:IsHidden() return true end
function modifier_item_hd_wolf_king_mask:IsPurgable() return false end


function modifier_item_hd_wolf_king_mask:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")
	

end



function modifier_item_hd_wolf_king_mask:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

		

	}
end



function modifier_item_hd_wolf_king_mask:GetModifierBonusStats_Intellect()	return self.bonus_int end



-- advanced_modifier
function modifier_item_hd_wolf_king_mask:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
		advanced_MODIFIER_PROPERTY_SummonTime_Intensity
    }
end
function modifier_item_hd_wolf_king_mask:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity
end


function modifier_item_hd_wolf_king_mask:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end



modifier_item_hd_wolf_king_mask_effect = class({})

function modifier_item_hd_wolf_king_mask_effect:IsDebuff()			return false end
function modifier_item_hd_wolf_king_mask_effect:IsHidden() 			return true end
function modifier_item_hd_wolf_king_mask_effect:IsPurgable() 		    return false end
function modifier_item_hd_wolf_king_mask_effect:IsPurgeException() 	return false end
function modifier_item_hd_wolf_king_mask_effect:RemoveOnDeath()       return false end
-- function modifier_item_hd_wolf_king_mask_effect:GetStatusEffectName() return "particles/status_fx/status_effect_swiftslash.vpcf" end
-- function modifier_item_hd_wolf_king_mask_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_wolf_king_mask_effect:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_05.vpcf" end
function modifier_item_hd_wolf_king_mask_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_Blur_detected:GetStatusEffectName() return "particles/basic_extend/status_effect_blur.vpcf" end
-- function modifier_Advanced_Blur_detected:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end