heroTalent_npc_dota_hero_meepo = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_meepo", "heroTalent/heroTalent_npc_dota_hero_meepo", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_meepo:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_meepo:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_meepo:IsStealable() 				return true end
function heroTalent_npc_dota_hero_meepo:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_meepo:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_meepo" end


modifier_heroTalent_npc_dota_hero_meepo = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_meepo:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_meepo:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_meepo:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_meepo:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_meepo:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_meepo:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_meepo:OnCreated(table)
    if not IsServer()  then
        return
    end

    self.count = 0

end
function modifier_heroTalent_npc_dota_hero_meepo:OnWaveEnd()
    
    self.count = self.count +1
    if self.count>=4 then
        local hero = self:GetParent()
        self.count = self.count-4
        local abilityPoints = hero:GetAbilityPoints()+1
        hero:SetAbilityPoints(abilityPoints)
        
        local particle_cast = "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_loadout.vpcf"

        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControl( effect_cast, 0, hero:GetOrigin() )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        hero:EmitSound("Hero_Meepo.Poof")
    end
    return 1
end


function modifier_heroTalent_npc_dota_hero_meepo:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end


