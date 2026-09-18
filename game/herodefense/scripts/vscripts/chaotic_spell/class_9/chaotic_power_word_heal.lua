
chaotic_power_word_heal = class({})
LinkLuaModifier("modifier_chaotic_power_word_heal", "chaotic_spell/class_9/chaotic_power_word_heal", LUA_MODIFIER_MOTION_NONE)



function chaotic_power_word_heal:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_power_word_heal/effect_target/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", context )

end

function chaotic_power_word_heal:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end


function chaotic_power_word_heal:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_power_word_heal:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_power_word_heal_target"    
	EmitSoundOn(sound_cast, caster)    

	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_power_word_heal:ApplyModifier(target, duration)

	

	local particle_cast = "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle_cast_fx,2.5)

	local caster = self:GetCaster()
	target:RemoveModifierByName("modifier_chaotic_power_word_heal")
	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_power_word_heal", {duration = duration*gain})

end



modifier_chaotic_power_word_heal = advanced_modifier({})



function modifier_chaotic_power_word_heal:IsHidden() return false end
function modifier_chaotic_power_word_heal:IsPurgable() return true end
function modifier_chaotic_power_word_heal:IsDebuff() return false end
function modifier_chaotic_power_word_heal:OnCreated(keys)

	
	if IsServer() then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_power_word_heal/effect_target/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
		local ex =math.min( parent:GetModelScale() * 100,400)
		ParticleManager:SetParticleControl(pfx, 15, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 16, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.rune_1_cost = self:GetAbility():GetSpecialValueFor("rune_1_cost")
		

		self.rune_2_bonus = self:GetAbility():GetSpecialValueFor("rune_2_bonus")*0.01
		self.rune_2_radius = self:GetAbility():GetSpecialValueFor("rune_2_radius")
		

		local ability = self:GetAbility()
		self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
	end
end

function modifier_chaotic_power_word_heal:OnIntervalThink()
	self:HealEffect()
end




function modifier_chaotic_power_word_heal:HealEffect()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	if parent:GetHealthPercent()<100 then
		
		local fhealing =  HealWithGain(parent:GetMaxHealth()- parent:GetHealth(),self:GetCaster(),parent,ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent, fhealing, nil) 
		if self.rune_2_bonus then
			local damageTable = {
				-- victim = self:GetParent(),
				attacker = parent,
				damage = fhealing*self.rune_2_bonus,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability, --Optional.
				-- hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			}

			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.rune_2_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, unit in ipairs(enemies) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
			
	
		end
	end
	parent:Purge(false, true, false, true, true)

end

function modifier_chaotic_power_word_heal:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},  --生命汲取
	}
	return funcs
end



function modifier_chaotic_power_word_heal:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit
		if unit~=self:GetParent() then	return end
		if keys.unit:GetHealth()<=0 then
			self:GetParent():SetHealth(1)
			self:HealEffect()
			self:SetDuration(self:GetRemainingTime()-self.rune_1_cost, true)
		end


 
    end 
end
