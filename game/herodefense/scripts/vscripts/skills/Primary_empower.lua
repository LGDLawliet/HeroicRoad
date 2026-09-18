Primary_empower = class({})
LinkLuaModifier( "modifier_Primary_empower", "skills/Primary_empower", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function Primary_empower:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_hit.vpcf", context )
end


function Primary_empower:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_Primary_empower", { duration = duration*ModifierStatusGain } )

	-- play effects
	local sound_cast = "Hero_Magnataur.Empower.Cast"
	local sound_target = "Hero_Magnataur.Empower.Target"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
end





modifier_Primary_empower = class({})

function modifier_Primary_empower:IsHidden()	return false end
function modifier_Primary_empower:IsDebuff()	return false end
function modifier_Primary_empower:IsPurgable()	return true end


function modifier_Primary_empower:OnCreated( kv )
	self.ability = self:GetAbility()

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )


	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )



	if self:GetCaster()==self:GetParent() and self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_magnataur_2") then
		self.damage = self.damage *2.5
		self.cleave = self.cleave *2.5
	end
	if not IsServer() then return end

end

function modifier_Primary_empower:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_Primary_empower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_Primary_empower:OnTooltip()
	return self.cleave
end
function modifier_Primary_empower:GetModifierProcAttack_Feedback( keys )
	if not IsServer() then return end
	if keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:IsDisableCleave() then
		return
	end
	local damage = keys.damage*self.cleave/100

	
	local units = DoHDCleaveAttack(keys.attacker, keys.target, self.ability, damage, 
	self.radius_start,
	self.radius_end, 
	self.radius_dist, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")
	for _, unit in ipairs(units) do
		if unit~=keys.target then
			local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
			-- ParticleManager:SetParticleControlEnt( pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(pfx, 1,Vector(0,0,1))
			ParticleManager:SetParticleControlEnt( pfx,2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end

end

function modifier_Primary_empower:GetModifierBaseDamageOutgoing_Percentage()	return self.damage end
function modifier_Primary_empower:GetEffectName()	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf" end
function modifier_Primary_empower:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end



