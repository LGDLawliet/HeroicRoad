Primary_Death_Pulse = Primary_Death_Pulse or class({})

function Primary_Death_Pulse:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus()
end

function Primary_Death_Pulse:OnSpellStart()

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	caster:EmitSound("Hero_Necrolyte.DeathPulse")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		self:ReleaseProjectile(caster,enemy,1)
	end

	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		self:ReleaseProjectile(caster,ally,0)
	end
end

function Primary_Death_Pulse:ReleaseProjectile(srouce,target,state)
	local projectile =
		{
			Target = target,
			Source = srouce,
			Ability = self,
			EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			flExpireTime = GameRules:GetGameTime() + 60,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			ExtraData = {state =state}
	}
	ProjectileManager:CreateTrackingProjectile(projectile)
end


function Primary_Death_Pulse:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()
		if not target or target:IsNull() then
			return
		end
		if extraData.state ==1  then
			local damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage"))
			local poison = target:FindModifierByName("modifier_hd_poison")
			if poison then
				damage = damage * (1+self:GetSpecialValueFor("poison_extra")*0.01)
			end

			ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
			return
		end

		if extraData.state ==0  then
			local heal = self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage"))
			local healing = HealWithGain(heal,caster,target,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
		end
	end
end
