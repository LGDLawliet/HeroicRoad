--特效优化 √
Advanced_metamorphosis = class({})

LinkLuaModifier("modifier_Advanced_metamorphosis_transform", "skills/Advanced_metamorphosis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_metamorphosis_transform_debuff", "skills/Advanced_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_metamorphosis_transform_damage_buff", "skills/Advanced_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_metamorphosis_Aura_effect", "skills/Advanced_metamorphosis", LUA_MODIFIER_MOTION_NONE)

function Advanced_metamorphosis:CheckKV(key)
	local table = {

	


		bonus_damage = 5,
		bonus_attack_speed = 3,
		bonus_attack_range = 4,




	}
	local value = table[key] or -1
	return value

end

function Advanced_metamorphosis:UnlockFirstCore(key)
	return true
end
function Advanced_metamorphosis:UnlockSecondCore(key)
	return true
end
function Advanced_metamorphosis:UnlockThirdCore(key)
	return true
end




function Advanced_metamorphosis:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", context )
	PrecacheResource( "model", "models/items/terrorblade/dotapit_s3_fallen_light_metamorphosis/dotapit_s3_fallen_light_metamorphosis.vmdl", context )
	PrecacheResource( "model", "models/items/terrorblade/endless_purgatory_demon/endless_purgatory_demon.vmdl", context )
	PrecacheResource( "model", "models/items/terrorblade/knight_of_foulfell_demon/knight_of_foulfell_demon.vmdl", context )
	PrecacheResource( "model", "models/items/terrorblade/marauders_demon/marauders_demon.vmdl", context )
	PrecacheResource( "particle", "particles/rebuild/spell/metamorphosis/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/metamorphosis/unlock3/effect_glow.vpcf", context )
end

function Advanced_metamorphosis:GetCastRange(vLocation, hTarget)

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local radius = 700
	--LV5解锁邪恶契约+
	if advanced_level>=5 then
		radius = 1000
	end
	return radius
end


function Advanced_metamorphosis:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self


	
	-- Start transformation gesture
	-- caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	-- Play cast sound
	EmitSoundOn("Hero_Terrorblade.Metamorphosis", caster)

	local selfmodifier = caster:FindModifierByName("modifier_Advanced_metamorphosis_transform")
	--销毁变形
	if selfmodifier then
		selfmodifier:SafeDestroy()
	
	else
		--添加状态

		local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
		if modifier then
			modifier:SafeDestroy()
		end
		caster.Form_MODIFIER_NAME = "modifier_Advanced_metamorphosis_transform"

		local attribute_bonus_index = 0.1
		--LV5解锁邪恶契约
		if self.advanced_level>=5 then
			attribute_bonus_index = 0.15
		end


		
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		table.remove(units,1)
		local bonus_str = 0
		local bonus_agi = 0
		local bonus_int = 0
		for _, unit in ipairs(units) do
			if unit:IsRealHero() then
				bonus_str = bonus_str + unit:GetBaseStrength()*attribute_bonus_index
				bonus_agi = bonus_agi + unit:GetBaseAgility()*attribute_bonus_index
				bonus_int = bonus_int + unit:GetBaseIntellect()*attribute_bonus_index
				unit:AddNewModifier(caster, ability, "modifier_Advanced_metamorphosis_transform_debuff", {})

				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)

			end
		end
	
		
		Timers:CreateTimer(0.1, function()
			caster:AddNewModifier(caster, ability, "modifier_Advanced_metamorphosis_transform", {str=bonus_str,agi=bonus_agi,int=bonus_int})
	
		end)
	end

	
	
end


function Advanced_metamorphosis:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	if not self then return end
	if not IsServer() then return end
	if not self:GetCaster():IsAlive() then return end
	
	local caster = self:GetCaster()
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 1,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, false, true, true, false, false, false)--对一单位执行攻击。
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end




