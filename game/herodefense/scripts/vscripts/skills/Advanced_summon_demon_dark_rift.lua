

Advanced_summon_demon_dark_rift						= Advanced_summon_demon_dark_rift or class({})


LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_gate", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_gate_ani", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_demon_status", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_demon_buff", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_buff", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_unlock1", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_unlock3", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15", "skills/Advanced_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )


function Advanced_summon_demon_dark_rift:IsSummonSpell()return true end

function Advanced_summon_demon_dark_rift:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti10/hot_potato/hot_potato_explode.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_extra_second.vpcf", context )



	
	PrecacheResource( "model", "models/heroes/abyssal_underlord/abyssal_underlord_portal_model.vmdl", context )
end

function Advanced_summon_demon_dark_rift:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end



function Advanced_summon_demon_dark_rift:CheckKVFixedOverride(key)
	if key=="spawn_interval" then
		if self:GetSpecialValueFor("advanced_level")>=10 then
			if self:GetUnlock(3)==3 then
				return 0.5
			end
			return 1.3
		end
	end


	return -999999

end
function Advanced_summon_demon_dark_rift:CheckKV(key)
	local table = {
		bonus_damage=0.7,
		gate_duration=0.4,


	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_demon_dark_rift:UnlockFirstCore(key)
	return true
end
function Advanced_summon_demon_dark_rift:UnlockSecondCore(key)
	return true
end
function Advanced_summon_demon_dark_rift:UnlockThirdCore(key)
	return true
end

function Advanced_summon_demon_dark_rift:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_POINT
	end
end


function Advanced_summon_demon_dark_rift:OnSpellStart()

	
	local caster =self:GetCaster()
	EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetCaster())	
	--召唤强度
	local unit = CreateUnitByName("npc_hd_dark_rift", self:GetCursorPosition(), true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, self or nil, "modifier_kill", {duration = self:GetSpecialValueFor("gate_duration")}) --召唤持续时间
	unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_demon_dark_rift_gate", {}) 
	unit:SetForwardVector(caster:GetForwardVector())
	FindClearSpaceForUnit( unit, self:GetCursorPosition(), true )

	

end

function Advanced_summon_demon_dark_rift:TrySpawnSingleDemon(parent)
	local caster = self:GetCaster()

	local unit_type = "dark_rift_demon"
	local units = caster:GetSpecialSummonedList(unit_type)
	if #units>=15 then
		return
	end

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	if self:GetAutoCastState() then
		heal = heal * 0.5
		damage = damage * 1.5
	end
	
	if self.unlock2 then
		damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.12
	end
	
	local unit = caster:SummonUnit("npc_hd_small_demon_1",life_duration,
	parent:GetAbsOrigin() + (parent:GetForwardVector() * 128),
	parent:GetForwardVector(),self,0,heal,0,damage,armor,1,1)
	unit:SetSpecialSummoned(true)
	unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_demon_dark_rift_demon_status", {}) 
	unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_demon_dark_rift_demon_buff", {}) 
	if self.advanced_level>=15 then
		
		unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15", {}) 
		if self.unlock3 then
			unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_demon_dark_rift_unlock3", {}) 
			
		end
	end
	caster:InsertSpecialSummonedList(unit_type,unit)
	parent:AddNewModifier(parent, self or nil, "modifier_Advanced_summon_demon_dark_rift_gate_ani", {duration = 0.2}) 
	parent:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	
	ParticleManager:SetParticleControl( nFXIndex, 0, parent:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100,100,100) )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )

	
end




modifier_Advanced_summon_demon_dark_rift_gate = modifier_Advanced_summon_demon_dark_rift_gate or  class({})

function modifier_Advanced_summon_demon_dark_rift_gate:IsDebuff()			    return false end
function modifier_Advanced_summon_demon_dark_rift_gate:IsHidden() 			return true end
function modifier_Advanced_summon_demon_dark_rift_gate:IsPurgable() 			return false end
function modifier_Advanced_summon_demon_dark_rift_gate:IsPurgeException() 	return false end
-- function modifier_Advanced_summon_demon_dark_rift_gate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_summon_demon_dark_rift_gate:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self.spawn_intetval = self:GetAbility():GetSpecialValueFor("spawn_interval")
		self:StartIntervalThink(self.spawn_intetval)
	end
