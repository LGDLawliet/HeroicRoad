
Primary_metamorphosis = class({})

LinkLuaModifier("modifier_Primary_metamorphosis_transform", "skills/Primary_metamorphosis", LUA_MODIFIER_MOTION_NONE)


function Primary_metamorphosis:Precache( context )
	PrecacheResource( "model", "models/items/terrorblade/marauders_demon/marauders_demon.vmdl", context )
end

function Primary_metamorphosis:OnSpellStart()
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
	caster.Form_MODIFIER_NAME = "modifier_Primary_metamorphosis_transform"

	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, ability, "modifier_Primary_metamorphosis_transform", {duration = duration*gain})
end



modifier_Primary_metamorphosis_transform = advanced_modifier({})
function modifier_Primary_metamorphosis_transform:IsHidden()	return false end
function modifier_Primary_metamorphosis_transform:IsPurgable()	return false end
function modifier_Primary_metamorphosis_transform:IsDebuff()	return false end



function modifier_Primary_metamorphosis_transform:DeclareFunctions()	
		local decFuncs = {
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
function modifier_Primary_metamorphosis_transform:GetModifierModelScale() 
    return 30
end
function modifier_Primary_metamorphosis_transform:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_Primary_metamorphosis_transform:GetModifierModelChange()
	return "models/items/terrorblade/marauders_demon/marauders_demon.vmdl"
end

function modifier_Primary_metamorphosis_transform:OnCreated()
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

    if IsServer() then
    	
    	

		--如果单位不是远程单位 则改变为远程
		if self.caster.IsRanger==false then
			self.caster.RangerFrom = self.caster.RangerFrom +  1   --变更为远程形态的状态数加一
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
	

    end
end

function modifier_Primary_metamorphosis_transform:OnDestroy()
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
function modifier_Primary_metamorphosis_transform:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end


function modifier_Primary_metamorphosis_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Primary_metamorphosis_transform:GetModifierProjectileSpeedBonus() return  800 end
function modifier_Primary_metamorphosis_transform:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_Primary_metamorphosis_transform:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_Primary_metamorphosis_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end