modifier_Advanced_metamorphosis_transform = advanced_modifier({})
function modifier_Advanced_metamorphosis_transform:IsHidden()	return false end
function modifier_Advanced_metamorphosis_transform:IsPurgable()	return false end
function modifier_Advanced_metamorphosis_transform:IsDebuff()	return false end



function modifier_Advanced_metamorphosis_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_PROJECTILE_NAME,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
			-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		}
		
		return decFuncs	
end
function modifier_Advanced_metamorphosis_transform:GetModifierModelScale() 
    return 30
end
function modifier_Advanced_metamorphosis_transform:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_Advanced_metamorphosis_transform:GetModifierModelChange()
	return self.model 
end

function modifier_Advanced_metamorphosis_transform:OnCreated(keys)
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	if caster:Script_GetAttackRange()<=400 then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	else
		self.bonus_attack_range = (self.ability:GetSpecialValueFor("bonus_attack_range"))*0.5
	end
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_terrorblade_2") then
		self.bonus_attack_range = self.bonus_attack_range +350
	end
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	self.bonus_str = keys.str
	self.bonus_agi = keys.agi
	self.bonus_int = keys.int
	self.health_reduce_index = 0.04
	--LV10解锁蚕食+
	if self.advanced_level >=10 then
		self.health_reduce_index = 0.02
	end
	self.model = "models/items/terrorblade/marauders_demon/marauders_demon.vmdl"
	self.bonus_attack_damage = 0
	if self.ability:GetUnlock(1)==1 then
		self.bonus_attack_damage = 100
		self.bonus_attack_range = 0
		self.model = "models/items/terrorblade/dotapit_s3_fallen_light_metamorphosis/dotapit_s3_fallen_light_metamorphosis.vmdl"

	elseif self.ability:GetUnlock(2)==2 then
		self.model = "models/items/terrorblade/endless_purgatory_demon/endless_purgatory_demon.vmdl"
	elseif self.ability:GetUnlock(3)==3 then
		self.model = "models/items/terrorblade/knight_of_foulfell_demon/knight_of_foulfell_demon.vmdl"
	end
    if IsServer() then
    	
    	

	
		if not self.ability.unlock1 then
			--如果单位不是远程单位 则改变为远程
			if caster.IsRanger==false then
				self.attackChanging = true  --攻击形态转换
				caster.RangerFrom = caster.RangerFrom +  1   --变更为远程形态的状态数加一
				caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
			end
		end

		-- print("1")
		self.interval = 0.7
		self:StartIntervalThink(self.interval)
	

    end
end

function modifier_Advanced_metamorphosis_transform:OnDestroy()
    if IsServer() then    	
		local caster = self:GetCaster()
		--如果单位不是远程单位 则改变为远程
		if self.attackChanging and caster.IsRanger==false then
			caster.RangerFrom = caster.RangerFrom -  1   --变更为远程形态的状态数减一
			--如果没有远程形态状态了变回近战
			if caster.RangerFrom==0 then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end	
		end
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end


		
		--销毁产生的邪恶契约
		local heroes = GetAllRealHeroes()
		for _, hero in ipairs(heroes) do
			local modifiers = hero:FindAllModifiersByName("modifier_Advanced_metamorphosis_transform_debuff")
			for _, modifier in ipairs(modifiers) do
				if modifier:GetCaster()==caster then
					modifier:SafeDestroy()
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(pfx)
				end
			end
		end
    	
 	
    end
end

