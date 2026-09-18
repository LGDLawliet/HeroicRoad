Advanced_Chronosphere = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Chronosphere_thinker", "skills/Advanced_Chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chronosphere_debuff", "skills/Advanced_Chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chronosphere_unlock1", "skills/Advanced_Chronosphere", LUA_MODIFIER_MOTION_NONE)
function Advanced_Chronosphere:IsHiddenWhenStolen() 		return false end
function Advanced_Chronosphere:IsRefreshable() 			return false  end
function Advanced_Chronosphere:IsStealable() 				return true  end
function Advanced_Chronosphere:IsNetherWardStealable() 	return true end
function Advanced_Chronosphere:CheckKV(key)
	local table = {
		base_duration =0.1,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Chronosphere:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Chronosphere_unlock1",{})
	return true
end
function Advanced_Chronosphere:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_Chronosphere:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end
function Advanced_Chronosphere:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chronosphere/unlock1/effect_jewel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", context )
end


--设置作用范围
function Advanced_Chronosphere:GetAOERadius() 
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local extra_radius_index = self:GetSpecialValueFor("extra_radius")
	--LV5解锁时间领主+
	if advanced_level>=5 then
		extra_radius_index = extra_radius_index *1.5
	end
	local radius = self:GetCaster():GetAgility() * extra_radius_index
	radius = math.min(radius,1000)
	return self:GetSpecialValueFor("base_radius") + radius
end
--------------------------------------------------------------------------------------------------------------
function Advanced_Chronosphere:OnSpellStart(pos)
	if self:FindTalent4() then
		return
	end
	local caster = self:GetCaster()
	local pos = pos or self:GetCursorPosition()
	local radius = self:GetAOERadius()
	--caster:SpendMana(caster:GetMana(), self)

	local extra_radius_index = self:GetSpecialValueFor("extra_radius")
	--LV5解锁时间领主+
	if self.advanced_level>=5 then
		extra_radius_index = extra_radius_index *1.5
	end

	local bonus_time = self:GetCaster():GetAgility() * extra_radius_index
	if bonus_time > 1000 then 
		bonus_time = (bonus_time - 1000) / 100
	else
		bonus_time = 0
	end
	bonus_time = math.min(bonus_time,6)
	local time = self:GetSpecialValueFor("base_duration")+ bonus_time
	local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbilityName())
	if type=="ability_particle_11" then
		time = time +1
	end

	local thinker = self:CreateChronosphere(caster, pos, radius, time, 1)
	thinker:EmitSound("Hero_FacelessVoid.Chronosphere")
end
function Advanced_Chronosphere:CreateChronosphere(caster, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	local ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_Advanced_Chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	thinker.chronosphere_modifier = thinker:FindModifierByName("modifier_Advanced_Chronosphere_thinker")
	return thinker
end


function Advanced_Chronosphere:FindTalent4()
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
modifier_Advanced_Chronosphere_thinker = class({})

function modifier_Advanced_Chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_11" then
			caster:EmitSound("dio_world")
			pfx_name = "particles/dev/the_world.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
			self:AddParticle(pfx, false, false, 16, false, false)
			pfx_name = "particles/rebuild/spell/chronoshere/effect2/faceless_void_chronosphere.vpcf"
		end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)





	end
end

function modifier_Advanced_Chronosphere_thinker:IsAura() 
	if not self:GetAbility() then
		return false
	end
	return true 
end
-- function modifier_Advanced_Chronosphere_thinker:GetAuraDuration() return 0 end
function modifier_Advanced_Chronosphere_thinker:GetModifierAura() return "modifier_Advanced_Chronosphere_debuff" end
function modifier_Advanced_Chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_Advanced_Chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Advanced_Chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Advanced_Chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Chronosphere_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() and unit:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID()  then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end

function modifier_Advanced_Chronosphere_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end


function modifier_Advanced_Chronosphere_thinker:InitFVTalent4(duration,max_duration)
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







modifier_Advanced_Chronosphere_debuff = advanced_modifier({})
--
--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5

function modifier_Advanced_Chronosphere_debuff:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	self.advanced_level = ability:GetSpecialValueFor("advanced_level")

	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then

		self.buff_type = Chronosphere_Caster
		if IsServer() then
			if ability.unlock2 then
				self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chronosphere/unlock1/effect_jewel.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
				ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil,caster:GetAbsOrigin(), true )
				self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	
			end
			if ability.unlock3 then
				self:StartIntervalThink(0.1)
			end

		
		end

	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self.advanced_level<15 then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self.advanced_level>=15 then
		self.buff_type = Chronosphere_Ally_Scepter
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self:GetParent():HasModifier("modifier_Advanced_Chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_Advanced_Chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy_Ability
	else
		self.buff_type = Chronosphere_Enemy
	end
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		-- self:StartIntervalThink(FrameTime())
	end


	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	--LV10解锁超维度+
	if self.advanced_level>=10 then
		self.bonus_as = self.bonus_as *1.5
	end




end

function modifier_Advanced_Chronosphere_debuff:OnIntervalThink()

	-- self:GetParent():InterruptMotionControllers(false)
	-- self:GetParent():SetOrigin(self.abs)
	local parent = self:GetParent()
	if parent:IsAlive() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if enemies~=nil then
			for _, unit in ipairs(enemies) do
				-- particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex,1,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex,4,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt(nFXIndex, 2, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", parent:GetAbsOrigin(), true)
				-- ParticleManager:SetParticleControl(nFXIndex, 2, Vector(1,0,0))
				ParticleManager:ReleaseParticleIndex(nFXIndex)
				parent:EmitSound("Hero_FacelessVoid.TimeLockImpact")
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
				local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				parent:PerformAttack(unit, false, true, true, true, false, false, true)--对一单位执行攻击。
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				break
			end
		
		end
	end

end

function modifier_Advanced_Chronosphere_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_Advanced_Chronosphere_debuff:IsHidden() 			return false end
function modifier_Advanced_Chronosphere_debuff:IsPurgable() 			return false end
function modifier_Advanced_Chronosphere_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_Advanced_Chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Advanced_Chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_Advanced_Chronosphere_debuff:IsMotionController() 
	-- local ability = self:GetAbility()
	-- local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	-- self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	--LV15解锁同化
	if self.advanced_level>=15 then
		return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally or self.buff_type == Chronosphere_Enemy_Ability) 
	end
	return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) 
