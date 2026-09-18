--特效优化 √
LinkLuaModifier("modifier_Advanced_arcane_bolt_buff", "skills/Advanced_arcane_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_arcane_bolt_lv15", "skills/Advanced_arcane_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_arcane_bolt_debuff", "skills/Advanced_arcane_bolt", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_arcane_bolt_debuff_unlock3", "skills/Advanced_arcane_bolt", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_arcane_bolt_passive", "skills/Advanced_arcane_bolt", LUA_MODIFIER_MOTION_NONE)





require('internal/timers')   --计时器功能
Advanced_arcane_bolt = Advanced_arcane_bolt or class({})
function Advanced_arcane_bolt:CheckKV(key)
	local table = {
		damage = 5,
		bonus_damage = 0.1,



	}
	local value = table[key] or -1
	return value

end

function Advanced_arcane_bolt:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_arcane_bolt:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_arcane_bolt:UnlockThirdCore(key)
	self:GetCaster():AddItemByName("item_hd_Song_of_Eagle_Voice_of_Dragonus")
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end

--modifier_Advanced_arcane_bolt_passive getinstinctmodifier
function Advanced_arcane_bolt:GetIntrinsicModifierName()
	return "modifier_Advanced_arcane_bolt_passive"
end



function Advanced_arcane_bolt:Precache( context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/rebuild/spell/skywrath_mage_arcane_bolt_low_pride/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_bolt_advanced_buff/buff_effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_bolt_advanced_lv15/effect.vpcf", context )

	
end
function Advanced_arcane_bolt:OnAdvancedUpgrade()
	if self.advanced_level>=15 then
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_Advanced_arcane_bolt_lv15") then
			caster:AddNewModifier(caster, self, "modifier_Advanced_arcane_bolt_lv15", {}) 
		end
	end
end
function Advanced_arcane_bolt:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end


function Advanced_arcane_bolt:GetBehavior()

	if self:GetUnlock(2)==2 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 
end

function Advanced_arcane_bolt:GetChannelTime()

	if self:GetUnlock(2)==2 then
		return 20
	end
	return 0
end
function Advanced_arcane_bolt:OnSpellStart()
	if self.unlock2 then
		self.timer = GameRules:GetGameTime()
		return
	end
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/rebuild/spell/skywrath_mage_arcane_bolt_low_pride/effect.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "bolt_speed" )
	local projectile_vision = 300
	local base_damage = self:GetSpecialValueFor( "damage" )
	local multiplier = self:GetSpecialValueFor( "bonus_damage" )

	-- calculate damage
	local damage = base_damage
	if caster:IsHero() then
		damage = damage + multiplier*caster:GetIntellect(false)
	end

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			damage = damage,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local radius = math.max(self:GetCastRange(caster:GetOrigin(), target) +  caster:GetCastRangeBonus() ,10)
		
	-- find nearby enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local effectUnit = {}
	table.insert(effectUnit,target)

	local count = 1
	if self.advanced_level>=5 then
		count = 2
		if self.advanced_level>=10 then
			local modifier = caster:FindModifierByName("modifier_Advanced_arcane_bolt_buff")
			if modifier then
				local bonus = math.floor(modifier:GetStackCount()/20)
				count = count + math.min(bonus,5)
			end
		end
	end
	local localCount = 0
	for _,enemy in pairs(enemies) do
		if enemy~=target then
			info.Target = enemy
			ProjectileManager:CreateTrackingProjectile(info)
			localCount = localCount + 1
			table.insert(effectUnit,enemy)
			if localCount>=count then
				break
			end
		end
	end


	if self.unlock1 then
		local mul = RandomInt(1, 3)
		for i = 1, mul, 1 do
			Timers:CreateTimer(i*0.2, function()
				if not self:IsNull() then
					for _, unit in ipairs(effectUnit) do
						if unit and not unit:IsNull() and unit:IsAlive() then
							info.Target = unit
							ProjectileManager:CreateTrackingProjectile(info)
						end
					end
					
				end
			end)
		end
	end

	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function Advanced_arcane_bolt:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end	

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	local caster = self:GetCaster()
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = extraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- vision
	local vision = 350
	local duration = 3.53
	AddFOWViewer(
		caster:GetTeamNumber(), --nTeamID
		target:GetOrigin(), --vLocation
		vision, --flRadius
		duration, --flDuration
		false --bObstructedVision
	)

	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Impact"
	EmitSoundOn( sound_cast, target )

	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	StopSoundOn( sound_cast, caster )

		
	local gain = caster:GetModifierDurationGainIndex(1)

	local duration = 25*gain
	caster:AddNewModifier(
		caster,
		self,
		"modifier_Advanced_arcane_bolt_buff",
		{	duration = duration,stack_time = duration}
	)

	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/arcane_bolt_advanced_buff/buff_effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	if self.advanced_level>=20 and target:IsAlive() then
		
		local modifier = target:AddNewModifier(caster,self,"modifier_Advanced_arcane_bolt_debuff",{} )
		if modifier and modifier:GetStackCount()>=5 then
			modifier:SafeDestroy()
			self:LV15Effect(target)
		end
		if self.unlock3 then
			local modifier = caster:FindModifierByName("modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff")
			if modifier and modifier:GetStackCount()>=50 then
				target:AddNewModifier(caster,self,"modifier_Advanced_arcane_bolt_debuff_unlock3",{duration = 7} )
			end
		end
	end
	-- particles/rebuild/spell/arcane_bolt_advanced_buff/buff_effect.vpcf
