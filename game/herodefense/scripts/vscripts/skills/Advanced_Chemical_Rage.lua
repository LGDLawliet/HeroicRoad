Advanced_Chemical_Rage = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Chemical_Rage", "skills/Advanced_Chemical_Rage", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_Chemical_Rage_unlock3", "skills/Advanced_Chemical_Rage", LUA_MODIFIER_MOTION_NONE )



function Advanced_Chemical_Rage:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lunar_blessing_unlock1",{})
	-- self:SetLevel(0)
	-- self:SetLevel(1)
	return true
end
function Advanced_Chemical_Rage:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Chemical_Rage:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_howl_unlock3",{})
	return true
end







function Advanced_Chemical_Rage:CheckKV(key)
	local table = {
		duration =0.5,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Chemical_Rage:GetBehavior()
	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end
function Advanced_Chemical_Rage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Chemical_Rage", -- modifier name
		{ duration = duration*ModifierStatusGain } -- kv
	)

	-- play effects
	local sound_cast = "Hero_Alchemist.ChemicalRage.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )



	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)
	--标记改
	local count =1

	local info = {
		-- Target = units[2],
		Source = caster,
		Ability = self,	
		
		EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
		iMoveSpeed = 750,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		-- iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			-- brew_time = brew_time,
		}
	}
	if self.advanced_level>=10 then
		count = 2
		if self.unlock2 then
			count = 5
			--分发给召唤物
			local units_basic = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
			)
			for index, unit in ipairs(units_basic) do
				info.Target = unit
				ProjectileManager:CreateTrackingProjectile(info)
				if index>=10 then
					break
				end
			end

		end
	end
	for _, unit in ipairs(units) do
		if unit~=caster and unit:IsRealHero() then
			info.Target = unit
			ProjectileManager:CreateTrackingProjectile(info)
			count = count - 1
			if count<=0 then
				break
			end
		end
	end
	
	
	-- Play effects
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
	EmitSoundOn( sound_cast, caster )
end


function Advanced_Chemical_Rage:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_Advanced_Chemical_Rage", -- modifier name
		{ duration = duration*ModifierStatusGain } -- kv
	)

	-- play effects
	local sound_cast = "Hero_Alchemist.ChemicalRage.Cast"
	EmitSoundOn( sound_cast,target )


end

--------------------------------------------------------------------------------
function Advanced_Chemical_Rage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end



modifier_Advanced_Chemical_Rage = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chemical_Rage:IsHidden()return false end
function modifier_Advanced_Chemical_Rage:IsDebuff()return false end
function modifier_Advanced_Chemical_Rage:IsStunDebuff()return false end
function modifier_Advanced_Chemical_Rage:IsPurgable()return false end
function modifier_Advanced_Chemical_Rage:AllowIllusionDuplicate()return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Chemical_Rage:OnCreated( kv )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	-- references
	self.bat = ability:GetSpecialValueFor( "base_attack_time" )
	self.health = ability:GetSpecialValueFor( "bonus_health" )
	self.health_regen = ability:GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = ability:GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = ability:GetSpecialValueFor( "bonus_movespeed" )
	self.attack_speed = 0
	self.bonus_status_resistance = 0
	--LV15解锁超越极限二阶
	if self.advanced_level>=15 then
		self.movespeed = self.movespeed +50
		self.attack_speed = 100
		if self.advanced_level>=20 then
			self.bonus_status_resistance = 50
		end
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		self.bat = self.bat -0.15
		self.alchemist_talent = true
	end
	

	if not IsServer() then return end
	if self.alchemist_talent then
		self:GetParent():StartGestureFadeWithSequenceSettings(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
	end


	if ability:GetAutoCastState() then
		self:GetParent():AddNewModifier(
		caster, -- player source
		ability, -- ability source
		"modifier_Advanced_Chemical_Rage_unlock3", -- modifier name
		{})
		
	end
	self.unlock1_count = 0
	-- disjoint & purge
	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )
	self.max_stack = 30
	if self.advanced_level>=5 then
		self.max_stack = 40
	end
	--LV20解锁超越极限三阶

	self:SetStackCount(0)
	-- play effects
	self:PlayEffects()
	self:StartIntervalThink(1)
end

