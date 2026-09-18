
--特效优化 √
Advanced_howl = class ({})
require('internal/timers')   --计时器功能
LinkLuaModifier("modifier_Advanced_howl_buff", "skills/Advanced_howl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_howl_debuff", "skills/Advanced_howl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_howl_unlock2_debuff", "skills/Advanced_howl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_howl_unlock3", "skills/Advanced_howl", LUA_MODIFIER_MOTION_NONE)

-- function Advanced_howl:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end
function Advanced_howl:CheckKV(key)
	local table = {

		damage_reduce =0.3,
		armor_reduce = 0.3,



	}
	local value = table[key] or -1
	return value

end
function Advanced_howl:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
end


function Advanced_howl:OnSpellStart()
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
	ParticleManager:SetParticleControlEnt(particle_lycan_howl_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	local max = 4 
	if self.advanced_level>=10 then
		max = 6
	end
	local count = RandomInt(1, max)
	for i = 1, count, 1 do
		Timers:CreateTimer(RandomFloat(0, 1), function()
			self:SpellEffect(caster)
		end)
	end
	if self.advanced_level>=15 then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										1000,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										DOTA_UNIT_TARGET_FLAG_NONE,
										FIND_ANY_ORDER,
										false)
										
		for _, ally in pairs(allies) do
			ally:AddNewModifier(caster, ability, "modifier_Advanced_howl_buff", {duration = duration})	
		end
	end
	
	

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
		unit:AddNewModifier(caster, ability,"modifier_Advanced_howl_debuff", {duration = duration*StatusResistance})	
	end
end


function Advanced_howl:SpellEffect(target)
	local caster = self:GetCaster()
	local ability = self
	-- local sound_cast = "Hero_Lycan.Howl"
	local particle_lycan_howl = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
	
	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")	
		
	-- Play global cast sound, only for allies
	-- EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, caster)
	target:EmitSound("Hero_Lycan.Howl")
	-- Add Lycan's cast particles
	local particle_lycan_howl_fx = ParticleManager:CreateParticle(particle_lycan_howl, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle_lycan_howl_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
	target:GetAbsOrigin(),
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
		unit:AddNewModifier(caster, ability,"modifier_Advanced_howl_debuff", {duration = duration*StatusResistance})	
	end
end

function Advanced_howl:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lunar_blessing_unlock1",{})
	-- self:SetLevel(0)
	-- self:SetLevel(1)
	return true
end
function Advanced_howl:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_howl:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_howl_unlock3",{})
	return true
end

modifier_Advanced_howl_buff = advanced_modifier({})

function modifier_Advanced_howl_buff:IsDebuff()			    return false end
function modifier_Advanced_howl_buff:IsHidden() 			return false end
function modifier_Advanced_howl_buff:IsPurgable() 			return true end
-- function modifier_Advanced_howl_buff:IsPurgeException() 	return true end
function modifier_Advanced_howl_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_Advanced_howl_buff:OnCreated()
	local ability = self:GetAbility()
    self.armor			= ability:GetSpecialValueFor("armor_reduce")
	self.damage = ability:GetSpecialValueFor("damage_reduce")
	self.base_value = 20
	if ability:GetSpecialValueFor("advanced_level")>=5 then
		self.base_value = 30
	end
	if IsServer() then
		self.trigger = true
		local parent = self:GetParent()

	end
end

function modifier_Advanced_howl_buff:OnRefresh()
	self:OnCreated()
end



function modifier_Advanced_howl_buff:DeclareFunctions()		
	local decFuncs = 	
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
						
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		
		decFuncs = 	
		{
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
							
		}
	end
	return decFuncs			
end


function modifier_Advanced_howl_buff:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_Advanced_howl_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage
end

function modifier_Advanced_howl_buff:GetModifierDamageOutgoing_Percentage()
	return self.damage
end

-- advanced_modifier
function modifier_Advanced_howl_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		
	}
	
	-- if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		
	-- 	table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	-- end
    return funcs
end
function modifier_Advanced_howl_buff:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.base_value
end

function modifier_Advanced_howl_buff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.base_value
end


function modifier_Advanced_howl_buff:Advanced_GetModifier_DurationGain(keys)
	return self.base_value
end


function modifier_Advanced_howl_buff:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.base_value
end





modifier_Advanced_howl_debuff = advanced_modifier({})

function modifier_Advanced_howl_debuff:IsDebuff()			    return true end
function modifier_Advanced_howl_debuff:IsHidden() 			return false end
function modifier_Advanced_howl_debuff:IsPurgable() 			return true end
-- function modifier_Advanced_howl_debuff:IsPurgeException() 	return true end
-- function modifier_Advanced_howl_debuff:GetEffectName()
-- 	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
-- end