function modifier_Advanced_metamorphosis_transform:OnIntervalThink()
	if IsServer() then
		if not self.playEffectdone then
			self:playEffect()
		end
		-- print("check1")
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		-- local gain =caster:GetModifierDurationGainIndex(0.33)

		-- print("check2",gain)
		local selfdamage = caster:GetHealth()*self.health_reduce_index*self.interval
		selfdamage = selfdamage - selfdamage%1
		-- print("check3")
		if selfdamage>=5 then
			caster:SetHealth(caster:GetHealth()-selfdamage)
			--LV15解锁血祭
			if self.advanced_level>=15 then
				caster:AddNewModifier(caster, caster, "modifier_Advanced_metamorphosis_transform_damage_buff", {duration = 5,index=caster:GetHealth()*0.005})
			end
		end


		if ability.unlock3 then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE , FIND_ANY_ORDER, false)
			if #units>=1 then
				local attach_point = {
					caster:ScriptLookupAttachment( "attach_wing_l1" ),
					caster:ScriptLookupAttachment( "attach_wing_l2" ),
					caster:ScriptLookupAttachment( "attach_wing_l3" ),
					caster:ScriptLookupAttachment( "attach_wing_r1" ),
					caster:ScriptLookupAttachment( "attach_wing_r2" ),
					caster:ScriptLookupAttachment( "attach_wing_r3" ),
				}
				
				local info = 
				{
					-- Target = keys.target,
					-- Source = caster,
					Ability = self:GetAbility(),	
					EffectName = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf",
					iMoveSpeed = caster:GetProjectileSpeed(),
					-- sourceloc = pos,
					-- caster:GetProjectileSpeed()
					-- vSourceLoc = pos,
					bDrawsOnMinimap = false,  --？？
					bDodgeable = true,   --可躲闪
					bIsAttack = false,   --攻击效果
					bVisibleToEnemies = true,  --对敌人可视
					bReplaceExisting = false, --替换现有的
					flExpireTime = GameRules:GetGameTime() + 10, --存在时间
					bProvidesVision = false, --提供视野
					ExtraData = {}   --额外的数据
				}
				for i = 1, RandomInt(1, 6), 1 do
					info.Target=units[RandomInt(1, #units)]
					info.vSourceLoc = caster:GetAttachmentOrigin(attach_point[i])
					ProjectileManager:CreateTrackingProjectile(info)
				end
		
		
				
			end
		end



	end
end


function modifier_Advanced_metamorphosis_transform:playEffect()
	local caster = self:GetCaster()

	if self.ability.unlock1 then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_wing_r1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 4, caster, PATTACH_POINT_FOLLOW, "attach_wing_r2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_wing_r3", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 6, caster, PATTACH_POINT_FOLLOW, "attach_wing_l1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 7, caster, PATTACH_POINT_FOLLOW, "attach_wing_l2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 8, caster, PATTACH_POINT_FOLLOW, "attach_wing_l3", caster:GetAbsOrigin(), true)
		self:AddParticle( self.pfx, false, false, -1, true, false )
	elseif self.ability.unlock2 then
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/metamorphosis/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_wing_r1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 4, caster, PATTACH_POINT_FOLLOW, "attach_wing_r2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_wing_r3", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 6, caster, PATTACH_POINT_FOLLOW, "attach_wing_l1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 7, caster, PATTACH_POINT_FOLLOW, "attach_wing_l2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 8, caster, PATTACH_POINT_FOLLOW, "attach_wing_l3", caster:GetAbsOrigin(), true)
		self:AddParticle( self.pfx, false, false, -1, true, false )
	elseif self.ability.unlock3 then
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/metamorphosis/unlock3/effect_glow.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_wing_r1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 4, caster, PATTACH_POINT_FOLLOW, "attach_wing_r2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_wing_r3", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 6, caster, PATTACH_POINT_FOLLOW, "attach_wing_l1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 7, caster, PATTACH_POINT_FOLLOW, "attach_wing_l2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 8, caster, PATTACH_POINT_FOLLOW, "attach_wing_l3", caster:GetAbsOrigin(), true)
		self:AddParticle( self.pfx, false, false, -1, true, false )
	end
	self.playEffectdone = true
end


function modifier_Advanced_metamorphosis_transform:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end
function modifier_Advanced_metamorphosis_transform:IsAura()
	if IsServer() then
		if self:GetAbility().unlock2 then
			return true
		end
	end
	
	return false
end

