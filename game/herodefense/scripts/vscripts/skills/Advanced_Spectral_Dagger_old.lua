-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_energy", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_path", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_in_path", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_in_path_debuff", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- --Abilities

-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_unlock1", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_unlock1_handler", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)



-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_unlock2_mark", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Spectral_Dagger_unlock3", "skills/Advanced_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
-- if Advanced_Spectral_Dagger == nil then
-- 	Advanced_Spectral_Dagger = class({})
-- end

-- function Advanced_Spectral_Dagger:CheckKV(key)
-- 	local table = {
-- 		damage=15,
-- 		bonus_damage=0.1,
-- 		bonus_movespeed=4,

-- 	}
-- 	local value = table[key] or -1
-- 	return value

-- end

-- function Advanced_Spectral_Dagger:UnlockFirstCore(key)
-- 	-- self.unlock1_timer = GameRules:GetGameTime()
-- 	local caster = self:GetCaster()
-- 	caster:AddNewModifier(caster,self,"modifier_Advanced_Spectral_Dagger_unlock1",{})
-- 	return true
-- end
-- function Advanced_Spectral_Dagger:UnlockSecondCore(key)
-- 	self.unlock2Table = {}
-- 	self.HealthData = {}
-- 	-- self.CoreUnlock = false
-- 	return true
-- end
-- function Advanced_Spectral_Dagger:UnlockThirdCore(key)
-- 	local caster = self:GetCaster()
-- 	caster:AddNewModifier(caster,self,"modifier_Advanced_Spectral_Dagger_unlock3",{})
-- 	return true
-- end


-- function Advanced_Spectral_Dagger:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_spectral_dagger_tracking.vpcf", context )
-- 	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_death.vpcf", context )




	
-- end

-- function Advanced_Spectral_Dagger:OnSpellStart()
-- 	local tHashtable = CreateHashtable()
-- 	local level = self.advanced_level

-- 	tHashtable.hCaster = self:GetCaster()

