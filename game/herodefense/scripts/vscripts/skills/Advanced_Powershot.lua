--特效优化 √
Advanced_Powershot= class({})
LinkLuaModifier("modifier_Advanced_Powershot_slow", "skills/Advanced_Powershot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Powershot_move", "skills/Advanced_Powershot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Powershot_armor", "skills/Advanced_Powershot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Powershot_lv20", "skills/Advanced_Powershot", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Powershot_root", "skills/Advanced_Powershot", LUA_MODIFIER_MOTION_NONE)
function Advanced_Powershot:CheckKV(key)
	local table = {

	


		basic_damage = 10,
		attack_damage = 0.1,




	}
	local value = table[key] or -1
	return value

end

function Advanced_Powershot:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Powershot:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Powershot:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blade_Fury_unlock3",{})
	return true

end



function Advanced_Powershot:IsHiddenWhenStolen()           return false end
function Advanced_Powershot:IsStealable()                  return true end
function Advanced_Powershot:IsNetherWardStealable()        return true end
function Advanced_Powershot:IsRefreshable() 			   return true end
function Advanced_Powershot:GetIntrinsicModifierName() return "modifier_Advanced_Powershot_lv20" end
function Advanced_Powershot:GetCooldown(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 5
		end	
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_Powershot:GetChannelTime()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 5
		end	
	end
	return 0.2
end
function Advanced_Powershot:GetCastRange()
	if IsClient() then		
		return self:GetSpecialValueFor("range")
	else					
		return 30000
	end
end

function Advanced_Powershot:OnSpellStart()
	 local caster = self:GetCaster()
	 local caster_pos = caster:GetAbsOrigin()
	-- 预防目标位置等于自身位置导致的bug
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end
	--  CreateUnitByName( "npc_creater_spawner", caster_pos , true, nil, nil, caster:GetTeamNumber())
	 caster:EmitSound("Ability.PowershotPull")
	--  print(self:GetCursorPosition())
     self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/powershot/channel_effect/effect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
     ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1",caster_pos, false)
     ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack", caster_pos, false)
     self.Effect="particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"



end

function Advanced_Powershot:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	self.distance=self:GetSpecialValueFor("range")+caster:GetCastRangeBonus()
	self.distance = math.max(self.distance,100)
	--LV10解锁疾风+
	if self.advanced_level>=10 then
		self.distance = self.distance*2
	end
	self.speed=3000
	self.radius=250
	-- 预防目标位置等于自身位置导致的bug
	local pos = self:GetCursorPosition()  
	if pos == self:GetCaster():GetAbsOrigin() then
		pos = pos + self:GetCaster():GetForwardVector()
	end
	local curpos = pos

	local ability = self
	
	local caster_pos = caster:GetAbsOrigin()
	
	local dir=TG_Direction(curpos,caster_pos)
    dir.z=0
    EmitSoundOn( "Ability.Powershot", caster )  

	local projectileTable =
	{
		EffectName =self.Effect,
		Ability = ability,
		vSpawnOrigin =caster:GetAbsOrigin(),
		vVelocity =dir*self.speed,
		fDistance =self.distance,
		fStartRadius = self.radius,
		fEndRadius = self.radius,
		Source = caster,
		TreeBehavior = PROJECTILES_NOTHING,
		bCutTrees = true,
		bTreeFullCollision = false,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_TREE,
		bProvidesVision = true,

	}

	if self.unlock3 then

		local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
		projectileTable.ExtraData =        {
			damage_index = channel_pct*5
		}
		local index = math.max(1,channel_pct*0.4)
		projectileTable.fStartRadius = projectileTable.fStartRadius * index
		projectileTable.fEndRadius = projectileTable.fEndRadius * index
		if channel_pct>=0.5 then
			projectileTable.EffectName = "particles/rebuild/spell/power_shot/unlock3/effect.vpcf"
		end
	end
	
	

	local projectile = ProjectileManager:CreateLinearProjectile( projectileTable )

	if self.unlock2 then
		for i = 1, 6, 1 do
			ProjectileManager:CreateLinearProjectile( projectileTable )
		end
	end
	if self.particle~=nil then 

		ParticleManager:DestroyParticle(self.particle, false)
		
	
		self.particle=nil
	end
end


function Advanced_Powershot:OnProjectileHit_ExtraData(target, location, ExtraData)
	
	if target~=nil then
		local ability = self
		local caster = ability:GetCaster()
		if not target:IsMagicImmune() then
			local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_ti6_powershot_dmg.vpcf", PATTACH_ABSORIGIN, target)
			ParticleManager:ReleaseParticleIndex( particle )
			local damage = 0
			local modifier
			if self.advanced_level>=15 then
				local armor = target:GetPhysicalArmorValue(false)
				modifier = target:AddNewModifier(caster, ability, "modifier_Advanced_Powershot_armor", {duration=0.15,index = armor}) 
				
				damage= (ability:GetSpecialValueFor( "basic_damage" ) + caster:GetAverageTrueAttackDamage(nil)*(ability:GetSpecialValueFor("attack_damage")))
			else 
				damage= (ability:GetSpecialValueFor( "basic_damage" )+ caster:GetBaseDamageMax()*(ability:GetSpecialValueFor("attack_damage")))
			end
			if ExtraData.damage_index then
				damage = damage *ExtraData.damage_index
			end
			-- local data = self.projectiles[handle]

			local damageTable = {
				victim = target,
				attacker = caster,
				damage =  damage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
				ability = ability,
				}
			ApplyDamage(damageTable)
			if not ExtraData.NoAttack then
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
				caster:PerformAttack(target, false, true, true, true, false, false, true)--对一单位执行攻击。
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			end
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, ability, "modifier_Advanced_Powershot_slow", {duration=ability:GetSpecialValueFor("duration")*StatusResistance}) 
			if self.unlock1 then
				target:AddNewModifier(caster, ability, "modifier_Advanced_Powershot_root", {duration=1}) 
			else
				target:AddNewModifier(caster, ability, "modifier_Advanced_Powershot_move", {duration=0.15}) 
			end
			
			if modifier then
				modifier:SafeDestroy()
			end
			if self.unlock2 and not ExtraData.NoAttack then
				-- print("")
				return true
			end
		end						
	end
end



function Advanced_Powershot:OnProjectileThink_ExtraData(vLocation, table) GridNav:DestroyTreesAroundPoint(vLocation,300,false) end













modifier_Advanced_Powershot_slow = class({})
function modifier_Advanced_Powershot_slow:IsDebuff()				             return true  end
function modifier_Advanced_Powershot_slow:IsPurgable() 			                 return true end
function modifier_Advanced_Powershot_slow:IsPurgeException() 	                 return true end
function modifier_Advanced_Powershot_slow:IsHidden()				             return false end
function modifier_Advanced_Powershot_slow:DeclareFunctions()                     return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_Advanced_Powershot_slow:GetModifierMoveSpeedBonus_Percentage() return (0- self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Advanced_Powershot_slow:CheckState()
	if IsClient() then
		return
	end
	local state = {}
	if self:GetAbility().advanced_level>=5 then
		state = {
			[MODIFIER_STATE_PASSIVES_DISABLED] = true
		}
	end

	return state
end

----------------------------------------------------------------------
--击退
modifier_Advanced_Powershot_move = class({})

function modifier_Advanced_Powershot_move:IsDebuff()			return false end
function modifier_Advanced_Powershot_move:IsHidden() 			return true end
function modifier_Advanced_Powershot_move:IsPurgable() 		return false end
function modifier_Advanced_Powershot_move:IsPurgeException() 	return false end
function modifier_Advanced_Powershot_move:IsMotionController() return true end
function modifier_Advanced_Powershot_move:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_Advanced_Powershot_move:OnCreated(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 2000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_Advanced_Powershot_move:OnRefresh(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 2000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_Powershot_move:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end
-------------------------------------------------------------------


modifier_Advanced_Powershot_armor = advanced_modifier({})
function modifier_Advanced_Powershot_armor:IsDebuff()				             return true  end
function modifier_Advanced_Powershot_armor:IsPurgable() 			                 return true end
function modifier_Advanced_Powershot_armor:IsPurgeException() 	                 return true end
function modifier_Advanced_Powershot_armor:IsHidden()				             return false end
function modifier_Advanced_Powershot_armor:OnCreated(keys)
	if IsServer() then
		self.armor = -keys.index*0.5 or 0
	end
end

function modifier_Advanced_Powershot_armor:Advanced_GetModifierPhysicalArmorBonus() return self.armor end




function modifier_Advanced_Powershot_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end



modifier_Advanced_Powershot_lv20 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Powershot_lv20:IsDebuff()			return false end
function modifier_Advanced_Powershot_lv20:IsHidden() 			return true end
function modifier_Advanced_Powershot_lv20:IsPurgable() 			return false end
function modifier_Advanced_Powershot_lv20:IsPurgeException() 	return false end
function modifier_Advanced_Powershot_lv20:OnRemoved() end
function modifier_Advanced_Powershot_lv20:OnDestroy() end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Powershot_lv20:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Powershot_lv20:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if ability.advanced_level>=20 then
		local chance = 2
		local Addcooldown = 5
		if ability.unlock1 then
			chance = 5
			Addcooldown = 2.5
			
		end
		if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
			local cooldown = ability:GetCooldownTimeRemaining()
			if cooldown>=40 then
				return
			end
			ability:StartCooldown(cooldown+Addcooldown)
			local caster = keys.attacker 
			local pos = keys.target:GetAbsOrigin()
			caster:SetCursorPosition(pos)
			self.distance=ability:GetSpecialValueFor("range")+caster:GetCastRangeBonus()
			self.distance = math.max(self.distance,100)
			--LV10解锁疾风+
			if ability.advanced_level>=10 then
				self.distance = self.distance*2
			end
			local speed=3000
			local radius=250
			-- 预防目标位置等于自身位置导致的bug
			if pos == self:GetCaster():GetAbsOrigin() then
				pos = pos + self:GetCaster():GetForwardVector()
			end
			local curpos = pos

			local caster = ability:GetCaster()
			local caster_pos = caster:GetAbsOrigin()
			
			local dir=TG_Direction(curpos,caster_pos)
			dir.z=0
			EmitSoundOn( "Ability.Powershot", caster )  
			local projectileTable =
			{
				EffectName ="particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
				Ability = ability,
				vSpawnOrigin =caster:GetAbsOrigin(),
				vVelocity =dir*speed,
				fDistance =self.distance,
				fStartRadius = radius,
				fEndRadius =radius,
				Source = caster,
				TreeBehavior = PROJECTILES_NOTHING,
				bCutTrees = true,
				bTreeFullCollision = false,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_TREE,
				bProvidesVision = true,
				ExtraData =        {
					NoAttack = true
				}
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )


					
			
		end
	end

	
end



modifier_Advanced_Powershot_root					= class({})

function modifier_Advanced_Powershot_root:IsDebuff()			return false end
function modifier_Advanced_Powershot_root:IsHidden() 			return true end
function modifier_Advanced_Powershot_root:IsPurgable() 		return true end
function modifier_Advanced_Powershot_root:IsPurgeException() 	return false end
-- function modifier_Advanced_Powershot_move:GetPriority() return 500 end
function modifier_Advanced_Powershot_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		-- [MODIFIER_STATE_DISARMED] = true
	}


	return state
end