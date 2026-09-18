Advanced_Fire_Blast = class({})

LinkLuaModifier("modifier_Advanced_Fire_Blast_debuff", "skills/Advanced_Fire_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Fire_Blast_stun", "skills/Advanced_Fire_Blast", LUA_MODIFIER_MOTION_NONE)





function Advanced_Fire_Blast:IsHiddenWhenStolen() 		return false end
function Advanced_Fire_Blast:IsRefreshable() 			return true end
function Advanced_Fire_Blast:IsStealable() 			return true end
function Advanced_Fire_Blast:IsNetherWardStealable()	return true end
function Advanced_Fire_Blast:GetAOERadius()
	local caster = self:GetCaster()
	local radius = (self:GetCastRange(caster:GetAbsOrigin(), caster)*0.5 + caster:GetCastRangeBonus()* 0.1) 	

	return radius		 
end

function Advanced_Fire_Blast:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pfx_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
	caster:EmitSound("Hero_OgreMagi.Ignite.Cast")
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfx_name,
		iMoveSpeed = 1000,
		iSourceAttachment = caster:ScriptLookupAttachment("attach_attack1"),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {},
	}
	
	ProjectileManager:CreateTrackingProjectile(info)
	if not scepter then
		local radius = (self:GetCastRange(caster:GetAbsOrigin(), caster)*0.5 + caster:GetCastRangeBonus()* 0.1) 	
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true)
				-- if not self:GetCaster():HasScepter() then --a杖对所有英雄释放
				-- 	return
				-- end	
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				caster:SetCursorCastTarget(unit)
				self:OnSpellStart(true)
				return
			end
		end	
	end	
end

function Advanced_Fire_Blast:OnProjectileHit_ExtraData(target, pos, keys)
	if not target or  target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()	
	target:EmitSound("Hero_OgreMagi.Ignite.Target") 
	target:EmitSound("Hero_OgreMagi.Fireblast.Target")
	target:AddNewModifier(caster, self, "modifier_Advanced_Fire_Blast_stun", {duration = self:GetSpecialValueFor("stunned_duration")})
	local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	ApplyDamage({attacker = caster, victim = target,
	 damage = self:GetSpecialValueFor("stunned_damage")+caster:GetIntellect(false)*self:GetSpecialValueFor("bonus_damage") ,
	  ability = self, damage_type = self:GetAbilityDamageType()}) 
	if target:IsAlive() then
		local buff =target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Fire_Blast_debuff", 
		{duration = self:GetSpecialValueFor("debuff_duration")})
		buff:SetStackCount(buff:GetStackCount() + 1)
	end	
end
modifier_Advanced_Fire_Blast_debuff = class({})

function modifier_Advanced_Fire_Blast_debuff:IsDebuff()			return true end
function modifier_Advanced_Fire_Blast_debuff:IsHidden() 			return false end
function modifier_Advanced_Fire_Blast_debuff:IsPurgable() 			return true end
function modifier_Advanced_Fire_Blast_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Fire_Blast_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	                                                                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Advanced_Fire_Blast_debuff:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf" end
function modifier_Advanced_Fire_Blast_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
--function modifier_Advanced_Fire_Blast_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end  --允许叠加
function modifier_Advanced_Fire_Blast_debuff:GetModifierMoveSpeedBonus_Percentage() 
	return (0 - self:GetAbility():GetSpecialValueFor("move_slow")*self:GetStackCount()) end
function modifier_Advanced_Fire_Blast_debuff:GetModifierAttackSpeedBonus_Constant() 
	return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")*self:GetStackCount()) end

function modifier_Advanced_Fire_Blast_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)  
	end
end

function modifier_Advanced_Fire_Blast_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local dmg = self:GetAbility():GetSpecialValueFor("debuff_damage")*self:GetStackCount()
	local dmgfaqiang = self:GetAbility():GetSpecialValueFor("debuff_damage")*self:GetStackCount() * (self:GetCaster():GetSpellAmplification(false) + 1)
	ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = dmg, damage_type = ability:GetAbilityDamageType()})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), dmgfaqiang, nil)
end
-- function modifier_Advanced_Fire_Blast_debuff:OnDestroy()
-- 	if IsServer() then
-- 	end
-- end			

modifier_Advanced_Fire_Blast_stun = class({})

function modifier_Advanced_Fire_Blast_stun:IsDebuff()			return true end
function modifier_Advanced_Fire_Blast_stun:IsHidden() 			return false end
function modifier_Advanced_Fire_Blast_stun:IsPurgable() 		return true end
function modifier_Advanced_Fire_Blast_stun:IsPurgeException() 	return true end
function modifier_Advanced_Fire_Blast_stun:IsStunDebuff() return true end
function modifier_Advanced_Fire_Blast_stun:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_Advanced_Fire_Blast_stun:GetStatusEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_Advanced_Fire_Blast_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_Fire_Blast_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Fire_Blast_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

function modifier_Advanced_Fire_Blast_stun:OnCreated()
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end

function modifier_Advanced_Fire_Blast_stun:OnRefresh(table)
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end