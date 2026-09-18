require("internal/timers")
-- Farna_Kill_SOUND = {
--     "enchantress_ench_kill_01",
-- 	"enchantress_ench_kill_06",
-- 	"enchantress_ench_kill_08",
-- 	"enchantress_ench_kill_09",
-- 	"enchantress_ench_kill_10",
-- 	"enchantress_ench_kill_13",

-- }

Farna_DEATH_SOUND = {
    "enchantress_ench_death_01",
	"enchantress_ench_death_02",
	"enchantress_ench_death_03",
	"enchantress_ench_death_04",
	"enchantress_ench_death_05",
	"enchantress_ench_death_06",
	"enchantress_ench_death_07",
	"enchantress_ench_death_08",
	"enchantress_ench_death_09",
	"enchantress_ench_death_10",
	"enchantress_ench_death_11",
}


function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
	Timers:CreateTimer(2, function()
		EmitGlobalSound("enchantress_ench_cast_03")  -- I'll run you down!
	end)
end



function OnEntityKilled( event )

	local hVictim = nil
	local hAttacker = nil
	-- PrintTable(event)
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end
	if hVictim == thisEntity then
		EmitGlobalSound(Farna_DEATH_SOUND[RandomInt(1, 11)])
	end
	-- if hVictim:IsRealHero() and hAttacker==thisEntity then
	-- 	EmitGlobalSound(Farna_Kill_SOUND[RandomInt(1, 6)])
	-- end


	

	

end