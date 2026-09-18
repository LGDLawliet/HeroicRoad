
chaotic_liquid_frost = class({})

LinkLuaModifier("modifier_chaotic_liquid_frost", "chaotic_spell/class_3/chaotic_liquid_frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_liquid_frost_orb", "chaotic_spell/class_3/chaotic_liquid_frost", LUA_MODIFIER_MOTION_NONE)
function chaotic_liquid_frost:IsRefreshable() 			return true end

--下为自动施法
function chaotic_liquid_frost:GetIntrinsicModifierName() return "modifier_chaotic_liquid_frost_orb" end

function chaotic_liquid_frost:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) 
end
--主动的施法
function chaotic_liquid_frost:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf",
		iMoveSpeed = caster:GetProjectileSpeed() or 1500,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	local projectile = ProjectileManager:CreateTrackingProjectile(info)

	if self:GetRuneType() == 1 then
		if self:GetSpecialValueFor("rune_1_chance") >= math.random(1,100) then
			caster:GiveMana(self:GetManaCost(self:GetLevel()))
			self:EndCooldown()
		end
	end
end

function chaotic_liquid_frost:OnProjectileHit(target, location)
    if not IsServer() then return end
	if not target then
		return
	end

	local caster = self:GetCaster()
    local freezing = caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_freezing") + self:GetSpecialValueFor("freezing")
    local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local effect_number = self:GetSpecialValueFor("max")
	local effect_number_count = 0
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius*2, radius*2,radius*2))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFrost", target)
	for _, enemy in pairs(enemies) do
        enemy:Freezing(caster,self,freezing)

        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
        local StatusResistance = enemy:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_chaotic_liquid_frost", {duration = duration*StatusResistance})
		effect_number_count = effect_number_count + 1
		if effect_number_count >= effect_number then
			return
		end
    end
end

modifier_chaotic_liquid_frost = advanced_modifier({})

function modifier_chaotic_liquid_frost:IsDebuff()			return true end
function modifier_chaotic_liquid_frost:IsHidden() 			return false end
function modifier_chaotic_liquid_frost:IsPurgable()         return true end
function modifier_chaotic_liquid_frost:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_chaotic_liquid_frost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_liquid_frost:OnCreated()
    self.ability =  self:GetAbility()
    self.incoming = self.ability:GetSpecialValueFor("incoming")
end

function modifier_chaotic_liquid_frost:ADDeclareFunctions() return {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_chaotic_liquid_frost:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.incoming
end

--------------------------------------------------------------------------------

modifier_chaotic_liquid_frost_orb = advanced_modifier({})

function modifier_chaotic_liquid_frost_orb:IsDebuff()			return false end
function modifier_chaotic_liquid_frost_orb:IsHidden() 			return true end
function modifier_chaotic_liquid_frost_orb:IsPurgable() 		return false end
function modifier_chaotic_liquid_frost_orb:IsPurgeException() 	return false end
function modifier_chaotic_liquid_frost_orb:OnCreated()
	self.ability = self:GetAbility()
	self.rune_1_chance = self.ability:GetSpecialValueFor("rune_1_chance")
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_chaotic_liquid_frost_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
			self.pfx2 = nil
		end
	end
end

function modifier_chaotic_liquid_frost_orb:ADDeclareFunctions()
	 return 
	 {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	  MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	} 
end

function modifier_chaotic_liquid_frost_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local attacker = keys.attacker
	local parent = self:GetParent()
	if attacker ~= parent or parent:IsSilenced() or not self.ability:IsCooldownReady() or not self.ability:GetAutoCastState() then
		return
	end
	self:SetStackCount(1)

	if self.ability:GetRuneType() == 1 and self.rune_1_chance >= math.random(1,100) then
		chaotic_era_spawner:PlayerGetGoldBounty(parent,-1,self.ability)
		return 
	else
		self:GetAbility():UseResources(true, true, true,true)
	end
end

function modifier_chaotic_liquid_frost_orb:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	if self:GetStackCount() ~= 1 then
		return
	end
	if not self:GetAbility() then return end
	self:SetStackCount(0)
	self:GetAbility():OnProjectileHit(keys.target, keys.target:GetAbsOrigin())
end

