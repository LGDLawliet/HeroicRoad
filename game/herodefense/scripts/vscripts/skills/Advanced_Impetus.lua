--特效优化 √
Advanced_Impetus = class({})

LinkLuaModifier("modifier_Advanced_Impetus", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Impetus_orb", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Impetus_unlock2", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Impetus_unlock2_effect", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Impetus_unlock3", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Impetus_unlock3_target", "skills/Advanced_Impetus", LUA_MODIFIER_MOTION_NONE)
function Advanced_Impetus:CheckKV(key)
	local table = {

	

		basic_damage =1,
		intelligence_index = 0.007,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Impetus:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	return true
end
function Advanced_Impetus:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	return true
end
function Advanced_Impetus:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock3",{})
	return true
end

-- function Advanced_Impetus:GetBehavior()


-- 	if self:GetCaster():HasModifier("modifier_Advanced_Impetus_unlock3") then

-- 		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
-- 	end
-- 	return self.BaseClass.GetBehavior(self)
	
-- end



function Advanced_Impetus:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_Advanced_Impetus_unlock3") then

			if not target:IsRealHero() then
				return UF_FAIL_CUSTOM
			end
			if target==self:GetCaster() then
				return UF_FAIL_CUSTOM
			end
			if IsEnemy(target,self:GetCaster()) then
				return UF_FAIL_CUSTOM
			end
			return UF_SUCCESS
		else
			if not IsEnemy(target,self:GetCaster()) then
				return UF_FAIL_CUSTOM
			end
		end
		


		return UF_SUCCESS
	end
	
end
function Advanced_Impetus:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end
function Advanced_Impetus:GetUnlock3Target()
	if self.target then
	
		if self.target:IsNull() then
			return nil
		end
		return self.target
	end
	return nil
end

function Advanced_Impetus:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf", context )


end




--------------------------------------------------------------------
function Advanced_Impetus:IsHiddenWhenStolen() 		  return false end
function Advanced_Impetus:IsRefreshable() 			  return true end
function Advanced_Impetus:IsStealable() 				return false end
function Advanced_Impetus:IsNetherWardStealable() 	return false end
--下为自动施法
function Advanced_Impetus:GetIntrinsicModifierName() return "modifier_Advanced_Impetus_orb" end
function Advanced_Impetus:GetManaCost(iLevel)
	if self:GetUnlock(1)==1 then
		return 0
	end
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if IsServer() then
		local ability = self:FindTalent()
		if ability then
			if ability:GetAutoCastState() then
				return cost*2
			end
			return cost *0.5
		end
	end
	return cost
end

function Advanced_Impetus:FindTalent()

	if not self.talent_ability then
		self.talent_ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enchantress_2")
	end
	return  self.talent_ability
end

function Advanced_Impetus:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end
--主动的施法
function Advanced_Impetus:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local modifier = caster:FindModifierByName("modifier_Advanced_Impetus_unlock3")
	if modifier then

		self.target = target
		modifier:SafeDestroy()
		return
	end
	self:StartCooldown(0.1)
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		-- EffectName = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
		EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
		
		iMoveSpeed = 1200,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function Advanced_Impetus:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	if keys.unlock3 then
		self:TriggerUnlock3(target,keys)
		return
	end
	local caster = self:GetCaster()
	local dis= GetDistanceBetweenTwoUnit(caster,target)
	if self.unlock1 and dis<1000 then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_loadout.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		
		dis = 1000
	end
	-- print(dis)
	if  self:GetCaster():GetRandomEffect(self:GetSpecialValueFor("bonus_chance"),INT_TYPE,1)  >=RandomInt(1, 100)  then
		local bonus_range = self:GetSpecialValueFor("bonua_range_in_damage")
		--LV10解锁自然打击
		if self.advanced_level>=10 then
			bonus_range = 600
		end
		dis = dis + bonus_range
		local pfx = ParticleManager:CreateParticle("particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas_n.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
		ParticleManager:ReleaseParticleIndex(pfx)
		
	end
	if keys.bonus then
		dis = dis + keys.bonus
	end
	local basic_damage_index = self:GetSpecialValueFor("basic_damage")
	local int_index = self:GetSpecialValueFor("intelligence_index")
	--LV15解锁璀璨一击
	local chance = 5
	if self.unlock2 then
		chance = 30
	end
	if self.advanced_level>=15 and self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) then
		basic_damage_index = basic_damage_index *5
		int_index = int_index *5

		local pfx = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_force_gold_ambient/rubick_telekinesis_land_force_gold.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z))
		ParticleManager:ReleaseParticleIndex(pfx)



	end
	local damage = dis * (basic_damage_index + int_index * caster:GetIntellect(false)) *0.01
	if self.unlock1 then
		if self.talent_ability then
			damage = damage *1.325
			
		end
	else
		if self.talent_ability and self.talent_ability:GetAutoCastState() then
			damage = damage *1.65
			
		end
	end

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = self, --Optional.
		}
	target:ApplyMergeDamage(damageTable)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enchantress.ImpetusDamage", target)

	--LV20解锁喜加一
	if self.advanced_level>=20 and 10>=RandomInt(1, 100) then
		local info = 
		{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
end
function Advanced_Impetus:TriggerUnlock3(target,keys)
	local caster = self:GetCaster()
	local dis= GetDistanceBetweenTwoUnit(caster,target)
	dis = math.min(dis,2000)
	local basic_damage_index = self:GetSpecialValueFor("basic_damage")
	local int_index = self:GetSpecialValueFor("intelligence_index")
	local damage = dis * (basic_damage_index + int_index * caster:GetIntellect(false)) *0.01
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage*0.1,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = self, --Optional.
	}
	target:ApplyMergeDamage(damageTable)

	local new_target = EntIndexToHScript(keys.target)
	if not new_target or new_target:IsNull() or not new_target:IsAlive() then
		return
	end
	local info = 
	{
		Target = new_target,
		Source = target,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
		iMoveSpeed = caster:GetProjectileSpeed(),
		vSourceLoc= target:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {bonus = dis}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end


function Advanced_Impetus:Spawn()
	self.talent_ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enchantress_2")
end









modifier_Advanced_Impetus_orb = advanced_modifier({})

function modifier_Advanced_Impetus_orb:IsDebuff()			return false end
function modifier_Advanced_Impetus_orb:IsHidden() 			return true end
function modifier_Advanced_Impetus_orb:IsPurgable() 		return false end
function modifier_Advanced_Impetus_orb:IsPurgeException() 	return false end
function modifier_Advanced_Impetus_orb:Advanced_GetModifierAttackRangeBonus() 
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonua_range = self:GetAbility():GetSpecialValueFor("bonua_range")
	--LV5解锁远程打击+
	if self.advanced_level>=5 then
		self.bonua_range = 250
	end
	if self:GetAbility():GetCaster():PassivesDisabled() or not self:GetCaster():IsRangedAttacker() then
		return 0
	end
	return self.bonua_range 
end


function modifier_Advanced_Impetus_orb:OnCreated()
	-- self.bonua_range = 150
	if IsServer() then
		self.advanced_level = 1
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Advanced_Impetus_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
	end
end
function modifier_Advanced_Impetus_orb:DeclareFunctions()
	 return 
	 
	 {

		 MODIFIER_EVENT_ON_ATTACK,

	} 
end
function modifier_Advanced_Impetus_orb:OnAttack(keys)


	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion()
	or not ability:GetAutoCastState() then
		return
	end
	if not ability:IsFullyCastable() then
		return
	end
	if not parent:IsApplyModifier() then
		return
	end
	if not IsEnemy(keys.target,parent) then
		return
	end
	-- self:SetStackCount(1)
	-- self:GetParent():StartGesture(ACT_DOTA_ATTACK2)
	local needTime = math.max(parent:GetSecondsPerAttack(false),0.03)
	parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1/needTime)
	ability:UseResources(true, true, true, true)
	local target = ability:GetUnlock3Target()
	if target then
		local info = 
		{
			Target = target,
			Source = parent,
			SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
			iMoveSpeed = parent:GetProjectileSpeed(),
			vSourceLoc= parent:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,	
			ExtraData = {unlock3 = 1,target	=  keys.target:entindex()}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
	else
		local info = 
		{
			Target = keys.target,
			Source = parent,
			SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
			iMoveSpeed = parent:GetProjectileSpeed(),
			vSourceLoc= parent:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,	
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end


end
function modifier_Advanced_Impetus_orb:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

modifier_Advanced_Impetus_unlock2 = class({})

function modifier_Advanced_Impetus_unlock2:IsDebuff()			return false end
function modifier_Advanced_Impetus_unlock2:IsHidden() 			return true end
function modifier_Advanced_Impetus_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Impetus_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Impetus_unlock2:RemoveOnDeath() return false end

function modifier_Advanced_Impetus_unlock2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Impetus_unlock2_effect", {})
	end
end


modifier_Advanced_Impetus_unlock2_effect = class({})

function modifier_Advanced_Impetus_unlock2_effect:IsDebuff()			return false end
function modifier_Advanced_Impetus_unlock2_effect:IsHidden() 			return true end
function modifier_Advanced_Impetus_unlock2_effect:IsPurgable() 		return false end
function modifier_Advanced_Impetus_unlock2_effect:IsPurgeException() 	return false end
-- function modifier_Advanced_Impetus_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Impetus_unlock2_effect:DeclareFunctions()
	return 
	
	{
		MODIFIER_EVENT_ON_ATTACK,
   } 
end
function modifier_Advanced_Impetus_unlock2_effect:OnAttack(keys)


   if not IsServer() then
	   return 
   end
   local parent = self:GetParent()
   local ability = self:GetAbility()
   if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion()
	or not ability:IsCooldownReady() or not ability:GetAutoCastState() then
	   return
   end
   if not IsEnemy(keys.target,parent) then
	   return
   end

	if  self:GetCaster():GetRandomEffect(10,INT_TYPE,1)  >=RandomInt(1, 100)  then
		-- local needTime = math.max(parent:GetSecondsPerAttack(false),0.03)
		-- parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1/needTime)
		-- :UseResources(true, true, true, true)
		local info = 
		{
			Target = keys.target,
			Source = parent,
			SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
			iMoveSpeed = parent:GetProjectileSpeed(),
			vSourceLoc= parent:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,	
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

end






modifier_Advanced_Impetus_unlock3 = class({})

function modifier_Advanced_Impetus_unlock3:IsDebuff()			return false end
function modifier_Advanced_Impetus_unlock3:IsHidden() 			return true end
function modifier_Advanced_Impetus_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Impetus_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Impetus_unlock3:RemoveOnDeath() return false end


modifier_Advanced_Impetus_unlock3_target = class({})

function modifier_Advanced_Impetus_unlock3_target:IsDebuff()			return false end
function modifier_Advanced_Impetus_unlock3_target:IsHidden() 			return true end
function modifier_Advanced_Impetus_unlock3_target:IsPurgable() 		return false end
function modifier_Advanced_Impetus_unlock3_target:IsPurgeException() 	return false end
function modifier_Advanced_Impetus_unlock3_target:RemoveOnDeath() return false end
function modifier_Advanced_Impetus_unlock3_target:OnCreated(keys)
	if IsServer() then
		self.target = EntIndexToHScript(keys.target)
	end
end
