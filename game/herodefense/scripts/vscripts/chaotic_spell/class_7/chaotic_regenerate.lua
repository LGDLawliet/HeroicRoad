
chaotic_regenerate = class({})
LinkLuaModifier("modifier_chaotic_regenerate", "chaotic_spell/class_7/chaotic_regenerate", LUA_MODIFIER_MOTION_NONE)


function chaotic_regenerate:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_regenerate/effect_main/effect_regeneration.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_regenerate/effect_target/effect.vpcf", context )

end



function chaotic_regenerate:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_regenerate_target"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(target)
end




function chaotic_regenerate:ApplyModifier(target)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_regenerate/effect_target/effect.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle_cast_fx,1.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_regenerate", {duration =  self:GetSpecialValueFor("duration")*gain})

	local heal =  self:GetSpecialValueFor("base_damage")+self:GetSpecialValueFor("bonus_damage") * caster:HDGetPrimaryStatValue()
	local per_health = target:GetHealth()
	local fhealing =  HealWithGain(heal,caster,target,self)
	local real_heal = target:GetHealth()-per_health
	if self:GetRuneType()==1 and real_heal>0 then
		local mana_regen = real_heal * self:GetSpecialValueFor("rune_1_bonus")*0.01
		target:GiveMana(mana_regen)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, mana_regen, nil)
	end
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,target, fhealing, nil) 
end



modifier_chaotic_regenerate = advanced_modifier({})

function modifier_chaotic_regenerate:IsHidden() return false end
function modifier_chaotic_regenerate:IsPurgable() return true end
function modifier_chaotic_regenerate:IsDebuff() return false end
function modifier_chaotic_regenerate:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_health_regen_amp = ability:GetSpecialValueFor("bonus_health_regen_amp")
	self.bonus_health_regen = ability:GetSpecialValueFor("bonus_health_regen")
end
function modifier_chaotic_regenerate:GetEffectName()
	return "particles/rebuild/chaotic_spell/chaotic_regenerate/effect_main/effect_regeneration.vpcf"
end






function modifier_chaotic_regenerate:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, --生命恢复 常数
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE, --生命恢复增强 百分比
	
    }
end

function modifier_chaotic_regenerate:AdvancedGetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_chaotic_regenerate:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.bonus_health_regen_amp
end


function modifier_chaotic_regenerate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_regenerate:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantHealthRegen()
	elseif self._tooltip == 2 then
		return self:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	end
end


