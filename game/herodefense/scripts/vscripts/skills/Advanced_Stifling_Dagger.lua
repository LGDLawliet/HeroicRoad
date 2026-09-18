--特效优化 √
Advanced_Stifling_Dagger = class({})

LinkLuaModifier("modifier_Advanced_Stifling_Dagger_slow", "skills/Advanced_Stifling_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Stifling_Dagger_atk", "skills/Advanced_Stifling_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ninja_gear_vision", "items/item_hd_ninja_gear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Stifling_Dagger_Unlock1_effect", "skills/Advanced_Stifling_Dagger", LUA_MODIFIER_MOTION_NONE)

function Advanced_Stifling_Dagger:CheckKV(key)
	local table = {
		bonus_damage=0.5,
		bonus_damage_con=6,


	}
	local value = table[key] or -1
	return value


end
function Advanced_Stifling_Dagger:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/stifling_dagger/dagger.vpcf", context )

	

end

function Advanced_Stifling_Dagger:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Stifling_Dagger_Unlock1_effect", {})
	return true
end
function Advanced_Stifling_Dagger:UnlockSecondCore(key)
	return true
end
function Advanced_Stifling_Dagger:UnlockThirdCore(key)
	return true
end

function Advanced_Stifling_Dagger:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		elseif coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		end
		
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AOE
end

function Advanced_Stifling_Dagger:IsHiddenWhenStolen() 	return false end
function Advanced_Stifling_Dagger:IsRefreshable() 			return true end
function Advanced_Stifling_Dagger:IsStealable() 			return true end
function Advanced_Stifling_Dagger:IsNetherWardStealable()	return true end

