item_hd_verodicias_rune_staff = class({})
-- LinkLuaModifier("modifier_item_hd_verodicias_rune_staff_arua", "items/item_hd_verodicias_rune_staff", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_verodicias_rune_staff_arua_effect", "items/item_hd_verodicias_rune_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_verodicias_rune_staff", "items/item_hd_verodicias_rune_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_verodicias_rune_staff_active", "items/item_hd_verodicias_rune_staff", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_verodicias_rune_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_verodicias_rune_staff"
end




modifier_item_hd_verodicias_rune_staff = advanced_modifier({})

function modifier_item_hd_verodicias_rune_staff:IsDebuff() return false end
function modifier_item_hd_verodicias_rune_staff:IsHidden() return true end
function modifier_item_hd_verodicias_rune_staff:IsPurgable() return false end



function modifier_item_hd_verodicias_rune_staff:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	
	self.bonus_summon_time = self.ability:GetSpecialValueFor("bonus_summon_time")
	


    if IsServer() then
		self:StartIntervalThink(0.2)

	end
end
function modifier_item_hd_verodicias_rune_staff:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()

	   if ability:IsCooldownReady() then
		
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for _, unit in pairs(units) do
			   if  unit:GetHealthPercent()<=95 then
					ability:UseResources(true, true, true, true)
					ability:StartCooldown(7)
					local heal = caster:GetIntellect(false)*6
					local healing = HealWithGain(heal,caster,unit,ability)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
					local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
					unit:AddNewModifier(caster, ability, "modifier_item_hd_verodicias_rune_staff_active", {duration = 20*ModifierStatusGain})
					self.particle = ParticleManager:CreateParticle("particles/econ/items/natures_prophet/natures_prophet_ti9_immortal/natures_prophet_ti9_wrath_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
					ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(self.particle)
					unit:EmitSound("Hero_Warlock.ShadowWordCastGood")



				return
			   end
		   end
		  
		end

		-- self:SetHasCustomTransmitterData(true)
	end
end


function modifier_item_hd_verodicias_rune_staff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	
		

	}
end



function modifier_item_hd_verodicias_rune_staff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_verodicias_rune_staff:GetModifierHealthBonus()	return self.bonus_health end

-- advanced_modifier
function modifier_item_hd_verodicias_rune_staff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_item_hd_verodicias_rune_staff:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end




modifier_item_hd_verodicias_rune_staff_active = advanced_modifier({})

function modifier_item_hd_verodicias_rune_staff_active:IsDebuff() return false end
function modifier_item_hd_verodicias_rune_staff_active:IsHidden() return false end
function modifier_item_hd_verodicias_rune_staff_active:IsPurgable() return false end
function modifier_item_hd_verodicias_rune_staff_active:GetTexture()return "item_verodicias_rune_staff" end
function modifier_item_hd_verodicias_rune_staff_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_item_hd_verodicias_rune_staff_active:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
	

-- 	}
-- end
-- function modifier_item_hd_verodicias_rune_staff_active:GetModifierTotalDamageOutgoing_Percentage()return 15 end

-- advanced_modifier
function modifier_item_hd_verodicias_rune_staff_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_verodicias_rune_staff_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return 15
end
