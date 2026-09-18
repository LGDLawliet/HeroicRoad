
Middle_hyakkiyakou = class({})

LinkLuaModifier("modifier_Middle_hyakkiyakou_thinker", "skills/Middle_hyakkiyakou", LUA_MODIFIER_MOTION_NONE)

function Middle_hyakkiyakou:IsHiddenWhenStolen() 	return false end
function Middle_hyakkiyakou:IsRefreshable() 		return true end
function Middle_hyakkiyakou:IsStealable() 			return true end
-- function Middle_hyakkiyakou:GetIntrinsicModifierName() return "modifier_Middle_hyakkiyakou_mod" end
function Middle_hyakkiyakou:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Middle_hyakkiyakou:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Middle_hyakkiyakou_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
			radius = self:GetSpecialValueFor("radius"),
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
end


function Middle_hyakkiyakou:OnProjectileHit_ExtraData(target, location, keys)
	-- print("aaa")
	if not IsServer() then
		return
	end
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
						attacker = self:GetCaster(),
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
	
end



modifier_Middle_hyakkiyakou_thinker = class({})

function modifier_Middle_hyakkiyakou_thinker:OnCreated(params)
	if IsServer() then
		--命石：百鬼夜行阵，范围
		self.radius = params.radius
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_Siltbreaker_Preserved_Skull")
		if equip_sp then
			self.radius = self.radius * (1+equip_sp:GetAbility():GetSpecialValueFor("bonus_radius")*0.01)
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
		self.interval = 1
		if equip_sp then
			self.interval = self.interval - equip_sp:GetAbility():GetSpecialValueFor("interval_down")
		end
		self:StartIntervalThink(self.interval)
		self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Appear")	
	end
end

function modifier_Middle_hyakkiyakou_thinker:OnIntervalThink()
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


	local info = 
	{
		-- Target = target,
		-- Source = self:GetParent(),
		-- SourceAttachment = nil,
		Ability = self:GetAbility(),	
		EffectName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc= self:GetParent():GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	for i,enemy in pairs(enemies) do
		info.Target = enemy
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		if i>=2 then
			break
		end
	end








	self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Activate")	

end

function modifier_Middle_hyakkiyakou_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	ParticleManager:DestroyParticle(self.effect_cast2, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast2)


	UTIL_Remove( self:GetParent() )
end


