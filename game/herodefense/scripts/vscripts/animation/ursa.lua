
print("model ok2")

model:CreateSequence(
	{
		name = "hd_enrage_gesture",
		sequences = {
			{ "ti10_ti9_ursa_taunt" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 99999 },
            { name = "hd_avtivity", weight = 99999 }
		}
	}
)


model:CreateSequence(
	{
		name = "hd_overpower_gesture",
		sequences = {
			{ "earthshock" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 }
		}
	}
)

