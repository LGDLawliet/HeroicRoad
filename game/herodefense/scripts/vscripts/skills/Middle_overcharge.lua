Middle_overcharge = class({})
-- LinkLuaModifier("modifier_Middle_overcharge_arua", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_arua_effect", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_overcharge_active", "skills/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_active", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_effect", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_effect2", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_active_standby", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_debuff", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_overcharge_thinker", "items/Middle_overcharge", LUA_MODIFIER_MOTION_NONE)



function Middle_overcharge:OnSpellStart()

	local caster    =   self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	local modifier = caster:FindModifierByName("modifier_Middle_overcharge_active")
	if modifier then
		modifier:SafeDestroy()
	end

	caster:AddNewModifier(caster, self, "modifier_Middle_overcharge_active", {duration = duration})
	--------------------随机选取一个友军施加状态
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  

		   for _, unit in pairs(units) do
			   local buffs = unit:FindAllModifiersByName("modifier_Middle_overcharge_active")
			   if  #buffs == 0 then
	
				unit:AddNewModifier(caster, self, "modifier_Middle_overcharge_active", {duration = duration})
				return
			   end
		   end
		   local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		   DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		 
		for _, unit in pairs(units) do
			local buffs = unit:FindAllModifiersByName("modifier_Middle_overcharge_active")
			if  #buffs == 0 then
	
				unit:AddNewModifier(caster, self, "modifier_Middle_overcharge_active", {duration = duration})
				return
			end
		end
---------------------------------
end





modifier_Middle_overcharge_active = advanced_modifier({})

function modifier_Middle_overcharge_active:IsDebuff() return false end
function modifier_Middle_overcharge_active:IsHidden() return false end
function modifier_Middle_overcharge_active:IsPurgable() return false end
function modifier_Middle_overcharge_active:IsPurgeException() return true end


function modifier_Middle_overcharge_active:OnCreated(keys)
    self.ability = self:GetAbility()

 
	self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_HPRegenAmplify_Percentage = self.ability:GetSpecialValueFor("bonus_HPRegenAmplify_Percentage")
	self.bonus_str = 0
    self.bonus_agi = 0
	self.bonus_int = 0
	local parent = self:GetParent()
	if parent:IsRealHero() then
		self.bonus_str = parent:GetStrength()*0.2
		self.bonus_agi = parent:GetAgility()*0.2
		self.bonus_int = parent:GetIntellect(false)*0.2
	end
	if IsServer() then
		self:GetParent():EmitSound("Hero_Wisp.Overcharge")
	end
end


function modifier_Middle_overcharge_active:OnDestroy(keys)
    ParticleManager:DestroyParticle(self.overcharge_pfx, false)
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end

end
function modifier_Middle_overcharge_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		

	}
end


function modifier_Middle_overcharge_active:AdvancedGetModifierConstantHealthRegenPercentage() return self.bonus_HPRegenAmplify_Percentage end

function modifier_Middle_overcharge_active:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_Middle_overcharge_active:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Middle_overcharge_active:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Middle_overcharge_active:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_Middle_overcharge_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end
