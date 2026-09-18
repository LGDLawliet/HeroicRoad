heroTalent_npc_dota_hero_hoodwink = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_hoodwink", "heroTalent/heroTalent_npc_dota_hero_hoodwink", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_hoodwink:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_hoodwink"
end

function heroTalent_npc_dota_hero_hoodwink:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local damageTable = {
		victim = target,
		attacker =caster,
		damage = caster:GetAverageTrueAttackDamage(nil),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	local sound_target = "Hero_Hoodwink.AcornShot.Target"
	EmitSoundOn( sound_target, target )
	ApplyDamage(damageTable)

end



modifier_heroTalent_npc_dota_hero_hoodwink = class({})

function modifier_heroTalent_npc_dota_hero_hoodwink:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_hoodwink:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_hoodwink:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_hoodwink:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_hoodwink:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_hoodwink:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_hoodwink:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:SetStackCount(5)
		self:StartIntervalThink(0.1)
	end
end


function modifier_heroTalent_npc_dota_hero_hoodwink:OnIntervalThink()

	if not self:GetAbility():IsCooldownReady() or self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		return
	else	
		local parent = self:GetParent()
		local cooldown = math.max(3-parent:GetAgility()/300,1)
		self:GetAbility():StartCooldown(cooldown)
		self:SetStackCount(math.min(self:GetStackCount()+1,20))
	end
end

function modifier_heroTalent_npc_dota_hero_hoodwink:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end

function modifier_heroTalent_npc_dota_hero_hoodwink:OnAttack(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	
		if not keys.attacker:IsRangedAttacker() then
			return
		end
		if self:GetStackCount()>=1 then
			local caster = keys.attacker
			self:DecrementStackCount()
			local info = 
			{
				Target = keys.target,
				Source = caster,
				Ability = self:GetAbility(),	
				EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
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
end
