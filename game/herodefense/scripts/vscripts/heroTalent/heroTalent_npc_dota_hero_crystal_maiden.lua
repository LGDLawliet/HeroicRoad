heroTalent_npc_dota_hero_crystal_maiden = class({})
require('internal/timers')   --计时器功能
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_crystal_maiden", "heroTalent/heroTalent_npc_dota_hero_crystal_maiden", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_crystal_maiden_effect", "heroTalent/heroTalent_npc_dota_hero_crystal_maiden", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_crystal_maiden:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_crystal_maiden:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_crystal_maiden:IsStealable() 				return true end
function heroTalent_npc_dota_hero_crystal_maiden:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_crystal_maiden:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_crystal_maiden" end


modifier_heroTalent_npc_dota_hero_crystal_maiden = class({})

function modifier_heroTalent_npc_dota_hero_crystal_maiden:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_heroTalent_npc_dota_hero_crystal_maiden:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end

	if keys.ability:GetCooldown(-1) <= 2.5 then
		return
	end


	if self:GetParent():PassivesDisabled() then
		return
	end
    local ability = self:GetAbility()
    local time = ability:GetCooldownTimeRemaining()
    if time>=15 then
        return
    end
    Timers:CreateTimer(RandomFloat(0.05, 0.3), function()
        for i=0, self:GetParent():GetAbilityCount() - 1 do
            local Ability = self:GetParent():GetAbilityByIndex(i)
            if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
                local newCooldown = Ability:GetCooldownTimeRemaining() - 2
                Ability:EndCooldown()
                if newCooldown>=0 then
                    Ability:StartCooldown(newCooldown)
                end
            end
        end
        if not ability:IsNull() then
            ability:StartCooldown(time+3.7)
        end
        
        -- for i=0, 9 do
        --     local Ability = self:GetParent():GetItemInSlot(i)
        --     if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility() and not Ability:IsCooldownReady()  then
        --         local newCooldown = Ability:GetCooldownTimeRemaining() - 1
        --         Ability:EndCooldown()
        --         if newCooldown>=0 then
        --             Ability:StartCooldown(newCooldown)
        --         end
        --     end
        -- end
    
    
        local particle_cast = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_loadout.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end)
   
end


