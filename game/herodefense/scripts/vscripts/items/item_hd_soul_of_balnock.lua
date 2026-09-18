item_hd_soul_of_balnock = class({})
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_arua", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_arua_effect", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_soul_of_balnock", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_active", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_soul_of_balnock_effect", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_effect2", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_active_standby", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_debuff", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_soul_of_balnock_thinker", "items/item_hd_soul_of_balnock", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_soul_of_balnock:GetIntrinsicModifierName()
	return "modifier_item_hd_soul_of_balnock"
end

function item_hd_soul_of_balnock:IsSummonSpell()return true end


function item_hd_soul_of_balnock:OnSpellStart()

	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	caster:EmitSound("n_creep_Ursa.Clap")
	-- local ability = caster:FindAbilityByName("imba_venomancer_poison_sting")
	local theward = {}

	local life_duration = self:GetSpecialValueFor("duration")
	local heal = caster:GetMaxHealth()
	local armor = caster:GetPhysicalArmorValue(false)
	local damage = caster:GetBaseDamageMax()

	local unit = caster:SummonUnit("npc_hd_balnock",life_duration,
	self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120),
	nil,
	self,0,heal,0,damage,armor,1,1)
	table.insert(theward, unit)
	unit:AddNewModifier(caster, self, "modifier_item_hd_soul_of_balnock_effect", {})


	Timers:CreateTimer(FrameTime(), function()
		for _, ward in pairs(theward) do
			FindClearSpaceForUnit(ward, ward:GetAbsOrigin(), true)
			local pos = ward:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, pos)
			ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
			ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
			ParticleManager:ReleaseParticleIndex(pfx)
		end
		return nil
	end
	)
end





modifier_item_hd_soul_of_balnock = advanced_modifier({})

function modifier_item_hd_soul_of_balnock:IsDebuff() return false end
function modifier_item_hd_soul_of_balnock:IsHidden() return true end
function modifier_item_hd_soul_of_balnock:IsPurgable() return false end
-- function modifier_item_hd_soul_of_balnock:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
-- function modifier_item_hd_soul_of_balnock:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_soul_of_balnock:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")
	

end


-- advanced_modifier
function modifier_item_hd_soul_of_balnock:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
		advanced_MODIFIER_PROPERTY_SummonTime_Intensity
    }
end
function modifier_item_hd_soul_of_balnock:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity
end



function modifier_item_hd_soul_of_balnock:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end






modifier_item_hd_soul_of_balnock_effect = class({})

function modifier_item_hd_soul_of_balnock_effect:IsDebuff()			return false end
function modifier_item_hd_soul_of_balnock_effect:IsHidden() 			return true end
function modifier_item_hd_soul_of_balnock_effect:IsPurgable() 		    return false end
function modifier_item_hd_soul_of_balnock_effect:IsPurgeException() 	return false end
function modifier_item_hd_soul_of_balnock_effect:RemoveOnDeath()       return false end
-- function modifier_item_hd_soul_of_balnock_effect:GetStatusEffectName() return "particles/status_fx/status_effect_swiftslash.vpcf" end
-- function modifier_item_hd_soul_of_balnock_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_soul_of_balnock_effect:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
function modifier_item_hd_soul_of_balnock_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_Blur_detected:GetStatusEffectName() return "particles/basic_extend/status_effect_blur.vpcf" end
-- function modifier_Advanced_Blur_detected:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end