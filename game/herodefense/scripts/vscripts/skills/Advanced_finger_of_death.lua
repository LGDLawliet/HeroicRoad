--特效优化 √
require('internal/timers')   --计时器功能
Advanced_finger_of_death = class({})
LinkLuaModifier( "modifier_Advanced_finger_of_death", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_finger_of_death_count", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_finger_of_death_debuff", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_finger_of_death_unlock1", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_finger_of_death_unlock2", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_finger_of_death_unlock3", "skills/Advanced_finger_of_death", LUA_MODIFIER_MOTION_NONE )
function Advanced_finger_of_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/finger_of_death_unlock3/effect.vpcf", context )

	

end
function Advanced_finger_of_death:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_finger_of_death_unlock1",{})
	return true
end
function Advanced_finger_of_death:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_finger_of_death_unlock1",{})
	return true
end
function Advanced_finger_of_death:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- self.unlock3_modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_assassinate_unlock3",{})
	return true

end
function Advanced_finger_of_death:GetAbilityTextureName()
	if self:GetUnlock(2)==2 then
		return "lion/finger_of_death/lion_finger_of_death_immortal"
	end
	return "lion_finger_of_death"
end
function Advanced_finger_of_death:GetBehavior()
	if self:GetUnlock(2)==2 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_finger_of_death:CheckKV(key)
	local table = {


		base_damage = 20,
		bonus_damage = 0.2,


	}
	local value = table[key] or -1
	return value

end
function Advanced_finger_of_death:GetAOERadius()
	if self:GetSpecialValueFor("advanced_level")>=10 then
		return 500
	end
	return 350
end

function Advanced_finger_of_death:GetCooldown( level )
	if IsServer() and self:GetAutoCastState() and not self.unlock2 then
		return 0
	end
	local base_cooldown = self.BaseClass.GetCooldown( self, level )
	if self:GetUnlock(2)==2 then
		base_cooldown = 7
	end
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
		base_cooldown = base_cooldown *0.8
	end
	return base_cooldown
end

function Advanced_finger_of_death:GetManaCost( level )

	local caster = self:GetCaster()
	local mana_cost = self.BaseClass.GetManaCost(self, level )
	if caster:HasModifier("modifier_Advanced_finger_of_death_debuff") then
		local cost_index = 1.5
		if self:GetSpecialValueFor("advanced_level")>=5 then
			cost_index = 1.4
		end
		
		if IsClient() then
			local nPlayerID = self:GetCaster():GetPlayerOwnerID()
			local NetTable_key = tostring(nPlayerID).."_finger_of_death"
			local count = CustomNetTables:GetTableValue( "spell_info", NetTable_key).value
		
			if count then
				for i = 1, count, 1 do
					mana_cost = mana_cost *cost_index
				end
			end
			if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
				mana_cost = mana_cost *0.6
			end
			return mana_cost
		end

		local count = caster:FindModifierByName("modifier_Advanced_finger_of_death_debuff"):GetStackCount()
		for i = 1, count, 1 do
			mana_cost = mana_cost *cost_index
		end
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
			mana_cost = mana_cost *0.6
		end
		return mana_cost

	end
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
		mana_cost = mana_cost *0.6
	end
	return mana_cost
end


function Advanced_finger_of_death:GetIntrinsicModifierName()
	return "modifier_Advanced_finger_of_death_count"
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_finger_of_death:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- pre-effects
	local sound_cast = "Hero_Lion.FingerOfDeath"
	EmitSoundOn( sound_cast, caster )

	-- cancel if linken
	if target:TriggerSpellAbsorb(self) then
		self:PlayEffects( target )
		return 
	end

	-- load data
	local delay = 3
	-- local search = self:GetSpecialValueFor("splash_radius_scepter")
	

	-- find targets
	local targets = {}
	targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetAOERadius(),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_CLOSEST ,	-- int, order filter
			false	-- bool, can grow cache
	)

	local count = 7
	if self.advanced_level>=10 then
		count = 10
		if self.advanced_level>=20 then
			delay = 60
		end
	end
	if self.unlock2 then
		local mana = caster:GetMana()
		caster:SetMana(0)
		caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_finger_of_death_unlock2", -- modifier name
		{ mana = mana } -- kv
	)
		
		for i,enemy in pairs(targets) do
			self:SingleSpellEffect(enemy,delay,mana*2)
			if i>=count then
				break
			end
		end
	else
		for i,enemy in pairs(targets) do
			self:SingleSpellEffect(enemy,delay)
			if i>=count then
				break
			end
		end
	end
	
	if self:GetAutoCastState() and not self.unlock2 then
		-- local cooldown = self:GetCooldown( self:GetLevel() )* caster:GetCooldownReduction()
		local cooldown = self.BaseClass.GetCooldown( self, 1 )* caster:GetCooldownReduction()
		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
			cooldown = cooldown *0.8
		end
        caster:AddNewModifier(
			caster,
			self,
			"modifier_Advanced_finger_of_death_debuff",
			{	duration = cooldown,stack_time =cooldown} 
    	)
		self:EndCooldown()
	end