-- 	tHashtable.damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetAgility()*(self:GetSpecialValueFor("bonus_damage"))
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
-- 	tHashtable.hAura = CreateModifierThinker(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger_path", {hashtable_index = GetHashtableIndex(tHashtable)}, tHashtable.vStartPosition, tHashtable.hCaster:GetTeamNumber(), false)
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


-- 	if self.unlock2 then
-- 		-- 清空无效数据
-- 		-- self.unlock2Table = {}
-- 		-- self.HealthData = {}
-- 		for key, value in pairs(self.unlock2Table) do
-- 			if key:IsNull() or not key:IsAlive() then
-- 				print("del")
-- 				self.unlock2Table[key] = nil
-- 			end
-- 		end
-- 		for key, value in pairs(self.HealthData) do
-- 			if key:IsNull() or not key:IsAlive() then
-- 				print("del")
-- 				self.HealthData[key] = nil
-- 			end
-- 		end
-- 	end
-- end

-- function Advanced_Spectral_Dagger:CreateDagger(source,target)

-- 	local tHashtable = CreateHashtable()
-- 	tHashtable.hCaster = self:GetCaster()
-- 	tHashtable.damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetAgility()*(self:GetSpecialValueFor("bonus_damage"))
-- 	tHashtable.bonus_movespeed = self:GetSpecialValueFor("bonus_movespeed")
-- 	tHashtable.dagger_path_duration = self:GetSpecialValueFor("dagger_path_duration")
-- 	tHashtable.hero_path_duration = self:GetSpecialValueFor("hero_path_duration")
-- 	tHashtable.buff_persistence = self:GetSpecialValueFor("buff_persistence")
-- 	tHashtable.dagger_radius = self:GetSpecialValueFor("dagger_radius")
-- 	tHashtable.path_radius = self:GetSpecialValueFor("path_radius")
-- 	tHashtable.speed = self:GetSpecialValueFor("speed")
-- 	tHashtable.dagger_grace_period = self:GetSpecialValueFor("dagger_grace_period")
-- 	tHashtable.fDistance = math.max(self:GetCastRange(self:GetCursorPosition(), self:GetCursorTarget()) + tHashtable.hCaster:GetCastRangeBonus(),100)
-- 	tHashtable.vStartPosition = source:GetAbsOrigin()
-- 	tHashtable.hCaster:EmitSound("Hero_Spectre.DaggerCast")
-- 	tHashtable.tTargets = {}
-- 	tHashtable.tAuraPositions = {}
-- 	tHashtable.tAuraPositionsTime = {}
-- 	tHashtable.hAura = CreateModifierThinker(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger_path", {hashtable_index = GetHashtableIndex(tHashtable)}, tHashtable.vStartPosition, tHashtable.hCaster:GetTeamNumber(), false)
-- 	self:AddShadow(tHashtable, tHashtable.vStartPosition, tHashtable.dagger_path_duration)

-- 	local target_pos = target:GetOrigin()
-- 	if target_pos == tHashtable.vStartPosition then
-- 		target_pos = target_pos + self:GetCaster():GetForwardVector()
-- 	end
-- 	local vDirection = target_pos - tHashtable.vStartPosition
-- 	vDirection.z = 0

-- 	local tInfo = {
-- 		Ability = self,
-- 		EffectName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_spectre/spectre_spectral_dagger.vpcf", tHashtable.hCaster),
-- 		vSpawnOrigin = tHashtable.vStartPosition,
-- 		vVelocity = vDirection:Normalized() * tHashtable.speed,
-- 		fDistance = tHashtable.fDistance,
-- 		Source = source,
-- 		bProvidesVision = true,
-- 		iVisionTeamNumber = tHashtable.hCaster:GetTeamNumber(),
-- 		iVisionRadius = 0,
-- 		ExtraData =
-- 		{
-- 			hashtable_index = GetHashtableIndex(tHashtable),
-- 		}
-- 	}
-- 	ProjectileManager:CreateLinearProjectile(tInfo)
-- end

-- function Advanced_Spectral_Dagger:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
-- 	local tHashtable = GetHashtableByIndex(ExtraData.hashtable_index)

-- 	return false
-- end



-- function Advanced_Spectral_Dagger:OnProjectileThink_ExtraData(vLocation, ExtraData)

-- 	local tHashtable = GetHashtableByIndex(ExtraData.hashtable_index)
-- 	-- print(tHashtable.unlock1timer)
-- 	if tHashtable.unlock1timer and GameRules:GetGameTime()>=tHashtable.unlock1timer then
-- 		ProjectileManager:DestroyTrackingProjectile(tHashtable.traciking)
-- 		return
-- 	end

-- 	self:AddShadow(tHashtable, vLocation, tHashtable.dagger_path_duration)


-- 	local tTargets = FindUnitsInRadius(tHashtable.hCaster:GetTeamNumber(), vLocation, nil, tHashtable.dagger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
-- 	for n, hTarget in pairs(tTargets) do
-- 		if IsValid(hTarget) and hTarget ~= tHashtable.hCaster and TableFindKey(tHashtable.tTargets, hTarget) == nil then
-- 			if hTarget:IsConsideredHero() then
-- 				hTarget:AddNewModifier(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger", {duration=tHashtable.hero_path_duration, hashtable_index=ExtraData.hashtable_index})
-- 			end

-- 			local damage_table =
-- 			{
-- 				ability = self,
-- 				attacker = tHashtable.hCaster,
-- 				victim = hTarget,
-- 				damage = tHashtable.damage,
-- 				damage_type = self:GetAbilityDamageType()
-- 			}
-- 			if self.unlock2 and  self.unlock2Table[hTarget] and self.unlock2Table[hTarget]==1 then
-- 				damage_table.damage = damage_table.damage * 15
-- 			end

-- 			local damage_absorb = 0.15
-- 			--LV10解锁横断之魄+
-- 			if self.advanced_level>=10 then
-- 				damage_absorb = 0.25
-- 			end

-- 			local damage = ApplyDamage(damage_table)*damage_absorb
-- 			if self.unlock2 then
-- 				if not self.unlock2Table[hTarget]  then
-- 					if self.HealthData[hTarget] then --已经有一次记录
-- 						if (self.HealthData[hTarget]-hTarget:GetHealthPercent())>=15 then
-- 							-- 生命差再15%以上 成功
-- 							self.unlock2Table[hTarget] = 1
-- 							hTarget:AddNewModifier(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger_unlock2_mark", {})
-- 							local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_arcana/spectre_arcana_death.vpcf", PATTACH_CUSTOMORIGIN, nil )
-- 							ParticleManager:SetParticleControl(nFXIndex, 0, hTarget:GetOrigin())
-- 							-- ParticleManager:SetParticleControl(nFXIndex, 1, Vector(500,500,500))
-- 							ParticleManager:ReleaseParticleIndex( nFXIndex )
-- 						else
-- 							self.unlock2Table[hTarget] = 2
-- 						end
-- 						self.HealthData[hTarget] =nil
-- 					else
-- 						self.HealthData[hTarget] = hTarget:GetHealthPercent()
-- 					end
				
-- 				end
				
-- 			end

-- 			damage = damage - damage%1
-- 			tHashtable.hCaster:AddNewModifier(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger_energy", {duration=15,stack = damage})
-- 			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Spectre.DaggerImpact", tHashtable.hCaster)

-- 			table.insert(tHashtable.tTargets, hTarget)
-- 		end
-- 	end
-- end
-- function Advanced_Spectral_Dagger:AddShadow(tHashtable, vLocation, duration)
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
-- 		tHashtable.timer_str = DoUniqueString("Advanced_Spectral_Dagger")
-- 		self:SetContextThink(tHashtable.timer_str, function()
-- 			local fTime = GameRules:GetGameTime()
-- 			for i = #tHashtable.tAuraPositions, 1, -1 do
-- 				if fTime > tHashtable.tAuraPositionsTime[i] then
-- 					table.remove(tHashtable.tAuraPositions, i)
-- 					table.remove(tHashtable.tAuraPositionsTime, i)
-- 				end
-- 			end
-- 			if #tHashtable.tAuraPositions == 0 then
-- 				tHashtable.hAura:FindModifierByName("modifier_Advanced_Spectral_Dagger_path"):SafeDestroy()
-- 				RemoveHashtable(tHashtable)
-- 				return nil
-- 			end
-- 			return 0
-- 		end, 0)
-- 	end
-- end
-- function Advanced_Spectral_Dagger:IsHiddenWhenStolen()
-- 	return false
-- end
-- ---------------------------------------------------------------------
-- --Modifiers 给主目标添加的状态 移动时候会产生路径 虽然不是很需要 还是放着吧
-- if modifier_Advanced_Spectral_Dagger == nil then
-- 	modifier_Advanced_Spectral_Dagger = class({})
-- end
-- function modifier_Advanced_Spectral_Dagger:IsHidden()return true end
-- function modifier_Advanced_Spectral_Dagger:IsDebuff()return true end
-- function modifier_Advanced_Spectral_Dagger:IsPurgable()return false end
-- function modifier_Advanced_Spectral_Dagger:IsPurgeException()return false end
-- function modifier_Advanced_Spectral_Dagger:IsStunDebuff()return false end
-- function modifier_Advanced_Spectral_Dagger:AllowIllusionDuplicate()return false end
-- function modifier_Advanced_Spectral_Dagger:GetEffectName()return "particles/units/heroes/hero_spectre/spectre_shadow_path_owner.vpcf" end
-- function modifier_Advanced_Spectral_Dagger:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_Spectral_Dagger:OnCreated(params)
-- 	if IsServer() then
-- 		self.tHashtable = GetHashtableByIndex(params.hashtable_index)

-- 		self:GetAbility():AddShadow(self.tHashtable, self:GetParent():GetAbsOrigin(), self.tHashtable.hero_path_duration)
		
-- 		self.vPosition = self:GetParent():GetAbsOrigin()

-- 		self:StartIntervalThink(0)
-- 	end
-- end
-- function modifier_Advanced_Spectral_Dagger:OnIntervalThink()
-- 	if IsServer() then
-- 		if (self:GetParent():GetAbsOrigin() - self.vPosition):Length2D() > self.tHashtable.speed/30 then
-- 			self:GetAbility():AddShadow(self.tHashtable, self:GetParent():GetAbsOrigin(), self.tHashtable.hero_path_duration)
			
-- 			self.vPosition = self:GetParent():GetAbsOrigin()
-- 		end
-- 	end
-- end
-- function modifier_Advanced_Spectral_Dagger:CheckState()
-- 	return {
-- 		[MODIFIER_STATE_PROVIDES_VISION] = true,
-- 	}
-- end
-- ---------------------------------------------------------------------
-- --路径的buff
-- if modifier_Advanced_Spectral_Dagger_path == nil then
-- 	modifier_Advanced_Spectral_Dagger_path = class({})
-- end
-- function modifier_Advanced_Spectral_Dagger_path:IsHidden()return true end
-- function modifier_Advanced_Spectral_Dagger_path:IsDebuff()return false end
-- function modifier_Advanced_Spectral_Dagger_path:IsPurgable()return false end
-- function modifier_Advanced_Spectral_Dagger_path:IsPurgeException()return false end
-- function modifier_Advanced_Spectral_Dagger_path:IsStunDebuff()return false end
-- function modifier_Advanced_Spectral_Dagger_path:AllowIllusionDuplicate()return false end
-- function modifier_Advanced_Spectral_Dagger_path:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
-- end
-- function modifier_Advanced_Spectral_Dagger_path:IsAura()return true end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraEntityReject(hEntity)
-- 	if IsValid(self:GetCaster()) then
-- 		-- print(hEntity)
-- 		local ability = self:GetAbility()
-- 		if not ability then
-- 			self:SafeDestroy()
-- 			return
-- 		end
-- 		for n, vPosition in pairs(self.tHashtable.tAuraPositions) do
-- 			-- print(hEntity)
-- 			if hEntity:IsPositionInRange(vPosition, self.tHashtable.path_radius) then
-- 				-- if UnitFilter(hEntity, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, self:GetCaster():GetTeamNumber()) == UF_SUCCESS then

-- 				-- 	hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				-- end
-- 				-- if UnitFilter(hEntity, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber()) == UF_SUCCESS then
-- 				-- 	hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				-- end
-- 				-- if hEntity:GetTeamNumber()==self.team then
-- 				-- 	-- hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				-- 	return false
-- 				-- else
-- 				-- 	if not hEntity:IsMagicImmune() then
-- 				-- 		-- hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				-- 		return false
-- 				-- 	end
-- 				-- end
-- 				-- hEntity:AddNewModifier(self:GetCaster(),ability, "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				local modifier = hEntity:FindModifierByName("modifier_Advanced_Spectral_Dagger_in_path")
-- 				if modifier then
-- 					modifier:SetDuration(self.tHashtable.buff_persistence,true)
-- 				else
-- 					hEntity:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Spectral_Dagger_in_path", {duration=self.tHashtable.buff_persistence})
-- 				end
-- 				return true
-- 			end
-- 		end
-- 	end
-- 	return true
-- end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraDuration()return 1 end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraRadius()return 2000 end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_BOTH end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_Advanced_Spectral_Dagger_path:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_Advanced_Spectral_Dagger_path:GetModifierAura()return "modifier_Advanced_Spectral_Dagger_in_path" end
-- function modifier_Advanced_Spectral_Dagger_path:OnCreated(params)
-- 	if IsServer() then
-- 		self.tHashtable = GetHashtableByIndex(params.hashtable_index)
-- 		-- self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_persistence")
-- 		self.caster = self:GetCaster()
-- 		self.team = self.caster:GetTeamNumber()
-- 	end
-- end
-- function modifier_Advanced_Spectral_Dagger_path:OnDestroy()
-- 	if IsServer() then
-- 		self:GetParent():RemoveSelf()
-- 	end
-- end
-- ---------------------------------------------------------------------
-- if modifier_Advanced_Spectral_Dagger_in_path == nil then
-- 	modifier_Advanced_Spectral_Dagger_in_path = class({})
-- end
-- function modifier_Advanced_Spectral_Dagger_in_path:IsHidden()return false end
-- function modifier_Advanced_Spectral_Dagger_in_path:IsDebuff()return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end
-- function modifier_Advanced_Spectral_Dagger_in_path:IsPurgable()return false end
-- function modifier_Advanced_Spectral_Dagger_in_path:IsPurgeException()return false end
-- function modifier_Advanced_Spectral_Dagger_in_path:IsStunDebuff()return false end
-- function modifier_Advanced_Spectral_Dagger_in_path:AllowIllusionDuplicate()return false end
-- function modifier_Advanced_Spectral_Dagger_in_path:CheckState()
-- 	local state = {}
	
-- 	if self:GetParent()==self:GetCaster() then
-- 		state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
-- 	end

-- 	return state

-- end
-- function modifier_Advanced_Spectral_Dagger_in_path:OnCreated(table)
-- 	local ability = self:GetAbility()
-- 	self.bonusmove = ability:GetSpecialValueFor("bonus_movespeed")
-- 	self.bonus_attack_speed = 100
-- 	self.bonus_incomingdamage_per = 0
-- 	self.bonus_EVASION = 0
-- 	--LV5解锁幽暗之路+
-- 	if ability:GetSpecialValueFor("advanced_level")>=5 then
-- 		self.bonus_attack_speed = 150
-- 		self.bonus_incomingdamage_per = -20
-- 	end


-- 	if ability:GetSpecialValueFor("advanced_level")>=20 then
-- 		self.bonus_EVASION = 40
-- 	end

-- 	if IsServer() then


-- 		--LV15解锁荆棘之路
-- 		if ability.advanced_level>=15 then
-- 			self:StartIntervalThink(2)
-- 			-- hTarget:AddNewModifier(tHashtable.hCaster, self, "modifier_Advanced_Spectral_Dagger", {duration=tHashtable.hero_path_duration, hashtable_index=ExtraData.hashtable_index})
-- 		end


		
-- 	end
-- end
-- -- function modifier_Advanced_Spectral_Dagger_in_path:GetAttributes()
-- -- 	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
-- -- end
-- function modifier_Advanced_Spectral_Dagger_in_path:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,   	   --受到伤害减少
-- 		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
-- 	}
-- end
-- function modifier_Advanced_Spectral_Dagger_in_path:GetModifierEvasion_Constant(params)
-- 		if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
-- 			return self.bonus_EVASION
-- 		end
-- 		return 0
-- end
-- function modifier_Advanced_Spectral_Dagger_in_path:GetModifierMoveSpeedBonus_Constant(params)
-- 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
-- 		return -self.bonusmove
-- 	end
-- 	return self.bonusmove
-- end


-- function modifier_Advanced_Spectral_Dagger_in_path:GetModifierAttackSpeedBonus_Constant()	
-- 	if self:GetParent()==self:GetCaster() then
-- 		return self.bonus_attack_speed
-- 	end
-- 	return 0
-- end
-- function modifier_Advanced_Spectral_Dagger_in_path:GetModifierIncomingDamage_Percentage()	
-- 	if self:GetParent()==self:GetCaster() then
-- 		return self.bonus_incomingdamage_per
-- 	end
-- 	return 0
-- end


-- function modifier_Advanced_Spectral_Dagger_in_path:OnIntervalThink()
-- 	if IsServer() then
-- 		if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
-- 			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Spectral_Dagger_in_path_debuff", {duration=1})
-- 		end
-- 	end
-- end










-- --横裂之魄
-- if modifier_Advanced_Spectral_Dagger_energy == nil then
-- 	modifier_Advanced_Spectral_Dagger_energy = class({})
-- end
-- function modifier_Advanced_Spectral_Dagger_energy:IsHidden()return false end
-- function modifier_Advanced_Spectral_Dagger_energy:IsDebuff()return false end
-- function modifier_Advanced_Spectral_Dagger_energy:IsPurgable()return false end
-- function modifier_Advanced_Spectral_Dagger_energy:IsPurgeException()return false end
-- function modifier_Advanced_Spectral_Dagger_energy:AllowIllusionDuplicate()return false end

-- function modifier_Advanced_Spectral_Dagger_energy:OnCreated(keys)
-- 	if IsServer() then
-- 		self:SetStackCount(keys.stack)
-- 		self:StartIntervalThink(1)
-- 	end
-- end

-- function modifier_Advanced_Spectral_Dagger_energy:OnRefresh(keys)
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetStackCount()+keys.stack)
-- 	end
-- end

-- function modifier_Advanced_Spectral_Dagger_energy:OnIntervalThink(params)
-- 	if IsServer() then
-- 		local stack = self:GetStackCount()
-- 		local parent =self:GetParent()
-- 		local limit = self:GetParent():GetBaseDamageMax()*5
-- 		if stack>=limit then
-- 			self:SetStackCount(stack-limit)
-- 			local tTargets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 500,
-- 			 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
-- 			 local damage_table =
-- 					{
-- 						ability = self:GetAbility(),
-- 						attacker = parent,
-- 						victim = hTarget,
-- 						damage = limit,
-- 						damage_type = self:GetAbility():GetAbilityDamageType()
-- 					}
-- 			for n, hTarget in pairs(tTargets) do
-- 					damage_table.victim = hTarget
-- 					ApplyDamage(damage_table)
-- 					if n>=5 then
-- 						break
-- 					end
-- 			end
-- 			EmitSoundOn( "Hero_Leshrac.Lightning_Storm", parent )
-- 			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
-- 			ParticleManager:SetParticleControl(nFXIndex, 0, parent:GetOrigin())
-- 			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(500,500,500))
-- 			ParticleManager:ReleaseParticleIndex( nFXIndex )
-- 		end
-- 	end
-- end




-- modifier_Advanced_Spectral_Dagger_in_path_debuff = class({})

-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:IsDebuff() return true end
-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:IsHidden() return false end
-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:IsPurgable() return true end
-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:GetEffectName() return "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_root.vpcf" end
-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_Spectral_Dagger_in_path_debuff:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_ROOTED] = true
-- 	}
	

-- 	return state
-- end





-- -- unlock1 effect
-- modifier_Advanced_Spectral_Dagger_unlock1 = class({})
-- function modifier_Advanced_Spectral_Dagger_unlock1:IsHidden() return true end
-- function modifier_Advanced_Spectral_Dagger_unlock1:IsDebuff() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock1:IsPurgable() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock1:IsPurgeException() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock1:RemoveOnDeath() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock1:OnCreated(params)
-- 	if IsServer() then
-- 		self.start_time 				= GameRules:GetGameTime()
-- 		self.spirit_summon_interval 	= 1
-- 		self.max_spirits				= 2
-- 		self.spirit_radius 				= 200
-- 		self.spirit_min_radius			= 200
-- 		self.spirit_max_radius			= 1000
-- 		self.spirit_movement_rate 		=1000
-- 		self.spirit_turn_rate			= 10
-- 		self.spirits_num_spirits		= 0
-- 		self.spirits_movementFactor = 1
-- 		self.spirits_spiritsSpawned		= {}
-- 		-- timers for tracking update of FX


-- 		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

-- 		self:StartIntervalThink(0.03)
-- 		self.nextDagger = GameRules:GetGameTime()
		
		
-- 	end
-- end

-- function modifier_Advanced_Spectral_Dagger_unlock1:OnIntervalThink()
-- 	if IsServer() then
-- 		local ability 					= self:GetAbility()
-- 		local caster 					= self:GetCaster()
-- 		if  ability.unlock1 and  GameRules:GetGameTime()>=self.nextDagger and self.finishCreate then
-- 			if caster:IsAlive() then
-- 				self.nextDagger = GameRules:GetGameTime()+RandomFloat(4, 7)
-- 				self:CreateDagger()
-- 			end
		
-- 		end

	

-- 		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
-- 		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval



-- 		local caster_position 			= self:GetParent():GetAbsOrigin()
-- 		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)
-- 		if self.spirits_num_spirits < idealNumSpiritsSpawned then

-- 			-- Spawn a new spirit
-- 			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())
-- 			-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
-- 			-- newSpirit.spirit_pfx = pfx

			
-- 			--增加数量记录
-- 			local spiritIndex = self.spirits_num_spirits + 1
-- 			newSpirit.spirit_index = spiritIndex
-- 			self.spirits_num_spirits = spiritIndex
-- 			self.spirits_spiritsSpawned[spiritIndex] = newSpirit

