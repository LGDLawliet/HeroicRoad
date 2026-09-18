-- hd_potion_colossus_1
modifier_hd_potion_colossus_1 = advanced_modifier({})

function modifier_hd_potion_colossus_1:IsHidden()return false end
function modifier_hd_potion_colossus_1:IsDebuff()return false end
function modifier_hd_potion_colossus_1:IsPurgable()return false end
function modifier_hd_potion_colossus_1:IsPurgeException() 	return false end
function modifier_hd_potion_colossus_1:RemoveOnDeath() return true end
function modifier_hd_potion_colossus_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_colossus_1:GetTexture() return self.texture end
function modifier_hd_potion_colossus_1:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_enlarge/hit_effect/effect.vpcf", context )

end
function modifier_hd_potion_colossus_1:OnCreated(keys)
    local gain = self:GetParent():GetPotionEffectIndex(1)
    self.texture = GetPotionTexture(self)
    self.value1 = GetPotionSpecial(self,"value1")*gain
    self.value2 = GetPotionSpecial(self,"value2")*gain
    self.value3 = GetPotionSpecial(self,"value3")*gain
    if IsServer() then
        local duration = GetPotionDuration(self)
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)
        -- self:Destroy()
    end
end

function modifier_hd_potion_colossus_1:OnRefresh(keys)
    if IsServer() then
        local parent = self:GetParent()
        self:PlayEffect(parent)
    end
end


function modifier_hd_potion_colossus_1:PlayEffect(parent)
    parent:EmitSound("chaotic_enlarge_target")

    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_enlarge/hit_effect/effect.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)
end



function modifier_hd_potion_colossus_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	    advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, --攻击力百分比  （基于基础攻击力）
    
    }
end


function modifier_hd_potion_colossus_1:Advanced_GetModifierPreAttack_BonusDamage(keys)
    return self.value1
end
function modifier_hd_potion_colossus_1:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
    return self.value2
end


function modifier_hd_potion_colossus_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_hd_potion_colossus_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
    elseif self._tooltip == 2 then
		return  self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
end



function modifier_hd_potion_colossus_1:GetModifierModelScale( params )
	return self.value3
end

