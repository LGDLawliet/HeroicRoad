function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	

	thisEntity.AI = {}
	thisEntity.AI.patrolSpeed = 200  -- 巡逻速度
	thisEntity.AI.chaseSpeed = 350   -- 追击速度
	thisEntity.AI.state = "patrol"  -- 状态设置为巡逻
	

	thisEntity:SetContextThink( "BearCaveUrsaThink", BearCaveUrsaThink, 0.25 )
	print("BearCaveUrsaThink Start")
end

--------------------------------------------

function BearCaveUrsaThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	--小熊猛猛冲
	if thisEntity:GetModelScale() == 0.5 then
		return -1
	end
	
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then 
		StartChase(enemies[1]) 
		return 0.1 
	end

	if thisEntity.AI.state == "patrol" then
		thisEntity:SetBaseMoveSpeed(thisEntity.AI.patrolSpeed)  -- 设置巡逻速度
		return 0.1
	else
		thisEntity.AI.state = "patrol"  -- 状态设置为巡逻
		thisEntity:SetBaseMoveSpeed(thisEntity.AI.patrolSpeed)  -- 设置巡逻速度
		
		return 0.1
	end
	
	
end

--------------------------------------------

function StartChase(target)
	if not IsServer() then return end
	--目标死亡
	if  not target:IsAlive()  then
		return
	end
	thisEntity:SetBaseMoveSpeed(thisEntity.AI.chaseSpeed)  -- 设置追击速度
	thisEntity.AI.state = "chase"  -- 状态设置为追击
end

-----------------------------------------