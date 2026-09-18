
chaotic_holy_aura = class({})
LinkLuaModifier("modifier_chaotic_holy_aura", "chaotic_spell/class_8/chaotic_holy_aura", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_holy_aura_buff", "chaotic_spell/class_8/chaotic_holy_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_holy_aura_debuff", "chaotic_spell/class_8/chaotic_holy_aura", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_holy_aura_debuff2", "chaotic_spell/class_8/chaotic_holy_aura", LUA_MODIFIER_MOTION_NONE)


function chaotic_holy_aura:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_greater_invisibility/effect_cast/effect_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_holy_aura/effect_cast/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_holy_aura/effect_buff/effect_of_the_light_blinding_light_thinker.vpcf", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", context )

	
	
	-- 

end

function chaotic_holy_aura:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_holy_aura:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()


	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_holy_aura/effect_cast/effect.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, caster:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)


	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_chaotic_holy_aura_buff", {duration =  self:GetSpecialValueFor("duration")*gain})

	

	-- local caster = self:GetCursorTarget() 
	local sound_cast = "Hero_KeeperOfTheLight.BlindingLight"    
	EmitSoundOn(sound_cast, caster)    
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local count = self:GetSpecialValueFor("count")


	local debuffDuration = self:GetSpecialValueFor("duration") * caster:GetModifierStatusNegativeGainIndex(1)
	for _, unit in ipairs(units) do
		self:ApplyModifier(unit,debuffDuration)
		count = count - 1
		if count<=0 then
			break
		end
	end
end

function chaotic_holy_aura:ApplyModifier(target,duration)
	-- local particle_cast = "particles/rebuild/chaotic_spell/chaotic_greater_invisibility/effect_cast/effect_loadout.vpcf"
	local caster = self:GetCaster()
	-- local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	-- DestroyParticleByDelay(particle_cast_fx,1.5)
	target:AddNewModifier(caster, self, "modifier_chaotic_holy_aura_debuff", {duration =  duration*target:GetHDStatusResistanceIndex()})

	

end


modifier_chaotic_holy_aura_debuff = advanced_modifier({})

function modifier_chaotic_holy_aura_debuff:IsHidden() return false end
function modifier_chaotic_holy_aura_debuff:IsPurgable() return true end
function modifier_chaotic_holy_aura_debuff:IsDebuff() return true end

function modifier_chaotic_holy_aura_debuff:OnCreated(keys)

	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	if ability:GetRuneType()==2 and self:GetParent():IsUndead() then
		self.bonus_damage = self.bonus_damage * (ability:GetSpecialValueFor("rune_2_bonus"))
	end

	if IsServer() then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_holy_aura/effect_buff/effect_of_the_light_blinding_light_thinker.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	
	end
end



function modifier_chaotic_holy_aura_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},

    }
end


function modifier_chaotic_holy_aura_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage
end



function modifier_chaotic_holy_aura_debuff:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		
		if unit==self:GetParent() then
			local particle_cast = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf"
			local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_cast_fx, 1, unit:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_cast_fx, 2, Vector(200,200,200))
			DestroyParticleByDelay(particle_cast_fx,2.5)

			local sound_cast = "Hero_KeeperOfTheLight.BlindingLight"    
			EmitSoundOn(sound_cast, unit)    
			local ability = self:GetAbility()
			local radius = ability:GetSpecialValueFor("radius")
			local caster = self:GetCaster()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local debuffDuration = ability:GetSpecialValueFor("debuff_duration") * caster:GetModifierStatusNegativeGainIndex(1)
			for _, unit in ipairs(units) do
				unit:AddNewModifier(caster, ability, "modifier_chaotic_holy_aura_debuff2", {duration =  debuffDuration*unit:GetHDStatusResistanceIndex()})
	
			end


			if ability:GetRuneType()==1 and not ability:IsCooldownReady() then
				local reduction = 1-ability:GetSpecialValueFor("rune_1_bonus")*0.01

				local cooldown = ability:GetCooldownTimeRemaining()
				ability:EndCooldown()
				ability:StartCooldown(cooldown*reduction)
			end
		
		end
	end
end





modifier_chaotic_holy_aura_buff = advanced_modifier({})

function modifier_chaotic_holy_aura_buff:IsHidden() return false end
function modifier_chaotic_holy_aura_buff:IsPurgable() return true end
function modifier_chaotic_holy_aura_buff:IsDebuff() return false end

function modifier_chaotic_holy_aura_buff:OnCreated(keys)

	local ability = self:GetAbility()
	self.bonus_vision = ability:GetSpecialValueFor("bonus_vision")

	if IsServer() then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)


	
	end
end



function modifier_chaotic_holy_aura_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_VISION,
    }
end


function modifier_chaotic_holy_aura_buff:Advanced_GetBonusVision()
	return self.bonus_vision
end








modifier_chaotic_holy_aura_debuff2 = advanced_modifier({})

function modifier_chaotic_holy_aura_debuff2:IsHidden() return false end
function modifier_chaotic_holy_aura_debuff2:IsPurgable() return true end
function modifier_chaotic_holy_aura_debuff2:IsDebuff() return true end

function modifier_chaotic_holy_aura_debuff2:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf" end
--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_holy_aura_debuff2:OnCreated( kv )
	

	self.miss_chance = self:GetAbility():GetSpecialValueFor("miss_chance")
	if not IsServer() then return end
	
end



function modifier_chaotic_holy_aura_debuff2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_chaotic_holy_aura_debuff2:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_chaotic_holy_aura_debuff2:OnTooltip()
	return self:GetModifierMiss_Percentage()
end