-- 			-- Apply the spirit modifier
-- 			newSpirit:AddNewModifier(
-- 				caster, 
-- 				ability, 
-- 				"modifier_Advanced_Spectral_Dagger_unlock1_handler", 
-- 				{ 
-- 					duraiton 			= -1,
-- 					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,
-- 				}
-- 			)
-- 		else
-- 			self.finishCreate = true
-- 		end
		
-- 		--------------------------------------------------------------------------------
-- 		-- Update the radius
-- 		--------------------------------------------------------------------------------
-- 		local currentRadius	= self.spirit_radius

-- 		local deltaRadius 	= self.spirits_movementFactor * self.spirit_movement_rate * 0.03
-- 		currentRadius 		= currentRadius + deltaRadius
-- 		-- currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
-- 		if currentRadius<= self.spirit_min_radius then
-- 			self.spirits_movementFactor = 1
-- 		end
-- 		if currentRadius>= self.spirit_max_radius then
-- 			self.spirits_movementFactor = -1
-- 		end
-- 		self.spirit_radius 	= currentRadius


-- 		--------------------------------------------------------------------------------
-- 		-- Update the spirits' positions
-- 		--------------------------------------------------------------------------------
-- 		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
-- 		local rotationAngleOffset	= 360 / self.max_spirits
-- 		local numSpiritsAlive 		= 0

