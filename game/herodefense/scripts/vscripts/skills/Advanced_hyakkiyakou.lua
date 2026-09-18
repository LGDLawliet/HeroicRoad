--特效优化 √
Advanced_hyakkiyakou = class({})

LinkLuaModifier("modifier_Advanced_hyakkiyakou_thinker", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hyakkiyakou_debuff", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hyakkiyakou_unlock1", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hyakkiyakou_unlock2", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hyakkiyakou_unlock3", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hyakkiyakou_unlock3_effect", "skills/Advanced_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
function Advanced_hyakkiyakou:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/hyakkiyakou/hyakkiyakou_army_model.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/hyakkiyakou/unlock3/effect.vpcf", context )

end
function Advanced_hyakkiyakou:CheckKV(key)
	local table = {

	
		damage =4,
		bonus_damage =0.04,



	}
	local value = table[key] or -1
	return value

end
function Advanced_hyakkiyakou:UnlockFirstCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_hyakkiyakou:UnlockSecondCore(key)
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	for _, unit in pairs(heroes) do
		if unit:IsAlive() then
			unit:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock2",{})
		else
			Timers:CreateTimer(1, function()
				if not self then
					return
				end
				if unit:IsAlive() then
					unit:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock2",{})
				else
					return 1
				end
			end)
		end
	end
	return true
end
function Advanced_hyakkiyakou:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock3",{})
	
	return true
end

function Advanced_hyakkiyakou:IsHiddenWhenStolen() 	return false end
function Advanced_hyakkiyakou:IsRefreshable() 		return true end
function Advanced_hyakkiyakou:IsStealable() 			return true end
-- function Advanced_hyakkiyakou:GetIntrinsicModifierName() return "modifier_Advanced_hyakkiyakou_mod" end
function Advanced_hyakkiyakou:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Advanced_hyakkiyakou:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	if self.advanced_level>=20 and caster:GetSummonTimeAmpIndex(1)>1 then
		duration = duration * caster:GetSummonTimeAmpIndex(0.5)
	end

	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Advanced_hyakkiyakou_thinker",
		{
			duration = duration,
			radius = self:GetSpecialValueFor("radius"),
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
end


function Advanced_hyakkiyakou:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then
		return
	end
	-- print("aaa")
	if not target or target:IsMagicImmune() then
		return
	end
	target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	local caster = self:GetCaster()
	local dmg = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	--命石：百鬼夜行阵，伤害降低
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_Siltbreaker_Preserved_Skull")
	if equip_sp then
		dmg = dmg * (1-equip_sp:GetAbility():GetSpecialValueFor("damage_down")*0.01)
	end
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self,
						}
	ApplyDamage(damageTable)

	--命石：百鬼夜行阵，剧毒之触
	if equip_sp then
		local unit = target
		equip_sp:Sphit(unit)
	end

	local parent = EntIndexToHScript(keys.parent)
	if not parent or parent:IsNull() then
		return
	end
	--命石：百鬼夜行阵，击杀
	if not target:IsAlive() and not equip_sp then
		local duration = 1
		if self.advanced_level>=10 then
			duration = 1.8
		end
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	
			parent:GetAbsOrigin(),
			nil,	
			1000,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
			FIND_ANY_ORDER,	
			false	
		)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
		for i,enemy in pairs(enemies) do

			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self, "modifier_Advanced_hyakkiyakou_debuff", {duration = duration*StatusResistance})
			if i>=8 then
				break
			end
		end
	
	end

	
end



modifier_Advanced_hyakkiyakou_thinker = class({})

