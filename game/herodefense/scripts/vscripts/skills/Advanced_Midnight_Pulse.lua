--特效优化 √
Advanced_Midnight_Pulse = class({})

LinkLuaModifier("modifier_Advanced_Midnight_Pulse_thinker", "skills/Advanced_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Midnight_Pulse_motion", "skills/Advanced_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Midnight_Pulse_unlock3", "skills/Advanced_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)
function Advanced_Midnight_Pulse:IsHiddenWhenStolen() 	return false end
function Advanced_Midnight_Pulse:IsRefreshable() 		
	if IsServer() and self.unlock2 then
		return true
	end
	return false  
end
function Advanced_Midnight_Pulse:IsStealable() 			return true  end
function Advanced_Midnight_Pulse:IsNetherWardStealable() return true end
function Advanced_Midnight_Pulse:CheckKV(key)
	local table = {

	


		basic_damage = 4,
		intelligence_index = 0.04,





	}
	local value = table[key] or -1
	return value

end

function Advanced_Midnight_Pulse:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_Midnight_Pulse:UnlockSecondCore(key)
	-- local heroes = GetAllRealHeroes()
	-- local caster = self:GetCaster()
	-- if #heroes<=1 then
	-- 	self.CoreUnlock = false
	-- 	self.unlock2 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Midnight_Pulse_unlock3",{})
	return true
end
function Advanced_Midnight_Pulse:UnlockThirdCore(key)
	local caster = self:GetCaster()
	
	-- if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	-- self.totalcost = 0
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Midnight_Pulse_unlock3",{})
	-- _G.Fortunes_end_unlock3 = true
	return true

end
function Advanced_Midnight_Pulse:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/midnight_pulse/effect2/effect.vpcf", context )
end
function Advanced_Midnight_Pulse:GetCooldown(iLevel)
	local base = self.BaseClass.GetCooldown(self,iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return base *0.7
		end
		
	end

	return base

end


function Advanced_Midnight_Pulse:GetAOERadius()  
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local radius = self:GetSpecialValueFor("radius")
	--LV15解锁重力场++
	if advanced_level>=15 then
		radius = radius +200
	end
	return radius
end




function Advanced_Midnight_Pulse:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_Advanced_Midnight_Pulse_thinker", {duration = self:GetSpecialValueFor('duration')}, pos, caster:GetTeamNumber(), false)
	if self.unlock1 then
		local ability = caster:FindAbilityByName("Advanced_Black_Hole")
		if ability then
			ability:Midnight_Pulse_Unlock1(pos)
		end
	end
end
function Advanced_Midnight_Pulse:Demonic_Conversion_Trigger(pos)
	CreateModifierThinker(self:GetCaster(), self, "modifier_Advanced_Midnight_Pulse_thinker", {duration = 2,small=1}, pos, self:GetCaster():GetTeamNumber(), false)
end

function Advanced_Midnight_Pulse:MaleficeTrigger(pos)
	CreateModifierThinker(self:GetCaster(), self, "modifier_Advanced_Midnight_Pulse_thinker", {duration = 6}, pos, self:GetCaster():GetTeamNumber(), false)
end

modifier_Advanced_Midnight_Pulse_thinker = class({})

function modifier_Advanced_Midnight_Pulse_thinker:RemoveOnDeath() return true end


function modifier_Advanced_Midnight_Pulse_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		self.advanced_level = ability.advanced_level
		self.mana_cost = ability:GetManaCost(1) + ability:GetSpecialValueFor("sub_cast") * 0.01 * caster:GetMana()
		
		local mana_damage_index = ability:GetSpecialValueFor("total_max_damage")
		self.health_damage = ability:GetSpecialValueFor("damage_base_health")
		self.health_damage = 0.025
		--LV10解锁暗物质
		if self.advanced_level>=10 then
			mana_damage_index = 1.7
			self.health_damage = 0.025
		end
		self.mana_cost = mana_damage_index * self.mana_cost
		--上值为当前的伤害倍数
		self:GetParent():EmitSound("Hero_Enigma.Midnight_Pulse")
		self.radius =  self:GetAbility():GetAOERadius()
		if keys.small ==1 then
			self.radius = 400
			-- caster:SpendMana(ability:GetSpecialValueFor("sub_cast") * 0.002 * caster:GetMana(),ability)
		else
			caster:SpendMana(ability:GetSpecialValueFor("sub_cast") * 0.01 * caster:GetMana(),ability)
		end
		if keys.unlock3 then
			self.radius = 500
		end
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.radius, false)
		self.damage = ability:GetSpecialValueFor("basic_damage") +  caster:GetIntellect(false) * (ability:GetSpecialValueFor("intelligence_index"))
		

		self.max_effect_unit = 10
		--LV20解锁作用强化
		if self.advanced_level>=15 then
			self.damage = self.damage *1.25
			self.max_effect_unit = 20
			
		end
		self:StartIntervalThink(0.25)
		local name = "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_6" then
			name = "particles/rebuild/spell/midnight_pulse/effect2/effect.vpcf"			
		end
		local pfx = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, nil)

		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.count = 0
	end
