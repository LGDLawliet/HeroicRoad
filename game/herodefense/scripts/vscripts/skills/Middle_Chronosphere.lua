Middle_Chronosphere = class({})

LinkLuaModifier("modifier_Middle_Chronosphere_thinker", "skills/Middle_Chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Chronosphere_debuff", "skills/Middle_Chronosphere", LUA_MODIFIER_MOTION_NONE)

function Middle_Chronosphere:IsHiddenWhenStolen() 		return false end
function Middle_Chronosphere:IsRefreshable() 			return false  end
function Middle_Chronosphere:IsStealable() 				return true  end
function Middle_Chronosphere:IsNetherWardStealable() 	return true end

--------------------------------------------------------------------------------------------------------------
--设置作用范围
function Middle_Chronosphere:GetAOERadius() 
	local radius = self:GetCaster():GetAgility() * self:GetSpecialValueFor("extra_radius")
	if radius > 1000 then 
		radius = 1000
	end
	return self:GetSpecialValueFor("base_radius") + radius
	 
end
--------------------------------------------------------------------------------------------------------------
function Middle_Chronosphere:OnSpellStart(pos)
	if self:FindTalent4() then
		return
	end
	local caster = self:GetCaster()
	local pos = pos or self:GetCursorPosition()
	local radius = self:GetAOERadius()
	--caster:SpendMana(caster:GetMana(), self)
	local bonus_time = self:GetCaster():GetAgility() * self:GetSpecialValueFor("extra_radius")
	if bonus_time > 1000 then 
		bonus_time = (bonus_time - 1000) / 100
	else
		bonus_time = 0
	end
	bonus_time = math.min(bonus_time,6)
	local time = self:GetSpecialValueFor("base_duration") + bonus_time
	local thinker = self:CreateChronosphere(caster, pos, radius, time, 1)
	thinker:EmitSound("Hero_FacelessVoid.Chronosphere")
end

function Middle_Chronosphere:CreateChronosphere(caster, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	local ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_Middle_Chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	thinker.chronosphere_modifier = thinker:FindModifierByName("modifier_Middle_Chronosphere_thinker")
	return thinker
end

function Middle_Chronosphere:FindTalent4()
	-- :InitCooldown(unit)
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	for _, unit in ipairs(heroes) do
		if unit~=caster then
			local ability = unit:FindAbilityByName("heroTalent_npc_dota_hero_faceless_void_4")
			if ability then
				if ability:InitCooldown(caster) then
					return true
				end
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------
modifier_Middle_Chronosphere_thinker = class({})

function modifier_Middle_Chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_Middle_Chronosphere_thinker:IsAura() return self:GetAbility() and true end
function modifier_Middle_Chronosphere_thinker:GetAuraDuration() return 0.1 end
function modifier_Middle_Chronosphere_thinker:GetModifierAura() return "modifier_Middle_Chronosphere_debuff" end
function modifier_Middle_Chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_Middle_Chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Middle_Chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Middle_Chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_Middle_Chronosphere_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end

function modifier_Middle_Chronosphere_thinker:OnDestroy(  )

    UTIL_Remove(self:GetParent())
end


function modifier_Middle_Chronosphere_thinker:InitFVTalent4(duration,max_duration)
	if not self.fvTalent4_duration then
		self.fvTalent4_duration = 0
	end
	if self.fvTalent4_duration>=max_duration then
		return
	end
	local add_duration = 0
	if (self.fvTalent4_duration+duration)>max_duration then
		add_duration = max_duration-self.fvTalent4_duration
	else
		add_duration = duration
	end
	self.fvTalent4_duration = self.fvTalent4_duration + add_duration
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldownTimeRemaining()+add_duration)
	self:SetDuration(self:GetRemainingTime()+add_duration, false)
end



modifier_Middle_Chronosphere_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5


function modifier_Middle_Chronosphere_debuff:OnCreated()
	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then
		self.buff_type = Chronosphere_Caster
		-- print("ggo")
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally_Scepter
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self:GetParent():HasModifier("modifier_Middle_Chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_Middle_Chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy_Ability
	else
		self.buff_type = Chronosphere_Enemy
	end

	self.bonus_move = self:GetAbility():GetSpecialValueFor("chrono_ms")
	self.bonus_turn = (0 -self:GetAbility():GetSpecialValueFor("slow_scepter"))
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_Middle_Chronosphere_debuff:OnIntervalThink()

	self:GetParent():InterruptMotionControllers(false)
	self:GetParent():SetOrigin(self.abs)
end

function modifier_Middle_Chronosphere_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_Middle_Chronosphere_debuff:IsHidden() 			return false end
function modifier_Middle_Chronosphere_debuff:IsPurgable() 			return false end
function modifier_Middle_Chronosphere_debuff:IsPurgeException() 	return false end
function modifier_Middle_Chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_Middle_Chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Middle_Chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_Middle_Chronosphere_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Middle_Chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_Middle_Chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Middle_Chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_Middle_Chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_Middle_Chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_INVISIBLE] = false,
			[MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_Middle_Chronosphere_debuff:DeclareFunctions()
	-- if self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter then
	-- 	return {
	-- 		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	-- 		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, 
	-- 		 MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
	-- 	}
	-- end
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, 
	 MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
	 }
end

function modifier_Middle_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	if self.buff_type == Chronosphere_Caster then
		return self.bonus_move
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_Middle_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	if self.buff_type ==  Chronosphere_Caster then
		return self.bonus_move
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_Middle_Chronosphere_debuff:GetModifierTurnRate_Percentage()
	if self.buff_type == Chronosphere_Ally_Scepter then
		return self.bonus_turn
	else
		return nil
	end
end



