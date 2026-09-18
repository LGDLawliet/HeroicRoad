-- hd_potion_hill_giant_strength_1
modifier_hd_potion_hill_giant_strength_1 = advanced_modifier({})

function modifier_hd_potion_hill_giant_strength_1:IsHidden()return false end
function modifier_hd_potion_hill_giant_strength_1:IsDebuff()return false end
function modifier_hd_potion_hill_giant_strength_1:IsPurgable()return false end
function modifier_hd_potion_hill_giant_strength_1:IsPurgeException() 	return false end
function modifier_hd_potion_hill_giant_strength_1:RemoveOnDeath() return true end
function modifier_hd_potion_hill_giant_strength_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_hill_giant_strength_1:GetTexture() return self.texture end
function modifier_hd_potion_hill_giant_strength_1:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_cyclopean_marauder/sven_cydclopean_gods_strength_small.vpcf", context )

end
function modifier_hd_potion_hill_giant_strength_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    self.value1 = GetPotionSpecial(self,"value1")*self:GetParent():GetPotionEffectIndex(1)
    -- self.value2 = GetPotionSpecial(self,"value2")
    -- self.value3 = GetPotionSpecial(self,"value3")
    if IsServer() then
        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)
        -- self:Destroy()
    end
end

function modifier_hd_potion_hill_giant_strength_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end


function modifier_hd_potion_hill_giant_strength_1:PlayEffect(parent)
    parent:EmitSound("hd_potion_hill_giant_strength_active")

    local particle_cast = "particles/econ/items/sven/sven_cyclopean_marauder/sven_cydclopean_gods_strength_small.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)
end



function modifier_hd_potion_hill_giant_strength_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

	
    }
end
function modifier_hd_potion_hill_giant_strength_1:Advanced_GetModifierBonusStats_Strength()
	return self.value1
end


function modifier_hd_potion_hill_giant_strength_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_hill_giant_strength_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
    -- elseif self._tooltip == 2 then
	-- 	return  self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
end