-- 		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
-- 			if not spirit:IsNull() then
-- 				numSpiritsAlive = numSpiritsAlive + 1

-- 				-- Rotate
-- 				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
-- 				local relPos 		= Vector(0, currentRadius, 0)
-- 				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
-- 				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

-- 				spirit:SetAbsOrigin(absPos)

-- 				-- Update particle... switch particle depending on currently active effect. 
-- 				-- the dealy is needed since it takes 0.3s for spirits to fade in.
				
				
-- 				-- if spirit.spirit_pfx then
-- 				-- 	spirit.currentRadius = Vector(currentRadius, 0, 0)
-- 				-- 	ParticleManager:SetParticleControl(spirit.spirit_pfx, 1, Vector(currentRadius, 0, 0))
-- 				-- end
-- 			else
-- 				self.spirits_spiritsSpawned[k] = nil
-- 			end
-- 		end
	

-- 	end
-- end

-- function modifier_Advanced_Spectral_Dagger_unlock1:CreateDagger()
	
	

-- 	for k,spirit in pairs( self.spirits_spiritsSpawned ) do
-- 		if not spirit:IsNull() then
-- 			local tHashtable = CreateHashtable()
-- 			local ability = self:GetAbility()
-- 			tHashtable.hCaster = self:GetCaster()
-- 			tHashtable.damage = ability:GetSpecialValueFor("damage") + self:GetCaster():GetAgility()*(ability:GetSpecialValueFor("bonus_damage"))
-- 			tHashtable.bonus_movespeed = ability:GetSpecialValueFor("bonus_movespeed")
-- 			tHashtable.dagger_path_duration = ability:GetSpecialValueFor("dagger_path_duration")
-- 			tHashtable.hero_path_duration = ability:GetSpecialValueFor("hero_path_duration")
-- 			tHashtable.buff_persistence = ability:GetSpecialValueFor("buff_persistence")
-- 			tHashtable.dagger_radius = ability:GetSpecialValueFor("dagger_radius")
-- 			tHashtable.path_radius = ability:GetSpecialValueFor("path_radius")
-- 			tHashtable.speed = 600
-- 			tHashtable.dagger_grace_period = ability:GetSpecialValueFor("dagger_grace_period")
-- 			tHashtable.fDistance = math.max(ability:GetCastRange(ability:GetCursorPosition(), ability:GetCursorTarget()) + tHashtable.hCaster:GetCastRangeBonus(),100)
-- 			tHashtable.vStartPosition = tHashtable.hCaster:GetAbsOrigin()
-- 			tHashtable.hCaster:EmitSound("Hero_Spectre.DaggerCast")
-- 			tHashtable.tTargets = {}
-- 			tHashtable.tAuraPositions = {}
-- 			tHashtable.tAuraPositionsTime = {}
-- 			tHashtable.hAura = CreateModifierThinker(tHashtable.hCaster, ability, "modifier_Advanced_Spectral_Dagger_path", {hashtable_index = GetHashtableIndex(tHashtable)}, tHashtable.vStartPosition, tHashtable.hCaster:GetTeamNumber(), false)
-- 			ability:AddShadow(tHashtable, tHashtable.vStartPosition, tHashtable.dagger_path_duration)
-- 			tHashtable.unlock1timer = GameRules:GetGameTime() + 6.0