end

function Advanced_finger_of_death:SingleSpellEffect(target,delay,mana)
	if not delay then
		delay = 3
		if self.advanced_level>=20 then
			delay = 60
		end
	end

	local bonus_damage = mana or 0
	local caster = self:GetCaster()
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_finger_of_death", -- modifier name
		{ duration = delay,bonus_damage=bonus_damage } -- kv
	)

	-- effects
	self:PlayEffects( target )
	if self.unlock3 then
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_finger_of_death_unlock3", -- modifier name
			{}
		)
	end
end

function Advanced_finger_of_death:Unlock3Effect(target)

	local caster = self:GetCaster()
	if not caster:IsAlive() or not caster:CanEntityBeSeenByMyTeam(target) then
		return
	end
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_finger_of_death", -- modifier name
		{ duration = 60,bonus_damage=0 } -- kv
	)
	self:PlayEffectsUnlock3( target )
end

--------------------------------------------------------------------------------
function Advanced_finger_of_death:PlayEffects( target )


	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	if self.unlock2 then
		particle_cast = "particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8.vpcf"
	end
	local sound_cast = "Hero_Lion.FingerOfDeathImpact"

	-- load data
	local caster = self:GetCaster()
	local direction = (caster:GetOrigin()-target:GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	
	local attach = "attach_attack1"
	if caster:ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() + direction )
	ParticleManager:SetParticleControlForward( effect_cast, 3, -direction )
	if self.unlock2 then
		local vStart = caster:GetAbsOrigin() + Vector(0,0,128)
		local vPosition = target:GetOrigin()+ Vector(0,0,128)
		local vDirection = (vPosition - vStart):Normalized()
		local flDistance = (vPosition - vStart):Length2D()
		ParticleManager:SetParticleControl(effect_cast, 6, vStart + vDirection * flDistance * 0.7 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
		ParticleManager:SetParticleControl(effect_cast, 10, vStart + vDirection * flDistance * 0.3 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
	end
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function Advanced_finger_of_death:PlayEffects2(start_pos, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local sound_cast = "Hero_Lion.FingerOfDeathImpact"

	-- load data
	local caster = self:GetCaster()
	local direction = (caster:GetOrigin()-target:GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	
	local attach = "attach_attack1"
	if caster:ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() + direction )
	ParticleManager:SetParticleControlForward( effect_cast, 3, -direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function Advanced_finger_of_death:PlayEffectsUnlock3( target )


	local particle_cast = "particles/rebuild/spell/finger_of_death_unlock3/effect.vpcf"
	local sound_cast = "Hero_Lion.FingerOfDeathImpact"

	-- load data
	local caster = self:GetCaster()
	local direction = (caster:GetOrigin()-target:GetOrigin()):Normalized()
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	
	local attach = "attach_attack1"
	if caster:ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() + direction )
	ParticleManager:SetParticleControlForward( effect_cast, 3, -direction )
	local vStart = caster:GetAbsOrigin() + Vector(0,0,512)
	local vPosition = target:GetOrigin()+ Vector(0,0,512)
	local vDirection = (vPosition - vStart):Normalized()
	local flDistance = (vPosition - vStart):Length2D()
	ParticleManager:SetParticleControl(effect_cast, 6, Vector(0,0,1024)+vStart + vDirection * flDistance * 0.7 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
	-- ParticleManager:SetParticleControl(effect_cast, 10,Vector(0,0,2048) + vStart + vDirection * flDistance * 0.3 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
	ParticleManager:SetParticleControl(effect_cast, 10,Vector(0,0,512) + vStart)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

modifier_Advanced_finger_of_death = class({})
function modifier_Advanced_finger_of_death:IsHidden()	return true end
function modifier_Advanced_finger_of_death:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE  end
function modifier_Advanced_finger_of_death:IsPurgable()	return false end

function modifier_Advanced_finger_of_death:OnCreated( kv )
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_Advanced_finger_of_death_count")
		if modifier then
			local max_index = ability:GetSpecialValueFor( "max_bonus_damage" )
			if ability.advanced_level>=15 then
				max_index = max_index + 7
				if ability.advanced_level>=20 then
					max_index = 30
				end
			end
			local bonus_index = math.min(modifier:GetStackCount(),max_index*caster:GetIntellect(false))
			self.damage = ability:GetSpecialValueFor( "base_damage" )+(ability:GetSpecialValueFor( "bonus_damage" ) )*caster:GetIntellect(false)+bonus_index
		else
			self.damage = ability:GetSpecialValueFor( "base_damage" )+(ability:GetSpecialValueFor( "bonus_damage" )  )*caster:GetIntellect(false)
		end
		self.damage = self.damage + kv.bonus_damage
		self:StartIntervalThink(0.2)
		
	end
end
function modifier_Advanced_finger_of_death:OnIntervalThink()
	local nResult = UnitFilter(
		self:GetParent(),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return
	end

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	self:StartIntervalThink(-1)
end
function modifier_Advanced_finger_of_death:OnDestroy( kv )
	if IsServer() then
		if not self:GetParent():IsAlive() then
			local modifier =  self:GetCaster():FindModifierByName("modifier_Advanced_finger_of_death_count")
			if modifier then
				local ability = self:GetAbility()
				if ability.advanced_level>=15 then
					modifier:SetStackCount(modifier:GetStackCount()+ ability:GetSpecialValueFor( "bonus_damage_per_kill")*self:GetCaster():GetIntellect(false) )
				else
					modifier:SetStackCount(modifier:GetStackCount()+RandomInt(1, ability:GetSpecialValueFor( "bonus_damage_per_kill")*self:GetCaster():GetIntellect(false)))
				end
				
				-- modifier:IncrementStackCount()
			end
		end
	end
end



modifier_Advanced_finger_of_death_count = class({})


function modifier_Advanced_finger_of_death_count:IsHidden()	return false end
function modifier_Advanced_finger_of_death_count:IsDebuff()	return false end
function modifier_Advanced_finger_of_death_count:IsPurgable()	return false end
function modifier_Advanced_finger_of_death_count:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Advanced_finger_of_death_count:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			if self:GetParent().finger_of_death_count then
				self:SetStackCount(self:GetParent().finger_of_death_count )
			else
				self:SetStackCount(0)
			end
		end)
	end
end



function modifier_Advanced_finger_of_death_count:OnDestroy()
	if IsServer() then
		self:GetParent().finger_of_death_count = self:GetStackCount()
	end
end









modifier_Advanced_finger_of_death_debuff = class({})

function modifier_Advanced_finger_of_death_debuff:IsHidden()	return false end
function modifier_Advanced_finger_of_death_debuff:IsDebuff()	return true end
function modifier_Advanced_finger_of_death_debuff:IsPurgable()	return false end
function modifier_Advanced_finger_of_death_debuff:IsPurgeException()	return false end
function modifier_Advanced_finger_of_death_debuff:RemoveOnDeath() return false end
function modifier_Advanced_finger_of_death_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		local NetTable_key = tostring(nPlayerID).."_finger_of_death"
		CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=self:GetStackCount() } )  --更新网表
	end
end
function modifier_Advanced_finger_of_death_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+params.stack_time
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		local NetTable_key = tostring(nPlayerID).."_finger_of_death"
		CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=self:GetStackCount() } )  --更新网表
		local ability = self:GetAbility()
		local max = 10
		if ability.unlock1 then
			max = 20
		end
		if self:GetStackCount()>=max then
			ability:SetActivated(false)
		end
	end
end
function modifier_Advanced_finger_of_death_debuff:OnDestroy()
	if IsServer() then
		local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		local NetTable_key = tostring(nPlayerID).."_finger_of_death"
		CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=0 } )  --更新网表
		self:GetAbility():SetActivated(true)
	end

