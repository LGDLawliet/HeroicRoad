-- LinkLuaModifier("modifier_Primary_Spectral_Dagger", "skills/Primary_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_Primary_Spectral_Dagger_path", "skills/Primary_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_Spectral_Dagger_in_path", "skills/Primary_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)

-- --Abilities
-- if Primary_Spectral_Dagger == nil then
-- 	Primary_Spectral_Dagger = class({})
-- end

-- function Primary_Spectral_Dagger:OnSpellStart()
-- 	local tHashtable = CreateHashtable()

-- 	tHashtable.hCaster = self:GetCaster()

-- 	tHashtable.damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetAgility()*self:GetSpecialValueFor("bonus_damage")
-- 	tHashtable.bonus_movespeed = self:GetSpecialValueFor("bonus_movespeed")
-- 	tHashtable.dagger_path_duration = self:GetSpecialValueFor("dagger_path_duration")
-- 	tHashtable.hero_path_duration = self:GetSpecialValueFor("hero_path_duration")
-- 	tHashtable.buff_persistence = self:GetSpecialValueFor("buff_persistence")
-- 	tHashtable.dagger_radius = self:GetSpecialValueFor("dagger_radius")
-- 	tHashtable.path_radius = self:GetSpecialValueFor("path_radius")

-- 	tHashtable.speed = self:GetSpecialValueFor("speed")
-- 	tHashtable.dagger_grace_period = self:GetSpecialValueFor("dagger_grace_period")

-- 	tHashtable.fDistance = math.max(self:GetCastRange(self:GetCursorPosition(), self:GetCursorTarget()) + tHashtable.hCaster:GetCastRangeBonus(),100)
-- 	tHashtable.vStartPosition = tHashtable.hCaster:GetAbsOrigin()

-- 	tHashtable.hCaster:EmitSound("Hero_Spectre.DaggerCast")
-- 	tHashtable.tTargets = {}
-- 	tHashtable.tAuraPositions = {}
-- 	tHashtable.tAuraPositionsTime = {}
-- 	tHashtable.hAura = CreateModifierThinker(tHashtable.hCaster, self, "modifier_Primary_Spectral_Dagger_path", {hashtable_index = GetHashtableIndex(tHashtable)}, tHashtable.vStartPosition, tHashtable.hCaster:GetTeamNumber(), false)
-- 	self:AddShadow(tHashtable, tHashtable.vStartPosition, tHashtable.dagger_path_duration)

-- 	if self:GetCursorTarget() ~= nil then
-- 		local tInfo =
-- 		{
-- 			Ability = self,
-- 			EffectName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_spectre/spectre_spectral_dagger_tracking.vpcf", tHashtable.hCaster),
-- 			vSourceLoc = tHashtable.vStartPosition,
-- 			iMoveSpeed = tHashtable.speed,
-- 			Target = self:GetCursorTarget(),
-- 			Source = tHashtable.hCaster,
-- 			bDodgeable = false,
-- 			bProvidesVision = true,
-- 			iVisionTeamNumber = tHashtable.hCaster:GetTeamNumber(),
-- 			iVisionRadius = 0,
-- 			ExtraData =
-- 			{
-- 				hashtable_index = GetHashtableIndex(tHashtable),
-- 			}
-- 		}
-- 		ProjectileManager:CreateTrackingProjectile(tInfo)
-- 	else
-- 		local target_pos = self:GetCursorPosition() 
-- 		if target_pos == tHashtable.vStartPosition then
-- 			target_pos = target_pos + self:GetCaster():GetForwardVector()
-- 		end
-- 		local vDirection = target_pos - tHashtable.vStartPosition
-- 		vDirection.z = 0

-- 		local tInfo = {
-- 			Ability = self,
-- 			EffectName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_spectre/spectre_spectral_dagger.vpcf", tHashtable.hCaster),
-- 			vSpawnOrigin = tHashtable.vStartPosition,
-- 			vVelocity = vDirection:Normalized() * tHashtable.speed,
-- 			fDistance = tHashtable.fDistance,
-- 			Source = tHashtable.hCaster,
-- 			bProvidesVision = true,
-- 			iVisionTeamNumber = tHashtable.hCaster:GetTeamNumber(),
-- 			iVisionRadius = 0,
-- 			ExtraData =
-- 			{
-- 				hashtable_index = GetHashtableIndex(tHashtable),
-- 			}
-- 		}
-- 		ProjectileManager:CreateLinearProjectile(tInfo)
-- 	end
-- end
-- function Primary_Spectral_Dagger:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
-- 	local tHashtable = GetHashtableByIndex(ExtraData.hashtable_index)

-- 	return false
-- end
-- function Primary_Spectral_Dagger:OnProjectileThink_ExtraData(vLocation, ExtraData)
-- 	local tHashtable = GetHashtableByIndex(ExtraData.hashtable_index)

-- 	self:AddShadow(tHashtable, vLocation, tHashtable.dagger_path_duration)


-- 	local tTargets = FindUnitsInRadius(tHashtable.hCaster:GetTeamNumber(), vLocation, nil, tHashtable.dagger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
-- 	for n, hTarget in pairs(tTargets) do
-- 		if IsValid(hTarget) and hTarget ~= tHashtable.hCaster and TableFindKey(tHashtable.tTargets, hTarget) == nil then
-- 			if hTarget:IsConsideredHero() then
-- 				hTarget:AddNewModifier(tHashtable.hCaster, self, "modifier_Primary_Spectral_Dagger", {duration=tHashtable.hero_path_duration, hashtable_index=ExtraData.hashtable_index})
-- 			end

-- 			local damage_table =
-- 			{
-- 				ability = self,
-- 				attacker = tHashtable.hCaster,
-- 				victim = hTarget,
-- 				damage = tHashtable.damage,
-- 				damage_type = self:GetAbilityDamageType()
-- 			}
-- 			local damage = ApplyDamage(damage_table)


-- 			table.insert(tHashtable.tTargets, hTarget)
-- 		end
-- 	end
-- end
-- function Primary_Spectral_Dagger:AddShadow(tHashtable, vLocation, duration)
-- 	local fTime = GameRules:GetGameTime() + duration
-- 	local bUpdate = false
-- 	for i = #tHashtable.tAuraPositions, 1, -1 do
-- 		if tHashtable.tAuraPositions[i] == vLocation then
-- 			tHashtable.tAuraPositionsTime[i] = fTime  --设置路径的存续时间
-- 			bUpdate = true
-- 		end
-- 	end
-- 	if not bUpdate then
-- 		table.insert(tHashtable.tAuraPositions, vLocation)
-- 		table.insert(tHashtable.tAuraPositionsTime, fTime)
-- 	end
-- 	if tHashtable.timer_str == nil then
-- 		tHashtable.timer_str = DoUniqueString("Primary_Spectral_Dagger")
-- 		self:SetContextThink(tHashtable.timer_str, function()
-- 			local fTime = GameRules:GetGameTime()
-- 			for i = #tHashtable.tAuraPositions, 1, -1 do
-- 				if fTime > tHashtable.tAuraPositionsTime[i] then
-- 					table.remove(tHashtable.tAuraPositions, i)
-- 					table.remove(tHashtable.tAuraPositionsTime, i)
-- 				end
-- 			end
-- 			if #tHashtable.tAuraPositions == 0 then
-- 				tHashtable.hAura:FindModifierByName("modifier_Primary_Spectral_Dagger_path"):SafeDestroy()
-- 				RemoveHashtable(tHashtable)
-- 				return nil
-- 			end
-- 			return 0
-- 		end, 0)
-- 	end
-- end
-- function Primary_Spectral_Dagger:IsHiddenWhenStolen()
-- 	return false
-- end
-- ---------------------------------------------------------------------
-- --Modifiers 给主目标添加的状态 移动时候会产生路径 虽然不是很需要 还是放着吧
-- if modifier_Primary_Spectral_Dagger == nil then
-- 	modifier_Primary_Spectral_Dagger = class({})
-- end
-- function modifier_Primary_Spectral_Dagger:IsHidden()return true end
-- function modifier_Primary_Spectral_Dagger:IsDebuff()return true end
-- function modifier_Primary_Spectral_Dagger:IsPurgable()return false end
-- function modifier_Primary_Spectral_Dagger:IsPurgeException()return false end
-- function modifier_Primary_Spectral_Dagger:IsStunDebuff()return false end
-- function modifier_Primary_Spectral_Dagger:AllowIllusionDuplicate()return false end
-- function modifier_Primary_Spectral_Dagger:GetEffectName()return "particles/units/heroes/hero_spectre/spectre_shadow_path_owner.vpcf" end
-- function modifier_Primary_Spectral_Dagger:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Primary_Spectral_Dagger:OnCreated(params)
-- 	if IsServer() then
-- 		self.tHashtable = GetHashtableByIndex(params.hashtable_index)

-- 		self:GetAbility():AddShadow(self.tHashtable, self:GetParent():GetAbsOrigin(), self.tHashtable.hero_path_duration)
		
-- 		self.vPosition = self:GetParent():GetAbsOrigin()

-- 		self:StartIntervalThink(0)
-- 	end
-- end
-- function modifier_Primary_Spectral_Dagger:OnIntervalThink()
-- 	if IsServer() then
-- 		if (self:GetParent():GetAbsOrigin() - self.vPosition):Length2D() > self.tHashtable.speed/30 then
-- 			self:GetAbility():AddShadow(self.tHashtable, self:GetParent():GetAbsOrigin(), self.tHashtable.hero_path_duration)
			
-- 			self.vPosition = self:GetParent():GetAbsOrigin()
-- 		end
-- 	end
-- end
-- function modifier_Primary_Spectral_Dagger:CheckState()
-- 	return {
-- 		[MODIFIER_STATE_PROVIDES_VISION] = true,
-- 	}
-- end
-- ---------------------------------------------------------------------
-- --路径的buff
-- if modifier_Primary_Spectral_Dagger_path == nil then
-- 	modifier_Primary_Spectral_Dagger_path = class({})
-- end
-- function modifier_Primary_Spectral_Dagger_path:IsHidden()return true end
-- function modifier_Primary_Spectral_Dagger_path:IsDebuff()return false end
-- function modifier_Primary_Spectral_Dagger_path:IsPurgable()return false end
-- function modifier_Primary_Spectral_Dagger_path:IsPurgeException()return false end
-- function modifier_Primary_Spectral_Dagger_path:IsStunDebuff()return false end
-- function modifier_Primary_Spectral_Dagger_path:AllowIllusionDuplicate()return false end
-- function modifier_Primary_Spectral_Dagger_path:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
-- end
-- function modifier_Primary_Spectral_Dagger_path:IsAura()return true end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraEntityReject(hEntity)
-- 	if IsValid(self:GetCaster()) then
-- 		local ability = self:GetAbility()
-- 		if not ability then
-- 			self:SafeDestroy()
-- 			return
-- 		end
-- 		for n, vPosition in pairs(self.tHashtable.tAuraPositions) do
-- 			if hEntity:IsPositionInRange(vPosition, self.tHashtable.path_radius) then
-- 				local modifier = hEntity:FindModifierByName("modifier_Primary_Spectral_Dagger_in_path")
-- 				if modifier then
-- 					modifier:SetDuration(self.tHashtable.buff_persistence,true)
-- 				else
-- 					hEntity:AddNewModifier(self:GetCaster(), ability, "modifier_Primary_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				end
-- 				return true
-- 			end
-- 		end
-- 	end
-- 	return true
-- end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraDuration()return 1 end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraRadius()return 3000 end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_BOTH end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_Primary_Spectral_Dagger_path:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_Primary_Spectral_Dagger_path:GetModifierAura()return "modifier_spectre_spectral_dagger_path" end
-- function modifier_Primary_Spectral_Dagger_path:OnCreated(params)
-- 	if IsServer() then
-- 		self.tHashtable = GetHashtableByIndex(params.hashtable_index)
-- 		-- self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_persistence")
-- 	end
-- end
-- function modifier_Primary_Spectral_Dagger_path:OnDestroy()
-- 	if IsServer() then
-- 		self:GetParent():RemoveSelf()
-- 	end
-- end
-- ---------------------------------------------------------------------
-- if modifier_Primary_Spectral_Dagger_in_path == nil then
-- 	modifier_Primary_Spectral_Dagger_in_path = class({})
-- end
-- function modifier_Primary_Spectral_Dagger_in_path:IsHidden()return false end
-- function modifier_Primary_Spectral_Dagger_in_path:IsDebuff()return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end
-- function modifier_Primary_Spectral_Dagger_in_path:IsPurgable()return false end
-- function modifier_Primary_Spectral_Dagger_in_path:IsPurgeException()return false end
-- function modifier_Primary_Spectral_Dagger_in_path:IsStunDebuff()return false end
-- function modifier_Primary_Spectral_Dagger_in_path:AllowIllusionDuplicate()return false end
-- function modifier_Primary_Spectral_Dagger_in_path:CheckState()
-- 	local state = {}
	
-- 	if self:GetParent()==self:GetCaster() then
-- 		state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
-- 	end

-- 	return state

-- end
-- -- function modifier_Primary_Spectral_Dagger_in_path:GetAttributes()
-- -- 	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
-- -- end
-- function modifier_Primary_Spectral_Dagger_in_path:OnCreated(table)
-- 	self.value = self:GetAbility():GetSpecialValueFor("bonus_movespeed") 
-- end
-- function modifier_Primary_Spectral_Dagger_in_path:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

-- 	}
-- end
-- function modifier_Primary_Spectral_Dagger_in_path:GetModifierMoveSpeedBonus_Constant(params)
	
-- 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
-- 		return -self.value
-- 	end
-- 	return self.value
-- end




