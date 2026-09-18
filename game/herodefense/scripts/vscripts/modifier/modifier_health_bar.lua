modifier_health_bar = modifier_health_bar or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_health_bar:IsHidden()return true end
function modifier_health_bar:IsDebuff()return false end
function modifier_health_bar:IsStunDebuff()return false end
function modifier_health_bar:IsPurgable()return false end
function modifier_health_bar:IsPurgeException() 	return false end
function modifier_health_bar:RemoveOnDeath() return false end
function modifier_health_bar:OnCreated(keys)
    if IsClient() then
        print("client create")
    end
    if IsServer() then
        print("创建血条")
        self.isShowHpBar = false
        self.health_bar_type = keys.health_bar_type
        self:StartIntervalThink(0.5)

    end
end
function modifier_health_bar:OnDestroy()
    if IsClient() then
        print("client OnDestroy")
    end
end
function modifier_health_bar:OnIntervalThink()

    if self.isShowHpBar then
        return
    end
    local parent = self:GetParent()
    if IsEntityValidAndAlive(parent) == false then
        return
    end
    player:EachPlayer(function(n, playerID)
        local Targetplayer = PlayerResource:GetPlayer(playerID)
        if Targetplayer then
            local hero = Targetplayer:GetAssignedHero()
            if hero then
                if hero:CanEntityBeSeenByMyTeam(parent) then
                    CustomGameEventManager:Send_ServerToAllClients(
                        "elite_health_bar_create",
                        {
                            enemyIndex = parent:entindex()
                        }
                    )
                    self.isShowHpBar = true
                    return true
                end
            end
        end
       
    end)
   
end