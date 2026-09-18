
weather_controler = weather_controler or  class( { })
print("天气系统已加载")
-- require('internal/timers')
function weather_controler:init(bReload)
	if not bReload then
        self.current_weather_list = {}
        self.current_global_weather = nil
        
    end
end



WeatherMap = {
    Default = {},
    Ash = {
        particle = "particles/rain_fx/econ_weather_ash.vpcf",
        offset = Vector(0,0,0),
    },
    Aurora = {
        particle = "particles/rain_fx/econ_weather_aurora.vpcf",
        offset = Vector(0,0,0),
    },
    Spring = {
        particle = "particles/rain_fx/econ_weather_spring.vpcf",
        offset = Vector(0,0,0),
        forward = Vector(0,0,0),
    },
    Summer = {
        particle = "particles/rain_fx/econ_weather_summer.vpcf",
        offset = Vector(0,0,0),
    },
    Harvest = {
        particle = "particles/rain_fx/econ_weather_harvest.vpcf",
        offset = Vector(0,0,0),
    },
    Snow = {
        particle = "particles/rain_fx/econ_snow.vpcf",
        offset = Vector(0,0,0),
    },
    Moonbeam = {
        particle = "particles/rain_fx/econ_moonlight.vpcf",
        offset = Vector(0,0,0),
    },
    Pestilence = {
        particle = "particles/rain_fx/econ_weather_pestilence.vpcf",
        offset = Vector(0,0,0),
    },
    Sirocco = {
        particle = "particles/rain_fx/econ_weather_sirocco.vpcf",
        offset = Vector(0,0,0),
    },
    Rain = {
        particle = "particles/rain_fx/econ_rain.vpcf",
        offset = Vector(0,0,0),
    },  
    HeavyRain = {
        particle = "particles/rain_fx/econ_heavy_rainecon_rain.vpcf",
        offset = Vector(0,0,0),
    }
}

function weather_controler:SwitchWeather(weather)
    print("weather_controler:SwitchWeather",weather)
    if WeatherMap[weather] then
        print("WeatherMap[weather]",WeatherMap[weather])
        self.current_global_weather = weather
        if not player then return false end
        player:EachPlayerWithTeam(DOTA_TEAM_GOODGUYS , function(n, nPlayerID)
        print("SwitchToDefaultWeather",nPlayerID)
        self:SwitchToDefaultWeather(nPlayerID)
        return false
        end)
    end
end

-- 将显示天气切换为默认天气
function weather_controler:SwitchToDefaultWeather(nPlayerID)
    
    if not self.current_weather_list[nPlayerID] then
        self.current_weather_list[nPlayerID] = {
            index = 0,
            particleIndex = -1,
            timer = -1,
        }
    
    end
    if self.current_weather_list[nPlayerID].particleIndex ~= -1 then
        ParticleManager:DestroyParticle(self.current_weather_list[nPlayerID].particleIndex, false)
    end

    if not self.current_global_weather then
        return
    end
    if not WeatherMap[self.current_global_weather] then
        return
    end
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    
    print("WeatherMap[self.current_global_weather].particle=",WeatherMap[self.current_global_weather].particle)
    local particleIndex = ParticleManager:CreateParticle(WeatherMap[self.current_global_weather].particle, PATTACH_EYES_FOLLOW, player)
    self.current_weather_list[nPlayerID].particleIndex = particleIndex
    self.current_weather_list[nPlayerID].index = self.current_weather_list[nPlayerID].index + 1
    self.current_weather_list[nPlayerID].timer = -1

    if self.current_global_weather=="Spring" then
        ParticleManager:SetParticleControl(self.current_weather_list[nPlayerID].particleIndex, 15, Vector(1,0,0))
    end

end

-- 覆盖所有人的天气
function weather_controler:OverrideWeather(weather,duration)
    player:EachPlayerWithTeam(DOTA_TEAM_GOODGUYS , function(n, nPlayerID)
        self:OverrideWeatherByPlayerID(nPlayerID, weather,duration)
        return false
    end)
end

-- 覆盖目标玩家天气
function weather_controler:OverrideWeatherByPlayerID(nPlayerID, weather,duration)
    
    if not self.current_weather_list[nPlayerID] then
        self.current_weather_list[nPlayerID] = {
            index = 0,
            particleIndex = -1,
            timer = -1,
        }
    
    end
    

    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    if not WeatherMap[weather] then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if self.current_weather_list[nPlayerID].particleIndex ~= -1 then
        ParticleManager:DestroyParticle(self.current_weather_list[nPlayerID].particleIndex, false)
    end
    if WeatherMap[weather].particle then        
        local particleIndex = ParticleManager:CreateParticle(WeatherMap[weather].particle, PATTACH_EYES_FOLLOW, player)
        self.current_weather_list[nPlayerID].particleIndex = particleIndex
        self.current_weather_list[nPlayerID].index = self.current_weather_list[nPlayerID].index + 1
        local temp_index = self.current_weather_list[nPlayerID].index
        self.current_weather_list[nPlayerID].timer = GameRules:GetGameTime() + duration
    
        if self.current_global_weather=="Spring" then
            ParticleManager:SetParticleControl(self.current_weather_list[nPlayerID].particleIndex, 15, Vector(1,0,0))
        end
        hero:GameTimer(duration, function()
            if self.current_weather_list[nPlayerID].index == temp_index then
                self:SwitchToDefaultWeather(nPlayerID)
            end
        end)
    end



 
end






return weather_controler