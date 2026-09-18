--特效优化 √
Advanced_Ice_Path = class({})
LinkLuaModifier("modifier_Advanced_Ice_Path_debuff", "skills/Advanced_Ice_Path", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Path_already", "skills/Advanced_Ice_Path", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Path_debuff2", "skills/Advanced_Ice_Path", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Path_unlock2", "skills/Advanced_Ice_Path", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')
function Advanced_Ice_Path:IsHiddenWhenStolen() 		return false end
function Advanced_Ice_Path:IsRefreshable() 			return true end
function Advanced_Ice_Path:IsStealable() 			return true end
function Advanced_Ice_Path:IsNetherWardStealable() 	return true end
function Advanced_Ice_Path:GetManaCost()
	if self:GetAutoCastState() then
		return 150 + 150*self:GetSpecialValueFor("auto_mana_index")*0.01
	end
	return 150
end
---------------------------------------------------------

------------------------------------------------------------
function Advanced_Ice_Path:CheckKV(key)
	local table = {

	
		basic_damage =10,
		path_duration =0.1,
		intelligence_index = 0.1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Ice_Path:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_Ice_Path:UnlockSecondCore(key)
	-- local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	-- if #heroes<=1 then
	-- 	self.CoreUnlock = false
	-- 	self.unlock2 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end

	caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Path_unlock2",{})
	return true
end
function Advanced_Ice_Path:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	
	-- if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	-- self.totalcost = 0
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Midnight_Pulse_unlock3",{})
	-- _G.Fortunes_end_unlock3 = true
	return true

end
function Advanced_Ice_Path:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/midnight_pulse/effect2/effect.vpcf", context )
end


function Advanced_Ice_Path:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock == 2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end


	return self.BaseClass.GetBehavior(self)
	
end


--add by MB 0823
--------------------------------------------------------------------
function Advanced_Ice_Path:OnSpellStart()
	if self.unlock1 then
		self:Unlock1SpellStart()
		return
	end
	if self.unlock3 then
		self:Unlock3Effect()
		return
	end
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if pos==caster:GetOrigin() then
		pos = pos + caster:GetForwardVector()
	end
	local caster_pos = caster:GetAbsOrigin()--起始点
	local hpos = caster:GetUpVector()*100--高度
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local length = math.max(self:GetCastRange(pos, caster)  + 200,100)--长度.
	--local length = math.max(self:GetCastRange(pos, caster) + caster:GetCastRangeBonus() + 200,100)--长度
	local end_pos = caster_pos + caster:GetForwardVector() * length--结束点
	--ability kv
	local path_radius = self:GetSpecialValueFor("path_radius")
	local duration = self:GetSpecialValueFor("path_duration") 
	--wearable kv 
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	--音效
	EmitSoundOn( sound_name, caster )
	--特效
	local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
	DestroyParticleByDelay(pfx,10)
	local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
	ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
	ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
	DestroyParticleByDelay(pfx2,duration+3)
	--抛射物
	local info =
	{
		Ability = self,
		vSpawnOrigin = caster_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +10,
		vVelocity	= direction * 3000,
		bProvidesVision = true,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	} 
	ProjectileManager:CreateLinearProjectile( info )

	--LV20解锁魔法三重化--已重做
	--新LV5解锁【寒域扩散】：冰封路径将额外在侧面15°方向产生一次。
	if self.advanced_level>=5 then
		
		local pos = RotatePosition(caster_pos, QAngle(0, 30, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = math.max(self:GetCastRange(pos, caster)+200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 3000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )


		--------------------------
		local pos = self:GetCursorPosition()
		local pos = RotatePosition(caster_pos, QAngle(0, -30, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = math.max(self:GetCastRange(pos, caster)+200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,duration+3)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 3000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )
	end
	--新LV15解锁【寒域封杀】：冰封路径将在侧面30°额外产生一次，并且此路径的长度+50%
	if self.advanced_level>=15 then
		----------------------------------
		local pos = RotatePosition(caster_pos, QAngle(0, 60, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = 1.5*math.max(self:GetCastRange(pos, caster)+200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length ,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 6000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )

		------------------------------------
		local pos = self:GetCursorPosition()
		local pos = RotatePosition(caster_pos, QAngle(0, -60, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = 1.5*math.max(self:GetCastRange(pos, caster)+200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 6000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )
		
	end

	--新高阶效果【巨型冰川】技能可以自动施法：自动施法开启时，魔法消耗量增加200%，让冰川在你的左右两侧额外产生一次，其长度无限。
	if self:GetAutoCastState() then
		
		local pos = RotatePosition(caster_pos, QAngle(0, 90, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = 1.5*math.max(self:GetCastRange(pos, caster) +200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 6000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )
		--------------------------------------------------------------------------
		local pos = self:GetCursorPosition()
		local pos = RotatePosition(caster_pos, QAngle(0, -90, 0), pos)--三叉位置调整
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		local length = 1.5*math.max(self:GetCastRange(pos, caster)+200,100)
		local end_pos = caster_pos + direction * length
		
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物
		local info =
		{
			Ability = self,
			vSpawnOrigin = caster_pos,
			EffectName = projectile_name,
			fDistance = length,
			fStartRadius = path_radius,
			fEndRadius = path_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime	= GameRules:GetGameTime() +10,
			vVelocity	= direction * 6000,
			bProvidesVision = true,
			iVisionRadius = 1000,
			iVisionTeamNumber = caster:GetTeamNumber()
		} 
		ProjectileManager:CreateLinearProjectile( info )
	end
end

function Advanced_Ice_Path:Unlock3Effect()
	local caster = self:GetCaster()
	local cast_pos = self:GetCursorPosition()
	local caster_pos = caster:GetAbsOrigin()
	if cast_pos==caster_pos then
		cast_pos = cast_pos + caster:GetForwardVector()
	end
	
	local hpos = caster:GetUpVector()*100 
	local length = 180
	local end_pos_main = caster_pos + caster:GetForwardVector() * length
	--ability kv
	local path_radius = 200
	local duration =60
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	--音效
	EmitSoundOn( sound_name, caster )
	--特效
	local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 1, end_pos_main + hpos )
	ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
	DestroyParticleByDelay(pfx,10)
	local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx2, 1, end_pos_main + hpos)
	ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
	ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
	DestroyParticleByDelay(pfx2,duration+3)
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	local direction = (end_pos_main - caster_pos):Normalized()
	local info =
	{
		Ability = self,
		vSpawnOrigin = caster_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +60,
		vVelocity	= direction * 3,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	} 
	ProjectileManager:CreateLinearProjectile( info )
end

function Advanced_Ice_Path:Unlock1SpellStart()--新原石1：【冰花三角】自动施法不再产生额外效果，冰封路径将构成一个完美无缺的三角。
	local caster = self:GetCaster()
	local cast_pos = self:GetCursorPosition()
	if cast_pos==caster:GetOrigin() then
		cast_pos = cast_pos + caster:GetForwardVector()
	end
	local caster_pos = caster:GetAbsOrigin()
	local hpos = caster:GetUpVector()*100 
	local length = math.max(self:GetCastRange(cast_pos, caster)+200,100)
	local end_pos_main = caster_pos + caster:GetForwardVector() * length*2
	--ability kv
	local path_radius = self:GetSpecialValueFor("path_radius")*1.5
	local duration = self:GetSpecialValueFor("path_duration") 
	self:CreatePathFromAToB(caster_pos,end_pos_main,hpos,duration,length*2,path_radius)
	self:CreatePathFromAToB(end_pos_main,caster_pos,hpos,duration,length*2,path_radius)



	local unlock1_length = length *2/3 * math.sqrt(3)
	local pos = RotatePosition(caster_pos, QAngle(0, 30, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)

	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)

	local pos = RotatePosition(caster_pos, QAngle(0, -30, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)

	local pos = RotatePosition(caster_pos, QAngle(0, -60, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)

	local pos = RotatePosition(caster_pos, QAngle(0, 60, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)
	
	local pos = RotatePosition(caster_pos, QAngle(0, 90, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)

	local pos = RotatePosition(caster_pos, QAngle(0, -90, 0), cast_pos)
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local end_pos = caster_pos + direction * unlock1_length
	self:CreatePathFromAToB(caster_pos,end_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,end_pos_main,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos,caster_pos,hpos,duration,length,path_radius)
	self:CreatePathFromAToB(end_pos_main,end_pos,hpos,duration,length,path_radius)
end

function Advanced_Ice_Path:CreatePathFromAToB(start_pos,end_pos,hpos,duration,length,path_radius)
	local caster = self:GetCaster()
	if start_pos==end_pos then
		end_pos = end_pos+caster:GetForwardVector()
	end
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	--音效
	EmitSoundOn( sound_name, caster )
	--特效
	local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, start_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 2, start_pos + hpos )
	DestroyParticleByDelay(pfx,10)
	local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx2, 0, start_pos + hpos )
	ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
	ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
	ParticleManager:SetParticleControl( pfx2, 9, start_pos + hpos )
	DestroyParticleByDelay(pfx2,duration+3)
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	local direction = (end_pos - start_pos):Normalized()
	local info =
	{
		Ability = self,
		vSpawnOrigin = start_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +10,
		vVelocity	= direction * 3000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	} 
	ProjectileManager:CreateLinearProjectile( info )

end


--------------------------------------------------------------------
function Advanced_Ice_Path:Spell_SplitIcePath(vSource,vCount)
	local caster = vSource
	local caster_pos = caster:GetAbsOrigin()
	local hpos = caster:GetUpVector()*100 
	local length = self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus()
	length = math.max(length,100)
	local end_pos = caster_pos + caster:GetForwardVector():Normalized() * length
	--ability kv
	local path_radius = self:GetSpecialValueFor("path_radius")
	local duration = self:GetSpecialValueFor("duration")
	--wearable kv 
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	--音效
	EmitSoundOn( sound_name, self:GetCaster() ) 
	--抛射物
	local info =
	{
		Ability = self,
		vSpawnOrigin = caster_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +10,
		--vVelocity	= direction * 3000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()
	} 
	--多道冰封路径
	for i=0, vCount-1 do
		local pos = GetGroundPosition(RotatePosition(caster_pos, QAngle(0,i * (360 / vCount),0), end_pos), nil)
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		direction.z = 0 
		--print("IcePath Direction",direction,i)
		--特效
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, pos + hpos ) --end_pos
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,10)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, pos + hpos) --end_pos
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物修改
		info.vVelocity = direction * 3000
		ProjectileManager:CreateLinearProjectile( info )
	end
end
--------------------------------------------------------------------
function Advanced_Ice_Path:OnProjectileHit_ExtraData(target, location, kv)
	
	if not target then
		return
	end
	self:AddSpellEffect(target)
end

function Advanced_Ice_Path:AddSpellEffect(target)
	local gain_index_res = 0.4
	local gain_index_negative = 0.8

	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(gain_index_negative)
	ModifierStatusNegativeGain = math.max(ModifierStatusNegativeGain,0)
	local StatusResistance = target:GetHDStatusResistanceIndex(gain_index_res)*ModifierStatusNegativeGain
	StatusResistance = math.max(StatusResistance,0)
	local duration = (self:GetSpecialValueFor("path_duration"))*StatusResistance
	local damage = self:GetSpecialValueFor("basic_damage")+ self:GetCaster():GetIntellect(false)*(self:GetSpecialValueFor("intelligence_index"))
	if self.unlock3 then
		damage = damage * 2
	end
	if not target:IsMagicImmune() then
		local modifier = target:FindModifierByNameAndCaster("modifier_Advanced_Ice_Path_already",self:GetCaster())
		if modifier then
			damage = damage*0.3
		end
		target:AddNewModifier(  self:GetCaster(), self, "modifier_Advanced_Ice_Path_debuff", {duration = duration} )
     	local damage_type = self:GetAbilityDamageType()
	    local damageTable = {
			victim = target,
			attacker =  self:GetCaster(),
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
			ability = self,
		}
		ApplyDamage(damageTable)
		target:AddNewModifier(  self:GetCaster(), self, "modifier_Advanced_Ice_Path_already", {duration = 0.5} )
	end
end

------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Ice_Path_debuff = class({})

function modifier_Advanced_Ice_Path_debuff:IsDebuff()	return true end
function modifier_Advanced_Ice_Path_debuff:IsHidden()	return false end
function modifier_Advanced_Ice_Path_debuff:IsPurgable()	return false end
function modifier_Advanced_Ice_Path_debuff:IsPurgeException()	return true end
function modifier_Advanced_Ice_Path_debuff:IsStunDebuff() return true end
function modifier_Advanced_Ice_Path_debuff:GetStatusEffectName()	return "particles/status_fx/status_effect_frost_lich.vpcf"	end
function modifier_Advanced_Ice_Path_debuff:StatusEffectPriority() return 100	end
function modifier_Advanced_Ice_Path_debuff:GetEffectName()	return "particles/generic_gameplay/generic_frozen.vpcf"	end
function modifier_Advanced_Ice_Path_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW	end
function modifier_Advanced_Ice_Path_debuff:CheckState()	
	return	{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true}
end

function modifier_Advanced_Ice_Path_debuff:DeclareFunctions() return
	{MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Ice_Path_debuff:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	--LV5解锁碎冰+
	if self.advanced_level>=10 then
		self.bonus_damage = self.bonus_damage +15
	end

end
function modifier_Advanced_Ice_Path_debuff:GetModifierMagicalResistanceBonus() return (0 - self.bonus_damage) end


function modifier_Advanced_Ice_Path_debuff:OnDestroy()--寒风刺骨效果无视魔免
	if not IsServer() then
		return
	end
	if self.advanced_level>=20 then
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Advanced_Ice_Path_debuff2", {duration = 3 } )
	end
end


modifier_Advanced_Ice_Path_debuff2 = class({})

function modifier_Advanced_Ice_Path_debuff2:IsDebuff()			return true end
function modifier_Advanced_Ice_Path_debuff2:IsHidden() 			return false end
function modifier_Advanced_Ice_Path_debuff2:IsPurgable() 			return true end
function modifier_Advanced_Ice_Path_debuff2:IsPurgeException() 	return true end
function modifier_Advanced_Ice_Path_debuff2:GetEffectName()	return "particles/generic_gameplay/generic_frozen.vpcf"	end
function modifier_Advanced_Ice_Path_debuff2:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW	end
function modifier_Advanced_Ice_Path_debuff2:DeclareFunctions() 
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end



function modifier_Advanced_Ice_Path_debuff2:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.move_slow  =-self:GetAbility():GetSpecialValueFor("move_slow")
	--self.attack_slow = -self:GetAbility():GetSpecialValueFor("attack_speed_slow")
end
function modifier_Advanced_Ice_Path_debuff2:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
--function modifier_Advanced_Ice_Path_debuff2:GetModifierAttackSpeedBonus_Constant() return self.attack_slow  end



modifier_Advanced_Ice_Path_already = class({})

function modifier_Advanced_Ice_Path_already:IsHidden()	return true end
function modifier_Advanced_Ice_Path_already:IsDebuff()	return false end
function modifier_Advanced_Ice_Path_already:IsPurgable()	return false end
function modifier_Advanced_Ice_Path_already:IsPurgeException() return false end






modifier_Advanced_Ice_Path_unlock2 = class({})

function modifier_Advanced_Ice_Path_unlock2:IsHidden()	return false end
function modifier_Advanced_Ice_Path_unlock2:IsDebuff()	return false end
function modifier_Advanced_Ice_Path_unlock2:IsPurgable()	return false end
function modifier_Advanced_Ice_Path_unlock2:IsPurgeException() return false end
function modifier_Advanced_Ice_Path_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Ice_Path_unlock2:OnCreated(keys)
	if IsServer() then
		self.count = 0
		self.timer = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Ice_Path_unlock2:OnIntervalThink()
	self.timer = self.timer + 0.1
	if self.timer>=3 then
		self:SetStackCount(math.min(self:GetStackCount()+1,15))
		self.timer = 0
	end
	if self:GetStackCount()>=1 then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = 4
		local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
		local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
		local sound_name = "Hero_Jakiro.IcePath"
		for _, unit in ipairs(enemy) do
			if not unit:HasModifier("modifier_Advanced_Ice_Path_debuff") then
				ability:AddSpellEffect(unit)

				EmitSoundOn( sound_name, unit )
				local pos = unit:GetOrigin()
				local new_pos = pos + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
				--特效
				local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
				ParticleManager:SetParticleControl( pfx, 0, pos  )
				ParticleManager:SetParticleControl( pfx, 1, new_pos  )
				ParticleManager:SetParticleControl( pfx, 2, pos )
				DestroyParticleByDelay(pfx,10)
				local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
				ParticleManager:SetParticleControl( pfx2, 0, pos  )
				ParticleManager:SetParticleControl( pfx2, 1, new_pos )
				ParticleManager:SetParticleControl( pfx2, 2, Vector( 1 , 0, 0 ) )
				ParticleManager:SetParticleControl( pfx2, 9, pos  )
				DestroyParticleByDelay(pfx2,10)
				count = count - 1
				if count<=0 then
					break
				end
			end
		
		end
		if count<4 then
			self:DecrementStackCount()
		end
		
	end
end

function modifier_Advanced_Ice_Path_unlock2:DeclareFunctions() 
    return {
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    } 
end

function modifier_Advanced_Ice_Path_unlock2:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=5 then
		self.count = self.count + 1
		if self.count>=2 then
			self.count = 0
			self:SetStackCount(math.min(self:GetStackCount()+1,15))
		end
      
    end
  
    
end