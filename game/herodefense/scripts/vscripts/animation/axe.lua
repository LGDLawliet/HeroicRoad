--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\axe\axe.mdl
--
--=============================================================================


--To Activate these scripted animation overrides, rename the "animation_example" folder to "animation"

-- model:CreateWeightlist( 
--   "upperBody",
--   {
--     { "thigh_L", 0 },
--     { "thigh_R", 0 },
--     { "root", 0.25 },
--     { "spine1", 1 }
--   }
-- )


--This is an example of a script-added weight list which effectively disables an animation from playing on any bones besides the right-arm
-- model:CreateWeightlist( 
--   "testWeights",
--   {
--     { "thigh_L", 0 },
--     { "thigh_R", 0 },
--     { "root", 0 },
--     { "spine1", 0 },
--     { "spine2", 0 },
--     { "spine3", 0 },
--     { "neck1", 0 },
--     { "clavicle_L", 0 },
--     { "clavicle_R", 0 },
--     { "bicep_R", 1 }
--   }
-- )

print("model ok1")

--This is an example of a scripted animation using the "@attack" animation that will only play on the right arm, as well as setting the new animation
--to the ACT_DOTA_ATTACK2 activity, which is unused on axe's model (currently).
--axeUnit:StartGesture(ACT_DOTA_ATTACK2) will play this single-arm scripted animation.
-- model:CreateSequence(
--   {
--     name = "test_weight",
--     sequences = {
--       { "@counter_helix" }
--     },
--     weightlist = "testWeights",
--     activities = {
--       { name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 }
--     }
--   }
-- )

-- model:CreateSequence(
--   {
--     name = "hd_override_ability_4",
--     sequences = {
--       { "@counter_helix_blood_chaser" }
--     },
--     -- weightlist = "upperBody",
--     activities = {
--       { name = "ACT_DOTA_OVERRIDE_ABILITY_5", weight = 1 },
--       -- { name = "hd_avtivity", weight = 99999 }
--     }
--   }
-- )

-- model:CreateSequence(
--   {
--     name = "hd_counter_helix",
--     framerangesequence = "@counter_helix_blood_chaser",
--     cmds = {
--       { cmd = "sequence", sequence = "@counter_helix_blood_chaser", dst = 1 },
--       { cmd = "fetchframe", sequence = "@counter_helix_blood_chaser", frame = 0, dst = 2 },
--       { cmd = "subtract", dst = 1, src = 2 },
--       { cmd = "add", dst = 0, src = 1 }
--     },
--     activities = {
--       { name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
--       -- { name = "hd_avtivity", weight = 1 }
--     }
--   }
-- )

model:CreateSequence(
  {
    name = "hd_counter_helix",
    activities = {
      { name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
      -- { name = "hd_avtivity", weight = 1 }
    },
    looping = true,
    cmds = {

      { cmd = "fetchframerange", sequence = "@counter_helix_blood_chaser", startframe = 10, endframe = 10, dst=0 },
  
    },
   
  }
)
