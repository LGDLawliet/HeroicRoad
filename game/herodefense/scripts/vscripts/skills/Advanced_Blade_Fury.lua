
Advanced_Blade_Fury = class({})


	--[[该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level]]


LinkLuaModifier( "modifier_Advanced_Blade_Fury", "skills/Advanced_Blade_Fury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Blade_Fury_timeslash", "skills/Advanced_Blade_Fury", LUA_MODIFIER_MOTION_NONE )

Advanced_Blade_Fury = class({})

function Advanced_Blade_Fury:Precache( context )
    PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_sword_shred/juggernaut_blade_fury_shred.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_time_cleave/slash_effect/effect_top.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_time_cleave/main_effect/effect_crit.vpcf", context )
end

function Advanced_Blade_Fury:CheckKV(key)
	local table = {
		radius = 2,
		duration = 0.02,
	}
	local value = table[key] or -1
	return value

end
--------------------------------------------------------------------------------
function Advanced_Blade_Fury:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level >= 5 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end

function Advanced_Blade_Fury:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Advanced_Blade_Fury:OnSpellStart()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(0.2)
	local bDuration = self:GetSpecialValueFor("duration")*gain


	caster:AddNewModifier(
		caster,
		self, 
		"modifier_Advanced_Blade_Fury",
		{ duration = bDuration }
	)
	if advanced_level >= 5 then
		caster:Purge(false, true, false, true, true)
	end
end
-------------------------------------------------------------------------------
modifier_Advanced_Blade_Fury = advanced_modifier({})


function modifier_Advanced_Blade_Fury:IsHidden()	return false end
function modifier_Advanced_Blade_Fury:IsDebuff()	return false end
function modifier_Advanced_Blade_Fury:IsPurgable()	return false end

function modifier_Advanced_Blade_Fury:OnCreated( kv )
	if IsServer() then
		self.tick = self:GetAbility():GetSpecialValueFor( "interval" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.max = self:GetAbility():GetSpecialValueFor( "max" )
		self.radius_max = self:GetAbility():GetSpecialValueFor( "radius_max" )
		local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
		local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

		if advanced_level >= 10 then
			local speed = self:GetCaster():GetAttackSpeed(false)*100
			--print(speed)
			local tick_down = math.floor(speed/100)*0.01
			self.tick = math.max((self.tick - tick_down),0.2)
			--print(self.tick)
		end
		self:StartIntervalThink( self.tick )
		self:PlayEffects()
	end
end

function modifier_Advanced_Blade_Fury:OnRefresh( kv )
	if IsServer() then
		self.tick = self:GetAbility():GetSpecialValueFor( "interval" )
		self.max = self:GetAbility():GetSpecialValueFor( "max" )
		self.radius_max = self:GetAbility():GetSpecialValueFor( "radius_max" )
		local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
		local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

		if advanced_level >= 20 then
			if self.radius and self.radius >= self.radius_max then
				self:TimeSlash()
			end
		end
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end
end

function modifier_Advanced_Blade_Fury:OnDestroy( kv )
	local sound_cast = "Hero_Juggernaut.BladeFuryStart"
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level >= 20 then
		if self.radius and self.radius >= self.radius_max then
			self:TimeSlash()
		end
	end
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_Advanced_Blade_Fury:TimeSlash()
	if not IsServer() then
		return
	end
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_time_cleave/main_effect/effect_crit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	DestroyParticleByDelay(effect_cast,3)

	self:GetParent():EmitSound("chaotic_six_light_continuous_slash_cast")
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false
	)

	for _ , enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_Advanced_Blade_Fury_timeslash",{duration = self:GetAbility():GetSpecialValueFor("lv20_duration")})
	end
end

function modifier_Advanced_Blade_Fury:OnIntervalThink()
	
	self.radius = self.radius * (1+self:GetAbility():GetSpecialValueFor("bonus_radius")*0.01)
	self.radius = math.min(self.radius,self.radius_max)

	self:Fury(self.radius,self.max)
