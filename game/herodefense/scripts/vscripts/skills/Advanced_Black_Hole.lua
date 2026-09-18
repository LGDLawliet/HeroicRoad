
Advanced_Black_Hole = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Black_Hole_singularity", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_thinker", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_out_pull", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_aura", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_unlock1", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_unlock2_thinker", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_thinker2", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Black_Hole_out_pull2", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Black_Hole_aura2", "skills/Advanced_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Black_Hole_out_pull_sp_self", "skills/Primary_Black_Hole", LUA_MODIFIER_MOTION_NONE)

function Advanced_Black_Hole:CheckKV(key)
	local table = {
		basic_damage = 5,
		intelligence_index = 0.05,
	}
	local value = table[key] or -1
	return value
end

--命石：黑洞，改形态
function Advanced_Black_Hole:GetCastRange() 
	if IsServer() and self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff") then
		return 99999
	end
end

function Advanced_Black_Hole:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Black_Hole_unlock1",{})
	return true
end
function Advanced_Black_Hole:UnlockSecondCore(key)
	local caster = self:GetCaster()
	local unit  = CreateUnitByName("npc_hd_double",  caster:GetOrigin(), true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, self, "modifier_Advanced_Black_Hole_unlock2_thinker", {})
	unit:SetModelScale(0)
	-- CreateModifierThinker(caster, self, "modifier_Advanced_Black_Hole_unlock2_thinker", {}, caster:GetOrigin(), caster:GetTeamNumber(), false)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Life_Drain_unlock2",{})
	return true
end
function Advanced_Black_Hole:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Nether_Blast_unlock3",{})
	return true
end
function Advanced_Black_Hole:GetChannelTime()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 30
		end
	end
	return self.BaseClass.GetChannelTime(self)
end



function Advanced_Black_Hole:IsHiddenWhenStolen() 	return false end
function Advanced_Black_Hole:IsRefreshable() 		return false  end
function Advanced_Black_Hole:IsStealable() 			return true  end
function Advanced_Black_Hole:IsNetherWardStealable() return true end



function Advanced_Black_Hole:GetAOERadius()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local bonus_radius_index = self:GetSpecialValueFor("bonua_radius_index")
	--LV5解锁不测之渊+
	if advanced_level>=5 then
		bonus_radius_index = bonus_radius_index+1
	end

	local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetIntellect(false) * bonus_radius_index
	radius= math.min(radius,1950)
	
	if IsServer() then--命石：黑洞，改范围1
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
		if equip_sp then
			radius = (self:GetSpecialValueFor("radius") + self:GetCaster():GetIntellect(false) * bonus_radius_index )* (1+equip_sp:GetAbility():GetSpecialValueFor("radius_up")*0.01)
			radius = math.min(radius,3510)
		end
	end
	return  radius
end

function Advanced_Black_Hole:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if IsServer() then--命石：黑洞，改位置
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
		if equip_sp then
			pos = caster:GetAbsOrigin()
			self.pos = caster:GetAbsOrigin()
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Black_Hole_out_pull_sp_self", {duration = self:GetChannelTime()})
		end
	end
	function Advanced_Black_Hole:Absonstart()
		return	self.pos
	end

	local exduration = 0
	if self.advanced_level>=15 then
		exduration = exduration +3
	end
	local bonus_radius_index = self:GetSpecialValueFor("bonua_radius_index")
	--LV5解锁不测之渊+
	if self.advanced_level>=5 then
		bonus_radius_index = bonus_radius_index+1
	end
	local radius = self:GetCaster():GetIntellect(false) * bonus_radius_index
	if self.advanced_level>=20 and radius>1000 then
		exduration = exduration +(radius-1000)*0.004
	end
	self.pos = pos
	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetChannelTime() + FrameTime() * 2+exduration}, pos, caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, self, "modifier_Advanced_Black_Hole_thinker", {duration = self:GetChannelTime()+1})

	self.think = 0
	self.baseTime = self.BaseClass.GetChannelTime(self)
end


