LinkLuaModifier( "modifier_chaotic_heroes_feast", "chaotic_spell/class_6/chaotic_heroes_feast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_heroes_feast_advanced", "chaotic_spell/class_6/chaotic_heroes_feast", LUA_MODIFIER_MOTION_NONE )

chaotic_heroes_feast = class({})
function chaotic_heroes_feast:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_heroes_feast/main_effect/effect_gold/tide_2021_gold_ravage.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_heroes_feast/food_hit/food_end_right.vpcf", context )
end
function chaotic_heroes_feast:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_heroes_feast:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("chaotic_heroes_feast_cast")  
	local pos = caster:GetOrigin()+Vector(0,0,64)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_heroes_feast/main_effect/effect_gold/tide_2021_gold_ravage.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,5)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	-- local heal =  self:GetSpecialValueFor("base_damage")+self:GetSpecialValueFor("bonus_damage") * caster:HDGetPrimaryStatValue()
	
	
	local duration = self:GetSpecialValueFor("duration")*caster:GetModifierDurationGainIndex(1)
	local advanced_duration = self:GetSpecialValueFor("advanced_duration")*caster:GetModifierDurationGainIndex(1)
	for _, unit in ipairs(units) do
		if unit:IsRealHero() then
			self:PlayEffect(unit)
			self:ApplyModifier(unit, duration)
			self:ApplyModifier2(unit, advanced_duration)
	
		end
	end





	
end


function chaotic_heroes_feast:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_heroes_feast/food_hit/food_end_right.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	-- target:EmitSound("chaotic_heroes_feast_target")
end

function chaotic_heroes_feast:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_heroes_feast", {duration = duration})
end
function chaotic_heroes_feast:ApplyModifier2(target, duration)
	local caster = self:GetCaster()
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_heroes_feast_advanced", {duration = duration})
end










modifier_chaotic_heroes_feast = advanced_modifier({})

function modifier_chaotic_heroes_feast:IsHidden() 			return false end
function modifier_chaotic_heroes_feast:IsPurgable() 			return true end
function modifier_chaotic_heroes_feast:IsPurgeException() 	return true end
function modifier_chaotic_heroes_feast:IsDebuff() return false end


function modifier_chaotic_heroes_feast:OnCreated(keys)
	self.base_health = self:GetAbility():GetSpecialValueFor("base_health")
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor("bonus_status_resistance")

end
function modifier_chaotic_heroes_feast:OnRefresh(keys)
	self:OnCreated(keys)
end



function modifier_chaotic_heroes_feast:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_chaotic_heroes_feast:AdvancedGetModifierHealthBonus(keys)
	return self.base_health
end
function modifier_chaotic_heroes_feast:OnTooltip() return self:AdvancedGetModifierHealthBonus() end
function modifier_chaotic_heroes_feast:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_heroes_feast:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end









modifier_chaotic_heroes_feast_advanced = advanced_modifier({})

function modifier_chaotic_heroes_feast_advanced:IsHidden() 			return false end
function modifier_chaotic_heroes_feast_advanced:IsPurgable() 			return true end
function modifier_chaotic_heroes_feast_advanced:IsPurgeException() 	return true end
function modifier_chaotic_heroes_feast_advanced:IsDebuff() return false end


function modifier_chaotic_heroes_feast_advanced:OnCreated(keys)
	self.bonus_trigger_chance = self:GetAbility():GetSpecialValueFor("bonus_trigger_chance")
	self.healing_per_second = self:GetAbility():GetSpecialValueFor("healing_per_second")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_heroes_feast_advanced:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_chaotic_heroes_feast_advanced:OnIntervalThink()
	local parent = self:GetParent()
	local caster  = self:GetCaster()
	local fhealing =  HealWithGain(self.healing_per_second,caster,parent,self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent, fhealing, nil) 
end
function modifier_chaotic_heroes_feast_advanced:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_RandomEffectGain
    }
end
function modifier_chaotic_heroes_feast_advanced:Advanced_GetModifier_RandomEffectGain(keys)
	return self.bonus_trigger_chance
end
function modifier_chaotic_heroes_feast_advanced:OnTooltip() return self:Advanced_GetModifier_RandomEffectGain() end
function modifier_chaotic_heroes_feast_advanced:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end




