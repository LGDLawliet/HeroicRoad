
--特效优化 √
LinkLuaModifier( "modifier_Advanced_frost_armor_buff", "skills/Advanced_frost_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frost_armor_debuff", "skills/Advanced_frost_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frost_armor_debuff_unlock2", "skills/Advanced_frost_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frost_armor_unlock3", "skills/Advanced_frost_armor", LUA_MODIFIER_MOTION_NONE )
Advanced_frost_armor = class({})
function Advanced_frost_armor:CheckKV(key)
	local table = {


		damage_reduce = 0.7,
		damage = 4,
		bonus_damage =0.02,


	}
	local value = table[key] or -1
	return value

end


function Advanced_frost_armor:UnlockFirstCore(key)
	return true
end
function Advanced_frost_armor:UnlockSecondCore(key)
		-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lightning_storm_unlock2",{})
	return true
end
function Advanced_frost_armor:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_frost_armor_unlock3",{})
	return true
end

function Advanced_frost_armor:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/frost_armor/unlock1/effect_dmg.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", context )
end

function Advanced_frost_armor:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_frost_armor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	if self.advanced_level>=10 then
		duration =12
	end
	local gain = caster:GetModifierDurationGainIndex(1)
	-- local bonus_regen = math.max(target:GetMaxHealth()*0.02,50)
	-- add modifier
	target:AddNewModifier(caster,self, "modifier_Advanced_frost_armor_buff", { duration = duration*gain })
	if caster~=target then
		caster:AddNewModifier(caster,self, "modifier_Advanced_frost_armor_buff", { duration = duration*gain })
	end

	-- effects
	local sound_cast = "Hero_Lich.FrostArmor"
	EmitSoundOn( sound_cast, self:GetCaster() )
end




modifier_Advanced_frost_armor_buff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_frost_armor_buff:IsHidden()	return false end
function modifier_Advanced_frost_armor_buff:IsDebuff()	return false end
function modifier_Advanced_frost_armor_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_INVULNERABLE 
end

function modifier_Advanced_frost_armor_buff:IsPurgable()	return true end



--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_frost_armor_buff:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	-- references
	self.damage_reduce = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )
	local index = 0.02
	if self.advanced_level>=5 then
		index = 0.03
	end
	self.regen = math.max(self:GetParent():GetMaxHealth()*index,50)
	self.bonus_magic_resistance = 0
	if self.advanced_level>=15 then
		self.bonus_magic_resistance = 35
	end
	if IsServer() then
		self:StartIntervalThink(1)
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0,parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(radius,radius,radius), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		self.unlock1_damage_count = 0
	end
	

end

function modifier_Advanced_frost_armor_buff:OnRefresh( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	-- references
	self.damage_reduce = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )
	local index = 0.02
	if self.advanced_level>=5 then
		index = 0.03
	end
	self.regen = math.max(self:GetParent():GetMaxHealth()*index,50)
	self.bonus_magic_resistance = 0
	if self.advanced_level>=15 then
		self.bonus_magic_resistance = 35
	end


	
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_frost_armor_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	local ability = self:GetAbility()
	if ability:GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	elseif ability:GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end

	return funcs
end
function modifier_Advanced_frost_armor_buff:Advanced_GetModifierPhysicalArmorBonus() return 500 end 

function modifier_Advanced_frost_armor_buff:GetModifierIncomingPhysicalDamage_Percentage(keys)
	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
		return self.damage_reduce
	end
	return 0
end





function modifier_Advanced_frost_armor_buff:AdvancedGetModifierConstantHealthRegen(keys)
	
	return self.regen
end

function modifier_Advanced_frost_armor_buff:GetModifierMagicalResistanceBonus(keys)
	return self.bonus_magic_resistance