function Advanced_Black_Hole:Midnight_Pulse_Unlock1(pos)
	local caster = self:GetCaster()
	-- local pos = self:GetCursorPosition()
	local thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration =2.5 + FrameTime() * 2}, pos, caster:GetTeamNumber(), false)
	thinker:AddNewModifier(caster, self, "modifier_Advanced_Black_Hole_thinker", {duration = 2.5,midnight_pulse = 1})
end

function Advanced_Black_Hole:Malefice_Unlock3(pos)
	local caster = self:GetCaster()
	-- local pos = self:GetCursorPosition()
	local thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration =2}, pos, caster:GetTeamNumber(), false)
	thinker:AddNewModifier(caster, self, "modifier_Advanced_Black_Hole_thinker", {duration = 2,Malefice = 1})
end

function Advanced_Black_Hole:OnChannelFinish(a)

	local exduration = 0
	if self.advanced_level>=15 then
		exduration = exduration +3
	end
	local bonus_radius_index = self:GetSpecialValueFor("bonua_radius_index")
	--LV5解锁不测之渊+
	if self.advanced_level>=5 then
		bonus_radius_index = bonus_radius_index+1
	end
	local radius = self:GetCaster():GetIntellect(false) * bonus_radius_index
	if self.advanced_level>=20 and radius>1000 then
		exduration = exduration +(radius-1000)*0.004
	end



	--延时
	if exduration>0 then
		if self.thinker and not self.thinker:IsNull() then
			local buff = self.thinker:FindModifierByName("modifier_Advanced_Black_Hole_thinker")
			buff:SetDuration( exduration, true )
			buff.on  = false
			self.thinker = nil
		
			
		end
	else
		if self.thinker and not self.thinker:IsNull() then
			local buff = self.thinker:FindModifierByName("modifier_Advanced_Black_Hole_thinker")
			buff:SetDuration( 0, true )
			self.thinker = nil
		end
	end

end
function Advanced_Black_Hole:OnChannelThink(time)
	if not self.unlock3 then
		return
	end
	self.think = self.think + time
	if self.think >=self.baseTime then
		local caster = self:GetCaster()
		local ex_second = math.floor(self.think-self.baseTime )
		local mana_cost_per_second = 1500+ex_second*500
		local mana_spend = mana_cost_per_second/(1/time)
		-- print(mana_spend)
		if mana_spend<=caster:GetMana() then
			caster:SpendMana( mana_spend, self )
		else
			self:EndChannel(true)
		end
		

		

	end
end
modifier_Advanced_Black_Hole_thinker = class({})

function modifier_Advanced_Black_Hole_thinker:OnCreated(keys)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
		

		local hole_pfx = "particles/units/heroes/hero_enigma/enigma_blackhole_rebuild.vpcf"
		local radius = self:GetAbility():GetAOERadius()
		if keys.midnight_pulse then
			radius = radius  *0.5
		end
		if keys.Malefice then
			radius = 600
		end
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = pos.z + 100
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		local index = radius/450

		ParticleManager:SetParticleControl(pfx, 10, Vector(index,0,0))
		if self:GetCaster():GetIntellect(false) * self:GetAbility():GetSpecialValueFor("bonua_radius_index") >= 500 then
			ParticleManager:SetParticleControl(pfx, 60, Vector(30,30,30))
			ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
			-- self:GetParent():EmitSound("Imba.EnigmaBlackHoleTobi0"..math.random(1, 5))
		end


		self:AddParticle(pfx, false, false, 15, false, false)

		self.advanced_level = self:GetAbility().advanced_level
		local caster = self:GetCaster()

		self.dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") +self:GetAbility():GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / 0.3)

		if radius>= 950 then
			self.dmg = self.dmg *2
		end
		if radius>=1450 and self.advanced_level>=10 then
			self.dmg = self.dmg *1.5
		end
	

		self.on = true

		self.radius = radius
		self:StartIntervalThink(0.3)
	end
end