function modifier_Advanced_hyakkiyakou_thinker:OnCreated(params)
	if IsServer() then

		--命石：百鬼夜行阵，范围
		self.radius = params.radius
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_Siltbreaker_Preserved_Skull")
		if equip_sp then
			self.radius = self.radius * (1+equip_sp:GetAbility():GetSpecialValueFor("bonus_radius")*0.01)
		end

		self.level = self:GetAbility().advanced_level
		self.max_target = 2
		local attack_rate = 1
		if self.level>=5 then
			self.max_target = 3
			if self.level>=15 then
				attack_rate = 0.7
			end
		end
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/hyakkiyakou/hyakkiyakou_army_ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(0, 234, 230) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )


		self.effect_cast2 = ParticleManager:CreateParticle( "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		--命石：百鬼夜行阵，攻击间隔
		if equip_sp then
			attack_rate = attack_rate - equip_sp:GetAbility():GetSpecialValueFor("interval_down")
		end
		self:StartIntervalThink(attack_rate)
		self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Appear")	
	end
end

function modifier_Advanced_hyakkiyakou_thinker:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
		FIND_ANY_ORDER,	
		false	
	)

	local position = self:GetParent():GetAbsOrigin()

	local info = 
	{
		-- Target = target,
		-- Source = self:GetParent(),
		-- SourceAttachment = nil,
		Ability = self:GetAbility(),	
		EffectName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc= position,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {parent = self:GetParent():entindex()}
	}

	for i,enemy in pairs(enemies) do
		info.Target = enemy
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		if i>=self.max_target then
			break
		end
	end








	self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Activate")	

end

function modifier_Advanced_hyakkiyakou_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	ParticleManager:DestroyParticle(self.effect_cast2, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast2)


	UTIL_Remove( self:GetParent() )
end






modifier_Advanced_hyakkiyakou_debuff = class({})

function modifier_Advanced_hyakkiyakou_debuff:IsHidden()	return false end
function modifier_Advanced_hyakkiyakou_debuff:IsDebuff()	return true end
function modifier_Advanced_hyakkiyakou_debuff:IsStunDebuff()	return false end
function modifier_Advanced_hyakkiyakou_debuff:IsPurgable()	return true end
function modifier_Advanced_hyakkiyakou_debuff:CanParentBeAutoAttacked()	return false end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_hyakkiyakou_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_Advanced_hyakkiyakou_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_Advanced_hyakkiyakou_debuff:GetOverrideAnimationRate()
	return 1
end


function modifier_Advanced_hyakkiyakou_debuff:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	self:SafeDestroy()
end

function modifier_Advanced_hyakkiyakou_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_Advanced_hyakkiyakou_debuff:GetEffectName()
	return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function modifier_Advanced_hyakkiyakou_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end









modifier_Advanced_hyakkiyakou_unlock1 = class({})

function modifier_Advanced_hyakkiyakou_unlock1:IsHidden()	return true end
function modifier_Advanced_hyakkiyakou_unlock1:IsDebuff()	return false end
function modifier_Advanced_hyakkiyakou_unlock1:IsPurgable()	return false end
function modifier_Advanced_hyakkiyakou_unlock1:IsPurgeException() return false end
function modifier_Advanced_hyakkiyakou_unlock1:RemoveOnDeath() return false end



function modifier_Advanced_hyakkiyakou_unlock1:OnCreated(params)
	if IsServer() then
		self.radius = 1000
		self.max_target = 2
		local parent = self:GetParent()

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/hyakkiyakou/hyakkiyakou_army_model.vpcf", PATTACH_CUSTOMORIGIN, parent )
		ParticleManager:SetParticleControlEnt(self.effect_cast,0,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		ParticleManager:SetParticleControlEnt(self.effect_cast,3,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		self:StartIntervalThink(0.7)
	end
end

function modifier_Advanced_hyakkiyakou_unlock1:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsAlive() or parent:PassivesDisabled() then
		return
	end

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),	
		parent:GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
		FIND_ANY_ORDER,	
		false	
	)

	-- local position = parent:GetAbsOrigin()

	local info = 
	{
		-- Target = target,
		Source = parent,
		-- SourceAttachment = nil,
		Ability = ability,	
		EffectName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf",
		iMoveSpeed = 1200,
		-- vSourceLoc= position,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {parent = parent:entindex()}
	}

	-- local sound = false
	for i,enemy in pairs(enemies) do
		info.Target = enemy
		ProjectileManager:CreateTrackingProjectile(info)
		-- sound = true
		if i>=self.max_target then
			break
		end
	end
	-- if sound then
	-- 	parent:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
	-- end
	
