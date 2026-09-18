heroTalent_npc_dota_hero_luna_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_luna_2", "heroTalent/heroTalent_npc_dota_hero_luna_2", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_luna_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_luna_2"
end
function heroTalent_npc_dota_hero_luna_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/luna_2/effect/moon_glaive_bounce.vpcf", context )


end
function heroTalent_npc_dota_hero_luna_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()

		if self:Chaotic_era() then
			caster:GameTimer(0.05,function ()
				chaotic_era:LearnChaoticEraSpell(caster,"chaotic_lucent_beam")
				
			end)
			return
		end
		
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"lucent_beam",costKeys)
			end
		end)
	
	end

end

function heroTalent_npc_dota_hero_luna_2:Chaotic_era()
	if Game_State:IsInChaoticEra() then
		return true
	end
	return false
end

function heroTalent_npc_dota_hero_luna_2:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local chance = self:GetSpecialValueFor("chance")
	if self:Chaotic_era() then
		chance = self:GetSpecialValueFor("chance_chaotic")
	end

	local random = math.random
	if chance>=random(1, 100) then
		if self:Chaotic_era() then
			local ability_chaotic = caster:FindAbilityByName("chaotic_lucent_beam")
			if ability_chaotic then
				ability_chaotic:OnSpellStart()
				return
			end
		end


		local ability = caster:FindAbilityByName("Advanced_lucent_beam")
		if not ability then
			ability = caster:FindAbilityByName("Middle_lucent_beam")
			if not ability then
				ability = caster:FindAbilityByName("Primary_lucent_beam")
			end
		end
		if ability then
			ability:CreateSingleLucent_luna(target)
		end
	end

	if keys.sameUnit==1 then
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/luna_2/effect/moon_glaive_bounce.vpcf", PATTACH_CUSTOMORIGIN, nil )
		local pos = target:GetAbsOrigin()
		pos.z = pos.z +128
		ParticleManager:SetParticleControl( nFXIndex, 0, pos )
		DestroyParticleByDelay(nFXIndex,3)
	end


	local bounce = keys.bounce
	if bounce>=1 then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		 DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST , false)
		
		local newTarget
		for _, unit in ipairs(enemies) do
			newTarget=unit
			break
		end


		if newTarget then
			
			self:GlaiveAttck(target,newTarget,bounce)
		
		end
	end
end

function heroTalent_npc_dota_hero_luna_2:GlaiveAttck(srouce,target, bounce)
	local caster = self:GetCaster()
	local attach_point = srouce:ScriptLookupAttachment( "attach_hitloc" )
	local sameUnit = 0
	if srouce == target then
		sameUnit = 1
	end
	local info = 
	{
		Target =target,
		-- Source = srouce,
		vSourceLoc = srouce:GetAttachmentOrigin(attach_point),
		Ability = self,	
		EffectName = caster:GetRangedProjectileName(),
		iMoveSpeed = caster:GetProjectileSpeed(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {bounce = bounce-1, sameUnit = sameUnit}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_luna_2 = class({})

function modifier_heroTalent_npc_dota_hero_luna_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_luna_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_luna_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_luna_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_luna_2:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_luna_2:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_luna_2:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_heroTalent_npc_dota_hero_luna_2:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	
		if not self:GetParent():IsRealHero() then
			return false
		end

		local caster = keys.attacker
		if not caster:IsRangedAttacker() then
			return
		end
		if caster:IsDisableSplit() or not caster:IsApplyModifier() then
			return
		end
		if caster:IsInSpecialAttack() then return end
		
		local damage = keys.damage
		if damage<=10 then
			return
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false)
		
		local target
		for _, unit in ipairs(enemies) do
			target=unit
			break
		end

		local count = self:GetAbility():GetSpecialValueFor("count")
		if self:GetAbility():Chaotic_era() then
			count = 1
		end
		if target then
			self:GetAbility():GlaiveAttck(keys.target,target,count)
		end
	end
end
