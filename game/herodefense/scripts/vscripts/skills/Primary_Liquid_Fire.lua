
Primary_Liquid_Fire = class({})

LinkLuaModifier("modifier_Primary_Liquid_Fire", "skills/Primary_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Liquid_Fire_orb", "skills/Primary_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)


function Primary_Liquid_Fire:IsHiddenWhenStolen() 		return false end
function Primary_Liquid_Fire:IsRefreshable() 			return true end
function Primary_Liquid_Fire:IsStealable() 				return false end
function Primary_Liquid_Fire:IsNetherWardStealable() 	return false end
--下为自动施法
function Primary_Liquid_Fire:GetIntrinsicModifierName() return "modifier_Primary_Liquid_Fire_orb" end

function Primary_Liquid_Fire:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) 
end

function Primary_Liquid_Fire:GetAbilityTextureName() 
	return "jakiro_liquid_fire" 
end

function Primary_Liquid_Fire:GetCooldown(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 6 - modifier:GetSpecialValueFor("fire_cd_reduce")
		end
		return 6
	end
end

function Primary_Liquid_Fire:GetManaCost(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 0
		end
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end
--主动的施法
function Primary_Liquid_Fire:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function Primary_Liquid_Fire:OnProjectileHit(target, location)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local effect_number = self:GetSpecialValueFor("effect_number")
	local effect_number_count = 0
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFire", target)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_Primary_Liquid_Fire", {duration = duration})
		effect_number_count = effect_number_count + 1
		if effect_number_count >= effect_number then
			return
		end
    end
end

modifier_Primary_Liquid_Fire = advanced_modifier({})

function modifier_Primary_Liquid_Fire:IsDebuff()			return true end
function modifier_Primary_Liquid_Fire:IsHidden() 			return false end
function modifier_Primary_Liquid_Fire:IsPurgable()         return true end
function modifier_Primary_Liquid_Fire:IsPurgeException() 	return true end
function modifier_Primary_Liquid_Fire:GetEffectName() return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf" end
function modifier_Primary_Liquid_Fire:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Primary_Liquid_Fire:OnCreated()
	self.damage_count = 0
	self.split_count = 0
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_interval"))
	end
end

function modifier_Primary_Liquid_Fire:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") + ability:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("intelligence_index_per_second")) *self:GetAbility():GetSpecialValueFor("damage_interval")
	local damage_type = self:GetAbility():GetAbilityDamageType()
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = dmg,
		damage_type = damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
end

function modifier_Primary_Liquid_Fire:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Primary_Liquid_Fire:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")) end

--------------------------------------------------------------------------------

modifier_Primary_Liquid_Fire_orb = advanced_modifier({})

function modifier_Primary_Liquid_Fire_orb:IsDebuff()			return false end
function modifier_Primary_Liquid_Fire_orb:IsHidden() 			return true end
function modifier_Primary_Liquid_Fire_orb:IsPurgable() 		return false end
function modifier_Primary_Liquid_Fire_orb:IsPurgeException() 	return false end
function modifier_Primary_Liquid_Fire_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Primary_Liquid_Fire_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
			self.pfx2 = nil
		end
	end
end

function modifier_Primary_Liquid_Fire_orb:ADDeclareFunctions()
	 return 
	 {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	  MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	} 
end

function modifier_Primary_Liquid_Fire_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsSilenced() or self:GetParent():IsIllusion()
	 or not self:GetAbility():IsCooldownReady() or not self:GetAbility():GetAutoCastState() then
		return
	end
	self:SetStackCount(1)
	self:GetParent():StartGesture(ACT_DOTA_ATTACK2)
	self:GetAbility():UseResources(true, true, true,true)
end

function modifier_Primary_Liquid_Fire_orb:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	if self:GetStackCount() ~= 1 then
		return
	end

	self:SetStackCount(0)
	self:GetAbility():OnProjectileHit(keys.target, keys.target:GetAbsOrigin())
end

