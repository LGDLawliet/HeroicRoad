Advanced_Venomous_Gale = class({})

LinkLuaModifier("modifier_Advanced_Venomous_Gale_slow", "skills/Advanced_Venomous_Gale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Venomous_Gale_stun", "skills/Advanced_Venomous_Gale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Venomous_Gale_unlock2_thinker", "skills/Advanced_Venomous_Gale", LUA_MODIFIER_MOTION_NONE)

function Advanced_Venomous_Gale:CheckKV(key)
	local table = {
		poison = 5,
		initial_slow=2,
		bonus_poison=0.08,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Venomous_Gale:UnlockFirstCore(key)
	return true
end
function Advanced_Venomous_Gale:UnlockSecondCore(key)
	return true
end
function Advanced_Venomous_Gale:UnlockThirdCore(key)
	return true
end

function Advanced_Venomous_Gale:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/venomous_gale/unlock2/effect_gale.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
end

function Advanced_Venomous_Gale:IsHiddenWhenStolen() 	return false end
function Advanced_Venomous_Gale:IsRefreshable() 			return true end
function Advanced_Venomous_Gale:IsStealable() 			return true end
function Advanced_Venomous_Gale:IsNetherWardStealable()	return true end

function Advanced_Venomous_Gale:GetCastRange()
	if IsServer() then
		return 0
	else
		return self:GetSpecialValueFor("distance")
	end
end
function Advanced_Venomous_Gale:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Venomous_Gale:GetAOERadius()
	return 500
end

function Advanced_Venomous_Gale:OnSpellStart()
	local caster = self:GetCaster()
	-- 原石2
	if self.unlock2 then
		local pos = self:GetCursorPosition()
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.8)
		caster:EmitSound("Hero_Venomancer.VenomousGale")
		local thinker = CreateModifierThinker(
			caster, 
			self, 
			"modifier_Advanced_Venomous_Gale_unlock2_thinker", 
			{duration = 20*ModifierStatusNegativeGain}, -- kv
			pos,
			caster:GetTeamNumber(),
			false
		)
		return
	end
	
	local pos = self:GetCursorPosition()
	self:CreateGale(caster:GetAbsOrigin(),pos)
end

function Advanced_Venomous_Gale:CreateGale(source,pos)
	local caster = self:GetCaster()
	local target_pos = pos
	if target_pos==source then
		target_pos = target_pos + caster:GetForwardVector()*100
	end
	local sound = CreateUnitByName("npc_dummy_unit", source, false, nil, nil, 0)
	sound:EmitSound("Hero_Venomancer.VenomousGale")
	sound:ForceKill(false)
	local distance = math.max(self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus(),100)
	local speed = (target_pos - source):Normalized() * self:GetSpecialValueFor("speed")
	--LV15
	if self.advanced_level >= 15 then
		distance = distance*1.5
		speed = (target_pos - source):Normalized() *100
	end
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		Source = caster,
		vSpawnOrigin = source,
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("radius"),
		fEndRadius = self:GetSpecialValueFor("radius"),
		-- Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 30.0,
		bDeleteOnHit = false,
		vVelocity = speed,
		bProvidesVision = false,
		ExtraData = {}
		-- ExtraData = {hit = i}   --额外的数据
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function Advanced_Venomous_Gale:OnProjectileHit_ExtraData(target, location,keys)
	if not target then
		return
	end
	target:EmitSound("Hero_Venomancer.VenomousGaleImpact")
	local caster = self:GetCaster()

	local each = self:GetSpecialValueFor("each")
	local index = self:GetSpecialValueFor("index")
	local index_max = self:GetSpecialValueFor("index_max")
	-- lv5
	if self.advanced_level >= 5 then
		index_max = 120
	end
	local duration = self:GetSpecialValueFor("duration")
	local poison = self:GetSpecialValueFor("poison") + self:GetSpecialValueFor("bonus_poison")*self:GetCaster():HDGetPrimaryStatValue()
	-- lv10
	if self.advanced_level >= 10 then
		local spell_amp = math.max(1+caster:GetSpellAmplification(false)*0.75,0)
		poison = poison*spell_amp
	end
	local poison_index = math.min(math.floor(target:GetHealth()/each)*index,index_max)*0.01 + 1
	poison = poison*poison_index
	duration = duration*poison_index
	target:Poison(self:GetCaster(), self, poison)
	target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Venomous_Gale_slow", {duration = duration})

	-- 原石3
	if keys.unlock3 then
		target:AddNewModifier(caster, self, "modifier_Advanced_Venomous_Gale_slow", {duration = duration, unlock3 = 1})
	end
