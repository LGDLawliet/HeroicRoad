LinkLuaModifier( "modifier_Primary_Anti_time", "skills/Primary_Anti_time", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_time_already", "skills/Primary_Anti_time", LUA_MODIFIER_MOTION_NONE )
	
Primary_Anti_time = class({})
function Primary_Anti_time:IsRefreshable() return false end

function Primary_Anti_time:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/anti_time/screen.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/anti_time/self.vpcf", context )
end

function Primary_Anti_time:GetCustomCastError()
	return "#DOTA_CUSTOM_ALL_TIRED"
end

function Primary_Anti_time:CastFilterResult()
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

function Primary_Anti_time:OnSpellStart()
	local caster = self:GetCaster()
	local heroes = GetAllRealHeroes()
	local duration = self:GetSpecialValueFor("duration") * caster:GetModifierDurationGainIndex(0.2)
	local tired_duration = duration + self:GetSpecialValueFor("cd")
	for _,hero in pairs(heroes) do
		if not hero:HasModifier("modifier_time_already") then
			hero:AddNewModifier(caster,self,"modifier_Primary_Anti_time",{duration = duration})
			hero:AddNewModifier(caster,self,"modifier_time_already",{duration = tired_duration})
		end
	end
end
---------------------------------------------------------------------
modifier_Primary_Anti_time = advanced_modifier({})

function modifier_Primary_Anti_time:IsHidden()return false end
function modifier_Primary_Anti_time:IsDebuff()return false end
function modifier_Primary_Anti_time:RemoveOnDeath()return false end
function modifier_Primary_Anti_time:OnCreated(params)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.interval = 0.33
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.cd_reduce = self.ability:GetSpecialValueFor("cd_speed")*0.01*self.interval

	if IsServer() then
		self:StartIntervalThink(self.interval)
		self.nfx1 = "particles/rebuild/spell/anti_time/screen.vpcf"
		self.nfx1_cast = ParticleManager:CreateParticle( self.nfx1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.nfx1_cast, 1, Vector(1,0,0))
		self:AddParticle(self.nfx1_cast, false, false, -1, false, false)
	end
end

function modifier_Primary_Anti_time:OnDestroy()
	if not IsServer() then return end
	if self.nfx1_cast ~= nil then
		ParticleManager:DestroyParticle(self.nfx1_cast, false)
	end
end

function modifier_Primary_Anti_time:OnIntervalThink()
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
end

function modifier_Primary_Anti_time:PlayEffects(unit)
	local particle_cast = "particles/rebuild/spell/anti_time/self.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end
function modifier_Primary_Anti_time:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end
function modifier_Primary_Anti_time:Advanced_GetModifierAttackSpeedPercentage()
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