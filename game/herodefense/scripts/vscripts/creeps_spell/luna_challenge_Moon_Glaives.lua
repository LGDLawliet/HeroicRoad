
luna_challenge_Moon_Glaives = class({})

LinkLuaModifier("modifier_luna_challenge_Moon_Glaives", "creeps_spell/luna_challenge_Moon_Glaives", LUA_MODIFIER_MOTION_NONE)


function luna_challenge_Moon_Glaives:IsHiddenWhenStolen() 		return false end
function luna_challenge_Moon_Glaives:IsRefreshable() 			return true end
function luna_challenge_Moon_Glaives:IsStealable() 				return true end
function luna_challenge_Moon_Glaives:IsNetherWardStealable()		return true end
function luna_challenge_Moon_Glaives:GetIntrinsicModifierName() return "modifier_luna_challenge_Moon_Glaives" end
function luna_challenge_Moon_Glaives:Precache( context )

	
	-- PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/moon_glavive/moon_glaive_bounce.vpcf", context )


end
function luna_challenge_Moon_Glaives:GlaiveAttck(source, damage)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() or not caster:IsAlive() then
		return
	end
	local target = nil
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), source:GetAbsOrigin(), nil, 500,
     DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
       DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= source then
			target = enemy
			break
		end
	end
	if target == nil then
		return
    end


	local info = 
	{
		Target = target,
		Source = source,
		Ability = self,	
		EffectName = "particles/rebuild/spell/moon_glavive/moon_glaive_bounce.vpcf",
		iMoveSpeed = (500),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 20,
		bProvidesVision = false,
		ExtraData = { dmg = damage}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function luna_challenge_Moon_Glaives:OnProjectileHit_ExtraData(target, location, keys)
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
	if not caster or caster:IsNull() or not caster:IsAlive() then
		return
	end
	local damage = keys.dmg 
	if target then
        target:EmitSound("Hero_Luna.MoonGlaive.Impact")
        local damageTable = {
            victim = target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
            ability = self, --Optional.
            }
            local damage2 = ApplyDamage(damageTable)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE , target, damage2, nil)


		local next_target = target
		local stack = 1.05
		if self:GetCaster():PassivesDisabled() then
			stack = 1

		end
		self:GlaiveAttck(next_target, damage*stack)
	end
end

modifier_luna_challenge_Moon_Glaives = class({})

function modifier_luna_challenge_Moon_Glaives:IsDebuff()			return false end
function modifier_luna_challenge_Moon_Glaives:IsHidden() 			return true end
function modifier_luna_challenge_Moon_Glaives:IsPurgable() 		return false end
function modifier_luna_challenge_Moon_Glaives:IsPurgeException() 	return false end
function modifier_luna_challenge_Moon_Glaives:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	-- MODIFIER_PROPERTY_PROJECTILE_NAME,
} end


function modifier_luna_challenge_Moon_Glaives:OnCreated()
	if IsServer() then
        self:GetParent().moonglaive = true
	end
end

function modifier_luna_challenge_Moon_Glaives:OnAttackLanded(keys)
	if not IsServer() then
		return
    end


	if keys.attacker ~= self:GetParent() or keys.target:IsOther()  or not self:GetParent().moonglaive or not keys.target:IsAlive() then
		return
	end
	if keys.damage<=0 then
		return
	end
	local dmg = keys.original_damage
    self:GetAbility():GlaiveAttck(keys.target, dmg)

end

