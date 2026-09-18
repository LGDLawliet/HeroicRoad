
Middle_Liquid_Frost = class({})

LinkLuaModifier("modifier_Middle_Liquid_Frost", "skills/Middle_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Liquid_Frost_sub", "skills/Middle_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Liquid_Frost_orb", "skills/Middle_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------
function Middle_Liquid_Frost:IsHiddenWhenStolen() 		return false end
function Middle_Liquid_Frost:IsRefreshable() 			return true end
function Middle_Liquid_Frost:IsStealable() 				return false end
function Middle_Liquid_Frost:IsNetherWardStealable() 	return false end
--下为自动施法
function Middle_Liquid_Frost:GetIntrinsicModifierName() return "modifier_Middle_Liquid_Frost_orb" end

function Middle_Liquid_Frost:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end
function Middle_Liquid_Frost:GetAbilityTextureName() return "jakiro_Liquid_Ice" end


function Middle_Liquid_Frost:GetCooldown(iLevel)
	if IsServer() then
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 7 - modifier:GetSpecialValueFor("ice_cd_reduce")
		end
		return 7
	end
end

function Middle_Liquid_Frost:GetManaCost(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 0
		end
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end
--主动的施法
function Middle_Liquid_Frost:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf",
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

function Middle_Liquid_Frost:OnProjectileHit(target, location)
	if not target then
		return
	end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local effect_number = self:GetSpecialValueFor("effect_number")
	local effect_number_count = 0
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("radius")*2, self:GetSpecialValueFor("radius")*2, self:GetSpecialValueFor("radius")*2))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFrost", target)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_Middle_Liquid_Frost", {duration = duration})
		effect_number_count = effect_number_count + 1
		if effect_number_count >= effect_number then
			return
		end
    end
end

modifier_Middle_Liquid_Frost = advanced_modifier({})

function modifier_Middle_Liquid_Frost:IsDebuff()			return true end
function modifier_Middle_Liquid_Frost:IsHidden() 			return false end
function modifier_Middle_Liquid_Frost:IsPurgable()         return true end
function modifier_Middle_Liquid_Frost:IsPurgeException() 	return true end
function modifier_Middle_Liquid_Frost:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Middle_Liquid_Frost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Middle_Liquid_Frost:OnCreated()
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("split_interval"))
	end
end

function modifier_Middle_Liquid_Frost:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("split_radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_Middle_Liquid_Frost_sub")  and enemy ~= target then
			local pfx_wave = "particles/new_effect/new_effect/new_liquid_ice_split.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			enemy:AddNewModifier(caster, ability, "modifier_Middle_Liquid_Frost_sub", {duration = ability:GetSpecialValueFor("duration") * 2})
			return
		end
	end
end


function modifier_Middle_Liquid_Frost:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Middle_Liquid_Frost:GetModifierMoveSpeedBonus_Constant() return self.move_slow end

function modifier_Middle_Liquid_Frost:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage
end

function modifier_Middle_Liquid_Frost:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_Middle_Liquid_Frost_orb = class({})

function modifier_Middle_Liquid_Frost_orb:IsDebuff()			return false end
function modifier_Middle_Liquid_Frost_orb:IsHidden() 			return true end
function modifier_Middle_Liquid_Frost_orb:IsPurgable() 		return false end
function modifier_Middle_Liquid_Frost_orb:IsPurgeException() 	return false end
function modifier_Middle_Liquid_Frost_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Middle_Liquid_Frost_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
			self.pfx2 = nil
		end
	end
end
function modifier_Middle_Liquid_Frost_orb:DeclareFunctions()
	 return 
	 {MODIFIER_EVENT_ON_ATTACK,
	  MODIFIER_EVENT_ON_ATTACK_LANDED,} end
function modifier_Middle_Liquid_Frost_orb:OnAttack(keys)
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
function modifier_Middle_Liquid_Frost_orb:OnAttackLanded(keys)
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

--------------------------------------------------------------------------------




--------------------------------------------------------------------
--次级特效
modifier_Middle_Liquid_Frost_sub = advanced_modifier({})
function modifier_Middle_Liquid_Frost_sub:IsDebuff()			return true end
function modifier_Middle_Liquid_Frost_sub:IsHidden() 			return false end
function modifier_Middle_Liquid_Frost_sub:IsPurgable()         return true end
function modifier_Middle_Liquid_Frost_sub:IsPurgeException() 	return true end
function modifier_Middle_Liquid_Frost_sub:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Middle_Liquid_Frost_sub:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Liquid_Frost_sub:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end

function modifier_Middle_Liquid_Frost_sub:OnCreated()
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")*0.5
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*0.5

end


function modifier_Middle_Liquid_Frost_sub:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
function modifier_Middle_Liquid_Frost_sub:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage
end

function modifier_Middle_Liquid_Frost_sub:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
