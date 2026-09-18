
LinkLuaModifier( "modifier_Primary_enrage", "skills/Primary_enrage", LUA_MODIFIER_MOTION_NONE )


Primary_enrage						= Primary_enrage or class({})

function Primary_enrage:IsRefreshable() return false end
function Primary_enrage:OnSpellStart()


	
	local caster =self:GetCaster()
	EmitSoundOn( "Hero_Ursa.Enrage", caster )
	caster:Purge(false, true, false, true, true)  --强驱散
	local Gain = caster:GetModifierDurationGainIndex(0.4)
	caster:AddNewModifier(caster, self, "modifier_Primary_enrage", {duration =self:GetSpecialValueFor("duration")*Gain})
end





modifier_Primary_enrage = advanced_modifier({})

-----------------------------------------------------------------------------------------
function modifier_Primary_enrage:IsDebuff() return false end
function modifier_Primary_enrage:IsHidden() return false end
function modifier_Primary_enrage:IsPurgable()
	return false
end

function modifier_Primary_enrage:OnCreated( kv )
	self.bonus_damage_reduce = -self:GetAbility():GetSpecialValueFor( "bonus_damage_reduce" )
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor( "bonus_status_resistance" )
	local parent = self:GetParent()

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		--变色
		-- ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(0,0,0))
		-- ParticleManager:SetParticleControl(self.nFXIndex, 61, Vector(1,0,0))
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 60, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end


function modifier_Primary_enrage:Advanced_GetModifierIncomingDamage_Percentage( params )
	return self.bonus_damage_reduce
end


function modifier_Primary_enrage:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
	return funcs
end

function modifier_Primary_enrage:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

