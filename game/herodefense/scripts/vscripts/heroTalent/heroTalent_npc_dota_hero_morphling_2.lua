
heroTalent_npc_dota_hero_morphling_2 = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_morphling_2_motion", "heroTalent/heroTalent_npc_dota_hero_morphling_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade", "heroTalent/heroTalent_npc_dota_hero_morphling_2", LUA_MODIFIER_MOTION_NONE)

-- require("internal/abilitychargecontroller")
function heroTalent_npc_dota_hero_morphling_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_morphling_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_morphling_2:IsStealable() 			return true end
function heroTalent_npc_dota_hero_morphling_2:IsNetherWardStealable()	return true end


------------------------------------------------------------------------------------------------------------------------------------------
function heroTalent_npc_dota_hero_morphling_2:GetCastRange(location , target)
	if IsClient() then
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end
-- wave_1
function heroTalent_npc_dota_hero_morphling_2:Unlockachievement()
	-- print("好的")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_morphling_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("wave_1")
		end
	end

end
function heroTalent_npc_dota_hero_morphling_2:Spawn()
	if IsServer() then
		self.wave_duration = self:GetSpecialValueFor("duration")
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"wave_1") then
			-- print("获得奖励")
			self.wave_duration = self.wave_duration + 1.5
		end
	end
end
function heroTalent_npc_dota_hero_morphling_2:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = (target_pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = math.min(self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus(),2000)
	local speed = 1500

	local pos = ((target_pos - caster_pos):Length2D() <= range) and target_pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_morphling_2_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	
	caster:EmitSound("Hero_Morphling.Waveform")
	ProjectileManager:ProjectileDodge(caster)
end

modifier_heroTalent_npc_dota_hero_morphling_2_motion = class({})

function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsStunDebuff()		return true end
--状态无敌
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:CheckState() 
	return 
	{[MODIFIER_STATE_ROOTED] = true,
	 [MODIFIER_STATE_DISARMED] = true,
	 [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true ,
	 [MODIFIER_STATE_INVULNERABLE] = true ,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

function modifier_heroTalent_npc_dota_hero_morphling_2_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:GetModifierDisableTurning() return 1 end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:IsMotionController() return true end
function modifier_heroTalent_npc_dota_hero_morphling_2_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_heroTalent_npc_dota_hero_morphling_2_motion:OnCreated(keys)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	self.wave_duration = ability:GetSpecialValueFor("duration")
	if IsServer() then
		local gain = self:GetCaster():GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade", {duration = self.wave_duration*gain})

		self.hitted = {}
		self.hitted_friendly = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed = 1500
		self.damageTable = {
			attacker = self:GetParent(),
			damage = self:GetAbility():GetSpecialValueFor("damage")*0.01* self:GetCaster():GetAverageTrueAttackDamage(nil),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
------------------------------------------------------------------------------------------------------------------------------------------
			--特效
			local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
			--local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			local pfx_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetUpVector() * 50
			ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
			ParticleManager:SetParticleControl(self.pfx, 1, (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.speed)
			self:AddParticle(self.pfx, false, false, 15, false, false)
------------------------------------------------------------------------------------------------------------------------------------------
		else
			self:SafeDestroy()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_2_motion:OnIntervalThink()
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	local width = 300
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	--local enemies = FindUnitsInRadius(

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
		nil, width,
		 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  DOTA_UNIT_TARGET_FLAG_NONE,
		   FIND_ANY_ORDER, false)
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
		   nil, width,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, false)
	
	----------------------------------------
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local gain = self:GetCaster():GetModifierDurationGainIndex(1)
	self.wave_duration = ability:GetSpecialValueFor("duration")
	table.insert(self.hitted_friendly,caster)
	for _, unit in pairs(units) do
		if not IsInTable(unit, self.hitted_friendly) then
			unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade", {duration=self.wave_duration*gain})
			--caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade", {duration = self.wave_duration*gain})
			table.insert(self.hitted_friendly,unit)
		end
	end
	--------------------------------------------------
	-- local damage = self:GetAbility():GetSpecialValueFor("damage" ) * self:GetCaster():GetBaseDamageMax()
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			if not enemy:IsMagicImmune() then 
				--造成伤害
				self.damageTable.victim = enemy
				-- self.damageTable.damage = damage
				ApplyDamage(self.damageTable)
				table.insert(self.hitted,enemy)
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_2_motion:OnDestroy() 
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.hitted = nil
		self.pos = nil
		self.speed = nil
		self:GetParent():SetForwardVector(Vector(self:GetParent():GetForwardVector()[1], self:GetParent():GetForwardVector()[2], 0))
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self:GetCaster():StartGesture(ACT_WAVEFORM_END)

	end
end



modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:IsPurgeException() 	return false end

function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:GetTexture()
    return "morphling_waveform"
end

function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:DeclareFunctions() return 
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	} 
end



function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:GetModifierAttackSpeedBonus_Constant() 
	if self:GetParent():IsHero() then
    	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")* self:GetStackCount()
	end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")* self:GetStackCount()*0.1
end

function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:GetModifierMoveSpeedBonus_Constant() 
    return self:GetAbility():GetSpecialValueFor("bonus_move_speed")* self:GetStackCount()
end




function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		if self:GetParent()==self:GetCaster() then
			if self:GetStackCount()>=5 then
				self:GetAbility():Unlockachievement()
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_2_Upgrade:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end






















