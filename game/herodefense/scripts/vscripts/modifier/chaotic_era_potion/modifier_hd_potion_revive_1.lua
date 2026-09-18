-- hd_potion_revive_1










modifier_hd_potion_revive_1 = advanced_modifier({})

function modifier_hd_potion_revive_1:IsHidden()return false end
function modifier_hd_potion_revive_1:IsDebuff()return false end
function modifier_hd_potion_revive_1:IsPurgable()return false end
function modifier_hd_potion_revive_1:IsPurgeException() 	return false end
function modifier_hd_potion_revive_1:RemoveOnDeath() return false end
function modifier_hd_potion_revive_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hd_potion_revive_1:GetTexture() return self.texture end

function modifier_hd_potion_revive_1:Precache( context )
	PrecacheResource( "particle", "particles/prime/hero_spawn_hero_level_6.vpcf", context )

end




function modifier_hd_potion_revive_1:OnCreated(keys)
    self.texture = GetPotionTexture(self)
    if IsServer() then
        self.respawn_delay = GetPotionSpecial(self,"value1")
        local duration = GetPotionDuration(self)
        
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)
        local stack = GetPotionSpecial(self,"value2")
        self:SetStackCount(self:GetStackCount()+stack)
    end
end

function modifier_hd_potion_revive_1:OnRefresh(keys)
    if IsServer() then
        local duration = GetPotionDuration(self)
        
        self:SetDuration(duration, true)
        local parent = self:GetParent()
        self:PlayEffect(parent)
        local stack = GetPotionSpecial(self,"value2")
        self:SetStackCount(self:GetStackCount()+stack)
    end
end





function modifier_hd_potion_revive_1:PlayEffect(parent)
    EmitSoundOn("hd_potion_revive_active", parent)   
    local particle_cast = "particles/prime/hero_spawn_hero_level_6.vpcf"
    local caster = self:GetCaster()
    local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
    -- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
    DestroyParticleByDelay(particle_cast_fx,9.5)
end



function modifier_hd_potion_revive_1:ADDeclareFunctions()
    return 
    {
		MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
    }
end


function modifier_hd_potion_revive_1:AdvancedGetModifierReincarnate(keys)
	if self:GetStackCount()>=1 then
		local data = {
			modifier = self,
			time = self.respawn_delay,
			priority = 5,
			invulnerable_time = 2,
			
	
		}
		return data
	end

	return nil
	
end

function modifier_hd_potion_revive_1:OnReincarnateTrigger(keys)
	self:DecrementStackCount()
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
    end
end
