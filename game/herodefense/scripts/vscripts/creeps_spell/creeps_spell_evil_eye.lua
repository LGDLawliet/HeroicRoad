creeps_spell_evil_eye = class({})




LinkLuaModifier("modifier_creeps_spell_evil_eye_debuff", "creeps_spell/creeps_spell_evil_eye", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_evil_eye:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf", context )
end



function creeps_spell_evil_eye:IsHiddenWhenStolen() 		return false end
function creeps_spell_evil_eye:IsRefreshable() 			return true end
function creeps_spell_evil_eye:IsStealable() 				return true end
function creeps_spell_evil_eye:IsNetherWardStealable()		return true end


function creeps_spell_evil_eye:OnSpellStart()

	local caster    =   self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
	-- local angle = AngleBetween(caster:GetAbsOrigin(),pos)

	local direction = GetDirection2D(pos, caster_pos)
	pos = caster:GetAbsOrigin() + direction*(-200)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye1", self:GetCaster():GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())

	-- ParticleManager:SetParticleControl(particle, 1, pos)
	
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(particle,false)
		ParticleManager:ReleaseParticleIndex(particle)
	end)

    local duration = self:GetSpecialValueFor("duration")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	local enemy = FindUnitsInTrapezoid(caster:GetTeamNumber(), direction, GetGroundPosition(caster:GetAbsOrigin(), nil), 100, 300, 600, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(enemy) do
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, self, "modifier_creeps_spell_evil_eye_debuff", {duration = duration*StatusResistance})
	end

end





modifier_creeps_spell_evil_eye_debuff = advanced_modifier({})

function modifier_creeps_spell_evil_eye_debuff:IsDebuff() return true end
function modifier_creeps_spell_evil_eye_debuff:IsHidden() return false end
function modifier_creeps_spell_evil_eye_debuff:IsPurgable() return false end
function modifier_creeps_spell_evil_eye_debuff:IsPurgeException() return false end
function modifier_creeps_spell_evil_eye_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_evil_eye_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
	}
end

function modifier_creeps_spell_evil_eye_debuff:OnCreated(keys)
    local ability = self:GetAbility()
    self.spell_damage = -ability:GetSpecialValueFor("spell_damage_reduce")
    self.damage = -ability:GetSpecialValueFor("attack_reduce")

	self.bonus_status_resistance = -ability:GetSpecialValueFor("status_resistacne_reduce")
    if IsServer() then
  
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )


        
    end
end

function modifier_creeps_spell_evil_eye_debuff:OnDestroy(keys)

    if IsServer() then        if self.nFXIndex then
            ParticleManager:DestroyParticle(self.nFXIndex,false)
            ParticleManager:ReleaseParticleIndex(self.nFXIndex)
        end

    end
end
function modifier_creeps_spell_evil_eye_debuff:Advanced_GetModifierSpellAmplifyBonus()	return self.spell_damage end
function modifier_creeps_spell_evil_eye_debuff:GetModifierBaseDamageOutgoing_Percentage()	return self.damage end



function modifier_creeps_spell_evil_eye_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end



function modifier_creeps_spell_evil_eye_debuff:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

