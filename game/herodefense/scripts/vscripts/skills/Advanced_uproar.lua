
Advanced_uproar =Advanced_uproar or class({})
LinkLuaModifier("modifier_Advanced_uproar", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_uproar_buff", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_uproar_debuff", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_uproar_modify_count", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_uproar_modify_1", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_uproar_modify_2", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_uproar_debuff2", "skills/Advanced_uproar", LUA_MODIFIER_MOTION_NONE)



function Advanced_uproar:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/uproar/unlock3/effect_.vpcf", context )




	
end






function Advanced_uproar:CheckKV(key)
	local table = {
        bonus_damage=1.5,
		bonus_damage_per_stack = 1,
		roared_bonus_armor = 0.1,

	}
	local value = table[key] or -1
	return value

end

function Advanced_uproar:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_uproar_modify_count", {stack = 10}) 
	return true
end
function Advanced_uproar:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_uproar")
	if modifier then
		modifier:OnRefresh(nil)
	end
	return true
end
--unlock3效果写在目标技能里了
function Advanced_uproar:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end



function Advanced_uproar:OnAdvancedUpgrade()
	self:SetLevel(0)
	self:SetLevel(1)
	if self.advanced_level>=15 and not self.lv15 then
		self.lv15 = true
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_Advanced_uproar_modify_count", {stack = 5}) 
	end
end
--------------------------------------------------------------------------------
-- Custom KV
function Advanced_uproar:GetBehavior()
	if self:GetSpecialValueFor("advanced_level")>=20 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	if self:GetCaster():GetModifierStackCount( "modifier_Advanced_uproar", self:GetCaster() )<1 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



function Advanced_uproar:GetAbilityTextureName(  )
	local stack = self:GetCaster():GetModifierStackCount( "modifier_Advanced_uproar", self:GetCaster() )
	if stack==0 then
		return "primal_beast_uproar_none"
	elseif stack== self:GetSpecialValueFor("stack_limit") then
		return "primal_beast_uproar_max"
	else
		return "primal_beast_uproar_mid"
	end
end

function Advanced_uproar:IsRefreshable()
	return false
end

function Advanced_uproar:GetIntrinsicModifierName()
	return "modifier_Advanced_uproar"
end

function Advanced_uproar:CastFilterResult()
	if IsClient() then
		return
	end
	if self:GetAutoCastState() then
		if self:GetCaster():GetAbilityPoints()>0 then
			return UF_SUCCESS
		end
		return UF_FAIL_CUSTOM
	end
	if self:GetCaster():GetModifierStackCount( "modifier_Advanced_uproar", self:GetCaster() )<1 then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function Advanced_uproar:GetCustomCastError( hTarget )
	if IsClient() then
		return
	end
	if self:GetAutoCastState() then
		return "DOTA_HUD_not_enough_ability_point"
	end
	if self:GetCaster():GetModifierStackCount( "modifier_Advanced_uproar", self:GetCaster() )<1 then
		return "#DOTA_CUSTOM_CAST_DENY_NO_stack"
	end

	return ""
end



function Advanced_uproar:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		local point = caster:GetAbilityPoints()
		if point>0 then
			caster:SetAbilityPoints(point-1)
			local stack = 2
			if self.unlock1 then
				stack = 3
			end
			caster:AddNewModifier(caster, self, "modifier_Advanced_uproar_modify_count", {stack = stack}) 
			self:PlayEffects( 300 )
			self:PlayEffects2()
		end
		return
	end
	local duration = self:GetSpecialValueFor( "roar_duration" ) * caster:GetModifierDurationGainIndex(1)
	local radius = self:GetSpecialValueFor( "radius" )
	local slow = self:GetSpecialValueFor( "slow_duration" )
	local stack = 0
	local modifier = caster:FindModifierByName( "modifier_Advanced_uproar" )
	if modifier then
		stack = modifier:GetStackCount()
		if stack<=0 then
			return
		end
		modifier:ResetStack()

	else
		return
	end

	caster:AddNewModifier(caster, self,"modifier_Advanced_uproar_buff", 
		{
			duration = duration,
			stack = stack,
		}
	)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_uproar_debuff", -- modifier name
			{
				duration = slow,
				stack = stack,
			} -- kv
		)
	end

	self:StartCooldown( duration )
	self:PlayEffects( radius )
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Effects
function Advanced_uproar:PlayEffects( radius )
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf"
	local sound_cast = "Hero_PrimalBeast.Uproar.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Advanced_uproar:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



