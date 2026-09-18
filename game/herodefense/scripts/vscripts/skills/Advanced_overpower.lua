--特效优化 √
Advanced_overpower = class({})
LinkLuaModifier( "modifier_Advanced_overpower", "skills/Advanced_overpower", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function Advanced_overpower:UnlockFirstCore(key)
	return true
end
function Advanced_overpower:UnlockSecondCore(key)
	self.unlock2={
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
	}
	return true
end
function Advanced_overpower:UnlockThirdCore(key)
	return true
end
function Advanced_overpower:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/overpower/unlock2/effect.vpcf", context )


	
end
function Advanced_overpower:OnSpellStart()
	-- get references
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local bonus_duration = self:GetSpecialValueFor("duration")
	local bonus = 0
	if self.unlock2 then
		local bonus_damage = 0
		local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,unit in pairs(heros) do
			if unit~=caster then
				bonus_damage = bonus_damage + unit:GetBaseDamageMax()
				local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,caster)
				ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)

			end
		end
		
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = 0
		for _,unit in pairs(units) do
			bonus_damage = bonus_damage + unit:GetBaseDamageMax()
			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,caster)
			ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			count = count + 1
			if count>=10 then
				break
			end
		
		end
		bonus_damage = bonus_damage *0.4
		table.remove(self.unlock2, 1)
		table.insert(self.unlock2, bonus_damage)
		for _, count in ipairs(self.unlock2) do
			bonus = bonus + count
		end
		bonus = bonus / 8
		
	end

	local duration =  bonus_duration *gain

	if self.unlock3 then
		duration = -1
	end

	-- Add buff modifier
	caster:AddNewModifier(
		caster,
		self,
		"modifier_Advanced_overpower",
		{ duration = duration,bonus=bonus}
	)

	caster:EmitSound("Hero_Ursa.Overpower")
end




function Advanced_overpower:CheckKV(key)
	local table = {

	


		attack_speed_bonus = 20,
		max_attacks = 0.5,
		duration = 0.5,




	}
	local value = table[key] or -1
	return value

end

modifier_Advanced_overpower = advanced_modifier({})

--------------------------------------------------------------------------------

function modifier_Advanced_overpower:IsDebuff()	return false end
function modifier_Advanced_overpower:IsPurgable() return true end
--------------------------------------------------------------------------------

function modifier_Advanced_overpower:OnCreated( kv )
	-- get reference
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = ability:GetSpecialValueFor("max_attacks")


	if ability:GetUnlock(1)==1 then
		self.max_attacks = self.max_attacks * 2
		self.bonus = 9999
	end
	-- Increase stack

	if IsServer() then
		self.bonus_attack_damage = kv.bonus
		self:SetStackCount(self.max_attacks)
		local internal = 2 
		self.chance = 20
		--LV5解锁怒气增幅
		if self.advanced_level>=5 then
			internal = 1.4
			--LV10解锁怒气外溢+
			if self.advanced_level>=10 then
				self.chance = 35
				--LV20解锁持久力
				if self.advanced_level>=20 then
					local modifier = self
					if not ability.unlock3 then
						Timers:CreateTimer(1, function()
							if modifier and not modifier:IsNull() and ability and not ability:IsNull() and not ability:IsCooldownReady() then
								modifier:SetDuration(modifier:GetRemainingTime()+1.2, true)
								return 1
							else
								return
							end
						end)
					end
					
				end
			end
		end
		self:StartIntervalThink(internal)
		-- self:AddEffects()
		self.effect_cast = ParticleManager:CreateParticle( "particles/new_effect/new_overpower.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true)

		
		-- Apply particle
		self:AddParticle(
			self.effect_cast,
			false,
			false,
			-1,
			false,
			false
		)

		if ability.unlock2 then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/overpower/unlock2/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(self.nFXIndex, 61,Vector(math.min(50,self.bonus_attack_damage/100),0,0))
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end

function modifier_Advanced_overpower:OnRefresh( kv )
	-- get reference
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus = ability:GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = ability:GetSpecialValueFor("max_attacks")


	if ability:GetUnlock(1)==1 then
		self.max_attacks = self.max_attacks * 2
		self.bonus = 9999
	end
	if IsServer() then
		self.bonus_attack_damage = kv.bonus
		self:SetStackCount(self.max_attacks)
		if ability.unlock2 and self.nFXIndex then
			ParticleManager:SetParticleControl(self.nFXIndex, 61,Vector(math.min(50,self.bonus_attack_damage/100),0,0))
		end
	end
end

function modifier_Advanced_overpower:OnDestroy( kv )

	if IsServer() then
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end


function modifier_Advanced_overpower:OnIntervalThink( kv )
	if IsServer() then
		if self:GetAbility().unlock1 then
			self:SetStackCount(self:GetStackCount()+2)
		elseif self:GetAbility().unlock3 then
			self:SetStackCount(self:GetStackCount()+3)
		else
			self:SetStackCount(self:GetStackCount()+1)
		end
	end
end
--------------------------------------------------------------------------------

function modifier_Advanced_overpower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Advanced_overpower:GetModifierAttackSpeedBonus_Constant()
	return self.bonus
end


function modifier_Advanced_overpower:OnAttack( params )
	if params.attacker~=self:GetParent() then
		return
	end
	if self:GetParent() :IsInSpecialAttack() then
		return
	end

	self:DecrementStackCount()

	if self:GetStackCount()<=0 then
		if not self:GetAbility().unlock3 then
			self:SafeDestroy()
		end


	end

end
function modifier_Advanced_overpower:GetEffectName() return "particles/units/heroes/hero_ursa/ursa_overpower_rebuildmohawk.vpcf" end
function modifier_Advanced_overpower:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_Advanced_overpower:GetModifierPreAttack_BonusDamagePostCrit(params) 
	if IsServer() then
		if self.advanced_level>=15 then
			if self:GetAbility().unlock3 then
				return math.min(self:GetStackCount()*10,5000)+self.bonus_attack_damage
			end
			return self:GetStackCount()*10+self.bonus_attack_damage
		end
	end

 end

-- function modifier_Advanced_overpower:GetModifierTotalDamageOutgoing_Percentage(keys)


-- 	if self:GetParent()==keys.attacker then
-- 		if self:GetParent() :IsInSpecialAttack() then
-- 			return
-- 		end
-- 		if keys.damage_category==1 and keys.original_damage>50 and self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1)   >=RandomInt(1, 100) then
-- 			keys.target:EmitSound("Hero_Centaur.DoubleEdge.TI9")
-- 			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9_tgt_rope.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
-- 			ParticleManager:SetParticleControl(particle_cast_fx, 1, keys.target:GetAbsOrigin())
-- 			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
-- 			return 50
-- 		end
-- 	end
	
-- end






-- advanced_modifier
function modifier_Advanced_overpower:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_overpower:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)

	if self:GetParent()==keys.attacker then
		if self:GetParent() :IsInSpecialAttack() then
			return
		end
		if keys.damage_category==1 and keys.original_damage>50 and self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1)   >=RandomInt(1, 100) then
			keys.target:EmitSound("Hero_Centaur.DoubleEdge.TI9")
			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9_tgt_rope.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(particle_cast_fx, 1, keys.target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			return 50
		end
	end
end