end
function modifier_Advanced_Midnight_Pulse_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_Midnight_Pulse_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self.count = self.count + 1
	
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	

	
	for i=1, #enemy do
		if self.count >= 4 then
			local dmg = enemy[i]:GetMaxHealth() * self.health_damage
			if dmg > self.mana_cost then
				dmg = self.mana_cost
			end
			dmg = dmg + self.damage
			-- print(dmg)
			local damageTable = {
								victim = enemy[i],
								attacker = self:GetCaster(),
								damage = dmg,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
		local direction = (self:GetParent():GetAbsOrigin() - enemy[i]:GetAbsOrigin()):Normalized()
		direction.z = 0.0
		local new_pos = enemy[i]:GetAbsOrigin() + direction * ability:GetSpecialValueFor("pull_distance")
		local spell_pos = self:GetParent():GetAbsOrigin()
		enemy[i]:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Midnight_Pulse_motion", {duration = 0.3,pos = new_pos,spell_pos = spell_pos,speed = ability:GetSpecialValueFor("pull_distance")})
		if i>=self.max_effect_unit then
			break
		end
	end
	if self.count >=4 then
		self.count = 0
	end
end




modifier_Advanced_Midnight_Pulse_motion = class({})

function modifier_Advanced_Midnight_Pulse_motion:IsDebuff()			return true end
function modifier_Advanced_Midnight_Pulse_motion:IsHidden() 			return true end
function modifier_Advanced_Midnight_Pulse_motion:IsPurgable() 		return false end
function modifier_Advanced_Midnight_Pulse_motion:IsPurgeException() 	return false end
function modifier_Advanced_Midnight_Pulse_motion:IsMotionController() return true end
function modifier_Advanced_Midnight_Pulse_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_Advanced_Midnight_Pulse_motion:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	-- MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,              --施法前摇
} end
function modifier_Advanced_Midnight_Pulse_motion:GetModifierMoveSpeedBonus_Constant() 
	if not self:GetAbility() then
		return 0
	end
	if self.gain ~= nil  then
		return (0 - self:GetAbility():GetSpecialValueFor("move_slow") * self.gain)
	else
		return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) 
	end 
end
-- function modifier_Advanced_Midnight_Pulse_motion:GetModifierPercentageCasttime() 
-- 	-- if self.gain ~= nil  then
-- 	-- 	return (self.cast_speed * self.gain)
-- 	-- else
-- 		return self.cast_speed 
-- 	-- end
-- end

