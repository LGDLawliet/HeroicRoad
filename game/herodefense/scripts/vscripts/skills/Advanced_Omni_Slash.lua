--特效优化 √
Advanced_Omni_Slash = Advanced_Omni_Slash or class({})
LinkLuaModifier("modifier_Advanced_Omni_Slash_caster", "skills/Advanced_Omni_Slash", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Omni_Slash_transfer", "skills/Advanced_Omni_Slash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Omni_Slash_debuff", "skills/Advanced_Omni_Slash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Omni_Slash_double", "skills/Advanced_Omni_Slash", LUA_MODIFIER_MOTION_NONE)

function Advanced_Omni_Slash:CheckKV(key)
	local table = {

	


		duration = 0.06,




	}
	if self:GetUnlock(3)==3 then
		table.attack_rate_multiplier = 0.02
	end
	local value = table[key] or -1
	return value

end

function Advanced_Omni_Slash:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Omni_Slash:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Omni_Slash:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_feast_unlock3",{})
	return true

end


-- DOTA_ABILITY_BEHAVIOR_UNIT_TARGET| DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
function Advanced_Omni_Slash:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end
end

function Advanced_Omni_Slash:IsNetherWardStealable() return false end


function Advanced_Omni_Slash:GetIntrinsicModifierName()
	return	"modifier_Advanced_Omni_Slash_transfer"
end

function Advanced_Omni_Slash:IsHiddenWhenStolen()return false end

-- Grimstroke edge case (really should be cleaner than this but...yeah)
function Advanced_Omni_Slash:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end



function Advanced_Omni_Slash:OnOwnerSpawned()
	self:OnOwnerDied()
end


function Advanced_Omni_Slash:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	local im_the_juggernaut_lich = 10

	
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

function Advanced_Omni_Slash:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	if self.target:TriggerSpellAbsorb(self) then
		return
	end
	self.previous_position = self.caster:GetAbsOrigin()
	
	-- ". . . and applies a basic dispel on cast."
	self.caster:Purge(false, true, false, false, false)
	
    -- local omnislash_modifier_handler

	local ModifierStatusGain = self.caster:GetModifierDurationGainIndex(0.2)
	local duration =  self:GetSpecialValueFor("duration")
	--LV15解锁剑法精研
	if self.advanced_level>=15 then
		duration = duration + self.caster:GetDamageMax()*0.003
	end

    self.caster:AddNewModifier(self.caster, self, "modifier_Advanced_Omni_Slash_caster", {duration =duration*ModifierStatusGain})


    -- if omnislash_modifier_handler then
    --     omnislash_modifier_handler.original_caster = self.caster
    -- end

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


function Advanced_Omni_Slash:TalentEffect(target,duration)
	local caster = self:GetCaster()
	local unit = caster:CreateDouble(target:GetOrigin(),caster:GetForwardVector())
	unit:AddNewModifier(caster, self, "modifier_Advanced_Omni_Slash_double", {duration=duration})

end




modifier_Advanced_Omni_Slash_caster = modifier_Advanced_Omni_Slash_caster or advanced_modifier({})

function modifier_Advanced_Omni_Slash_caster:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.last_enemy = nil

	self:SetStackCount(40)
	if not self:GetAbility() then
		self:SafeDestroy()
		return nil
	end
	self.transfer = 0       --前次传承值
	self.transferofnow = 0  --当次传承值

	self.slash = true
	self.original_caster = self:GetParent()
	if IsServer() then
		self.timer = 0
		local modifiers = self.caster:FindAllModifiersByName("modifier_Advanced_Omni_Slash_transfer")
		if #modifiers>0 then
			self.transfermodifier = modifiers[1]
		end
		if self.transfermodifier then
			self.transfer = self.transfermodifier:GetStackCount()
		end
		self.bounce_range = self:GetAbility():GetSpecialValueFor("omni_slash_radius") --搜寻范围
		--LV15解锁剑法精研
		if self.advanced_level>=15 then
			self.bounce_range = self.bounce_range+250
		end
		
		self.hero_agility = self.original_caster:GetAgility()
		self:GetAbility():SetRefCountsModifiers(false)
		-- print(self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier"))
		self.rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
		-- print(rate)
		
		-- self:StartIntervalThink(FrameTime())
		
		-- self:BounceAndSlaughter(true)  --先造成一次效果


		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				
				self.bounce_range = self:GetAbility():GetSpecialValueFor("omni_slash_radius") --搜寻范围
				--LV15解锁剑法精研
				if self.advanced_level>=15 then
					self.bounce_range = self.bounce_range+250
				end
				
				self.hero_agility = self.original_caster:GetAgility()
				self:GetAbility():SetRefCountsModifiers(false)
				-- print(self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier"))
				-- local rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
				-- print(rate)
				self:StartIntervalThink(FrameTime())
		
				self:BounceAndSlaughter(true)  --先造成一次效果


			end
		end)
	end
end

function modifier_Advanced_Omni_Slash_caster:OnIntervalThink()
	-- Get the hero Agility while casting Omnislash
	-- self.hero_agility = self.original_caster:GetAgility()
	self.timer = self.timer + FrameTime()
	if self.ability.unlock1 then
		if self.timer>=self.rate then

			local change = math.min(math.floor(self.timer/ self.rate),3)
			self.timer = self.timer -self.rate*change
			for i = 1, change, 1 do
				self:BounceAndSlaughter()
				if self:GetStackCount()>0 then
					self:DecrementStackCount()
					
				end
			end
			
		end
	else
		if self.timer>=self.rate then
			self.timer = self.timer -self.rate
			self:BounceAndSlaughter()
			if self:GetStackCount()>0 then
				--LV5解锁起源+
				if self.advanced_level>=5 then
					self:DecrementStackCount()
				else
					self:DecrementStackCount()
					self:DecrementStackCount()
				end
				
			end
		end
	end

	
	

    --更新攻击速度
	self.rate = (self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")) 

	-- self:StartIntervalThink(-1)
	-- self:StartIntervalThink(slash_rate)
end

function modifier_Advanced_Omni_Slash_caster:BounceAndSlaughter(first_slash)
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
	local ability = self:GetAbility()

	if #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do
			self.transferofnow = self.transferofnow + 1
			local previous_position = self.parent:GetAbsOrigin()
			-- Used to be 128 but it seems to interrupt a lot at fast speeds if there's Lotus battles...
			FindClearSpaceForUnit(self.parent, enemy:GetAbsOrigin() + RandomVector(100), false)

			
			if not ability then break end

			local current_position = self.parent:GetAbsOrigin()

			-- Face the enemy every slash
			self.parent:FaceTowards(enemy:GetAbsOrigin())
			
			-- Provide vision of the target for a short duration
			AddFOWViewer(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), 200, 1, false)

			-- Perform the slash
			self.slash = true
			
			if first_slash and enemy:TriggerSpellAbsorb(ability) then
				break
			else
				if ability.unlock2 then
					enemy:AddNewModifier(self.caster, ability, "modifier_Advanced_Omni_Slash_debuff", {duration =0.01})
					self.parent:PerformAttack(enemy, true, true, true, true, true, false, false)
				else
					self.parent:PerformAttack(enemy, true, true, true, true, true, false, false)

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

function modifier_Advanced_Omni_Slash_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_Advanced_Omni_Slash_caster:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount()*5
end
function modifier_Advanced_Omni_Slash_caster:Advanced_GetModifierIncomingDamage_Percentage()
	return -100
end




function modifier_Advanced_Omni_Slash_caster:GetModifierAttackSpeedBonus_Constant() return (self.transfer*5) end
function modifier_Advanced_Omni_Slash_caster:GetAttributes()
	if IsServer() and self:GetAbility().unlock3 then
		return MODIFIER_ATTRIBUTE_MULTIPLE
	end
end
function modifier_Advanced_Omni_Slash_caster:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	if self:GetAbility():GetUnlock(3)==3 then
		state = {
			-- [MODIFIER_STATE_INVULNERABLE] = true,
			-- [MODIFIER_STATE_UNSELECTABLE] = true,
			-- [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,

		}
	end

	return state
end


function modifier_Advanced_Omni_Slash_caster:GetModifierPreAttack_BonusDamage(kv)
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_Advanced_Omni_Slash_caster:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_Advanced_Omni_Slash_caster:OnDestroy()
	if IsServer() then
		self:GetAbility():SetActivated(true)
		if self.transferofnow>self.transfer then
			if self.transferofnow>200 then
				self.transferofnow = 200
			end
			self.transfermodifier:SetStackCount(self.transferofnow)
		elseif self.transfer<200 then
			--LV10解锁传承+
			if self.advanced_level>=10 then
				self.transfermodifier:SetStackCount(self.transfer+2)
			else
				self.transfermodifier:SetStackCount(self.transfer+1)
			end
		end
		
		self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		if self.parent and self:GetAbility() then
			self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())
		end

	end
end


function modifier_Advanced_Omni_Slash_caster:ADDeclareFunctions()
	local funcs = {
		
	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end


	return funcs
end





modifier_Advanced_Omni_Slash_transfer = modifier_Advanced_Omni_Slash_transfer or class({})

function modifier_Advanced_Omni_Slash_transfer:IsHidden() return false end
function modifier_Advanced_Omni_Slash_transfer:IsPurgable() 		return false end
function modifier_Advanced_Omni_Slash_transfer:IsPurgeException() 	return false end
function modifier_Advanced_Omni_Slash_transfer:RemoveOnDeath()  return false end
function modifier_Advanced_Omni_Slash_transfer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Omni_Slash_transfer:OnAttackLanded(keys)
	if IsServer() then
		--LV20解锁幻影剑舞
		local parent = self:GetParent()
		if keys.attacker == parent and self:GetAbility().advanced_level>=20 and 10>=RandomInt(1, 100) then
			if parent:PassivesDisabled() then
				return
			end
			if not self:GetAbility():GetAutoCastState() then
				return
			end

			self:GetAbility().target = keys.target
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Omni_Slash_caster", {duration =0.1})

			self:GetAbility().previous_position = parent:GetAbsOrigin()
			-- if omnislash_modifier_handler then
			-- 	omnislash_modifier_handler.original_caster = parent
			-- end
		
			self:GetAbility():SetActivated(false)
		
		 
		
			FindClearSpaceForUnit(parent, self:GetAbility().target:GetAbsOrigin() + RandomVector(128), false)
		
			parent:EmitSound("Hero_Juggernaut.OmniSlash")
			self:GetAbility().current_position = parent:GetAbsOrigin()

			local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self:GetAbility().caster)
			ParticleManager:SetParticleControl(trail_pfx, 0, self:GetAbility().previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, self:GetAbility().current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)
		end
	end
end






modifier_Advanced_Omni_Slash_debuff = advanced_modifier({})

function modifier_Advanced_Omni_Slash_debuff:IsDebuff() return true end
function modifier_Advanced_Omni_Slash_debuff:IsHidden() return true end
function modifier_Advanced_Omni_Slash_debuff:IsPurgable() return false end

function modifier_Advanced_Omni_Slash_debuff:Advanced_GetModifierPhysicalArmorBonus() 
	if IsServer() then
		return -1000 	
	end
end

function modifier_Advanced_Omni_Slash_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end



modifier_Advanced_Omni_Slash_double = modifier_Advanced_Omni_Slash_double or class({})

function modifier_Advanced_Omni_Slash_double:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.last_enemy = nil
	self.slash = true
	if IsServer() then
		self.timer = 0
		self.rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				self.bounce_range = 500
				-- local rate = self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")
				self:StartIntervalThink(FrameTime())
				self:BounceAndSlaughter(true) 

			end
		end)
	end
end

function modifier_Advanced_Omni_Slash_double:OnIntervalThink()
	self.timer = self.timer + FrameTime()
	if self.timer>=self.rate then
		self.timer = self.timer -self.rate
		self:BounceAndSlaughter()
	end


	self.rate = (self.caster:GetSecondsPerAttack(false) / self:GetAbility():GetSpecialValueFor("attack_rate_multiplier")) 

end

function modifier_Advanced_Omni_Slash_double:BounceAndSlaughter(first_slash)
	local order = FIND_ANY_ORDER
	
	if first_slash then
		order = FIND_CLOSEST
	end
	if not self.parent or self.parent:IsNull() then
		self:SafeDestroy()
		return
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
				local attackEffectRecord = self.caster:AddAttackEffectModifier( self.ability,modifier_keys)
				if self.ability.unlock2 then
					enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Omni_Slash_debuff", {duration =0.01})
					self.caster:PerformAttack(enemy, true, true, true, true, true, false, false)
				else
					self.caster:PerformAttack(enemy, true, true, true, true, true, false, false)

				end
				
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

function modifier_Advanced_Omni_Slash_double:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_Advanced_Omni_Slash_double:CheckState()
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



function modifier_Advanced_Omni_Slash_double:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_Advanced_Omni_Slash_double:OnDestroy()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove( self:GetParent() )
	end
end
