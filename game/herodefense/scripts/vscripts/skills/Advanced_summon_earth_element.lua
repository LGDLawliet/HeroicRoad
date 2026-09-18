
LinkLuaModifier( "modifier_Advanced_summon_earth_element_arua", "skills/Advanced_summon_earth_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_earth_element_effect", "skills/Advanced_summon_earth_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_earth_element_buff", "skills/Advanced_summon_earth_element", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_generic_animation_frozen", "modifier/generic/modifier_generic_animation_frozen", LUA_MODIFIER_MOTION_NONE )


Advanced_summon_earth_element						= Advanced_summon_earth_element or class({})
require("internal/timers")

function Advanced_summon_earth_element:IsSummonSpell()return true end
function Advanced_summon_earth_element:IsElementSummon()return true end

function Advanced_summon_earth_element:Precache( context )
	PrecacheResource( "model", "models/monster/golem/rock_golem.vmdl", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_earth_element/particle_14/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash_ground_impact_flat.vpcf", context )




	
end
function Advanced_summon_earth_element:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_summon_earth_element:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_summon_earth_element:UnlockThirdCore(key)

	if self:GetCaster():GetUnitName()~="npc_dota_hero_earth_spirit" then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	return true

end
function Advanced_summon_earth_element:CheckKV(key)
	local table = {
		bonus_armor=1,
		bonus_health=2,


	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_earth_element:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=15 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function Advanced_summon_earth_element:OnSpellStart()

	
	local caster =self:GetCaster()


	
	

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+self:GetSpecialValueFor("basic_armor")
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 



	-- Add spawn particles in spawn location
	EmitSoundOn("Ability.Avalanche", caster)	
	local pfx_name = "particles/rebuild/spell/earth_element/summon_earth.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, unit_pos)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300,300,0))
	ParticleManager:ReleaseParticleIndex( pfx )

	local status = self:GetAutoCastState() or self.unlock3
	if status then
		-- heal = heal*1.5
		if self.unlock3 then
			heal = heal * 2
		else
			heal = heal*1.5
		end
	end


	local ability = self
	Timers(1.2, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_earth_element",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_earth_element_arua", {})
		if status then
			-- unit:StartGesture(ACT_DOTA_CAST_ABILITY_3)
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_earth_element_buff", {})
		end

		if self.unlock1 then
			local dragon_blood = caster:FindAbilityByName("Advanced_dragon_blood")
			if dragon_blood then
				dragon_blood:EarthElementUnlock1(unit)
			end
		end
	end)


end




modifier_Advanced_summon_earth_element_arua = class({})

function modifier_Advanced_summon_earth_element_arua:IsHidden() return true end
function modifier_Advanced_summon_earth_element_arua:IsAura() return true end
function modifier_Advanced_summon_earth_element_arua:IsPurgable() 		return false end
function modifier_Advanced_summon_earth_element_arua:IsPurgeException() 	return false end
function modifier_Advanced_summon_earth_element_arua:RemoveOnDeath()  return false end
function modifier_Advanced_summon_earth_element_arua:GetAuraDuration() return 0.5 end
function modifier_Advanced_summon_earth_element_arua:GetModifierAura() return "modifier_Advanced_summon_earth_element_effect" end
function modifier_Advanced_summon_earth_element_arua:GetAuraRadius() return 500 end
function modifier_Advanced_summon_earth_element_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_summon_earth_element_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_summon_earth_element_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_summon_earth_element_arua:OnCreated(keys)
	self.chance = 10
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		self.chance = 14
	end
	if IsServer() then
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_14" then
			local parent = self:GetParent()
			parent:SetOriginalModel("models/monster/golem/rock_golem.vmdl")
			Timers:CreateTimer(0.1, function()
				if parent and not parent:IsNull() and parent:IsAlive() then
					local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_earth_element/particle_14/effect.vpcf", PATTACH_CUSTOMORIGIN, parent)
					ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(pfx, 2, parent, PATTACH_POINT_FOLLOW, "attach_eye_r", parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(pfx, 3, parent, PATTACH_POINT_FOLLOW, "attach_eye_l", parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(pfx, 4, parent, PATTACH_POINT_FOLLOW, "attach_eye_r", parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_eye_l_b", parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(pfx, 6, parent, PATTACH_POINT_FOLLOW, "attach_eye_r_b", parent:GetAbsOrigin(), true)
					self:AddParticle(pfx, false, false, 15, false, false)
				end
			end)
			

		end
	end
end
function modifier_Advanced_summon_earth_element_arua:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ATTACK_LANDED,

	}

	return funcs
end



function modifier_Advanced_summon_earth_element_arua:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
			return
		end
		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		if CalculateDistance(self:GetParent(),keys.attacker)>=300 then
			return
		end
		if self:GetCaster():GetRandomEffect( self.chance,INT_TYPE,1) >=RandomInt(1, 100) then
			local ability = self:GetAbility()
			local caster= self:GetCaster()
			local damage = 0
			if ability.unlock2 then
				damage = caster:GetStrength()*5
				local reactive_armor = caster:FindAbilityByName("Advanced_reactive_armor")
				if reactive_armor then
					local armor = keys.target:GetPhysicalArmorValue(false)
					if armor>0 then
						damage = damage + armor*5
					end
					
				end
			else
				damage = caster:GetStrength()*1.5
			end
	
			self:PlayEffects( keys.attacker )
			local damageTable = {
				victim = keys.attacker,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = self:GetAbility(), --Optional.
			}
			ApplyDamage(damageTable)

			
			if not ability.unlock2 then
				local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
				local StatusResistance = keys.attacker:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				keys.attacker:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = 1*StatusResistance})
			end
			
		end
		
		

	end
end


function modifier_Advanced_summon_earth_element_arua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_tiny/tiny_craggy_hit.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
	target:EmitSound("Hero_Tiny.Attack")
end

















modifier_Advanced_summon_earth_element_effect = advanced_modifier({})

function modifier_Advanced_summon_earth_element_effect:IsDebuff()			return false end
function modifier_Advanced_summon_earth_element_effect:IsHidden() 			return true end
function modifier_Advanced_summon_earth_element_effect:IsPurgable() 			return false end
function modifier_Advanced_summon_earth_element_effect:IsPurgeException() 	return false end
function modifier_Advanced_summon_earth_element_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_summon_earth_element_effect:OnCreated(keys)
	self.bonus_armor = 7
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
		self.bonus_armor = 10
	end
end
function modifier_Advanced_summon_earth_element_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_Advanced_summon_earth_element_effect:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end








modifier_Advanced_summon_earth_element_buff = advanced_modifier({})

function modifier_Advanced_summon_earth_element_buff:IsDebuff()			return false end
function modifier_Advanced_summon_earth_element_buff:IsHidden() 			return true end
function modifier_Advanced_summon_earth_element_buff:IsPurgable() 			return false end
function modifier_Advanced_summon_earth_element_buff:IsPurgeException() 	return false end
function modifier_Advanced_summon_earth_element_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_summon_earth_element_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_Advanced_summon_earth_element_buff:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA+10000
end
function modifier_Advanced_summon_earth_element_buff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
function modifier_Advanced_summon_earth_element_buff:OnCreated(keys)
	self.bonus_regen = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		self.bonus_regen = 2
		if self:GetAbility():GetUnlock(3)==3 then
			self.bonus_regen = 6
		end
	end
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)
		self:StartIntervalThink(RandomFloat(0.5, 1.8))
	end
end
function modifier_Advanced_summon_earth_element_buff:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_animation_frozen", {})
	self:StartIntervalThink(-1)
end

function modifier_Advanced_summon_earth_element_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.bonus_regen
end





function modifier_Advanced_summon_earth_element_buff:Advanced_GetModifierIncomingDamage_Percentage()
	return -30
end

function modifier_Advanced_summon_earth_element_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end


