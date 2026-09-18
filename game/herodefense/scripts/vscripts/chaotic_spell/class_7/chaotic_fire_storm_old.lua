-- LinkLuaModifier("modifier_chaotic_fire_storm_thinker", "chaotic_spell/class_7/chaotic_fire_storm", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_fire_storm_buff", "chaotic_spell/class_7/chaotic_fire_storm", LUA_MODIFIER_MOTION_NONE)





-- chaotic_fire_storm = class({})

-- function chaotic_fire_storm:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_fire_storm/storm_effect/abyssal_underlord_firestorm_wave.vpcf", context )
-- end


-- function chaotic_fire_storm:GetIntrinsicModifierName()
-- 	return "modifier_generic_custom_indicator"
-- end
-- function chaotic_fire_storm:CastFilterResultLocation( vLoc )
-- 	vLoc = SnapToGrid( self:GetSpecialValueFor("width"), vLoc)
-- 	if IsClient() then
-- 		if self.custom_indicator then
-- 			self.custom_indicator:Register( vLoc )
-- 		end
-- 	end
-- 	if not IsServer() then return end

-- 	if IsValid(self.modifier) then
		
-- 		local result = self.modifier:CheckPos(vLoc)
-- 		if result==1 then
-- 			return UF_SUCCESS
-- 		elseif result==2 then
-- 			self.error = "DOTA_HUB_CANT_CAST_Same_Pos"
-- 			return UF_FAIL_CUSTOM
-- 		elseif result==3 then
-- 			self.error = "DOTA_HUB_CANT_CAST_Un_Connection"
-- 			return UF_FAIL_CUSTOM
-- 		end
-- 	end

-- 	return UF_SUCCESS
-- end
-- function chaotic_fire_storm:GetCustomCastErrorLocation( vLoc )
-- 	return self.error
-- end

-- function chaotic_fire_storm:CreateCustomIndicator()
-- 	local particle_cast = "particles/ui_mouseactions/custom_sector_square.vpcf"
-- 	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
-- 	ParticleManager:SetParticleShouldCheckFoW(self.effect_cast,false)
		
-- 	local radius = self:GetSpecialValueFor("width")
-- 	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(radius,radius,0))
-- 	ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(87,165,0))

-- end


-- function chaotic_fire_storm:UpdateCustomIndicator( loc )
-- 	-- local caster = self:GetCaster()
-- 	-- loc = loc or caster:GetAbsOrigin()
-- 	-- local pos = SnapToGrid( self:GetSpecialValueFor("width"), loc)
-- 	ParticleManager:SetParticleControl( self.effect_cast, 0,loc)
-- end
-- function chaotic_fire_storm:DestroyCustomIndicator()
-- 	ParticleManager:DestroyParticle( self.effect_cast, true ) 
-- 	ParticleManager:ReleaseParticleIndex( self.effect_cast )
-- end




-- function chaotic_fire_storm:GetAOERadius()
-- 	return 100
-- end

-- -- 
-- function chaotic_fire_storm:GetBehavior()
-- 	if self:GetCaster():HasModifier("modifier_chaotic_fire_storm_buff") then
-- 		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE  + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
-- 	end
-- 	return self.BaseClass.GetBehavior(self)
-- end






-- function chaotic_fire_storm:GetManaCost(iLevel)
-- 	if self:GetCaster():HasModifier("modifier_chaotic_fire_storm_buff") then
-- 		return 0
-- 	end
-- 	return self.BaseClass.GetManaCost(self,iLevel)
-- end


-- function chaotic_fire_storm:GetCooldown(iLevel)
-- 	if self:GetCaster():HasModifier("modifier_chaotic_fire_storm_buff") then
-- 		return 0
-- 	end
-- 	return self.BaseClass.GetCooldown(self,iLevel)
-- end
-- function chaotic_fire_storm:Spawn()
-- 	self.dataRecordList = {}
-- end

-- function chaotic_fire_storm:OnSpellStart()
-- 	local caster = self:GetCaster()
-- 	local pos = SnapToGrid( self:GetSpecialValueFor("width"), self:GetCursorPosition())


-- 	-- CreateModifierThinker(caster, self, "modifier_chaotic_fire_storm_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)



-- 	-- SnapToGrid(radius, self:GetCursorPosition())


-- 	if not IsValid(self.modifier) then
-- 		local cooldown_record = self:GetCooldownTimeRemaining()
-- 		self:EndCooldown()
-- 		self.modifier = caster:AddNewModifier(caster, self, "modifier_chaotic_fire_storm_buff", {duration =self:GetSpecialValueFor("time_require"),cooldown_record=cooldown_record})
-- 	end

-- 	if IsValid(self.modifier) then
		
-- 		self.modifier:InitPos(pos)

-- 		local count = self.modifier:GetStackCount()
-- 		if count<=0 then
-- 			self.modifier:SafeDestroy()
-- 		end

-- 	end




-- end





-- modifier_chaotic_fire_storm_buff = advanced_modifier({})

-- function modifier_chaotic_fire_storm_buff:IsHidden() return false end
-- function modifier_chaotic_fire_storm_buff:IsPurgable() return false end
-- function modifier_chaotic_fire_storm_buff:IsDebuff() return false end
-- function modifier_chaotic_fire_storm_buff:OnCreated(keys)
-- 	-- self.sunbeam_bonus_day_vison = self:GetAbility():GetSpecialValueFor("sunbeam_bonus_day_vison")
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetAbility():GetSpecialValueFor("count"))

