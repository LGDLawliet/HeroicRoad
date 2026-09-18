heroTalent_npc_dota_hero_storm_spirit_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_storm_spirit_2", "heroTalent/heroTalent_npc_dota_hero_storm_spirit_2", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_storm_spirit_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_storm_spirit_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_storm_spirit_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_storm_spirit_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_storm_spirit_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_storm_spirit_2" end

function heroTalent_npc_dota_hero_storm_spirit_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", context )

end

modifier_heroTalent_npc_dota_hero_storm_spirit_2 = class({})

function modifier_heroTalent_npc_dota_hero_storm_spirit_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:RemoveOnDeath() return false end
	
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_2:GetModifierExtraManaPercentage() return self.bonus_mana end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:OnCreated(keys)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.limit = self:GetAbility():GetSpecialValueFor("limit")

    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack1",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)

        self.maxMana = self:GetParent():GetMaxMana()*self.limit*0.01
        self:StartIntervalThink(0.5)     
    end
end
function modifier_heroTalent_npc_dota_hero_storm_spirit_2:OnIntervalThink()
    self.maxMana = self:GetParent():GetMaxMana()*self.limit*0.01
    if self:GetParent():GetManaPercent()>self.limit then
        self:GetParent():SetMana(self.maxMana)
    end
   
end
