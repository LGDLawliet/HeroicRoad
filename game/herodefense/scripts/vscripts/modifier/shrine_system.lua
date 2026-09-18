if ShrineSystem == nil then
    ShrineSystem = class({})
end

print("ACT4已加载")

function ShrineSystem:init(bReload)
    self:ScheduleNextSpawn()
	if not bReload then

    end
end

function ShrineSystem:ScheduleNextSpawn()
    local spawn_interval = 40

    Timers:CreateTimer(spawn_interval, function()
        self:SpawnShrine()
        self:ScheduleNextSpawn() -- 循环调用
        return nil
    end)
end

function ShrineSystem:SpawnShrine()

    local pos = (Vector(-300,-1053,896)) --房间中心
    local distance = RandomFloat(500, 2500)
    local angle = RandomFloat(0, 2 * math.pi)
    local offset = Vector(math.cos(angle), math.sin(angle), 0) * distance
    local spawn_pos = pos + offset


    local hero_pos = self:ChoseSpawnPos_Hero()
    if hero_pos then
        spawn_pos = hero_pos
    end

    local shrine_type = RandomInt(1, 4)
    --1紫猫2火猫3土猫4蓝猫
    spawn_pos = GetGroundPosition(spawn_pos, nil)
    local shrine = CreateUnitByName("npc_shrine_"..shrine_type, spawn_pos, true, nil, nil, DOTA_TEAM_GOODGUYS)
    
    shrine:AddNewModifier(shrine, nil, "modifier_shrine_logic", {
        duration = 120 , 
        type = shrine_type 
    })
end

function ShrineSystem:ChoseSpawnPos_Hero()
    if not Game_State:IsInBattle() then return end
    local heroes = GetAllRealHeroes()
    local valid_heroes = {}
    for _, hero in pairs(heroes) do
        if hero:IsRealHero() and hero:IsAlive() then
            table.insert(valid_heroes, hero)
        end
    end

    if #valid_heroes ~= 0 then
        local random_hero = valid_heroes[RandomInt(1, #valid_heroes)]
        local spawn_pos = self:TryCreatePos(random_hero)

        -- 桥坐标cy - 如果坐标在此范围内，一直尝试直到不在范围内
        while spawn_pos.y < -3500 and (spawn_pos.x > 350 and spawn_pos.x < 2800) do
            spawn_pos = self:TryCreatePos(random_hero)
        end

        return spawn_pos
    end

    return nil
end


function ShrineSystem:TryCreatePos(hero)
    local base_pos = hero:GetAbsOrigin()

    local distance = RandomFloat(600, 1400)
    local angle = RandomFloat(0, 2 * math.pi)
    local offset = Vector(math.cos(angle), math.sin(angle), 0) * distance
    local spawn_pos = base_pos + offset

    return spawn_pos
end