end
function modifier_Advanced_summon_demon_dark_rift_gate:CheckState() return 
	{
	[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 

	} 
end
function modifier_Advanced_summon_demon_dark_rift_gate:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:TrySpawnSingleDemon(self:GetParent())
end




modifier_Advanced_summon_demon_dark_rift_gate_ani = modifier_Advanced_summon_demon_dark_rift_gate_ani or  class({})

function modifier_Advanced_summon_demon_dark_rift_gate_ani:IsDebuff()			    return false end
function modifier_Advanced_summon_demon_dark_rift_gate_ani:IsHidden() 			return true end
function modifier_Advanced_summon_demon_dark_rift_gate_ani:IsPurgable() 			return false end
function modifier_Advanced_summon_demon_dark_rift_gate_ani:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_gate_ani:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_Advanced_summon_demon_dark_rift_gate_ani:GetOverrideAnimation(params)

	return ACT_DOTA_CHANNEL_ABILITY_1
end



modifier_Advanced_summon_demon_dark_rift_demon_status = modifier_Advanced_summon_demon_dark_rift_demon_status or  class({})

function modifier_Advanced_summon_demon_dark_rift_demon_status:IsDebuff()			    return false end
function modifier_Advanced_summon_demon_dark_rift_demon_status:IsHidden() 			return true end
function modifier_Advanced_summon_demon_dark_rift_demon_status:IsPurgable() 			return false end
function modifier_Advanced_summon_demon_dark_rift_demon_status:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_demon_status:RemoveOnDeath()return false end
function modifier_Advanced_summon_demon_dark_rift_demon_status:GetStatusEffectName()
	return "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf"
end
function modifier_Advanced_summon_demon_dark_rift_demon_status:StatusEffectPriority() return 9999999 end



function modifier_Advanced_summon_demon_dark_rift_demon_status:DeclareFunctions()
	local funcs={}
	if self:GetAbility().unlock1 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end
	
	return funcs
end


function modifier_Advanced_summon_demon_dark_rift_demon_status:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	


	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if unit~=parent and unit:HasModifier("modifier_Advanced_summon_demon_dark_rift_unlock1") then
			self:TriggerUnlock1Effect(unit,parent)
			
			return
		end
	end

	parent:AddNewModifier(parent,ability, "modifier_Advanced_summon_demon_dark_rift_unlock1", {duration = 3}) 
end

function modifier_Advanced_summon_demon_dark_rift_demon_status:TriggerUnlock1Effect(unit1,unit2)
	local pos = (unit1:GetOrigin() + unit2:GetOrigin())*0.5
	unit1:ModifySummonedDuration(0.03)
	unit2:ModifySummonedDuration(0.03)
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti10/hot_potato/hot_potato_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, pos+Vector(0,0,128))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_extra_second.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 3, pos+Vector(0,0,128))
	ParticleManager:SetParticleControl( nFXIndex, 5, Vector(400,400,400))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	unit1:EmitSound("Hero_Techies.RemoteMine.Detonate")
	unit2:EmitSound("Hero_Techies.Suicide")

	local damage =( unit1:GetAverageTrueAttackDamage(nil)+unit2:GetAverageTrueAttackDamage(nil))*8
	local caster = self:GetCaster()
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
	}

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for i,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		if i>=5 then
			break
		end
	end
	-- particles/econ/events/ti10/hot_potato/hot_potato_explode.vpcf
	-- particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_extra_second.vpcf
end


modifier_Advanced_summon_demon_dark_rift_demon_buff = modifier_Advanced_summon_demon_dark_rift_demon_buff or  class({})

function modifier_Advanced_summon_demon_dark_rift_demon_buff:IsDebuff()			    return false end
function modifier_Advanced_summon_demon_dark_rift_demon_buff:IsHidden() 			return true end
function modifier_Advanced_summon_demon_dark_rift_demon_buff:IsPurgable() 			return false end
function modifier_Advanced_summon_demon_dark_rift_demon_buff:IsPurgeException() 	return false end


