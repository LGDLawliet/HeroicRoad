Primary_Storm_Bolt = class({})

LinkLuaModifier("modifier_Primary_Storm_Bolt_caster", "skills/Primary_Storm_Bolt", LUA_MODIFIER_MOTION_NONE)

function Primary_Storm_Bolt:IsHiddenWhenStolen() 		return false end
function Primary_Storm_Bolt:IsRefreshable() 			return true end
function Primary_Storm_Bolt:IsStealable() 			return true end
function Primary_Storm_Bolt:IsNetherWardStealable()	return true end
function Primary_Storm_Bolt:GetAOERadius() return self:GetSpecialValueFor("radius") end


function Primary_Storm_Bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Sven.StormBolt")
	caster:AddNewModifier(caster, self, "modifier_Primary_Storm_Bolt_caster", {})
	local pfxname =  "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfxname,
		iMoveSpeed = self:GetSpecialValueFor("speed"),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function Primary_Storm_Bolt:OnProjectileHit(target, location)
	if not IsServer() then
		return
	end
	local hTarget = target or self:GetCaster()
	local caster = self:GetCaster()
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")
	if hTarget ~= caster then
		if hTarget:TriggerSpellAbsorb(self) or hTarget:IsMagicImmune() then
			caster:RemoveModifierByName("modifier_Primary_Storm_Bolt_caster")
			return
		end
		local radius = self:GetSpecialValueFor("radius")
		local dmg = self:GetSpecialValueFor("damage") +caster:GetAverageTrueAttackDamage(nil) *self:GetSpecialValueFor("bonus_damage")
		if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        	dmg = dmg*0.27
    	end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")*StatusResistance})
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = dmg,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)

		end

		

	end
	FindClearSpaceForUnit(caster, hTarget:GetAbsOrigin(), true)
	caster:RemoveModifierByName("modifier_Primary_Storm_Bolt_caster")
	caster:SetAttacking(hTarget)
end

modifier_Primary_Storm_Bolt_caster = class({})

function modifier_Primary_Storm_Bolt_caster:IsDebuff()			return false end
function modifier_Primary_Storm_Bolt_caster:IsHidden() 		return true end
function modifier_Primary_Storm_Bolt_caster:IsPurgable() 		return false end
function modifier_Primary_Storm_Bolt_caster:IsPurgeException() return false end
function modifier_Primary_Storm_Bolt_caster:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_Primary_Storm_Bolt_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_Primary_Storm_Bolt_caster:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveNoDraw()
	end
end

