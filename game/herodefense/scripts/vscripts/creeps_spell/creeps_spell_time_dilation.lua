creeps_spell_time_dilation = class({})

LinkLuaModifier("modifier_creeps_spell_time_dilation_debuff", "creeps_spell/creeps_spell_time_dilation", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_time_dilation:IsHiddenWhenStolen() 		return false end
function creeps_spell_time_dilation:IsRefreshable() 			return true end
function creeps_spell_time_dilation:IsStealable() 				return true end
function creeps_spell_time_dilation:IsNetherWardStealable()		return true end
-- function creeps_spell_time_dilation:GetIntrinsicModifierName() return "modifier_creeps_spell_time_dilation_debuff" end


function creeps_spell_time_dilation:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_dialate.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_dialate_debuff.vpcf", context )

	
end


Spell_sound = {
	"faceless_void_fv_arc_ability_time_dilation_01",
	"faceless_void_fv_arc_ability_time_dilation_02",
	"faceless_void_fv_arc_ability_time_dilation_03",
	"faceless_void_fv_arc_ability_time_dilation_04",
	"faceless_void_fv_arc_ability_time_dilation_05",
	"faceless_void_fv_arc_ability_time_dilation_06",
	"faceless_void_fv_arc_ability_time_dilation_07",
	"faceless_void_fv_arc_ability_time_dilation_08",
	"faceless_void_fv_arc_ability_time_dilation_09",
	"faceless_void_fv_arc_ability_time_dilation_10",
	"faceless_void_fv_arc_ability_time_dilation_11",
	"faceless_void_fv_arc_ability_time_dilation_12",
	"faceless_void_fv_arc_ability_time_dilation_13",
	"faceless_void_fv_arc_ability_time_dilation_14",

}



function creeps_spell_time_dilation:OnSpellStart(walk)
	-- unit identifier
	local caster = self:GetCaster()
	caster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
	local effect_name = "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_dialate.vpcf"
	-- effect_name = "particles/rebuild/creeps_spell/time_dialate_big/effect.vpcf"5
	local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )

	ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	local duration = self:GetSpecialValueFor("duration")
	for _, unit in ipairs(enemies) do
		local StatusResistance = unit:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
		unit:EmitSound("Hero_FacelessVoid.TimeDilation.Target")
		unit:AddNewModifier( caster, self, "modifier_creeps_spell_time_dilation_debuff", {duration=duration*StatusResistance} )
	end

	if not walk then
		if caster:GetUnitName()=="npc_hd_Claszian_Apostasy" then
			EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
		end
		-- EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
	end

end


modifier_creeps_spell_time_dilation_debuff = class({})

function modifier_creeps_spell_time_dilation_debuff:IsDebuff()			return true end
function modifier_creeps_spell_time_dilation_debuff:IsHidden() 			return false end
function modifier_creeps_spell_time_dilation_debuff:IsPurgable() 		    return self.isPurgeException end
function modifier_creeps_spell_time_dilation_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_time_dilation_debuff:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_dialate_debuff.vpcf" end

function modifier_creeps_spell_time_dilation_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法


	}
end


function modifier_creeps_spell_time_dilation_debuff:GetModifierAttackSpeedBonus_Constant()	return self.attack_slow*self:GetStackCount() end
function modifier_creeps_spell_time_dilation_debuff:GetModifierMoveSpeedBonus_Percentage()	return self.move_slow*self:GetStackCount() end


function modifier_creeps_spell_time_dilation_debuff:OnCreated()
	local ability = self:GetAbility()
	self.attack_slow = -ability:GetSpecialValueFor("attack_slow")
	self.move_slow = -ability:GetSpecialValueFor("move_slow")
	self.isPurgeException = true
	if IsServer() then
		if self:GetCaster().pattern_2 then
			self.isPurgeException = false
		end
		self.interval = FrameTime()*2
		self.cooldown_reduce = ability:GetSpecialValueFor("slow")*0.01*self.interval
		self:StartIntervalThink(self.interval)
		self.timer = GameRules:GetGameTime()
	end
end
-- function modifier_creeps_spell_time_dilation_debuff:OnDestroy()
-- 	if IsServer() then
		
-- 	end
-- end

function modifier_creeps_spell_time_dilation_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local stack = 0
	for i=0, 15 do
		local Ability = parent:GetAbilityByIndex(i)
		if Ability ~= nil and not Ability:IsCooldownReady() then
			local newCooldown = Ability:GetCooldownTimeRemaining() +self.cooldown_reduce
			Ability:StartCooldown(newCooldown)
			stack = stack + 1
			-- Ability:EndCooldown()
			-- if newCooldown>=0 then
			-- 	Ability:StartCooldown(newCooldown)
			-- end
		end
	end
	self:SetStackCount(stack)
	if GameRules:GetGameTime()>=self.timer then
		self.timer = GameRules:GetGameTime()+1
		if stack<=0 then
			return
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local damageTable = {
			victim = parent,
			attacker = caster,
			damage = ability:GetSpecialValueFor("damage")*caster:GetDamageMax()*self:GetStackCount(),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
		ApplyDamage(damageTable)
	end
end

function modifier_creeps_spell_time_dilation_debuff:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) < 2 then
		return
	end
	self:SetDuration(self:GetRemainingTime()+3, true)
	Timers:CreateTimer(1.3, function()
		if not keys.ability or keys.ability:IsNull() then
			return
		end
		
		local newCooldown = keys.ability:GetCooldownTimeRemaining() *1.5
		-- ability:EndCooldown()
		if newCooldown>=0 then
			keys.ability:StartCooldown(newCooldown)
		end
	end)

end