UPROAR_SPELL_MODIFY_MODIFIER = {
	DOTA_HUD_spell_modify_1 = "modifier_Advanced_uproar_modify_1",
	DOTA_HUD_spell_modify_2 = "modifier_Advanced_uproar_modify_2",
}
function Advanced_uproar:CheckSpellModify(data)
	-- PrintTable(data)
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_uproar_modify_count")
	if not modifier then
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"DOTA_HUD_spell_modify_deny_1","General.Cancel")
		return
	end
	-- 先计算一下点数足不足
	local pointCount = modifier:GetStackCount()
	local need_pont = 0
	for key, value in pairs(data) do
		need_pont = need_pont + value
	end
	if need_pont>pointCount then
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"DOTA_HUD_spell_modify_deny_1","General.Cancel")
		return
	end
	-- 可以加上了
	for key, value in pairs(data) do
		caster:AddNewModifier(caster, self,UPROAR_SPELL_MODIFY_MODIFIER[key], {stack = value})
		modifier:ReducePoint(value)
	end
	self:PlayEffects( 100 )
	self:PlayEffects2()
end


function Advanced_uproar:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return true
	end
		
	target:AddNewModifier(self:GetCaster(), self,"modifier_Advanced_uproar_debuff2", 
		{
			duration = 5,
		}
	)
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(nil),
						damage_type = DAMAGE_TYPE_PHYSICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_PrimalBeast.Uproar.Projectile.Split", target)


	return true
end








modifier_Advanced_uproar =modifier_Advanced_uproar or  advanced_modifier({})
function modifier_Advanced_uproar:IsHidden()	return self:GetStackCount()<1 end
function modifier_Advanced_uproar:IsDebuff()	return false end
function modifier_Advanced_uproar:IsPurgable()	return false end
function modifier_Advanced_uproar:RemoveOnDeath()	return false end
function modifier_Advanced_uproar:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_uproar:OnCreated( kv )
	self.parent = self:GetParent()
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
	self.stack_chance = self:GetAbility():GetSpecialValueFor("stack_chance")


	self.bonus_gain_index = 2
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
		self.bonus_gain_index = 3
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
			self.stack_limit = 9
		end
	end
	
	if not IsServer() then return end
	if self:GetAbility().unlock2 then
		self.stack_limit = 80
		self.stack_chance = 20
	end

end

function modifier_Advanced_uproar:OnRefresh(kv)
	self:OnCreated( kv )
end

function modifier_Advanced_uproar:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function modifier_Advanced_uproar:OnTakeDamage( params )
	if self.parent:PassivesDisabled() then return end
	if self.parent:HasModifier( "modifier_Advanced_uproar_buff" ) then return end
	if params.unit~=self.parent then return end
	if self.stack_chance>=RandomInt(1, 100) then
		if self:GetStackCount()<self.stack_limit then
			self:IncrementStackCount()
	
			if self:GetStackCount()==self.stack_limit then
				EmitSoundOn( "Hero_PrimalBeast.Uproar.MaxStacks", self.parent )
			end
		end
		self:SetDuration( self.duration, true )
		self:StartIntervalThink(self.duration)
	end

	
end

function modifier_Advanced_uproar:GetModifierPreAttack_BonusDamage()	return self.parent:PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor( "bonus_damage" ) end


function modifier_Advanced_uproar:OnIntervalThink()	
	self:ResetStack() 
end
function modifier_Advanced_uproar:ResetStack()	self:SetStackCount(0) end





