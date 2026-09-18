Primary_water_prison = class({})
LinkLuaModifier( "modifier_Primary_water_prison", "skills/Primary_water_prison", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function Primary_water_prison:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/water_prison/water_prison.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", context )
	

end


function Primary_water_prison:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )


	target:AddNewModifier(caster, self, "modifier_Primary_water_prison", { duration = duration } )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(450,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	-- play effects
	local sound_cast = "Ability.pre.Torrent"
	local sound_target = "Hero_Kunkaa.Tidebringer"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
end





modifier_Primary_water_prison = advanced_modifier({})

function modifier_Primary_water_prison:IsHidden()	return false end
function modifier_Primary_water_prison:IsDebuff()	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() end
function modifier_Primary_water_prison:IsPurgable()	return false end
function modifier_Primary_water_prison:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}

	return funcs
end

function modifier_Primary_water_prison:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
function modifier_Primary_water_prison:GetModifierMagicalResistanceBonus() return self.bonus_magic_res end
function modifier_Primary_water_prison:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor end
function modifier_Primary_water_prison:OnCreated( kv )
	self.bonus_armor = 0
	self.bonus_magic_res = 0
	local ability = self:GetAbility()
	self.type = 1
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.type = 2
		self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
		self.bonus_magic_res = ability:GetSpecialValueFor("bonus_magic_res")
	end
	self.trigger = false

	self:StartIntervalThink(0.3)
	if not IsServer() then return end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/water_prison/water_prison.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(20,80,48))
	ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,1,1))
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	
end

function modifier_Primary_water_prison:OnIntervalThink()
	self.trigger = true
	self:StartIntervalThink(-1)
end

function modifier_Primary_water_prison:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 3, parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		parent:EmitSound("Ability.Ghostship.crash")
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local caster = self:GetCaster()


		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			damage = caster:GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}

	
		for _, enemy in ipairs(units) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
end


function modifier_Primary_water_prison:CheckState()
	local state = {
		
	}
	if self.trigger then
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
		if self.type==1 then
			state[MODIFIER_STATE_INVULNERABLE] = true
		end
		
	end

	return state
end


function modifier_Primary_water_prison:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end