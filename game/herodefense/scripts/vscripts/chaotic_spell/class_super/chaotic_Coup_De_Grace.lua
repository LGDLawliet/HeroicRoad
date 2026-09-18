chaotic_Coup_De_Grace = class({})

LinkLuaModifier("modifier_chaotic_Coup_De_Grace", "chaotic_spell/class_super/chaotic_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)

function chaotic_Coup_De_Grace:GetIntrinsicModifierName() return "modifier_chaotic_Coup_De_Grace" end

modifier_chaotic_Coup_De_Grace = advanced_modifier({})

function modifier_chaotic_Coup_De_Grace:IsDebuff()			return false end
function modifier_chaotic_Coup_De_Grace:IsHidden() 		return true end
function modifier_chaotic_Coup_De_Grace:IsPurgable() 		return false end
function modifier_chaotic_Coup_De_Grace:IsPurgeException() return false end
function modifier_chaotic_Coup_De_Grace:DeclareFunctions() return 
	{
	  	MODIFIER_EVENT_ON_ATTACK_FAIL
	} 
end
function modifier_chaotic_Coup_De_Grace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end
function modifier_chaotic_Coup_De_Grace:OnCreated() 
    self.crit = {}

    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    self.crit_mult = self:GetAbility():GetSpecialValueFor("crit_mult")
    self.line = self:GetAbility():GetSpecialValueFor("line")
    self.crit_mult_add = self:GetAbility():GetSpecialValueFor("crit_mult_add")
end
function modifier_chaotic_Coup_De_Grace:OnDestroy() self.crit = nil end

function modifier_chaotic_Coup_De_Grace:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() then
		local pct = self.chance
		local random = math.random
		if pct > random(0,100) then
			self.crit[keys.record] = true
			local damage_mul = self.crit_mult
			if keys.target:GetHealthPercent() <= self.line then
               damage_mul = damage_mul + self.crit_mult_add 
            end
			return damage_mul 
		else		
			return 0
		end
	end
end

function modifier_chaotic_Coup_De_Grace:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_chaotic_Coup_De_Grace:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	local caster = self:GetParent()
	if self.crit[keys.record] then
		local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, keys.target)
		self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	self.crit[keys.record] = nil
end