end

-- 单次风暴执行
function modifier_Advanced_Blade_Fury:Fury(radius,max)
	if not IsServer() then
		return
	end
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	local parent = self:GetParent()
	parent:Purge(false, true, false, false, false)--弱驱散
	local radius = radius
	local max = max

	if radius >= self.radius_max then
		self:SetStackCount(1)
		ProjectileManager:ProjectileDodge(parent) --弹道躲闪
		if advanced_level >= 15 then
			max = 7
		end
		--print("大回天触发！")
	else
		self:SetStackCount(0)
	end
	if self.effect then
		ParticleManager:SetParticleControl( self.effect, 5, Vector( radius, 0, 0 ) )
	end
	
	local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
	}
	local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false
	)
	
	local i = 0
	for _ , enemy in pairs(enemies) do
		parent:PerformAttack(enemy, true, true, true, true, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
		self:PlayEffects2( enemy )
		i = i + 1 
		if i >= max then
			break
		end
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

function modifier_Advanced_Blade_Fury:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_Advanced_Blade_Fury:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_Advanced_Blade_Fury:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_Advanced_Blade_Fury:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_move")
end

function modifier_Advanced_Blade_Fury:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self:GetStackCount()*self:GetAbility():GetSpecialValueFor("incoming")
end

function modifier_Advanced_Blade_Fury:PlayEffects()
	local particle_cast = "particles/econ/items/juggernaut/jugg_sword_shred/juggernaut_blade_fury_shred.vpcf"
	local sound_cast = "Hero_Juggernaut.BladeFuryStart"

	self.effect = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect, 5, Vector( self.radius, 0, 0 ) )

	self:AddParticle(
		self.effect,
		false,
		false,
		-1,
		false,
		false
	)
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Advanced_Blade_Fury:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-------------------------------------------------------------------------------
modifier_Advanced_Blade_Fury_timeslash = advanced_modifier({})


function modifier_Advanced_Blade_Fury_timeslash:IsHidden() 	return true end
function modifier_Advanced_Blade_Fury_timeslash:IsPurgable() 		    return false end
function modifier_Advanced_Blade_Fury_timeslash:IsPurgeException() return false end
function modifier_Advanced_Blade_Fury_timeslash:IsDebuff() return true end
--function modifier_Advanced_Blade_Fury_timeslash:GetEffectName() return "particles/rebuild/spell/chaotic_time_cleave/slash_effect/effect_top.vpcf" end
function modifier_Advanced_Blade_Fury_timeslash:OnCreated()
	self.ability = self:GetAbility()
	self.lv20_armor = self.ability:GetSpecialValueFor("lv20_armor")
	self:PlayEffect(self:GetParent())
end

function modifier_Advanced_Blade_Fury_timeslash:OnRefresh()
	self.ability = self:GetAbility()
	self.lv20_armor = self.ability:GetSpecialValueFor("lv20_armor")
	self:PlayEffect(self:GetParent())
end

function modifier_Advanced_Blade_Fury_timeslash:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_Advanced_Blade_Fury_timeslash:Advanced_GetModifierPhysicalArmorBonus()
	return -self.lv20_armor
end

function modifier_Advanced_Blade_Fury_timeslash:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end

function modifier_Advanced_Blade_Fury_timeslash:PlayEffect(target)
	if not IsServer() then
		return
	end
	local target_pos = target:GetOrigin() + Vector(0,0,128)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_time_cleave/slash_effect/effect_top.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target_pos)

	local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
	local pos_1 = target_pos + vDir * 300
	local pos_2 = target_pos - vDir *300 + Vector(0,0,RandomInt(-20, 180))
	ParticleManager:SetParticleControl( effect_cast, 2, pos_1)
	ParticleManager:SetParticleControl( effect_cast, 3, pos_2)

	DestroyParticleByDelay(effect_cast,3)
end