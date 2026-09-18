
modifier_hd_potion_healing_3 = advanced_modifier({})

function modifier_hd_potion_healing_3:IsHidden()return true end
function modifier_hd_potion_healing_3:IsDebuff()return false end
function modifier_hd_potion_healing_3:IsPurgable()return false end
function modifier_hd_potion_healing_3:IsPurgeException() 	return false end
function modifier_hd_potion_healing_3:RemoveOnDeath() return false end
function modifier_hd_potion_healing_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_hd_potion_healing_3:GetTexture() return "modifier_illusion" end
function modifier_hd_potion_healing_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_healing/effect_use/effect.vpcf", context )

end
function modifier_hd_potion_healing_3:OnCreated(keys)
    if IsServer() then
       local healing = GetPotionSpecial(self,"value1")*self:GetParent():GetPotionEffectIndex(1)
       local parent = self:GetParent()
       local fhealing =  HealWithGain(healing,parent,parent,nil)
       SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent, fhealing, nil) 
       self:PlayEffect(parent)
       self:Destroy()
    end
end

function modifier_hd_potion_healing_3:PlayEffect(parent)
    parent:EmitSound("DOTA_Item.HealingSalve.Activate")

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_healing/effect_use/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end


