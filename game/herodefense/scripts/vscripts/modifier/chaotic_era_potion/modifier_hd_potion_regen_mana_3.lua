
modifier_hd_potion_regen_mana_3 = advanced_modifier({})

function modifier_hd_potion_regen_mana_3:IsHidden()return true end
function modifier_hd_potion_regen_mana_3:IsDebuff()return false end
function modifier_hd_potion_regen_mana_3:IsPurgable()return false end
function modifier_hd_potion_regen_mana_3:IsPurgeException() 	return false end
function modifier_hd_potion_regen_mana_3:RemoveOnDeath() return false end
function modifier_hd_potion_regen_mana_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_hd_potion_regen_mana_3:GetTexture() return "modifier_illusion" end
function modifier_hd_potion_regen_mana_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_regen_mana/effect_use/effect.vpcf", context )

end
function modifier_hd_potion_regen_mana_3:OnCreated(keys)
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
        self:Destroy()
    end
end

function modifier_hd_potion_regen_mana_3:PlayEffect(parent)
    parent:EmitSound("DOTA_Item.ClarityPotion.Activate")

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_regen_mana/effect_use/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end


