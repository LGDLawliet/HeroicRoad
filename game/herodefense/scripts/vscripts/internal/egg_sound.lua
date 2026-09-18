Egg_sound = Egg_sound or class({})
require("internal/timers")


function Egg_sound:Init()
  
end

function Egg_sound:TryPlayEggSoundOfWave25()
    if  _G.GAME_END_WAVE~=25 then
        return
    end
    if 10>=RandomInt(1, 100) then
        if Myspawner:GetWaveID(25)==52 then
            local gameEvent = {}
            -- gameEvent["player_id"] = nPlayerID
            gameEvent["teamnumber"] = -1
            gameEvent["message"] = "#EggSound_FacelessVoid"
            FireGameEvent( "dota_combat_event_message", gameEvent )
            -- print("success")
            self:PlayEggSound_FacelessVoid(RandomInt(1, 1))
        end
    end
end


function Egg_sound:PlayEggSound_FacelessVoid(type)
    if type==1 then
        self:PlayEggSound_FacelessVoid_A()
    elseif type==2 then
        self:PlayEggSound_FacelessVoid_B()
    elseif type==3 then
        self:PlayEggSound_FacelessVoid_C()
    elseif type==4 then
        self:PlayEggSound_FacelessVoid_D()
    elseif type==5 then
        self:PlayEggSound_FacelessVoid_E()
    end
  
end
function Egg_sound:PlayEggSound_FacelessVoid_A()
    local sound_event = {
        {
           name= "faceless_void_fv_arc_mono_a_01",
           delay = 8,
        },
        {
            name= "faceless_void_fv_arc_mono_a_02",
            delay = 4.5,
        },
        {
            name= "faceless_void_fv_arc_mono_a_03",
            delay = 8.5,
        },
        {
            name= "faceless_void_fv_arc_mono_a_04",
            delay = 7.4,
        },
        {
            name= "faceless_void_fv_arc_mono_a_05",
            delay = 7.5,
        },
        {
            name= "faceless_void_fv_arc_mono_a_06",
            delay = 6.3,
        },
        {
            name= "faceless_void_fv_arc_mono_a_07",
            delay = 5.7,
        },
        {
            name= "faceless_void_fv_arc_mono_a_08",
            delay = 7,
        },
        {
            name= "faceless_void_fv_arc_mono_a_09",
            delay = 5.3,
        },
        {
            name= "faceless_void_fv_arc_mono_a_10",
            delay = 4.2,
        },
        {
            name= "faceless_void_fv_arc_mono_a_11",
            delay = 2.6,
        },
        {
            name= "faceless_void_fv_arc_mono_a_12",
            delay = 4,
        },
        {
            name= "faceless_void_fv_arc_mono_a_13",
            delay = -1,
        },




    }
    local count = 0
    Timers:CreateTimer(0.1, function()
        count = count + 1
        EmitGlobalSound(sound_event[count].name)
        if sound_event[count].delay>=0 then
            return sound_event[count].delay
        else
            return nil
        end
    end)
   
end
function Egg_sound:PlayEggSound_FacelessVoid_B()
    local sound_event = {
        {
           name= "faceless_void_fv_arc_mono_b_01",
           delay = 6.5,
        },
        {
            name= "faceless_void_fv_arc_mono_b_02",
            delay = 2.2,
        },
        {
            name= "faceless_void_fv_arc_mono_b_03",
            delay = 4.8,
        },
        {
            name= "faceless_void_fv_arc_mono_b_04",
            delay = 3.7,
        },
        {
            name= "faceless_void_fv_arc_mono_b_05",
            delay = 8.5,
        },
        {
            name= "faceless_void_fv_arc_mono_b_06",
            delay = 5.2,
        },
        {
            name= "faceless_void_fv_arc_mono_b_07",
            delay =-1,
        },




    }
    local count = 0
    Timers:CreateTimer(0.1, function()
        count = count + 1
        EmitGlobalSound(sound_event[count].name)
        if sound_event[count].delay>=0 then
            return sound_event[count].delay
        else
            return nil
        end
    end)
   
end
function Egg_sound:PlayEggSound_FacelessVoid_C()
    local sound_event = {
        {
           name= "faceless_void_fv_arc_mono_c_01",
           delay = 5.5,
        },
        {
            name= "faceless_void_fv_arc_mono_c_02",
            delay = 4.6,
        },
        {
            name= "faceless_void_fv_arc_mono_c_03",
            delay = 2.35,
        },
        {
            name= "faceless_void_fv_arc_mono_c_04",
            delay = 5.3,
        },
        {
            name= "faceless_void_fv_arc_mono_c_05",
            delay =-1,
        },





    }
    local count = 0
    Timers:CreateTimer(0.1, function()
        count = count + 1
        EmitGlobalSound(sound_event[count].name)
        if sound_event[count].delay>=0 then
            return sound_event[count].delay
        else
            return nil
        end
    end)
   
end
function Egg_sound:PlayEggSound_FacelessVoid_D()
    local sound_event = {
        {
           name= "faceless_void_fv_arc_mono_d_01",
           delay = 7,
        },
        {
            name= "faceless_void_fv_arc_mono_d_02",
            delay = 5.2,
        },
        {
            name= "faceless_void_fv_arc_mono_d_03",
            delay = 5.2,
        },
        {
            name= "faceless_void_fv_arc_mono_d_04",
            delay = 4.3,
        },
        {
            name= "faceless_void_fv_arc_mono_d_05",
            delay = -1,
        },





    }
    local count = 0
    Timers:CreateTimer(0.1, function()
        count = count + 1
        EmitGlobalSound(sound_event[count].name)
        if sound_event[count].delay>=0 then
            return sound_event[count].delay
        else
            return nil
        end
    end)
   
end
function Egg_sound:PlayEggSound_FacelessVoid_E()
    local sound_event = {
        {
           name= "faceless_void_fv_arc_mono_e_01",
           delay = 3.1,
        },
        {
            name= "faceless_void_fv_arc_mono_e_02",
            delay = 3,
        },
        {
            name= "faceless_void_fv_arc_mono_e_03",
            delay = 5,
        },
        {
            name= "faceless_void_fv_arc_mono_e_04",
            delay = 7,
        },
        {
            name= "faceless_void_fv_arc_mono_e_05",
            delay = 4,
        },
        {
            name= "faceless_void_fv_arc_mono_e_06",
            delay = 5,
        },
        {
            name= "faceless_void_fv_arc_mono_e_07",
            delay = -1,
        },





    }
    local count = 0
    Timers:CreateTimer(0.1, function()
        count = count + 1
        EmitGlobalSound(sound_event[count].name)
        if sound_event[count].delay>=0 then
            return sound_event[count].delay
        else
            return nil
        end
    end)
   
end