heroTalent_npc_dota_hero_abaddon = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_abaddon", "heroTalent/heroTalent_npc_dota_hero_abaddon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_abaddon_triger", "heroTalent/heroTalent_npc_dota_hero_abaddon", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_abaddon:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_abaddon:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_abaddon:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_abaddon:IsStealable() 				return true end
function heroTalent_npc_dota_hero_abaddon:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_abaddon:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_abaddon" end


function heroTalent_npc_dota_hero_abaddon:GetCooldown(iLevel)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_Advanced_mist_coil_unlock2") then
		return 10
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end


function heroTalent_npc_dota_hero_abaddon:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	local caster = self:GetCaster()

	caster:EmitSound("Hero_Visage.SoulAssumption.Target")
	local healing = HealWithGain(caster:GetStrength()*self:GetSpecialValueFor("str_index")+self:GetSpecialValueFor("base_damage"),caster,caster,self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
end

-----------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_abaddon = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_abaddon:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_abaddon:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_abaddon:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_abaddon:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abaddon:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_abaddon:ADDeclareFunctions() 
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
} 
end

function modifier_heroTalent_npc_dota_hero_abaddon:OnTakeDamage(keys)
	if IsServer() and keys.unit==self:GetParent() then
		if not self:GetParent():IsRealHero() then
			return
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true, true, true,true)
			self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_heroTalent_npc_dota_hero_abaddon_triger",
			{duration = self:GetAbility():GetSpecialValueFor("tri_duration")})
		else
			if self:GetCaster():GetRandomEffect(self:GetAbility():GetSpecialValueFor("chance"),INT_TYPE,1)>=RandomInt(1, 100) then
				self:GetAbility():UseResources(true, true, true,true)
				self:GetCaster():AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_heroTalent_npc_dota_hero_abaddon_triger",
				{duration = self:GetAbility():GetSpecialValueFor("tri_duration")})
			end
		end
	end
end

----------------------------------------------------------------------------------------------


modifier_heroTalent_npc_dota_hero_abaddon_triger = class({})
function modifier_heroTalent_npc_dota_hero_abaddon_triger:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:IsStunDebuff() return false end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:AllowIllusionDuplicate() return false end

function modifier_heroTalent_npc_dota_hero_abaddon_triger:DeclareFunctions() return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
} end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:GetOverrideAnimation( params ) return ACT_DOTA_RUN end
function modifier_heroTalent_npc_dota_hero_abaddon_triger:GetOverrideAnimationRate( params ) return 0.5 end

function modifier_heroTalent_npc_dota_hero_abaddon_triger:OnCreated(table)
    if IsServer() then
        self.model_scale = 1
        self:GetParent():SetModelScale(2)

		self.next_step = 0
		self:StartIntervalThink(FrameTime())
 
        local caster = self:GetCaster()
		local ability = self:GetAbility()
		local count = self:GetAbility():GetSpecialValueFor("max_count")

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			damage = caster:GetStrength()*self:GetAbility():GetSpecialValueFor("str_index") + self:GetAbility():GetSpecialValueFor("base_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
		}
		caster:EmitSound("Hero_ShadowDemon.Soul_Catcher")
		if caster:HasModifier("modifier_Advanced_mist_coil_unlock2") then
			local mist_ability = caster:FindAbilityByName("Advanced_mist_coil")
			local soul_projectile = {
				Target = caster,
				-- Source = enemy,
				Ability = ability,
				EffectName = "particles/rebuild/spell/abadon_telent/abadon_souls.vpcf",
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = 1200,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData = {}   --额外的数据
			}

			for _, enemy in ipairs(units) do
				damageTable.victim = enemy
				soul_projectile.Source = enemy
				ApplyDamage(damageTable)
				ProjectileManager:CreateTrackingProjectile(soul_projectile)	
				if mist_ability then
					mist_ability:CastToASingleTarget(enemy)
				end
				count = count -1 
				if count <= 0 then
					break
				end
					
			
			end
		else
			for _, enemy in ipairs(units) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				local soul_projectile = {
					Target = caster,
					Source = enemy,
					Ability = ability,
					EffectName = "particles/rebuild/spell/abadon_telent/abadon_souls.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = 1200,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData = {}   --额外的数据
				}
	
				ProjectileManager:CreateTrackingProjectile(soul_projectile)	
				count = count -1 
				if count <= 0 then
					break
				end
					
				
			end
		end
	

    end
end


function modifier_heroTalent_npc_dota_hero_abaddon_triger:OnDestroy()
    if IsServer() then

        self:GetParent():SetModelScale(self.model_scale )
    end
end


function modifier_heroTalent_npc_dota_hero_abaddon_triger:OnIntervalThink(table)
	self.next_step = self.next_step + 30
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	self:GetParent():SetForwardVector( self.facing )
end
