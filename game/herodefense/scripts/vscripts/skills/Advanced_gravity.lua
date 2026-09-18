--特效优化 √
LinkLuaModifier("modifier_Advanced_gravity_thinker", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_gravity_damage", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_gravity_motion", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_gravity_unlock1", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_gravity_motion_unlock2", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_gravity_thinker_unlock3", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_gravity_thinker_unlock3_debuff", "skills/Advanced_gravity", LUA_MODIFIER_MOTION_NONE)
Advanced_gravity = class ({})


require('internal/timers')   --计时器功能
function Advanced_gravity:CheckKV(key)
	local table = {


	
		damage =3,
		bonus_damage = 0.02,
		explosion_damage =0.2,




	}
	local value = table[key] or -1
	return value

end

function Advanced_gravity:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_gravity:UnlockSecondCore(key)
	return true
end
function Advanced_gravity:UnlockThirdCore(key)
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

function Advanced_gravity:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/gravity/unlock3/effect_warp.vpcf", context )

end

-- particles/rebuild/spell/gravity/unlock3/effect_warp.vpcf

function Advanced_gravity:GetAOERadius()return self:GetSpecialValueFor("radius") end

function Advanced_gravity:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local forward = 1
	local bonus_count = 0
	if self:GetAutoCastState() then
		forward = -1
		if self.advanced_level>=5 then
			forward = -1.5
		end
		bonus_count = 1
	else
		if self.advanced_level>=20 then
			bonus_count = 2
		end
	end
	

	if self.unlock2 then
		bonus_count = 6
		forward = -1.5
	end
	local thinker = CreateModifierThinker(caster, self, "modifier_Advanced_gravity_thinker", {duration = duration,posx=point.x,posy=point.y,forward=forward,damage_index = 1,bonus_count =bonus_count}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	thinker:AddNewModifier(caster, self, "modifier_Advanced_gravity_damage", {duration =duration,damage_index = 1})
	if self.unlock3 then
	
		if self.thinker then
			UTIL_Remove( self.thinker )
			self.thinker = nil
		end
		self.thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_gravity_thinker_unlock3", 
			{duration = 25}, -- kv
			point,
			caster:GetTeamNumber(),
			false
		)
		return
	end
end

modifier_Advanced_gravity_thinker = class({})

function modifier_Advanced_gravity_thinker:IsDebuff()			return true end
function modifier_Advanced_gravity_thinker:IsHidden() 			return true end
function modifier_Advanced_gravity_thinker:IsPurgable() 		return true end
function modifier_Advanced_gravity_thinker:IsPurgeException() 	return true end
function modifier_Advanced_gravity_thinker:OnCreated(keys)
	if IsServer() then
		EmitSoundOn( "Hero_Enigma.Black_Hole", self:GetParent() )
		EmitSoundOn( "gravity.Black_Hole", self:GetParent() )
		
		self.caster = self:GetCaster()
		self.thinker = self:GetParent()
		self.ability = self:GetAbility()
		self.thinker_loc = self.thinker:GetAbsOrigin()
		self.target = Vector(keys.posx,keys.posy,1500)
		self.damage_index = keys.damage_index
		self.damage_index2 = 1

		self.radius			= self.ability:GetSpecialValueFor("radius")
		self.forward = keys.forward
		self.bonus_count = keys.bonus_count
		if self:GetAbility().advanced_level>=15 then
			self.damage_index2=self.damage_index2*1.5
			self.radius = self.radius*1.5
		end

		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/gravity/gravity.vpcf", PATTACH_CUSTOMORIGIN, nil)
		self.pos = self:GetParent():GetAbsOrigin()
		self.pos.z = self.pos.z +128
		self.dir = ( self.target-self.pos):Normalized()
		ParticleManager:SetParticleControl(self.particle, 0, self.pos)
		ParticleManager:SetParticleControl(self.particle, 4, self.pos)
		self:GetParent():SetAbsOrigin(self.pos)
		self:AddParticle(self.particle, false, false, 15, false, false)

		self:StartIntervalThink(FrameTime())
	end
