creeps_spell_Chronosphere = class({})

LinkLuaModifier("modifier_creeps_spell_Chronosphere_thinker", "creeps_spell/creeps_spell_Chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Chronosphere_debuff", "creeps_spell/creeps_spell_Chronosphere", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Chronosphere:IsHiddenWhenStolen() 		return false end
function creeps_spell_Chronosphere:IsRefreshable() 			return false  end
function creeps_spell_Chronosphere:IsStealable() 				return true  end
function creeps_spell_Chronosphere:IsNetherWardStealable() 	return true end


function creeps_spell_Chronosphere:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_chronosphere.vpcf", context )

end



--设置作用范围
function creeps_spell_Chronosphere:GetAOERadius() 
	return 300
end

function creeps_spell_Chronosphere:Spawn()
	self.bonus_time = 0
end


--------------------------------------------------------------------------------------------------------------
function creeps_spell_Chronosphere:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local radius = self:GetAOERadius()

	local min_radius = self:GetSpecialValueFor("base_radius")
	local radius = math.min(math.max(caster:GetAverageTrueAttackDamage(nil) * self:GetSpecialValueFor("radius_index")+min_radius,min_radius),self:GetSpecialValueFor("max_radius"))
	local time = self:GetSpecialValueFor("duration")+self.bonus_time

	local thinker = self:CreateChronosphere(caster, pos, radius, time, 1)
	thinker:EmitSound("Hero_FacelessVoid.Chronosphere.ti11")
	if caster.pattern_2  then
		self.bonus_time = math.min(self.bonus_time+0.5,6)
	end
end
Success_sound = {
	"faceless_void_fv_arc_ability_chronos_07",
	"faceless_void_fv_arc_ability_chronos_08",
	"faceless_void_fv_arc_ability_chronos_09",
	"faceless_void_fv_arc_ability_chronos_10",
	"faceless_void_fv_arc_ability_chronos_11",
	"faceless_void_fv_arc_ability_chronos_12",

}

Fail_sound = {
	"faceless_void_fv_arc_ability_chronos_failure_09",
	"faceless_void_fv_arc_ability_chronos_failure_10",
	"faceless_void_fv_arc_ability_chronos_failure_13",
	"faceless_void_fv_arc_ability_chronos_failure_15",
	"faceless_void_fv_arc_ability_chronos_failure_16",
}

function creeps_spell_Chronosphere:CreateChronosphere(caster, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	local ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_creeps_spell_Chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	if caster:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		if caster:GetUnitName()=="npc_hd_Claszian_Apostasy" then
			if #enemies>0 then
				local index = RandomInt(1, #Success_sound)
				EmitGlobalSound(Success_sound[index])
				-- caster:EmitSound(success_sound[RandomInt(1, #success_sound)])
			else
				EmitGlobalSound(Fail_sound[RandomInt(1, #Fail_sound)])
				-- caster:EmitSound(fail_sound[RandomInt(1, #fail_sound)])
			end
		end
		
	end
	return thinker
end



----------------------------------------------------------------------------------
modifier_creeps_spell_Chronosphere_thinker = class({})

function modifier_creeps_spell_Chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_chronosphere.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_creeps_spell_Chronosphere_thinker:IsAura() return true end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraDuration() return 0.1 end
function modifier_creeps_spell_Chronosphere_thinker:GetModifierAura() return "modifier_creeps_spell_Chronosphere_debuff" end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_creeps_spell_Chronosphere_thinker:GetAuraEntityReject(unit)
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

function modifier_creeps_spell_Chronosphere_thinker:OnDestroy(  )
    UTIL_Remove(self:GetParent())
end



modifier_creeps_spell_Chronosphere_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Enemy = 3
Chronosphere_Enemy_Void = 4
function modifier_creeps_spell_Chronosphere_debuff:OnCreated()
	self.buff_type = 0
	local parent = self:GetParent()
	if parent == self:GetCaster() or parent:GetUnitName()=="npc_hd_Claszian_Apostasy_phantom" or parent:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		self.buff_type = Chronosphere_Caster
	elseif parent:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self.buff_type = Chronosphere_Ally
	elseif parent:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.buff_type = Chronosphere_Enemy
	else
		self.buff_type = Chronosphere_Enemy
	end
	-- local name = parent:GetUnitName()
	if self.buff_type == Chronosphere_Enemy and parent:GetUnitName()=="npc_dota_hero_faceless_void" then
		if IsServer() and (parent:HasAbility("Primary_Chronosphere") or parent:HasAbility("Middle_Chronosphere") or parent:HasAbility("Advanced_Chronosphere") )then
			self.buff_type = Chronosphere_Enemy_Void
		else
			self.buff_type = Chronosphere_Enemy
		end
	end

	if IsServer() and self:IsMotionController() then
		parent:InterruptMotionControllers(false)
		self.abs = parent:GetAbsOrigin()
		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_creeps_spell_Chronosphere_debuff:OnIntervalThink()
	local parent = self:GetParent()
	parent:InterruptMotionControllers(false)
	parent:SetOrigin(self.abs)
end
Spell_Dead_sound = {
	"faceless_void_fv_arc_chronos_kill_12",
	"faceless_void_fv_arc_chronos_kill_07",
	"faceless_void_fv_arc_chronos_special_05",
	"faceless_void_fv_arc_chronos_special_07",
	"faceless_void_fv_arc_kill_12",
	"faceless_void_fv_arc_kill_17",
	"faceless_void_fv_arc_kill_20",


}

function modifier_creeps_spell_Chronosphere_debuff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if self:IsMotionController() then
			self.abs = nil
			FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
		end
	
		if _G.GAME_Faceless_Void_Online then
			if IsEnemy(self:GetCaster(),parent) and not parent:IsAlive() and parent:IsRealHero() then
				EmitGlobalSound(Spell_Dead_sound[RandomInt(1, #Spell_Dead_sound)])
			end
		end


		
	end
	self.buff_type = nil
end

function modifier_creeps_spell_Chronosphere_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Chronosphere_debuff:IsPurgable() 			return false end
function modifier_creeps_spell_Chronosphere_debuff:IsPurgeException() 	return false end
function modifier_creeps_spell_Chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_creeps_spell_Chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster) end
function modifier_creeps_spell_Chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_creeps_spell_Chronosphere_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Void) end
function modifier_creeps_spell_Chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_creeps_spell_Chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_creeps_spell_Chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_creeps_spell_Chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creeps_spell_Chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_creeps_spell_Chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_INVISIBLE] = false,
			[MODIFIER_STATE_FROZEN] = true,
			-- [MODIFIER_STATE_INVISIBLE] = false,
		}
	elseif self.buff_type == Chronosphere_Caster then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_creeps_spell_Chronosphere_debuff:DeclareFunctions()
	local parent = self:GetParent()
	if self:GetParent()==self:GetCaster() or parent:GetUnitName()=="npc_hd_Claszian_Apostasy_phantom" or parent:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		return 
		{
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	end

end

function modifier_creeps_spell_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	return 2500
end

function modifier_creeps_spell_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	return 2500
end

function modifier_creeps_spell_Chronosphere_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.buff_type == Chronosphere_Caster then
		return (self:GetStackCount() *15)
	else
		return nil
	end
end

function modifier_creeps_spell_Chronosphere_debuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if self:IsDebuff() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:HasModifier("modifier_creeps_spell_Chronosphere_debuff") or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
end



-- function modifier_creeps_spell_Chronosphere_debuff:DeclareFunctions()
-- 	if self.buff_type == Chronosphere_Caster then
-- 		return 
-- 		{
-- 			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
-- 			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
-- 		}
-- 	end

-- end


-- function modifier_creeps_spell_Chronosphere_debuff:GetModifierIgnoreMovespeedLimit() return 1 end
-- function modifier_creeps_spell_Chronosphere_debuff:GetModifierMoveSpeedBonus_Constant() return   2000 end
