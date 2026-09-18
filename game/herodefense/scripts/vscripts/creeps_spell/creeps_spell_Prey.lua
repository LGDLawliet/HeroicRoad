creeps_spell_Prey									= class({})

LinkLuaModifier("modifier_creeps_spell_Prey", "creeps_spell/creeps_spell_Prey",LUA_MODIFIER_MOTION_HORIZONTAL)

LinkLuaModifier("modifier_creeps_spell_Prey_charge", "creeps_spell/creeps_spell_Prey", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Prey_debuff", "creeps_spell/creeps_spell_Prey", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Prey:IsHiddenWhenStolen() 		return false end
function creeps_spell_Prey:IsRefreshable() 			return true end
function creeps_spell_Prey:IsStealable() 				return true end
function creeps_spell_Prey:IsNetherWardStealable()		return true end


-- function creeps_spell_Prey:GetCastRange(location, target)
-- 	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_creeps_spell_Prey_cast_range")
-- end

function creeps_spell_Prey:OnSpellStart()
	if not IsServer() then 
		return 
	end
	
	self:GetCaster():EmitSound("Hero_Huskar.Life_Break")
	self:GetCaster():Purge(false, true, false, false, false)  --弱驱散
	self.triger = 0
	local life_break_charge_max_duration = self:GetSpecialValueFor("delay")
	self.target = self:GetCursorTarget()
	-- if self.target:TriggerSpellAbsorb(self) then
	-- 	return nil
	-- end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Prey_charge", {duration=life_break_charge_max_duration,ent_index = self:GetCursorTarget():GetEntityIndex()})

end

function creeps_spell_Prey:OnChannelThink(flInterval)
	if self.stack == nil then
		self.stack = 0
	end
	self.stack = (GameRules:GetGameTime() - self:GetChannelStartTime()) * 100
	--检测到从modifier传过来的背对触发，立即结束施法
	if self.triger==1 then 
		self:EndChannel(true)
	end
end

function creeps_spell_Prey:GetStack(flInterval)
	if self.stack == nil then
		self.stack = 0
	end
	return self.stack
end

function creeps_spell_Prey:SetTriger(flInterval)
	self.triger = 1
end


function creeps_spell_Prey:OnChannelFinish(judge)
	if self.stack==nil then
		self.stack = 500
	end
	if self.stack > 490 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Prey", {damage_index=1,ent_index = self.target:GetEntityIndex()})
	elseif self.triger == 1 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Prey", {damage_index=2,ent_index = self.target:GetEntityIndex()})
	end
end

modifier_creeps_spell_Prey = class({})

function modifier_creeps_spell_Prey:IsHidden()		return false end
function modifier_creeps_spell_Prey:IsPurgable()	return false end
function modifier_creeps_spell_Prey:IsPurgeException() 	return false end
function modifier_creeps_spell_Prey:OnCreated(params)
	self.ability	= self:GetAbility()
	self.caster		= self.ability:GetCaster()
	self.parent		= self:GetParent()

	-- AbilitySpecials

	

	self.charge_speed			= 1500
	self.damage_index = params.damage_index

	if not IsServer() then return end
	self.damage = self.ability:GetSpecialValueFor("damage") * self.caster:GetBaseDamageMax() * params.damage_index
	self.target			= EntIndexToHScript(params.ent_index)
	self.break_range	= 1450

	-- Begin the motion controller
	-- self:ApplyHorizontalMotionController()
	-- self:ApplyHorizontalMotionController()
	if self:ApplyHorizontalMotionController() == false then
		self:SafeDestroy()
	end
end

function modifier_creeps_spell_Prey:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	if not self.target or self.target:IsNull() then
		self:SafeDestroy()
		return
	end

	me:FaceTowards(self.target:GetOrigin())

	local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
	me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
	
	-- IDK aribtrary numbers again
	if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self.break_range or self.parent:IsHexed() or self.parent:IsNightmared() or self.parent:IsStunned() then
		self:SafeDestroy()
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_creeps_spell_Prey:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end

function modifier_creeps_spell_Prey:OnDestroy()
	if not IsServer() then return end

	if self.parent and not self.parent:IsNull() then
		self.parent:RemoveHorizontalMotionController( self )
	else
		return
	end
	if not self.target or self.target:IsNull() or not self.ability or self.ability:IsNull() then
		return
	end
	

	-- Assumption is that if the caster's within range when the modifier is destroyed, then the cast landed 
	-- (probably some extreme edge cases but like come on now)
	if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() <= 128 then
		-- Do nothing else if blocked
		-- if self.target:TriggerSpellAbsorb(self.ability) then
		-- 	return nil
		-- end
		self.target:EmitSound("Hero_Huskar.Life_Break.Impact")

		-- Emit particle

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)


		local damageTable_enemy = {
			victim 			= self.target,
			attacker 		= self.parent,
			damage 			= self.damage,
			damage_type 	= self.ability:GetAbilityDamageType(),
			ability 		= self.ability,
			damage_flags	= DOTA_DAMAGE_FLAG_NONE
		}
		ApplyDamage(damageTable_enemy)
	
		-- Apply the slow modifier
		-- self.target:AddNewModifier(self.parent, self.ability, "modifier_creeps_spell_Prey_slow", {duration = duration})
		
		-- This is optional I guess but it replicates vanilla Life Break being reflected by Lotus Orb a bit closer (cause the target starts attacking you)
		self.parent:MoveToTargetToAttack( self.target )
		if self.damage_index ~= 1 then
			local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
			local StatusResistance = self.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_creeps_spell_Prey_debuff", {duration=self.ability:GetSpecialValueFor("duration")*StatusResistance})
		end
		
	end
