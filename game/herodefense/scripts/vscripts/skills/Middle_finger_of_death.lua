
require('internal/timers')   --计时器功能
Middle_finger_of_death = class({})
LinkLuaModifier( "modifier_Middle_finger_of_death", "skills/Middle_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_finger_of_death_count", "skills/Middle_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_finger_of_death_debuff", "skills/Middle_finger_of_death", LUA_MODIFIER_MOTION_NONE )
function Middle_finger_of_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", context )
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
-- function Middle_finger_of_death:GetAOERadius()
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetSpecialValueFor( "splash_radius_scepter" )
-- 	end

-- 	return 0
-- end

-- function Middle_finger_of_death:GetCooldown( level )
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetSpecialValueFor( "cooldown_scepter" )
-- 	end

-- 	return self.BaseClass.GetCooldown( self, level )
-- end
function Middle_finger_of_death:GetCooldown( level )
	if IsServer() and self:GetAutoCastState() then
		return 0
	end
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
		return self.BaseClass.GetCooldown( self, level ) *0.8
	end
	return self.BaseClass.GetCooldown( self, level )
end

function Middle_finger_of_death:GetManaCost( level )

	local caster = self:GetCaster()
	local mana_cost = self.BaseClass.GetManaCost(self, level )
	if caster:HasModifier("modifier_Middle_finger_of_death_debuff") then
		
		if IsClient() then
			local nPlayerID = self:GetCaster():GetPlayerOwnerID()
			local NetTable_key = tostring(nPlayerID).."_finger_of_death"
			local count = CustomNetTables:GetTableValue( "spell_info", NetTable_key).value
		
			if count then
				for i = 1, count, 1 do
					mana_cost = mana_cost *1.5
				end
			end
			if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
				mana_cost = mana_cost *0.6
			end
			return mana_cost
		end

		local count = caster:FindModifierByName("modifier_Middle_finger_of_death_debuff"):GetStackCount()
		for i = 1, count, 1 do
			mana_cost = mana_cost *1.5
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

-- 	return self.BaseClass.GetManaCost( self, level )
-- end

function Middle_finger_of_death:GetIntrinsicModifierName()
	return "modifier_Middle_finger_of_death_count"
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_finger_of_death:OnSpellStart()
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
	-- if caster:HasScepter() then
	-- 	targets = FindUnitsInRadius(
	-- 		caster:GetTeamNumber(),	-- int, your team number
	-- 		target:GetOrigin(),	-- point, center point
	-- 		nil,	-- handle, cacheUnit. (not known)
	-- 		search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	-- 		0,	-- int, flag filter
	-- 		0,	-- int, order filter
	-- 		false	-- bool, can grow cache
	-- 	)
	-- else
	-- 	table.insert(targets,target)
	-- end
	table.insert(targets,target)

	for _,enemy in pairs(targets) do
		-- delay
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Middle_finger_of_death", -- modifier name
			{ duration = delay } -- kv
		)

		-- effects
		self:PlayEffects( enemy )
	end
	if self:GetAutoCastState() then
		-- local cooldown = self:GetCooldown( self:GetLevel() )* caster:GetCooldownReduction()
		local cooldown = self.BaseClass.GetCooldown( self, 1 )* caster:GetCooldownReduction()
		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lion_2") then
			cooldown = cooldown *0.8
		end
        caster:AddNewModifier(
			caster,
			self,
			"modifier_Middle_finger_of_death_debuff",
			{	duration = cooldown,stack_time =cooldown} 
    	)
		self:EndCooldown()
	end
end

--------------------------------------------------------------------------------
function Middle_finger_of_death:PlayEffects( target )
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
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end





modifier_Middle_finger_of_death = class({})
function modifier_Middle_finger_of_death:IsHidden()	return true end
function modifier_Middle_finger_of_death:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE  end
function modifier_Middle_finger_of_death:IsPurgable()	return false end

function modifier_Middle_finger_of_death:OnCreated( kv )
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_Middle_finger_of_death_count")
		if modifier then
			local bonus_index = math.min(modifier:GetStackCount(),ability:GetSpecialValueFor( "max_bonus_damage" )*caster:GetIntellect(false))
			self.damage = ability:GetSpecialValueFor( "base_damage" )+(ability:GetSpecialValueFor( "bonus_damage" ) )*caster:GetIntellect(false)+bonus_index
		else
			self.damage = ability:GetSpecialValueFor( "base_damage" )+(ability:GetSpecialValueFor( "bonus_damage" )  )*caster:GetIntellect(false)
		end
		self:StartIntervalThink(0.2)
		
	end
end
function modifier_Middle_finger_of_death:OnIntervalThink()
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
function modifier_Middle_finger_of_death:OnDestroy( kv )
	if IsServer() then
		if not self:GetParent():IsAlive() then
			local modifier =  self:GetCaster():FindModifierByName("modifier_Middle_finger_of_death_count")
			if modifier then
				modifier:SetStackCount(modifier:GetStackCount()+RandomInt(1, self:GetAbility():GetSpecialValueFor( "bonus_damage_per_kill")*self:GetCaster():GetIntellect(false)))
				-- modifier:IncrementStackCount()
			end
		end
	end
end



modifier_Middle_finger_of_death_count = class({})


function modifier_Middle_finger_of_death_count:IsHidden()	return false end
function modifier_Middle_finger_of_death_count:IsDebuff()	return false end
function modifier_Middle_finger_of_death_count:IsPurgable()	return false end
function modifier_Middle_finger_of_death_count:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Middle_finger_of_death_count:OnCreated( kv )
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



function modifier_Middle_finger_of_death_count:OnDestroy()
	if IsServer() then
		self:GetParent().finger_of_death_count = self:GetStackCount()
	end
end









modifier_Middle_finger_of_death_debuff = class({})

function modifier_Middle_finger_of_death_debuff:IsHidden()	return false end
function modifier_Middle_finger_of_death_debuff:IsDebuff()	return true end
function modifier_Middle_finger_of_death_debuff:IsPurgable()	return false end
function modifier_Middle_finger_of_death_debuff:IsPurgeException()	return false end
function modifier_Middle_finger_of_death_debuff:RemoveOnDeath() return false end
function modifier_Middle_finger_of_death_debuff:OnCreated(params)
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
function modifier_Middle_finger_of_death_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+params.stack_time
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		local NetTable_key = tostring(nPlayerID).."_finger_of_death"
		CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=self:GetStackCount() } )  --更新网表
		if self:GetStackCount()>=10 then
			self:GetAbility():SetActivated(false)
		end
	end
end
function modifier_Middle_finger_of_death_debuff:OnDestroy()
	if IsServer() then
		local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		local NetTable_key = tostring(nPlayerID).."_finger_of_death"
		CustomNetTables:SetTableValue( "spell_info", NetTable_key, {value=0 } )  --更新网表
		self:GetAbility():SetActivated(true)
	end

end

function modifier_Middle_finger_of_death_debuff:OnIntervalThink()
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
	end
end






