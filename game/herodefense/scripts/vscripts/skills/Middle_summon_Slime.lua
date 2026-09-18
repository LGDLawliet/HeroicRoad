

Middle_summon_Slime						= Middle_summon_Slime or class({})


LinkLuaModifier("modifier_Slime_arua", "skills/Middle_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_arua_effect", "skills/Middle_summon_Slime", LUA_MODIFIER_MOTION_NONE)


function Middle_summon_Slime:IsSummonSpell()return true end

function Middle_summon_Slime:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_slime/summon_slime.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ice_rain/ice_rain.vpcf", context )

end

function Middle_summon_Slime:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_Slardar.Slithereen_Crush", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_Slime",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)

		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_slime/summon_slime.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)


		unit:AddNewModifier(caster, self, "modifier_Slime_arua", {})
		

	end	

end








modifier_Slime_arua = class({})

function modifier_Slime_arua:IsDebuff()			return false end
function modifier_Slime_arua:IsHidden() 			return true end
function modifier_Slime_arua:IsPurgable() 		return false end
function modifier_Slime_arua:IsPurgeException() 	return false end
-- function modifier_Slime_arua:IsAura()	return self:GetAbility() and true or false end
-- function modifier_Slime_arua:GetModifierAura()	return "modifier_Slime_arua_effect" end
-- function modifier_Slime_arua:GetAuraRadius()	return 400  end
-- function modifier_Slime_arua:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_Slime_arua:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
-- function modifier_Slime_arua:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
-- function modifier_Slime_arua:GetAuraEntityReject(hEntity)
-- 	if hEntity:GetUnitName()=="npc_hd_Slime" or  hEntity == self:GetParent() then
-- 		return true
-- 	end
-- 	return false
-- end
function modifier_Slime_arua:OnCreated(keys)
	if IsServer() then
		local effect = "particles/rebuild/spell/ice_rain/ice_rain.vpcf"
		if self:GetAbility().unlock2 then
			effect = "particles/rebuild/spell/summon_slime_unlocl2/effect.vpcf"
		end

		self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(5,5,5) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.4)

	end

end
function modifier_Slime_arua:OnDestroy()
	if self.nFXIndex then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		self.nFXIndex = nil
	end
end


function modifier_Slime_arua:OnIntervalThink()
	local parent = self:GetParent()
	if not parent or not parent:IsAlive() then
		return
	end
	if parent:IsInvulnerable() then
		return
	end
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in ipairs(units) do
		if unit:GetUnitName()~="npc_hd_Slime" and  unit ~= self:GetParent() then
			unit:AddNewModifier(parent, self:GetAbility(), "modifier_Slime_arua_effect", { duration = 1.0 })
		end
	end
end


modifier_Slime_arua_effect = advanced_modifier({})

function modifier_Slime_arua_effect:IsDebuff()			return false end
function modifier_Slime_arua_effect:IsHidden() 			return false end
function modifier_Slime_arua_effect:IsPurgable() 		return false end
function modifier_Slime_arua_effect:IsPurgeException() 	return false end



function modifier_Slime_arua_effect:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_Slime_arua_effect:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	local target = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	if not target or target:IsNull() or not target:IsAlive() then
		return 0
	end
	local damage = keys.damage
	if damage<=0 then
		return 0
	end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS  ) == DOTA_DAMAGE_FLAG_HPLOSS  then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   then
		return 0
	end
	local index = 1.8
	local level = ability:GetSpecialValueFor("advanced_level")
	if level and level>=5 then
		index = 1.5
		if level>=20 then
			damage = damage*0.8 -target:GetPhysicalArmorValue(false)*2

		elseif level>=15 then
			damage = damage -target:GetPhysicalArmorValue(false)*2
		end
	end
	if damage<=0 then
		return keys.damage
	end

	local damageTable = {

		attacker =keys.attacker,
		victim = target,
		damage = damage*index,
		damage_type = keys.damage_type,
		ability = ability, 
		damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS,
	}
	ApplyDamage(damageTable)
	return keys.damage
end