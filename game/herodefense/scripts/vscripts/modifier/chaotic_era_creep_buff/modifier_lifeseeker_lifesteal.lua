
modifier_lifeseeker_lifesteal = advanced_modifier({})

function modifier_lifeseeker_lifesteal:IsHidden()return false end
function modifier_lifeseeker_lifesteal:IsDebuff()return false end
function modifier_lifeseeker_lifesteal:IsPurgable()return false end
function modifier_lifeseeker_lifesteal:IsPurgeException() 	return false end
function modifier_lifeseeker_lifesteal:RemoveOnDeath() return true end
function modifier_lifeseeker_lifesteal:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_lifeseeker_lifesteal:GetTexture() return self.texture end
-- function modifier_lifeseeker_lifesteal:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )

-- end
function modifier_lifeseeker_lifesteal:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus = GetChaticEraCreep_BuffSpecial(self,"value1")
    if IsServer() then

    end
end




-- function modifier_lifeseeker_lifesteal:PlayEffect(parent)
--     parent:EmitSound("hd_potion_arcane_boost_active")

--     local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
-- 	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
-- 	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
-- 	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
-- 	DestroyParticleByDelay(particle_cast_fx,2.5)
-- end


function modifier_lifeseeker_lifesteal:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end

function modifier_lifeseeker_lifesteal:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	return self.bonus
end



function modifier_lifeseeker_lifesteal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_lifeseeker_lifesteal:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

