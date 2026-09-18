
LinkLuaModifier("modifier_item_hd_thousand_leagues_astrologer_buff", "items/item_hd_thousand_leagues_astrologer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_thousand_leagues_astrologer_active", "items/item_hd_thousand_leagues_astrologer.lua", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
item_hd_thousand_leagues_astrologer= item_hd_thousand_leagues_astrologer or class({})
function item_hd_thousand_leagues_astrologer:GetIntrinsicModifierName() 
    return "modifier_item_hd_thousand_leagues_astrologer_buff" 
end
function item_hd_thousand_leagues_astrologer:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_end_stars.vpcf", context )

end


function item_hd_thousand_leagues_astrologer:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetOrigin()+Vector(0,0,64)
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_end_stars.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl(nFXIndex, 0,pos)
    ParticleManager:SetParticleControl(nFXIndex, 2,pos)
    DestroyParticleByDelay(nFXIndex,2)
    for i = 1, 3, 1 do
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_end_stars.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0,pos)
		ParticleManager:SetParticleControl(nFXIndex, 2,pos+Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
		DestroyParticleByDelay(nFXIndex,2)
    end
    caster:AddNewModifier(caster, self, "modifier_item_hd_thousand_leagues_astrologer_active", { duration = 10} 	)
    caster:EmitSound("Ability.Starfall")
end




modifier_item_hd_thousand_leagues_astrologer_buff=class({})

-- function modifier_item_hd_thousand_leagues_astrologer_buff:IsPassive()			return true end
function modifier_item_hd_thousand_leagues_astrologer_buff:IsDebuff() return false end
function modifier_item_hd_thousand_leagues_astrologer_buff:IsHidden() 		return false end
function modifier_item_hd_thousand_leagues_astrologer_buff:IsPurgable() 		return false end
function modifier_item_hd_thousand_leagues_astrologer_buff:IsPurgeException() return false end
function modifier_item_hd_thousand_leagues_astrologer_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_thousand_leagues_astrologer_buff:DestroyOnExpire() return false end
function modifier_item_hd_thousand_leagues_astrologer_buff:OnCreated()

    local ability = self:GetAbility()
    self.bonus_evasion = ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_all_attribute = ability:GetSpecialValueFor("bonus_all_attribute")

end
function modifier_item_hd_thousand_leagues_astrologer_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
	
		

	}
end


function modifier_item_hd_thousand_leagues_astrologer_buff:GetModifierBonusStats_Strength()	return self.bonus_all_attribute end
function modifier_item_hd_thousand_leagues_astrologer_buff:GetModifierBonusStats_Agility()	return self.bonus_all_attribute end
function modifier_item_hd_thousand_leagues_astrologer_buff:GetModifierBonusStats_Intellect()	return self.bonus_all_attribute end
function modifier_item_hd_thousand_leagues_astrologer_buff:GetModifierEvasion_Constant()	
    if self:GetParent():HasModifier("modifier_item_hd_thousand_leagues_astrologer_active") then
        return 70
    end
    return self.bonus_evasion 
end



modifier_item_hd_thousand_leagues_astrologer_active = modifier_item_hd_thousand_leagues_astrologer_active or advanced_modifier({})

function modifier_item_hd_thousand_leagues_astrologer_active:IsDebuff() return false end
function modifier_item_hd_thousand_leagues_astrologer_active:IsHidden() return false end
function modifier_item_hd_thousand_leagues_astrologer_active:IsPurgable() return false end
function modifier_item_hd_thousand_leagues_astrologer_active:IsPurgeException() return false end
function modifier_item_hd_thousand_leagues_astrologer_active:RemoveOnDeath() return true end



-- advanced_modifier
function modifier_item_hd_thousand_leagues_astrologer_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp
    }
end
function modifier_item_hd_thousand_leagues_astrologer_active:Advanced_GetModifier_RandomEffectGain(keys)
	return 60
end


function modifier_item_hd_thousand_leagues_astrologer_active:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return 30
end