-- function modifier_Advanced_uproar:GetModifierPhysical_ConstantBlock(keys)  
-- 	if self.parent:PassivesDisabled() then
-- 		return
-- 	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

-- 	local block = keys.damage * 0.1
-- 	if self.parent:HasModifier("modifier_Advanced_uproar_buff") then
-- 		block = block *self.bonus_gain_index
-- 	end
-- 	return block 
-- end






function modifier_Advanced_uproar:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_Advanced_uproar:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self.parent:PassivesDisabled() then
		return 0
	end
	local block = -10
	if self.parent:HasModifier("modifier_Advanced_uproar_buff") then

		block = block *self.bonus_gain_index
	end
	if IsClient() then
		return block
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


	return block 

end





modifier_Advanced_uproar_buff = modifier_Advanced_uproar_buff or advanced_modifier({})

function modifier_Advanced_uproar_buff:IsHidden()	return false end
function modifier_Advanced_uproar_buff:IsDebuff()	return false end
function modifier_Advanced_uproar_buff:IsPurgable()	return true end
function modifier_Advanced_uproar_buff:OnCreated( kv )

	if not IsServer() then return end
	self:StartIntervalThink(0.1)
	self:SetStackCount(kv.stack)
	local ability = self:GetAbility()
	if ability.unlock3 then
		self.unlock3 = true
		self.timer = GameRules:GetGameTime()
		self:OnIntervalThink()
	end

	self:PlayEffects()
end

function modifier_Advanced_uproar_buff:OnRefresh( kv )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_Advanced_uproar_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_Advanced_uproar_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" ) * self:GetStackCount()
end

function modifier_Advanced_uproar_buff:OnIntervalThink()
	self:GetAbility():StartCooldown(math.max(self:GetRemainingTime()-0.1,0))

	if self.unlock3 then
		local time = GameRules:GetGameTime()
		if time>=self.timer then
			self.timer = GameRules:GetGameTime() + 1.25
			local caster = self:GetCaster()
			local ability = self:GetAbility()
			caster:EmitSound("Hero_PrimalBeast.Uproar.Projectile")
			local info = 
			{
				Ability = ability,
				EffectName = "particles/rebuild/spell/uproar/unlock3/effect_.vpcf",
				vSpawnOrigin = caster:GetAbsOrigin(),
				fDistance = 2000,
				fStartRadius = 150,
				fEndRadius = 150,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 90.0,
				bDeleteOnHit = true,
				-- vVelocity = direction * self:GetSpecialValueFor("speed"),
				bProvidesVision = false,
				-- ExtraData = {thinker = thinker}
			}
			local count = math.min(self:GetStackCount(),5)*2+2
			local caster_pos = caster:GetOrigin()
			local pos = caster_pos + caster:GetForwardVector()*100
			local angle = 360/count
			for i = 0, count-1, 1 do
				local new_pos = RotatePosition(caster_pos, QAngle(0, i*angle, 0), pos)
				local direction = (new_pos - caster_pos):Normalized()
				info.vVelocity = direction * 400
				ProjectileManager:CreateLinearProjectile(info)
			end
			
		end
	end
end

function modifier_Advanced_uproar_buff:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_OVERHEAD_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end



function modifier_Advanced_uproar_buff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

function modifier_Advanced_uproar_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_uproar_buff:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" ) * self:GetStackCount()
end