end
function modifier_Advanced_gravity_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	-- self.pos.z = self.pos.z +100*FrameTime()
	self.pos = self.pos +self.dir*100*FrameTime()
	ParticleManager:SetParticleControl(self.particle, 0, self.pos)
	ParticleManager:SetParticleControl(self.particle, 4, self.pos)
	self:GetParent():SetAbsOrigin(self.pos)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if ability.unlock1 then
		
		for _, unit in pairs(enemies) do
			unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_gravity_motion", {duration = 0.6,forward = self.forward})
			unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_gravity_unlock1", {duration = 0.6})
		end
	else
		for _, unit in pairs(enemies) do
			unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_gravity_motion", {duration = 0.6,forward = self.forward})
		end
	end


	-- if ability.unlock2 then
	-- 	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200,
	-- 	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _, unit in pairs(enemies) do
	-- 		if not unit:HasModifier("modifier_Advanced_gravity_motion") then
	-- 			unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_gravity_motion_unlock2", {duration = 0.6})
	-- 		end
			
	-- 	end
	-- end
end

function modifier_Advanced_gravity_thinker:OnDestroy(keys)
	if IsServer() then
		-- local thinker = self:GetParent()


		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("gravity.Black_Hole")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)

		local ability = self:GetAbility()
		if ability then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
			local pos = self:GetParent():GetAbsOrigin()
			pos.z = pos.z-64
			ParticleManager:SetParticleControl(pfx, 0, pos)
			ParticleManager:SetParticleControl(pfx, 60, Vector(70,70,70))
			ParticleManager:SetParticleControl(pfx, 1, Vector(700,700,700))
			ParticleManager:SetParticleControl(pfx, 3, pos)
			ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(pfx)
			local caster = self:GetCaster()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(),
			nil, 700,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE ,
			FIND_ANY_ORDER, false)
			local damageTable = {

				attacker = caster,
				damage = caster:GetIntellect(false)*ability:GetSpecialValueFor("explosion_damage")*self.damage_index*self.damage_index2,
				damage_type =  ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
				}
			for _, enemy in pairs(enemies) do

				damageTable.victim = enemy
			
				ApplyDamage(damageTable)  

				
				
			end
			caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
			-- if self.forward<=-1 and self.bonus_count>=1 then
			-- 	local point = self:GetParent():GetAbsOrigin()
				local damage_index = 0.5
				if ability.advanced_level>=10 then
					damage_index = 0.75
					if ability.advanced_level>=20 then
						damage_index = 0.9
						if ability.unlock2 then
							damage_index = 1.1
							self.forward = 1.5
						end
					end
				end
			-- 	local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_gravity_thinker", {duration = 5,posx=point.x,posy=point.y,forward=1,damage_index =self.damage_index* damage_index,bonus_count=self.bonus_count-1}, point, caster:GetTeamNumber(), false)
			-- 	thinker:AddNewModifier(caster, ability, "modifier_Advanced_gravity_damage", {duration =5,damage_index = self.damage_index*damage_index})
			-- elseif ability.advanced_level>=20 and self.bonus_count>=1 then
			-- 	local point = self:GetParent():GetAbsOrigin()
			-- 	local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_gravity_thinker", {duration = 5,posx=point.x,posy=point.y,forward=-1,damage_index = self.damage_index*0.75,bonus_count=self.bonus_count-1}, point, caster:GetTeamNumber(), false)
			-- 	thinker:AddNewModifier(caster, ability, "modifier_Advanced_gravity_damage", {duration =5,damage_index = self.damage_index*0.75})
			-- end
			if self.bonus_count>=1 then
				local point = self:GetParent():GetAbsOrigin()
				local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_gravity_thinker", {duration = 5,posx=point.x,posy=point.y,forward=-self.forward,damage_index = self.damage_index*damage_index,bonus_count=self.bonus_count-1}, point, caster:GetTeamNumber(), false)
				thinker:AddNewModifier(caster, ability, "modifier_Advanced_gravity_damage", {duration =5,damage_index = self.damage_index*damage_index})
			end
		end

		UTIL_Remove(self:GetParent())
		
	end
