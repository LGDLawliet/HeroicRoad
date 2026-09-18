--特效优化 √
Advanced_lightning_storm = class({})
LinkLuaModifier( "modifier_Advanced_lightning_storm", "skills/Advanced_lightning_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lightning_storm_thinker", "skills/Advanced_lightning_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lightning_storm_buff", "skills/Advanced_lightning_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lightning_storm_unlock2", "skills/Advanced_lightning_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lightning_storm_unlock3", "skills/Advanced_lightning_storm", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function Advanced_lightning_storm:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_lightning_storm_thinker", -- modifier name
		{  }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local modifier = thinker:FindModifierByName( "modifier_Advanced_lightning_storm_thinker" )
	modifier:Cast( target )
end
function Advanced_lightning_storm:CheckKV(key)
	local table = {

	


		damage = 10,
		bonus_damage = 0.08,



	}
	local value = table[key] or -1
	return value

end


function Advanced_lightning_storm:UnlockFirstCore(key)
	return true
end
function Advanced_lightning_storm:UnlockSecondCore(key)
		local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_lightning_storm_unlock2",{})
	return true
end
function Advanced_lightning_storm:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_lightning_storm_unlock3",{})
	return true
end

function Advanced_lightning_storm:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end

	return self.BaseClass.GetBehavior(self)
end

function Advanced_lightning_storm:Unlock2Lighting( target ,index)
	local ability = self
	local caster = self:GetCaster()
	if not target:IsMagicImmune() then
		local damage = self:GetSpecialValueFor( "damage" )+(self:GetSpecialValueFor( "bonus_damage" ))*caster:GetIntellect(false)
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = damage*index,
			damage_type = self:GetAbilityDamageType(),
			ability = self, 
		}
		ApplyDamage( damageTable )
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, ability,"modifier_Advanced_lightning_storm", {duration = self:GetSpecialValueFor( "duration" )*StatusResistance,} )
		caster:AddNewModifier(caster, ability, "modifier_Advanced_lightning_storm_buff", {duration = 45})
		
		
		
	end
	self:PlayEffects( target )
end

function Advanced_lightning_storm:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
	local sound_cast = "Hero_Leshrac.Lightning_Storm"

	-- get data
	local location = target:GetOrigin()
	local height = Vector( 0, 0, 100 )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 800 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end



modifier_Advanced_lightning_storm_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_lightning_storm_thinker:IsHidden()	return true end
function modifier_Advanced_lightning_storm_thinker:IsPurgable()	return false end

function modifier_Advanced_lightning_storm_thinker:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if not IsServer() then return end
	self.chance_add_count = 0 --增伤次数
	-- references
	self.delay = 0.2
	self.count = self:GetAbility():GetSpecialValueFor( "jump_count" )
	self.radius = 600
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.bonus_damage_index = 1
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )+(self:GetAbility():GetSpecialValueFor( "bonus_damage" ))*self:GetCaster():GetIntellect(false)
	self.bonus_count = 0
	self.bonus_damage_increment = 0.07
	self.buff_duration = 30
	if self.advanced_level>=10 then
		self.buff_duration = 45
		if self.advanced_level>=20 then
			self.bonus_damage_increment = 0.07 --lv20增加伤害增长
		end
	end
	--[[if self.advanced_level>=5 then
		self.bonus_damage_increment = 0.11
		if self.advanced_level>10 then
			self.buff_duration = 45
		end
	end]]
	self.unlock1_count  = 0

	-- init and precache
	self.targets = {}
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

end

function modifier_Advanced_lightning_storm_thinker:Cast( target )
	-- guaranteed on server
	self.current_target = target
	self.started = false
	self:StartIntervalThink( self.delay )
end


function modifier_Advanced_lightning_storm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_lightning_storm_thinker:OnIntervalThink()
	if not IsValid(self.current_target) then
		self:SafeDestroy()
		return
	end
	if not self.started then
		self.started = true

		self:Struck( self.current_target,1 )
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.current_target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	local found = false
	for _,enemy in pairs(enemies) do
		if not self.targets[enemy] then
			found = true
			self.current_target = enemy
			self:Struck( enemy ,1)
			return
		end
	end
	--lv5 可以打击单一目标
	if self.advanced_level>=5 then
		
		for _,enemy in pairs(enemies) do
			found = true
			self.current_target = enemy

			self:Struck( enemy,0.3 )
			return
		end
	end

	if not found then
		self:SafeDestroy()
	end
end