modifier_Advanced_uproar_debuff = modifier_Advanced_uproar_debuff or class({})
function modifier_Advanced_uproar_debuff:IsHidden()	return false end
function modifier_Advanced_uproar_debuff:IsDebuff()	return true end
function modifier_Advanced_uproar_debuff:IsPurgable()	return true end
function modifier_Advanced_uproar_debuff:GetTexture()	return "primal_beast_uproar" end
function modifier_Advanced_uproar_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	self.attack_slow = -self:GetAbility():GetSpecialValueFor( "attack_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_Advanced_uproar_debuff:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	self.attack_slow = -self:GetAbility():GetSpecialValueFor( "attack_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end


function modifier_Advanced_uproar_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_Advanced_uproar_debuff:GetModifierMoveSpeedBonus_Constant()
	return math.max(self.slow * self:GetStackCount(),-90)
end
function modifier_Advanced_uproar_debuff:GetModifierAttackSpeedBonus_Constant() 	return self.attack_slow * self:GetStackCount() end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_uproar_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_Advanced_uproar_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end



modifier_Advanced_uproar_modify_count = modifier_Advanced_uproar_modify_count or class({})
function modifier_Advanced_uproar_modify_count:IsHidden()	return true end
function modifier_Advanced_uproar_modify_count:IsDebuff()	return false end
function modifier_Advanced_uproar_modify_count:IsPurgable()	return false end
function modifier_Advanced_uproar_modify_count:IsPurgeException() return false end
function modifier_Advanced_uproar_modify_count:RemoveOnDeath() return false end
function modifier_Advanced_uproar_modify_count:OnCreated( keys )
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_uproar_modify_count:OnRefresh( keys )
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end
function modifier_Advanced_uproar_modify_count:ReducePoint(value)
	self:SetStackCount(self:GetStackCount()-value)
	if self:GetStackCount()<=0 then
		self:SafeDestroy()
	end

end

function modifier_Advanced_uproar_modify_count:OnIntervalThink()
	local nPlayerID = self:GetCaster():GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(nPlayerID)
	if player then
		local data ={
			spellName = self:GetAbility():GetAbilityName(),
			point = self:GetStackCount(),
			option = {
				"DOTA_HUD_spell_modify_1",
				"DOTA_HUD_spell_modify_2",
			}
		}
		CustomGameEventManager:Send_ServerToPlayer(player, "SpellModifyData", { data})
	end
	
end








modifier_Advanced_uproar_modify_1 = modifier_Advanced_uproar_modify_1 or class({})
function modifier_Advanced_uproar_modify_1:IsHidden()	return false end
function modifier_Advanced_uproar_modify_1:IsDebuff()	return false end
function modifier_Advanced_uproar_modify_1:IsPurgable()	return false end
function modifier_Advanced_uproar_modify_1:IsPurgeException() return false end
function modifier_Advanced_uproar_modify_1:RemoveOnDeath() return false end
function modifier_Advanced_uproar_modify_1:OnCreated( keys )
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Advanced_uproar_modify_1:OnRefresh( keys )
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end

function modifier_Advanced_uproar_modify_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end



function modifier_Advanced_uproar_modify_1:GetModifierPreAttack_BonusDamage()	return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetStackCount()*0.3 end




modifier_Advanced_uproar_modify_2 = modifier_Advanced_uproar_modify_2 or advanced_modifier({})
function modifier_Advanced_uproar_modify_2:IsHidden()	return trufalsee end
function modifier_Advanced_uproar_modify_2:IsDebuff()	return false end
function modifier_Advanced_uproar_modify_2:IsPurgable()	return false end
function modifier_Advanced_uproar_modify_2:IsPurgeException() return false end
function modifier_Advanced_uproar_modify_2:RemoveOnDeath() return false end
function modifier_Advanced_uproar_modify_2:OnCreated( keys )
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Advanced_uproar_modify_2:OnRefresh( keys )
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end




function modifier_Advanced_uproar_modify_2:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_uproar_modify_2:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_uproar_modify_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_uproar_modify_2:Advanced_GetModifierPhysicalArmorBonus()
	return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )*self:GetStackCount()*0.4

end








modifier_Advanced_uproar_debuff2 = class({})

function modifier_Advanced_uproar_debuff2:IsDebuff() return true end
function modifier_Advanced_uproar_debuff2:IsHidden() return false end
function modifier_Advanced_uproar_debuff2:IsPurgable() return false end
function modifier_Advanced_uproar_debuff2:IsPurgeException() return true end

function modifier_Advanced_uproar_debuff2:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED]=true,

	}
	

	return state
end