end
function modifier_Advanced_Chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_Advanced_Chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Advanced_Chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_Advanced_Chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_Advanced_Chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_Advanced_Chronosphere_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	 MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
	 MODIFIER_EVENT_ON_ATTACK_LANDED,
	--  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
	}
	
end
-- function modifier_Advanced_Chronosphere_debuff:GetModifierTotalDamageOutgoing_Percentage()
-- 	--LV20解锁无力化
-- 	if self.buff_type == Chronosphere_Enemy and IsServer() and self:GetAbility().advanced_level>=20 then
-- 		return -100
-- 	end
-- end

-- advanced_modifier
function modifier_Advanced_Chronosphere_debuff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	return funcs

end
function modifier_Advanced_Chronosphere_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if self.buff_type == Chronosphere_Enemy and IsServer() and self:GetAbility().advanced_level>=20 then
		return -90
	end
end


function modifier_Advanced_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if self.buff_type == Chronosphere_Caster then
		if IsServer() and ability.unlock2 then
			return 10000
		end
		return ability:GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return 100
	end
end

function modifier_Advanced_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if self.buff_type == Chronosphere_Caster then
		if IsServer() and ability.unlock2 then
			return 10000
		end
		return ability:GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return 0
	end
end

function modifier_Advanced_Chronosphere_debuff:GetModifierTurnRate_Percentage()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if self.buff_type == Chronosphere_Ally_Scepter then
		return (0 -ability:GetSpecialValueFor("slow_scepter"))
	else
		return nil
	end
end

function modifier_Advanced_Chronosphere_debuff:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if self.buff_type == Chronosphere_Caster then
		if ability:GetUnlock(2)==2 then
			return (self:GetStackCount() *self.bonus_as) +5000
		end
		return (self:GetStackCount() *self.bonus_as)
	else
		return nil
	end
end

function modifier_Advanced_Chronosphere_debuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if keys.attacker ~= self:GetCaster() or ability ~= self:GetParent():FindAbilityByName("Advanced_Chronosphere") then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:HasModifier("modifier_Advanced_Chronosphere_debuff") or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
end








modifier_Advanced_Chronosphere_unlock1 = advanced_modifier({})

function modifier_Advanced_Chronosphere_unlock1:IsDebuff()			return false end
function modifier_Advanced_Chronosphere_unlock1:IsHidden() 			return true end
function modifier_Advanced_Chronosphere_unlock1:IsPurgable() 		    return false end
function modifier_Advanced_Chronosphere_unlock1:IsPurgeException() return false end
function modifier_Advanced_Chronosphere_unlock1:RemoveOnDeath() return false end

function modifier_Advanced_Chronosphere_unlock1:Advanced_GetModifierIncomingDamage_Percentage( keys )
	if not IsServer() then
		return
	end
	-- if keys.target~=self:GetParent() then return end
    local parent = keys.target
    if keys.damage >= parent:GetHealth()   then
        local ability = self:GetAbility()
		if not ability:IsCooldownReady() then
			return 0
		end
		local radius = ability:GetAOERadius()
		local thinker = ability:CreateChronosphere(parent, parent:GetOrigin(), radius, 3, 1)
		thinker:EmitSound("Hero_FacelessVoid.Chronosphere")
		ability:StartCooldown(10)
		parent:EmitSound("killer_queen")
		parent:AddNewModifier(parent,ability,"modifier_Advanced_Chronosphere_unlock1_bonus",{duration = 0.5})
        return -100
    end
end

function modifier_Advanced_Chronosphere_unlock1:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end






modifier_Advanced_Chronosphere_unlock1_bonus = advanced_modifier({})

function modifier_Advanced_Chronosphere_unlock1_bonus:IsDebuff()			return false end
function modifier_Advanced_Chronosphere_unlock1_bonus:IsHidden() 			return true end
function modifier_Advanced_Chronosphere_unlock1_bonus:IsPurgable() 		    return false end
function modifier_Advanced_Chronosphere_unlock1_bonus:IsPurgeException() return false end
function modifier_Advanced_Chronosphere_unlock1_bonus:RemoveOnDeath() return false end

function modifier_Advanced_Chronosphere_unlock1_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,   	   --受到伤害增加
	}
	return funcs
end
function modifier_Advanced_Chronosphere_unlock1_bonus:Advanced_GetModifierIncomingDamage_Percentage( keys )

    return -100

end

function modifier_Advanced_Chronosphere_unlock1_bonus:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




