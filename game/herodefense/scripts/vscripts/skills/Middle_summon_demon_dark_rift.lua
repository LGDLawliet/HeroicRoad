

Middle_summon_demon_dark_rift						= Middle_summon_demon_dark_rift or class({})


LinkLuaModifier( "modifier_Middle_summon_demon_dark_rift_gate", "skills/Middle_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_demon_dark_rift_gate_ani", "skills/Middle_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_demon_dark_rift_demon_status", "skills/Middle_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_demon_dark_rift_demon_buff", "skills/Middle_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_demon_dark_rift_buff", "skills/Middle_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )

function Middle_summon_demon_dark_rift:IsSummonSpell()return true end


function Middle_summon_demon_dark_rift:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )




	
	PrecacheResource( "model", "models/heroes/abyssal_underlord/abyssal_underlord_portal_model.vmdl", context )
end


function Middle_summon_demon_dark_rift:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end



function Middle_summon_demon_dark_rift:OnSpellStart()

	
	local caster =self:GetCaster()
	EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetCaster())	
	--召唤强度
	local unit = CreateUnitByName("npc_hd_dark_rift", self:GetCursorPosition(), true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, self or nil, "modifier_kill", {duration =  self:GetSpecialValueFor("gate_duration")}) --召唤持续时间
	unit:AddNewModifier(caster, self or nil, "modifier_Middle_summon_demon_dark_rift_gate", {}) 
	unit:SetForwardVector(caster:GetForwardVector())
	FindClearSpaceForUnit( unit, self:GetCursorPosition(), true )

	

end

function Middle_summon_demon_dark_rift:TrySpawnSingleDemon(parent)
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
	
	
	local unit = caster:SummonUnit("npc_hd_small_demon_1",life_duration,
	parent:GetAbsOrigin() + (parent:GetForwardVector() * 128),
	parent:GetForwardVector(),self,0,heal,0,damage,armor,1,1)
	unit:SetSpecialSummoned(true)
	unit:AddNewModifier(caster, self or nil, "modifier_Middle_summon_demon_dark_rift_demon_status", {}) 
	unit:AddNewModifier(caster, self or nil, "modifier_Middle_summon_demon_dark_rift_demon_buff", {}) 
	caster:InsertSpecialSummonedList(unit_type,unit)
	parent:AddNewModifier(parent, self or nil, "modifier_Middle_summon_demon_dark_rift_gate_ani", {duration = 0.2}) 
	parent:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	
	ParticleManager:SetParticleControl( nFXIndex, 0, parent:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100,100,100) )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )

	
end




modifier_Middle_summon_demon_dark_rift_gate = modifier_Middle_summon_demon_dark_rift_gate or  class({})

function modifier_Middle_summon_demon_dark_rift_gate:IsDebuff()			    return false end
function modifier_Middle_summon_demon_dark_rift_gate:IsHidden() 			return true end
function modifier_Middle_summon_demon_dark_rift_gate:IsPurgable() 			return false end
function modifier_Middle_summon_demon_dark_rift_gate:IsPurgeException() 	return false end
-- function modifier_Middle_summon_demon_dark_rift_gate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_summon_demon_dark_rift_gate:OnCreated(keys)
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
function modifier_Middle_summon_demon_dark_rift_gate:CheckState() return 
	{
	[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 

	} 
end
function modifier_Middle_summon_demon_dark_rift_gate:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:TrySpawnSingleDemon(self:GetParent())
end




modifier_Middle_summon_demon_dark_rift_gate_ani = modifier_Middle_summon_demon_dark_rift_gate_ani or  class({})

function modifier_Middle_summon_demon_dark_rift_gate_ani:IsDebuff()			    return false end
function modifier_Middle_summon_demon_dark_rift_gate_ani:IsHidden() 			return true end
function modifier_Middle_summon_demon_dark_rift_gate_ani:IsPurgable() 			return false end
function modifier_Middle_summon_demon_dark_rift_gate_ani:IsPurgeException() 	return false end
function modifier_Middle_summon_demon_dark_rift_gate_ani:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_Middle_summon_demon_dark_rift_gate_ani:GetOverrideAnimation(params)

	return ACT_DOTA_CHANNEL_ABILITY_1
end



modifier_Middle_summon_demon_dark_rift_demon_status = modifier_Middle_summon_demon_dark_rift_demon_status or  class({})

function modifier_Middle_summon_demon_dark_rift_demon_status:IsDebuff()			    return false end
function modifier_Middle_summon_demon_dark_rift_demon_status:IsHidden() 			return true end
function modifier_Middle_summon_demon_dark_rift_demon_status:IsPurgable() 			return false end
function modifier_Middle_summon_demon_dark_rift_demon_status:IsPurgeException() 	return false end
function modifier_Middle_summon_demon_dark_rift_demon_status:RemoveOnDeath()return false end
function modifier_Middle_summon_demon_dark_rift_demon_status:GetStatusEffectName()
	return "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf"
end
function modifier_Middle_summon_demon_dark_rift_demon_status:StatusEffectPriority() return 9999999 end







modifier_Middle_summon_demon_dark_rift_demon_buff = modifier_Middle_summon_demon_dark_rift_demon_buff or  class({})

function modifier_Middle_summon_demon_dark_rift_demon_buff:IsDebuff()			    return false end
function modifier_Middle_summon_demon_dark_rift_demon_buff:IsHidden() 			return true end
function modifier_Middle_summon_demon_dark_rift_demon_buff:IsPurgable() 			return false end
function modifier_Middle_summon_demon_dark_rift_demon_buff:IsPurgeException() 	return false end




function modifier_Middle_summon_demon_dark_rift_demon_buff:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local duration = 18 * caster:GetModifierDurationGainIndex(1)
		local index = 0.05
		local stack = parent:GetDamageMax()*index
		if stack<=0 then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit~=caster then
				self:PlayEffect(unit)
				unit:AddNewModifier(caster,ability, "modifier_Middle_summon_demon_dark_rift_buff", {duration = duration,stack=stack}) 
				return
			end
		end

		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if not unit:IsSpecialSummoned() then
				unit:AddNewModifier(caster,ability, "modifier_Middle_summon_demon_dark_rift_buff", {duration = duration,stack=stack}) 
				self:PlayEffect(unit)
				return
			end
		end
	end

end

function modifier_Middle_summon_demon_dark_rift_demon_buff:PlayEffect(target)
	local parent = self:GetParent()
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN, parent)
	ParticleManager:SetParticleControlEnt(pfx1, 0, castparenter, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx1)

end






modifier_Middle_summon_demon_dark_rift_buff = class({})

function modifier_Middle_summon_demon_dark_rift_buff:IsDebuff() return false end
function modifier_Middle_summon_demon_dark_rift_buff:IsHidden() return false end
function modifier_Middle_summon_demon_dark_rift_buff:IsPurgable() 		return false end
function modifier_Middle_summon_demon_dark_rift_buff:IsPurgeException() 	return false end
function modifier_Middle_summon_demon_dark_rift_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end
function modifier_Middle_summon_demon_dark_rift_buff:GetModifierPreAttack_BonusDamage( params )
	return math.min(self:GetStackCount(),5000)
end


function modifier_Middle_summon_demon_dark_rift_buff:OnCreated(keys)
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
function modifier_Middle_summon_demon_dark_rift_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		-- local dieTime = GameRules:GetGameTime()+keys.stack_time

		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_Middle_summon_demon_dark_rift_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end



