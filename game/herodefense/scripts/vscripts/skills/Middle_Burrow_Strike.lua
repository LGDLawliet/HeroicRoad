
Middle_Burrow_Strike = class({})

LinkLuaModifier("modifier_Middle_Burrow_Strike_caster_motion", "skills/Middle_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Burrow_Strike_target_motion", "skills/Middle_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Burrow_Strike_target_motion2", "skills/Middle_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_Burrow_Strike_target_passtive", "skills/Middle_Burrow_Strike", LUA_MODIFIER_MOTION_NONE)
function Middle_Burrow_Strike:IsHiddenWhenStolen() 	return false end
function Middle_Burrow_Strike:IsRefreshable() 		return true end
function Middle_Burrow_Strike:IsStealable() 			return true end
function Middle_Burrow_Strike:IsNetherWardStealable()	return true end
-- function Middle_Burrow_Strike:GetCastRange() return self:GetSpecialValueFor("tooltip_range") end
function Middle_Burrow_Strike:GetCastRange(location , target)
	if IsServer() then return 30000 end
	if IsClient() then
		local caster = self:GetCaster()
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end

function Middle_Burrow_Strike:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local range = self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus()
	local speed = self:GetSpecialValueFor("burrow_speed")
	
	local pos = ((pos - caster_pos):Length2D() <= range) and pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_Middle_Burrow_Strike_caster_motion", {duration = duration, direction_x = direction.x, direction_y = direction.y, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:StartGesture(ACT_DOTA_SAND_KING_BURROW_IN)
	caster:EmitSound("Ability.SandKing_BurrowStrike")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_Middle_Burrow_Strike_caster_motion = class({})

function modifier_Middle_Burrow_Strike_caster_motion:IsDebuff()					return false end
function modifier_Middle_Burrow_Strike_caster_motion:IsHidden() 				return true end
function modifier_Middle_Burrow_Strike_caster_motion:IsPurgable() 				return false end
function modifier_Middle_Burrow_Strike_caster_motion:IsPurgeException() 		return false end
function modifier_Middle_Burrow_Strike_caster_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Middle_Burrow_Strike_caster_motion:IsMotionController() return true end
function modifier_Middle_Burrow_Strike_caster_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Middle_Burrow_Strike_caster_motion:OnCreated(keys)
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
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Middle_Burrow_Strike_caster_motion:OnIntervalThink()
	local distance = self.speed / (1.0 / FrameTime())
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	next_pos.z = next_pos.z - 100
	self:GetParent():SetOrigin(next_pos)
	local damage = self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("bonus_damage")*self.caster:HDGetPrimaryStatValue()
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			table.insert(self.hitted, enemy)
			if not enemy:TriggerStandardTargetSpell(self.ability) then
				local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex(0.3)
				local StatusResistance = enemy:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
				enemy:AddNewModifier(self.caster, self.ability, "modifier_Middle_Burrow_Strike_target_motion", {duration = self.air_time*StatusResistance, pos_x = self.pos.x, pos_y = self.pos.y, pos_z = self.pos.z})
				-- enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_time})
				local damageTable = {
									victim = enemy,
									attacker = self.caster,
									damage = damage,
									damage_type = self.ability:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self.ability, --Optional.
									}
				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_Middle_Burrow_Strike_caster_motion:OnDestroy()
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

modifier_Middle_Burrow_Strike_target_motion = class({})

function modifier_Middle_Burrow_Strike_target_motion:IsDebuff()				return true end
function modifier_Middle_Burrow_Strike_target_motion:IsHidden() 			return true end
function modifier_Middle_Burrow_Strike_target_motion:IsPurgable() 			return false end
function modifier_Middle_Burrow_Strike_target_motion:IsPurgeException() 	return true end
function modifier_Middle_Burrow_Strike_target_motion:IsStunDebuff() 		return true end
function modifier_Middle_Burrow_Strike_target_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Middle_Burrow_Strike_target_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Middle_Burrow_Strike_target_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_Middle_Burrow_Strike_target_motion:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Middle_Burrow_Strike_target_motion:IsMotionController() return true end
function modifier_Middle_Burrow_Strike_target_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Middle_Burrow_Strike_target_motion:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
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

function modifier_Middle_Burrow_Strike_target_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("air_height")
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Middle_Burrow_Strike_target_motion:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent or parent:IsNull() then
			return
		end
		FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
	
		--掩埋
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.7)
		local StatusResistance = parent:GetHDStatusResistanceIndex(0.7)*ModifierStatusNegativeGain
		local duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance
		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Burrow_Strike_target_motion2", {duration = duration})
		self.pos = nil
		self.distance = nil 
	end
end



modifier_Middle_Burrow_Strike_target_motion2 = advanced_modifier({})

function modifier_Middle_Burrow_Strike_target_motion2:IsDebuff()				return true end
function modifier_Middle_Burrow_Strike_target_motion2:IsHidden() 			return false end
function modifier_Middle_Burrow_Strike_target_motion2:IsPurgable() 			return false end
function modifier_Middle_Burrow_Strike_target_motion2:IsPurgeException() 	return false end
function modifier_Middle_Burrow_Strike_target_motion2:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end
function modifier_Middle_Burrow_Strike_target_motion2:OnCreated(keys)
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
end
function modifier_Middle_Burrow_Strike_target_motion2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_Middle_Burrow_Strike_target_motion2:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.armor
end
