heroTalent_npc_dota_hero_gyrocopter_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_gyrocopter_2", "heroTalent/heroTalent_npc_dota_hero_gyrocopter_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_gyrocopter_2_effect", "heroTalent/heroTalent_npc_dota_hero_gyrocopter_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_gyrocopter_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_gyrocopter_2"
end






function heroTalent_npc_dota_hero_gyrocopter_2:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	local caster = self:GetCaster()
	caster.gyrocopter = true
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
	caster.gyrocopter = nil
end










modifier_heroTalent_npc_dota_hero_gyrocopter_2 = class({})

function modifier_heroTalent_npc_dota_hero_gyrocopter_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_gyrocopter_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.attack = 0
		self.timer = GameRules:GetGameTime()
		self.EffectName = self:GetCaster():GetRangedProjectileName()
		self:StartIntervalThink(0.1)	
	end
end


function modifier_heroTalent_npc_dota_hero_gyrocopter_2:OnIntervalThink()
	if GameRules:GetGameTime()>=self.timer then
		self.timer = GameRules:GetGameTime()+3
		self:SetStackCount(math.min(self:GetStackCount()+1,20))
	end
	local caster = self:GetCaster()

	if caster:IsAlive() and self:GetStackCount()>=1 and caster:IsRangedAttacker() then

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
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



function modifier_heroTalent_npc_dota_hero_gyrocopter_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end




function modifier_heroTalent_npc_dota_hero_gyrocopter_2:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			if not self:GetParent():IsApplyModifier() or self:GetParent().gyrocopter then
				return
			end
			self.attack = self.attack + 1
			if self.attack>=5 then
				self.attack = 0
				self:SetStackCount(math.min(self:GetStackCount()+1,20))
			end
		end
	end
end




