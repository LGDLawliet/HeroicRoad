

Middle_howl = class ({})
-- LinkLuaModifier("modifier_Middle_howl_buff", "skills/Middle_howl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_howl_debuff", "skills/Middle_howl", LUA_MODIFIER_MOTION_NONE)

-- function Middle_howl:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end
function Middle_howl:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
end


function Middle_howl:OnSpellStart()
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
	-- ParticleManager:SetParticleControl(particle_lycan_howl_fx, 1 , caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_lycan_howl_fx, 2 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle_lycan_howl_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		
		
	
	
	-- Find all allies (except lane creeps) and give them the buff
	-- local allies = FindUnitsInRadius(caster:GetTeamNumber(),
	-- 								caster:GetAbsOrigin(),
	-- 								nil,
	-- 								1500,
	-- 								DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	-- 								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	-- 								DOTA_UNIT_TARGET_FLAG_NONE,
	-- 								FIND_ANY_ORDER,
	-- 								false)
									
	-- for _, ally in pairs(allies) do
	-- 	ally:AddNewModifier(caster, ability, "modifier_Middle_howl_buff", {duration = duration})	
    -- end
    local units = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									1000,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
                                    false)
                                    
  
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)								
    for _, unit in pairs(units) do

		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, ability,"modifier_Middle_howl_debuff", {duration = duration*StatusResistance})	
	end
end




-- modifier_Middle_howl_buff = class({})

-- function modifier_Middle_howl_buff:IsDebuff()			    return false end
-- function modifier_Middle_howl_buff:IsHidden() 			return false end
-- function modifier_Middle_howl_buff:IsPurgable() 			return false end
-- function modifier_Middle_howl_buff:IsPurgeException() 	return true end
-- function modifier_Middle_howl_buff:GetEffectName()
-- 	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
-- end

-- function modifier_Middle_howl_buff:OnCreated()
	
-- 	--AbilitySpecials
-- 	self.attack	= 0
-- 	local ability = self:GetAbility()
-- 	if ability then
-- 		self.attack = ability:GetSpecialValueFor("bonus_attack")
-- 	end
-- end

-- function modifier_Middle_howl_buff:OnRefresh()
-- 	self:OnCreated()
-- end

-- function modifier_Middle_howl_buff:DeclareFunctions()		
-- 	local decFuncs = 	{
--         MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
-- 						}		
-- 	return decFuncs			
-- end

-- function modifier_Middle_howl_buff:GetModifierBaseDamageOutgoing_Percentage()
-- 	return self.attack
-- end





modifier_Middle_howl_debuff = advanced_modifier({})

function modifier_Middle_howl_debuff:IsDebuff()			    return true end
function modifier_Middle_howl_debuff:IsHidden() 			return false end
function modifier_Middle_howl_debuff:IsPurgable() 			return true end
-- function modifier_Middle_howl_debuff:IsPurgeException() 	return true end
-- function modifier_Middle_howl_debuff:GetEffectName()
-- 	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
-- end

function modifier_Middle_howl_debuff:OnCreated()
    local ability = self:GetAbility()
    self.armor			= -ability:GetSpecialValueFor("armor_reduce")
	self.damage = -ability:GetSpecialValueFor("damage_reduce")
	if IsServer() then
		local parent = self:GetParent()

	end
end	



function modifier_Middle_howl_debuff:DeclareFunctions()		
	local decFuncs = 	
	{

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
						
	}		
	return decFuncs			
end


function modifier_Middle_howl_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_Middle_howl_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage
end

-- advanced_modifier
function modifier_Middle_howl_debuff:ADDeclareFunctions()

	return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    
end
function modifier_Middle_howl_debuff:Advanced_GetModifierHealAMP_Percentage(keys)
	return -20
end



function modifier_Middle_howl_debuff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -20
end



function modifier_Middle_howl_debuff:Advanced_GetModifier_DurationGain(keys)
	return -20
end



function modifier_Middle_howl_debuff:Advanced_GetModifier_NegativeDurationGain(keys)
	return -20
end


