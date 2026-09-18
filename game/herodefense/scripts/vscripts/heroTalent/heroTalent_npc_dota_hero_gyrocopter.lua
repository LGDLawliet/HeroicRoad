heroTalent_npc_dota_hero_gyrocopter = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_gyrocopter", "heroTalent/heroTalent_npc_dota_hero_gyrocopter", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_gyrocopter_effect", "heroTalent/heroTalent_npc_dota_hero_gyrocopter", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_gyrocopter:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_gyrocopter"
end

function heroTalent_npc_dota_hero_gyrocopter:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)

	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

end



modifier_heroTalent_npc_dota_hero_gyrocopter = class({})

function modifier_heroTalent_npc_dota_hero_gyrocopter:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.timer = 0
		self.EffectName = self:GetCaster():GetRangedProjectileName()
		self:StartIntervalThink(1/self:GetAbility():GetSpecialValueFor("speed_interval"))	
	end
end


function modifier_heroTalent_npc_dota_hero_gyrocopter:OnIntervalThink()
	self.timer = self.timer + 1/self:GetAbility():GetSpecialValueFor("speed_interval")
	if self.timer>=self:GetAbility():GetSpecialValueFor("time") then
		self.timer = self.timer -self:GetAbility():GetSpecialValueFor("time")
		self:SetStackCount(math.min(self:GetStackCount()+1,self:GetAbility():GetSpecialValueFor("max_count")))
	end
	local caster = self:GetCaster()

	if caster:IsAlive() and self:GetStackCount()>=1 and caster:IsRangedAttacker() and self:GetAbility():GetAutoCastState() then

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _, unit in pairs(units) do
			if not unit:IsAttackImmune() then
				local info = 
				{
					Target = unit,
					Source = caster,
					Ability = self:GetAbility(),	
					EffectName =self.EffectName,
					iMoveSpeed = 1200,
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
				ProjectileManager:CreateTrackingProjectile(info)
				self:DecrementStackCount()
				break
			end
		end
	end

end
