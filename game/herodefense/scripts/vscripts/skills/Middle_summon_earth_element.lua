
LinkLuaModifier( "modifier_Middle_summon_earth_element_arua", "skills/Middle_summon_earth_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_earth_element_effect", "skills/Middle_summon_earth_element", LUA_MODIFIER_MOTION_NONE )

Middle_summon_earth_element						= Middle_summon_earth_element or class({})
require("internal/timers")

function Middle_summon_earth_element:IsSummonSpell()return true end
function Middle_summon_earth_element:IsElementSummon()return true end


function Middle_summon_earth_element:OnSpellStart()

	
	local caster =self:GetCaster()


	
	

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+self:GetSpecialValueFor("basic_armor")
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 



	-- Add spawn particles in spawn location
	EmitSoundOn("Ability.Avalanche", caster)	
	local pfx_name = "particles/rebuild/spell/earth_element/summon_earth.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, unit_pos)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300,300,0))
	ParticleManager:ReleaseParticleIndex( pfx )


	local ability = self
	Timers(1.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_earth_element",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
		unit:AddNewModifier(caster, self, "modifier_Middle_summon_earth_element_arua", 
		{})
	end)


end




modifier_Middle_summon_earth_element_arua = class({})

function modifier_Middle_summon_earth_element_arua:IsHidden() return true end
function modifier_Middle_summon_earth_element_arua:IsAura() return true end
function modifier_Middle_summon_earth_element_arua:IsPurgable() 		return false end
function modifier_Middle_summon_earth_element_arua:IsPurgeException() 	return false end
function modifier_Middle_summon_earth_element_arua:RemoveOnDeath()  return false end
function modifier_Middle_summon_earth_element_arua:GetAuraDuration() return 0.5 end
function modifier_Middle_summon_earth_element_arua:GetModifierAura() return "modifier_Middle_summon_earth_element_effect" end
function modifier_Middle_summon_earth_element_arua:GetAuraRadius() return 500 end
function modifier_Middle_summon_earth_element_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Middle_summon_earth_element_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_summon_earth_element_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_Middle_summon_earth_element_effect = advanced_modifier({})

function modifier_Middle_summon_earth_element_effect:IsDebuff()			return false end
function modifier_Middle_summon_earth_element_effect:IsHidden() 			return true end
function modifier_Middle_summon_earth_element_effect:IsPurgable() 			return false end
function modifier_Middle_summon_earth_element_effect:IsPurgeException() 	return false end
function modifier_Middle_summon_earth_element_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Middle_summon_earth_element_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


function modifier_Middle_summon_earth_element_effect:Advanced_GetModifierPhysicalArmorBonus()
	return 7
end

