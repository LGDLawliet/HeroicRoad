Primary_fear_arua = class({})
LinkLuaModifier( "modifier_Primary_fear_arua", "skills/Primary_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_fear_arua_effect", "skills/Primary_fear_arua", LUA_MODIFIER_MOTION_NONE )


function Primary_fear_arua:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/bugs/bug.vpcf", context )

end



-- require('internal/timers')   --计时器功能
function Primary_fear_arua:GetIntrinsicModifierName()
	return "modifier_Primary_fear_arua"
end

function Primary_fear_arua:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_Primary_fear_arua = class({})

function modifier_Primary_fear_arua:IsHidden()	return true end
function modifier_Primary_fear_arua:IsDebuff()	return false end
function modifier_Primary_fear_arua:IsPurgable()	return false end
function modifier_Primary_fear_arua:IsPurgeException() return false end
function modifier_Primary_fear_arua:RemoveOnDeath() return false end
function modifier_Primary_fear_arua:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Primary_fear_arua:GetModifierAura()	return "modifier_Primary_fear_arua_effect" end
function modifier_Primary_fear_arua:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Primary_fear_arua:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Primary_fear_arua:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Primary_fear_arua:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Primary_fear_arua:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/bugs/bug.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end

function modifier_Primary_fear_arua:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/bugs/bug.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end


modifier_Primary_fear_arua_effect = advanced_modifier({})
function modifier_Primary_fear_arua_effect:IsHidden()	return false end
function modifier_Primary_fear_arua_effect:IsDebuff()	return true end
function modifier_Primary_fear_arua_effect:IsPurgable()	return false end
-- function modifier_Primary_fear_arua_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_Primary_fear_arua_effect:GetModifierBaseDamageOutgoing_Percentage()	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return 0
	end
	return -ability:GetSpecialValueFor("bonus_damage")
end
function modifier_Primary_fear_arua_effect:Advanced_GetModifierIncomingDamage_Percentage()	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return 0
	end
	return ability:GetSpecialValueFor("bonus_damage_resistance")
end


function modifier_Primary_fear_arua_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
