heroTalent_npc_dota_hero_invoker_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_invoker_3", "heroTalent/heroTalent_npc_dota_hero_invoker_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_invoker_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_invoker_3"
end



modifier_heroTalent_npc_dota_hero_invoker_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_invoker_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_invoker_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_invoker_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_invoker_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_invoker_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_invoker_3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.wave_require = self:GetAbility():GetSpecialValueFor("wave_require")
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb1", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb2", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_orb3", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )

	end

end


function modifier_heroTalent_npc_dota_hero_invoker_3:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ChaoticEraRoundChange = {},
    }
end


function modifier_heroTalent_npc_dota_hero_invoker_3:OnChaoticEraRoundChange(keys)
	if keys.round>=self.wave_require then
        if not self.checkingAbility then
			local parent = self:GetParent()
			local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
			if not parent:IsAlive() then
                return
            end
            if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
				return
			end
			self.checkingAbility = true
			if parent:HasModifier("chaotic_wish") then
				return
			end
			chaotic_era:LearnChaoticEraSpell(parent,"chaotic_wish")
		end
    end
end