end

modifier_Advanced_Venomous_Gale_slow = advanced_modifier({})

function modifier_Advanced_Venomous_Gale_slow:IsDebuff()			return true end
function modifier_Advanced_Venomous_Gale_slow:IsHidden() 			return false end
function modifier_Advanced_Venomous_Gale_slow:IsPurgable() 			return false end
function modifier_Advanced_Venomous_Gale_slow:IsPurgeException() 	return false end
function modifier_Advanced_Venomous_Gale_slow:GetEffectName() return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf" end
function modifier_Advanced_Venomous_Gale_slow:IsPoisonDeBuff() return true end
function modifier_Advanced_Venomous_Gale_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Venomous_Gale_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Venomous_Gale_slow:OnCreated(keys)
	self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.initial_slow = self:GetAbility():GetSpecialValueFor("initial_slow")

	if self:GetAbility():GetUnlock(2)==2 then
		self.initial_slow = self.initial_slow *0.5
	end

	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
		if keys.unlock3 then
			self.not_unlock3 = true
		end
	end
end

function modifier_Advanced_Venomous_Gale_slow:OnIntervalThink()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("stun_duration")

	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.4)
	local StatusResistance = parent:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
	parent:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Venomous_Gale_stun", {duration = duration * StatusResistance})
end

function modifier_Advanced_Venomous_Gale_slow:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,MODIFIER_EVENT_ON_DEATH)
	end
	return funcs
end

function modifier_Advanced_Venomous_Gale_slow:GetModifierMoveSpeedBonus_Constant() 
	if self:GetParent():IsMagicImmune() then
		return
	end
	if self:GetAbility() and self:GetAbility():GetUnlock(2)==2 then
		return (0 - self.initial_slow) 
	end
	return (0 - self.initial_slow* (self:GetRemainingTime() / self:GetDuration())) 
end

function modifier_Advanced_Venomous_Gale_slow:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if self.not_unlock3 then
		return
	end
	if not keys.unit.venomous_gale then
		keys.unit.venomous_gale = 0
	end
	if keys.unit.venomous_gale>=1 then
		return
	end
	if keys.unit == self:GetParent() then
		keys.unit.venomous_gale = keys.unit.venomous_gale + 1
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local source = parent:GetOrigin()
		local target_pos = caster:GetOrigin()
		if target_pos==source then
			target_pos = target_pos + caster:GetForwardVector()*100
		end
		local sound = CreateUnitByName("npc_dummy_unit", source, false, nil, nil, 0)
		sound:EmitSound("Hero_Venomancer.VenomousGale")
		sound:ForceKill(false)
		local distance = math.max(ability:GetSpecialValueFor("distance") + caster:GetCastRangeBonus(),100)
		local speed = (target_pos - source):Normalized() * ability:GetSpecialValueFor("speed")
		distance = distance*1.5

		local info = 
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
			Source = caster,
			vSpawnOrigin = source,
			fDistance = distance,
			fStartRadius = ability:GetSpecialValueFor("radius"),
			fEndRadius = ability:GetSpecialValueFor("radius"),
			-- Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 30.0,
			bDeleteOnHit = false,
			vVelocity = speed,
			bProvidesVision = false,
			--ExtraData = {}
			ExtraData = {unlock3 = 1}   --额外的数据
		}
		ProjectileManager:CreateLinearProjectile(info)


		local name = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
	
		local pfx2 = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(pfx2, 1, Vector(300, 0.2, 300))
		ParticleManager:ReleaseParticleIndex(pfx2)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = caster:GetIntellect(false)*5, 
			damage_type = self:GetAbility():GetAbilityDamageType(), 
			damage_flags = DOTA_DAMAGE_FLAG_NONE, 
			ability = self:GetAbility()
		}

		for i, enemy in pairs(enemies) do
			
			damageTable.victim = enemy
			ApplyDamage(damageTable	)
			if i>=6 then
				break
			end
		end
	end