-- 		self.posRecord = {}
-- 		self.cooldown_record = keys.cooldown_record
-- 		-- self:PlayEffect(self:GetParent())
-- 	end
-- end
-- function modifier_chaotic_fire_storm_buff:OnDestroy()
-- 	if IsServer() then
-- 		local ability = self:GetAbility()
-- 		if not ability then
-- 			return
-- 		end

-- 		self:InitEffect()
-- 		local stack =self:GetStackCount()
-- 		if stack>=1 then
-- 			local ability = self:GetAbility()
-- 			local cooldown_reduction = math.min(ability:GetSpecialValueFor("cooldown_reduction")*stack,ability:GetSpecialValueFor("cooldown_reduction_max"))*0.01
-- 			self.cooldown_record = self.cooldown_record *(1-cooldown_reduction)
-- 		end
-- 		ability:StartCooldown(self.cooldown_record)

-- 		-- ParticleManager:DestroyParticle(self.effect_cast1,false)
-- 	end
-- end
-- function modifier_chaotic_fire_storm_buff:InitPos(location)
-- 	local particle_cast = "particles/ui_mouseactions/custom_sector_square.vpcf"
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,nil )
-- 	ParticleManager:SetParticleShouldCheckFoW(effect_cast,false)
		
-- 	local radius = self:GetAbility():GetSpecialValueFor("width")
-- 	ParticleManager:SetParticleControl( effect_cast, 0, location)
-- 	ParticleManager:SetParticleControl( effect_cast, 6, Vector(radius,radius,0))
-- 	ParticleManager:SetParticleControl( effect_cast, 61, Vector(87,165,0))
-- 	local data = {
-- 		particleID = effect_cast,
-- 		pos = location
-- 	}

-- 	table.insert(self.posRecord,data)
-- 	self:DecrementStackCount()
-- end

-- function modifier_chaotic_fire_storm_buff:InitEffect()
-- 	for _, data in ipairs(self.posRecord) do
-- 		ParticleManager:DestroyParticle(data.particleID,true)
-- 	end

-- 	local particleName = "particles/rebuild/chaotic_spell/chaotic_fire_storm/storm_effect/abyssal_underlord_firestorm_wave.vpcf"
-- 	local radius = self:GetAbility():GetSpecialValueFor("width")
-- 	local caster = self:GetCaster()
-- 	local unitList = {}
-- 	local ability = self:GetAbility()
-- 	for _, data in ipairs(self.posRecord) do
-- 		local pos = data.pos
-- 		local effect_cast = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN,nil )
	
		
-- 		ParticleManager:SetParticleControl( effect_cast, 0, pos)
-- 		ParticleManager:SetParticleControl( effect_cast, 4, Vector(radius,radius,0))
-- 		DestroyParticleByDelay(effect_cast,1.5)
-- 		EmitSoundOnLocationWithCaster(pos, "Hero_AbyssalUnderlord.Firestorm", caster)
-- 		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius*2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
-- 		for _, unit in ipairs(enemies) do
-- 			if self:IsUnitInsideBlock(unit, pos, radius) then
-- 				if not unitList[unit]  then
-- 					unitList[unit] = 1
-- 				else
-- 					if ability:GetRuneType()==1 then
-- 						unitList[unit] = unitList[unit] + 1
-- 					end

-- 				end
				
			
-- 			end
-- 		end
-- 	end
-- 	local gain = ability:GetEffectGain()
	
-- 	local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
-- 	local damageTable = {
-- 		-- victim = self:GetParent(),
-- 		attacker = caster,
-- 		damage = damage*gain,
-- 		damage_type = ability:GetAbilityDamageType(),
-- 		ability = ability, --Optional.
-- 		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
-- 	}
-- 	if ability:GetRuneType()==1 then
-- 		local bonus_damage =  ability:GetSpecialValueFor( "rune_1_damage_stack" )*0.01
-- 		for unit, value in pairs(unitList) do
-- 			damageTable.damage = damage* (1+(value-1)*bonus_damage)
-- 			damageTable.victim = unit
-- 			ApplyDamage(damageTable)
-- 		end
-- 	else
-- 		for unit, value in pairs(unitList) do
-- 			damageTable.victim = unit
-- 			ApplyDamage(damageTable)
-- 		end
-- 	end


	
-- end


-- function modifier_chaotic_fire_storm_buff:IsUnitInsideBlock(unit, blockPosition, blockSize)
--     local unitPosition = unit:GetAbsOrigin()
--     local xMin = blockPosition.x - blockSize
--     local xMax = blockPosition.x + blockSize
--     local yMin = blockPosition.y - blockSize
--     local yMax = blockPosition.y + blockSize

--     if unitPosition.x >= xMin and unitPosition.x <= xMax and unitPosition.y >= yMin and unitPosition.y <= yMax then
--         -- 单位在方块内
--         return true
--     else
--         -- 单位不在方块内
--         return false
--     end
-- end


-- function modifier_chaotic_fire_storm_buff:CheckPos(vLoc)
--     local radius = self:GetAbility():GetSpecialValueFor("width")

-- 	-- print("---------------")
-- 	-- 检测两遍 先检测有没有相同坐标 再检测相邻
--     for _, data in pairs(self.posRecord) do
--         local distance = (vLoc - data.pos):Length2D()
-- 		if distance<=10 and self:GetAbility():GetRuneType()~=1 then
-- 			return 2
-- 		end
        
--     end
-- 	for _, data in pairs(self.posRecord) do
--         local distance = (vLoc - data.pos):Length2D()
--         if distance < (radius*2+10) then
--             -- 传入的坐标与某个记录的坐标相连
--             return 1
--         end
--     end


--     -- 传入的坐标与任何记录的坐标都不相连
--     return 3

-- end
