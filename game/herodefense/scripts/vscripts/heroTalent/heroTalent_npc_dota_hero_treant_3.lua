heroTalent_npc_dota_hero_treant_3 = class({})

LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_3", "heroTalent/heroTalent_npc_dota_hero_treant_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_3_effect", "heroTalent/heroTalent_npc_dota_hero_treant_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_treant_3:Precache( context )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/treant_3/golden_seed.vpcf", context )
end

function heroTalent_npc_dota_hero_treant_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_treant_3"
end

modifier_heroTalent_npc_dota_hero_treant_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_treant_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_treant_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_treant_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_treant_3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.1)	
	end
end

function modifier_heroTalent_npc_dota_hero_treant_3:OnIntervalThink()
    if self:GetAbility():IsCooldownReady() then
        self:GoldenTree()
        self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("cooldown"))
	end
end

function modifier_heroTalent_npc_dota_hero_treant_3:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
    }
end

function modifier_heroTalent_npc_dota_hero_treant_3:AdvancedOnDeathAgain(keys)
    local caster = self:GetCaster()
    self.duration = self:GetAbility():GetSpecialValueFor("duration")*1.5
	caster:EmitSound("Hero_Treant.LeechSeed.Tick")
	-- local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 100000, 
    -- DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
	local units = GetAllRealHeroes()
	for _, unit in pairs(units) do
		if unit:IsAlive() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/treant_3/golden_seed.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
            unit:Purge(false, true, false, true, true)
         	unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_treant_3_effect", {duration = self.duration})
		end
	end
end

function modifier_heroTalent_npc_dota_hero_treant_3:OnDeath(keys)
    if not IsServer() then
        return
    end
    self:GoldenTree()
end

function modifier_heroTalent_npc_dota_hero_treant_3:GoldenTree()
	local caster = self:GetCaster()
     self.duration = self:GetAbility():GetSpecialValueFor("duration")

	if not caster:IsAlive() then
		self.duration = 1.5*self.duration
	end

	caster:EmitSound("Hero_Treant.LeechSeed.Tick")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 100000, 
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

	for _, unit in pairs(units) do
		if unit:IsAlive() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/treant_3/golden_seed.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
            unit:Purge(false, true, false, true, true)
         unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_treant_3_effect", {duration = self.duration})
		end
	end
end
------------------------------
modifier_heroTalent_npc_dota_hero_treant_3_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_3_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_heroTalent_npc_dota_hero_treant_3_effect:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_treant_3_effect:OnCreated()
    self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
	
end

function modifier_heroTalent_npc_dota_hero_treant_3_effect:OnRefresh()
    self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_heroTalent_npc_dota_hero_treant_3_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_treant_3_effect:AdvancedGetModifierConstantHealthRegenPercentage()
    return self.hp_regen
end

function modifier_heroTalent_npc_dota_hero_treant_3_effect:CheckState()
    return{
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end
