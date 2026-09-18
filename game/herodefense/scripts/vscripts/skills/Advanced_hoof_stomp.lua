--特效优化 √
LinkLuaModifier("modifier_Advanced_hoof_stomp_buff", "skills/Advanced_hoof_stomp", LUA_MODIFIER_MOTION_NONE)

Advanced_hoof_stomp = class({})

function Advanced_hoof_stomp:CheckKV(key)
	local table = {

	
		damage =15,
		damage_index = 0.15,


	}
	local value = table[key] or -1
	return value

end

function Advanced_hoof_stomp:UnlockFirstCore(key)
	return true
end
function Advanced_hoof_stomp:UnlockSecondCore(key)
	return true
end
function Advanced_hoof_stomp:UnlockThirdCore(key)
	
	return true
end

function Advanced_hoof_stomp:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_POINT
		end
		
	end
	return self.BaseClass.GetBehavior(self)
end


require('internal/timers')   --计时器功能
function Advanced_hoof_stomp:GetCastRange()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 800-self:GetCaster():GetCastRangeBonus()
		end
		
	end
	return self:GetSpecialValueFor("radius")
end

function Advanced_hoof_stomp:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "damage" )+ caster:GetStrength()*(self:GetSpecialValueFor("damage_index"))
	local stun_duration = self:GetSpecialValueFor("duration")
	if self.unlock1 then
		self:TriggerEpicenter()
	end


	local talen3 = caster:FindAbilityByName("heroTalent_npc_dota_hero_centaur_3")
	local double_edge=  self:GetDouble_edge()
	

	if self.unlock3 then
		local point = self:GetCursorPosition()
		local caster_pos = caster:GetAbsOrigin()
		if point == caster_pos then
			point = point + self:GetCaster():GetForwardVector()
		end
		local norm = (point - caster_pos):Normalized()
		for i = 0, 2, 1 do

			local target_point = caster_pos + norm * i*300
			self:PlayEffects(target_point)
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				target_point,
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			if #enemies>=1 then
				local damageTable = {
					victim = nil,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self, --Optional.
				}
			
				-- for each caught enemies
				local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
				local Res_disable = 0.1
				local need_number = 5
				local default = true
				
				for _,enemy in pairs(enemies) do
					-- Apply Damage
					damageTable.victim = enemy
					ApplyDamage(damageTable)
					local StatusResistance = nemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					if #enemies<=need_number then
						if enemy:GetHDStatusResistanceIndex(1)>1 then
							StatusResistance =enemy:GetHDStatusResistanceIndex(Res_disable)*ModifierStatusNegativeGain
						end
						StatusResistance = StatusResistance*1.3
					end
					enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration *StatusResistance} )


					if talen3 and double_edge then
						if enemy:IsAlive() then
							if default then
								default = false
								double_edge:OnSpellStart(enemy)
							elseif caster:RollRandom(talen3:GetSpecialValueFor("chance"),1) then
								double_edge:OnSpellStart(enemy)
							end
							
						end
					end
				end
		
				caster:AddNewModifier( caster, self, "modifier_Advanced_hoof_stomp_buff", { duration = 18,stack=#enemies} )
				--LV20解锁晕5个
				if #enemies>5 and 10>=RandomInt(1, 100) then
					self:EndCooldown()
				end
			end
		
		
		
		end
	elseif self.unlock2 then
		local pos = caster:GetAbsOrigin()
		Timers:CreateTimer(5, function()
			if not self then
				return
			end
			self:Unlock2Effect(8,radius,pos,damage)
		end)
		
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			pos,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		local damageTable = {
			victim = nil,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- for each caught enemies
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local Res_disable = 0.1
		local need_number = 5
		

		local default = true
		for _,enemy in pairs(enemies) do
			-- Apply Damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			if #enemies<=need_number then
				if enemy:GetHDStatusResistanceIndex(1)>1 then
					StatusResistance = enemy:GetHDStatusResistanceIndex(Res_disable)*ModifierStatusNegativeGain
				end
				StatusResistance = StatusResistance*1.3
			end
			
			-- Apply stun debuff
			enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration *StatusResistance} )


			if talen3 and double_edge then
				if enemy:IsAlive() then
					if default then
						default = false
						double_edge:OnSpellStart(enemy)
					elseif caster:RollRandom(talen3:GetSpecialValueFor("chance"),1) then
						double_edge:OnSpellStart(enemy)
					end
					
				end
			end
		end
		--LV15解锁能量汇聚
		if #enemies>0  then
			caster:AddNewModifier( caster, self, "modifier_Advanced_hoof_stomp_buff", { duration = 10,stack=#enemies} )
		end
		--LV20解锁晕5个
		if #enemies>5 and 1==RandomInt(1, 2) then
			self:EndCooldown()
		end
		self:PlayEffects( pos)
	else
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- Prepare damage table
		local damageTable = {
			victim = nil,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- for each caught enemies
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local Res_disable = 0.4
		local need_number = 3
		--LV5解锁本源撼动
		if self.advanced_level>=5 then
			Res_disable = 0.1
			need_number = 5
		end
		local default = true
		for _,enemy in pairs(enemies) do
			-- Apply Damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			if #enemies<=need_number then
				if enemy:GetHDStatusResistanceIndex(1)>1 then
					StatusResistance = enemy:GetHDStatusResistanceIndex(Res_disable)*ModifierStatusNegativeGain
				end
				StatusResistance = StatusResistance*1.3
			end
			
			-- Apply stun debuff
			enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration *StatusResistance} )
			if talen3 and double_edge then
				if enemy:IsAlive() then
					if default then
						default = false
						double_edge:OnSpellStart(enemy)
					elseif caster:RollRandom(talen3:GetSpecialValueFor("chance"),1) then
						double_edge:OnSpellStart(enemy)
					end
					
				end
			end
		end
		--LV15解锁能量汇聚
		if #enemies>0 and self.advanced_level>=15 then
			caster:AddNewModifier( caster, self, "modifier_Advanced_hoof_stomp_buff", { duration = 10,stack=#enemies} )
		end
		--LV20解锁晕5个
		if #enemies>5 and self.advanced_level>=20 and 1==RandomInt(1, 2) then
			self:EndCooldown()
		end

		-- Play effects
		self:PlayEffects( caster:GetOrigin())
		Timers:CreateTimer(4, function()
			if not self then
				return
			end
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				caster:GetOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
		
			-- Prepare damage table
			local damageTable = {
				victim = nil,
				attacker = caster,
				damage = damage*0.7,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self, --Optional.
			}
		

			for _,enemy in pairs(enemies) do
				-- Apply Damage
				damageTable.victim = enemy
				ApplyDamage(damageTable)
			end

			self:PlayEffects( caster:GetOrigin())
		end)
		--LV10解锁震撼大地+
		if self.advanced_level>=10 then
			Timers:CreateTimer(7, function()
				if not self then
					return
				end
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),
					caster:GetOrigin(),
					nil,
					radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false
				)
			
				-- Prepare damage table
				local damageTable = {
					victim = nil,
					attacker = caster,
					damage = damage*0.7,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self, --Optional.
				}
			
		
				for _,enemy in pairs(enemies) do
					-- Apply Damage
					damageTable.victim = enemy
					ApplyDamage(damageTable)
				end
		
				self:PlayEffects( caster:GetOrigin())
			end)
		end

	end

end

function Advanced_hoof_stomp:PlayEffects(pos)


	local caster = self:GetCaster()
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local sound_cast = "Hero_Centaur.HoofStomp"
	local radius = self:GetSpecialValueFor("radius")


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		pos, -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		pos, -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
end


function Advanced_hoof_stomp:TriggerEpicenter()
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        local ability = hero:FindAbilityByName("Advanced_Epicenter")
		if not ability then
			ability = hero:FindAbilityByName("Middle_Epicenter")
		end
		if not ability then
			ability = hero:FindAbilityByName("Primary_Epicenter")
		end
        if ability then
			ability:SandKingEffect()
        end
        
    end
end

function Advanced_hoof_stomp:Unlock2Effect(count,radius,pos,damage)

	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		pos,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage*0.7,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}


	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	self:PlayEffects( pos)
	if count>=1 then

		Timers:CreateTimer(5, function()
			if not self then
				return
			end
			self:Unlock2Effect(count-1,radius,pos,damage)
		end)
	end

end







function Advanced_hoof_stomp:GetDouble_edge()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_double_edge")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_double_edge")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_double_edge")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_double_edge")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end





modifier_Advanced_hoof_stomp_buff = class({})
function modifier_Advanced_hoof_stomp_buff:IsDebuff()			    return false end
function modifier_Advanced_hoof_stomp_buff:IsHidden() 			    return false end
function modifier_Advanced_hoof_stomp_buff:IsPurgable() 			return false end
function modifier_Advanced_hoof_stomp_buff:IsPurgeException() 	    return true end
function modifier_Advanced_hoof_stomp_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_hoof_stomp_buff:OnCreated(keys)
    if not IsServer() then
        return        
    end
	self:SetStackCount(math.min(keys.stack,10))
end


function modifier_Advanced_hoof_stomp_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量


	}
end


function modifier_Advanced_hoof_stomp_buff:GetModifierBonusStats_Strength()	return self:GetStackCount()*5 end





