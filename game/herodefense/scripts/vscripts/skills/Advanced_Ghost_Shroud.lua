--特效优化 √
Advanced_Ghost_Shroud = Advanced_Ghost_Shroud or class({})
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_active", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_aura", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_aura_debuff", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_buff", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_debuff", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Shroud_Despair_Aura_buff", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Ghost_Shroud_unlock1_debuff", "skills/Advanced_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
function Advanced_Ghost_Shroud:CheckKV(key)
	local table = {


	
		radius =10,
		duration = 0.1,
		slow_pct = 4,
		healing_amp_pct =1,




	}
	local value = table[key] or -1
	return value

end
function Advanced_Ghost_Shroud:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_shroud/unlock1/effect_red.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_shroud/unlock1/effect_blue.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_shroud/unlock1/effect_dark.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_c.vpcf", context )

end


function Advanced_Ghost_Shroud:UnlockFirstCore(key)
	return true
end
function Advanced_Ghost_Shroud:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end
function Advanced_Ghost_Shroud:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end



function Advanced_Ghost_Shroud:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local radius = self:GetSpecialValueFor("radius")
	if advanced_level >=20 then
		radius = radius + self:GetCaster():GetIntellect(false)*3
	end
	return radius
end
function Advanced_Ghost_Shroud:OnSpellStart()

	local caster = self:GetCaster()
	local level = self.advanced_level

	-- Params
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local healing_amp_pct = self:GetSpecialValueFor("healing_amp_pct")
	local slow_pct = self:GetSpecialValueFor("slow_pct")

	--LV20解锁领域扩展
	if level>=20 then
		radius = radius + caster:GetIntellect(false)*3
	end

	caster:EmitSound("Hero_Necrolyte.SpiritForm.Cast")

	caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
	caster:AddNewModifier(caster, self, "modifier_Advanced_Ghost_Shroud_active", { duration = duration })
	caster:AddNewModifier(caster, self, "modifier_Advanced_Ghost_Shroud_aura", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
	caster:AddNewModifier(caster, self, "modifier_Advanced_Ghost_Shroud_aura_debuff", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
	if self.unlock1 then
		self:ReleaseUnlock1()
	end
end
function Advanced_Ghost_Shroud:ReleaseUnlock1()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Lich.SinisterGaze.Cast.TI10")
	local switch = RandomInt(1, 3)
	local radius = self:GetSpecialValueFor("radius")+ caster:GetIntellect(false)*3

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local particle_name = "particles/rebuild/spell/ghost_shroud/unlock1/effect_dark.vpcf"
	if switch==1 then
		for i, enemy in pairs(enemies) do	
			enemy:AddNewModifier(caster, self, "modifier_Advanced_Ghost_Shroud_unlock1_debuff", {duration = 3})
		end
	elseif switch==2 then
		local damage_table = {
			attacker = caster,
			ability = self,
			damage = caster:GetHealth()*0.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		for i, enemy in pairs(enemies) do	
			damage_table.victim = enemy
			ApplyDamage(damage_table)
		end
		particle_name = "particles/rebuild/spell/ghost_shroud/unlock1/effect_red.vpcf"
	else
		local damage_table = {
			attacker = caster,
			ability = self,
			damage = caster:GetMaxMana()*0.3,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		for i, enemy in pairs(enemies) do	
			damage_table.victim = enemy
			ApplyDamage(damage_table)
		end
		particle_name = "particles/rebuild/spell/ghost_shroud/unlock1/effect_blue.vpcf"
	end
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(pfx, 60,Vector(radius,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
end
function Advanced_Ghost_Shroud:GetAOERadius( location , target)
	return self:GetTalentSpecialValueFor("radius")
end

function Advanced_Ghost_Shroud:IsHiddenWhenStolen()
	return false
end

---------------------------------------------
-- Ghost Shroud Active Modifier (Purgable) --
---------------------------------------------

modifier_Advanced_Ghost_Shroud_active = advanced_modifier({})

function modifier_Advanced_Ghost_Shroud_active:IsHidden() return false end
function modifier_Advanced_Ghost_Shroud_active:IsPurgable() return true end
function modifier_Advanced_Ghost_Shroud_active:IsPurgeException() return true end

function modifier_Advanced_Ghost_Shroud_active:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_Advanced_Ghost_Shroud_active:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_Advanced_Ghost_Shroud_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		

	}
end

function modifier_Advanced_Ghost_Shroud_active:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self:GetAbility():GetSpecialValueFor("magic_amp_pct") * (-1)
end

function modifier_Advanced_Ghost_Shroud_active:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end

function modifier_Advanced_Ghost_Shroud_active:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.healing_amp_pct
end

function modifier_Advanced_Ghost_Shroud_active:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.healing_amp_pct
end

function modifier_Advanced_Ghost_Shroud_active:CheckState()
	return
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end

-- ，魔免时移除状态
function modifier_Advanced_Ghost_Shroud_active:OnCreated()
	self.healing_amp_pct	= self:GetAbility():GetSpecialValueFor("healing_amp_pct")

	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())   
end
function modifier_Advanced_Ghost_Shroud_active:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			ability:ReleaseUnlock1()
		end
	end
end

function modifier_Advanced_Ghost_Shroud_active:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end
end

function modifier_Advanced_Ghost_Shroud_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end


modifier_Advanced_Ghost_Shroud_aura = class({})

function modifier_Advanced_Ghost_Shroud_aura:IsHidden() return true end
function modifier_Advanced_Ghost_Shroud_aura:IsPurgable() return true end
function modifier_Advanced_Ghost_Shroud_aura:IsPurgeException() return true end
function modifier_Advanced_Ghost_Shroud_aura:IsAura() return true end

function modifier_Advanced_Ghost_Shroud_aura:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
		self.healing_amp_pct = params.healing_amp_pct
		self.slow_pct = params.slow_pct
	end
end

function modifier_Advanced_Ghost_Shroud_aura:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

function modifier_Advanced_Ghost_Shroud_aura:StatusEffectPriority()return MODIFIER_PRIORITY_ULTRA end
function modifier_Advanced_Ghost_Shroud_aura:GetEffectAttachType()return PATTACH_POINT_FOLLOW end
function modifier_Advanced_Ghost_Shroud_aura:GetAuraEntityReject(target)if IsServer() then	return false end end
function modifier_Advanced_Ghost_Shroud_aura:GetAuraRadius()return self.radius end
function modifier_Advanced_Ghost_Shroud_aura:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Ghost_Shroud_aura:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Ghost_Shroud_aura:GetAuraSearchType()return self:GetAbility():GetAbilityTargetType() end
function modifier_Advanced_Ghost_Shroud_aura:GetModifierAura()return "modifier_Advanced_Ghost_Shroud_buff" end

------------------------------------------------
-- Ghost Shroud Positive Aura Buff (Heal Amp) --
------------------------------------------------

modifier_Advanced_Ghost_Shroud_buff = modifier_Advanced_Ghost_Shroud_buff or advanced_modifier({})

function modifier_Advanced_Ghost_Shroud_buff:IsHidden()
	if self:GetParent() == self:GetCaster() then return true end
	return false
end
function modifier_Advanced_Ghost_Shroud_buff:IsDebuff()	return false end

function modifier_Advanced_Ghost_Shroud_buff:OnCreated()

	self.healing_amp_pct = self:GetAbility():GetSpecialValueFor("healing_amp_pct")
	self.HealthRegen = 0
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	--LV10解锁阴间特效+
	if advanced_level>=10 then
		self.HealthRegen = 1
	end

	if self:GetCaster() ~= self:GetParent() then
		self.healing_amp_pct = self.healing_amp_pct * 0.5
		self.HealthRegen = self.HealthRegen *0.5
	end

end





function modifier_Advanced_Ghost_Shroud_buff:AdvancedGetModifierConstantManaRegenAmpPercentage()
return self.healing_amp_pct
end

function modifier_Advanced_Ghost_Shroud_buff:AdvancedGetModifierConstantHealthRegenAmpPercentage()
return self.healing_amp_pct
end
function modifier_Advanced_Ghost_Shroud_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.HealthRegen
end
	
function modifier_Advanced_Ghost_Shroud_buff:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,


	}
end

modifier_Advanced_Ghost_Shroud_aura_debuff = modifier_Advanced_Ghost_Shroud_aura_debuff or class({})

function modifier_Advanced_Ghost_Shroud_aura_debuff:IsHidden() return true end
function modifier_Advanced_Ghost_Shroud_aura_debuff:IsPurgable() return false end
function modifier_Advanced_Ghost_Shroud_aura_debuff:IsAura() return self:GetAbility() end

function modifier_Advanced_Ghost_Shroud_aura_debuff:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
	end
end

function modifier_Advanced_Ghost_Shroud_aura_debuff:GetAuraRadius()return self.radius end
function modifier_Advanced_Ghost_Shroud_aura_debuff:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Ghost_Shroud_aura_debuff:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Ghost_Shroud_aura_debuff:GetAuraSearchType()return self:GetAbility():GetAbilityTargetType() end
function modifier_Advanced_Ghost_Shroud_aura_debuff:GetModifierAura()return "modifier_Advanced_Ghost_Shroud_debuff" end

-------------------------------------------------------
-- Ghost Shroud Negative Aura Debuff (Movement Slow) --
-------------------------------------------------------

modifier_Advanced_Ghost_Shroud_debuff = modifier_Advanced_Ghost_Shroud_debuff or class({})

function modifier_Advanced_Ghost_Shroud_debuff:IsHidden() return false end
function modifier_Advanced_Ghost_Shroud_debuff:IsDebuff() return true end

function modifier_Advanced_Ghost_Shroud_debuff:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_Advanced_Ghost_Shroud_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	return funcs
end

function modifier_Advanced_Ghost_Shroud_debuff:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
	end
end
function modifier_Advanced_Ghost_Shroud_debuff:GetModifierMagicalResistanceBonus()
	if self:GetAbility() then
		return self.magic_resistance_reduce
	end
end
function modifier_Advanced_Ghost_Shroud_debuff:OnCreated(table)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.magic_resistance_reduce = 0
	--LV15解锁死灵之息
	if advanced_level>=15 then
		self.magic_resistance_reduce = -20
	end

	if not IsServer() then
		return
	end
	self.truekill_index = 6
	self.debuff_index = 2
	local level = self:GetAbility().advanced_level
	--LV5解锁绝望灵气+
	if level>=5 then
		self.debuff_index = 3
		self.truekill_index = 8
	end


	self.triggerTime = GameRules:GetGameTime()+RandomFloat(1, 2)
	self:StartIntervalThink(0.1)
end

function modifier_Advanced_Ghost_Shroud_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if parent:GetBaseDamageMax()<=caster:GetIntellect(false)*self.debuff_index then
		self:Retreat(caster)
		parent:AddNewModifier(caster, ability, "modifier_Advanced_Ghost_Shroud_Despair_Aura_buff", { duration = 1})
	end
	if parent:GetHealth()<=caster:GetIntellect(false)*self.truekill_index then
		parent:EmitSound("Hero_DeathProphet.Death")
		TrueKill(caster, parent, ability)
	end
	if ability.unlock3 and GameRules:GetGameTime()>= self.triggerTime then
		self.triggerTime = GameRules:GetGameTime()+RandomFloat(1, 2)
		local death_pulse = caster:FindAbilityByName("Advanced_Death_Pulse")
		if death_pulse then
			death_pulse:ReleaseProjectile(caster,parent,1)
		end
	end


end


function modifier_Advanced_Ghost_Shroud_debuff:Retreat(unit)
	local thisEntity = self:GetParent()
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 3 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos
	})

end


function modifier_Advanced_Ghost_Shroud_debuff:OnTakeDamage( keys )

	if IsServer() then

		local Target = keys.unit

		if Target ~= self:GetParent() or Target == nil then
			return 0
		end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS  ) == DOTA_DAMAGE_FLAG_HPLOSS  then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS   ) == DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS   then
			return 0
		end
		self:SetStackCount(self:GetStackCount()+keys.damage)

	end

	return 0.0

