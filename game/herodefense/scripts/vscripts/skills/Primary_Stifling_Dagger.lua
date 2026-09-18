Primary_Stifling_Dagger = class({})

LinkLuaModifier("modifier_Primary_Stifling_Dagger_slow", "skills/Primary_Stifling_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Stifling_Dagger_atk", "skills/Primary_Stifling_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ninja_gear_vision", "items/item_hd_ninja_gear", LUA_MODIFIER_MOTION_NONE)

function Primary_Stifling_Dagger:IsHiddenWhenStolen() 	return false end
function Primary_Stifling_Dagger:IsRefreshable() 			return true end
function Primary_Stifling_Dagger:IsStealable() 			return true end
function Primary_Stifling_Dagger:IsNetherWardStealable()	return true end

function Primary_Stifling_Dagger:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then
		return
	end

	local daggers = self:GetSpecialValueFor("dagger_count")
	for i=1,daggers do
		local info = 
		{
			Target = target,
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

	
	
end
--添加视野用的，忽略
-- function Primary_Stifling_Dagger:OnProjectileThink(location)  --正在移动  添加视野
-- 	AddFOWViewer(self:GetCaster():GetTeamNumber(), location, 450, FrameTime(), false)
-- end

function Primary_Stifling_Dagger:OnProjectileHit_ExtraData(target, location, keys)
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
	local newmodifier = caster:AddNewModifier(caster, self, "modifier_Primary_Stifling_Dagger_atk", {})
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
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

	--caster:RemoveModifierByName("modifier_Primary_Stifling_Dagger_atk")
	newmodifier:SafeDestroy()
	if not target:IsMagicImmune() then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_Primary_Stifling_Dagger_slow", {duration = self:GetSpecialValueFor("slow_duration")*StatusResistance})
	end
end

--------------------------------------------------------------------------

modifier_Primary_Stifling_Dagger_atk = class({})

function modifier_Primary_Stifling_Dagger_atk:IsDebuff()			return false end
function modifier_Primary_Stifling_Dagger_atk:IsHidden() 			return true end
function modifier_Primary_Stifling_Dagger_atk:IsPurgable() 			return false end
function modifier_Primary_Stifling_Dagger_atk:IsPurgeException() 	return false end  
function modifier_Primary_Stifling_Dagger_atk:DeclareFunctions() return {
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
 } end
function modifier_Primary_Stifling_Dagger_atk:GetModifierDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_Primary_Stifling_Dagger_atk:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage_con") end

-------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_Primary_Stifling_Dagger_slow = class({})

function modifier_Primary_Stifling_Dagger_slow:IsDebuff()			return true end
function modifier_Primary_Stifling_Dagger_slow:IsHidden() 			return false end
function modifier_Primary_Stifling_Dagger_slow:IsPurgable() 		return true end
function modifier_Primary_Stifling_Dagger_slow:IsPurgeException() 	return true end
function modifier_Primary_Stifling_Dagger_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Primary_Stifling_Dagger_slow:GetModifierMoveSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Primary_Stifling_Dagger_slow:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf" end


 