chaotic_live_in_peace_magic = class({})

LinkLuaModifier("modifier_chaotic_live_in_peace_magic_thinker", "chaotic_spell/class_7/chaotic_live_in_peace_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_live_in_peace_magic_debuff", "chaotic_spell/class_7/chaotic_live_in_peace_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_live_in_peace_magic_debuff_aura_debuff", "chaotic_spell/class_7/chaotic_live_in_peace_magic", LUA_MODIFIER_MOTION_NONE)

function chaotic_live_in_peace_magic:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_live_in_peace_magic/effect/main_ring.vpcf", context )
end


function chaotic_live_in_peace_magic:OnSpellStart()

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:EmitSound("chaotic_live_in_peace_magic_cast")
	self.thinker = CreateModifierThinker(
		caster, 
		self, 
		"modifier_chaotic_live_in_peace_magic_thinker",
		{duration = duration},
		caster:GetAbsOrigin(),
		caster:GetTeamNumber(),
		false
	)
end


modifier_chaotic_live_in_peace_magic_thinker = advanced_modifier({})
function modifier_chaotic_live_in_peace_magic_thinker:OnCreated( kv )

	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.radius =self:GetAbility():GetSpecialValueFor("radius")
		self.distance = self.ability:GetSpecialValueFor("distance")
		self.duration = self.ability:GetSpecialValueFor("duration")
		self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
		
		self.UnitTable = {}
		self:PlayEffects(self:GetParent():GetAbsOrigin())
	end
end

function modifier_chaotic_live_in_peace_magic_thinker:OnDestroy()
	if not IsServer() then return end
	if self.thinkerParticle then
		ParticleManager:DestroyParticle( self.thinkerParticle,true)
	end
	if self.ability.thinker then
		self.ability.thinker = nil
	end
	UTIL_Remove( self:GetParent() )
end


function modifier_chaotic_live_in_peace_magic_thinker:IsAura()	return true end
function modifier_chaotic_live_in_peace_magic_thinker:GetModifierAura()
	return "modifier_chaotic_live_in_peace_magic_debuff_aura_debuff" 
end
function modifier_chaotic_live_in_peace_magic_thinker:GetAuraRadius()	return self.radius end
function modifier_chaotic_live_in_peace_magic_thinker:GetAuraDuration()	return 0.2 end
function modifier_chaotic_live_in_peace_magic_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_live_in_peace_magic_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_chaotic_live_in_peace_magic_thinker:GetAuraEntityReject(hEntity)
	if not IsInTable(hEntity,self.UnitTable) then
		-- local enemy_direction = (hEntity:GetOrigin() - self.ability.CasterPos):Normalized()
		if not IsValid(self.ability) then
			return
		end
		local pos = self:GetParent():GetAbsOrigin()
		local knockback =
		{
			knockback_duration = 0.2,
			duration = 0.15,
			knockback_distance = self.distance,
			knockback_height = 20,
			center_x = pos.x,
			center_y = pos.y,
			center_z = pos.z,
		}
		hEntity:EmitSound("chaotic_live_in_peace_magic_cast")
		hEntity:RemoveModifierByName("modifier_knockback")
		hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", knockback)		
		table.insert(self.UnitTable, hEntity)
		local ModifierStatusNegativeGain = self:GetParent():GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = hEntity:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		hEntity:AddNewModifier(self.caster, self.ability, "modifier_chaotic_live_in_peace_magic_debuff", {duration = self.slow_duration*StatusResistance})
		return true
	end
	return false
end
function modifier_chaotic_live_in_peace_magic_thinker:PlayEffects( loc )
	self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_live_in_peace_magic/effect/main_ring.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControl( self.particle, 0,loc)
	-- ParticleManager:SetParticleControl( self.particle, 2,loc)
	ParticleManager:SetParticleControl( self.particle, 1,Vector(self.radius,self.radius,self.radius) )
	self:AddParticle(self.particle, false, false, -1, false, false)
	local sound_location = "Hero_Grimstroke.InkSwell.Stun"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end

modifier_chaotic_live_in_peace_magic_debuff = advanced_modifier({})
function modifier_chaotic_live_in_peace_magic_debuff:IsHidden()	return false end
function modifier_chaotic_live_in_peace_magic_debuff:IsDebuff()	return true end
function modifier_chaotic_live_in_peace_magic_debuff:IsPurgable()	return true end

function modifier_chaotic_live_in_peace_magic_debuff:OnCreated()
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_speed_reduction")
end

function modifier_chaotic_live_in_peace_magic_debuff:OnRefresh()
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_speed_reduction")
end

function modifier_chaotic_live_in_peace_magic_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_live_in_peace_magic_debuff:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:GetModifierMoveSpeedBonus_Constant()
	end
end

function modifier_chaotic_live_in_peace_magic_debuff:GetModifierMoveSpeedBonus_Constant() 
    return self.move_speed_reduction
end

modifier_chaotic_live_in_peace_magic_debuff_aura_debuff = advanced_modifier({})
function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:IsHidden()	return false end
function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:IsDebuff()	return true end
function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:IsPurgable()	return false end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if not self:GetAbility() then
		self.armor_reduction = 0
		self.magic_resistance_reduction = 0
	end

	self.armor_reduction = -self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.magic_resistance_reduction = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduction")
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:OnRefresh()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if not self:GetAbility() then
		self.armor_reduction = 0
		self.magic_resistance_reduction = 0
	end

	self.armor_reduction = -self:GetAbility():GetSpecialValueFor("armor_reduction")
	self.magic_resistance_reduction = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduction")
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
	end
    if self._tooltip == 2 then
        return self:GetModifierMagicalResistanceBonus()
	end	
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor_reduction
end

function modifier_chaotic_live_in_peace_magic_debuff_aura_debuff:GetModifierMagicalResistanceBonus()	return self.magic_resistance_reduction end