function modifier_Advanced_Chemical_Rage:OnRefresh( kv )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	-- references
	self.bat = ability:GetSpecialValueFor( "base_attack_time" )
	self.health = ability:GetSpecialValueFor( "bonus_health" )
	self.health_regen = ability:GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = ability:GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = ability:GetSpecialValueFor( "bonus_movespeed" )
	self.attack_speed = 0
	--LV15解锁超越极限二阶
	if self.advanced_level>=15 then
		self.movespeed = self.movespeed +50
		self.attack_speed = 100
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		self.bat = self.bat -0.15
		self.alchemist_talent = true
	end
	if not IsServer() then return end
	self.max_stack = 30
	if self.advanced_level>=5 then
		self.max_stack = 40
	end
	-- disjoint & purge
	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )
	self:SetStackCount(0)
end

function modifier_Advanced_Chemical_Rage:OnIntervalThink()

	if self:GetStackCount()>=self.max_stack then
		return
	end
	self:IncrementStackCount()
end



function modifier_Advanced_Chemical_Rage:OnDestroy()
	if not IsServer() then return end

	local sound_cast = "Hero_Alchemist.ChemicalRage"
	StopSoundOn( sound_cast, self:GetParent() )
	self:GetParent():RemoveModifierByName("modifier_Advanced_Chemical_Rage_unlock3")
	if self.alchemist_talent then
		self:GetParent():StartGestureFadeWithSequenceSettings(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Chemical_Rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		table.insert(funcs,MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS)
	end

	return funcs
end
function modifier_Advanced_Chemical_Rage:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end
function modifier_Advanced_Chemical_Rage:GetModifierBaseAttackTimeConstant()
	return math.max(self.bat-self:GetStackCount()*0.01,0.01)
end
function modifier_Advanced_Chemical_Rage:AdvancedGetModifierConstantHealthRegen()
	return self.health_regen
end
function modifier_Advanced_Chemical_Rage:GetModifierHealthBonus()
	return self.health
end
function modifier_Advanced_Chemical_Rage:GetModifierConstantManaRegen()
	return self.mana_regen
end
function modifier_Advanced_Chemical_Rage:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end
function modifier_Advanced_Chemical_Rage:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_Advanced_Chemical_Rage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
	local sound_cast = "Hero_Alchemist.ChemicalRage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end



function modifier_Advanced_Chemical_Rage:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	if self.advanced_level<20 then
		return
	end
	--不反映刃甲伤害
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	--生命丢失也不要
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	--技能伤害不要
	-- print(" keys.damage_category=".. keys.damage_category)
	if keys.damage_category~=1 then 
		return 0
	end
	if IsServer() then
		--返还生命值
		local dmg = keys.damage*0.2
		local parent = self:GetParent()
		parent:Heal(dmg, parent)
		
		
	end
end

function modifier_Advanced_Chemical_Rage:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		if keys.attacker ~=parent then
			return
		end

		
		if parent==self:GetCaster() then
			return
		end
		if not parent:IsApplyModifier() or parent:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end

		self.unlock1_count = self.unlock1_count +1
		if self.unlock1_count>=6 then
			self.unlock1_count = 0
			local caster = self:GetCaster()
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			caster:PerformAttack(keys.target, false, true, true, false, true, false, true)
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end

	end
end



function modifier_Advanced_Chemical_Rage:GetActivityTranslationModifiers()	
	return "chemical_rage" 
end



-- advanced_modifier
function modifier_Advanced_Chemical_Rage:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)

	end
	return funcs
end
function modifier_Advanced_Chemical_Rage:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 30
end


function modifier_Advanced_Chemical_Rage:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end





modifier_Advanced_Chemical_Rage_unlock3 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Chemical_Rage_unlock3:IsHidden()return true end
function modifier_Advanced_Chemical_Rage_unlock3:IsDebuff()return false end
function modifier_Advanced_Chemical_Rage_unlock3:IsStunDebuff()return false end
function modifier_Advanced_Chemical_Rage_unlock3:IsPurgable()return false end
function modifier_Advanced_Chemical_Rage_unlock3:AllowIllusionDuplicate()return true end
function modifier_Advanced_Chemical_Rage_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}


	return funcs
end

function modifier_Advanced_Chemical_Rage_unlock3:GetModifierDamageOutgoing_Percentage()
	return 100
end


function modifier_Advanced_Chemical_Rage_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_Chemical_Rage_unlock3:Advanced_GetModifierPhysicalArmorBonus()
    return -200
end