end










modifier_Advanced_gravity_damage = class({})

function modifier_Advanced_gravity_damage:IsDebuff()			return true end
function modifier_Advanced_gravity_damage:IsHidden() 			return true end
function modifier_Advanced_gravity_damage:IsPurgable() 		return true end
function modifier_Advanced_gravity_damage:IsPurgeException() 	return true end
function modifier_Advanced_gravity_damage:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage_index = keys.damage_index
		if self:GetAbility().advanced_level>=15 then
			self.radius = self.radius*1.5
			damage_index = damage_index*1.5
		end
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = (self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"))*damage_index,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}

		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_gravity_damage:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	 for _, unit in pairs(enemies) do
		 self.damageTable.victim = unit
		 ApplyDamage(self.damageTable)
	 end
end












modifier_Advanced_gravity_motion = class({})

function modifier_Advanced_gravity_motion:IsDebuff()			return true end
function modifier_Advanced_gravity_motion:IsHidden() 			return true end
function modifier_Advanced_gravity_motion:IsPurgable() 		return false end
function modifier_Advanced_gravity_motion:IsPurgeException() 	return false end
function modifier_Advanced_gravity_motion:IsMotionController() return true end

function modifier_Advanced_gravity_motion:OnCreated(keys)
	if IsServer() then
		self.forward = keys.forward
		if self:GetAbility().advanced_level>=15 then
			self.forward =self.forward *1.5
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/fall_2021/radiance_fall_2021.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		


		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_gravity_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
	end
end




function modifier_Advanced_gravity_motion:OnIntervalThink(keys)   
	if  IsServer() then
		if not self:GetCaster() or not self:GetAbility() then
			self:SafeDestroy()
			return
		end
		local direction = ((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
		direction.z = 0  --初始化Z值
		local me = self:GetParent()
		local dt = FrameTime()
		local new_pos = me:GetAbsOrigin() + direction * (200 / (1.0 / dt))  *self.forward
		new_pos = GetGroundPosition(new_pos, nil)   
		me:SetOrigin(new_pos)  
		ResolveNPCPositions(new_pos, 70)
    end
end










modifier_Advanced_gravity_thinker_unlock3= modifier_Advanced_gravity_thinker_unlock3 or class({})

function modifier_Advanced_gravity_thinker_unlock3:IsHidden()		return true end
function modifier_Advanced_gravity_thinker_unlock3:IsPurgable()		return false end
function modifier_Advanced_gravity_thinker_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_gravity_thinker_unlock3:IsAura() return self:GetAbility() end
function modifier_Advanced_gravity_thinker_unlock3:GetAuraRadius()return self.radius end
function modifier_Advanced_gravity_thinker_unlock3:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_gravity_thinker_unlock3:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_gravity_thinker_unlock3:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_gravity_thinker_unlock3:GetModifierAura()return "modifier_Advanced_gravity_thinker_unlock3_debuff" end


function modifier_Advanced_gravity_thinker_unlock3:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local particle_cast = "particles/rebuild/spell/gravity/unlock3/effect_warp.vpcf"
		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
		local pos = self:GetParent():GetOrigin()
		ParticleManager:SetParticleControl( self.effect_cast, 0, pos )
		pos.z  =  pos.z  +200
		self:GetParent():SetOrigin(pos)
		self:StartIntervalThink(2)
	end
end
function modifier_Advanced_gravity_thinker_unlock3:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast,false	)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		-- ParticleManager:DestroyParticle(self.effect_cast2,true	)
		-- ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_Advanced_gravity_thinker_unlock3:OnIntervalThink()
	-- local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:IsAlive() or not ability then
		self:SafeDestroy()
		return
	end
end






modifier_Advanced_gravity_thinker_unlock3_debuff= modifier_Advanced_gravity_thinker_unlock3_debuff or class({})

function modifier_Advanced_gravity_thinker_unlock3_debuff:IsHidden()		return false end
function modifier_Advanced_gravity_thinker_unlock3_debuff:IsDebuff() return true end
function modifier_Advanced_gravity_thinker_unlock3_debuff:IsPurgable()		return false end
function modifier_Advanced_gravity_thinker_unlock3_debuff:OnCreated()
	if IsServer() then
		self.cant_move = 300
		self.damage_per_move_speed = 50
		self.damage_index = 0.1
		local ability = self:GetAbility()
		
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = (self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"))*damage_index,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_gravity_thinker_unlock3_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	local move_speed = parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false)
	if move_speed<self.cant_move then
		return
	end
	local damage_index = math.floor((move_speed-self.cant_move)/self.damage_per_move_speed)
	if damage_index<=0 then
		return
	end


	local damage  = (self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"))*math.min(damage_index*self.damage_index,10)
	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)

end

function modifier_Advanced_gravity_thinker_unlock3_debuff:CheckState()
	if IsServer() then
		local parent = self:GetParent()
		local move_speed = parent:GetMoveSpeedModifier(parent:GetBaseMoveSpeed(), false)
		if move_speed<=self.cant_move then
			return {[MODIFIER_STATE_ROOTED] = true}
		end
	end
end











-- modifier_Advanced_gravity_motion_unlock2 = class({})

-- function modifier_Advanced_gravity_motion_unlock2:IsDebuff()			return true end
-- function modifier_Advanced_gravity_motion_unlock2:IsHidden() 			return true end
-- function modifier_Advanced_gravity_motion_unlock2:IsPurgable() 		return false end
-- function modifier_Advanced_gravity_motion_unlock2:IsPurgeException() 	return false end
-- function modifier_Advanced_gravity_motion_unlock2:IsMotionController() return true end

-- function modifier_Advanced_gravity_motion_unlock2:OnCreated(keys)
-- 	if IsServer() then
-- 		self.radius = self:GetAbility():GetSpecialValueFor("radius")
-- 		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/fall_2021/radiance_fall_2021.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	
-- 		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		


-- 		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
-- 	end
-- end


-- function modifier_Advanced_gravity_motion_unlock2:OnDestroy()
-- 	if IsServer() then
-- 		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
-- 	end
-- end




-- function modifier_Advanced_gravity_motion_unlock2:OnIntervalThink(keys)   
-- 	if  IsServer() then
-- 		local caster = self:GetCaster()
-- 		if not caster or not self:GetAbility() then
-- 			self:SafeDestroy()
-- 			return
-- 		end
-- 		print(caster:GetUnitName())
-- 		local direction = ((caster:GetAbsOrigin() + self:GetParent():GetAbsOrigin()):Normalized())
-- 		direction.z = 0  --初始化Z值
-- 		local me = self:GetParent()
-- 		local dt = FrameTime()
-- 		local new_pos = me:GetAbsOrigin() + direction * (500 / (1.0 / dt))  
-- 		new_pos = GetGroundPosition(new_pos, nil)   
-- 		me:SetOrigin(new_pos)  
-- 		ResolveNPCPositions(new_pos, 70)
-- 		if CalculateDistance(caster,me)<=self.radius then
-- 			self:SafeDestroy()
-- 			return
-- 		end
--     end
-- end














modifier_Advanced_gravity_unlock1 = advanced_modifier({})

function modifier_Advanced_gravity_unlock1:IsDebuff()			return true end
function modifier_Advanced_gravity_unlock1:IsHidden() 			return true end
function modifier_Advanced_gravity_unlock1:IsPurgable() 		return false end
function modifier_Advanced_gravity_unlock1:IsPurgeException() 	return false end


function modifier_Advanced_gravity_unlock1:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		-- [MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
	
	

	return state
end



function modifier_Advanced_gravity_unlock1:Advanced_GetModifierIncomingDamage_Percentage()	return 43 end


function modifier_Advanced_gravity_unlock1:ADDeclareFunctions()

	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
	}
	return funcs
end


function modifier_Advanced_gravity_unlock1:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return 1
end