end


function Advanced_arcane_bolt:LV15Effect(source)
	local caster = self:GetCaster()
	local radius = math.max(self:GetCastRange(caster:GetOrigin(), caster) +  caster:GetCastRangeBonus() ,10)
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), source:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)  
	local count = 2
	if self.unlock2 then
		count = 3
	end
	local effect = false
	for i, unit in ipairs(units) do
		self:CastTosingleTarget(unit,true,source)
		effect = true
		if i>=count then
			break
		end
	end
	if effect then
		source:EmitSound("Hero_SkywrathMage.MysticFlare.Cast")
	end
	
end

function Advanced_arcane_bolt:CastTosingleTarget(target,lv15,source)
	local caster = self:GetCaster()
	local projectile_name = "particles/rebuild/spell/skywrath_mage_arcane_bolt_low_pride/effect.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "bolt_speed" )
	local projectile_vision = 300
	local base_damage = self:GetSpecialValueFor( "damage" )
	local multiplier = self:GetSpecialValueFor( "bonus_damage" )

	-- calculate damage
	local damage = base_damage
	if caster:IsHero() then
		damage = damage + multiplier*caster:GetIntellect(false)
	end

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			damage = damage,
		}
	}
	if lv15 then
		info.Source = nil
		info.vSourceLoc = caster:GetOrigin() + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),2000)
		info.iMoveSpeed = 900
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/arcane_bolt_advanced_lv15/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0, source:GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, info.vSourceLoc)
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		Timers:CreateTimer(2.5, function()
			ProjectileManager:CreateTrackingProjectile(info)
		end)
	else
		ProjectileManager:CreateTrackingProjectile(info)
	end
	
	
end
function Advanced_arcane_bolt:Spawn()
	self.timer =0
end

function Advanced_arcane_bolt:OnChannelThink( flInterval )
	if IsServer() then
		if not self.unlock2 then
			return
		end
		if GameRules:GetGameTime() >= self.timer then
			self.timer =self.timer + 0.4
			self:LV15Effect(self:GetCaster())
		end
	end
end

