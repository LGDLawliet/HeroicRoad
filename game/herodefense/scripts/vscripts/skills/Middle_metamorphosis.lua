
Middle_metamorphosis = class({})

LinkLuaModifier("modifier_Middle_metamorphosis_transform", "skills/Middle_metamorphosis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Middle_metamorphosis_transform_debuff", "skills/Middle_metamorphosis", LUA_MODIFIER_MOTION_NONE)
function Middle_metamorphosis:Precache( context )
	PrecacheResource( "model", "models/items/terrorblade/marauders_demon/marauders_demon.vmdl", context )
end
function Middle_metamorphosis:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	local duration = ability:GetSpecialValueFor("duration")	
	
	-- Start transformation gesture
	-- caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	-- Play cast sound
	EmitSoundOn("Hero_Terrorblade.Metamorphosis", caster)

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Middle_metamorphosis_transform"


	local gain = caster:GetModifierDurationGainIndex(0.3)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	table.remove(units,1)
	local bonus_str = 0
	local bonus_agi = 0
	local bonus_int = 0
	for _, unit in ipairs(units) do
		if unit:IsRealHero() then
			bonus_str = bonus_str + unit:GetBaseStrength()*0.1
			bonus_agi = bonus_agi + unit:GetBaseAgility()*0.1
			bonus_int = bonus_int + unit:GetBaseIntellect()*0.1
			unit:AddNewModifier(caster, ability, "modifier_Middle_metamorphosis_transform_debuff", {duration = duration*gain})

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)




		end
	end



	
	caster:AddNewModifier(caster, ability, "modifier_Middle_metamorphosis_transform", {duration = duration*gain,str=bonus_str,agi=bonus_agi,int=bonus_int})
	
end



modifier_Middle_metamorphosis_transform = advanced_modifier({})
function modifier_Middle_metamorphosis_transform:IsHidden()	return false end
function modifier_Middle_metamorphosis_transform:IsPurgable()	return false end
function modifier_Middle_metamorphosis_transform:IsDebuff()	return false end



function modifier_Middle_metamorphosis_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			-- MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
			MODIFIER_PROPERTY_PROJECTILE_NAME,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			-- MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		}
		
		return decFuncs	
end
function modifier_Middle_metamorphosis_transform:GetModifierModelScale() 
    return 30
end
function modifier_Middle_metamorphosis_transform:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_Middle_metamorphosis_transform:GetModifierModelChange()
	return "models/items/terrorblade/marauders_demon/marauders_demon.vmdl"
end

function modifier_Middle_metamorphosis_transform:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if self.caster:Script_GetAttackRange()<=400 then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	else
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")*0.5
	end
	if self.caster:HasModifier("modifier_heroTalent_npc_dota_hero_terrorblade_2") then
		self.bonus_attack_range = self.bonus_attack_range +350
	end
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	self.bonus_str = keys.str
	self.bonus_agi = keys.agi
	self.bonus_int = keys.int

    if IsServer() then
    	
    	

		--如果单位不是远程单位 则改变为远程
		if self.caster.IsRanger==false then
			self.caster.RangerFrom = self.caster.RangerFrom +  1   --变更为远程形态的状态数加一
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
	

    end
end

function modifier_Middle_metamorphosis_transform:OnDestroy()
    if IsServer() then    	

		--如果单位不是远程单位 则改变为远程
		if self.caster.IsRanger==false then
			self.caster.RangerFrom = self.caster.RangerFrom -  1   --变更为远程形态的状态数减一
			--如果没有远程形态状态了变回近战
			if self.caster.RangerFrom==0 then
				self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end	
		end
    	
 	
    end
end
function modifier_Middle_metamorphosis_transform:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end


function modifier_Middle_metamorphosis_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Middle_metamorphosis_transform:GetModifierProjectileSpeedBonus() return  800 end
function modifier_Middle_metamorphosis_transform:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_Middle_metamorphosis_transform:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_Middle_metamorphosis_transform:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Middle_metamorphosis_transform:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Middle_metamorphosis_transform:GetModifierBonusStats_Agility()	return self.bonus_agi end

function modifier_Middle_metamorphosis_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end






modifier_Middle_metamorphosis_transform_debuff = class({})
function modifier_Middle_metamorphosis_transform_debuff:IsHidden()	return false end
function modifier_Middle_metamorphosis_transform_debuff:IsPurgable()	return false end
function modifier_Middle_metamorphosis_transform_debuff:IsDebuff()	return true end
function  modifier_Middle_metamorphosis_transform_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Middle_metamorphosis_transform_debuff:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		}
		
		return decFuncs	
end


function modifier_Middle_metamorphosis_transform_debuff:OnCreated(keys)
	self.parent = self:GetParent()
	self.bonus_str = -self.parent:GetStrength()*0.1
	self.bonus_agi = -self.parent:GetAgility()*0.1
	self.bonus_int = -self.parent:GetIntellect(false)*0.1

end


function modifier_Middle_metamorphosis_transform_debuff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Middle_metamorphosis_transform_debuff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Middle_metamorphosis_transform_debuff:GetModifierBonusStats_Agility()	return self.bonus_agi end