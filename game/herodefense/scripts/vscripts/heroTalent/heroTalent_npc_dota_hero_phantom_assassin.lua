heroTalent_npc_dota_hero_phantom_assassin = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_buff", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_phantom_assassin:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_phantom_assassin"
end

modifier_heroTalent_npc_dota_hero_phantom_assassin = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:IsHidden() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnCreated() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.chance = 50
	self.mult_max = self:GetAbility():GetSpecialValueFor("mult_max")
	self.bonus_mult_max = self:GetAbility():GetSpecialValueFor("bonus_mult_max")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")

	self.talentgain = self.ability:GetTalentGain(0.8)
	self.crit_mult = 100 + (self.mult_max + self.parent:GetLevel()*self.bonus_mult_max)/self.chance
	self.crit_mult_t = self.crit_mult*self.talentgain

	self.crit = {}
	self:SetStackCount(self.chance)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnIntervalThink()
	if self.ability:GetAutoCastState() then
		self.chance = math.random(1,100)
		self:SetStackCount(self.chance)
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:DeclareFunctions()
 	return 
	{
	  	MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_TOOLTIP
	} 
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.8)
	self.crit_mult = 100 + (self.mult_max + self.parent:GetLevel()*self.bonus_mult_max)/self:GetStackCount()
	self.crit_mult_t = self.crit_mult*self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self:GetStackCount()
    end
    if self._tooltip == 2 then
        return self.crit_mult_t
    end
    if self._tooltip == 3 then
        return (self.mult_max + self.parent:GetLevel()*self.bonus_mult_max)*self.talentgain
    end
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end

function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnDestroy() self.crit = nil end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:Advanced_GetModifierCriticalStrike(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	if attacker ~= self.parent then return end

	
	self.talentgain = self.ability:GetTalentGain(0.8)
	local chance = self.chance
	local mult = (100 + (self.mult_max + self.parent:GetLevel()*self.bonus_mult_max)/chance)*self.talentgain

	local random = math.random
	if chance >= random(1,100) then
		local buff = attacker:FindModifierByName("modifier_heroTalent_npc_dota_hero_phantom_assassin_buff")
		if buff then
			buff:ForceRefresh()
			buff:SetDuration(self.duration, true)
		else
			attacker:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_phantom_assassin_buff", {duration = self.duration})
		end

		self.crit[keys.record] = true
		self.chance = random(1,100)
		self:SetStackCount(self.chance)
		return mult 
	else		
		return 0
	end
end

function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_heroTalent_npc_dota_hero_phantom_assassin:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker ~= self.parent  or not target:IsAlive() then return end

	if self.crit[keys.record] then
		local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, target)
		attacker:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	self.crit[keys.record] = nil
end
----
modifier_heroTalent_npc_dota_hero_phantom_assassin_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:IsHidden() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:OnCreated() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.move = self.ability:GetSpecialValueFor("move")
	self.evasion = self.ability:GetSpecialValueFor("evasion")
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:DeclareFunctions()
 	return 
	{
	  	MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	} 
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:GetModifierEvasion_Constant()
	return self.evasion
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end
