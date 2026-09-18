--特效优化 √
Advanced_Shadow_Wave = class({})

LinkLuaModifier("modifier_Advanced_Shadow_Wave_armor_bonus", "skills/Advanced_Shadow_Wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Shadow_Wave_armor_debuff", "skills/Advanced_Shadow_Wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Shadow_Wave_armor_unlock2_thinker", "skills/Advanced_Shadow_Wave", LUA_MODIFIER_MOTION_NONE)
function Advanced_Shadow_Wave:CheckKV(key)
	local table = {
		basic_damage=6,
		bonus_damage=0.04,


	}
	if self:GetUnlock(3)==3 then
		table.basic_damage = 36
		table.bonus_damage=0.24
	end



	local value = table[key] or -1
	return value

end
function Advanced_Shadow_Wave:UnlockFirstCore(key)
	return true
end
function Advanced_Shadow_Wave:UnlockSecondCore(key)

	return true
end
function Advanced_Shadow_Wave:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_laguna_blade_passive",{})
	return true
end



function Advanced_Shadow_Wave:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/shadow_wave/unlock2/thinker_effectformation.vpcf", context )

	
end
function Advanced_Shadow_Wave:IsHiddenWhenStolen() 		return false end
function Advanced_Shadow_Wave:IsRefreshable() 			return true  end
function Advanced_Shadow_Wave:IsStealable() 				return true  end
function Advanced_Shadow_Wave:IsNetherWardStealable()	return true end
function Advanced_Shadow_Wave:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT
		end
		
	end


	return self.BaseClass.GetBehavior(self)
	
end

function Advanced_Shadow_Wave:GetCooldown(iLevel)
	if self:GetUnlock(3)==3 then
		return 5
	end
	return  self.BaseClass.GetCooldown(self,iLevel)
end



function Advanced_Shadow_Wave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if self.unlock2 then
		local target_point 	= self:GetCursorPosition()
		if self.thinker then
			UTIL_Remove( self.thinker )
			self.thinker = nil
		end
		self.thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Shadow_Wave_armor_unlock2_thinker", 
			{duration = -1}, -- kv
			target_point,
			caster:GetTeamNumber(),
			false
		)
		local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW,"attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.thinker, PATTACH_POINT_FOLLOW, nil,self.thinker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(target_point, "Hero_Dazzle.Shadow_Wave", caster)
		return
	end


	self:CastSpell(target)
end

