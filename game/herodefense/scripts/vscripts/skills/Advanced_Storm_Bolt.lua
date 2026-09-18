--特效优化 √
Advanced_Storm_Bolt = class({})

LinkLuaModifier("modifier_Advanced_Storm_Bolt_caster", "skills/Advanced_Storm_Bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Storm_Bolt_buff", "skills/Advanced_Storm_Bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Storm_Bolt_unlock1", "skills/Advanced_Storm_Bolt", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Storm_Bolt_unlock3", "skills/Advanced_Storm_Bolt", LUA_MODIFIER_MOTION_NONE)

require("internal/timers")
function  Advanced_Storm_Bolt:CheckKV(key)
	local table = {
		damage=10,
		bonus_damage=0.1,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Storm_Bolt:UnlockFirstCore(key)
    local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Storm_Bolt_unlock1",{})
	return true
end
function Advanced_Storm_Bolt:UnlockSecondCore(key)
	return true
end
function Advanced_Storm_Bolt:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Storm_Bolt_unlock3",{})
	return true
end

function Advanced_Storm_Bolt:GetBehavior()
	if self:GetUnlock(1)==1 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Storm_Bolt:IsHiddenWhenStolen() 		return false end
function Advanced_Storm_Bolt:IsRefreshable() 			return true end
function Advanced_Storm_Bolt:IsStealable() 			return true end
function Advanced_Storm_Bolt:IsNetherWardStealable()	return true end
function Advanced_Storm_Bolt:GetAOERadius() 
	local radius =  self:GetSpecialValueFor("radius") 
	if self:GetUnlock(2)==2 then
		radius = radius * 2
	end
	return radius
end
function Advanced_Storm_Bolt:GetCooldown(iLevel)
	
	if self:GetSpecialValueFor("advanced_level")>=15 then
		if self:GetUnlock(2)==2 then
			return 4.5
		end
		return 8
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function Advanced_Storm_Bolt:GetCastRange(vLocation, hTarget)
	local advanced_level =self:GetSpecialValueFor("advanced_level")
	--LV15解锁风暴降临
	if advanced_level>=15 then
		return 1500
	end
	return 800
end



function Advanced_Storm_Bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Sven.StormBolt")
	caster:AddNewModifier(caster, self, "modifier_Advanced_Storm_Bolt_caster", {})
	local duration = self:GetSpecialValueFor("delay")
	--LV10解锁天降正义+
	if self.advanced_level>=10 then
		duration = 14
		if self.unlock3 then
			local modifier = caster:FindAllModifiersByName("modifier_Advanced_Storm_Bolt_buff")
			if #modifier<5 then
				duration = 30
			else 
				duration = 5
			end
		end
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_Storm_Bolt_buff", {duration = duration})
	local pfxname =  "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
	local speed = self:GetSpecialValueFor("speed")
	--Lv15解锁风暴降临
	if self.advanced_level>=15 then
		speed = speed*2
	end
	if self.advanced_level >= 20 then
		caster:Purge(false, true, false, true, true) --强驱散
	end
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfxname,
		iMoveSpeed = speed,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {main = 1}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
--
function Advanced_Storm_Bolt:OnProjectileHit_ExtraData(target, location, extraData)
	if not IsServer() then
		return
	end
	local hTarget = target or self:GetCaster()
	local caster = self:GetCaster()
	if self.unlock1 then
		self:Unlock1Hit(hTarget)
		return
	end
	if self.unlock2 then
		self:Unlock2Hit(hTarget,extraData)
		return
	end

	
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")
	if hTarget ~= caster then
		if hTarget:TriggerSpellAbsorb(self) or hTarget:IsMagicImmune() then
			caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
			return
		end
		local radius = self:GetSpecialValueFor("radius")
		local dmg = self:GetSpecialValueFor("damage") +caster:GetAverageTrueAttackDamage(nil)*(self:GetSpecialValueFor("bonus_damage"))
		if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        	dmg = dmg*0.27
    	end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local double_attack_chance = 0
		local disableAttackEffect = true
		--LV5解锁暴风+
		if self.advanced_level>=5 then
			double_attack_chance = 50
			if caster:GetHealthPercent() <= 50 then
				double_attack_chance = 100
			end
			--LV20解锁暴风++
			if self.advanced_level>=20 then
				double_attack_chance = 100
				--disableAttackEffect = false
			end
		end

		for _, enemy in pairs(enemies) do
						
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = dmg,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)
			--攻击目标一次
			
			Timers(RandomFloat(0, 0.2), function()
				if self and not self:IsNull() then
				

					local caster = self:GetCaster()
					local modifier_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave =0,
						iDisableSplit = 0,
				
					}
					if disableAttackEffect then
						modifier_keys.iDisableCleave = 1
						modifier_keys.iDisableSplit = 1
					end
					local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	
					
					if enemy:GetHealth()>0 then
						caster:PerformAttack(enemy, false, true, true, false, true, false, true)
						--LV5解锁暴风+
						if enemy:GetHealth()>0 and self:GetCaster():GetRandomEffect(double_attack_chance,INT_TYPE,1)  >=RandomInt(1, 100) then
							caster:PerformAttack(enemy, false, true, true, false, true, false, true)
						end
					end	
					--LV15解锁风暴降临
					if self.advanced_level>=20 then
						enemy:Purge(true, false, false, true, true) --强驱散
					end
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end
					
				end

			end)	

		end

		

	end
	FindClearSpaceForUnit(caster, hTarget:GetAbsOrigin(), true)
	caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
	caster:SetAttacking(hTarget)
