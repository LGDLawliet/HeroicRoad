heroTalent_npc_dota_hero_templar_assassin_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin_2", "heroTalent/heroTalent_npc_dota_hero_templar_assassin_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin_2_effect", "heroTalent/heroTalent_npc_dota_hero_templar_assassin_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_templar_assassin_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_templar_assassin_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_templar_assassin_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_templar_assassin_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_templar_assassin_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_templar_assassin_2" end
-- particles/rebuild/talent/templar_assassin_2/effect/shockwave/effect.vpcf
function heroTalent_npc_dota_hero_templar_assassin_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/templar_assassin_2/effect/shockwave/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_hit_sparks.vpcf", context )

	
end
function heroTalent_npc_dota_hero_templar_assassin_2:Spawn()
	self.active_proj = {}
end


function heroTalent_npc_dota_hero_templar_assassin_2:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		if not target  then
			if self.active_proj[handle] then
				self.active_proj[handle] = nil
			end
			local pfx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_hit_sparks.vpcf", PATTACH_CUSTOMORIGIN,nil)
			ParticleManager:SetParticleControl(pfx, 0,self:GetCaster():GetOrigin())
			ParticleManager:SetParticleControl(pfx, 3,location)
			ParticleManager:SetParticleControlForward(pfx, 0, CalculateDirection(location,self:GetCaster()))  --方向
			ParticleManager:ReleaseParticleIndex(pfx)
			return true
		end

		if self.active_proj[handle].count<=0 then
			-- self.active_proj[handle] = nil
			return false
		end
		if target~=self.active_proj[handle].target then
			local damageTable = {
				victim = target,
				attacker = self:GetCaster(),
				damage =self.active_proj[handle].damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self, --Optional.
			}
			ApplyDamage(damageTable)
			local pfx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_hit_sparks.vpcf", PATTACH_CUSTOMORIGIN,nil)
			ParticleManager:SetParticleControl(pfx, 0,self:GetCaster():GetOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, CalculateDirection(target,self:GetCaster()))  --方向
			ParticleManager:SetParticleControlEnt( pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(pfx)
			target:EmitSound("Hero_TemplarAssassin.PsiBlade.Resonance")
			self.active_proj[handle].count = self.active_proj[handle].count - 1
		end
	
		

	end
end







modifier_heroTalent_npc_dota_hero_templar_assassin_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_templar_assassin_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_templar_assassin_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_templar_assassin_2:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and not self:GetCaster():PassivesDisabled() and 200 or 0 end


function modifier_heroTalent_npc_dota_hero_templar_assassin_2:OnCreated(keys)
    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
        -- self:StartIntervalThink(0.3)     
    end
end
function modifier_heroTalent_npc_dota_hero_templar_assassin_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_heroTalent_npc_dota_hero_templar_assassin_2:OnAttackLanded(keys)
	if IsServer() then
		if self.caster:IsNull() then return end
		if not self:GetParent():IsRealHero() then
			return false
		end
		if keys.damage<=0 then
			return
		end
		local target = keys.target
		local attacker = keys.attacker
		if self.caster == attacker then
			if self.caster:IsInSpecialAttack() or not self.caster:IsApplyModifier() then
				return
			end

			local startpoint = target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc"))
			-- local dir = CalculateDirection(target,attacker)
			-- local endpoint = target:GetAbsOrigin() +dir *2000
			local damage = keys.damage * 0.23
			local effect_count = 2
			if self.caster:GetSecondsPerAttack(false)<=0.1 then
				damage = damage * 2
				effect_count = 1
			end

			local direction = keys.target:GetOrigin() - self.caster:GetOrigin()
			direction.z = 0
			direction = direction:Normalized()
		
	
			-- create projectile
			local info = {
				Source =  self.caster,
				Ability = self.ability,
				vSpawnOrigin = startpoint,
				
				bDeleteOnHit = true,
				
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				
				EffectName = "particles/rebuild/talent/templar_assassin_2/effect/shockwave/effect.vpcf",
				fDistance = 450,
				fStartRadius = 150,
				fEndRadius = 150,
				vVelocity = direction * 2000,
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				ExtraData = {}   --额外的数据
			}

			local particle = ProjectileManager:CreateLinearProjectile(info)
			self.ability.active_proj[particle] = {
				damage = damage,
				count = effect_count,
				target = target
			}

			
		end
	end
end



function modifier_heroTalent_npc_dota_hero_templar_assassin_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

