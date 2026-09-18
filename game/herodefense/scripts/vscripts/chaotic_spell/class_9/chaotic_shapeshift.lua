LinkLuaModifier("modifier_chaotic_shapeshift_transform_stun", "chaotic_spell/class_9/chaotic_shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_shapeshift_transform", "chaotic_spell/class_9/chaotic_shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_shapeshift_rune_1", "chaotic_spell/class_9/chaotic_shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
chaotic_shapeshift = class({})
function chaotic_shapeshift:GetIntrinsicModifierName()
	return "modifier_chaotic_shapeshift_rune_1"
end
function chaotic_shapeshift:Precache( context )
	PrecacheResource( "model", "models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl", context )
	PrecacheResource( "model", "models/items/lycan/wolves/_ascension_of_the_hallowed_beast_summons/_ascension_of_the_hallowed_beast_summons.vmdl", context )
end
function chaotic_shapeshift:IsRefreshable() return false end
function chaotic_shapeshift:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	local transformation_time = 0.1
	local duration = ability:GetSpecialValueFor("duration")	
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_chaotic_shapeshift_transform"
	

	EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	caster:AddNewModifier(caster, ability, "modifier_chaotic_shapeshift_transform_stun", {duration = transformation_time})
	caster:GameTimer(transformation_time, function()
        local gain = caster:GetModifierDurationGainIndex(0.4)

        local buff = caster:FindModifierByName("modifier_chaotic_shapeshift_transform")
		if buff then
            buff:SetDuration(duration*gain, true)
        else
		    caster:AddNewModifier(caster, ability, "modifier_chaotic_shapeshift_transform", {duration = duration*gain})
        end
	end)	
end


modifier_chaotic_shapeshift_transform_stun = class({})

function modifier_chaotic_shapeshift_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end
function modifier_chaotic_shapeshift_transform_stun:IsHidden()
	return true
end

modifier_chaotic_shapeshift_transform = advanced_modifier({})
function modifier_chaotic_shapeshift_transform:IsHidden()	return false end
function modifier_chaotic_shapeshift_transform:IsPurgable()	return false end
function modifier_chaotic_shapeshift_transform:IsDebuff()	return false end
function modifier_chaotic_shapeshift_transform:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()    
    self.attack = self.ability:GetSpecialValueFor("attack")
    self.evasion = self.ability:GetSpecialValueFor("evasion")
    self.crit = self.ability:GetSpecialValueFor("crit")
    self.bonus = self.ability:GetSpecialValueFor("bonus")
    self.time = self.ability:GetSpecialValueFor("time")
    self.index = self.ability:GetSpecialValueFor("index")

    self.type = self.ability:GetRuneType()
    self.rune_1_crit = self.ability:GetSpecialValueFor("rune_1_crit")
    self.rune_1_max = self.ability:GetSpecialValueFor("rune_1_max")
    self:SetStackCount(0)
end
function modifier_chaotic_shapeshift_transform:OnDestroy()
    if IsServer() then    	
    	local particle_revert_fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    	ParticleManager:SetParticleControl(particle_revert_fx, 0, self:GetParent():GetAbsOrigin())
    	ParticleManager:SetParticleControl(particle_revert_fx, 3, self:GetParent():GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex(particle_revert_fx)
    end
end
function modifier_chaotic_shapeshift_transform:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return decFuncs	
end
function modifier_chaotic_shapeshift_transform:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
        MODIFIER_EVENT_ON_DEATH  = {self:GetParent(),nil}
        }
    if self:GetAbility():GetRuneType() == 1 then
        funcs["MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER"] = {self:GetParent(),nil}
    end
	return funcs
end
function modifier_chaotic_shapeshift_transform:GetModifierModelScale() 
    return 30
end
function modifier_chaotic_shapeshift_transform:GetModifierModelChange()
	if self.type == 1 then
		return "models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl"
	end
	return "models/items/lycan/wolves/_ascension_of_the_hallowed_beast_summons/_ascension_of_the_hallowed_beast_summons.vmdl"
end
function modifier_chaotic_shapeshift_transform:Advanced_GetModifier_PhysicalCriticalAmp(keys)
    if not self:GetAbility() then self:Destroy() return end
	return self.crit + self:GetStackCount()
end
function modifier_chaotic_shapeshift_transform:GetModifierEvasion_Constant()
    if not self:GetAbility() then self:Destroy() return end
	return self.evasion
end
function modifier_chaotic_shapeshift_transform:Advanced_GetModifierBaseAttack_BonusDamage()
    if not self:GetAbility() then self:Destroy() return end
	return self.attack
end
function modifier_chaotic_shapeshift_transform:OnDeath(keys)
    if not self:GetAbility() then self:Destroy() return end
    if not IsServer() then return end
    local unit = keys.unit
    local attacker = keys.attacker
    if unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
    if attacker ~= self.parent then return end

    local time_plus = self.bonus
    if unit:IsChaoticEraElite() then
        time_plus = self.bonus*self.index
    end
    self:SetDuration(math.min(self:GetRemainingTime() + time_plus, self.time), true)
end
function modifier_chaotic_shapeshift_transform:AdvancedOnCriticalStrikeTrigger(keys)
	if IsServer() then
        local attacker = keys.attacker
        if attacker == self.parent then
			self:SetStackCount(math.min(self:GetStackCount()+self.rune_1_crit, self.rune_1_max))
		end
	end
end

modifier_chaotic_shapeshift_rune_1 = advanced_modifier({})
function modifier_chaotic_shapeshift_rune_1:IsHidden()	return true end
function modifier_chaotic_shapeshift_rune_1:IsPurgable()	return false end
function modifier_chaotic_shapeshift_rune_1:IsDebuff()	return false end
function modifier_chaotic_shapeshift_rune_1:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()    
    self.type = self.ability:GetRuneType()
    self.rune_1_incoming = self.ability:GetSpecialValueFor("rune_1_incoming")
    self:SetStackCount(0)
    if IsServer() then
        self:StartIntervalThink(0.75)
        self:OnIntervalThink()
    end
end
function modifier_chaotic_shapeshift_rune_1:OnIntervalThink()
    local ability = self:GetAbility()
	if ability and self.parent:IsAlive() then
		if HDCanAutoCast(self.parent, ability)==true then
			self.parent:CastAbilityNoTarget(ability, self.parent:GetPlayerOwnerID())
		end
	end

    if self.type == 1 then
	    self:SetStackCount(self.parent:GetEvasion()*100)
    end
end
function modifier_chaotic_shapeshift_rune_1:ADDeclareFunctions()
    local funcs = {}
    if self:GetAbility():GetRuneType() == 1 then
        table.insert(funcs, advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
        funcs["MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER"] = {self:GetParent(),nil}
    end
	return funcs
end
function modifier_chaotic_shapeshift_rune_1:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
	return -self.rune_1_incoming*self:GetStackCount()
end