end

function modifier_Advanced_Ghost_Shroud_debuff:OnDestroy()
	if IsServer() then
		local stack = self:GetStackCount()
		if stack>=10 then
			local caster = self:GetCaster()
			local parent = self:GetParent()
			local pfx = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_c.vpcf", PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControl(pfx, 3, parent:GetOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			local damage_table = {
				victim = parent,
				attacker = caster,
				ability = self:GetAbility(),
				damage = stack,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
			}
			ApplyDamage(damage_table)
			parent:EmitSound("DOTA_Item.Orchid.Activate")
		end
	end
end


modifier_Advanced_Ghost_Shroud_Despair_Aura_buff = class({})

function modifier_Advanced_Ghost_Shroud_Despair_Aura_buff:IsHidden() return false end
function modifier_Advanced_Ghost_Shroud_Despair_Aura_buff:IsPurgable() return true end
function modifier_Advanced_Ghost_Shroud_Despair_Aura_buff:CheckState()
	return {
		[MODIFIER_STATE_FEARED]=true,
	}
end

function modifier_Advanced_Ghost_Shroud_Despair_Aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
end

function modifier_Advanced_Ghost_Shroud_Despair_Aura_buff:GetModifierMagicalResistanceDecrepifyUnique( params )
	return -30
end



modifier_Advanced_Ghost_Shroud_unlock1_debuff = class({})

function modifier_Advanced_Ghost_Shroud_unlock1_debuff:IsDebuff()			return true end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:IsHidden() 			return false end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:IsPurgable() 		return false end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Ghost_Shroud_unlock1_debuff:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end





