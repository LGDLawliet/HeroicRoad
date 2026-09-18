creeps_spell_reverse_polarity_rebuild = class({})

LinkLuaModifier( "modifier_creeps_spell_reverse_polarity_rebuild", "creeps_spell/creeps_spell_reverse_polarity_rebuild", LUA_MODIFIER_MOTION_HORIZONTAL )
require("internal/timers")

function creeps_spell_reverse_polarity_rebuild:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_reverse_polarity_rebuild", -- modifier name
		{
			duration = 16

		} -- kv
	)
end




modifier_creeps_spell_reverse_polarity_rebuild = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_reverse_polarity_rebuild:IsHidden()	return false end
function modifier_creeps_spell_reverse_polarity_rebuild:IsDebuff()	return false end
function modifier_creeps_spell_reverse_polarity_rebuild:IsStunDebuff()	return false end
function modifier_creeps_spell_reverse_polarity_rebuild:IsPurgable()	return false end





function modifier_creeps_spell_reverse_polarity_rebuild:OnCreated( kv )


	if not IsServer() then return end
	local caster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local particle_cast = "particles/econ/items/magnataur/magnus_ti10_immortal_head/magnataur_ti_10_head_rp.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = 600
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )


    self.effect_cast = effect_cast
	-- Create Sound
	EmitSoundOn( sound_cast, caster )
	for i = 1, 10, 1 do
		local pos =caster:GetAbsOrigin()  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/world_rebuild/world_rebuild_projected.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( effect_cast, 3, pos)
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- Timers:CreateTimer(16, function()
		-- 	ParticleManager:DestroyParticle(effect_cast, true)
		-- 	ParticleManager:ReleaseParticleIndex( effect_cast )
		-- end)
	end


	self:StartIntervalThink(2.5)
end

function modifier_creeps_spell_reverse_polarity_rebuild:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end

end

function modifier_creeps_spell_reverse_polarity_rebuild:OnIntervalThink( kv )

	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	local damage =caster:GetDamageMax()*self:GetAbility():GetSpecialValueFor("damage")
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
			for i = 1, 5, 1 do
				local pos = hero:GetAbsOrigin()
				pos.x = pos.x +RandomInt(-400, 400)
				pos.y = pos.y +RandomInt(-400, 400)
				
				local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
				local sound_cast = "Hero_Invoker.SunStrike.Charge"
			

				local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl( effect_cast, 0, pos )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
				ParticleManager:ReleaseParticleIndex( effect_cast )

				local effect_cast = ParticleManager:CreateParticle("particles/rebuild/spell/reverse_polarity_rebuild/reverse_polarity_rebuild_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl( effect_cast, 0, pos )
				ParticleManager:SetParticleControl( effect_cast, 3, pos )
				ParticleManager:SetParticleControl( effect_cast, 61, Vector( self.radius, 0, 0 ) )
				DestroyParticleByDelay(effect_cast,3)
			
				EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
				Timers:CreateTimer(1.5, function()
					local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
					local sound_cast = "Hero_Invoker.SunStrike.Ignite"

					local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
					ParticleManager:SetParticleControl( effect_cast, 0,pos )
					ParticleManager:SetParticleControl( effect_cast, 1, Vector(350, 0, 0 ) )
					ParticleManager:ReleaseParticleIndex( effect_cast )
					EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos,
					nil, self.radius,
					 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					  DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
					   FIND_ANY_ORDER, false)
					for _, enemy in pairs(enemies) do
						
						local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
						ApplyDamage(damageTable)  					
					end

				end)
			end
			
        end
    end

	
end

function modifier_creeps_spell_reverse_polarity_rebuild:Advanced_GetModifierIncomingDamage_Percentage()	return -95 end


function modifier_creeps_spell_reverse_polarity_rebuild:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_creeps_spell_reverse_polarity_rebuild:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
