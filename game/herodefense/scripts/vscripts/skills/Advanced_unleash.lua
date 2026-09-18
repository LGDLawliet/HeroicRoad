--特效优化 √
Advanced_unleash = class({})

require('internal/timers')   --计时器功能
LinkLuaModifier( "modifier_Advanced_unleash", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_unleash_animation", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_unleash_fury", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_unleash_debuff", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_unleash_recovery", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_unleash_recovery_passive", "skills/Advanced_unleash", LUA_MODIFIER_MOTION_NONE )

function Advanced_unleash:CheckKV(key)
	local table = {
		duration=0.2,
		charges_per_flurry = 0.1


	}
	local value = table[key] or -1
	return value

end

function Advanced_unleash:UnlockFirstCore(key)
	return true
end
function Advanced_unleash:UnlockSecondCore(key)

	local caster = self:GetCaster()
	local heroes = GetAllRealHeroes()
	local pass = false
	for _, unit in ipairs(heroes) do
		if caster~=unit and unit:GetUnitName()=="npc_dota_hero_mirana" then
		
			caster:AddNewModifier(caster, self, "modifier_Advanced_unleash_recovery_passive",{} )
			unit:AddNewModifier(caster, self, "modifier_Advanced_unleash_recovery_passive",{} )
			
			pass = true
		end
	end
	if not pass then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	return true
end
function Advanced_unleash:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local heroes = GetAllRealHeroes()
	local pass = false
	for _, unit in ipairs(heroes) do
		if caster~=unit and unit:GetUnitName()=="npc_dota_hero_dragon_knight" then
			pass = true
		end
	end
	if not pass then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	return true
end




function Advanced_unleash:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/unleash/unlock2/spectre_arcana_death_dander.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", context )

end



function Advanced_unleash:OnSpellStart()
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = (self:GetSpecialValueFor( "duration" ))*gain
	caster:Purge( false, true, false, false, false )  --弱驱散
	caster:AddNewModifier(caster, self, "modifier_Advanced_unleash",{ duration = duration } )
	if self.unlock3 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD+ DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			unit:Purge( false, true, false, false, false )  --弱驱散
			unit:AddNewModifier(caster, self, "modifier_Advanced_unleash",{ duration = unit~=caster and 25 or duration } )
		end
	else
		caster:Purge( false, true, false, false, false )  --弱驱散
		caster:AddNewModifier(caster, self, "modifier_Advanced_unleash",{ duration = duration } )

	end

	if self.unlock1 then
		local pos = caster:GetAbsOrigin()
		local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf"
		local sound_cast = "Hero_Marci.Unleash.Pulse"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(500,500,500) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/unleash/unlock2/spectre_arcana_death_dander.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		-- ParticleManager:SetParticleControlEnt( effect_cast, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOnLocationWithCaster( pos, sound_cast, caster )

		
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(700, 700, 700) )
		-- ParticleManager:SetParticleControl( effect_cast, 2, caster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		for i = 1, 4, 1 do
			Timers:CreateTimer(RandomFloat(0.1, 0.3), function()
				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
				ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector(700, 700, 700) )
				-- ParticleManager:SetParticleControl( effect_cast, 2, caster:GetOrigin() )
				ParticleManager:ReleaseParticleIndex( effect_cast )
			end)
	
		end
		
	end

end


function Advanced_unleash:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



modifier_Advanced_unleash = class({})


function modifier_Advanced_unleash:IsHidden()	return false end
function modifier_Advanced_unleash:IsDebuff()	return false end
function modifier_Advanced_unleash:IsPurgable()	return false end
function modifier_Advanced_unleash:IsPurgeException() return false end
function modifier_Advanced_unleash:RemoveOnDeath()
	return true
end

function modifier_Advanced_unleash:OnCreated( kv )
	self.parent = self:GetParent()

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )

	if not IsServer() then return end


	self.parent:AddNewModifier(	self.parent,self:GetAbility(),"modifier_Advanced_unleash_fury",{}	)
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )

end

function modifier_Advanced_unleash:OnRefresh( kv )

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )	
	if not IsServer() then return end
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_Advanced_unleash:OnDestroy()
	if not IsServer() then return end
	if not self.parent or self.parent:IsNull() then
		return
	end
	local modifier = self.parent:FindModifierByNameAndCaster( "modifier_Advanced_unleash_fury", self.parent )
	if modifier then
		modifier:ForceDestroy()
	end

	local modifier = self.parent:FindModifierByNameAndCaster( "modifier_Advanced_unleash_recovery", self.parent )
	if modifier then
		modifier:ForceDestroy()
	end


end


function modifier_Advanced_unleash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_unleash:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_ms end