--攻击后添加一层buff
modifier_Advanced_arcane_bolt_passive = class({})
function modifier_Advanced_arcane_bolt_passive:IsHidden() return true end
function modifier_Advanced_arcane_bolt_passive:IsPurgable() return false end
function modifier_Advanced_arcane_bolt_passive:IsPurgeException() return false end
function modifier_Advanced_arcane_bolt_passive:RemoveOnDeath() return false end
--onattackland 
function modifier_Advanced_arcane_bolt_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_Advanced_arcane_bolt_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target
	local ability = self:GetAbility()
	--attacker 不是有技能的单位 或者target 是魔免的单位
	
	if attacker == self:GetParent() then
		local ability = self:GetAbility()
		if ability:GetLevel() < 1 then
			return
		end
		if not target:IsAlive() then
			return
		end
		if  target:IsBuilding() or target:IsMagicImmune() then
			return
		end
		if not ability:IsCooldownReady() then
			return
		end
		--也会释放一次技能
		ability:CastTosingleTarget(target,false)
		ability:StartCooldown(0.5)
		if  ability.advanced_level>=20  then
			--给target添加1层modifier_Advanced_arcane_bolt_debuff，5层后触发LV15效果
			local modifier = target:AddNewModifier(attacker,ability,"modifier_Advanced_arcane_bolt_debuff",{} )
			if modifier and modifier:GetStackCount()>=5 then
				modifier:SafeDestroy()
				ability:LV15Effect(target)
			end
		end
		
	end
end





modifier_Advanced_arcane_bolt_buff = class({})

function modifier_Advanced_arcane_bolt_buff:IsHidden()	return false end
function modifier_Advanced_arcane_bolt_buff:IsDebuff()	return false end
function modifier_Advanced_arcane_bolt_buff:IsPurgable()	return false end
function modifier_Advanced_arcane_bolt_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}

	return funcs
end

function modifier_Advanced_arcane_bolt_buff:GetModifierBonusStats_Intellect()	return math.min(2*self:GetStackCount(),200) end



function modifier_Advanced_arcane_bolt_buff:OnCreated(params)
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
function modifier_Advanced_arcane_bolt_buff:OnRefresh(params)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+params.stack_time

		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_arcane_bolt_buff:OnIntervalThink()
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




modifier_Advanced_arcane_bolt_lv15 = class({})

function modifier_Advanced_arcane_bolt_lv15:IsDebuff() return false end
function modifier_Advanced_arcane_bolt_lv15:IsHidden() return true end
function modifier_Advanced_arcane_bolt_lv15:IsPurgable() 		return false end
function modifier_Advanced_arcane_bolt_lv15:IsPurgeException() 	return false end
function modifier_Advanced_arcane_bolt_lv15:RemoveOnDeath()  return false end
function modifier_Advanced_arcane_bolt_lv15:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整释放法术
		

	}
end





function modifier_Advanced_arcane_bolt_lv15:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	local ability = self:GetAbility()
	if keys.ability:GetCooldown(-1)>=3 and keys.ability~=ability then
		ability:LV15Effect(keys.unit)

	end

end












modifier_Advanced_arcane_bolt_debuff = class({})

function modifier_Advanced_arcane_bolt_debuff:IsHidden()	return false end
function modifier_Advanced_arcane_bolt_debuff:IsDebuff()	return true end
function modifier_Advanced_arcane_bolt_debuff:IsPurgable()	return false end
function modifier_Advanced_arcane_bolt_debuff:IsPurgeException() return false end
function modifier_Advanced_arcane_bolt_debuff:GetTexture() return "skywrath_mage_arcane_bolt" end
function modifier_Advanced_arcane_bolt_debuff:OnCreated()
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_arcane_bolt_debuff:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end












modifier_Advanced_arcane_bolt_debuff_unlock3 = class({})

function modifier_Advanced_arcane_bolt_debuff_unlock3:IsHidden()	return false end
function modifier_Advanced_arcane_bolt_debuff_unlock3:IsDebuff()	return true end
function modifier_Advanced_arcane_bolt_debuff_unlock3:IsPurgable()	return true end
function modifier_Advanced_arcane_bolt_debuff_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_Advanced_arcane_bolt_debuff_unlock3:GetModifierMagicalResistanceBonus()	return -8*self:GetStackCount() end


function modifier_Advanced_arcane_bolt_debuff_unlock3:OnCreated(params)
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
function modifier_Advanced_arcane_bolt_debuff_unlock3:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 4 then
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

function modifier_Advanced_arcane_bolt_debuff_unlock3:OnIntervalThink()
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