function modifier_Advanced_Black_Hole_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local radius = self:GetAbility():GetAOERadius()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	--进入延迟将不造成伤害
	if self.on == true then
		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 
		radius,
		 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
		for i=1, #enemy do
			local damageTable = {
								victim = enemy[i],
								attacker = caster,
								damage = self.dmg,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
	end



	-- local enemies2 = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- for i=1, #enemies2 do
	-- 	if not enemies2[i]:HasModifier("modifier_Advanced_Black_Hole_aura") then
	-- 		enemies2[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Black_Hole_out_pull", {})
	-- 	end
	-- end
end

function modifier_Advanced_Black_Hole_thinker:IsAura() return true end
function modifier_Advanced_Black_Hole_thinker:GetAuraDuration() return 0.1 end
function modifier_Advanced_Black_Hole_thinker:GetModifierAura() return "modifier_Advanced_Black_Hole_aura" end
function modifier_Advanced_Black_Hole_thinker:GetAuraRadius() return self.radius end
function modifier_Advanced_Black_Hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Advanced_Black_Hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Black_Hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Black_Hole_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		UTIL_Remove(self:GetParent())
		
	end
end

modifier_Advanced_Black_Hole_aura = class({})

function modifier_Advanced_Black_Hole_aura:IsDebuff()			return true end
function modifier_Advanced_Black_Hole_aura:IsHidden() 			return false end
function modifier_Advanced_Black_Hole_aura:IsPurgable() 			return false end
function modifier_Advanced_Black_Hole_aura:IsPurgeException() 	return false end
function modifier_Advanced_Black_Hole_aura:IsStunDebuff()		return true end
function modifier_Advanced_Black_Hole_aura:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_Advanced_Black_Hole_aura:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Black_Hole_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Advanced_Black_Hole_aura:IsMotionController() return true end
function modifier_Advanced_Black_Hole_aura:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Black_Hole_aura:OnCreated()
	if IsServer() then
		self.pos = self:GetAuraOwner():GetOrigin()
		--命石：黑洞，拉扯加强
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
		if equip_sp then
			self.new_pos = self:GetAbility():Absonstart()
		end
		if self:CheckMotionControllers() then
			if self:GetParent():IsHero() then
				local pfx = ParticleManager:CreateParticleForPlayer("particles/hero/enigma/screen_blackhole_indicator.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()))
			self:AddParticle(pfx, false, false, 15, false, false)
				PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
			end
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Black_Hole_aura:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local distance = (self:GetParent():GetAbsOrigin() - self.pos):Length2D()
	local in_pull = 250
	local new_pos = GetGroundPosition(RotatePosition(self.pos, QAngle(0,1.5,0), self:GetParent():GetAbsOrigin()), self:GetParent())
	if distance > 20 then
		local direction = (self.pos - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
	end
	--命石：黑洞，拉扯加强
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
	if equip_sp then
		new_pos = self.new_pos
	end
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Advanced_Black_Hole_aura:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		if self:GetParent():IsHero() then
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
	end
	end
end

-- modifier_Advanced_Black_Hole_out_pull = class({})

-- function modifier_Advanced_Black_Hole_out_pull:IsDebuff()			return false end
-- function modifier_Advanced_Black_Hole_out_pull:IsHidden() 			return true end
-- function modifier_Advanced_Black_Hole_out_pull:IsPurgable() 			return false end
-- function modifier_Advanced_Black_Hole_out_pull:IsPurgeException() 	return false end
-- function modifier_Advanced_Black_Hole_out_pull:IsMotionController() return true end
-- function modifier_Advanced_Black_Hole_out_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

-- function modifier_Advanced_Black_Hole_out_pull:OnCreated()
-- 	if IsServer() then
-- 		if self:CheckMotionControllers() then
-- 			self:StartIntervalThink(FrameTime())
-- 		else
-- 			self:SafeDestroy()
-- 		end
-- 	end
-- end

-- function modifier_Advanced_Black_Hole_out_pull:OnIntervalThink()
-- 	if self:GetParent():HasModifier("modifier_Advanced_Black_Hole_aura") then
-- 		self:SafeDestroy()
-- 		return
-- 	end
-- 	local ability = self:GetAbility()
-- 	local out_distance = self:GetAbility():GetSpecialValueFor("pull_distance")
-- 	if not ability:IsChanneling() or (self:GetParent():GetAbsOrigin() - ability.pos):Length2D() > out_distance or self:GetParent():IsBoss() then
-- 		self:SafeDestroy()
-- 	end
-- 	local out_pull = ability:GetSpecialValueFor("pull_speed")

-- 	local direction = (ability.pos - self:GetParent():GetAbsOrigin()):Normalized()
-- 	direction.z = 0.0
-- 	local new_pos = self:GetParent():GetAbsOrigin() + direction * (out_pull / (1.0 / FrameTime()))
-- 	self:GetParent():SetOrigin(new_pos)
-- end

-- function modifier_Advanced_Black_Hole_out_pull:OnDestroy()
-- 	if IsServer() and not self:GetParent():HasModifier("modifier_Advanced_Black_Hole_aura") then
-- 		local pos = self:GetParent():GetAbsOrigin()
-- 		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
-- 	end
-- end
--命石：黑洞，致死返还
function modifier_Advanced_Black_Hole_aura:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end
function modifier_Advanced_Black_Hole_aura:OnDeath()	
	if not IsServer() then
		return
	end
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
	if equip_sp then
		local ability_sp = equip_sp:GetAbility()
		if not self:GetAbility():IsCooldownReady() then
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - ability_sp:GetSpecialValueFor("cd_reduce")
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
	end
end
 

modifier_Advanced_Black_Hole_unlock1 = class({})

function modifier_Advanced_Black_Hole_unlock1:IsDebuff()			return false end
function modifier_Advanced_Black_Hole_unlock1:IsHidden() 			return false end
function modifier_Advanced_Black_Hole_unlock1:IsPurgable() 		    return false end
function modifier_Advanced_Black_Hole_unlock1:IsPurgeException() return false end
function modifier_Advanced_Black_Hole_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Black_Hole_unlock1:OnEndTrigger(keys)
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		if unit:GetTimeUntilRespawn()<=0 then --位处于复活倒计时
			if not unit:IsAlive() then --防止二次复活
			
				local pos = unit:GetOrigin()
				unit:RespawnHero(false,false)
				FindClearSpaceForUnit( unit, pos, true )
				unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=20}) --提供无敌防止死亡
				local hole_pfx = "particles/units/heroes/hero_enigma/enigma_blackhole_rebuild.vpcf"
				pos.z = pos.z + 100
				local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, pos)
				local index = 2
				ParticleManager:SetParticleControl(pfx, 10, Vector(index,0,0))
				Timers:CreateTimer(0.5, function()
					ParticleManager:DestroyParticle(pfx,false)
					ParticleManager:ReleaseParticleIndex(pfx)
					unit:EmitSound("Hero_Enigma.Black_Hole.Stop")
					return nil
				end
			)
			
			end
	   
		end


	end
	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Player_Black_Hole"..RandomInt(1, 2)
	FireGameEvent( "dota_combat_event_message", gameEvent )
	self:SafeDestroy()

end










modifier_Advanced_Black_Hole_unlock2_thinker = modifier_Advanced_Black_Hole_unlock2_thinker or class({})
function modifier_Advanced_Black_Hole_unlock2_thinker:IsHidden()	return true end
function modifier_Advanced_Black_Hole_unlock2_thinker:IsDebuff()	return false end
function modifier_Advanced_Black_Hole_unlock2_thinker:IsPurgable()	return false end
function modifier_Advanced_Black_Hole_unlock2_thinker:IsPurgeException()	return false end
function modifier_Advanced_Black_Hole_unlock2_thinker:OnCreated(keys)
	if IsServer() then
		self:GetParent():SetHullRadius(0)
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.01)
		self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_Advanced_Black_Hole_thinker2", {})

	end