end

function modifier_Advanced_finger_of_death_debuff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				local nPlayerID = self:GetCaster():GetPlayerOwnerID()
				local NetTable_key = tostring(nPlayerID).."_finger_of_death"
				CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=self:GetStackCount() } )  --更新网表
			end
		end
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_finger_of_death_debuff:Unlock1Effect()
	table.remove(self.tData, #self.tData)
	self:DecrementStackCount()
	local nPlayerID = self:GetCaster():GetPlayerOwnerID()
	local NetTable_key = tostring(nPlayerID).."_finger_of_death"
	CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=self:GetStackCount() } )  --更新网表
end









modifier_Advanced_finger_of_death_unlock1 = class({})

function modifier_Advanced_finger_of_death_unlock1:IsDebuff()			return false end
function modifier_Advanced_finger_of_death_unlock1:IsHidden() 			return true end
function modifier_Advanced_finger_of_death_unlock1:IsPurgable() 		return false end
function modifier_Advanced_finger_of_death_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_finger_of_death_unlock1:RemoveOnDeath() return false end




function modifier_Advanced_finger_of_death_unlock1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_Advanced_finger_of_death_unlock1:OnAbilityFullyCast(keys)

	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ~=parent then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) < 5 then
			return
		end
		if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
			return 
		end
		if keys.ability==self:GetAbility() then
			return
		end
		local parent = self:GetParent()
		local modifier = parent:FindModifierByName("modifier_Advanced_finger_of_death_debuff")
		if modifier then
			modifier:Unlock1Effect()
			self:GetAbility():PlayEffects2(parent:GetOrigin()+Vector(0,0,128), parent )
		end
		
	end
