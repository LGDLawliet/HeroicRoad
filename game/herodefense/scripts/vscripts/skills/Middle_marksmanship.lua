Middle_marksmanship = class({})
LinkLuaModifier( "modifier_Middle_marksmanship", "skills/Middle_marksmanship", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_marksmanship_debuff", "skills/Middle_marksmanship", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function Middle_marksmanship:GetIntrinsicModifierName()
	return "modifier_Middle_marksmanship"
end

--------------------------------------------------------------------------------
-- Projectile
function Middle_marksmanship:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

		
	local caster = self:GetCaster()
	local damagetable= {
		victim = target,
		attacker = caster,
		damage = self:GetSpecialValueFor( "bonus_damage" ),
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		}
	ApplyDamage(damagetable)

end


modifier_Middle_marksmanship = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_marksmanship:IsHidden()	return true end
function modifier_Middle_marksmanship:IsDebuff()	return false end
function modifier_Middle_marksmanship:IsPurgable() 		return false end
function modifier_Middle_marksmanship:IsPurgeException() 	return false end
function modifier_Middle_marksmanship:RemoveOnDeath()  return false end
-- function modifier_Middle_marksmanship:GetPriority()	return MODIFIER_PRIORITY_SUPER_ULTRA  end

--------------------------------------------------------------------------------
-- Initializations
-- function modifier_Middle_marksmanship:OnCreated( kv )
-- 	-- references
-- 	-- self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
-- 	-- self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

-- 	-- self:StartIntervalThink(10)

-- 	if not IsServer() then return end
-- 	-- self.records = {}
-- 	-- self.procs = false

-- 	-- precache splinter
-- 	-- self.info = {
-- 	-- 	-- Target = target,
-- 	-- 	-- Source = self:GetParent(),
-- 	-- 	Ability = self:GetAbility(),	
		
-- 	-- 	EffectName = self:GetParent():GetRangedProjectileName(),
-- 	-- 	iMoveSpeed = self:GetParent():GetProjectileSpeed(),
-- 	-- 	iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
	
-- 	-- 	bDodgeable = true,                           -- Optional
-- 	-- 	bIsAttack = true,                                -- Optional

-- 	-- 	ExtraData = {},
-- 	-- }
-- 	-- ProjectileManager:CreateTrackingProjectile(info)



-- end

-- function modifier_Middle_marksmanship:OnRefresh( kv )
-- 	-- references
-- 	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )


-- end

-- function modifier_Middle_marksmanship:OnIntervalThink()

-- 	if IsServer() then
-- 	 self.records = {}
-- 	end
	
-- end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_marksmanship:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,

		-- MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算
	}

	return funcs
end



function modifier_Middle_marksmanship:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

    if not self:GetParent():IsRangedAttacker() or self:GetParent():PassivesDisabled() then
        return
    end
	if not self:GetParent():IsApplyModifier() then
		return
	end

	if self:GetAbility():GetSpecialValueFor( "chance" )>RandomInt( 0, 100 ) then 
		-- self.records[params.record] = true
		local caster = self:GetCaster()
		local info = 
		{
			Target = params.target,
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf",
			iMoveSpeed =1500,
			-- caster:GetProjectileSpeed()
			vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = false, --提供视野
			ExtraData = {fakeAttack = true}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

function modifier_Middle_marksmanship:OnAttackLanded( params )
	-- if not self.records[params.record] then return end
	if params.attacker~=self:GetParent() or self:GetParent():PassivesDisabled() then
		return
	end
	if not self:GetParent():IsRangedAttacker() then
        return
    end
	-- add ignore armor modifier
	params.target:AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_Middle_marksmanship_debuff", -- modifier name
		{ duration = 0.5 } -- kv
	)

end

-- function modifier_Middle_marksmanship:GetModifierPreAttack_BonusDamagePostCrit( params )
-- 	if not IsServer() then return end
-- 	if self.records[params.record] then 
-- 		return self:GetAbility():GetSpecialValueFor( "bonus_damage" )
-- 	end
-- end


function modifier_Middle_marksmanship:OnDamageCalculated(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local modifier = params.target:FindModifierByName("modifier_Middle_marksmanship_debuff")
			if modifier then
				modifier:SafeDestroy()
			end
		end
	end
end







-- function modifier_Middle_marksmanship:GetModifierProcAttack_Feedback( params )
-- 	if not IsServer() then return end

-- 	-- for scepter
-- 	if not self:GetParent():HasScepter() then return end

-- 	-- check if this is split shot
-- 	if self:GetAbility().split then return end

-- 	-- find enemies
-- 	local enemies = FindUnitsInRadius(
-- 		self:GetParent():GetTeamNumber(),	-- int, your team number
-- 		params.target:GetOrigin(),	-- point, center point
-- 		nil,	-- handle, cacheUnit. (not known)
-- 		self.split_range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
-- 		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
-- 		FIND_CLOSEST,	-- int, order filter
-- 		false	-- bool, can grow cache
-- 	)

-- 	local count = 0
-- 	for _,enemy in pairs(enemies) do
-- 		if enemy~=params.target and count<self.split_count then

-- 			-- roll pierce armor chance
-- 			local procs = false
-- 			local rand = RandomInt( 0, 100 )
-- 			if self.active and rand<=self.chance then
-- 				procs = true
-- 			end

-- 			-- launch projectile
-- 			self.info.Target = enemy
-- 			self.info.Source = params.target
-- 			if procs then
-- 				self.info.EffectName = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
-- 				self.info.ExtraData = {
-- 					procs = true,
-- 				}
-- 			else
-- 				self.info.EffectName = self:GetParent():GetRangedProjectileName()
-- 				self.info.ExtraData = {
-- 					procs = false,
-- 				}
-- 			end
-- 			ProjectileManager:CreateTrackingProjectile( self.info )

-- 			count = count+1
-- 		end
-- 	end
-- end

-- function modifier_Middle_marksmanship:GetModifierDamageOutgoing_Percentage()
-- 	if not IsServer() then return end
	
-- 	-- check if split shot
-- 	if self:GetAbility().split then
-- 		return -self.split_damage
-- 	end
-- end









modifier_Middle_marksmanship_debuff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_marksmanship_debuff:IsHidden()	return true end
function modifier_Middle_marksmanship_debuff:IsDebuff()	return true end
function modifier_Middle_marksmanship_debuff:IsStunDebuff()	return false end
function modifier_Middle_marksmanship_debuff:IsPurgable()	return false end

function modifier_Middle_marksmanship_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_marksmanship_debuff:OnCreated( kv )
    local ability = self:GetAbility()
    self.armor_reduce = ability:GetSpecialValueFor("armor")*self:GetParent():GetPhysicalArmorValue(false)*0.01
	if 30>=RandomInt(1, 100) then
		self.armor_reduce = self.armor_reduce*2
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/hero_levelup_ti7_flash_hit_magic.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
    self.armor_reduce = -math.max(self.armor_reduce,ability:GetSpecialValueFor("armor_min"))
end



function modifier_Middle_marksmanship_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor_reduce
end


function modifier_Middle_marksmanship_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end