end

-- advanced_modifier
function modifier_Advanced_Venomous_Gale_slow:ADDeclareFunctions()
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		return 
		{
			advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
		}
	end
	return {}
    
end
function modifier_Advanced_Venomous_Gale_slow:Advanced_GetModifierIncomingPoisonDamagePercentage(keys)
	return 10
end







modifier_Advanced_Venomous_Gale_stun = class({})

function modifier_Advanced_Venomous_Gale_stun:IsDebuff()			return true end
function modifier_Advanced_Venomous_Gale_stun:IsHidden() 			return false end
function modifier_Advanced_Venomous_Gale_stun:IsPurgable() 		return true end
function modifier_Advanced_Venomous_Gale_stun:IsPurgeException() 	return true end
function modifier_Advanced_Venomous_Gale_stun:IsStunDebuff() return true end
function modifier_Advanced_Venomous_Gale_stun:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_Advanced_Venomous_Gale_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Venomous_Gale_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end


modifier_Advanced_Venomous_Gale_unlock2_thinker= modifier_Advanced_Venomous_Gale_unlock2_thinker or class({})

function modifier_Advanced_Venomous_Gale_unlock2_thinker:IsHidden()		return true end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:IsPurgable()		return false end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:IsAura()
	return true
end

function modifier_Advanced_Venomous_Gale_unlock2_thinker:GetModifierAura()	return "modifier_Advanced_Venomous_Gale_slow" end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:GetAuraRadius()	return 500  end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Venomous_Gale_unlock2_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Venomous_Gale_unlock2_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Advanced_Venomous_Gale_unlock2_thinker:OnCreated(keys)
	if IsServer() then

		local particle_cast = "particles/rebuild/spell/venomous_gale/unlock2/effect_gale.vpcf"


		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetParent() )
		local pos = self:GetParent():GetOrigin()
	
		ParticleManager:SetParticleControl( self.effect_cast, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast, 3, pos )
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Venomous_Gale_unlock2_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
       	500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        0,
        FIND_CLOSEST,
        false
    	)
	for _,target in pairs(enemies) do
	
	
	if not target then
		return
	end
	target:EmitSound("Hero_Venomancer.VenomousGaleImpact")
	local caster = self:GetCaster()

	local each = self:GetAbility():GetSpecialValueFor("each")
	local index = self:GetAbility():GetSpecialValueFor("index")
	local index_max = self:GetAbility():GetSpecialValueFor("index_max")
	index_max = 120
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local poison = self:GetAbility():GetSpecialValueFor("poison") + self:GetAbility():GetSpecialValueFor("bonus_poison")*caster:HDGetPrimaryStatValue()
	local spell_amp = math.max(1+caster:GetSpellAmplification(false)*0.75,0)
	poison = poison*spell_amp

	local poison_index = math.min(math.floor(target:GetHealth()/each)*index,index_max)*0.01 + 1
	poison = poison*poison_index*0.2
	duration = duration*poison_index
	target:Poison(caster, self:GetAbility(), poison)
	end
end

function modifier_Advanced_Venomous_Gale_unlock2_thinker:OnDestroy()
	if IsServer() then
		if self.effect_cast then
			ParticleManager:DestroyParticle( self.effect_cast,false )
			ParticleManager:ReleaseParticleIndex( self.effect_cast )
		end
	
		UTIL_Remove( self:GetParent() )
	end
end
