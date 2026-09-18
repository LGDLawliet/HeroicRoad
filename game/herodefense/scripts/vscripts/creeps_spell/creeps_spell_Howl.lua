
creeps_spell_Howl = class ({})
LinkLuaModifier("modifier_creeps_spell_Howl_buff", "creeps_spell/creeps_spell_Howl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Howl_debuff", "creeps_spell/creeps_spell_Howl", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Howl:IsHiddenWhenStolen() 		return false end
function creeps_spell_Howl:IsRefreshable() 			return true  end
function creeps_spell_Howl:IsStealable() 			return true  end
function creeps_spell_Howl:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function creeps_spell_Howl:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	-- local sound_cast = "Hero_Lycan.Howl"
	local particle_lycan_howl = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
	
	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")	
		
	-- Play global cast sound, only for allies
	-- EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, caster)
	caster:EmitSound("Hero_Lycan.Howl")
	-- Add Lycan's cast particles
	local particle_lycan_howl_fx = ParticleManager:CreateParticle(particle_lycan_howl, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 2 , caster:GetAbsOrigin())

		
		
	
	
	-- Find all allies (except lane creeps) and give them the buff
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									1500,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
									
	for _, ally in pairs(allies) do
		ally:AddNewModifier(caster, ability, "modifier_creeps_spell_Howl_buff", {duration = duration})	
    end
    local units = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									1500,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
                                    false)
                                    
  
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)								
    for _, unit in pairs(units) do

		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, ability,"modifier_creeps_spell_Howl_debuff", {duration = duration*StatusResistance})	
	end
end



-------------------
-- HOWL MODIFIER --
-------------------

modifier_creeps_spell_Howl_buff = class({})

function modifier_creeps_spell_Howl_buff:IsDebuff()			    return false end
function modifier_creeps_spell_Howl_buff:IsHidden() 			return false end
function modifier_creeps_spell_Howl_buff:IsPurgable() 			return false end
function modifier_creeps_spell_Howl_buff:IsPurgeException() 	return true end
function modifier_creeps_spell_Howl_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_creeps_spell_Howl_buff:OnCreated()
	
	--AbilitySpecials
	self.attack	= 0
	local ability = self:GetAbility()
	if ability then
		self.attack = ability:GetSpecialValueFor("bonus_attack")
	end
end

function modifier_creeps_spell_Howl_buff:OnRefresh()
	self:OnCreated()
end

function modifier_creeps_spell_Howl_buff:DeclareFunctions()		
	local decFuncs = 	{
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
						}		
	return decFuncs			
end

function modifier_creeps_spell_Howl_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.attack
end





modifier_creeps_spell_Howl_debuff = advanced_modifier({})

function modifier_creeps_spell_Howl_debuff:IsDebuff()			    return true end
function modifier_creeps_spell_Howl_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Howl_debuff:IsPurgable() 			return false end
function modifier_creeps_spell_Howl_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_Howl_debuff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_creeps_spell_Howl_debuff:OnCreated()
    self.armor			= -self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_creeps_spell_Howl_debuff:OnRefresh()
	self:OnCreated()
end


function modifier_creeps_spell_Howl_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_spell_Howl_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end
-- advanced_modifier

function modifier_creeps_spell_Howl_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_spell_Howl_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end