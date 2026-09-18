item_hd_grandmasters_glaive = class({})
-- LinkLuaModifier("modifier_item_hd_grandmasters_glaive_arua", "items/item_hd_grandmasters_glaive", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_grandmasters_glaive_arua_effect", "items/item_hd_grandmasters_glaive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_grandmasters_glaive", "items/item_hd_grandmasters_glaive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_grandmasters_glaive_active", "items/item_hd_grandmasters_glaive", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_grandmasters_glaive:GetIntrinsicModifierName()
	return "modifier_item_hd_grandmasters_glaive"
end


function item_hd_grandmasters_glaive:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_TrollWarlord.Taunt.TrollGroove")
	self.particle = ParticleManager:CreateParticle("particles/econ/events/ti9/ti9_drums_musicnotes.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		   DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	
	for _, unit in pairs(units) do
		unit:AddNewModifier(unit, self, "modifier_item_hd_grandmasters_glaive_active", {duration = 10})
	end
	
end


modifier_item_hd_grandmasters_glaive = advanced_modifier({})

function modifier_item_hd_grandmasters_glaive:IsDebuff() return false end
function modifier_item_hd_grandmasters_glaive:IsHidden() return true end
function modifier_item_hd_grandmasters_glaive:IsPurgable() return false end


function modifier_item_hd_grandmasters_glaive:OnCreated(keys)
    self.ability = self:GetAbility()

 
  

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	
end


function modifier_item_hd_grandmasters_glaive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end


function modifier_item_hd_grandmasters_glaive:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_grandmasters_glaive:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_item_hd_grandmasters_glaive:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end
function modifier_item_hd_grandmasters_glaive:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end




modifier_item_hd_grandmasters_glaive_active = class({})

function modifier_item_hd_grandmasters_glaive_active:IsDebuff() return false end
function modifier_item_hd_grandmasters_glaive_active:IsHidden() return false end
function modifier_item_hd_grandmasters_glaive_active:IsPurgable() return false end
function modifier_item_hd_grandmasters_glaive_active:GetTexture()return "item_grandmasters_glaive" end
-- function modifier_item_hd_grandmasters_glaive_active:GetEffectName() return "particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf" end
-- function modifier_item_hd_grandmasters_glaive_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_grandmasters_glaive_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	

	}
end
function modifier_item_hd_grandmasters_glaive_active:GetModifierAttackSpeedBonus_Constant()return 100 end

function modifier_item_hd_grandmasters_glaive_active:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	


	return state
end