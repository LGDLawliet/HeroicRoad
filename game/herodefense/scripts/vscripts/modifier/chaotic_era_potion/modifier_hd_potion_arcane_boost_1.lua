
modifier_hd_potion_arcane_boost_1 = advanced_modifier({})

function modifier_hd_potion_arcane_boost_1:IsHidden()return false end
function modifier_hd_potion_arcane_boost_1:IsDebuff()return false end
function modifier_hd_potion_arcane_boost_1:IsPurgable()return false end
function modifier_hd_potion_arcane_boost_1:IsPurgeException() 	return false end
function modifier_hd_potion_arcane_boost_1:RemoveOnDeath() return true end
function modifier_hd_potion_arcane_boost_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_arcane_boost_1:GetTexture() return self.texture end
function modifier_hd_potion_arcane_boost_1:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )

end
function modifier_hd_potion_arcane_boost_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    self.bonus = GetPotionSpecial(self,"value1")* self:GetParent():GetPotionEffectIndex(1)
    if IsServer() then
        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)
        -- self:Destroy()
    end
end

function modifier_hd_potion_arcane_boost_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end



function modifier_hd_potion_arcane_boost_1:PlayEffect(parent)
    parent:EmitSound("hd_potion_arcane_boost_active")

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end



function modifier_hd_potion_arcane_boost_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end


function modifier_hd_potion_arcane_boost_1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if IsServer() then
        if keys.damage_type==DAMAGE_TYPE_MAGICAL  then
            return self.bonus
        end
    end
	return 0
end

function modifier_hd_potion_arcane_boost_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_arcane_boost_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

