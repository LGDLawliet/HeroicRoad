Advanced_return = class({})
LinkLuaModifier( "modifier_Advanced_return", "skills/Advanced_return", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_return_arua_effect", "skills/Advanced_return", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_return_debuff", "skills/Advanced_return", LUA_MODIFIER_MOTION_NONE )
function Advanced_return:CheckKV(key)
	local table = {
		damage = 2,
		damage_index=0.015,



	}
	local value = table[key] or -1
	return value

end

function Advanced_return:GetIntrinsicModifierName()	return "modifier_Advanced_return" end
function Advanced_return:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/return/return_unlock1_rings.vpcf", context )
end
function Advanced_return:UnlockFirstCore(key)
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_return")
	if modifier then
		modifier:Unlock1Effect()
	end
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
function Advanced_return:UnlockSecondCore(key)
		-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock2",{})
	
	return true
end
function Advanced_return:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end

function Advanced_return:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
	end


	return self.BaseClass.GetBehavior(self)
	
end


modifier_Advanced_return = advanced_modifier({})


function modifier_Advanced_return:IsHidden()	return true end
function modifier_Advanced_return:IsPurgable() 		return false end
function modifier_Advanced_return:IsPurgeException() 	return false end
function modifier_Advanced_return:RemoveOnDeath()  return false end
function modifier_Advanced_return:IsAura() return true end
function modifier_Advanced_return:GetAuraDuration() return 0.5 end
function modifier_Advanced_return:GetModifierAura() return "modifier_Advanced_return_arua_effect" end
function modifier_Advanced_return:GetAuraRadius() return 1500 end
function modifier_Advanced_return:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_return:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_return:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_return:GetAuraEntityReject(hEntity)

	if hEntity == self:GetParent() then
		return true
	end
	return false
