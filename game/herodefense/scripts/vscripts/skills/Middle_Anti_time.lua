LinkLuaModifier( "modifier_Middle_Anti_time", "skills/Middle_Anti_time", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_time_already", "skills/Middle_Anti_time", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Soul", "skills/Middle_Anti_time", LUA_MODIFIER_MOTION_NONE )
Middle_Anti_time = class({})
function Middle_Anti_time:IsRefreshable() return false end
function Middle_Anti_time:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/anti_time/screen.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/anti_time/self.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/nevermore_epic_8/main_effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/anti_time/soul_projectile.vpcf", context )
end

function Middle_Anti_time:GetCustomCastError()
	return "#DOTA_CUSTOM_ALL_TIRED"
end

function Middle_Anti_time:CastFilterResult()
	if IsServer() then
		local caster = self:GetCaster()
		if caster.GetPlayerOwnerID then
			local heroes = GetAllRealHeroes()
			local all_tired = true
			for _,hero in pairs(heroes) do
				if not hero:HasModifier("modifier_time_already") then
					all_tired = false
				end
			end
			if all_tired then
				return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
end

function Middle_Anti_time:OnSpellStart()
	local caster = self:GetCaster()
	local heroes = GetAllRealHeroes()
	local duration = self:GetSpecialValueFor("duration") * caster:GetModifierDurationGainIndex(0.2)
	local tired_duration = duration + self:GetSpecialValueFor("cd")
	for _,hero in pairs(heroes) do
		if not hero:HasModifier("modifier_time_already") then
			if not IsInToolsMode() then
				hero:AddNewModifier(caster,self,"modifier_time_already",{duration = tired_duration})
			end
			hero:AddNewModifier(caster,self,"modifier_Middle_Anti_time",{duration = duration})
		end
	end

	self:CreateSouls(self:GetSpecialValueFor("count"))
end

function Middle_Anti_time:CreateSouls(num)
	local caster = self:GetCaster()
	local random = math.random
	local duration = self:GetSpecialValueFor("duration") * caster:GetModifierDurationGainIndex(0.2)
	self.souls = {}
	for i = 1, num do
		local spawn_pos = caster:GetAbsOrigin() + RandomVector(random(200, 800))
		
		local pos = GetClearSpaceForUnit(caster, spawn_pos)
		local newSoul = CreateUnitByName("npc_dota_wisp_spirit", pos, false, caster, caster, caster:GetTeam())
		
		
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/nevermore_epic_8/main_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSoul)
		ParticleManager:SetParticleControl(pfx, 61, Vector(0, 0, 0))
		newSoul.spirit_pfx = pfx

		table.insert(self.souls, newSoul)

		newSoul:AddNewModifier(caster,self,"modifier_Middle_Soul",{duration = duration})

	end
end
----
modifier_Middle_Soul = modifier_Middle_Soul or advanced_modifier({})
function modifier_Middle_Soul:OnCreated()
	self:StartIntervalThink(3)
end
function modifier_Middle_Soul:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
end
function modifier_Middle_Soul:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO]    = true,
		[MODIFIER_STATE_NO_TEAM_SELECT]     = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE]      = true,
		[MODIFIER_STATE_MAGIC_IMMUNE]       = true,
		[MODIFIER_STATE_INVULNERABLE]       = true,
		[MODIFIER_STATE_UNSELECTABLE]       = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]     = true,
		[MODIFIER_STATE_NO_HEALTH_BAR]      = true,
	}
	return state
end
function modifier_Middle_Soul:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
---------------------------------------------------------------------
modifier_Middle_Anti_time = advanced_modifier({})

function modifier_Middle_Anti_time:IsHidden()return false end
function modifier_Middle_Anti_time:IsDebuff()return false end
function modifier_Middle_Anti_time:RemoveOnDeath()return false end
function modifier_Middle_Anti_time:OnCreated(params)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.interval = 0.33
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.cd_reduce = self.ability:GetSpecialValueFor("cd_speed")*0.01*self.interval
	self.spirit_cd = self.ability:GetSpecialValueFor("spirit_cd")
	self.unrefresh_pct = self.ability:GetSpecialValueFor("unrefresh_pct")

	if IsServer() then
		self:StartIntervalThink(self.interval)
		self.nfx1 = "particles/rebuild/spell/anti_time/screen.vpcf"
		self.nfx1_cast = ParticleManager:CreateParticle( self.nfx1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.nfx1_cast, 1, Vector(1,0,0))
		self:AddParticle(self.nfx1_cast, false, false, -1, false, false)
	end
end

function modifier_Middle_Anti_time:OnDestroy()
	if not IsServer() then return end
	if self.nfx1_cast ~= nil then
		ParticleManager:DestroyParticle(self.nfx1_cast, false)
	end
end

function modifier_Middle_Anti_time:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	local keys = {
		target = self.parent,
		--ability = self.ability,
		cdr = self.cd_reduce,
		unrefresh_pct = 0,
	}

	for i=0, self.parent:GetAbilityCount() - 1 do
		local Ability = self.parent:GetAbilityByIndex(i)
		if Ability ~= nil then
			keys.ability = Ability
			CooldownReduce_Seconds(keys)
		end
	end

	for i=0, 10 do
		local Ability = self.parent:GetItemInSlot(i)
		if Ability ~= nil then
			keys.ability = Ability
			CooldownReduce_Seconds(keys)
		end
	end

	self:PlayEffects(self.parent)
	self:TimeSoul()
end

function modifier_Middle_Anti_time:TimeSoul()
	if self.ability.souls and #self.ability.souls > 0 then
		for i,soul in ipairs(self.ability.souls) do	
			if soul and not soul:IsNull() then
				local disctance = CalculateDistance(self.parent,soul)
				if disctance <= 150 then
					self:PlayEffects_TakeSoul(soul)
					UTIL_Remove(soul)

					local keys = {
						target = self.parent,
						--ability = self.ability,
						cdr = self.spirit_cd,
						unrefresh_pct = self.unrefresh_pct,
					}

					for i=0, self.parent:GetAbilityCount() - 1 do
						local Ability = self.parent:GetAbilityByIndex(i)
						if Ability ~= nil then
							keys.ability = Ability
							CooldownReduce_Seconds(keys)
						end
					end
				end
			end
		end
	end
end

function modifier_Middle_Anti_time:PlayEffects(unit)
	local particle_cast = "particles/rebuild/spell/anti_time/self.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

function modifier_Middle_Anti_time:PlayEffects_TakeSoul(target)
	local projectile_name = "particles/rebuild/spell/anti_time/soul_projectile.vpcf"

	local info = {
		Target = self:GetCaster(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 1000,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function modifier_Middle_Anti_time:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end

function modifier_Middle_Anti_time:Advanced_GetModifierAttackSpeedPercentage()
	if not self:GetAbility() then self:Destroy() return end
	return self.attack_speed
end

---------------------------------------------------------------------
modifier_time_already = advanced_modifier({})

function modifier_time_already:IsHidden()return false end
function modifier_time_already:IsDebuff()return true end
function modifier_time_already:IsPurgable()return false end
function modifier_time_already:RemoveOnDeath()return false end

function modifier_time_already:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
    if self:GetAbility():GetSpecialValueFor("advanced_level") ~= nil and self:GetAbility():GetSpecialValueFor("advanced_level") >= 15 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end
function modifier_time_already:OnWaveStart()
	if not IsServer() then return end
	self:Destroy()
end

function modifier_time_already:Advanced_GetModifierIncomingDamage_Percentage()
	return -10
end
function modifier_time_already:Advanced_GetModifierCooldownReduction()
	return 10
end