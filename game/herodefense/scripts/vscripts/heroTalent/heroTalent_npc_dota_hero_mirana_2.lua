--
heroTalent_npc_dota_hero_mirana_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_mirana_2", "heroTalent/heroTalent_npc_dota_hero_mirana_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_mirana_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_mirana_2"
end

function heroTalent_npc_dota_hero_mirana_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/mirana/mirana_2/attack_effect.vpcf" , context )
end

modifier_heroTalent_npc_dota_hero_mirana_2 = class({})

function modifier_heroTalent_npc_dota_hero_mirana_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_mirana_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_mirana_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_mirana_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_mirana_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_mirana_2:OnCreated(keys)
	if IsServer() then
		if self:GetParent():IsInDayTime() then
			self.currentTime = 1
		else
			self.currentTime = 2
		end
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_mirana_2:OnIntervalThink()
	if self:GetParent():IsInDayTime() then
		if self.currentTime==2  then
			self.currentTime = 1
			self:IncrementStackCount()
		end
		
	else
		if self.currentTime==1  then
			self.currentTime = 2
			self:IncrementStackCount()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_mirana_2:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_mirana_2:OnAttack(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() then
			return
		end
		local info = 
		{
			Target = keys.target,
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = "particles/rebuild/talent/mirana/mirana_2/attack_effect.vpcf",
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
		ProjectileManager:CreateTrackingProjectile(info)
		
		
		
		
	end
end


function modifier_heroTalent_npc_dota_hero_mirana_2:GetModifierProcAttack_BonusDamage_Physical(params) 
	if not self:GetParent():IsRealHero() then
		return 0
	end
	if IsServer() then
		local damage = self:GetParent():GetAverageTrueAttackDamage(nil)*self:OnTooltip()*0.01
		return damage
	end
	return 0
end



function modifier_heroTalent_npc_dota_hero_mirana_2:OnTooltip()
	return 35 + math.min(self:GetStackCount()*0.3,30)
end