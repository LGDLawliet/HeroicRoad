


Middle_Warcry = class({})

LinkLuaModifier("modifier_Middle_Warcry_active", "skills/Middle_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Warcry_passive", "skills/Middle_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Warcry_effect", "skills/Middle_Warcry", LUA_MODIFIER_MOTION_NONE)


function Middle_Warcry:IsHiddenWhenStolen() 		return false end
function Middle_Warcry:IsRefreshable() 			return true end
function Middle_Warcry:IsStealable() 			return true end
function Middle_Warcry:IsNetherWardStealable()	return true end
-- function Middle_Warcry:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Middle_Warcry:GetIntrinsicModifierName() return "modifier_Middle_Warcry_passive" end
function Middle_Warcry:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Middle_Warcry:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
	local pfx_name2 = "particles/units/heroes/hero_sven/sven_warcry_buff_sven.vpcf"
	local sound_name = "Hero_Sven.WarCry"
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	caster:Purge(false, true, false, true, true)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
		local buff = ally:AddNewModifier(caster, self, "modifier_Middle_Warcry_active", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
		-- if not ally:IsCreep() then
		-- 	ally:CalculateStatBonus()
		-- end
		local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, ally)
		buff:AddParticle(pfx, false, false, 15, false, false)
	end
end

modifier_Middle_Warcry_active = advanced_modifier({})

function modifier_Middle_Warcry_active:IsDebuff()			return false end
function modifier_Middle_Warcry_active:IsHidden() 		return false end
function modifier_Middle_Warcry_active:IsPurgable() 		return false end
function modifier_Middle_Warcry_active:IsPurgeException() return true end
function modifier_Middle_Warcry_active:DeclareFunctions() return 
	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,} end
function modifier_Middle_Warcry_active:GetModifierMoveSpeedBonus_Percentage() return self.bonus_move_speed end
function modifier_Middle_Warcry_active:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor  end
function modifier_Middle_Warcry_active:GetModifierBonusStats_Strength() return self.bonus_str end
function modifier_Middle_Warcry_active:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	if IsServer() then
		
	end
end
	

function modifier_Middle_Warcry_active:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_Middle_Warcry_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

modifier_Middle_Warcry_passive = class({})

function modifier_Middle_Warcry_passive:IsHidden() return true end
function modifier_Middle_Warcry_passive:IsAura() return true end
function modifier_Middle_Warcry_passive:IsPurgable() 		return false end
function modifier_Middle_Warcry_passive:IsPurgeException() 	return false end
function modifier_Middle_Warcry_passive:RemoveOnDeath()  return false end
function modifier_Middle_Warcry_passive:GetAuraDuration() return 0.5 end
function modifier_Middle_Warcry_passive:GetModifierAura() return "modifier_Middle_Warcry_effect" end
function modifier_Middle_Warcry_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or 15000 end
function modifier_Middle_Warcry_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Middle_Warcry_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Warcry_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_Middle_Warcry_effect = advanced_modifier({})

function modifier_Middle_Warcry_effect:IsDebuff()			return false end
function modifier_Middle_Warcry_effect:IsHidden() 			return false end
function modifier_Middle_Warcry_effect:IsPurgable() 			return false end
function modifier_Middle_Warcry_effect:IsPurgeException() 	return false end
function modifier_Middle_Warcry_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_Middle_Warcry_effect:DeclareFunctions()
	return 	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end
function modifier_Middle_Warcry_effect:GetModifierMoveSpeedBonus_Percentage() return self.bonus_move_speed end
function modifier_Middle_Warcry_effect:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor  end
function modifier_Middle_Warcry_effect:GetModifierBonusStats_Strength() return self.bonus_str end
function modifier_Middle_Warcry_effect:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")*0.5
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")*0.5
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")*0.5
	if IsServer() then
		
	end
end

function modifier_Middle_Warcry_effect:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_Middle_Warcry_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end