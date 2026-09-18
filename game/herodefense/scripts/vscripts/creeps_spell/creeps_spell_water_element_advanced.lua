
creeps_spell_water_element_advanced = class({})

LinkLuaModifier("modifier_creeps_spell_water_element_advanced", "creeps_spell/creeps_spell_water_element_advanced", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_water_element_advanced_nodmg", "creeps_spell/creeps_spell_water_element_advanced", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_water_element_advanced:IsHiddenWhenStolen() 		return false end
function creeps_spell_water_element_advanced:IsRefreshable() 			return true end
function creeps_spell_water_element_advanced:IsStealable() 				return true end
function creeps_spell_water_element_advanced:IsNetherWardStealable()		return true end
function creeps_spell_water_element_advanced:GetIntrinsicModifierName() return "modifier_creeps_spell_water_element_advanced" end

function creeps_spell_water_element_advanced:GlaiveAttck(source, damage, bounce)
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
		EffectName = self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_luna/luna_moon_glaive.vpcf",
		iMoveSpeed = (self:GetCaster():IsRangedAttacker() and self:GetCaster():GetProjectileSpeed() or 900),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {bounces = bounce, dmg = damage}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function creeps_spell_water_element_advanced:OnProjectileHit_ExtraData(target, location, keys)
    if not IsServer() then
        return
    end
	local damage = keys.dmg
	if target then
        target:EmitSound("Hero_Morphling.attack")
        local damageTable = {
            victim = target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
            ability = self, --Optional.
        }
            local damage2 = ApplyDamage(damageTable)
            -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE , target, damage2, nil)
            -- print("-------------")
            -- print("in ability")
            -- print(self)
            -- print(damage2)
            -- print("-------------")
            -- self:GetCaster():PerformAttack(target, false, false, true, true, false, false, true)

		-- if PseudoRandom:RollPseudoRandom(self, self:GetSpecialValueFor("attack_effect_change")) and not self:GetCaster():IsIllusion() then
		-- 	self:GetCaster().moonglaive = false
		-- 	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_water_element_advanced_nodmg", {})
		-- 	self:GetCaster():PerformAttack(target, false, true, true, true, false, true, true)
		-- 	self:GetCaster():RemoveModifierByName("modifier_creeps_spell_water_element_advanced_nodmg")
		-- 	self:GetCaster().moonglaive = true
		-- end
		local bounce = keys.bounces - 1
		if bounce <=0  then
			return
		end
		local next_target = target
		self:GlaiveAttck(next_target, damage, bounce)
	end
end

modifier_creeps_spell_water_element_advanced = class({})

function modifier_creeps_spell_water_element_advanced:IsDebuff()			return false end
function modifier_creeps_spell_water_element_advanced:IsHidden() 			return true end
function modifier_creeps_spell_water_element_advanced:IsPurgable() 		return false end
function modifier_creeps_spell_water_element_advanced:IsPurgeException() 	return false end
function modifier_creeps_spell_water_element_advanced:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	-- MODIFIER_PROPERTY_PROJECTILE_NAME,
} end
-- function modifier_creeps_spell_water_element_advanced:GetModifierProjectileName()
-- 	return  "particles/econ/items/luna/luna_lucent_rider/luna_attack_lucent_rider.vpcf" 
--  end 
 

function modifier_creeps_spell_water_element_advanced:OnCreated()
	if IsServer() then
		-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_ambient_moon_glaive.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetParent():GetAbsOrigin(), true)
		-- self:AddParticle(pfx, false, false, 15, false, false)
        self:GetParent().moonglaive = true
	end
end

function modifier_creeps_spell_water_element_advanced:OnAttackLanded(keys)
	if not IsServer() then
		return
    end


	if keys.attacker ~= self:GetParent() or keys.target:IsOther()  or self:GetParent():HasModifier("modifier_creeps_spell_water_element_advanced_nodmg") or not self:GetParent().moonglaive or not keys.target:IsAlive() then
		return
	end
	if keys.damage<=0 then
		return
	end
	local dmg = keys.original_damage
    self:GetAbility():GlaiveAttck(keys.target, dmg, 2)

end

modifier_creeps_spell_water_element_advanced_nodmg = class({})

function modifier_creeps_spell_water_element_advanced_nodmg:IsDebuff()			return false end
function modifier_creeps_spell_water_element_advanced_nodmg:IsHidden() 			return true end
function modifier_creeps_spell_water_element_advanced_nodmg:IsPurgable() 			return false end
function modifier_creeps_spell_water_element_advanced_nodmg:IsPurgeException() 	return false end
function modifier_creeps_spell_water_element_advanced_nodmg:DeclareFunctions() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE} end
function modifier_creeps_spell_water_element_advanced_nodmg:GetModifierDamageOutgoing_Percentage() return (IsServer() and -100 or 0) end