function Advanced_Shadow_Wave:CastSpell(target,source)
	local caster = self:GetCaster()
	local units = {}
	local radius = self:GetSpecialValueFor("bounce_radius")
	units[#units + 1] = target
	local max_target = self:GetSpecialValueFor("bounce_number")
	for _, aunit in pairs(units) do
		local units1 = FindUnitsInRadius(caster:GetTeamNumber(), aunit:GetAbsOrigin(), nil, radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == caster then  --判断取出的单位是否是施法者或已存在于列表中
					no_yet = false                        --如果是 则纪录
					break
				end
			end
			if no_yet then
				units[#units + 1] = unit1
				break
			end
			if #units > max_target then
				break
			end
		end
	end
	if caster ~= target then   --施法对象不上自身则插入自身
		table.insert(units, 1, caster)
	end

	local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
	local pfx_damage = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_impact_damage.vpcf"
	local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_Advanced_Shadow_Wave_armor_bonus", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain}):SetStackCount(#units)
	local basic_heal = self:GetSpecialValueFor("basic_damage")+(self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	if self.unlock2 then
		local summon_intensity_gain = caster:GetSummonIntensityIndex(1)
		basic_heal = basic_heal * summon_intensity_gain
	end
	local bonus_heal_index = self:GetSpecialValueFor("bonus_hp")
	--LV5解锁光明波+
	if self.advanced_level>=5 then
		bonus_heal_index = 0.35
		if self.unlock1 then
			bonus_heal_index = 0.6
			if caster:GetRandomEffect(30,INT_TYPE,1)  > RandomInt(1, 100) then
				bonus_heal_index =1
			end
		end
	end

	if source then
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_POINT_FOLLOW,nil, source:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc",caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	for k, unit in pairs(units) do
		local i = (k == #units) and k or (k + 1)
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		if unit == caster then
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		else
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControlEnt(pfx, 1, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i]:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)

		local health = ((unit:GetMaxHealth() - unit:GetHealth()) * (bonus_heal_index)+basic_heal )
		if self.unlock3 then
			unit:Purge(false, true, false, false, false)
		end
		local healing = HealWithGain(health,caster,unit,self)

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		local damage = health 
		--LV20解锁光明波++
		if self.advanced_level>=20 then
			damage = healing
		end

		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Dazzle.Shadow_Wave", caster)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self:GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				if self.unlock3 then
					enemy:Purge(true, false, false, false, false)
				end
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
					}
                ApplyDamage(damageTable)
				--LV15解锁黯淡波
				if self.advanced_level>=15 then
					local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
					local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					enemy:AddNewModifier(caster, self, "modifier_Advanced_Shadow_Wave_armor_debuff", {duration = 10*StatusResistance})
				end
                local pfx2 = ParticleManager:CreateParticle(pfx_damage, PATTACH_CUSTOMORIGIN, enemy)
                ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(pfx2, 1, enemy:GetAbsOrigin() + (enemy:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * 100)
                ParticleManager:ReleaseParticleIndex(pfx2)
			end
		end
	end
end


modifier_Advanced_Shadow_Wave_armor_bonus = advanced_modifier({})

function modifier_Advanced_Shadow_Wave_armor_bonus:IsDebuff()			return false end
function modifier_Advanced_Shadow_Wave_armor_bonus:IsHidden() 			return false end
function modifier_Advanced_Shadow_Wave_armor_bonus:IsPurgable() 		return true end
function modifier_Advanced_Shadow_Wave_armor_bonus:IsPurgeException() 	return true end
function modifier_Advanced_Shadow_Wave_armor_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Shadow_Wave_armor_bonus:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
}
end
function modifier_Advanced_Shadow_Wave_armor_bonus:OnCreated(keys)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	self.bonus_magic_resistance = 0
	--LV10解锁暗夜护盾+
	if self.advanced_level>=10 then
		self.bonus_magic_resistance = 4
	end
	self.armor = self:GetAbility():GetSpecialValueFor("armor_bonus")

end
function modifier_Advanced_Shadow_Wave_armor_bonus:GetModifierPhysicalArmorBonus() return self.armor* self:GetStackCount() end
function modifier_Advanced_Shadow_Wave_armor_bonus:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance* self:GetStackCount() end

function modifier_Advanced_Shadow_Wave_armor_bonus:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end




modifier_Advanced_Shadow_Wave_armor_debuff = advanced_modifier({})

function modifier_Advanced_Shadow_Wave_armor_debuff:IsDebuff() return true end
function modifier_Advanced_Shadow_Wave_armor_debuff:IsHidden() return false end
function modifier_Advanced_Shadow_Wave_armor_debuff:IsPurgable() return false end
function modifier_Advanced_Shadow_Wave_armor_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_Shadow_Wave_armor_debuff:Advanced_GetModifierPhysicalArmorBonus()	return -2*self:GetStackCount() end




function modifier_Advanced_Shadow_Wave_armor_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Shadow_Wave_armor_debuff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Shadow_Wave_armor_debuff:OnIntervalThink()
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





modifier_Advanced_Shadow_Wave_armor_unlock2_thinker= modifier_Advanced_Shadow_Wave_armor_unlock2_thinker or class({})

function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:IsHidden()		return true end
function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:IsPurgable()		return false end
function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()

		local particle_cast = "particles/rebuild/spell/shadow_wave/unlock2/thinker_effectformation.vpcf"
		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
		local pos = self:GetParent():GetOrigin()
		-- pos.z = pos.z -400
		self.radius =  ability:GetCastRange(pos, nil)
		ParticleManager:SetParticleControl( self.effect_cast, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, 0, 0 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(9999, 0, 0 ) )


		self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(0, 0, 0 ) )
		ParticleManager:SetParticleControl( self.effect_cast2, 2, Vector(9999, 0, 0 ) )
		-- ParticleManager:ReleaseParticleIndex( self.effect_cast )
		pos.z  =  pos.z  +200
		self:GetParent():SetOrigin(pos)
		self:StartIntervalThink(2)
	end
end
function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast,true	)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		ParticleManager:DestroyParticle(self.effect_cast2,true	)
		ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
		UTIL_Remove( self:GetParent() )
	end
end



function modifier_Advanced_Shadow_Wave_armor_unlock2_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:IsAlive() or not ability then
		self:SafeDestroy()
		return
	end
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _, unit in ipairs(enemies) do

		ability:CastSpell(unit,self:GetParent())
		break
	end





end