modifier_Advanced_unleash_fury = class({})


function modifier_Advanced_unleash_fury:IsHidden()	return false end
function modifier_Advanced_unleash_fury:IsDebuff()	return false end
function modifier_Advanced_unleash_fury:IsPurgable()	return false end


function modifier_Advanced_unleash_fury:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_as = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.recovery = self:GetAbility():GetSpecialValueFor( "attack_interval" )
	self.charges = self:GetAbility():GetSpecialValueFor( "charges_per_flurry" )
	self.timer = self:GetAbility():GetSpecialValueFor( "max_time_window_per_hit" )

	self.radius = self:GetAbility():GetSpecialValueFor( "pulse_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "pulse_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "pulse_debuff_duration" )
	self.attack_count = 0
	if not IsServer() then return end
	self.advanced_level = self.ability.advanced_level

	self.counter = self.charges
	--LV10解锁风暴+
	if self.advanced_level>=10 then
		self.recovery =0.6
	end
	--LV15解锁拳击手
	if self.advanced_level>=15 then
		self.counter = self.counter+4
	end
	self:SetStackCount( self.counter )
	self.chance = 20
	--LV5解锁怒役狂击+
	if self.advanced_level>=5 then
		self.chance = 32
	end
	

	self.success = 0

	-- create anmiation modifier
	self.animation = self.parent:AddNewModifier(self.parent,self.ability, "modifier_Advanced_unleash_animation", {}	)

	self:PlayEffects1()
	self:PlayEffects2( self.parent, self.counter )

end



function modifier_Advanced_unleash_fury:OnRemoved()
end

function modifier_Advanced_unleash_fury:OnDestroy()
	if not IsServer() then return end


	if not self.animation:IsNull() then
		self.animation:SafeDestroy()
	end

	local main = self.parent:FindModifierByName("modifier_Advanced_unleash")
	if not main then return end


	if self.forced then return end
	local recovery = self.recovery
	if self.parent:HasAbility("heroTalent_npc_dota_hero_marci_2") and self.parent:GetRandomEffect(50,INT_TYPE,1)  > RandomInt(1, 100) then
		recovery = 0.03
	end
	self.parent:AddNewModifier(	self.parent, 	self.ability,"modifier_Advanced_unleash_recovery", {duration = recovery,success = self.success,} )

	if self.success~=1 then return end
end


function modifier_Advanced_unleash_fury:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end



function modifier_Advanced_unleash_fury:OnAttack( params )
	if params.attacker~=self.parent then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:ForceDestroy()
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_unleash")
		if modifier then
			modifier:SafeDestroy()
		end
		return
	end
	if self.parent:IsInSpecialAttack() then
		return
	end
	self:StartIntervalThink( self.timer )
	self.counter = self.counter - 1
	self:SetStackCount( self.counter )
	self:EditEffects2( self.counter )
	self:PlayEffects3( self.parent, params.target )
	self.attack_count = self.attack_count +1

	if self.counter<=0 then
		self.success = 1
		self:Pulse( params.target:GetOrigin() )
		self:SafeDestroy()
	else
		if self.ability.unlock1 and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
			self:Pulse( params.target:GetOrigin() )
		end
		if self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1) >=RandomInt(1, 100) then
			self.counter = self.counter + 1
			self:SetStackCount( self.counter )
		end
	end

end

function modifier_Advanced_unleash_fury:GetModifierAttackSpeedBonus_Constant()	return self.bonus_as+200*self.attack_count end

function modifier_Advanced_unleash_fury:GetActivityTranslationModifiers()
	if self:GetStackCount()==1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount()%2==0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end


function modifier_Advanced_unleash_fury:OnIntervalThink()
	self:SafeDestroy()
end


function modifier_Advanced_unleash_fury:Pulse( center )

	local enemies = FindUnitsInRadius(	self.parent:GetTeamNumber(),center,	nil,	self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE ,
		FIND_ANY_ORDER ,
		false	
	)


	local damageTable = {
		attacker = self.parent,
		damage = self.damage*self.parent:GetDamageMax(),
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
	}

	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)


		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(self.parent, self.ability, "modifier_Advanced_unleash_debuff", { duration = self.duration*StatusResistance })
	end


	self:PlayEffects4( center, self.radius )
end

function modifier_Advanced_unleash_fury:ForceDestroy()
	self.forced = true
	self:SafeDestroy()
end


function modifier_Advanced_unleash_fury:PlayEffects1()

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Charged"
	local sound_cast2 = "Hero_Marci.Unleash.Charged.2D"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_l",Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt(effect_cast,2,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_r",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,3,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,4,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,5,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt(effect_cast,6,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	self:AddParticle(effect_cast,false, false, -1, false, false )
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_cast2, self:GetParent() )
end

