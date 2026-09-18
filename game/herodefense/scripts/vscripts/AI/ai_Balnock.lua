require("internal/timers")
-- BALNOCK_Kill_SOUND = {
--     "abaddon_abad_deny_06",
-- 	"abaddon_abad_deny_15",
-- 	"abaddon_abad_deny_21",
-- 	"abaddon_abad_frostmourne_06",  --没人会哀悼你
-- 	"abaddon_abad_frostmourne_07",  --打倒你
-- 	"abaddon_abad_kill_01",--如此卑鄙的鲜血洒在地上污染了土壤。
-- 	"abaddon_abad_kill_04",--遗忘的阴暗将你找回
-- 	"abaddon_abad_kill_06",--死在高贵的手中并不能保证高贵的死亡

-- }

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity.balnock_shield_sound_intervel = false
	Ability1 = thisEntity:FindAbilityByName( "creeps_spell_Electrostatic_Connection" )
	Ability2 = thisEntity:FindAbilityByName( "creeps_spell_Electric_Induction" )
	-- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	thisEntity:SetContextThink( "CallousFurbolgThink", CallousFurbolgThink, 1 )
	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
	Timers:CreateTimer(2, function()
		EmitGlobalSound("abaddon_abad_cast_02")
	end)
end

function CallousFurbolgThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	--有第二状态
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS , FIND_CLOSEST, false )


	if thisEntity.pattern_2 then
		if Ability1 ~= nil and Ability1:IsFullyCastable() and enemies[1] ~= nil then
			-- print("1111")
			return SpellAbility1(enemies[1])
		end

	end
    

	if thisEntity.pattern_3 then
		if Ability2 ~= nil and Ability2:IsFullyCastable() and enemies[1] ~= nil then
			-- print("jhh")
			return SpellAbility2()
		end

	end



    
    
	return 0.3+RandomFloat(0.0,0.3)
end

function SpellAbility1(enemy)
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = enemy:entindex(),
			AbilityIndex = Ability1:entindex(),
			Queue = false,
		})
	end)
	
	return 2
end


function SpellAbility2()
	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = Ability2:entindex(),
			Queue = false,
		})
	end)
	-- print("555")
	
	return 2
end

-- function ult( enemy )
-- 	Timers:CreateTimer(RandomFloat(0.0,0.5), function()
-- 		ExecuteOrderFromTable({
-- 			UnitIndex = thisEntity:entindex(),
-- 			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
-- 			AbilityIndex = ultAbility:entindex(),
-- 			TargetIndex = enemy:entindex(),
-- 			Queue = false,
-- 		})
-- 	end)

-- 	return 1
-- end

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
		EmitSoundOn( "Hero_Leshrac.Lightning_Storm", hVictim )
		EmitGlobalSound("abaddon_abad_death_01")
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0, hVictim:GetOrigin())
    	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1000,1000,1000))
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex2, 0, hVictim:GetOrigin())
    	ParticleManager:SetParticleControl(nFXIndex2, 1, Vector(1500,1500,1500))
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )
		local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex3, 0, hVictim:GetOrigin())
   	 	ParticleManager:SetParticleControl(nFXIndex3, 1, Vector(2000,2000,2000))
		ParticleManager:ReleaseParticleIndex( nFXIndex3 )
	end
	-- if hVictim:IsRealHero() and hAttacker==thisEntity then
	-- 	EmitGlobalSound(BALNOCK_Kill_SOUND[RandomInt(1, 8)])
	-- end


	

	

end