-- 			local tInfo =
-- 			{
-- 				Ability = ability,
-- 				EffectName = ParticleManager:GetParticleReplacement("particles/econ/items/spectre/spectre_arcana/spectre_arcana_spectral_dagger_tracking.vpcf", tHashtable.hCaster),
-- 				vSourceLoc = tHashtable.vStartPosition,
-- 				iMoveSpeed = tHashtable.speed,
-- 				-- Target = self:GetCursorTarget(),
-- 				Source = tHashtable.hCaster,
-- 				bDodgeable = false,
-- 				bProvidesVision = true,
-- 				iVisionTeamNumber = tHashtable.hCaster:GetTeamNumber(),
-- 				iVisionRadius = 0,

-- 				ExtraData =
-- 				{
-- 					hashtable_index = GetHashtableIndex(tHashtable),
					

-- 				}
-- 			}
-- 			tInfo.Target = spirit

-- 			local projectile = ProjectileManager:CreateTrackingProjectile(tInfo)
-- 			tHashtable.traciking = projectile
-- 			-- print("trancking="..projectile)
	
-- 		end
-- 	end
-- end


-- modifier_Advanced_Spectral_Dagger_unlock1_handler = class({})
-- function modifier_Advanced_Spectral_Dagger_unlock1_handler:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
-- 		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
-- 		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
-- 		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
-- 		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
-- 		[MODIFIER_STATE_INVULNERABLE] 		= true,
-- 		[MODIFIER_STATE_UNSELECTABLE] 		= true,
-- 		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
-- 		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
-- 	}

