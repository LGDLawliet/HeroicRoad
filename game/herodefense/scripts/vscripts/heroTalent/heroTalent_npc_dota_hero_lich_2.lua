heroTalent_npc_dota_hero_lich_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lich_2", "heroTalent/heroTalent_npc_dota_hero_lich_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lich_2_debuff", "heroTalent/heroTalent_npc_dota_hero_lich_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_lich_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lich_2"
end
function heroTalent_npc_dota_hero_lich_2:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()
end

function heroTalent_npc_dota_hero_lich_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_chain_frost.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf", context )

end

function heroTalent_npc_dota_hero_lich_2:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end


	target:EmitSound("Hero_Lich.ChainFrostImpact.Hero")
	local caster = self:GetCaster()
	local damage_index = keys.damage_index
	-- if target~=caster then
	-- 	local damage = caster:GetIntellect(false)*3*(1+damage_index)
	-- 	local damageTable = {
	-- 		victim = target,
	-- 		attacker =caster,
	-- 		damage =damage,
	-- 		damage_type = DAMAGE_TYPE_MAGICAL,
	-- 		ability = self, --Optional.
	-- 	}
	-- 	ApplyDamage(damageTable)
	-- 	if target:IsAlive() then
	-- 		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- 		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	-- 		target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_lich_2_debuff", {duration = 1.5*StatusResistance})
	-- 	end
	-- end

	local enemies_start = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), nil,200,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = caster:GetIntellect(false)*3*(1+damage_index)
	local damageTable = {
		victim = target,
		attacker =caster,
		damage =damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
	}
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	for _,enemy in pairs(enemies_start) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		if enemy:IsAlive() then
	
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_lich_2_debuff", {duration = 1.5*StatusResistance})
		end

	end



	local bounce = keys.bounce
	if bounce>=1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		local newTarget
		for _, unit in ipairs(enemies) do
			if unit~=target then
				newTarget=unit
			end
		end
		if not newTarget then
			if caster~=target and CalculateDistance(caster,target)<=1000 then
				newTarget = caster
			end
		end


		if newTarget then
			damage_index = damage_index +0.1
			-- self:GlaiveAttck(target,newTarget,keys.dmg*0.75,bounce)
			self:CreateProjectile(newTarget,target,bounce-1,damage_index)
		
		end
	end


end

function heroTalent_npc_dota_hero_lich_2:CreateProjectile(target,srouce,bounce,damage_index)
	local info = 
	{
		Target =target,
		Source = srouce,
		-- vSourceLoc = caster:GetAttachmentOrigin("attach_attack1"),
		Ability = self,	
		EffectName = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf",
		iMoveSpeed = 800,
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 30, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {bounce = bounce, damage_index = damage_index}   --额外的数据
	}
	
	ProjectileManager:CreateTrackingProjectile(info)
end

modifier_heroTalent_npc_dota_hero_lich_2 = class({})

function modifier_heroTalent_npc_dota_hero_lich_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_lich_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_lich_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_lich_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_lich_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lich_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.1)
	end

end



function modifier_heroTalent_npc_dota_hero_lich_2:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		local caster = self:GetParent()
		if not caster:IsAlive() then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			local bounce  = math.floor(caster:GetIntellect(false)/20)
			ability:CreateProjectile(unit,caster,bounce,0)
			ability:StartCooldown(bounce+10)
			caster:EmitSound("Hero_Lich.ChainFrost")
			return
		end
	end

end




--修饰器内容
modifier_heroTalent_npc_dota_hero_lich_2_debuff =  modifier_heroTalent_npc_dota_hero_lich_2_debuff or class({})
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:IsPurgable()	return true end
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf" 
end
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:GetEffectAttachType()
    return  PATTACH_ROOTBONE_FOLLOW
end
function modifier_heroTalent_npc_dota_hero_lich_2_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_lich_2_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -90
end

