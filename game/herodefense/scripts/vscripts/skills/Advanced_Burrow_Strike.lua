
Advanced_Burrow_Strike = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Burrow_Strike_caster_motion", "skills/Advanced_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Burrow_Strike_target_motion", "skills/Advanced_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Burrow_Strike_target_motion2", "skills/Advanced_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Burrow_Strike_unlock1", "skills/Advanced_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Burrow_Strike_target_passtive", "skills/Advanced_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
function Advanced_Burrow_Strike:IsHiddenWhenStolen() 	return false end
function Advanced_Burrow_Strike:IsRefreshable() 		return true end
function Advanced_Burrow_Strike:IsStealable() 			return true end
function Advanced_Burrow_Strike:IsNetherWardStealable()	return true end
-- function Advanced_Burrow_Strike:GetCastRange() return self:GetSpecialValueFor("tooltip_range") end
require('internal/timers')   --计时器功能

function Advanced_Burrow_Strike:CheckKV(key)
	local table = {
		damage = 4,
		bonus_damage = 0.04,






	}
	local value = table[key] or -1
	return value

end
function Advanced_Burrow_Strike:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Burrow_Strike_unlock1",{})
	return true
end
function Advanced_Burrow_Strike:UnlockSecondCore(key)
	return true
end
function Advanced_Burrow_Strike:UnlockThirdCore(key)
	return true
end
function Advanced_Burrow_Strike:GetCastRange(location , target)
	if IsServer() then return 30000 end
	if IsClient() then
		local caster = self:GetCaster()
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end

function Advanced_Burrow_Strike:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_pos =caster:GetAbsOrigin()
	local direction = (pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus()
	local speed = self:GetSpecialValueFor("burrow_speed")
	
	local pos = ((pos - caster_pos):Length2D() <= range) and pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_Advanced_Burrow_Strike_caster_motion", {duration = duration, direction_x = direction.x, direction_y = direction.y, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:StartGesture(ACT_DOTA_SAND_KING_BURROW_IN)
	caster:EmitSound("Ability.SandKing_BurrowStrike")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:ReleaseParticleIndex(pfx)

    local fDis =( pos -caster_pos):Length2D()
    local vE = caster_pos + direction * fDis
	local damage = self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("bonus_damage"))*caster:HDGetPrimaryStatValue()
	--LV10解锁裂地+

	if self.unlock2 then
		local count = 8
		Timers:CreateTimer(5, function()
			if self and not self:IsNull() then
				self:SpellApplyEffect(pos,caster_pos,vE,damage)
				count = count - 1
				if count>0 then
					return 5 
				end
				
			end
		end)
	else
		local random = math.random
		if self.advanced_level>=10 then
			if 50 >= random(1,100) then
				Timers:CreateTimer(3, function()
					if self and not self:IsNull() then
						self:SpellApplyEffect(pos,caster_pos,vE,damage)
					end
				end)
			end
			if 15 >= random(1,100) then
				Timers:CreateTimer(9, function()
					if self and not self:IsNull()  then
						self:SpellApplyEffect(pos,caster_pos,vE,damage)
					end
				end)
			end
		end
		
		Timers:CreateTimer(self:GetSpecialValueFor("delay"), function()
			if self and not self:IsNull()  then
				self:SpellApplyEffect(pos,caster_pos,vE,damage)
			end
		end)
	end
	


	--LV15解锁地址裂缝
	if self.advanced_level>=15  then
		local fDis =( pos -caster_pos):Length2D()
		local vE = caster_pos + direction * fDis*2
		self:SpellApplyEffect(pos,vE,pos,damage)
	end

	if self.advanced_level>=20 then
		local range = caster:GetCastRangeBonus() +self:GetCastRange()
		for i = 1, 1, 1 do
			local vE = caster_pos + Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)* RandomInt(200, range)
			self:SpellApplyEffect(pos,vE,pos,damage)
		end
	end

end


function Advanced_Burrow_Strike:SpellApplyEffect(pos,caster_pos,vE,damage)
	if self:IsNull() then
		return
	end
	local caster = self:GetCaster()

	caster:EmitSound("Ability.SandKing_BurrowStrike")
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_pos, vE, nil, self:GetSpecialValueFor("burrow_width"),
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local air_time = self:GetSpecialValueFor("air_time")
	for _, enemy in pairs(tTargets) do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.3)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_Advanced_Burrow_Strike_target_motion", {duration = air_time*StatusResistance, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})

		local damageTable = {
									victim = enemy,
									attacker = caster,
									damage = damage,
									damage_type = self:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									}
		ApplyDamage(damageTable)
	end
end


modifier_Advanced_Burrow_Strike_caster_motion = class({})