end


modifier_Advanced_finger_of_death_unlock2 = class({})

function modifier_Advanced_finger_of_death_unlock2:IsDebuff()			return false end
function modifier_Advanced_finger_of_death_unlock2:IsHidden() 			return false end
function modifier_Advanced_finger_of_death_unlock2:IsPurgable() 		return false end
function modifier_Advanced_finger_of_death_unlock2:IsPurgeException() 	return false end


function modifier_Advanced_finger_of_death_unlock2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.mana)
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_Advanced_finger_of_death_unlock2:OnIntervalThink()
	local ability =self:GetAbility()
	if ability:IsCooldownReady() then
		local unit = self:GetParent()
		unit:GiveMana(self:GetStackCount())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, self:GetStackCount(), nil)
		self:StartIntervalThink(-1)
		self:SafeDestroy()
	end
end



modifier_Advanced_finger_of_death_unlock3 = class({})

function modifier_Advanced_finger_of_death_unlock3:IsDebuff()			return false end
function modifier_Advanced_finger_of_death_unlock3:IsHidden() 			return false end
function modifier_Advanced_finger_of_death_unlock3:IsPurgable() 		return false end
function modifier_Advanced_finger_of_death_unlock3:IsPurgeException() 	return false end


function modifier_Advanced_finger_of_death_unlock3:OnCreated(keys)
	if IsServer() then
		self.timer = {}
		self:SetStackCount(1)
		self:StartIntervalThink(0.1)
		table.insert(self.timer, GameRules:GetGameTime()+10)
	end
end

function modifier_Advanced_finger_of_death_unlock3:OnRefresh(keys)
	if IsServer() then
		if self:GetStackCount()<5 then
			self:IncrementStackCount()
			table.insert(self.timer, GameRules:GetGameTime()+10)
		end
	
		
		
	end
end
function modifier_Advanced_finger_of_death_unlock3:OnIntervalThink()
	local ability =self:GetAbility()
	local now_time = GameRules:GetGameTime()
	-- print("now="..now_time)
	for i, time in ipairs(self.timer) do
		-- print("time="..time.."  i="..i)
		if now_time>=time then
			self.timer[i] = now_time+10
			ability:Unlock3Effect(self:GetParent())
			-- break
		end
	end
	-- print("-------------")
	
end




