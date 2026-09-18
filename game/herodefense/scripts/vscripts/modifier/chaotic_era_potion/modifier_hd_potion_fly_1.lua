
-- hd_potion_fly_1
modifier_hd_potion_fly_1 = advanced_modifier({})

function modifier_hd_potion_fly_1:IsHidden()return false end
function modifier_hd_potion_fly_1:IsDebuff()return false end
function modifier_hd_potion_fly_1:IsPurgable()return false end
function modifier_hd_potion_fly_1:IsPurgeException() 	return false end
function modifier_hd_potion_fly_1:RemoveOnDeath() return true end
function modifier_hd_potion_fly_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_fly_1:GetTexture() return self.texture end
-- function modifier_hd_potion_fly_1:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_permanent_vitality/effect_active/effect.vpcf", context )

-- end
function modifier_hd_potion_fly_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    -- self.value1 = GetPotionSpecial(self,"value1")
    -- self.value2 = GetPotionSpecial(self,"value2")
    -- self.value3 = GetPotionSpecial(self,"value3")
    if IsServer() then
        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)

    end
end
    local gain = self:GetParent():GetPotionEffectIndex(1)
function modifier_hd_potion_fly_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end


function modifier_hd_potion_fly_1:PlayEffect(parent)
    parent:EmitSound("hd_potion_fly_active")

    -- local particle_cast = "particles/rebuild/potion/hd_potion_permanent_vitality/effect_active/effect.vpcf"
	-- local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	-- -- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
    -- ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(255,20,20))
    -- ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
	-- DestroyParticleByDelay(particle_cast_fx,3)
end



function modifier_hd_potion_fly_1:ADDeclareFunctions()
    return 
    {
        -- advanced_MODIFIER_PROPERTY_Flying,
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_hd_potion_fly_1:Advanced_GetModifier_FlyingPathing()	
	return 1
end



function modifier_hd_potion_fly_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

    return funcs
end

function modifier_hd_potion_fly_1:GetVisualZDelta( params )
	return 150
end

