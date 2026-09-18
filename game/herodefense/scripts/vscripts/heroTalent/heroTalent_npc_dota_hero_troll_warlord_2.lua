heroTalent_npc_dota_hero_troll_warlord_2 = class({})
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_2_arua", "skills/heroTalent_npc_dota_hero_troll_warlord_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_2_arua_effect", "skills/heroTalent_npc_dota_hero_troll_warlord_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_2", "heroTalent/heroTalent_npc_dota_hero_troll_warlord_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_2_active", "heroTalent/heroTalent_npc_dota_hero_troll_warlord_2", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_troll_warlord_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_troll_warlord_2"
end


function heroTalent_npc_dota_hero_troll_warlord_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti8/fountain_regen_ti8_lvl2.vpcf", context )
end



modifier_heroTalent_npc_dota_hero_troll_warlord_2 = advanced_modifier({})




function modifier_heroTalent_npc_dota_hero_troll_warlord_2:IsHidden() 	return true end
function modifier_heroTalent_npc_dota_hero_troll_warlord_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_2:DeclareFunctions() return
    {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_heroTalent_npc_dota_hero_troll_warlord_2:AdvancedGetModifierConstantHealthRegenPercentage() return self:GetStackCount()==1 and 7 or 0 end


function modifier_heroTalent_npc_dota_hero_troll_warlord_2:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    if keys.damage<=0 then
        return
    end
    self:GetAbility():StartCooldown(7)
	self:SetStackCount(0)
end


function modifier_heroTalent_npc_dota_hero_troll_warlord_2:OnCreated(keys)
    if IsServer() then
        self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti8/fountain_regen_ti8_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.1)
    end
end

function modifier_heroTalent_npc_dota_hero_troll_warlord_2:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	end
end


function modifier_heroTalent_npc_dota_hero_troll_warlord_2:OnIntervalThink()
	if not self:GetAbility():IsCooldownReady() or not self:GetParent():IsAlive() or self:GetParent():PassivesDisabled() then
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


function modifier_heroTalent_npc_dota_hero_troll_warlord_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end
