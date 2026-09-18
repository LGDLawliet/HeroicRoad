
Primary_Impetus = class({})

LinkLuaModifier("modifier_Primary_Impetus", "skills/Primary_Impetus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Impetus_orb", "skills/Primary_Impetus", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------
function Primary_Impetus:IsHiddenWhenStolen() 		  return false end
function Primary_Impetus:IsRefreshable() 			  return true end
function Primary_Impetus:IsStealable() 				return false end
function Primary_Impetus:IsNetherWardStealable() 	return false end
--下为自动施法
function Primary_Impetus:GetIntrinsicModifierName() return "modifier_Primary_Impetus_orb" end
function Primary_Impetus:Precache( context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf", context )


	
	
end
function Primary_Impetus:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end
--主动的施法
function Primary_Impetus:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self:StartCooldown(0.1)
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
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
	ProjectileManager:CreateTrackingProjectile(info)
end

function Primary_Impetus:OnProjectileHit(target, location)
	if not target then
		return
	end
	local caster = self:GetCaster()
	local dis= GetDistanceBetweenTwoUnit(caster,target)

	local damage = dis * (self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("intelligence_index") * caster:GetIntellect(false)) *0.01
	
	if self.talent_ability and self.talent_ability:GetAutoCastState() then
		damage = damage *1.65
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = self, --Optional.
		}
	target:ApplyMergeDamage(damageTable)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enchantress.ImpetusDamage", target)
end
function Primary_Impetus:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if IsServer() then
		local ability = self:FindTalent()
		if ability then
			if ability:GetAutoCastState() then
				return cost*2
			end
			return cost *0.5
		end
	end

	return cost
end

function Primary_Impetus:FindTalent()

	if not self.talent_ability then
		self.talent_ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enchantress_2")
	end
	return  self.talent_ability
end



modifier_Primary_Impetus_orb = class({})

function modifier_Primary_Impetus_orb:IsDebuff()			return false end
function modifier_Primary_Impetus_orb:IsHidden() 			return true end
function modifier_Primary_Impetus_orb:IsPurgable() 		return false end
function modifier_Primary_Impetus_orb:IsPurgeException() 	return false end


function modifier_Primary_Impetus_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Primary_Impetus_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
	end
end
function modifier_Primary_Impetus_orb:DeclareFunctions()
	 return 
	 {MODIFIER_EVENT_ON_ATTACK,
	  MODIFIER_EVENT_ON_ATTACK_LANDED,} end
function modifier_Primary_Impetus_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion()
	or not ability:GetAutoCastState() then
		return
	end
	if not ability:IsFullyCastable() then
		return
	end
	if not parent:IsApplyModifier() then
		return
	end
	if not IsEnemy(keys.target,parent) then
		return
	end
	-- self:SetStackCount(1)
	local needTime = math.max(parent:GetSecondsPerAttack(false),0.03)
	parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1/needTime)
	ability:UseResources(true, true, true, true)
		local info = 
	{
		Target = keys.target,
		Source = parent,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
		iMoveSpeed = parent:GetProjectileSpeed(),
		vSourceLoc= parent:GetAbsOrigin(),
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
