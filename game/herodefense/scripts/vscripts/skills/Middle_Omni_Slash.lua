
-- OMNI SLASH --
Middle_Omni_Slash = Middle_Omni_Slash or class({})
LinkLuaModifier("modifier_Middle_Omni_Slash_caster", "skills/Middle_Omni_Slash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Omni_Slash_origin", "skills/Middle_Omni_Slash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Omni_Slash_double", "skills/Middle_Omni_Slash", LUA_MODIFIER_MOTION_NONE)

function Middle_Omni_Slash:IsNetherWardStealable() return false end




function Middle_Omni_Slash:IsHiddenWhenStolen()return false end

-- Grimstroke edge case (really should be cleaner than this but...yeah)
function Middle_Omni_Slash:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end



function Middle_Omni_Slash:OnOwnerSpawned()
	self:OnOwnerDied()
end

function Middle_Omni_Slash:OnUpgrade()
	if self:GetCaster():FindAbilityByName("Middle_Omni_Slash"):GetLevel() == 1 then
		self.omnislash_kill_count = 0
	end
	
	-- For vanilla Swift Slash
	if self:GetCaster():HasAbility("juggernaut_omni_slash") then
		self:GetCaster():FindAbilityByName("juggernaut_omni_slash"):SetLevel(self:GetLevel())
	end
end

function Middle_Omni_Slash:OnAbilityPhaseStart()
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

function Middle_Omni_Slash:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	if self.target:TriggerSpellAbsorb(self) then
		return
	end
	self.previous_position = self.caster:GetAbsOrigin()
	
	-- ". . . and applies a basic dispel on cast."
	self.caster:Purge(false, true, false, false, false)
	
    local omnislash_modifier_handler

	local ModifierStatusGain = self.caster:GetModifierDurationGainIndex(0.2)
    omnislash_modifier_handler = self.caster:AddNewModifier(self.caster, self, "modifier_Middle_Omni_Slash_caster", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})


    if omnislash_modifier_handler then
        omnislash_modifier_handler.original_caster = self.caster
    end

    self:SetActivated(false)

 

    FindClearSpaceForUnit(self.caster, self.target:GetAbsOrigin() + RandomVector(128), false)

    self.caster:EmitSound("Hero_Juggernaut.OmniSlash")
    -- StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
    self.current_position = self.caster:GetAbsOrigin()

    -- Play particle trail when moving
    local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
    ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
    ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
    ParticleManager:ReleaseParticleIndex(trail_pfx)
end

function Middle_Omni_Slash:TalentEffect(target,duration)
	local caster = self:GetCaster()
	local unit = caster:CreateDouble(target:GetOrigin(),caster:GetForwardVector())
	unit:AddNewModifier(caster, self, "modifier_Middle_Omni_Slash_double", {duration=duration})

end



modifier_Middle_Omni_Slash_caster = modifier_Middle_Omni_Slash_caster or class({})

function modifier_Middle_Omni_Slash_caster:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.last_enemy = nil

	self:SetStackCount(20)
	if not self:GetAbility() then
		self:SafeDestroy()
		return nil
	end

	self.slash = true
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				
				self.bounce_range = self:GetAbility():GetSpecialValueFor("omni_slash_radius") --搜寻范围
				
				self.hero_agility = self.original_caster:GetAgility()
				self:GetAbility():SetRefCountsModifiers(false)
				-- print(self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier"))
				local rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
				-- print(rate)
				
				self:StartIntervalThink(rate)
				self:BounceAndSlaughter(true)  --先造成一次效果


			end
		end)
	end
end

