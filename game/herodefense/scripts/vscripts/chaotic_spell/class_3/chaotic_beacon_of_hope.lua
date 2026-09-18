LinkLuaModifier("modifier_chaotic_beacon_of_hope", "chaotic_spell/class_3/chaotic_beacon_of_hope", LUA_MODIFIER_MOTION_NONE)

chaotic_beacon_of_hope = class({})
function chaotic_beacon_of_hope:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_beacon_of_hope/cast_effect/effect_target.vpcf", context )

end
function chaotic_beacon_of_hope:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_beacon_of_hope:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end


function chaotic_beacon_of_hope:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("chaotic_beacon_of_hope_cast")  
	local pos = caster:GetOrigin() + Vector(0,0,64)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_beacon_of_hope/cast_effect/effect_target.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,5)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * gain

	for _, unit in ipairs(units) do
		self:ApplyModifier(unit, duration)
	end





	
end

function chaotic_beacon_of_hope:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_beacon_of_hope/cast_effect/effect_glow.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin()+Vector(0,0,64))
	-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, target:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,1)
	target:AddNewModifier(caster, self, "modifier_chaotic_beacon_of_hope", {duration = duration})

end







modifier_chaotic_beacon_of_hope = advanced_modifier({})

function modifier_chaotic_beacon_of_hope:IsHidden() return false end
function modifier_chaotic_beacon_of_hope:IsPurgable() return true end
function modifier_chaotic_beacon_of_hope:IsDebuff() return false end

function modifier_chaotic_beacon_of_hope:OnCreated(keys)
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_healing_receive") * self:GetAbility():GetEffectGain()
end


function modifier_chaotic_beacon_of_hope:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_beacon_of_hope:OnTooltip() return self:Advanced_GetModifierHealReceiveAMP_Percentage() end
function modifier_chaotic_beacon_of_hope:Advanced_GetModifierHealReceiveAMP_Percentage()	
	return self.bonus
end
function modifier_chaotic_beacon_of_hope:ADDeclareFunctions()
	local funcs =  {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,

    }
	if self:GetAbility():GetRuneType()==1 then
		self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01
		self.rune_1_max_stack = self:GetAbility():GetSpecialValueFor("rune_1_max_stack")
		funcs["MODIFIER_EVENT_ON_Heal"] = {nil,self:GetParent()}
		funcs["MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK"] = {nil,self:GetParent()}
	end
    return  funcs
   
end

function modifier_chaotic_beacon_of_hope:AdvancedOnHeal(keys)	

	if keys.target==self:GetParent() then
		self:SetStackCount(math.min(keys.heal*self.rune_1_bonus+self:GetStackCount(),self:GetCaster():HDGetPrimaryStatValue()*self.rune_1_max_stack))
	end
	return self.bonus
end




function modifier_chaotic_beacon_of_hope:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        -- self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack
end