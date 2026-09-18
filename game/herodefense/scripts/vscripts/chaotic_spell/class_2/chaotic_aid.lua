
chaotic_aid = class({})
LinkLuaModifier("modifier_chaotic_aid", "chaotic_spell/class_2/chaotic_aid", LUA_MODIFIER_MOTION_NONE)



function chaotic_aid:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_aid/target_effect_hit.vpcf", context )

end

function chaotic_aid:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_aid:GetBehavior()
	if self:GetCaster():HasModifier("pszScriptName") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end



function chaotic_aid:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_aid_target"    
	EmitSoundOn(sound_cast, caster)    
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * gain
	if self:GetRuneType()==1 then
		duration = duration * (1+0.01*self:GetSpecialValueFor("rune_1_bonuscas_gain"))

	end
	self:ApplyModifier(target, duration)

	local arti = caster:FindModifierByName("modifier_item_hd_holy_staff_effects")
	if arti then
		local arti_ability = arti:GetAbility()
		local level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_holy_staff_effects")
		if level and level >= 30 then
			local heroes = GetAllRealHeroes()
			for _,hero in pairs(heroes) do
				if hero ~= target then
					self:ApplyModifier(hero, duration* arti_ability:GetArtifactSpecialValueFor("duration_3")*0.01)
				end
			end
		end
	end
end

function chaotic_aid:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_aid/target_effect_hit.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,1.5)
	
	target:AddNewModifier(caster, self, "modifier_chaotic_aid", {duration = duration})

end


modifier_chaotic_aid = advanced_modifier({})

function modifier_chaotic_aid:IsHidden() return false end
function modifier_chaotic_aid:IsPurgable() return true end
function modifier_chaotic_aid:IsDebuff() return false end

function modifier_chaotic_aid:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor") * self:GetAbility():GetEffectGain()
end


function modifier_chaotic_aid:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_aid:OnTooltip() return self:Advanced_GetModifierPhysicalArmorBonus() end
function modifier_chaotic_aid:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor end
function modifier_chaotic_aid:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }
end