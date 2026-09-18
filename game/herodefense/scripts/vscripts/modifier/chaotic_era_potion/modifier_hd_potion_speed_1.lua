-- hd_potion_speed_1
LinkLuaModifier("modifier_chaotic_haste", "chaotic_spell/class_3/chaotic_haste", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_haste_debuff", "chaotic_spell/class_3/chaotic_haste", LUA_MODIFIER_MOTION_NONE)

modifier_hd_potion_speed_1 = advanced_modifier({})

function modifier_hd_potion_speed_1:IsHidden()return false end
function modifier_hd_potion_speed_1:IsDebuff()return false end
function modifier_hd_potion_speed_1:IsPurgable()return false end
function modifier_hd_potion_speed_1:IsPurgeException() 	return false end
function modifier_hd_potion_speed_1:RemoveOnDeath() return true end
function modifier_hd_potion_speed_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_speed_1:GetTexture() return self.texture end

function modifier_hd_potion_speed_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    -- self.value1 = GetPotionSpecial(self,"value1")
    -- self.value2 = GetPotionSpecial(self,"value2")
    -- self.value3 = GetPotionSpecial(self,"value3")
    if IsServer() then
        local duration = GetPotionDuration(self)
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_chaotic_haste", {duration = duration})
        self:PlayEffect(parent)

        self:Destroy()
    end
end
function modifier_hd_potion_speed_1:PlayEffect(parent)
    EmitSoundOn("chaotic_haste_target", parent)   
    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_haste/effect_cast/effect_end.vpcf"
    local caster = self:GetCaster()
    local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
    -- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
    DestroyParticleByDelay(particle_cast_fx,2.5)
end





