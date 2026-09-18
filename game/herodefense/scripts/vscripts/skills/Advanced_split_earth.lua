--特效优化 √
Advanced_split_earth = class({})
require('internal/timers')   --计时器功能
LinkLuaModifier( "modifier_Advanced_split_earth", "skills/Advanced_split_earth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_split_earth_debuff", "skills/Advanced_split_earth", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius

function Advanced_split_earth:CheckKV(key)
	local table = {
		damage=25,
		-- damage_index=0.02,
	}
	local value = table[key] or -1
	return value

end
-- function Advanced_split_earth:UnlockFirstCore(key)
-- 	-- local caster = self:GetCaster()
-- 	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
-- 	return true
-- end
function Advanced_split_earth:UnlockSecondCore(key)
		-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock2",{})
	return true
end
function Advanced_split_earth:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
function Advanced_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_split_earth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local delay = self:GetSpecialValueFor("delay")
	local bonus_count = 1
	local base_possablity = 70
	local max_possablity = 90
	local max_count = 5
	if self.unlock1 then
		base_possablity = 85
		max_possablity = 93
	end
		--LV10解锁多段+
		if self.advanced_level>=10 then
			--LV15解锁永续
			if self.advanced_level>=15 then
				bonus_count = bonus_count+1 --保底加1
				--随机概率为self:GetCaster():GetRandomEffect(50,INT_TYPE,1)和90的最小值
				local random_possablity = math.min(self:GetCaster():GetRandomEffect(base_possablity,INT_TYPE,1),max_possablity)
				--self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) 则循环bonus_count=bonus_count+1
				while random_possablity >=RandomInt(1, 100) do
					bonus_count = bonus_count+1
				end
				
				print("bonus_count",bonus_count,"random_possablity",random_possablity)
			else
				if self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
					bonus_count = bonus_count+2
				end
			end
		end
	
	--LV20设定保底值10并设置上限20
	if self.advanced_level>=20 then
		if self.unlock1 then
			bonus_count = math.max( 15,bonus_count)
		else	
			bonus_count =math.max( 10,math.min(bonus_count,20))
		end
	else
		bonus_count = math.min(bonus_count,max_count)
	end

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_split_earth", -- modifier name
		{ duration = delay,count = bonus_count, bonus_radius = 0,damage_index = 1}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	--[[LV20解锁共鸣
	if self.advanced_level>=20 then
		CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_split_earth", -- modifier name
			{ duration = delay,count = 1, bonus_radius = 0,damage_index = 0.5}, -- kv
			caster:GetAbsOrigin(),
			caster:GetTeamNumber(),
			false
		)
	end]]
end



modifier_Advanced_split_earth = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_split_earth:IsHidden()	return true end
function modifier_Advanced_split_earth:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_split_earth:OnCreated( kv )
	if not IsServer() then return end

	-- references
	local ability = self:GetAbility()
	self.bonus_radius = kv.bonus_radius
	self.duration = ability:GetSpecialValueFor( "duration" )--这是眩晕的时间
	self.radius =ability:GetSpecialValueFor( "radius" )+self.bonus_radius
	-- local damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("damage_index")+self:GetCaster():GetIntellect(false)
	local damage = ability:GetSpecialValueFor("damage")

	self.bonus_count = math.max(kv.count,0.2)
	self.damage_index = kv.damage_index
	--damage = damage *self.damage_index

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	-- ApplyDamage(damageTable)
end


function modifier_Advanced_split_earth:OnDestroy()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	local caster = self:GetCaster()
	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if ability.unlock1 and #enemies<=0 then
		local enemies2 = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies2>=1 then
			local new_target = enemies2[RandomInt(1,#enemies2)]
			self:GetParent():SetOrigin(new_target:GetOrigin())
			enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				self:GetParent():GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
		end

	end
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.8)
	local time = 120
	--LV5解锁颤魂+
	if ability.advanced_level>=5 then
		time = 180
		if ability.unlock3 then
			time = -1
		end
	end
	--当玩家有技能“Advanced_lightning_storm”时，对enemies里的所有单位释放一次单体“Advanced_lightning_storm”
	
	for _,enemy in pairs(enemies) do
		-- stun
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, ability, "modifier_stunned",{ duration = self.duration*StatusResistance} )

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(caster, ability, "modifier_Advanced_split_earth_debuff",{ duration = time*ModifierStatusNegativeGain } )
		if ability.unlock2 and enemy:GetHealthPercent()<=10 then
			TrueKill(caster, enemy, ability)
		end
		--lvl20解锁共鸣
		if ability.advanced_level>=20 then
			--判断是否有技能“Advanced_lightning_storm”,
			if caster:HasAbility("Advanced_lightning_storm") then
				--print("have Advanced_lightning_storm")
				local ability_lightning_storm = caster:FindAbilityByName("Advanced_lightning_storm")
				--print(ability_lightning_storm)
				if caster:FindAbilityByName("Advanced_lightning_storm") then
					--对enemies里的所有单位释放一次一半伤害的单体“Advanced_lightning_storm”
					ability_lightning_storm:Unlock2Lighting(enemy,0.5)
					--ability_lightning_storm:Struck({enemy[1]},0.2)
					--print("Unlock2Lighting")
				end
			end
			
		end
		
 
	end

	-- play effects
	self:PlayEffects()
	if self.bonus_count>=1 then
		local pos=self:GetParent():GetAbsOrigin()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius+100, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		local count = self.bonus_count-1
		local bonus_radius =  self.bonus_radius+100 
		local damage_index = self.damage_index-0.3
		local ability = ability
		Timers:CreateTimer(5.5, function()
			if not ability or ability:IsNull() then
				return
			end
			CreateModifierThinker(
				caster, -- player source
				ability, -- ability source
				"modifier_Advanced_split_earth", -- modifier name
				{ duration = 0.3,count = count,bonus_radius = bonus_radius,damage_index=damage_index }, -- kv
				pos,
				caster:GetTeamNumber(),
				false
			)
		end)
	
	end
	UTIL_Remove( self:GetParent() )

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_split_earth:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end







modifier_Advanced_split_earth_debuff = advanced_modifier({})

function modifier_Advanced_split_earth_debuff:IsDebuff() return true end
function modifier_Advanced_split_earth_debuff:IsHidden() return false end
function modifier_Advanced_split_earth_debuff:IsPurgable() return false end
function modifier_Advanced_split_earth_debuff:IsPurgeException() return true end

function modifier_Advanced_split_earth_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if not IsServer() then
		return
	end
	if keys.damage_type==DAMAGE_TYPE_MAGICAL  then
		return math.min(self.bonus*self:GetStackCount() ,200)
	end
	return 0
end




function modifier_Advanced_split_earth_debuff:OnCreated(params)
	if IsServer() then
		self.bonus = 3
		if self:GetAbility().unlock3 then
			self:IncrementStackCount()
			self.bonus = 5
			self.unlock = true
		else
			self.tData = {}
			table.insert(self.tData, { dieTime = self:GetDieTime() })
			self:IncrementStackCount()
			self:StartIntervalThink(0.1)
		end
		
	end
end
function modifier_Advanced_split_earth_debuff:OnRefresh(params)
	if IsServer() then
		if self.unlock then
			self:SetStackCount(math.min(100,self:GetStackCount()+1))
		else
			table.insert(self.tData, {dieTime = self:GetDieTime() })
			self:IncrementStackCount()
		end

	end
end

function modifier_Advanced_split_earth_debuff:OnIntervalThink()
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

function modifier_Advanced_split_earth_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
