

LinkLuaModifier( "modifier_Middle_Chakra_buff", "skills/Middle_Chakra", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Middle_Chakra_debuff", "skills/Middle_Chakra", LUA_MODIFIER_MOTION_NONE )

Middle_Chakra = class({})

--------------------------------------------------------------------------------
-- Ability Start
function Middle_Chakra:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	local mana_return = self:GetSpecialValueFor("mana_return")+self:GetSpecialValueFor("bonus_mana_return")*caster:GetIntellect(false)
	target:GiveMana(mana_return)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, mana_return, nil)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)


	-- effects
	target:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")

	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_Middle_Chakra_buff", {duration = 10*gain})

	for i=0, target:GetAbilityCount() - 1 do
		local Ability = target:GetAbilityByIndex(i)
		if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
			local time = self:GetSpecialValueFor("cooldown_reduce")
	
			local newCooldown = Ability:GetCooldownTimeRemaining() - time
			Ability:EndCooldown()
			-- Ability:StartCooldown(newCooldown)
			if newCooldown>0 then
				Ability:StartCooldown(newCooldown)
			end
			break
		end
	end







end




modifier_Middle_Chakra_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Chakra_buff:IsHidden()	return false end
function modifier_Middle_Chakra_buff:IsDebuff()	return false end
function modifier_Middle_Chakra_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_INVULNERABLE 
end

function modifier_Middle_Chakra_buff:IsPurgable()	return true end



--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Chakra_buff:OnCreated( kv )
	-- references
	self.cooldown_reduce = 0.5

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_Chakra_buff:OnIntervalThink( kv )


	if IsServer() then
		for i=0, self:GetParent():GetAbilityCount() - 1 do
			local Ability = self:GetParent():GetAbilityByIndex(i)
			if Ability ~= nil and Ability ~= self:GetAbility()  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then

		
				local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduce
				Ability:EndCooldown()
				if newCooldown>0 then
					Ability:StartCooldown(newCooldown)
				end
				
				break
			end
		end
	end
end

-- function modifier_Middle_Chakra_buff:OnRefresh( kv )
-- 	-- references
-- 	self.damage_reduce = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )


	
-- end



-- --------------------------------------------------------------------------------
-- -- Modifier Effects
-- function modifier_Middle_Chakra_buff:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
-- 	}

-- 	return funcs
-- end


-- function modifier_Middle_Chakra_buff:GetModifierIncomingPhysicalDamage_Percentage(keys)
-- 	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
-- 		return self.damage_reduce
-- 	end
-- 	return 0
-- end

-- function modifier_Middle_Chakra_buff:OnIntervalThink()
-- 	local pos = self:GetParent():GetAbsOrigin()
-- 	local caster = self:GetCaster()
-- 	local ability = self:GetAbility()
-- 	local parent = self:GetParent()
-- 	local radius = ability:GetSpecialValueFor("radius")
-- 	caster:EmitSound("Hero_Lich.IceAge.Tick")
-- 	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_WORLDORIGIN, nil )
-- 	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
-- 	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )
-- 	ParticleManager:SetParticleControl( effect_cast, 2, Vector(radius,radius,radius))
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )
-- 	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
-- 	 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
-- 	 local damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
-- 	for _, enemy in pairs(enemies) do
-- 		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 		enemy:AddNewModifier(caster, ability, "modifier_Middle_Chakra_debuff", {duration = ability:GetSpecialValueFor( "slow_duration" )*StatusResistance})
-- 		local damageTable = {
-- 							victim = enemy,
-- 							attacker = caster,
-- 							damage = damage,
-- 							damage_type = ability:GetAbilityDamageType(),
-- 							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
-- 							ability = ability, --Optional.
-- 							}
-- 		ApplyDamage(damageTable)

-- 	end
-- end





-- modifier_Middle_Chakra_debuff = class({})

-- --------------------------------------------------------------------------------
-- -- Classifications
-- function modifier_Middle_Chakra_debuff:IsHidden()	return false end
-- function modifier_Middle_Chakra_debuff:IsDebuff()	return true end
-- function modifier_Middle_Chakra_debuff:IsPurgable()	return true end

-- --------------------------------------------------------------------------------
-- -- Initializations
-- function modifier_Middle_Chakra_debuff:OnCreated( kv )
-- 	self.move_slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
-- end




-- --------------------------------------------------------------------------------
-- -- Modifier Effects
-- function modifier_Middle_Chakra_debuff:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
-- 	}

-- 	return funcs
-- end

-- function modifier_Middle_Chakra_debuff:GetModifierMoveSpeedBonus_Percentage()
-- 	return self.move_slow
-- end

-- --------------------------------------------------------------------------------
-- -- Graphics & Animations
-- function modifier_Middle_Chakra_debuff:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_frost_lich.vpcf"
-- end