end

function Advanced_Storm_Bolt:Unlock1Hit(hTarget)
		if not IsServer() then
			return
		end
	local caster = self:GetCaster()

	
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")
	if hTarget ~= caster then
		if hTarget:TriggerSpellAbsorb(self) or hTarget:IsMagicImmune() then
			caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
			return
		end

		local dmg = self:GetSpecialValueFor("damage") +caster:GetAverageTrueAttackDamage(nil)*(self:GetSpecialValueFor("bonus_damage"))
		if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        	dmg = dmg*0.27
    	end
		--local disableAttackEffect = false


		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = hTarget:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		hTarget:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
		local damageTable = {
							victim = hTarget,
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		--攻击目标一次
		
		Timers(RandomFloat(0, 0.2), function()
			if self and not self:IsNull() then
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
				if disableAttackEffect then
					modifier_keys.iDisableCleave = 1
					modifier_keys.iDisableSplit = 1
				end
				local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
				if hTarget:GetHealth()>0 then
					caster:PerformAttack(hTarget, false, true, true, false, true, false, true)
					caster:PerformAttack(hTarget, false, true, true, false, true, false, true)
				end	
				hTarget:Purge(true, false, false, true, true) --强驱散
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				
			end

		end)

		

	end
	
	caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
	caster:SetAttacking(hTarget)
end

function Advanced_Storm_Bolt:Unlock2Hit(hTarget,extraData)
		if not IsServer() then
			return
		end
	local caster = self:GetCaster()

	FindClearSpaceForUnit(caster, hTarget:GetAbsOrigin(), true)
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")
	if hTarget ~= caster then
		if hTarget:TriggerSpellAbsorb(self) or hTarget:IsMagicImmune() then
			caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
			return
		end
		if extraData.main and extraData.main==1 then
			local radius = self:GetSpecialValueFor("radius")*2
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local info = 
			{
				Target = hTarget,
				-- Source = caster,
				Ability = self,	
				EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
				iMoveSpeed = RandomInt(550, 1500),
				vSourceLoc = caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
				-- ExtraData = {main = 1}   --额外的数据
			}
			
			for i, unit in ipairs(enemies) do
				if unit~=hTarget then
					info.Source = unit
					-- info.Target = hTarget
					ProjectileManager:CreateTrackingProjectile(info)
				end
				if i>=21 then
					break
				end
			end
		end

		local dmg = self:GetSpecialValueFor("damage") +caster:GetAverageTrueAttackDamage(nil)*(self:GetSpecialValueFor("bonus_damage"))
		if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        	dmg = dmg*0.27
    	end
		--local disableAttackEffect = false


		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance =  hTarget:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		hTarget:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
		local damageTable = {
							victim = hTarget,
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		--攻击目标一次
		
		Timers(RandomFloat(0, 0.2), function()
			if self and not self:IsNull() then
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
				if disableAttackEffect then
					modifier_keys.iDisableCleave = 1
					modifier_keys.iDisableSplit = 1
				end
				local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
				if hTarget:GetHealth()>0 then
					caster:PerformAttack(hTarget, true, true, true, false, true, false, true)
					caster:PerformAttack(hTarget, true, true, true, false, true, false, true)
				end	
				hTarget:Purge(true, false, false, true, true) --强驱散
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				
			end

		end)

		

	end
	
	caster:RemoveModifierByName("modifier_Advanced_Storm_Bolt_caster")
	caster:SetAttacking(hTarget)
end


modifier_Advanced_Storm_Bolt_caster = class({})

function modifier_Advanced_Storm_Bolt_caster:IsDebuff()			return false end
function modifier_Advanced_Storm_Bolt_caster:IsHidden() 		return true end
function modifier_Advanced_Storm_Bolt_caster:IsPurgable() 		return false end
function modifier_Advanced_Storm_Bolt_caster:IsPurgeException() return false end
function modifier_Advanced_Storm_Bolt_caster:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_Advanced_Storm_Bolt_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_Advanced_Storm_Bolt_caster:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveNoDraw()
	end
end





modifier_Advanced_Storm_Bolt_buff = advanced_modifier({})

function modifier_Advanced_Storm_Bolt_buff:IsDebuff()			return false end
function modifier_Advanced_Storm_Bolt_buff:IsHidden() 			return false end
function modifier_Advanced_Storm_Bolt_buff:IsPurgable() 		    return false end
function modifier_Advanced_Storm_Bolt_buff:IsPurgeException() 	return false end
function modifier_Advanced_Storm_Bolt_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Storm_Bolt_buff:OnCreated()
	self.attack = self:GetAbility():GetSpecialValueFor("attack")
end
function modifier_Advanced_Storm_Bolt_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	end
	return funcs
end
function modifier_Advanced_Storm_Bolt_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	return self.attack
end
function modifier_Advanced_Storm_Bolt_buff:Advanced_GetModifierPhysicalArmorBonus(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	return 6
end



modifier_Advanced_Storm_Bolt_unlock1 = class({})


function modifier_Advanced_Storm_Bolt_unlock1:IsHidden()	return true end
function modifier_Advanced_Storm_Bolt_unlock1:IsDebuff()	return false end
function modifier_Advanced_Storm_Bolt_unlock1:IsStunDebuff()	return false end
function modifier_Advanced_Storm_Bolt_unlock1:RemoveOnDeath()	return false end
function modifier_Advanced_Storm_Bolt_unlock1:DestroyOnExpire()	return false end
function modifier_Advanced_Storm_Bolt_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Storm_Bolt_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Storm_Bolt_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1.5)
	end
end

function modifier_Advanced_Storm_Bolt_unlock1:OnIntervalThink()
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		return
	end
	local pos = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	
	local pass = false
	local ability = self:GetAbility()
	local pfxname =  "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
	local speed = ability:GetSpecialValueFor("speed")
	local info = 
	{
		-- Target = enemy,
		-- Source = caster,
		
		Ability = ability,	
		EffectName = pfxname,
		iMoveSpeed = speed,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	for i, enemy in pairs(enemies) do

		
		info.Target = enemy
		local vPos = enemy:GetAbsOrigin()
		vPos.x = vPos.x + RandomInt(-500,500)
		vPos.y = vPos.y + RandomInt(-500,500)
		vPos.z = vPos.z +2000
		info.vSourceLoc = vPos

		ProjectileManager:CreateTrackingProjectile(info)
		pass = true
		if i>=4 then
			break
		end
		

	end
	if pass then
		caster:AddNewModifier(caster, ability, "modifier_Advanced_Storm_Bolt_buff", {duration = 2.6})
	end
	
end



