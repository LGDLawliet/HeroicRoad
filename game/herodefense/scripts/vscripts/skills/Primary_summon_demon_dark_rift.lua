

Primary_summon_demon_dark_rift						= Primary_summon_demon_dark_rift or class({})


LinkLuaModifier( "modifier_Primary_summon_demon_dark_rift_gate", "skills/Primary_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_summon_demon_dark_rift_gate_ani", "skills/Primary_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_summon_demon_dark_rift_demon_buff", "skills/Primary_summon_demon_dark_rift", LUA_MODIFIER_MOTION_NONE )

function Primary_summon_demon_dark_rift:IsSummonSpell()return true end

function Primary_summon_demon_dark_rift:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf", context )




	
	PrecacheResource( "model", "models/heroes/abyssal_underlord/abyssal_underlord_portal_model.vmdl", context )
end

function Primary_summon_demon_dark_rift:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end




function Primary_summon_demon_dark_rift:OnSpellStart()

	
	local caster =self:GetCaster()
	EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetCaster())	
	--召唤强度
	local unit = CreateUnitByName("npc_hd_dark_rift", self:GetCursorPosition(), true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, self or nil, "modifier_kill", {duration =  self:GetSpecialValueFor("gate_duration")}) --召唤持续时间
	unit:AddNewModifier(caster, self or nil, "modifier_Primary_summon_demon_dark_rift_gate", {}) 
	unit:SetForwardVector(caster:GetForwardVector())
	FindClearSpaceForUnit( unit, self:GetCursorPosition(), true )

	

end

function Primary_summon_demon_dark_rift:TrySpawnSingleDemon(parent)
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
	
	unit:AddNewModifier(parent, self or nil, "modifier_Primary_summon_demon_dark_rift_demon_buff", {}) 
	caster:InsertSpecialSummonedList(unit_type,unit)
	parent:AddNewModifier(parent, self or nil, "modifier_Primary_summon_demon_dark_rift_gate_ani", {duration = 0.2}) 
	parent:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	
	ParticleManager:SetParticleControl( nFXIndex, 0, parent:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100,100,100) )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )

	
end




modifier_Primary_summon_demon_dark_rift_gate = modifier_Primary_summon_demon_dark_rift_gate or  class({})

function modifier_Primary_summon_demon_dark_rift_gate:IsDebuff()			    return false end
function modifier_Primary_summon_demon_dark_rift_gate:IsHidden() 			return true end
function modifier_Primary_summon_demon_dark_rift_gate:IsPurgable() 			return false end
function modifier_Primary_summon_demon_dark_rift_gate:IsPurgeException() 	return false end
-- function modifier_Primary_summon_demon_dark_rift_gate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_summon_demon_dark_rift_gate:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_portal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, parent, PATTACH_POINT_FOLLOW, "attach_portal", parent:GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self.spawn_intetval = self:GetAbility():GetSpecialValueFor("spawn_interval")
		self:StartIntervalThink(self.spawn_intetval)
	end
end
-- function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:GetStatusEffectName()
-- 	return "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf"
-- end
function modifier_Primary_summon_demon_dark_rift_gate:CheckState() return 
	{
	[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 

	} 
end
function modifier_Primary_summon_demon_dark_rift_gate:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:TrySpawnSingleDemon(self:GetParent())
end




modifier_Primary_summon_demon_dark_rift_gate_ani = modifier_Primary_summon_demon_dark_rift_gate_ani or  class({})

function modifier_Primary_summon_demon_dark_rift_gate_ani:IsDebuff()			    return false end
function modifier_Primary_summon_demon_dark_rift_gate_ani:IsHidden() 			return true end
function modifier_Primary_summon_demon_dark_rift_gate_ani:IsPurgable() 			return false end
function modifier_Primary_summon_demon_dark_rift_gate_ani:IsPurgeException() 	return false end
function modifier_Primary_summon_demon_dark_rift_gate_ani:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_Primary_summon_demon_dark_rift_gate_ani:GetOverrideAnimation(params)

	return ACT_DOTA_CHANNEL_ABILITY_1
end



modifier_Primary_summon_demon_dark_rift_demon_buff = modifier_Primary_summon_demon_dark_rift_demon_buff or  class({})

function modifier_Primary_summon_demon_dark_rift_demon_buff:IsDebuff()			    return false end
function modifier_Primary_summon_demon_dark_rift_demon_buff:IsHidden() 			return true end
function modifier_Primary_summon_demon_dark_rift_demon_buff:IsPurgable() 			return false end
function modifier_Primary_summon_demon_dark_rift_demon_buff:IsPurgeException() 	return false end
function modifier_Primary_summon_demon_dark_rift_demon_buff:RemoveOnDeath()return false end
function modifier_Primary_summon_demon_dark_rift_demon_buff:GetStatusEffectName()
	return "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf"
end
function modifier_Primary_summon_demon_dark_rift_demon_buff:StatusEffectPriority() return 9999999 end