function modifier_Advanced_lightning_storm_thinker:Struck( target ,index)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.unlock1 = ability.unlock1 and true or false
	if not target:IsMagicImmune() then
		-- damage
		self.damageTable.victim = target

		self.damageTable.damage = self.damage *index * self.bonus_damage_index
		ApplyDamage( self.damageTable )

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(
			caster, -- player source
			ability, -- ability source
			"modifier_Advanced_lightning_storm", -- modifier name
			{
				duration = self.duration*StatusResistance,

			} -- kv
		)
		caster:AddNewModifier(caster, ability, "modifier_Advanced_lightning_storm_buff", {duration = self.buff_duration})
		-- track targeted
		self.targets[target] = true
		if target:GetHealth()<=0 then
			self.bonus_damage_index = self.bonus_damage_index +self.bonus_damage_increment
			self.damageTable.damage = self.damage * self.bonus_damage_index
			if self.bonus_count<10 then
				self.count = self.count +1
				self.bonus_count = self.bonus_count+1
			end
			
		end

	end

	-- play effects
	ability:PlayEffects( target )
	--LV20有30概率本次打击不减少次数,受概率加成影响
	
	local chance = 40 * math.min(self.chance_add_count*0.05+1,1.4)
	
	--原石1概率修正
	local max_chance = 90
	if self.unlock1 then
		max_chance = 95
	end
	--修正后概率
	local chance_mordify = math.min(self:GetCaster():GetRandomEffect(chance,INT_TYPE,1),max_chance)
	print("本次闪电触发后不减少概率为百分之",chance_mordify,"增伤比为",self.bonus_damage_index)
	--LV20触发增加次数后也会增加伤害
	if self.advanced_level>=20 then
		if chance_mordify>=RandomInt(1, 100) then
			self.count = self.count + 1
			--如果解锁石头1本技能会叠加闪电风暴增伤，上限40倍 否则上限4倍
			if self.unlock1 then
				self.bonus_damage_index =math.min(40, self.bonus_damage_index +self.bonus_damage_increment)
				self.chance_add_count = self.chance_add_count+1
			else
			self.bonus_damage_index =math.min(4, self.bonus_damage_index +self.bonus_damage_increment)
			self.chance_add_count = self.chance_add_count+1
			end
		end
	end	
	-- count 计数减少1
	self.count = self.count - 1
	if self.count<=0 then
		if ability:GetAutoCastState() and self.unlock1_count<35 then
			local mana = caster:GetMana()
			if mana>=100 then
				caster:SpendMana( 100, ability )
				self.count = self.count + 1
				self.unlock1_count = self.unlock1_count + 1
				return
			end
		end
		self:SafeDestroy()
	end
end

-- function modifier_Advanced_lightning_storm_thinker:PlayEffects( target )
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
-- 	local sound_cast = "Hero_Leshrac.Lightning_Storm"

-- 	-- get data
-- 	local location = target:GetOrigin()
-- 	local height = Vector( 0, 0, 100 )

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
-- 	ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 800 ) )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		1,
-- 		target,
-- 		PATTACH_POINT_FOLLOW,
-- 		"attach_hitloc",
-- 		Vector(0,0,0), -- unknown
-- 		true -- unknown, true
-- 	)
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- Create Sound
-- 	EmitSoundOn( sound_cast, target )
-- end




modifier_Advanced_lightning_storm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_lightning_storm:IsHidden()	return false end
function modifier_Advanced_lightning_storm:IsDebuff()	return true end
function modifier_Advanced_lightning_storm:IsPurgable()	return true end
function modifier_Advanced_lightning_storm:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
	if self.advanced_level>=15 then
		self.slow = -999
	end
	if IsServer() then
		-- references
		
	end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_lightning_storm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_lightning_storm:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end







modifier_Advanced_lightning_storm_buff = class({})

function modifier_Advanced_lightning_storm_buff:IsDebuff() return false end
function modifier_Advanced_lightning_storm_buff:IsHidden() return false end
function modifier_Advanced_lightning_storm_buff:IsPurgable() return false end
function modifier_Advanced_lightning_storm_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	}
end
function modifier_Advanced_lightning_storm_buff:GetModifierBonusStats_Intellect()	return 2*self:GetStackCount() end




function modifier_Advanced_lightning_storm_buff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_lightning_storm_buff:OnRefresh(params)
	if IsServer() then

		local dieTime = self:GetDieTime()

		
		if self:GetStackCount() >=200 then
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

function modifier_Advanced_lightning_storm_buff:OnIntervalThink()
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









modifier_Advanced_lightning_storm_unlock2 = class({})

function modifier_Advanced_lightning_storm_unlock2:IsDebuff()			return false end
function modifier_Advanced_lightning_storm_unlock2:IsHidden() 			return true end
function modifier_Advanced_lightning_storm_unlock2:IsPurgable() 		return false end
function modifier_Advanced_lightning_storm_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_lightning_storm_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_lightning_storm_unlock2:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_lightning_storm_unlock2:DeclareFunctions() return 
	{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
} 
end


function modifier_Advanced_lightning_storm_unlock2:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if flDamage<50 then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
	
		local ability = self:GetAbility()
		if Ability and Ability~=ability then
			if not Target.lightning_storm_unlock2 or Target.lightning_storm_unlock2<= GameRules:GetGameTime() then
				ability:Unlock2Lighting(Target,1)
				Target.lightning_storm_unlock2 = GameRules:GetGameTime()+3
			end
		end


	end

	return 0.0

end


modifier_Advanced_lightning_storm_unlock3 = class({})

function modifier_Advanced_lightning_storm_unlock3:IsDebuff()			return false end
function modifier_Advanced_lightning_storm_unlock3:IsHidden() 			return true end
function modifier_Advanced_lightning_storm_unlock3:IsPurgable() 		    return false end
function modifier_Advanced_lightning_storm_unlock3:IsPurgeException() return false end
function modifier_Advanced_lightning_storm_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_lightning_storm_unlock3:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(0.1)     

    end
end
function modifier_Advanced_lightning_storm_unlock3:OnIntervalThink()
  

    self.dis =self.dis+ CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    self.currentPos = self.parent:GetAbsOrigin()
    if self.dis>=500 then
        local selfAbility = self:GetAbility()
		if not selfAbility:IsCooldownReady() then
			return
		end
		local enemies = FindUnitsInRadius(
			self.parent:GetTeamNumber(),	-- int, your team number
			self.parent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
	
		
		for _,enemy in pairs(enemies) do
			self.dis = 0
			self.parent:SetCursorCastTarget(enemy)
            selfAbility:OnSpellStart()
			selfAbility:StartCooldown(2.5)
			break
		end
    end
end
