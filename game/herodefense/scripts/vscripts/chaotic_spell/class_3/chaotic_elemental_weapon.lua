
chaotic_elemental_weapon = class({})
LinkLuaModifier("modifier_chaotic_elemental_weapon", "chaotic_spell/class_3/chaotic_elemental_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_elemental_weapon_rune_1", "chaotic_spell/class_3/chaotic_elemental_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_elemental_weapon_rune_2", "chaotic_spell/class_3/chaotic_elemental_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_elemental_weapon_rune_3", "chaotic_spell/class_3/chaotic_elemental_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_elemental_weapon_cd", "chaotic_spell/class_3/chaotic_elemental_weapon", LUA_MODIFIER_MOTION_NONE)
function chaotic_elemental_weapon:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/elemental_weapon/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", context )--0 1 3 
    PrecacheResource( "particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/invincible_army/lightning/lightning_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
end



function chaotic_elemental_weapon:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end
function chaotic_elemental_weapon:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_elemental_weapon:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	EmitSoundOn("chaotic_elemental_weapon_target", target)    
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_elemental_weapon:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/elemental_weapon/cast_effect/effect.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	ParticleManager:SetParticleControl(particle_cast_fx, 2, target:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_elemental_weapon", {duration = duration*gain})
	if self:GetRuneType()==1 then
		target:AddNewModifier(caster, self, "modifier_chaotic_elemental_weapon_rune_1", {duration = duration*gain})
	end
	if self:GetRuneType()==2 then
		target:AddNewModifier(caster, self, "modifier_chaotic_elemental_weapon_rune_2", {duration = duration*gain})
	end
	if self:GetRuneType()==3 then
		target:AddNewModifier(caster, self, "modifier_chaotic_elemental_weapon_rune_3", {duration = duration*gain})
	end
end



modifier_chaotic_elemental_weapon = advanced_modifier({})

function modifier_chaotic_elemental_weapon:IsHidden() return false end
function modifier_chaotic_elemental_weapon:IsPurgable() return true end
function modifier_chaotic_elemental_weapon:IsDebuff() return false end

function modifier_chaotic_elemental_weapon:OnCreated(keys)
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
		self:SetStackCount(bonus*self:GetAbility():GetEffectGain())
	end
end
function modifier_chaotic_elemental_weapon:OnRefresh(keys)
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
		self:SetStackCount(bonus*self:GetAbility():GetEffectGain())
	end
end


function modifier_chaotic_elemental_weapon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_elemental_weapon:OnTooltip() return self:Advanced_GetModifierProcAttack_BonusDamage_Physical() end
function modifier_chaotic_elemental_weapon:Advanced_GetModifierProcAttack_BonusDamage_Physical()	
	return self:GetStackCount()
end
function modifier_chaotic_elemental_weapon:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,

    }
end

-------------
modifier_chaotic_elemental_weapon_rune_1 = advanced_modifier({})

function modifier_chaotic_elemental_weapon_rune_1:IsHidden() return true end
function modifier_chaotic_elemental_weapon_rune_1:IsPurgable() return false end
function modifier_chaotic_elemental_weapon_rune_1:IsDebuff() return false end

function modifier_chaotic_elemental_weapon_rune_1:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_1_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_1:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_1_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_1:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_chaotic_elemental_weapon_rune_1:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target

	if not attacker:HasModifier("modifier_chaotic_elemental_weapon_cd") then
		
		local effect_ice = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, keys.target)
	    ParticleManager:SetParticleControl(effect_ice, 0, Vector(keys.target:GetAbsOrigin().x, keys.target:GetAbsOrigin().y, keys.target:GetAbsOrigin().z + 64))
	    ParticleManager:SetParticleControl(effect_ice, 2, Vector(100, 100, 100))
		local damageTable = {
			victim = target,
			attacker = attacker,
			damage = self.damage * self.index,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		}
		ApplyDamage(damageTable)

		attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_chaotic_elemental_weapon_cd",{duration = self.cd})
	end
end


-------------
modifier_chaotic_elemental_weapon_rune_2 = advanced_modifier({})

function modifier_chaotic_elemental_weapon_rune_2:IsHidden() return true end
function modifier_chaotic_elemental_weapon_rune_2:IsPurgable() return false end
function modifier_chaotic_elemental_weapon_rune_2:IsDebuff() return false end

function modifier_chaotic_elemental_weapon_rune_2:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_2_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_2:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_2_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_2:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_chaotic_elemental_weapon_rune_2:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target
	
	if not attacker:HasModifier("modifier_chaotic_elemental_weapon_cd") then
		local effect_fire = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(effect_fire, 0,target:GetAbsOrigin())
		ParticleManager:SetParticleControl(effect_fire, 3, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
		ParticleManager:ReleaseParticleIndex(effect_fire)
		local damageTable = {
			victim = target,
			attacker = attacker,
			damage = self.damage * self.index,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		ApplyDamage(damageTable)
		attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_chaotic_elemental_weapon_cd",{duration = self.cd})
	end
end


-------------
modifier_chaotic_elemental_weapon_rune_3 = advanced_modifier({})

function modifier_chaotic_elemental_weapon_rune_3:IsHidden() return true end
function modifier_chaotic_elemental_weapon_rune_3:IsPurgable() return false end
function modifier_chaotic_elemental_weapon_rune_3:IsDebuff() return false end

function modifier_chaotic_elemental_weapon_rune_3:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_3_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_3:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.cd = self:GetAbility():GetSpecialValueFor("rune_cd")
	self.index = self:GetAbility():GetSpecialValueFor("rune_3_index")*0.01
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_index")*0.01*self:GetCaster():HDGetPrimaryStatValue()
end

function modifier_chaotic_elemental_weapon_rune_3:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_chaotic_elemental_weapon_rune_3:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target

	if not attacker:HasModifier("modifier_chaotic_elemental_weapon_cd") then
		local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, caster)

		ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, 5000))
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local damageTable = {
			victim = target,
			attacker = attacker,
			damage = self.damage * self.index,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		ApplyDamage(damageTable)
		attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_chaotic_elemental_weapon_cd",{duration = self.cd})
	end
end



modifier_chaotic_elemental_weapon_cd = advanced_modifier({})

function modifier_chaotic_elemental_weapon_cd:IsHidden() return true end
function modifier_chaotic_elemental_weapon_cd:IsPurgable() return false end
function modifier_chaotic_elemental_weapon_cd:IsDebuff() return false end