function modifier_Advanced_howl_debuff:OnCreated()
    local ability = self:GetAbility()
    self.armor			= -ability:GetSpecialValueFor("armor_reduce")
	self.damage = -ability:GetSpecialValueFor("damage_reduce")
	self.base_value = -20
	if ability:GetSpecialValueFor("advanced_level")>=5 then
		self.base_value = -30
	end
	if IsServer() then
		self.trigger = true
		if not ability.unlock3 then
			self:StartIntervalThink(1)
		end
		
		local parent = self:GetParent()


	end
end	

function modifier_Advanced_howl_debuff:OnRefresh(keys)
	if IsServer() and self.trigger then
		local ability = self:GetAbility()
		local base_value = -20
		if ability.advanced_level>=5 then
			base_value = -30
		end
		self:SetStackCount(math.min(self:GetStackCount()+1,10))
		-- self:IncrementStackCount()
		local parent = self:GetParent()
	end
end



function modifier_Advanced_howl_debuff:OnIntervalThink()
	self.trigger = nil
end

function modifier_Advanced_howl_debuff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()

		local ability = self:GetAbility()
		if ability.unlock2 and not parent:IsAlive() then
			-- 死亡恐惧效果
			local particle_lycan_howl = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
			parent:EmitSound("Hero_Lycan.Howl")
			local particle_lycan_howl_fx = ParticleManager:CreateParticle(particle_lycan_howl, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , parent:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(particle_lycan_howl_fx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_lycan_howl_fx)
			local caster = self:GetCaster()
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
			parent:GetAbsOrigin(),
			nil,
			350,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
			local heroes = GetAllRealHeroes()
			local damage = 0
			for  _, hero in pairs(heroes) do
				local hero_damage = hero:GetAverageTrueAttackDamage(nil)
				if hero_damage>damage then
					damage = hero_damage
				end
			end			
			local damageTable = {
				-- victim = nil,
				attacker = caster,
				damage = damage*2,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = ability, --Optional.
			}
			
			for _, unit in pairs(units) do
				unit:AddNewModifier(caster, ability,"modifier_Advanced_howl_unlock2_debuff", {duration = 7})	
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
		end
	end
end


function modifier_Advanced_howl_debuff:DeclareFunctions()		
	local decFuncs = 	
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
						
	}	
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		
		decFuncs = 	
		{
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
							
		}
	end	
	return decFuncs			
end


function modifier_Advanced_howl_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor*(self:GetStackCount()*0.1+1)
end

function modifier_Advanced_howl_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage*(self:GetStackCount()*0.1+1)
end

function modifier_Advanced_howl_debuff:GetModifierDamageOutgoing_Percentage()
	return self.damage*(self:GetStackCount()*0.1+1)
end


-- advanced_modifier
function modifier_Advanced_howl_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_Advanced_howl_debuff:Advanced_GetModifierHealAMP_Percentage(keys)
	local value = self.base_value*(self:GetStackCount()*0.1+1)
	return value
end


function modifier_Advanced_howl_debuff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	local value = self.base_value*(self:GetStackCount()*0.1+1)
	return value
end



function modifier_Advanced_howl_debuff:Advanced_GetModifier_DurationGain(keys)
	local value = self.base_value*(self:GetStackCount()*0.1+1)
	return value
end


function modifier_Advanced_howl_debuff:Advanced_GetModifier_NegativeDurationGain(keys)
	local value = self.base_value*(self:GetStackCount()*0.1+1)
	return value
end







modifier_Advanced_howl_unlock2_debuff = advanced_modifier({})

function modifier_Advanced_howl_unlock2_debuff:IsDebuff()			    return true end
function modifier_Advanced_howl_unlock2_debuff:IsHidden() 			return false end
function modifier_Advanced_howl_unlock2_debuff:IsPurgable() 			return true end




function modifier_Advanced_howl_unlock2_debuff:Advanced_GetModifierIncomingDamage_Percentage()	return 35 end



function modifier_Advanced_howl_unlock2_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_Advanced_howl_unlock2_debuff:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end


function modifier_Advanced_howl_unlock2_debuff:OnTooltip()
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end








modifier_Advanced_howl_unlock3 = class({})

function modifier_Advanced_howl_unlock3:IsDebuff()			return false end
function modifier_Advanced_howl_unlock3:IsHidden() 			return true end
function modifier_Advanced_howl_unlock3:IsPurgable() 		return false end
function modifier_Advanced_howl_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_howl_unlock3:RemoveOnDeath() return false end
