--左上角的传送门
LinkLuaModifier( "modifier_GAME_Portal2", "creeps_spell/GAME_Portal2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_GAME_Portal2_effect", "creeps_spell/GAME_Portal2", LUA_MODIFIER_MOTION_NONE )
GAME_Portal2 = class({})

function GAME_Portal2:GetIntrinsicModifierName()
	return "modifier_GAME_Portal2"
end

-----------------------------------------------------------------------------------------

modifier_GAME_Portal2 = class({})

function modifier_GAME_Portal2:IsHidden()   return true end
function modifier_GAME_Portal2:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
    state[MODIFIER_STATE_UNSELECTABLE] = true
	return state
end

function modifier_GAME_Portal2:IsAura()   return true end
function modifier_GAME_Portal2:GetAuraRadius()
	if IsServer() then
        return self:GetParent():IsAlive() and self.radius or 0
    end
end
function modifier_GAME_Portal2:OnCreated()
    if IsServer() then
        self.radius = 6000
    end
end
function modifier_GAME_Portal2:GetAuraSearchFlags()   return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_GAME_Portal2:GetAuraSearchTeam()   return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_GAME_Portal2:GetAuraSearchType()    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_GAME_Portal2:GetModifierAura()   return "modifier_GAME_Portal2_effect" end
function modifier_GAME_Portal2:OnDestroy()
    if IsServer() then
        if self.pfx then
            ParticleManager:DestroyParticle(self.pfx, false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            self.pfx = nil
        end
    end
end

function modifier_GAME_Portal2:OnGameStateChanged(key)
    if key==1 then
        self.radius = 0
        if self.pfx then
            ParticleManager:DestroyParticle(self.pfx, false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            self.pfx = nil
        end
    end
    if key==2 then
        local pos = self:GetParent():GetAbsOrigin()
        if not self.pfx then
            self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/astral_step_portal_selected_game_portal.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(self.pfx, 0, pos)
            ParticleManager:SetParticleControl(self.pfx, 1, Vector(pos.x,pos.y,pos.z+280))
            ParticleManager:SetParticleControl(self.pfx, 3, pos)
            local dir = CalculateDirection(pos, Vector(-300,-1053,896))
            ParticleManager:SetParticleControlForward(self.pfx, 1, dir)  --方向
            ParticleManager:SetParticleControlForward(self.pfx, 2, dir)  --方向

        end

        self.radius = 6000
    end

end



modifier_GAME_Portal2_effect = class({})

function modifier_GAME_Portal2_effect:IsHidden()    return true end
function modifier_GAME_Portal2_effect:GetAttributes()    return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_GAME_Portal2_effect:OnCreated(kv)
    if IsServer() then
        if self:GetParent()==self:GetCaster() or self:GetParent():IsInvulnerable() then
            return
        end
        if not self:GetParent().hdIsSummoned then
            FindClearSpaceForUnit( self:GetParent(), Vector(-300,-1053,896), true )
        end
       
        self:StartIntervalThink(1)

    end
end


function modifier_GAME_Portal2_effect:OnIntervalThink()
    
    if self:GetParent().hdIsSummoned then
        -- self:GetParent():TrueKill()
        TrueKill(self:GetParent(),self:GetParent(),self:GetAbility())
    else
        FindClearSpaceForUnit( self:GetParent(), Vector(-300,-1053,896), true )
    end
end