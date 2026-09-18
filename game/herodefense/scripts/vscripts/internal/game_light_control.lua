
print("game_light_control load.....")
game_light_control = game_light_control or class({})

function game_light_control:Init()
  
    print("game_light_control init")

    self.light_on = true

    self.tree_light = {
        Entities:FindByName(nil, "tree_light_1"),
        Entities:FindByName(nil, "tree_light_2"),
        Entities:FindByName(nil, "tree_light_3"),
        Entities:FindByName(nil, "tree_light_4"),
        Entities:FindByName(nil, "tree_light_5"),
        Entities:FindByName(nil, "tree_light_6"),
        Entities:FindByName(nil, "tree_light_7"),
        Entities:FindByName(nil, "tree_light_8"),
        Entities:FindByName(nil, "tree_light_9"),
    }

    self.light_control_on = Entities:FindByName(nil, "light_control_on")
    self.light_control_off = Entities:FindByName(nil, "light_control_off")


    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("checkLighting"), function()
		self:LightLogicChecking()
		return 1
	end, 0)



end



function game_light_control:LightLogicChecking()
    if GameRules:IsDaytime()  then
        if  self.light_on then
            -- print("关灯")
            self.light_on = false
            for _, eneity in ipairs(self.tree_light) do
                DoEntFireByInstanceHandle(eneity, "TurnOff", "", RandomFloat(0, 0.5), nil, nil)
                -- DoEntFireByInstanceHandle(eneity, "Radius", "100", RandomFloat(0, 2.5), nil, nil)
            end
            -- self.light_control_off:Trigger(nil,nil)

        end

    else
        if not self.light_on then
            self.light_on = true
            -- print("开灯")
            for _, eneity in ipairs(self.tree_light) do
                DoEntFireByInstanceHandle(eneity, "TurnOn", "", RandomFloat(0, 0.5), nil, nil)
                -- DoEntFireByInstanceHandle(eneity, "Radius", "1500", RandomFloat(0, 2.5), nil, nil)
            end
            -- self.light_control_on:Trigger(nil,nil)

        end
    end
end