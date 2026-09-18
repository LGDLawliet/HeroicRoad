heroTalent_npc_dota_hero_weaver = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_weaver", "heroTalent/heroTalent_npc_dota_hero_weaver", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_weaver_effect", "heroTalent/heroTalent_npc_dota_hero_weaver", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_weaver:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_weaver"
end






function heroTalent_npc_dota_hero_weaver:OnProjectileHit_ExtraData(target, location, keys)
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




modifier_heroTalent_npc_dota_hero_weaver = class({})

function modifier_heroTalent_npc_dota_hero_weaver:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_weaver:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_weaver:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_weaver:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_weaver:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_weaver:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end
-- function modifier_heroTalent_npc_dota_hero_weaver:OnCreated(keys)
-- 	self.advanced_level = 1
-- end
function modifier_heroTalent_npc_dota_hero_weaver:OnAttack(keys)
	if not IsServer() then return end

	if self:GetParent():IsDisableSplit() then  --分裂箭无效化
		return    
	end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	

		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() then
			return
		end
		self:GetAbility():UseResources(true, true, true,true)
		local info = 
		{
			Target = keys.target,
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = caster:GetRangedProjectileName(),
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
		local count = self:GetAbility():GetSpecialValueFor("count")-1
		Timers:CreateTimer(0.1, function()
			count = count - 1
			ProjectileManager:CreateTrackingProjectile(info)
			if count<=0 then
				return nil
			end
			return 0.1
			
		end)
		
		
		
		
	end
end