end
function modifier_Advanced_Black_Hole_unlock2_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_Black_Hole_unlock2_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,

	}
end


function modifier_Advanced_Black_Hole_unlock2_thinker:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	

	-- if not caster:HasModifier("modifier_Advanced_elder_dragon_form_transform") then
	-- 	-- self:SafeDestroy()
	-- 	self:GoDie()
	-- 	return
	-- end
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)*0.5
	local parent = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	-- local newpos = RotatePosition(pos, QAngle(0, 90, 0), pos + forward)
	local newpos =  pos - forward*100
	local dir = (newpos-pos):Normalized()
	-- local target_pos = pos+dir*200
	-- target_pos.z = target_pos.z+128
	local dis = CalculateDistance(newpos,parent:GetAbsOrigin())
	if dis>=3000 then
		parent:SetForwardVector(forward)
		parent:SetAbsOrigin(newpos+dir)
		return
	end
	if dis>=150 then
		parent:MoveToPosition(newpos)
	end


	
end

function modifier_Advanced_Black_Hole_unlock2_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end


function modifier_Advanced_Black_Hole_unlock2_thinker:GetModifierMoveSpeed_AbsoluteMin()
	local caster = self:GetCaster()
	local index =  (self:GetParent():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/500
	return math.max( caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true),self.bonus_move*index)