function modifier_Advanced_Midnight_Pulse_motion:OnCreated(keys)
	if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
			local pos_caster = StringToVector(keys.pos)
			local spell_pos = StringToVector(keys.spell_pos)
			local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
			self.direction = (pos_caster - pos_target):Normalized()
			self.direction.z = 0  --初始化Z值
			local x = spell_pos.x - pos_target.x
			local y = spell_pos.y - pos_target.y
			self.d = math.sqrt(x*x+y*y)
			--LV5解锁重力场
			if self.advanced_level>=5 then
				self.gain = -0.0025*self.d + 5.5
				if self.gain > 5 then
					self.gain = 5
				elseif self.gain < 1 then
					self.gain = 1
				end
				
			else
				self.gain = -0.0025*self.d + 3.25
				if self.gain > 3 then
					self.gain = 3
				elseif self.gain < 1 then
					self.gain = 1
				end
			end
			--self.direction = StringToVector(keys.key_drection)
			self.speed = keys.speed * self.gain
			if CalculateDistance(pos_caster,pos_target)<=50  then
				self.speed  = self.speed *0.1
			end
			local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(1)
			self.speed = self.speed*StatusResistance
			self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_Midnight_Pulse_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
	end
end




function modifier_Advanced_Midnight_Pulse_motion:OnRefresh(keys)
    if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
        local pos_caster = StringToVector(keys.pos)  --获取自己
		local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
		local spell_pos = StringToVector(keys.spell_pos)
        self.direction = (  pos_caster - pos_target ):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		local x = spell_pos.x - pos_target.x
		local y = spell_pos.y - pos_target.y
		self.d = math.sqrt(x*x+y*y)
		--LV5解锁重力场
		if self.advanced_level>=5 then
		self.gain = -0.0025*self.d + 5.5
		if self.gain > 5 then
			self.gain = 5
		elseif self.gain < 1 then
			self.gain = 1
		end
	
	else
		self.gain = -0.0025*self.d + 3.25
		if self.gain > 3 then
			self.gain = 3
		elseif self.gain < 1 then
			self.gain = 1
		end
	end

	self.cast_speed = 0
	--LV15解锁重力场++
	if self.advanced_level>=15 then
		self.cast_speed = -40
	end


		self.speed = keys.speed * self.gain 
		if CalculateDistance(pos_caster,pos_target)<=50  then
			self.speed  = self.speed *0.1
		end
		local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(1)
		self.speed = self.speed*StatusResistance
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_Midnight_Pulse_motion:OnIntervalThink(keys)   
	if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end



function modifier_Advanced_Midnight_Pulse_motion:ADDeclareFunctions()
	local funcs = {
        

    }
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_CastPoint)
	end
	return funcs

end

function modifier_Advanced_Midnight_Pulse_motion:Advanced_GetModifier_CastPoint() return -40 end





modifier_Advanced_Midnight_Pulse_unlock3 = class({})

function modifier_Advanced_Midnight_Pulse_unlock3:IsHidden()	return true end
function modifier_Advanced_Midnight_Pulse_unlock3:IsDebuff()	return false end
function modifier_Advanced_Midnight_Pulse_unlock3:IsPurgable()	return false end
function modifier_Advanced_Midnight_Pulse_unlock3:IsPurgeException() return false end
function modifier_Advanced_Midnight_Pulse_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_Midnight_Pulse_unlock3:DeclareFunctions() 
    return {
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    } 
end

function modifier_Advanced_Midnight_Pulse_unlock3:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=5 then
		-- PrintTable(keys)
        local caster = self:GetParent()
		local pos = caster:GetOrigin()
		if keys.target then
			pos = keys.target:GetOrigin()
		else
			local behavior =keys.ability:GetBehaviorInt()
	
			if bit.band( behavior, DOTA_ABILITY_BEHAVIOR_POINT  ) == DOTA_ABILITY_BEHAVIOR_POINT  then
				pos = keys.ability:GetCursorPosition()
			end
		end
		CreateModifierThinker(caster, self:GetAbility(), "modifier_Advanced_Midnight_Pulse_thinker", {duration = RandomFloat(1, 3),unlock3=1}, pos, caster:GetTeamNumber(), false)

      
    end
  
    
end