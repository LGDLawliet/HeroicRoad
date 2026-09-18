--特效优化 √
Advanced_astral_step = class({})

LinkLuaModifier( "modifier_Advanced_astral_step", "skills/Advanced_astral_step", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_step_buff", "skills/Advanced_astral_step", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_astral_step_buff2", "skills/Advanced_astral_step", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能

function Advanced_astral_step:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/astral_step/particle_16/effect.vpcf", context )

end











function Advanced_astral_step:CheckKV(key)
	local table = {
		damage = 15,
		damage_index = 0.15,



	}
	local value = table[key] or -1
	return value

end
function Advanced_astral_step:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})

	return true
end
function Advanced_astral_step:UnlockSecondCore(key)
	return true
end
function Advanced_astral_step:UnlockThirdCore(key)
	return true
end

function Advanced_astral_step:GetManaCost(iLevel)
	-- local ability = self

	--LV20解锁通脉
	if self:GetSpecialValueFor("advanced_level")>=20 then
		return 0 
	end

    return self.BaseClass.GetManaCost(self, iLevel)
end

function Advanced_astral_step:OnSpellStart()



	local caster = self:GetCaster()
	--LV20解锁通脉
	if self.advanced_level>=20 then
		caster:GiveMana(150)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, 150, nil)
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local min_dist = 200
	local max_dist = self:GetSpecialValueFor( "distance" )+ caster:GetCastRangeBonus()
	max_dist = math.min(max_dist,2000)
	local radius = 250
	local delay = 3

	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )
	FindClearSpaceForUnit( caster, target, true )


	local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
	)
	local duration = 3
	--LV5解锁太虚+
	if self.advanced_level>=5 then
		duration = 5
	end
	caster:AddNewModifier(caster, self,"modifier_Advanced_astral_step_buff", { duration = duration })
	caster:AddNewModifier(caster, self,"modifier_Advanced_astral_step_buff2", { duration = 3 })

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	
	for _,enemy in pairs(enemies) do

		caster:PerformAttack( enemy, true, true, true, false, false, false, true )


		enemy:AddNewModifier(caster, self,"modifier_Advanced_astral_step", { duration = delay })


		self:PlayEffects2( enemy )
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end


	self:PlayEffects1( origin, target )
	if self.unlock2 then
		if 60>=RandomInt(1, 100) then
			self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges()+1)
		end
	end

	if self:GetCurrentAbilityCharges()<=0 then
		local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_void_spirit_2")
		if ability and ability:GetCurrentAbilityCharges()>=1 then
			ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
			ability:OnCostCharge()
			ability:AddCount()
			self:SetCurrentAbilityCharges(1)
		end
	end
end

--------------------------------------------------------------------------------
function Advanced_astral_step:PlayEffects1( origin, target )
	
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

	local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbilityName())
	if type=="ability_particle_16" then
		particle_cast = "particles/rebuild/spell/astral_step/particle_16/effect.vpcf"
	end
	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function Advanced_astral_step:PlayEffects2( target )

	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_Advanced_astral_step = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_astral_step:IsHidden()	return false end
function modifier_Advanced_astral_step:IsDebuff()	return true end
function modifier_Advanced_astral_step:IsStunDebuff()	return false end
function modifier_Advanced_astral_step:IsPurgable()	return true end
function modifier_Advanced_astral_step:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_astral_step:OnCreated( kv )
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.slow = -ability:GetSpecialValueFor("slow")
	-- references
	if IsServer() then
	
		self.damage = ability:GetSpecialValueFor("damage")+(ability:GetSpecialValueFor("damage_index"))*self:GetCaster():GetIntellect(false)
		if kv.type and kv.type==1 then
			self.damage = self.damage *0.5
		end
	end

end


function modifier_Advanced_astral_step:OnDestroy()
	if not IsServer() then return end

	--LV15解锁精神体共振
	if self.advanced_level>=15 then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  200,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)  
	   local damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage*0.5,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
		}

		for _, unit in pairs(units) do
			if unit~=self:GetParent() then
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
			
		end
	end

	-- Apply damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)



	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_astral_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_astral_step:GetModifierMoveSpeedBonus_Constant()	return self.slow end

function modifier_Advanced_astral_step:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_Advanced_astral_step:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_astral_step:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_Advanced_astral_step:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end

function modifier_Advanced_astral_step:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
	local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_target, self:GetParent() )
end








modifier_Advanced_astral_step_buff = class({})
function modifier_Advanced_astral_step_buff:IsHidden()	return false end
function modifier_Advanced_astral_step_buff:IsDebuff()	return false end
function modifier_Advanced_astral_step_buff:IsPurgable()	return false end


function modifier_Advanced_astral_step_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

function modifier_Advanced_astral_step_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_Advanced_astral_step_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end


modifier_Advanced_astral_step_buff2 = class({})
function modifier_Advanced_astral_step_buff2:IsHidden()	return false end
function modifier_Advanced_astral_step_buff2:IsDebuff()	return false end
function modifier_Advanced_astral_step_buff2:IsPurgable()	return false end

function modifier_Advanced_astral_step_buff2:OnCreated(keys)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
end



function modifier_Advanced_astral_step_buff2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_Advanced_astral_step_buff2:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	local caster = self:GetParent()
	if  caster:IsRooted() then
		return 
	end
	-- right click, switch position
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SpellToTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SpellToTarget( params.target:GetOrigin() )
	end
end

function modifier_Advanced_astral_step_buff2:SpellToTarget(pos)
	if IsServer() then
		if self.trigger then
			return
		end

		local ability = self:GetAbility()
		self.trigger =true
		local delay = 0.3
		--LV10解锁位相共轭
		if self.advanced_level>=10 then
			delay = 0.2
			if ability.unlock1 then
				delay = 0.01
			
			end
		end

		Timers:CreateTimer(delay, function()
			self.trigger =false
	

		end)



		local caster = self:GetCaster()
		local point = pos
		local origin = caster:GetOrigin()
		local min_dist = 200
		local max_dist = ability:GetSpecialValueFor( "distance" )*0.5
		local radius = 250

		local direction = (point-origin)
		local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
		direction.z = 0
		direction = direction:Normalized()
	
		local target = GetGroundPosition( origin + direction*dist, nil )
		FindClearSpaceForUnit( caster, target, true )
	
	
		local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
		)

		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	
		if ability.unlock3 then
			for _,enemy in pairs(enemies) do
	
				caster:PerformAttack( enemy, true, true, true, false, false, false, true )
				enemy:AddNewModifier(caster, ability,"modifier_Advanced_astral_step", { duration = 0.5,type=1 })
				ability:PlayEffects2( enemy )
			end
		else
			for _,enemy in pairs(enemies) do
	
				caster:PerformAttack( enemy, true, true, true, false, false, false, true )
	
				ability:PlayEffects2( enemy )
			end
		end

		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end

	
		ability:PlayEffects1( origin, target )
	end

end