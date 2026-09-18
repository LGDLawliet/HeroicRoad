Primary_marksmanship = class({})
LinkLuaModifier( "modifier_Primary_marksmanship", "skills/Primary_marksmanship", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_marksmanship_debuff", "skills/Primary_marksmanship", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function Primary_marksmanship:GetIntrinsicModifierName()
	return "modifier_Primary_marksmanship"
end

--------------------------------------------------------------------------------
-- Projectile
function Primary_marksmanship:OnProjectileHit_ExtraData( target, location, data )
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


modifier_Primary_marksmanship = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_marksmanship:IsHidden()	return true end
function modifier_Primary_marksmanship:IsDebuff()	return false end
function modifier_Primary_marksmanship:IsPurgable() 		return false end
function modifier_Primary_marksmanship:IsPurgeException() 	return false end
function modifier_Primary_marksmanship:RemoveOnDeath()  return false end
-- function modifier_Primary_marksmanship:GetPriority()	return MODIFIER_PRIORITY_SUPER_ULTRA  end

--------------------------------------------------------------------------------
-- Initializations
-- function modifier_Primary_marksmanship:OnCreated( kv )


-- 	self:StartIntervalThink(10)

-- 	if not IsServer() then return end
-- 	-- self.records = {}


-- 	-- precache splinter
-- 	self.info = {
-- 		-- Target = target,
-- 		-- Source = self:GetParent(),
-- 		Ability = self:GetAbility(),	
		
-- 		EffectName = self:GetParent():GetRangedProjectileName(),
-- 		iMoveSpeed = self:GetParent():GetProjectileSpeed(),
-- 		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
	
-- 		bDodgeable = true,                           -- Optional
-- 		bIsAttack = true,                                -- Optional

-- 		ExtraData = {},
-- 	}
-- 	-- ProjectileManager:CreateTrackingProjectile(info)



-- end



-- function modifier_Primary_marksmanship:OnIntervalThink()

-- 	if IsServer() then
-- 	 self.records = {}
-- 	end
	
--  end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_marksmanship:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,



		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT


	}

	return funcs
end



function modifier_Primary_marksmanship:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

    if not self:GetParent():IsRangedAttacker() or self:GetParent():PassivesDisabled() then
        return
    end
	if not self:GetParent():IsApplyModifier() then
		return
	end

	if self:GetAbility():GetSpecialValueFor( "chance" )>RandomInt( 0, 100 ) then 
		-- local recordIndex = params.record
		-- self.records[recordIndex] = true
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

function modifier_Primary_marksmanship:OnAttackLanded( params )
	-- if not self.records[params.record] then return end
	if params.attacker~=self:GetParent() or self:GetParent():PassivesDisabled() then
		return
	end
	if not self:GetParent():IsRangedAttacker() then
        return
    end
	params.target:AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_Primary_marksmanship_debuff", -- modifier name
		{ duration = 0.5 } -- kv
	)


end

-- function modifier_Primary_marksmanship:GetModifierPreAttack_BonusDamagePostCrit( params )
-- 	if not IsServer() then return end
-- 	if self.records[params.record] then 
-- 		return self:GetAbility():GetSpecialValueFor( "bonus_damage" )
-- 	end
-- end


function modifier_Primary_marksmanship:OnDamageCalculated(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local modifier = params.target:FindModifierByName("modifier_Primary_marksmanship_debuff")
			if modifier then
				modifier:SafeDestroy()
			end
		end
	end
end








modifier_Primary_marksmanship_debuff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_marksmanship_debuff:IsHidden()	return true end
function modifier_Primary_marksmanship_debuff:IsDebuff()	return true end
function modifier_Primary_marksmanship_debuff:IsStunDebuff()	return false end
function modifier_Primary_marksmanship_debuff:IsPurgable()	return false end

function modifier_Primary_marksmanship_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_marksmanship_debuff:OnCreated( kv )
    local ability = self:GetAbility()
    self.armor_reduce = ability:GetSpecialValueFor("armor")*self:GetParent():GetPhysicalArmorValue(false)*0.01
    self.armor_reduce = -math.max(self.armor_reduce,ability:GetSpecialValueFor("armor_min"))
end



function modifier_Primary_marksmanship_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Primary_marksmanship_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor_reduce
end