heroTalent_npc_dota_hero_abyssal_underlord = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_skewer", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_skewer_debuff", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_start", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_abyssal_underlord:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_abyssal_underlord"
end

function heroTalent_npc_dota_hero_abyssal_underlord:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius_2") - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_abyssal_underlord = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord:OnCreated()
	self.radius_1 = self:GetAbility():GetSpecialValueFor("radius_1")
	self.radius_2 = self:GetAbility():GetSpecialValueFor("radius_2")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	if IsServer() then
		self.currentOrder = 0
		self.currentPos = self:GetParent():GetAbsOrigin()
	end
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {}
	}
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:OnWaveStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  

   	for i, unit in pairs(units) do
		if unit ~= caster then
           unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_abyssal_underlord_start", {duration = self.duration})
	   	    if i >= self.max then
			    break
		    end
		end
   	end
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_abyssal_underlord_start", {duration = self.duration})
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return
	end
	if params.unit~=self:GetParent() then return end
	local ability = self:GetAbility()

	if not ability:IsCooldownReady() or not ability:GetAutoCastState() then
		return
	end
	-- right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self.currentOrder = self.currentOrder +1
		
		Timers:CreateTimer(0.3, function()
			self.currentOrder = self.currentOrder - 1
		end)
		
		if self.currentOrder>=2 and CalculateDistance(self.currentPos,params.new_pos)<=30 then
			-- self:GetAbility():UseResources(true, true, true,true)
			-- print(ability:GetCooldown(ability:GetLevel()) * self:GetParent():GetCooldownReduction())
			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.new_pos, nil, self.radius_1, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			if #units==1 and units[1]==self:GetParent() then
				return
			end
			if #units>=1 then
				self:GetAbility():UseResources(true, true, true, true)
				self:SpellToTarget( params.new_pos )
				self:OnWaveStart()
			end
		end
		self.currentPos = params.new_pos
	end
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:SpellToTarget(pos)
	if IsServer() then
		local caster = self:GetCaster()
		self:PlayEffects1()
		local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetAbility():GetSpecialValueFor("radius_2"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	

		for _,target in pairs(targets) do
			-- disjoint
			ProjectileManager:ProjectileDodge( target )
	
			-- move to position
			FindClearSpaceForUnit( target, pos, true )
		end
		self:PlayEffects2()
	end

end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord:PlayEffects1()
	local particle_cast = "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf"


	-- Get Data
	local caster = self:GetCaster()


	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius_2, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		2,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


end


function modifier_heroTalent_npc_dota_hero_abyssal_underlord:PlayEffects2()
	local sound_cast1 = "Hero_AbyssalUnderlord.DarkRift.Complete"
	local sound_cast2 = "Hero_AbyssalUnderlord.DarkRift.Aftershock"

	-- Get Data
	local caster = self:GetCaster()
	local parent = self:GetParent()

	-- Set Effect
	ParticleManager:SetParticleControl( self.effect_cast, 5, caster:GetOrigin() )
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	self.effect_cast = nil
	-- Create Sound
	EmitSoundOn( sound_cast1, parent )
	EmitSoundOnLocationWithCaster( caster:GetOrigin(), sound_cast2, caster )


end





modifier_heroTalent_npc_dota_hero_abyssal_underlord_start = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:OnCreated()
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_start:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return self.outgoing
end