function modifier_Advanced_unleash_fury:PlayEffects2( caster, counter )

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, counter, 0 ) )
	self:AddParticle(effect_cast,false, false, -1, false, false )
	self.effect_cast = effect_cast
end

function modifier_Advanced_unleash_fury:EditEffects2( counter )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, counter, 0 ) )
end

function modifier_Advanced_unleash_fury:PlayEffects3( caster, target )
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	DestroyParticleByDelayButNotImmediately(effect_cast,2)
end

function modifier_Advanced_unleash_fury:PlayEffects4( point, radius )

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Pulse"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,radius,radius) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetParent() )
end



modifier_Advanced_unleash_debuff = class({})

function modifier_Advanced_unleash_debuff:IsHidden()	return false end
function modifier_Advanced_unleash_debuff:IsDebuff()	return true end
function modifier_Advanced_unleash_debuff:IsPurgable()	return true end

function modifier_Advanced_unleash_debuff:OnCreated( kv )
	self.as_slow = -self:GetAbility():GetSpecialValueFor( "pulse_attack_slow_pct" )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor( "pulse_move_slow_pct" )

	if not IsServer() then return end
end

function modifier_Advanced_unleash_debuff:OnRefresh( kv )	self:OnCreated( kv ) end
function modifier_Advanced_unleash_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Advanced_unleash_debuff:GetModifierAttackSpeedBonus_Constant()	return self.as_slow end
function modifier_Advanced_unleash_debuff:GetModifierMoveSpeedBonus_Constant()	return self.ms_slow end
function modifier_Advanced_unleash_debuff:GetEffectName()	return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf" end
function modifier_Advanced_unleash_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_unleash_debuff:GetStatusEffectName()	return "particles/status_fx/status_effect_snapfire_slow.vpcf" end
function modifier_Advanced_unleash_debuff:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end


modifier_Advanced_unleash_animation = class({})
function modifier_Advanced_unleash_animation:IsHidden()	return true end
function modifier_Advanced_unleash_animation:IsDebuff()	return false end
function modifier_Advanced_unleash_animation:IsPurgable()	return false end

function modifier_Advanced_unleash_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_Advanced_unleash_animation:GetActivityTranslationModifiers()	return "unleash" end


modifier_Advanced_unleash_recovery = advanced_modifier({})
function modifier_Advanced_unleash_recovery:IsHidden()	return false end
function modifier_Advanced_unleash_recovery:IsDebuff()	return true end
function modifier_Advanced_unleash_recovery:IsPurgable()	return false end
function modifier_Advanced_unleash_recovery:OnCreated( kv )
	self.parent = self:GetParent()
	if not IsServer() then return end
	self.eva = 0
	--LV20解锁闪电侠
	if self:GetAbility().advanced_level>=20 then
		self.eva = 80
	end
	self.success = kv.success==1
end

function modifier_Advanced_unleash_recovery:OnRefresh( kv )
	self:OnCreated( kv )
end



function modifier_Advanced_unleash_recovery:OnDestroy()
	if not IsServer() then return end
	if self.parent:IsNull() then
		return
	end
	local main = self.parent:FindModifierByName("modifier_Advanced_unleash")
	if not main then return end
	if self.forced then return end
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_Advanced_unleash_fury", {} )

end


function modifier_Advanced_unleash_recovery:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end


function modifier_Advanced_unleash_recovery:GetModifierEvasion_Constant()             return   self.eva  end

function modifier_Advanced_unleash_recovery:ForceDestroy()
	self.forced = true
	self:SafeDestroy()
end







modifier_Advanced_unleash_recovery_passive = class({})


function modifier_Advanced_unleash_recovery_passive:IsHidden()	return true end
function modifier_Advanced_unleash_recovery_passive:IsDebuff()	return false end
function modifier_Advanced_unleash_recovery_passive:IsStunDebuff()	return false end
function modifier_Advanced_unleash_recovery_passive:RemoveOnDeath()	return false end
function modifier_Advanced_unleash_recovery_passive:DestroyOnExpire()	return false end
function modifier_Advanced_unleash_recovery_passive:IsPurgable() 		return false end
function modifier_Advanced_unleash_recovery_passive:IsPurgeException() 	return false end
function modifier_Advanced_unleash_recovery_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_unleash_recovery_passive:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_Advanced_unleash_recovery_passive:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsAlive() and  not parent:HasModifier("modifier_Advanced_unleash") then	
		local ability = self:GetAbility()
		if not ability then
			self:SafeDestroy()
			return
		end
		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_unleash",{} )
	end
end