function Advanced_Stifling_Dagger:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
	local daggers = self:GetSpecialValueFor("dagger_count")
	--LV10解锁连掷+
	if self.advanced_level>=10 then
		daggers = daggers+1
	end
	local enemy_count = 0
	if self.unlock2 then
		local pos = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		if #enemies==1 then
			daggers = (daggers+RandomInt(1, 2))*2

		end
		for _, enemy in pairs(enemies) do
	
			for i=1,daggers do
				local vPos = enemy:GetAbsOrigin()
				vPos.x = vPos.x + RandomInt(-500,500)
				vPos.y = vPos.y + RandomInt(-500,500)
				vPos.z = vPos.z +2000
				local info = 
				{
					Target = enemy,
					-- Source = caster,
					Ability = self,	
					EffectName = "particles/rebuild/spell/stifling_dagger/dagger.vpcf",
					iMoveSpeed =math.max(2000-i*200,400),
					vSourceLoc = vPos,
					bDrawsOnMinimap = false,  --？？
					bDodgeable = true,   --可躲闪
					bIsAttack = false,   --攻击效果
					bVisibleToEnemies = true,  --对敌人可视
					bReplaceExisting = false, --替换现有的
					flExpireTime = GameRules:GetGameTime() + 10, --存在时间
					bProvidesVision = false, --提供视野
					ExtraData = {hit = i}   --额外的数据
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
			enemy_count = enemy_count +1
		 
			if enemy_count >= 12 then
				break
			end
		end
	else
		local target = self:GetCursorTarget()
		if target:TriggerSpellAbsorb(self) then
			return
		end
	
		local pos = target:GetAbsOrigin()
	
		local effect_number = 3
		--LV5解锁匕首影分身+
		if self.advanced_level>=5 then
			effect_number = effect_number+2
		end
	

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		
		if self.advanced_level>=15 and #enemies==1 then
			daggers = daggers+RandomInt(1, 2)
		end
		for _, enemy in pairs(enemies) do
			for i=1,daggers do
				local info = 
				{
					Target = enemy,
					Source = caster,
					Ability = self,	
					EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
					iMoveSpeed = self:GetSpecialValueFor("dagger_speed")-i*200,
					vSourceLoc = caster:GetAbsOrigin(),
					bDrawsOnMinimap = false,  --？？
					bDodgeable = true,   --可躲闪
					bIsAttack = false,   --攻击效果
					bVisibleToEnemies = true,  --对敌人可视
					bReplaceExisting = false, --替换现有的
					flExpireTime = GameRules:GetGameTime() + 10, --存在时间
					bProvidesVision = false, --提供视野
					ExtraData = {hit = i}   --额外的数据
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
			enemy_count = enemy_count +1
		 
			if enemy_count >= effect_number then
				break
			end
		end

	end

	
	
end



function Advanced_Stifling_Dagger:GetAOERadius()
	return 500
end

function Advanced_Stifling_Dagger:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then
		return
	end
	if not target then
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	--AddFOWViewer(self:GetCaster():GetTeamNumber(), location, 450, self:GetSpecialValueFor("slow_duration"), false)
	local caster = self:GetCaster()
--	local bonus_damage = self:GetSpecialValueFor("bonus_damage") * self:GetCaster():GetAverageTrueAttackDamage(nil) *0.01
	local newmodifier = caster:AddNewModifier(caster, self, "modifier_Advanced_Stifling_Dagger_atk", {})


	
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =0,
		iDisableSplit = 0,

	}
	if not self.unlock3 then
		modifier_keys.iDisableCleave = 1
		modifier_keys.iDisableSplit = 1
	end
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	local equip_sp = caster:FindModifierByName("modifier_item_hd_ninja_gear")
	if equip_sp then
		target:AddNewModifier(caster, self, "modifier_item_hd_ninja_gear_vision", {duration = equip_sp:GetAbility():GetSpecialValueFor("vision_duration")})
		local newCooldown = self:GetCooldownTimeRemaining() - equip_sp:GetAbility():GetSpecialValueFor("cd_reduce")
		self:EndCooldown()
		if newCooldown>0 then
			self:StartCooldown(newCooldown)
		end
	end
	local talent5 = caster:FindAbilityByName("heroTalent_npc_dota_hero_phantom_assassin_5")
	if talent5 then
		talent5:Trigger(target)
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	--LV20解锁窒息
	if self.advanced_level>=20 and not target:IsAlive() then
		local cooldown = self:GetCooldownTimeRemaining()*0.85
		self:EndCooldown()
		self:StartCooldown(cooldown)
	end
	--caster:RemoveModifierByName("modifier_Advanced_Stifling_Dagger_atk")
	if newmodifier then
		newmodifier:SafeDestroy()
	end
	
	if not target:IsMagicImmune() then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_Advanced_Stifling_Dagger_slow", {duration = self:GetSpecialValueFor("slow_duration")*StatusResistance})
	end
end

--------------------------------------------------------------------------

modifier_Advanced_Stifling_Dagger_atk = class({})

function modifier_Advanced_Stifling_Dagger_atk:IsDebuff()			return false end
function modifier_Advanced_Stifling_Dagger_atk:IsHidden() 			return true end
function modifier_Advanced_Stifling_Dagger_atk:IsPurgable() 			return false end
function modifier_Advanced_Stifling_Dagger_atk:IsPurgeException() 	return false end  
function modifier_Advanced_Stifling_Dagger_atk:DeclareFunctions() return {
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
 } end

function modifier_Advanced_Stifling_Dagger_atk:GetModifierDamageOutgoing_Percentage() 	return self.bonus_damage end
function modifier_Advanced_Stifling_Dagger_atk:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.bonus_damage =ability:GetSpecialValueFor("bonus_damage")
		self.bonus_damage_con = ability:GetSpecialValueFor("bonus_damage_con")
	end
end

function modifier_Advanced_Stifling_Dagger_atk:GetModifierPreAttack_BonusDamage() return self.bonus_damage_con end


-------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_Advanced_Stifling_Dagger_slow = class({})

function modifier_Advanced_Stifling_Dagger_slow:IsDebuff()			return true end
function modifier_Advanced_Stifling_Dagger_slow:IsHidden() 			return false end
function modifier_Advanced_Stifling_Dagger_slow:IsPurgable() 		return true end
function modifier_Advanced_Stifling_Dagger_slow:IsPurgeException() 	return true end
function modifier_Advanced_Stifling_Dagger_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Stifling_Dagger_slow:GetModifierMoveSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Advanced_Stifling_Dagger_slow:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf" end

function modifier_Advanced_Stifling_Dagger_slow:CheckState()
	--LV20解锁窒息
	-- if IsClient() then
	-- 	return
	-- end
	if self:GetAbility():GetSpecialValueFor("advanced_level")<20 then
		return
	end

	local state = {[MODIFIER_STATE_SILENCED] = true}


	return state
end
 





modifier_Advanced_Stifling_Dagger_Unlock1_effect = class({})


function modifier_Advanced_Stifling_Dagger_Unlock1_effect:IsHidden()	return true end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:IsDebuff()	return false end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:IsStunDebuff()	return false end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:RemoveOnDeath()	return false end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:DestroyOnExpire()	return false end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:IsPurgable() 		return false end
function modifier_Advanced_Stifling_Dagger_Unlock1_effect:IsPurgeException() 	return false end

function modifier_Advanced_Stifling_Dagger_Unlock1_effect:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Stifling_Dagger_Unlock1_effect:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if self:GetCaster():GetRandomEffect(5,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end
		local cooldown = ability:GetCooldownTimeRemaining()
		if cooldown>=10 then
			return
		end
		ability:StartCooldown(cooldown+2)
		caster:SetCursorCastTarget(keys.target)

		ability:OnSpellStart()



				
		
	end

	
end