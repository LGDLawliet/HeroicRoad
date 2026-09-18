--战斗场地的传送门
LinkLuaModifier( "modifier_GAME_Portal1", "creeps_spell/GAME_Portal1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_GAME_Portal1_effect", "creeps_spell/GAME_Portal1", LUA_MODIFIER_MOTION_NONE )
GAME_Portal1 = class({})

function GAME_Portal1:GetIntrinsicModifierName()
	return "modifier_GAME_Portal1"
end

-----------------------------------------------------------------------------------------

modifier_GAME_Portal1 = class({})

function modifier_GAME_Portal1:IsHidden()   return true end
function modifier_GAME_Portal1:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
    state[MODIFIER_STATE_UNSELECTABLE] = true
	return state
end

function modifier_GAME_Portal1:IsAura()   return true end
function modifier_GAME_Portal1:GetAuraRadius()
	if IsServer() then
        return self:GetParent():IsAlive() and self.radius or 0
    end
end
function modifier_GAME_Portal1:OnCreated()
    if IsServer() then
        self.radius = 0
    end
end
function modifier_GAME_Portal1:GetAuraSearchFlags()   return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_GAME_Portal1:GetAuraSearchTeam()   return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_GAME_Portal1:GetAuraSearchType()    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_GAME_Portal1:GetModifierAura()   return "modifier_GAME_Portal1_effect" end
function modifier_GAME_Portal1:OnDestroy()
    if IsServer() then
        if self.pfx then
            ParticleManager:DestroyParticle(self.pfx, false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            self.pfx = nil
        end
    end
end
function modifier_GAME_Portal1:OnGameStateChanged(key)
    if key==1 then
        self.radius = 0
        if self.pfx then
            ParticleManager:DestroyParticle(self.pfx, false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            self.pfx = nil
            self:StartIntervalThink(-1)
        end
    end
    if key==2 then
        local pos = self:GetParent():GetAbsOrigin()
        if not self.pfx then
            self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/astral_step_portal_selected_game_portal.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(self.pfx, 0, pos)
            ParticleManager:SetParticleControl(self.pfx, 1, Vector(pos.x,pos.y,pos.z+280))
            ParticleManager:SetParticleControl(self.pfx, 3, pos)
            local pos2 = _G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector + RandomVector(300)
            local dir = CalculateDirection(pos, pos2)

            ParticleManager:SetParticleControlForward(self.pfx, 1, dir)  --方向
            ParticleManager:SetParticleControlForward(self.pfx, 2, dir)  --方向
            self:StartIntervalThink(2)
 

        end

        self.radius = 100
    end

end

function modifier_GAME_Portal1:OnIntervalThink()
    local pos = Vector(-5950,5443,896)
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            local dis = CalculateDistance(hero,pos)
            if dis>=4000 then
                local pos2 = _G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector + RandomVector(300)
                FindClearSpaceForUnit( hero, pos2, true )
            end
        end
    end
end

modifier_GAME_Portal1_effect = class({})

function modifier_GAME_Portal1_effect:IsHidden()    return true end
function modifier_GAME_Portal1_effect:GetAttributes()    return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_GAME_Portal1_effect:OnCreated(kv)
    if IsServer() then
        if self:GetParent()==self:GetCaster() or self:GetParent():IsInvulnerable() then
            return
        end


        local pos = _G.GAME_START_POINT[1][RandomInt(1, #_G.GAME_START_POINT[1])].Vector + RandomVector(300)
        FindClearSpaceForUnit( self:GetParent(), pos, true )
        
    end
end