function modifier_Middle_Omni_Slash_caster:OnIntervalThink()
	-- Get the hero Agility while casting Omnislash
	-- self.hero_agility = self.original_caster:GetAgility()
	self:BounceAndSlaughter()
	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end
	

    --更新攻击速度
	local slash_rate = (self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")) 

	self:StartIntervalThink(-1)
	self:StartIntervalThink(slash_rate)
end

function modifier_Middle_Omni_Slash_caster:BounceAndSlaughter(first_slash)
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
	
	-- for count = #self.nearby_enemies, 1, -1 do
	-- 	-- "Cannot jump on units in the Fog of War, invisible or hidden units, Tombstone Zombies and on Astral Spirits."
	-- 	if self.nearby_enemies[count] and (self.nearby_enemies[count]:GetName() == "npc_dota_unit_undying_zombie" or self.nearby_enemies[count]:GetName() == "npc_dota_elder_titan_ancestral_spirit") then
	-- 		table.remove(self.nearby_enemies, count)
	-- 	end
	-- end

	if #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do
			local previous_position = self.parent:GetAbsOrigin()
			-- Used to be 128 but it seems to interrupt a lot at fast speeds if there's Lotus battles...
			FindClearSpaceForUnit(self.parent, enemy:GetAbsOrigin() + RandomVector(100), false)
			
			if not self:GetAbility() then break end

			local current_position = self.parent:GetAbsOrigin()

			-- Face the enemy every slash
			self.parent:FaceTowards(enemy:GetAbsOrigin())
			
			-- Provide vision of the target for a short duration
			AddFOWViewer(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), 200, 1, false)

			-- Perform the slash
			self.slash = true
			
			if first_slash and enemy:TriggerSpellAbsorb(self:GetAbility()) then
				break
			else
				self.parent:PerformAttack(enemy, true, true, true, true, true, false, false)
			end

			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:SetParticleControl(hit_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
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
		self:SafeDestroy()
	end
end

function modifier_Middle_Omni_Slash_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_Middle_Omni_Slash_caster:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount()*10
end


function modifier_Middle_Omni_Slash_caster:CheckState()
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


function modifier_Middle_Omni_Slash_caster:GetModifierPreAttack_BonusDamage(kv)
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_Middle_Omni_Slash_caster:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_Middle_Omni_Slash_caster:OnDestroy()
	if IsServer() then
		self:GetAbility():SetActivated(true)
		self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		if self.parent and self:GetAbility() then
			self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())
		end

	end
end








modifier_Middle_Omni_Slash_double = modifier_Middle_Omni_Slash_double or class({})

function modifier_Middle_Omni_Slash_double:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.last_enemy = nil
	self.slash = true
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				self.bounce_range = 500
				local rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
				self:StartIntervalThink(rate)
				self:BounceAndSlaughter(true) 

			end
		end)
	end
end

function modifier_Middle_Omni_Slash_double:OnIntervalThink()
	self:BounceAndSlaughter()
    --更新攻击速度
	local slash_rate = (self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")) 
	self:StartIntervalThink(-1)
	self:StartIntervalThink(slash_rate)
end

function modifier_Middle_Omni_Slash_double:BounceAndSlaughter(first_slash)
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
			-- Used to be 128 but it seems to interrupt a lot at fast speeds if there's Lotus battles...
			FindClearSpaceForUnit(self.parent, enemy:GetAbsOrigin() + RandomVector(100), false)
			
			if not self:GetAbility() then break end

			local current_position = self.parent:GetAbsOrigin()

			-- Face the enemy every slash
			self.parent:FaceTowards(enemy:GetAbsOrigin())
			
			-- Provide vision of the target for a short duration
			AddFOWViewer(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), 200, 1, false)

			-- Perform the slash
			self.slash = true
			if first_slash and enemy:TriggerSpellAbsorb(self:GetAbility()) then
				break
			else
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
			
				local attackEffectRecord = self.caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				self.caster:PerformAttack(enemy, true, true, true, true, true, false, false)
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			
			end
			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:SetParticleControl(hit_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
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
		self:SafeDestroy()
	end
end

function modifier_Middle_Omni_Slash_double:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_Middle_Omni_Slash_double:CheckState()
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



function modifier_Middle_Omni_Slash_double:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_Middle_Omni_Slash_double:OnDestroy()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove( self:GetParent() )
	end
end