end

function modifier_Advanced_Black_Hole_unlock2_thinker:GetVisualZDelta( params )
	-- if IsClient() then
	-- 	return
	-- end
	return 128
end
function modifier_Advanced_Black_Hole_unlock2_thinker:GetModifierIgnoreMovespeedLimit( params )
	return 1
end


modifier_Advanced_Black_Hole_thinker2 = class({})

function modifier_Advanced_Black_Hole_thinker2:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
		local hole_pfx = "particles/units/heroes/hero_enigma/enigma_blackhole_rebuild.vpcf"
		local radius = self:GetAbility():GetAOERadius()
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = pos.z + 100
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControlEnt()
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 10, Vector(1.2,0,0))
		self:AddParticle(pfx, false, false, 15, false, false)
		local caster = self:GetCaster()
		self.dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") +self:GetAbility():GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / 0.3)
		if caster:HasModifier("modifier_item_hd_starry_sky_dome_buff") then
			self.dmg = self.dmg *1.4
		end
		if radius>= 950 then
			self.dmg = self.dmg *2
		end
		if radius>=1450 then
			self.dmg = self.dmg *1.5
		end
		self.dmg = self.dmg *0.2
		self.radius = 450
		self:StartIntervalThink(0.3)
	end
end

function modifier_Advanced_Black_Hole_thinker2:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	self.dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") +self:GetAbility():GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / 0.3)
	if caster:HasModifier("modifier_item_hd_starry_sky_dome_buff") then
		self.dmg = self.dmg *1.4
	end
	local radius = self:GetAbility():GetAOERadius()
	if radius>= 950 then
		self.dmg = self.dmg *2
	end
	if radius>=1450 then
		self.dmg = self.dmg *1.5
	end
	self.dmg = self.dmg *0.2
	--进入延迟将不造成伤害
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 
	self.radius ,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	for i=1, #enemy do
		local damageTable = {
							victim = enemy[i],
							attacker = caster,
							damage = self.dmg,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		if i>=10 then
			break
		end
	end



	-- local enemies2 = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- for i=1, #enemies2 do
	-- 	if not enemies2[i]:HasModifier("modifier_Advanced_Black_Hole_aura") then
	-- 		enemies2[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Black_Hole_out_pull", {})
	-- 	end
	-- end
end

function modifier_Advanced_Black_Hole_thinker2:IsAura() return true end
function modifier_Advanced_Black_Hole_thinker2:GetAuraDuration() return 0.1 end
function modifier_Advanced_Black_Hole_thinker2:GetModifierAura() return "modifier_Advanced_Black_Hole_aura2" end
function modifier_Advanced_Black_Hole_thinker2:GetAuraRadius() return self.radius end
function modifier_Advanced_Black_Hole_thinker2:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Advanced_Black_Hole_thinker2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Black_Hole_thinker2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Black_Hole_thinker2:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		UTIL_Remove(self:GetParent())
		
	end
end

modifier_Advanced_Black_Hole_aura2 = class({})

function modifier_Advanced_Black_Hole_aura2:IsDebuff()			return true end
function modifier_Advanced_Black_Hole_aura2:IsHidden() 			return true end
function modifier_Advanced_Black_Hole_aura2:IsPurgable() 			return false end
function modifier_Advanced_Black_Hole_aura2:IsPurgeException() 	return false end
function modifier_Advanced_Black_Hole_aura2:CheckState() return
	 {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	} 
end
function modifier_Advanced_Black_Hole_aura2:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Black_Hole_aura2:GetOverrideAnimation() return ACT_DOTA_FLAIL end
-- function modifier_Advanced_Black_Hole_aura2:IsMotionController() return true end
-- function modifier_Advanced_Black_Hole_aura2:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH-1 end

function modifier_Advanced_Black_Hole_aura2:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			if self:GetParent():IsHero() then
				local pfx = ParticleManager:CreateParticleForPlayer("particles/hero/enigma/screen_blackhole_indicator.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()))
				self:AddParticle(pfx, false, false, 15, false, false)
				PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
			end
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Black_Hole_aura2:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local pos = self:GetAuraOwner():GetOrigin()
	local distance = (self:GetParent():GetAbsOrigin() - pos):Length2D()

	local in_pull = 100
	local new_pos = GetGroundPosition(RotatePosition(pos, QAngle(0,1.5,0), self:GetParent():GetAbsOrigin()), self:GetParent())
	local dir = CalculateDirection(self:GetParent():GetAbsOrigin(),new_pos)
	-- local dir = CalculateDirection(pos,new_pos)
	if distance > 10 then
		local direction = (pos - new_pos):Normalized()
		direction.z = 0.0
		-- new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
		new_pos = self:GetParent():GetAbsOrigin() + dir * in_pull *FrameTime()
	end
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Advanced_Black_Hole_aura2:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		if self:GetParent():IsHero() then
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
	end
	end
end

-- modifier_Advanced_Black_Hole_out_pull2 = class({})

-- function modifier_Advanced_Black_Hole_out_pull2:IsDebuff()			return false end
-- function modifier_Advanced_Black_Hole_out_pull2:IsHidden() 			return true end
-- function modifier_Advanced_Black_Hole_out_pull2:IsPurgable() 			return false end
-- function modifier_Advanced_Black_Hole_out_pull2:IsPurgeException() 	return false end
-- function modifier_Advanced_Black_Hole_out_pull2:IsMotionController() return true end
-- function modifier_Advanced_Black_Hole_out_pull2:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

-- function modifier_Advanced_Black_Hole_out_pull2:OnCreated()
-- 	if IsServer() then
-- 		if self:CheckMotionControllers() then
-- 			self:StartIntervalThink(FrameTime())
-- 		else
-- 			self:SafeDestroy()
-- 		end
-- 	end
-- end

-- function modifier_Advanced_Black_Hole_out_pull2:OnIntervalThink()
-- 	if self:GetParent():HasModifier("modifier_Advanced_Black_Hole_aura") then
-- 		self:SafeDestroy()
-- 		return
-- 	end
-- 	local ability = self:GetAbility()
-- 	local out_distance = self:GetAbility():GetSpecialValueFor("pull_distance")
-- 	if not ability:IsChanneling() or (self:GetParent():GetAbsOrigin() - ability.pos):Length2D() > out_distance or self:GetParent():IsBoss() then
-- 		self:SafeDestroy()
-- 	end
-- 	local out_pull = ability:GetSpecialValueFor("pull_speed")

-- 	local direction = (ability.pos - self:GetParent():GetAbsOrigin()):Normalized()
-- 	direction.z = 0.0
-- 	local new_pos = self:GetParent():GetAbsOrigin() + direction * (out_pull / (1.0 / FrameTime()))
-- 	self:GetParent():SetOrigin(new_pos)
-- end

-- function modifier_Advanced_Black_Hole_out_pull2:OnDestroy()
-- 	if IsServer() and not self:GetParent():HasModifier("modifier_Advanced_Black_Hole_aura") then
-- 		local pos = self:GetParent():GetAbsOrigin()
-- 		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
-- 	end
-- end