-- 	return state
-- end

-- function modifier_Advanced_Spectral_Dagger_unlock1_handler:OnCreated(params)
-- 	if IsServer() then
-- 		self.caster 			= self:GetCaster()
-- 		self.ability 			= self:GetAbility()


-- 		self.tinkerval 			= params.tinkerval
-- 		self.parent = self:GetParent()
-- 		self.parent.hit_table = {}
-- 		self.damage_time = 5
-- 		self.damage_count = 0
-- 		self.damage_interval 	= 0.10
-- 		self.damage_timer 		= 0

-- 		self:StartIntervalThink(self.damage_interval)
-- 	end
-- end

-- function modifier_Advanced_Spectral_Dagger_unlock1_handler:OnIntervalThink()
-- 	if IsServer() then 
-- 		local ability = self:GetAbility()
-- 		if not ability then
-- 			self:SafeDestroy()
-- 		end
-- 		-- local spirit = self:GetParent()
-- 		-- -- Check if we hit stuff
-- 		-- local nearby_enemy_units = FindUnitsInRadius(
-- 		-- 	self.caster:GetTeam(),
-- 		-- 	spirit:GetAbsOrigin(), 
-- 		-- 	nil, 
-- 		-- 	self.collision_radius, 
-- 		-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,
-- 		-- 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
-- 		-- 	DOTA_UNIT_TARGET_FLAG_NONE, 
-- 		-- 	FIND_ANY_ORDER, 
-- 		-- 	false
-- 		-- )


