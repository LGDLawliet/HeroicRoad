-- hd_potion_bloodlust_1
modifier_hd_potion_bloodlust_1 = advanced_modifier({})

function modifier_hd_potion_bloodlust_1:IsHidden()return false end
function modifier_hd_potion_bloodlust_1:IsDebuff()return false end
function modifier_hd_potion_bloodlust_1:IsPurgable()return false end
function modifier_hd_potion_bloodlust_1:IsPurgeException() 	return false end
function modifier_hd_potion_bloodlust_1:RemoveOnDeath() return true end
function modifier_hd_potion_bloodlust_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_bloodlust_1:GetTexture() return self.texture end
function modifier_hd_potion_bloodlust_1:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )

end
function modifier_hd_potion_bloodlust_1:OnCreated(keys)
    local gain = self:GetParent():GetPotionEffectIndex(1)
    self.texture = GetPotionTexture(self)
    self.value1 = GetPotionSpecial(self,"value1")*gain
    self.value2 = GetPotionSpecial(self,"value2")*gain
    self.value3 = GetPotionSpecial(self,"value3")*gain
    if IsServer() then

        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        parent:CalculateStatBonus(true)
        self:SetStackCount(math.min(self.value3,parent:GetMaxHealth()*self.value1*0.01))
        self:PlayEffect(parent)
        -- self:Destroy()
    end
end

function modifier_hd_potion_bloodlust_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end


function modifier_hd_potion_bloodlust_1:PlayEffect(parent)
    parent:EmitSound("hd_potion_bloodlust_1_active")

    local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle_cast_fx, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle_cast_fx, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)
end







function modifier_hd_potion_bloodlust_1:ADDeclareFunctions()
    return 
    {

		-- 临时生命值需要组合使用
		MODIFIER_SPECIAL_Temporary_Health_Points = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,


    }
end


function modifier_hd_potion_bloodlust_1:AdvancedGetModifierTemporaryHealth(keys)
	local stack = self:GetStackCount()
	-- 作为临时生命值加成效果时直接返回
	if keys.temporaryHealthLogic then
		return stack
	end
	if IsClient() then
		return 0
	end
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack

end

function modifier_hd_potion_bloodlust_1:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
    return self.value2
end


function modifier_hd_potion_bloodlust_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_bloodlust_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    -- elseif self._tooltip == 2 then
	-- 	return  self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
end



