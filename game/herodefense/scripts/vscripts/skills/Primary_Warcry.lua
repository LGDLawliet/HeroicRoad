


Primary_Warcry = class({})

LinkLuaModifier("modifier_Primary_Warcry_active", "skills/Primary_Warcry", LUA_MODIFIER_MOTION_NONE)




function Primary_Warcry:IsHiddenWhenStolen() 		return false end
function Primary_Warcry:IsRefreshable() 			return true end
function Primary_Warcry:IsStealable() 			return true end
function Primary_Warcry:IsNetherWardStealable()	return true end
-- function Primary_Warcry:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Primary_Warcry:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Primary_Warcry:OnSpellStart()
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
		local buff = ally:AddNewModifier(caster, self, "modifier_Primary_Warcry_active", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
		-- if not ally:IsCreep() then
		-- 	ally:CalculateStatBonus()
		-- end
		local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, ally)
		buff:AddParticle(pfx, false, false, 15, false, false)
	end
end

modifier_Primary_Warcry_active = advanced_modifier({})

function modifier_Primary_Warcry_active:IsDebuff()			return false end
function modifier_Primary_Warcry_active:IsHidden() 		return false end
function modifier_Primary_Warcry_active:IsPurgable() 		return false end
function modifier_Primary_Warcry_active:IsPurgeException() return true end
function modifier_Primary_Warcry_active:DeclareFunctions() return 
	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,} end
function modifier_Primary_Warcry_active:GetModifierMoveSpeedBonus_Percentage() return self.bonus_move_speed end
function modifier_Primary_Warcry_active:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor  end
function modifier_Primary_Warcry_active:GetModifierBonusStats_Strength() return self.bonus_str end
function modifier_Primary_Warcry_active:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	if IsServer() then
		
	end
end

function modifier_Primary_Warcry_active:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_Primary_Warcry_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end