-- 		-- if nearby_enemy_units ~= nil and #nearby_enemy_units > 0 then
-- 		-- 	self:OnHit(self.caster, spirit, nearby_enemy_units, self.creep_damage, self.ability)
-- 		-- end


-- 		-- self.damage_timer = self.damage_timer +self.damage_interval
-- 		-- if self.advanced_level>=15 and self.damage_timer>=1 then
-- 		-- 	self.damage_timer = 0
-- 		-- 	if self:GetCaster():GetRandomEffect(30,INT_TYPE,1) >=RandomInt(1, 100) then
-- 		-- 		local nearby_enemy_units = FindUnitsInRadius(
-- 		-- 			self.caster:GetTeam(),
-- 		-- 			spirit:GetAbsOrigin(), 
-- 		-- 			nil, 
-- 		-- 			600, 
-- 		-- 			DOTA_UNIT_TARGET_TEAM_ENEMY,
-- 		-- 			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
-- 		-- 			DOTA_UNIT_TARGET_FLAG_NONE, 
-- 		-- 			FIND_ANY_ORDER, 
-- 		-- 			false
-- 		-- 		)
-- 		-- 		if #nearby_enemy_units>=1 then
-- 		-- 			for _, unit in ipairs(nearby_enemy_units) do
-- 		-- 				if not unit:IsAttackImmune() then
-- 		-- 					local info = 
-- 		-- 					{
-- 		-- 						Target = unit,
-- 		-- 						Source = spirit,
-- 		-- 						Ability = self.ability,	
-- 		-- 						EffectName = "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf",
-- 		-- 						iMoveSpeed = 800,
-- 		-- 						vSourceLoc= spirit:GetAbsOrigin(),
-- 		-- 						bDrawsOnMinimap = false,
-- 		-- 						bDodgeable = true,
-- 		-- 						bIsAttack = false,
-- 		-- 						bVisibleToEnemies = true,
-- 		-- 						bReplaceExisting = false,
-- 		-- 						flExpireTime = GameRules:GetGameTime() + 10,
-- 		-- 						bProvidesVision = false,	
-- 		-- 					}
-- 		-- 					ProjectileManager:CreateTrackingProjectile(info)
-- 		-- 					break
-- 		-- 				end
-- 		-- 			end
-- 		-- 		end
-- 		-- 	end
			