function modifier_Advanced_metamorphosis_transform:GetModifierAura()	return "modifier_Advanced_metamorphosis_Aura_effect" end
function modifier_Advanced_metamorphosis_transform:GetAuraRadius()	return 1000  end
function modifier_Advanced_metamorphosis_transform:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_metamorphosis_transform:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_metamorphosis_transform:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end


function modifier_Advanced_metamorphosis_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Advanced_metamorphosis_transform:GetModifierProjectileSpeedBonus() return  800 end
function modifier_Advanced_metamorphosis_transform:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_Advanced_metamorphosis_transform:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_Advanced_metamorphosis_transform:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_metamorphosis_transform:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Advanced_metamorphosis_transform:GetModifierBonusStats_Agility()	return self.bonus_agi end
-- function modifier_Advanced_metamorphosis_transform:GetModifierTotalDamageOutgoing_Percentage(keys)	
-- 	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
-- 		return self.bonus_attack_damage  
-- 	end
-- 	return 0
-- end


function modifier_Advanced_metamorphosis_transform:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self.advanced_level>=20 and self:GetCaster():GetRandomEffect(5,INT_TYPE,1) >=RandomInt(1, 100) then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			local health_regen =  keys.target:GetHealth()*0.1
			local healing = HealWithGain(health_regen,keys.attacker,keys.attacker,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, healing, nil)
			keys.attacker:EmitSound("Hero_Terrorblade.Sunder.Cast")
		end
	end
end



-- advanced_modifier
function modifier_Advanced_metamorphosis_transform:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

	return funcs

end
function modifier_Advanced_metamorphosis_transform:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
		return self.bonus_attack_damage  
	end
	return 0
end




modifier_Advanced_metamorphosis_transform_debuff = class({})
function modifier_Advanced_metamorphosis_transform_debuff:IsHidden()	return false end
function modifier_Advanced_metamorphosis_transform_debuff:IsPurgable()	return false end
function modifier_Advanced_metamorphosis_transform_debuff:IsDebuff()	return true end
function  modifier_Advanced_metamorphosis_transform_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Advanced_metamorphosis_transform_debuff:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		}
		
		return decFuncs	
end


function modifier_Advanced_metamorphosis_transform_debuff:OnCreated(keys)
	self.parent = self:GetParent()
	self.bonus_str = -self.parent:GetStrength()*0.1
	self.bonus_agi = -self.parent:GetAgility()*0.1
	self.bonus_int = -self.parent:GetIntellect(false)*0.1

end


function modifier_Advanced_metamorphosis_transform_debuff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_metamorphosis_transform_debuff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Advanced_metamorphosis_transform_debuff:GetModifierBonusStats_Agility()	return self.bonus_agi end




modifier_Advanced_metamorphosis_transform_damage_buff = class({})

function modifier_Advanced_metamorphosis_transform_damage_buff:IsDebuff() return false end
function modifier_Advanced_metamorphosis_transform_damage_buff:IsHidden() return true end
function modifier_Advanced_metamorphosis_transform_damage_buff:IsPurgable() return false end
function  modifier_Advanced_metamorphosis_transform_damage_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Advanced_metamorphosis_transform_damage_buff:OnCreated(keys)

    if IsServer() then
		self:SetStackCount(keys.index)
	
  

	end
end


function modifier_Advanced_metamorphosis_transform_damage_buff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_Advanced_metamorphosis_transform_damage_buff:GetModifierBaseAttack_BonusDamage() return self:GetStackCount() end









modifier_Advanced_metamorphosis_Aura_effect = advanced_modifier({})
function modifier_Advanced_metamorphosis_Aura_effect:IsHidden()	return false end
function modifier_Advanced_metamorphosis_Aura_effect:IsDebuff()	return true end
function modifier_Advanced_metamorphosis_Aura_effect:IsPurgable()	return false end

function modifier_Advanced_metamorphosis_Aura_effect:Advanced_GetModifierPhysicalArmorBonus()	return -50 end



function modifier_Advanced_metamorphosis_Aura_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