end

function modifier_Advanced_hyakkiyakou_unlock1:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end





modifier_Advanced_hyakkiyakou_unlock2 = advanced_modifier({})

function modifier_Advanced_hyakkiyakou_unlock2:IsHidden()	return true end
function modifier_Advanced_hyakkiyakou_unlock2:IsDebuff()	return false end
function modifier_Advanced_hyakkiyakou_unlock2:IsPurgable()	return false end
function modifier_Advanced_hyakkiyakou_unlock2:IsPurgeException() return false end
function modifier_Advanced_hyakkiyakou_unlock2:RemoveOnDeath() return false end



function modifier_Advanced_hyakkiyakou_unlock2:OnCreated(keys)
	self.bonus = 18
	if self:GetParent()==self:GetCaster() then
		self.bonus = -30
	end
	if IsServer() then

		self:StartIntervalThink(5)
	end
end


function modifier_Advanced_hyakkiyakou_unlock2:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
	end
end
-- advanced_modifier
function modifier_Advanced_hyakkiyakou_unlock2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
    }
end
function modifier_Advanced_hyakkiyakou_unlock2:Advanced_GetModifier_RandomEffectGain(keys)
	return self.bonus
end


modifier_Advanced_hyakkiyakou_unlock3 = class({})

function modifier_Advanced_hyakkiyakou_unlock3:IsHidden()	return true end
function modifier_Advanced_hyakkiyakou_unlock3:IsDebuff()	return false end
function modifier_Advanced_hyakkiyakou_unlock3:IsPurgable()	return false end
function modifier_Advanced_hyakkiyakou_unlock3:IsPurgeException() return false end
function modifier_Advanced_hyakkiyakou_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_hyakkiyakou_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_hyakkiyakou_unlock3_effect", {})

	end
end
modifier_Advanced_hyakkiyakou_unlock3_effect = class({})

function modifier_Advanced_hyakkiyakou_unlock3_effect:IsHidden()	return true end
function modifier_Advanced_hyakkiyakou_unlock3_effect:IsDebuff()	return false end
function modifier_Advanced_hyakkiyakou_unlock3_effect:IsPurgable()	return false end
function modifier_Advanced_hyakkiyakou_unlock3_effect:IsPurgeException() return false end


function modifier_Advanced_hyakkiyakou_unlock3_effect:OnCreated(params)
	if IsServer() then
		self.radius = 1000
		self.max_target = 1
		local parent = self:GetParent()

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/hyakkiyakou/unlock3/effect.vpcf", PATTACH_OVERHEAD_FOLLOW , parent )
		-- ParticleManager:SetParticleControlEnt(self.effect_cast,0,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		ParticleManager:SetParticleControlEnt(self.effect_cast,3,parent,PATTACH_OVERHEAD_FOLLOW ,"attach_hitloc",Vector(0,0,0),true)
		self:StartIntervalThink(7)
	end
end

function modifier_Advanced_hyakkiyakou_unlock3_effect:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability then 
		self:SafeDestroy()
		return
	end
	local parent = self:GetParent()
	if not parent:IsAlive() or parent:PassivesDisabled() then
		return
	end

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),	
		parent:GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
		FIND_ANY_ORDER,	
		false	
	)

	-- local position = parent:GetAbsOrigin()

	local info = 
	{
		-- Target = target,
		Source = parent,
		-- SourceAttachment = nil,
		Ability = ability,	
		EffectName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf",
		iMoveSpeed = 1200,
		-- vSourceLoc= position,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {parent = parent:entindex()}
	}

	-- local sound = false
	for i,enemy in pairs(enemies) do
		info.Target = enemy
		ProjectileManager:CreateTrackingProjectile(info)
		-- sound = true
		if i>=self.max_target then
			break
		end
	end
	-- if sound then
	-- 	parent:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
	-- end
	
end

function modifier_Advanced_hyakkiyakou_unlock3_effect:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end
