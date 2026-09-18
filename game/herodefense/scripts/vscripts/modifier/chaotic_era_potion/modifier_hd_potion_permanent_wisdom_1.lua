LinkLuaModifier("modifier_hd_potion_permanent_wisdom_1_buff", "modifier/chaotic_era_potion/modifier_hd_potion_permanent_wisdom_1", LUA_MODIFIER_MOTION_NONE)

-- hd_potion_permanent_wisdom_1
modifier_hd_potion_permanent_wisdom_1 = advanced_modifier({})

function modifier_hd_potion_permanent_wisdom_1:IsHidden()return false end
function modifier_hd_potion_permanent_wisdom_1:IsDebuff()return false end
function modifier_hd_potion_permanent_wisdom_1:IsPurgable()return false end
function modifier_hd_potion_permanent_wisdom_1:IsPurgeException() 	return false end
function modifier_hd_potion_permanent_wisdom_1:RemoveOnDeath() return true end
function modifier_hd_potion_permanent_wisdom_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_permanent_wisdom_1:GetTexture() return self.texture end
function modifier_hd_potion_permanent_wisdom_1:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_permanent_vitality/effect_active/effect.vpcf", context )

end
function modifier_hd_potion_permanent_wisdom_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    -- self.value1 = GetPotionSpecial(self,"value1")
    -- self.value2 = GetPotionSpecial(self,"value2")
    -- self.value3 = GetPotionSpecial(self,"value3")
    if IsServer() then
        local gain = self:GetParent():GetPotionEffectIndex(1)
        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:SetStackCount(math.min(parent:GetIntellect(false)* GetPotionSpecial(self,"value1")*0.01*gain, GetPotionSpecial(self,"value2")))
        self:PlayEffect(parent)
        local value3 = GetPotionSpecial(self,"value3")
        parent:AddNewModifier(parent, nil, "modifier_hd_potion_permanent_wisdom_1_buff", {stack = value3*gain})
        -- self:Destroy()
    end
end

function modifier_hd_potion_permanent_wisdom_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end


function modifier_hd_potion_permanent_wisdom_1:PlayEffect(parent)
    parent:EmitSound("general_potion_active")

    local particle_cast = "particles/rebuild/potion/hd_potion_permanent_vitality/effect_active/effect.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
    ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(18,219,255))
    ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
	DestroyParticleByDelay(particle_cast_fx,3)
end



function modifier_hd_potion_permanent_wisdom_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	
    }
end
function modifier_hd_potion_permanent_wisdom_1:Advanced_GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end


function modifier_hd_potion_permanent_wisdom_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_permanent_wisdom_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Intellect()
	end
end






modifier_hd_potion_permanent_wisdom_1_buff = advanced_modifier({})

function modifier_hd_potion_permanent_wisdom_1_buff:IsHidden()return false end
function modifier_hd_potion_permanent_wisdom_1_buff:IsDebuff()return false end
function modifier_hd_potion_permanent_wisdom_1_buff:IsPurgable()return false end
function modifier_hd_potion_permanent_wisdom_1_buff:IsPurgeException() 	return false end
function modifier_hd_potion_permanent_wisdom_1_buff:RemoveOnDeath() return false end
function modifier_hd_potion_permanent_wisdom_1_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_permanent_wisdom_1_buff:GetTexture() return self.texture end

function modifier_hd_potion_permanent_wisdom_1_buff:OnCreated(keys)
    self.texture = GetPotionTexture("hd_potion_permanent_wisdom_1")
    if IsServer() then
       self:SetStackCount(self:GetStackCount()+keys.stack)
    end
end

function modifier_hd_potion_permanent_wisdom_1_buff:OnRefresh(keys)
    self:OnCreated(keys)
end



function modifier_hd_potion_permanent_wisdom_1_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	
    }
end
function modifier_hd_potion_permanent_wisdom_1_buff:Advanced_GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end



function modifier_hd_potion_permanent_wisdom_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_permanent_wisdom_1_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Intellect()
	end
end
