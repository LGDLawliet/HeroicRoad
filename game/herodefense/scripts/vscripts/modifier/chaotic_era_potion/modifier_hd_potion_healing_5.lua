LinkLuaModifier("modifier_hd_potion_healing_5_bonus", "modifier/chaotic_era_potion/modifier_hd_potion_healing_5", LUA_MODIFIER_MOTION_NONE)


modifier_hd_potion_healing_5 = advanced_modifier({})

function modifier_hd_potion_healing_5:IsHidden()return true end
function modifier_hd_potion_healing_5:IsDebuff()return false end
function modifier_hd_potion_healing_5:IsPurgable()return false end
function modifier_hd_potion_healing_5:IsPurgeException() 	return false end
function modifier_hd_potion_healing_5:RemoveOnDeath() return false end
function modifier_hd_potion_healing_5:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_hd_potion_healing_5:GetTexture() return "enchantress_natures_attendants" end
function modifier_hd_potion_healing_5:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_healing/effect_use/effect.vpcf", context )

end
function modifier_hd_potion_healing_5:OnCreated(keys)
    if IsServer() then
       local healing = GetPotionSpecial(self,"value1")*self:GetParent():GetPotionEffectIndex(1)
       local parent = self:GetParent()
       local fhealing =  HealWithGain(healing,parent,parent,nil)
       SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent, fhealing, nil) 
       self:PlayEffect(parent)
       local duration = GetPotionDuration(self)
       parent:AddNewModifier(parent, nil, "modifier_hd_potion_healing_5_bonus", {duration = duration})
       self:Destroy()
    end
end

function modifier_hd_potion_healing_5:PlayEffect(parent)
    parent:EmitSound("DOTA_Item.HealingSalve.Activate")

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_healing/effect_use/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end



modifier_hd_potion_healing_5_bonus = advanced_modifier({})

function modifier_hd_potion_healing_5_bonus:IsHidden()return false end
function modifier_hd_potion_healing_5_bonus:IsDebuff()return false end
function modifier_hd_potion_healing_5_bonus:IsPurgable()return false end
function modifier_hd_potion_healing_5_bonus:IsPurgeException() 	return false end
function modifier_hd_potion_healing_5_bonus:GetTexture() return self.texture end
function modifier_hd_potion_healing_5_bonus:OnCreated(keys)
    self.texture = GetPotionTexture("hd_potion_healing_5")
    self.bonus = GetPotionSpecial("hd_potion_healing_5","value2")
end




function modifier_hd_potion_healing_5_bonus:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE, --生命恢复增强 百分比
    }
end
function modifier_hd_potion_healing_5_bonus:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.bonus
end

function modifier_hd_potion_healing_5_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_healing_5_bonus:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	end
end