-- 		-- end
-- 	end
-- end

-- -- function modifier_Advanced_Spectral_Dagger_unlock1_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability) 

-- -- 	-- Initialize damage table
-- -- 	local damage_table 			= {}
-- -- 	damage_table.attacker 		= caster
-- -- 	damage_table.ability 		= ability
-- -- 	damage_table.damage_type 	= ability:GetAbilityDamageType() 

-- -- 	-- Deal damage to each enemy hero
-- -- 	for _,enemy in pairs(enemies_hit) do
-- -- 		-- cant dmg ded stuff + cant dmg if ded
-- -- 		if enemy:IsAlive() and not spirit:IsNull() then 
-- -- 			local hit = false

-- -- 			damage_table.victim = enemy

-- -- 			if spirit.hit_table[enemy] == nil then
-- -- 				spirit.hit_table[enemy] = true
-- -- 				enemy:AddNewModifier(caster, ability, "modifier_Advanced_spirits_creep_hit", {duration = 0.03})
-- -- 				damage_table.damage	= creep_damage
-- -- 				hit = true
-- -- 				Timers:CreateTimer(self.damage_time, function()
-- -- 					if not spirit:IsNull() then
-- -- 						spirit.hit_table[enemy] = nil
-- -- 					end
-- -- 				end)
-- -- 			end

-- -- 			if hit then
-- -- 				ApplyDamage(damage_table)
-- -- 				if self.ability.unlock2 then
-- -- 					self.damage_count = self.damage_count + 1
-- -- 				end
-- -- 			end

-- -- 		end
-- -- 	end
-- -- 	if self.ability.unlock2 and self.damage_count>=3 then
-- -- 		self:SafeDestroy()
-- -- 	end

-- -- end

-- function modifier_Advanced_Spectral_Dagger_unlock1_handler:OnRemoved()
-- 	if IsServer() then
-- 		local spirit	= self:GetParent()
-- 		-- local ability	= self:GetAbility()
-- 		-- ability:Explode(self.caster, spirit, self.explosion_radius, self.explosion_damage, ability)
-- 		-- if spirit.spirit_pfx~= nil then
-- 		-- 	ParticleManager:DestroyParticle(spirit.spirit_pfx, true)
-- 		-- end
-- 		spirit:ForceKill( true )
-- 	end
-- end




-- modifier_Advanced_Spectral_Dagger_unlock2_mark = class({})
-- function modifier_Advanced_Spectral_Dagger_unlock2_mark:IsHidden() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock2_mark:IsDebuff() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock2_mark:IsPurgable() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock2_mark:IsPurgeException() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock2_mark:RemoveOnDeath() return false end
-- -- function modifier_Advanced_Spectral_Dagger_unlock2_mark:GetEffectName() return "particles/econ/items/spectre/spectre_arcana/spectre_arcana_death.vpcf" end
-- -- function modifier_Advanced_Spectral_Dagger_unlock2_mark:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

-- -- function modifier_Advanced_Spectral_Dagger_unlock2_mark:OnCreated()
-- -- 	if IsServer() then
		
-- -- 		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_arcana/spectre_arcana_death.vpcf", PATTACH_CUSTOMORIGIN, nil )
-- -- 		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetOrigin())
-- -- 		-- ParticleManager:SetParticleControl(nFXIndex, 1, Vector(500,500,500))
-- -- 		ParticleManager:ReleaseParticleIndex( nFXIndex )


-- -- 		-- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_arcana/spectre_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
-- -- 		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
-- -- 		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
-- -- 		-- -- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
-- -- 		-- -- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
-- -- 		-- -- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
-- -- 		-- self:AddParticle( self.nFXIndex, false, false, -1, true, false )
-- -- 	end
-- -- end


-- modifier_Advanced_Spectral_Dagger_unlock3 = class({})
-- function modifier_Advanced_Spectral_Dagger_unlock3:IsHidden() return true end
-- function modifier_Advanced_Spectral_Dagger_unlock3:IsDebuff() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock3:IsPurgable() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock3:IsPurgeException() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock3:RemoveOnDeath() return false end
-- function modifier_Advanced_Spectral_Dagger_unlock3:OnCreated()
-- 	if IsServer() then
-- 		self.timer =  GameRules:GetGameTime()
-- 	end
-- end