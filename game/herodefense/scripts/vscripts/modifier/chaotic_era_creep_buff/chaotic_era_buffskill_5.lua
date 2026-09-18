chaotic_era_buffskill_5 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_5", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_5_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_5_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_5", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_5:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_5"
end

modifier_chaotic_era_buffskill_5 = advanced_modifier({})

function modifier_chaotic_era_buffskill_5:IsDebuff() return false end
function modifier_chaotic_era_buffskill_5:IsHidden() return false end
function modifier_chaotic_era_buffskill_5:IsPurgable() return false end

function modifier_chaotic_era_buffskill_5:OnCreated(keys)
    self.crit_event = {}
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.crit = self.ability:GetSpecialValueFor("crit")
end
function modifier_chaotic_era_buffskill_5:OnDestroy() self.crit_event = nil end
function modifier_chaotic_era_buffskill_5:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_ATTACK_FAIL
	}
	return funcs
end

function modifier_chaotic_era_buffskill_5:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() then
        local attacker = keys.attacker
        if attacker ~= self.parent then return end
        if attacker:PassivesDisabled() then return end
        if not self.ability:IsCooldownReady() then return end
        
		local pct = self.chance
		local random = math.random
		if pct > random(0,100) then
			self.crit_event[keys.record] = true
			local damage_mul = self.crit
			return damage_mul 
		else		
			return 0
		end
	end
end

function modifier_chaotic_era_buffskill_5:OnAttackFail(keys) self.crit_event[keys.record] = nil end

function modifier_chaotic_era_buffskill_5:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
    local attacker = keys.attacker
    local target = keys.target
	if attacker ~= self.parent then return end
    if attacker:PassivesDisabled() or not target:IsAlive() then return end
    if not self.ability:IsCooldownReady() then return end

	if self.crit_event[keys.record] then
		local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, target)
		attacker:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
        self.ability:UseResources(true, true, true, true)
	end
	self.crit_event[keys.record] = nil
end