LinkLuaModifier("modifier_hd_potion_regen_mana_4_bonus", "modifier/chaotic_era_potion/modifier_hd_potion_regen_mana_4", LUA_MODIFIER_MOTION_NONE)

modifier_hd_potion_regen_mana_4 = advanced_modifier({})

function modifier_hd_potion_regen_mana_4:IsHidden()return true end
function modifier_hd_potion_regen_mana_4:IsDebuff()return false end
function modifier_hd_potion_regen_mana_4:IsPurgable()return false end
function modifier_hd_potion_regen_mana_4:IsPurgeException() 	return false end
function modifier_hd_potion_regen_mana_4:RemoveOnDeath() return false end
function modifier_hd_potion_regen_mana_4:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_hd_potion_regen_mana_4:GetTexture() return "modifier_illusion" end
function modifier_hd_potion_regen_mana_4:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_regen_mana/effect_use/effect.vpcf", context )

end
function modifier_hd_potion_regen_mana_4:OnCreated(keys)
    if IsServer() then
        local value1 = GetPotionSpecial(self,"value1")*self:GetParent():GetPotionEffectIndex(1)
        local parent = self:GetParent()
        local keys = {
            caster = parent,
            target = parent,
            value = value1,
        }
        local realValue = GiveMana(keys)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD ,parent, realValue, nil) 
        self:PlayEffect(parent)

        local duration = GetPotionDuration(self)
        parent:AddNewModifier(parent, nil, "modifier_hd_potion_regen_mana_4_bonus", {duration = duration})
        self:Destroy()
    end
end

function modifier_hd_potion_regen_mana_4:PlayEffect(parent)
    parent:EmitSound("DOTA_Item.ClarityPotion.Activate")

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_regen_mana/effect_use/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end





modifier_hd_potion_regen_mana_4_bonus = advanced_modifier({})

function modifier_hd_potion_regen_mana_4_bonus:IsHidden()return false end
function modifier_hd_potion_regen_mana_4_bonus:IsDebuff()return false end
function modifier_hd_potion_regen_mana_4_bonus:IsPurgable()return false end
function modifier_hd_potion_regen_mana_4_bonus:IsPurgeException() 	return false end

function modifier_hd_potion_regen_mana_4_bonus:GetTexture() return self.texture end

function modifier_hd_potion_regen_mana_4_bonus:OnCreated(keys)
    self.texture = GetPotionTexture("hd_potion_regen_mana_4")
    self.bonus = GetPotionSpecial("hd_potion_regen_mana_4","value2")
end




function modifier_hd_potion_regen_mana_4_bonus:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE, --生命恢复增强 百分比
    }
end
function modifier_hd_potion_regen_mana_4_bonus:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.bonus
end

function modifier_hd_potion_regen_mana_4_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_hd_potion_regen_mana_4_bonus:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantManaRegenAmpPercentage()
	end
end

