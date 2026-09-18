
-- OMNI SLASH --
chaotic_Omni_Slash = chaotic_Omni_Slash or class({})
LinkLuaModifier("modifier_chaotic_Omni_Slash_caster", "chaotic_spell/class_6/chaotic_Omni_Slash", LUA_MODIFIER_MOTION_NONE)

function chaotic_Omni_Slash:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end

function chaotic_Omni_Slash:OnOwnerSpawned()
	self:OnOwnerDied()
end

function chaotic_Omni_Slash:OnUpgrade()
	if self:GetCaster():FindAbilityByName("chaotic_Omni_Slash"):GetLevel() == 1 then
		self.omnislash_kill_count = 0
	end
end

function chaotic_Omni_Slash:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	local im_the_juggernaut_lich = 10
	local ryujinnokenwokurae = 10
	
	if caster:GetName() == "npc_dota_hero_juggernaut" then
		if RollPercentage(im_the_juggernaut_lich) then
			caster:EmitSound("juggernaut_jug_rare_17")
		elseif RollPercentage(im_the_juggernaut_lich) then
			caster:EmitSound("Imba.JuggernautGenji")
		else
			caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
		end
	end
	return true
end

function chaotic_Omni_Slash:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	self.previous_position = self.caster:GetAbsOrigin()
	
    local omnislash_modifier_handler

    omnislash_modifier_handler = self.caster:AddNewModifier(self.caster, self, "modifier_chaotic_Omni_Slash_caster", {duration = self:GetSpecialValueFor("duration")})

    if omnislash_modifier_handler then
        omnislash_modifier_handler.original_caster = self.caster
    end

    self:SetActivated(false)
    FindClearSpaceForUnit(self.caster, self.target:GetAbsOrigin() + RandomVector(128), false)
	self.current_position = self.caster:GetAbsOrigin()

    self.caster:EmitSound("Hero_Juggernaut.OmniSlash")
    local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
    ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
    ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
    ParticleManager:ReleaseParticleIndex(trail_pfx)
end
----------------------------------------------------------

modifier_chaotic_Omni_Slash_caster = modifier_chaotic_Omni_Slash_caster or class({})

function modifier_chaotic_Omni_Slash_caster:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.last_enemy = nil

	if not self:GetAbility() then
		self:SafeDestroy()
		return nil
	end

	self.slash = true
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				
				self.bounce_range = self:GetAbility():GetSpecialValueFor("omni_slash_radius") --搜寻范围
				if self:GetAbility():GetRuneType() == 1 then
					self.bounce_range = self:GetAbility():GetSpecialValueFor("rune_1_radius")
				end
		
				self:GetAbility():SetRefCountsModifiers(false)
				local rate = self.caster:GetSecondsPerAttack(false) / (1+self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")*0.01)

				self:StartIntervalThink(rate)
				self:BounceAndSlaughter(true)
			end
		end)
	end
end

function modifier_chaotic_Omni_Slash_caster:OnIntervalThink()

	self:BounceAndSlaughter()
	
	local slash_rate = (self.caster:GetSecondsPerAttack(false) / (1+self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")*0.01))

	self:StartIntervalThink(-1)
	self:StartIntervalThink(slash_rate)
end

function modifier_chaotic_Omni_Slash_caster:BounceAndSlaughter(first_slash)
	local order = FIND_ANY_ORDER
	
	if first_slash then
		order = FIND_CLOSEST
	end
	
	self.nearby_enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.bounce_range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		order,
		false
	)
	
	if #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do
			local previous_position = self.parent:GetAbsOrigin()
			FindClearSpaceForUnit(self.parent, enemy:GetAbsOrigin() + RandomVector(100), false)
			
			if not self:GetAbility() then break end

			local current_position = self.parent:GetAbsOrigin()

			self.parent:FaceTowards(enemy:GetAbsOrigin())
			
			AddFOWViewer(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), 200, 1, false)

			self.slash = true
			

			self.parent:PerformAttack(enemy, true, true, true, true, true, false, false)
			self.parent:StartGesture(ACT_DOTA_ATTACK)

			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:SetParticleControl(hit_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.parent)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			if self.last_enemy ~= enemy then
				local dash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_dash.vpcf", PATTACH_ABSORIGIN, self.parent)
				ParticleManager:SetParticleControl(dash_pfx, 0, previous_position)
				ParticleManager:SetParticleControl(dash_pfx, 2, current_position)
				ParticleManager:ReleaseParticleIndex(dash_pfx)
			end

			self.last_enemy = enemy
			break
		end
	else
		if self:GetAbility():GetRuneType() == 1 then
			local time = self:GetRemainingTime()
			local max_time = self:GetAbility():GetSpecialValueFor("duration")
			local used_time_pct = 1-time/max_time
			local newcooldown = self:GetAbility():GetCooldownTimeRemaining()*(used_time_pct)
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(newcooldown)
		end
		self:SafeDestroy()
	end
end

function modifier_chaotic_Omni_Slash_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_chaotic_Omni_Slash_caster:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
	}
end
function modifier_chaotic_Omni_Slash_caster:CheckState()
	local state = {[MODIFIER_STATE_INVULNERABLE] = true,
				[MODIFIER_STATE_UNSELECTABLE] = true,
				[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
				[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				[MODIFIER_STATE_NO_HEALTH_BAR] = true,
				[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
				[MODIFIER_STATE_NO_TEAM_SELECT] = true,
				[MODIFIER_STATE_DISARMED] = true,}

	return state
end


function modifier_chaotic_Omni_Slash_caster:GetModifierPreAttack_BonusDamage(kv)
	if not self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack")
	end
	return
end

function modifier_chaotic_Omni_Slash_caster:GetModifierAttackSpeedBonus_Constant(kv)
	if not self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
	return
end

function modifier_chaotic_Omni_Slash_caster:Advanced_GetModifierAttackArmor_Ignore(kv)
	if not self:GetParent():IsRangedAttacker() then
		return 60
	end
	return
end

function modifier_chaotic_Omni_Slash_caster:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_chaotic_Omni_Slash_caster:OnDestroy()
	
	if IsServer() then
		if self:GetAbility()then
			self:GetAbility():SetActivated(true)
		end
		
		self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())
	end
end