end
function modifier_Advanced_return:Unlock1Effect()
	local caster = self:GetCaster()
	local pfx1 = ParticleManager:CreateParticle("particles/rebuild/spell/return/return_unlock1_rings.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW,nil, caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx1)
	self:SetStackCount(1)
	self:StartIntervalThink(10)
end
function modifier_Advanced_return:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability:GetAutoCastState() then
		return
	end
	local caster = self:GetCaster()
	if self:GetStackCount()==1 then
		self:SetStackCount(2) --阴极
		-- particles/rebuild/spell/return/return_unlock1_rings.vpcf

		local pfx1 = ParticleManager:CreateParticle("particles/rebuild/spell/return/return_unlock1_rings.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW,nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl( pfx1, 60, Vector(134,3,1) )
		ParticleManager:SetParticleControl( pfx1, 61, Vector(1,0,0) )
		ParticleManager:ReleaseParticleIndex(pfx1)
		caster:EmitSound("Hero_Centaur.DoubleEdge.Precast.TI9")
	else
		self:SetStackCount(1) --阳极
		local pfx1 = ParticleManager:CreateParticle("particles/rebuild/spell/return/return_unlock1_rings.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW,nil, caster:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl( pfx1, 60, Vector(134,3,1) )
		-- ParticleManager:SetParticleControl( pfx1, 61, Vector(1,0,0) )
		ParticleManager:ReleaseParticleIndex(pfx1)
		caster:EmitSound("Hero_Centaur.DoubleEdge.Precast.TI9")
	end
end

function modifier_Advanced_return:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_return:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_Advanced_return:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
			return
		end
		if self:GetStackCount()==2 then
			return
		end
		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		local target = keys.attacker
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		self.advanced_level = ability.advanced_level
		self.damage = ability:GetSpecialValueFor( "damage" ) +caster:GetStrength()*(ability:GetSpecialValueFor( "damage_index" ))
		if ability.unlock2 then
			if not ability.current_target or ability.current_target:IsNull()  or not ability.current_target:IsAlive() then
				ability.current_target = target
				ability.current_bonus = 1
			end
			target = ability.current_target
			ability.current_bonus = math.min(ability.current_bonus +0.01,5)
			self.damage = self.damage * ability.current_bonus
		end
		-- get damage
		local damage = self.damage
		local ex_damage_index =0.1
		--LV5解锁借力打力+
		if self.advanced_level>=5 then
			ex_damage_index = 0.18
			--LV15解锁全属性附加
			if self.advanced_level>=15 then
				damage = damage+caster:GetIntellect(false)*0.3+caster:GetAgility()*0.3
				--LV20解锁生命附加
				if self.advanced_level>=20 then
					damage = damage + caster:GetMaxHealth()*0.01
				end
			end
		end
		damage = damage +  math.min(keys.damage*ex_damage_index, self:GetParent():GetStrength()*150)
		if self:GetStackCount()==1 then
			damage = damage * 4
		end
		self:PlayEffects(target )
		-- local nearby_enemy_units = FindUnitsInRadius(
        --     caster:GetTeamNumber(), 
        --     caster:GetAbsOrigin() , 
        --     nil, 
        --     300, 
        --     DOTA_UNIT_TARGET_TEAM_ENEMY, 
        --     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        --     DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        --     FIND_CLOSEST, 
        --     false
        -- )
		-- local enemy_num = #nearby_enemy_units
		-- --根据敌人数量调整伤害倍率 2024-3-14
		-- if IsServer() then
		-- 	damage = damage * (1 + enemy_num * ability:GetSpecialValueFor( "enemy_num_mul" ) )
		-- 	--print("伤害倍率"..(enemy_num * ability:GetSpecialValueFor( "enemy_num_mul" ))..",敌人数量"..enemy_num)
		-- end
		-- Apply Damage
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = ability, --Optional.
		}
		
		ApplyDamage(damageTable)

		-- Play effects

		if ability.unlock3 and target:IsAlive() then
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, ability, "modifier_Advanced_return_debuff", {duration = 60*StatusResistance})
	
		end
	end
end


function modifier_Advanced_return:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
	
end


function modifier_Advanced_return:AdvancedGetModifierConstantHealthRegenPercentage( params ) 
	return self:GetStackCount()==2 and 7 or 0 
end

function modifier_Advanced_return:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end



modifier_Advanced_return_arua_effect = class({})

function modifier_Advanced_return_arua_effect:IsDebuff() return false end
function modifier_Advanced_return_arua_effect:IsHidden() return false end
function modifier_Advanced_return_arua_effect:IsPurgable() return false end


function modifier_Advanced_return_arua_effect:OnCreated(table)
	-- self.ability = self:GetAbility()

	self.caster = self:GetCaster()
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_return_arua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_Advanced_return_arua_effect:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion() or self.caster:PassivesDisabled() then
			return
		end
		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local target = keys.attacker
		self.advanced_level = ability.advanced_level
		self.damage = ability:GetSpecialValueFor( "damage" )+2*self.advanced_level +self.caster:GetStrength()*(ability:GetSpecialValueFor( "damage_index" ))
		if ability.unlock2 then
			if not ability.current_target or ability.current_target:IsNull()  or not ability.current_target:IsAlive() then
				ability.current_target = target
				ability.current_bonus = 1
			end
			target = ability.current_target
			ability.current_bonus = math.min(ability.current_bonus +0.01,5)
			self.damage = self.damage * ability.current_bonus
		end
		-- get damage
		local damage = self.damage
		local ex_damage_index =0.1
		--LV5解锁借力打力+
		if self.advanced_level>=5 then
			ex_damage_index = 0.18
			--LV15解锁全属性附加
			if self.advanced_level>=15 then
				damage = damage+self.caster:GetIntellect(false)*0.3+self.caster:GetAgility()*0.3
				--LV20解锁生命附加
				if self.advanced_level>=20 then
					damage = damage + self:GetParent():GetMaxHealth()*0.01 --调整最大血量为自身 2024-3-14
				end
			end
		end
		damage = damage + math.min(keys.damage*ex_damage_index, self:GetParent():GetStrength()*150)
		local reduce = 0.75 --调整反伤倍率 2024-3-14
		--LV10解锁领域反击+
		if self.advanced_level>=10 then
			reduce = 1.0
		end
		damage = damage *reduce
		self:PlayEffects( target )
		-- Apply Damage
		local damageTable = {
			victim =target,
			attacker = self.caster,
			-- attacker = self.caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability =ability, --Optional.
		}
		ApplyDamage(damageTable)

		-- Play effects
	
		if ability.unlock3 and target:IsAlive() then
			local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex()
			local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			target:AddNewModifier(self.caster, ability, "modifier_Advanced_return_debuff", {duration = 60*StatusResistance})
	
		end
	end
end


function modifier_Advanced_return_arua_effect:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
end





modifier_Advanced_return_debuff = advanced_modifier({})

function modifier_Advanced_return_debuff:IsHidden()	return false end
function modifier_Advanced_return_debuff:IsDebuff()	return true end
function modifier_Advanced_return_debuff:IsPurgable()	return false end
function modifier_Advanced_return_debuff:IsPurgeException() return true  end

function modifier_Advanced_return_debuff:Advanced_GetModifierPhysicalArmorBonus()	return -2*self:GetStackCount() end






function modifier_Advanced_return_debuff:OnCreated(params)
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
function modifier_Advanced_return_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 50 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_return_debuff:OnIntervalThink()
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

function modifier_Advanced_return_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end