function modifier_Advanced_Burrow_Strike_caster_motion:IsDebuff()					return false end
function modifier_Advanced_Burrow_Strike_caster_motion:IsHidden() 				return true end
function modifier_Advanced_Burrow_Strike_caster_motion:IsPurgable() 				return false end
function modifier_Advanced_Burrow_Strike_caster_motion:IsPurgeException() 		return false end
function modifier_Advanced_Burrow_Strike_caster_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Advanced_Burrow_Strike_caster_motion:IsMotionController() return true end
function modifier_Advanced_Burrow_Strike_caster_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Burrow_Strike_caster_motion:OnCreated(keys)
	if IsServer() then
		self.direction = Vector(keys.direction_x, keys.direction_y, 0)
		self.hitted = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.width = self:GetAbility():GetSpecialValueFor("burrow_width")
		self.air_time = self:GetAbility():GetSpecialValueFor("air_time")
		self.stun_time = self:GetAbility():GetSpecialValueFor("burrow_duration")
		self.speed = self:GetAbility():GetSpecialValueFor("burrow_speed")
		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.advanced_level = self.ability.advanced_level
		-- if self.ability.unlock3 then
		-- 	self.caustic_finale = self.caster:FindAbilityByName("Advanced_Caustic_Finale")
		-- end
		self.damage = self.ability:GetSpecialValueFor("damage") + (self.ability:GetSpecialValueFor("bonus_damage"))*self.caster:HDGetPrimaryStatValue()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Burrow_Strike_caster_motion:OnIntervalThink()
	local distance = self.speed / (1.0 / FrameTime())
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	next_pos.z = next_pos.z - 100
	self:GetParent():SetOrigin(next_pos)


	-- if self.caustic_finale and not self.caustic_finale:IsNull() then
		
	-- end
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			table.insert(self.hitted, enemy)
			if not enemy:TriggerStandardTargetSpell(self.ability) then
				local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex(0.3)
				local StatusResistance = enemy:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
				enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Burrow_Strike_target_motion", {duration = self.air_time*StatusResistance, pos_x = self.pos.x, pos_y = self.pos.y, pos_z = self.pos.z})
				-- enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_time})
				local damageTable = {
									victim = enemy,
									attacker = self.caster,
									damage = self.damage,
									damage_type = self.ability:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self.ability, --Optional.
									}
				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_Advanced_Burrow_Strike_caster_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self.pos, true)
		self.pos = nil
		self:GetParent():RemoveGesture(ACT_DOTA_SAND_KING_BURROW_IN)
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_SAND_KING_BURROW_OUT, 3.0)
		self.hitted = nil
		self.width = nil
		self.air_time = nil
		self.stun_time = nil
		self.speed = nil
		self.ability = nil
		self.caster = nil
	end
end

modifier_Advanced_Burrow_Strike_target_motion = class({})

function modifier_Advanced_Burrow_Strike_target_motion:IsDebuff()				return true end
function modifier_Advanced_Burrow_Strike_target_motion:IsHidden() 			return true end
function modifier_Advanced_Burrow_Strike_target_motion:IsPurgable() 			return false end
function modifier_Advanced_Burrow_Strike_target_motion:IsPurgeException() 	return true end
function modifier_Advanced_Burrow_Strike_target_motion:IsStunDebuff() 		return true end
function modifier_Advanced_Burrow_Strike_target_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Burrow_Strike_target_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Advanced_Burrow_Strike_target_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_Advanced_Burrow_Strike_target_motion:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Advanced_Burrow_Strike_target_motion:IsMotionController() return true end
function modifier_Advanced_Burrow_Strike_target_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Burrow_Strike_target_motion:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		self.advanced_level = self:GetAbility().advanced_level
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end

function modifier_Advanced_Burrow_Strike_target_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("air_height")
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Advanced_Burrow_Strike_target_motion:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent or parent:IsNull() then
			return
		end
		FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
	
		--掩埋

		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.7)
		local StatusResistance =parent:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
		local duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance
		--LV5解锁掩埋+
		if self.advanced_level>=5 then
			duration = math.max(duration, 1)
		end
		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Burrow_Strike_target_motion2", {duration = duration})
		self.pos = nil
		self.distance = nil 
	end
end



modifier_Advanced_Burrow_Strike_target_motion2 = advanced_modifier({})

function modifier_Advanced_Burrow_Strike_target_motion2:IsDebuff()				return true end
function modifier_Advanced_Burrow_Strike_target_motion2:IsHidden() 			return false end
function modifier_Advanced_Burrow_Strike_target_motion2:IsPurgable() 			return false end
function modifier_Advanced_Burrow_Strike_target_motion2:IsPurgeException() 	return false end
function modifier_Advanced_Burrow_Strike_target_motion2:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end
function modifier_Advanced_Burrow_Strike_target_motion2:OnCreated(keys)
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if self.level >= 5 then
		self.armor = 7
	end
end
function modifier_Advanced_Burrow_Strike_target_motion2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_Advanced_Burrow_Strike_target_motion2:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.armor
end




modifier_Advanced_Burrow_Strike_unlock1 = class({})

function modifier_Advanced_Burrow_Strike_unlock1:IsDebuff()			return false end
function modifier_Advanced_Burrow_Strike_unlock1:IsHidden() 			return true end
function modifier_Advanced_Burrow_Strike_unlock1:IsPurgable() 			return false end
function modifier_Advanced_Burrow_Strike_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Burrow_Strike_unlock1:RemoveOnDeath() 	return false end
function modifier_Advanced_Burrow_Strike_unlock1:OnCreated(keys)

	if IsServer() then
		self:StartIntervalThink(3)
	end
end
function modifier_Advanced_Burrow_Strike_unlock1:OnIntervalThink(keys)
	local caster = self:GetCaster()
	if caster:IsAlive() then
		local ability = self:GetAbility()
		local range = caster:GetCastRangeBonus() +ability:GetCastRange(caster:GetAbsOrigin(), nil)
		local caster_pos = caster:GetOrigin()
		local damage = ability:GetSpecialValueFor("damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:HDGetPrimaryStatValue()
		for i = 1, 3, 1 do
			local vE = caster_pos + Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)* RandomInt(200, range)
			local start = caster_pos + Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)* RandomInt(200, range)
			ability:SpellApplyEffect(start,vE,start,damage)
		end
	end
end