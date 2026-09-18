
---------------------------------------------------------------------------
-- Arrow Trap
---------------------------------------------------------------------------
LinkLuaModifier( "modifier_hero_pos_check", "trigger/Trigger_disable_bug", LUA_MODIFIER_MOTION_NONE )

function OnStartTouch( trigger )
	-- local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, thisEntity:GetAbsOrigin(), nil, 500, 
	-- DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	-- _G.GAME_PREPARE_INDEX = 0
	-- for _, unit in pairs(units) do
	-- 	if unit:IsRealHero() then
	-- 		_G.GAME_PREPARE_INDEX = _G.GAME_PREPARE_INDEX + 1
	-- 	end
	-- end
	local target = trigger.activator
	if not target or target.isThinker then
		return
	end
	if target:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  target:IsOwnedByAnyPlayer() and Game_State:IsInBattle()  then
		target:AddNewModifier(target, nil, "modifier_hero_pos_check", {duration = 20})
		FindClearSpaceForUnit(target, Vector(0,0,0), true)
		
		return
	end
end




function OnEndTouch( trigger )
	local target = trigger.activator
	if not target or target.isThinker then
		return
	end
	local modifier = target:FindModifierByName("modifier_hero_pos_check")
	if modifier then
		modifier:DecrementStackCount()
	end
	-- target:RemoveModifierByName("modifier_hero_pos_check")
end


--------------------------------------------------------------------------------
modifier_hero_pos_check = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hero_pos_check:IsHidden()return false end
function modifier_hero_pos_check:IsDebuff()return false end
function modifier_hero_pos_check:IsStunDebuff()return false end
function modifier_hero_pos_check:IsPurgable()return false end
function modifier_hero_pos_check:IsPurgeException() 	return false end
function modifier_hero_pos_check:RemoveOnDeath() return false end
function modifier_hero_pos_check:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_hero_pos_check:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_hero_pos_check:OnIntervalThink()
	FindClearSpaceForUnit(self:GetParent(), Vector(-300,-1053,896), true)
	if self:GetStackCount()<=0 then
		self:SafeDestroy()
	end
end