end
function modifier_Advanced_frost_armor_buff:OnIntervalThink()
	local pos = self:GetParent():GetAbsOrigin()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local radius = ability:GetSpecialValueFor("radius")
	caster:EmitSound("Hero_Lich.IceAge.Tick")
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	 local damage = ability:GetSpecialValueFor("damage")+(ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	for _, enemy in pairs(enemies) do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, ability, "modifier_Advanced_frost_armor_debuff", {duration = ability:GetSpecialValueFor( "slow_duration" )*StatusResistance})
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
							}
		ApplyDamage(damageTable)

	end
	if self.advanced_level>=20 and #enemies>0 then
		parent:GiveMana(#enemies*20)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, parent, #enemies*20, nil)
	end
end




function modifier_Advanced_frost_armor_buff:OnTakeDamage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent and not parent:PassivesDisabled() then
			--过滤不该触发的伤害
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	
			if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

			if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
				self.unlock1_damage_count = self.unlock1_damage_count + keys.damage
				
			end

		end
	end
end

function modifier_Advanced_frost_armor_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			local parent = self:GetParent()
			if self.unlock1_damage_count>0 then
				local radius = 600
				parent:EmitSound("Hero_Lich.IceAge.Tick")
				local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/frost_armor/unlock1/effect_dmg.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 2, Vector(radius,radius,radius))
				-- ParticleManager:ReleaseParticleIndex( effect_cast )
				DestroyParticleByDelay(effect_cast,3)
				local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local damage = self.unlock1_damage_count * 2
				local damageTable = {
					-- victim = enemy,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = ability:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = ability, --Optional.
					}
				for _, enemy in pairs(enemies) do
					damageTable.victim = enemy
					ApplyDamage(damageTable)

				end
			end
		
		end
	end
end


function modifier_Advanced_frost_armor_buff:OnAttackLanded(keys)
	if not IsServer()  then
		return
	end
	local parent = self:GetParent()
	if  keys.target ~=parent then
		return
	end
	if not IsEnemy(keys.attacker,parent) then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if caster:GetRandomEffect(10,INT_TYPE,1)  > RandomInt(1, 100) then
		keys.attacker:AddNewModifier(caster, ability, "modifier_Advanced_frost_armor_debuff_unlock2", {duration =2})
	end

	
end



function modifier_Advanced_frost_armor_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	local ability = self:GetAbility()
	if ability:GetUnlock(1)==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)

	end
    return funcs
end





modifier_Advanced_frost_armor_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_frost_armor_debuff:IsHidden()	return false end
function modifier_Advanced_frost_armor_debuff:IsDebuff()	return true end
function modifier_Advanced_frost_armor_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_frost_armor_debuff:OnCreated( kv )
	self.move_slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
end




--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_frost_armor_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_frost_armor_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.move_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_frost_armor_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end







modifier_Advanced_frost_armor_debuff_unlock2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_frost_armor_debuff_unlock2:IsHidden()	return false end
function modifier_Advanced_frost_armor_debuff_unlock2:IsDebuff()	return true end
function modifier_Advanced_frost_armor_debuff_unlock2:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_frost_armor_debuff_unlock2:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
		parent:EmitSound("Hero_Lich.SinisterGaze.Target")
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )
		-- ParticleManager:SetParticleControl( effect_cast, 2, Vector(radius,radius,radius))
		DestroyParticleByDelay(effect_cast,5)
	end
end




--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_frost_armor_debuff_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_frost_armor_debuff_unlock2:GetModifierAttackSpeedBonus_Constant()
	return -1000
end






modifier_Advanced_frost_armor_unlock3 = class({})

function modifier_Advanced_frost_armor_unlock3:IsDebuff()			return false end
function modifier_Advanced_frost_armor_unlock3:IsHidden() 			return true end
function modifier_Advanced_frost_armor_unlock3:IsPurgable() 		    return false end
function modifier_Advanced_frost_armor_unlock3:IsPurgeException() return false end
function modifier_Advanced_frost_armor_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_frost_armor_unlock3:OnCreated(keys)
    if IsServer() then
        self:StartIntervalThink(3)     
    end
end
function modifier_Advanced_frost_armor_unlock3:OnIntervalThink()
	local caster = self:GetCaster()
 
	local ability = self:GetAbility()

	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_FARTHEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,unit in pairs(units) do
		if unit~=caster and not unit:HasModifier("modifier_Advanced_frost_armor_buff") then
			caster:SetCursorCastTarget(unit)
			ability:OnSpellStart()
			return
		end

	end
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_FARTHEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,unit in pairs(units) do
		if not unit:HasModifier("modifier_Advanced_frost_armor_buff") then
			caster:SetCursorCastTarget(unit)
			ability:OnSpellStart()
			return
		end
	
		
	end
	caster:SetCursorCastTarget(caster)
	ability:OnSpellStart()
end

