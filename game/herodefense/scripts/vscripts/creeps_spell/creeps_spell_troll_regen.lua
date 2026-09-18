creeps_spell_troll_regen = class({})
LinkLuaModifier("modifier_creeps_spell_troll_regen_damage_count", "creeps_spell/creeps_spell_troll_regen", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_troll_regen:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti8/fountain_regen_ti8_lvl2.vpcf", context )
end

function creeps_spell_troll_regen:IsHiddenWhenStolen() 		return false end
function creeps_spell_troll_regen:IsRefreshable() 			return true end
function creeps_spell_troll_regen:IsStealable() 				return true end
function creeps_spell_troll_regen:IsNetherWardStealable()		return true end
function creeps_spell_troll_regen:GetIntrinsicModifierName() return "modifier_creeps_spell_troll_regen_damage_count" end

modifier_creeps_spell_troll_regen_damage_count = advanced_modifier({})
function modifier_creeps_spell_troll_regen_damage_count:IsHidden() return false end
function modifier_creeps_spell_troll_regen_damage_count:IsDebuff() return false end
function modifier_creeps_spell_troll_regen_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_troll_regen_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_troll_regen_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_troll_regen_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_troll_regen_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_troll_regen_damage_count:DeclareFunctions() return
    {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_creeps_spell_troll_regen_damage_count:AdvancedGetModifierConstantHealthRegenPercentage() return self:GetStackCount()==1 and 5 or 0 end


function modifier_creeps_spell_troll_regen_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.unit ~= self:GetParent() then
		return
	end
	-- if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
	-- 	return
    -- end
    if keys.damage<=0 then
        return
    end
    self:GetAbility():StartCooldown(1.5)
end


function modifier_creeps_spell_troll_regen_damage_count:OnCreated(keys)
    if IsServer() then
        self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti8/fountain_regen_ti8_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
    end
end

function modifier_creeps_spell_troll_regen_damage_count:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	end
end


function modifier_creeps_spell_troll_regen_damage_count:OnIntervalThink()
	if not self:GetAbility():IsCooldownReady() or not self:GetParent():IsAlive() then
		self:SetStackCount(0)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
		return
	else
		self:SetStackCount(1)
		if not self.nFXIndex then
            self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti8/fountain_regen_ti8_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
        end
	end
end

function modifier_creeps_spell_troll_regen_damage_count:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end