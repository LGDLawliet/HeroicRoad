heroTalent_npc_dota_hero_juggernaut_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_3", "heroTalent/heroTalent_npc_dota_hero_juggernaut_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_3_effect", "heroTalent/heroTalent_npc_dota_hero_juggernaut_3", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_juggernaut_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/jugg_3/shockwave/effect.vpcf", context )


end

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_juggernaut_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_juggernaut_3"
end

function heroTalent_npc_dota_hero_juggernaut_3:Spawn()
	self.active_proj = {}
end


function heroTalent_npc_dota_hero_juggernaut_3:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		if not target  then
			if self.active_proj[handle] then
				self.active_proj[handle] = nil
			end
			
			return true
		end

		if self.active_proj[handle].count<=0 then
			-- self.active_proj[handle] = nil
			return false
		end
		local plus_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*1.5
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage =plus_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
		target:EmitSound("Hero_Juggernaut.OmniSlash")
		self.active_proj[handle].count = self.active_proj[handle].count - 1
		

	end
end











modifier_heroTalent_npc_dota_hero_juggernaut_3 = class({})

function modifier_heroTalent_npc_dota_hero_juggernaut_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_juggernaut_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_juggernaut_3:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end
-- function modifier_heroTalent_npc_dota_hero_juggernaut_3:OnCreated(keys)
-- 	self.advanced_level = 1
-- end
function modifier_heroTalent_npc_dota_hero_juggernaut_3:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() and self:GetCaster():GetRandomEffect(15,INT_TYPE,1)>=RandomInt(1, 100) then	

		local caster = self:GetCaster()
		if not caster:IsApplyModifier() then
			return
		end
		local ability = self:GetAbility()
		if not ability:IsCooldownReady() then
			return
		end

		if 20>=RandomInt(1, 100) then
			ability:StartCooldown(0.3)
		end
		local caster = self:GetCaster()
	
	
		-- load data
		local name = "particles/rebuild/talent/jugg_3/shockwave/effect.vpcf"
		local distance = math.max(CalculateDistance(caster,keys.target),caster:Script_GetAttackRange()*2,700)
		local radius = 200
		local speed = 2500
	
		local point = keys.target:GetOrigin()
		if point==caster:GetOrigin() then
			point = point + caster:GetForwardVector()
		end
		local direction = keys.target:GetOrigin() - caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
	

		-- create projectile
		local info = {
			Source = caster,
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			
			bDeleteOnHit = true,
			
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			
			EffectName = name,
			fDistance = distance,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			ExtraData = {}   --额外的数据
		}
		local particle = ProjectileManager:CreateLinearProjectile(info)
		ability.active_proj[particle] = {
			count = 8,
		}
		-- play effects
		local sound_cast = "Hero_Juggernaut.BladeDance"
		EmitSoundOn( sound_cast, caster )

	
	end
end

