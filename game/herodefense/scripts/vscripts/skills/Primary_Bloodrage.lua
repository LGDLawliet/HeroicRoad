Primary_Bloodrage = class({})

LinkLuaModifier("modifier_Primary_Bloodrage_buff", "skills/Primary_Bloodrage", LUA_MODIFIER_MOTION_NONE)
function Primary_Bloodrage:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*ModifierStatusGain

	target:AddNewModifier(caster, self, "modifier_Primary_Bloodrage_buff", {duration = duration})
	caster:EmitSound("hero_bloodseeker.bloodRage")
end


function Primary_Bloodrage:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
end




modifier_Primary_Bloodrage_buff = advanced_modifier({})

function modifier_Primary_Bloodrage_buff:IsDebuff() return false end
function modifier_Primary_Bloodrage_buff:IsHidden() return false end
function modifier_Primary_Bloodrage_buff:IsPurgable() return false end
function modifier_Primary_Bloodrage_buff:IsPurgeException() return false end
function modifier_Primary_Bloodrage_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end
function modifier_Primary_Bloodrage_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Bloodrage_buff:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_spell_damage = ability:GetSpecialValueFor("bonus_spell_damage")
	self.max_health_as_cost_per_second =ability:GetSpecialValueFor("max_health_as_cost_per_second")*0.01
	if IsServer() then
		-- local parent = self:GetParent()
		-- self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		-- self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		-- self.interval = 0.25
		self:StartIntervalThink(1)
		-- self.block = self:GetAbility():GetSpecialValueFor("bonus_block")*self:GetCaster():GetIntellect(false)

	end
end

function modifier_Primary_Bloodrage_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,         --魔法抗性
	}
end
function modifier_Primary_Bloodrage_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Primary_Bloodrage_buff:OnIntervalThink()
	local ability = self:GetAbility()
	-- local caster = self:GetCaster()
	local parent = self:GetParent()
	local health = parent:GetHealth() -parent:GetMaxHealth()*self.max_health_as_cost_per_second
	parent:ModifyHealth(health,ability,false,0)

end


function modifier_Primary_Bloodrage_buff:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end
function modifier_Primary_Bloodrage_buff:Advanced_GetModifierSpellAmplifyBonus(keys) 
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL   then
		return self.bonus_spell_damage 
	end
	return 0
end