end

--------------------------------
-- LIFE BREAK CHARGE MODIFIER --
--------------------------------

--"This modifier turns him spell immune, disarms him, forces him to face the target and is responsible for the leap animation."
-- I'm gonna put the "forces him to face the target" in the other modifier cause it seems to make sense to just deal with that logic in the motion controller
modifier_creeps_spell_Prey_charge					= class({})
function modifier_creeps_spell_Prey_charge:IsHidden()		return false end
function modifier_creeps_spell_Prey_charge:IsPurgable()	return false end

-- function modifier_creeps_spell_Prey_charge:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
-- 		[MODIFIER_STATE_DISARMED] = true,
-- 	}

-- 	return state
-- end

function modifier_creeps_spell_Prey_charge:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }

    return decFuncs
end

function modifier_creeps_spell_Prey_charge:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end


function modifier_creeps_spell_Prey_charge:OnCreated(keys)
	if IsServer() then
		self.target	= EntIndexToHScript(keys.ent_index)
		self:StartIntervalThink(0.1)
	end
end


function modifier_creeps_spell_Prey_charge:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local target = self.target
		self:GetParent():FaceTowards(self.target:GetOrigin())
		local victim_angle = target:GetAnglesAsVector().y
		--求得攻击者与受害者所成直线与坐标轴所成角度而不是单纯攻击者的角度
		local origin_difference =  parent:GetAbsOrigin() - target:GetAbsOrigin() 
		local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
		origin_difference_radian = origin_difference_radian * 180
		local attacker_angle = origin_difference_radian / math.pi
		--用反三角函数求得弧度，再求得角度
		--此时求得的范围是-180-180  所以为了一致需要加上180
		attacker_angle = attacker_angle + 180.0

		--由于可能出现一个角度是1° 另外一个是350°的情况，为了正确计算需要为其增加一个派
		if attacker_angle<180 then
			attacker_angle = attacker_angle + 360	
		end
		if victim_angle<180 then
			victim_angle = victim_angle + 360	
		end
		--计算两角度差并取绝对值
		local result_angle = attacker_angle - victim_angle
		result_angle = math.abs(result_angle)
		--暂且将逃离角度设定为60°好了
		local back_chance = 60
		--这个角度又左右60°，因此合计是120°
		--目标逃逸，触发捕食

		if result_angle <= back_chance then
	
			self:GetAbility():SetTriger()
			self:SafeDestroy()

		end
	end
end


modifier_creeps_spell_Prey_debuff = class({})

function modifier_creeps_spell_Prey_debuff:IsDebuff()			return true end
function modifier_creeps_spell_Prey_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Prey_debuff:IsPurgable() 		return true end
function modifier_creeps_spell_Prey_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_Prey_debuff:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_creeps_spell_Prey_debuff:GetModifierMoveSpeedBonus_Percentage() 
    if self:GetAbility() ~= nil then
        return (0 - self:GetAbility():GetSpecialValueFor("move_slow"))
    else
        return -40
    end
end
function modifier_creeps_spell_Prey_debuff:GetModifierAttackSpeedBonus_Constant() 
    if self:GetAbility() ~= nil then
        return (0 - self:GetAbility():GetSpecialValueFor("attack_slow"))
    else
        return -50
    end
end



