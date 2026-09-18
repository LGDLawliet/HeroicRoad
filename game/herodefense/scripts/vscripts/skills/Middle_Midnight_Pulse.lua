
Middle_Midnight_Pulse = class({})

LinkLuaModifier("modifier_Middle_Midnight_Pulse_thinker", "skills/Middle_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Midnight_Pulse_motion", "skills/Middle_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)

function Middle_Midnight_Pulse:IsHiddenWhenStolen() 	return false end
function Middle_Midnight_Pulse:IsRefreshable() 		return false  end
function Middle_Midnight_Pulse:IsStealable() 			return true  end
function Middle_Midnight_Pulse:IsNetherWardStealable() return true end

function Middle_Midnight_Pulse:GetAOERadius() return self:GetSpecialValueFor("radius") end


function Middle_Midnight_Pulse:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_Middle_Midnight_Pulse_thinker", {duration = self:GetSpecialValueFor('duration')}, pos, caster:GetTeamNumber(), false)
end

modifier_Middle_Midnight_Pulse_thinker = class({})

function modifier_Middle_Midnight_Pulse_thinker:RemoveOnDeath() return true end

function modifier_Middle_Midnight_Pulse_thinker:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()

		--上值为当前的伤害倍数
		self:GetParent():EmitSound("Hero_Enigma.Midnight_Pulse")
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetAOERadius(), false)
		self:StartIntervalThink(0.25)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAbility():GetAOERadius(), self:GetAbility():GetAOERadius(), self:GetAbility():GetAOERadius()))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.count = 0
	end
end
function modifier_Middle_Midnight_Pulse_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Middle_Midnight_Pulse_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self.count = self.count + 1
	
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, ability:GetAOERadius(),
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	

	local damage = ability:GetSpecialValueFor("basic_damage") +  caster:GetIntellect(false) * ability:GetSpecialValueFor("intelligence_index")
	for i=1, #enemy do
		if self.count >= 4 then

			local damageTable = {
								victim = enemy[i],
								attacker = self:GetCaster(),
								damage = damage,
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
			enemy[i]:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Midnight_Pulse_motion", {duration = 0.3,pos = new_pos,spell_pos = spell_pos,speed = ability:GetSpecialValueFor("pull_distance")})
			if i>=10 then
				break
			end
		end
	if self.count >=4 then
		self.count = 0
	end
end

modifier_Middle_Midnight_Pulse_motion = class({})

function modifier_Middle_Midnight_Pulse_motion:IsDebuff()			return true end
function modifier_Middle_Midnight_Pulse_motion:IsHidden() 			return true end
function modifier_Middle_Midnight_Pulse_motion:IsPurgable() 		return false end
function modifier_Middle_Midnight_Pulse_motion:IsPurgeException() 	return false end
function modifier_Middle_Midnight_Pulse_motion:IsMotionController() return true end
function modifier_Middle_Midnight_Pulse_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_Middle_Midnight_Pulse_motion:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Middle_Midnight_Pulse_motion:GetModifierMoveSpeedBonus_Constant() 
	if self.gain ~= nil  then
		return self.move_slow * self.gain
	else
	return self.move_slow end end

function modifier_Middle_Midnight_Pulse_motion:OnCreated(keys)
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	if IsServer() then
			local pos_caster = StringToVector(keys.pos)
			local spell_pos = StringToVector(keys.spell_pos)
			local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
			self.direction = (pos_caster - pos_target):Normalized()
			self.direction.z = 0  --初始化Z值
			local x = spell_pos.x - pos_target.x
			local y = spell_pos.y - pos_target.y
			self.d = math.sqrt(x*x+y*y)
			self.gain = -0.0025*self.d + 3.25
			if self.gain > 3 then
				self.gain = 3
			elseif self.gain < 1 then
				self.gain = 1
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


function modifier_Middle_Midnight_Pulse_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		-- self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end
end




function modifier_Middle_Midnight_Pulse_motion:OnRefresh(keys)
    if IsServer() then
        local pos_caster = StringToVector(keys.pos)  --获取自己
		local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人

		local spell_pos = StringToVector(keys.spell_pos)
        self.direction = (  pos_caster - pos_target ):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		local x = spell_pos.x - pos_target.x
		local y = spell_pos.y - pos_target.y
		self.d = math.sqrt(x*x+y*y)
		self.gain = -0.0025*self.d + 3.25
			if self.gain > 3 then
				self.gain = 3
			elseif self.gain < 1 then
				self.gain = 1
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


function modifier_Middle_Midnight_Pulse_motion:OnIntervalThink(keys)   
	if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end