function modifier_Advanced_summon_demon_dark_rift_demon_buff:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local duration = 18 * caster:GetModifierDurationGainIndex(1)
		local index = 0.05
		if ability.advanced_level>=5 then
			index = 0.075
		end
		local stack = parent:GetDamageMax()*index
		if stack<=0 then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit~=caster then
				self:PlayEffect(unit)
				unit:AddNewModifier(caster,ability, "modifier_Advanced_summon_demon_dark_rift_buff", {duration = duration,stack=stack}) 
				return
			end
		end

		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if not unit:IsSpecialSummoned() then
				unit:AddNewModifier(caster,ability, "modifier_Advanced_summon_demon_dark_rift_buff", {duration = duration,stack=stack}) 
				self:PlayEffect(unit)
				return
			end
		end
	end

end

function modifier_Advanced_summon_demon_dark_rift_demon_buff:PlayEffect(target)
	local parent = self:GetParent()
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN, parent)
	ParticleManager:SetParticleControlEnt(pfx1, 0, castparenter, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx1)

end






modifier_Advanced_summon_demon_dark_rift_buff = modifier_Advanced_summon_demon_dark_rift_buff or class({})

function modifier_Advanced_summon_demon_dark_rift_buff:IsDebuff() return false end
function modifier_Advanced_summon_demon_dark_rift_buff:IsHidden() return false end
function modifier_Advanced_summon_demon_dark_rift_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_demon_dark_rift_buff:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end
function modifier_Advanced_summon_demon_dark_rift_buff:GetModifierPreAttack_BonusDamage( params )
	return math.min(self:GetStackCount(),5000)
end


function modifier_Advanced_summon_demon_dark_rift_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_summon_demon_dark_rift_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		-- local dieTime = GameRules:GetGameTime()+keys.stack_time

		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_Advanced_summon_demon_dark_rift_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end




modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15 = modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15 or  advanced_modifier({})

function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:IsDebuff()			    return false end
function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:IsHidden() 			return true end
function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:IsPurgable() 			return false end
function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:OnCreated(keys)
	if IsServer() then
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
			if _G.GAME_ENDLESS_WAVE>=1 then
				self:SetStackCount(2)
			else
				self:SetStackCount(1)
			end
			if self:GetAbility().unlock2 then
				self:SetStackCount(self:GetStackCount()+4)
			end
		end
	end
end

function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	if self:GetStackCount()>=1 then
		if keys.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		self:DecrementStackCount()
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1,3)
		return -100
	else
		self:SafeDestroy()
	end
end


function modifier_Advanced_summon_demon_dark_rift_demon_buff_lv15:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end







modifier_Advanced_summon_demon_dark_rift_unlock1 = modifier_Advanced_summon_demon_dark_rift_unlock1 or class({})

function modifier_Advanced_summon_demon_dark_rift_unlock1:IsDebuff() return false end
function modifier_Advanced_summon_demon_dark_rift_unlock1:IsHidden() return true end
function modifier_Advanced_summon_demon_dark_rift_unlock1:IsPurgable() 		return false end
function modifier_Advanced_summon_demon_dark_rift_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_unlock1:OnCreated()
	if IsServer() then
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_SPAWN,0.5)
	end
end
function modifier_Advanced_summon_demon_dark_rift_unlock1:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	return state
end






modifier_Advanced_summon_demon_dark_rift_unlock3 = modifier_Advanced_summon_demon_dark_rift_unlock3 or class({})

function modifier_Advanced_summon_demon_dark_rift_unlock3:IsDebuff() return false end
function modifier_Advanced_summon_demon_dark_rift_unlock3:IsHidden() return true end
function modifier_Advanced_summon_demon_dark_rift_unlock3:IsPurgable() 		return false end
function modifier_Advanced_summon_demon_dark_rift_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_summon_demon_dark_rift_unlock3:DeclareFunctions()
	local funcs={MODIFIER_EVENT_ON_ATTACK_LANDED}
	return funcs
end


function modifier_Advanced_summon_demon_dark_rift_unlock3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	

	parent:ModifySummonedDuration(0.03)
	self:SafeDestroy()
end



function modifier_Advanced_summon_demon_dark_rift_unlock3:CheckState()
	return {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end