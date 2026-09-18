LinkLuaModifier("modifier_chaotic_scorching_ray_rune_2", "chaotic_spell/class_2/chaotic_scorching_ray", LUA_MODIFIER_MOTION_NONE)

chaotic_scorching_ray = class({})
function chaotic_scorching_ray:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/hit_effect/effect.vpcf", context )
end
function chaotic_scorching_ray:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_scorching_ray:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end





function chaotic_scorching_ray:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_scorching_ray_cast")  





	local count = self:GetSpecialValueFor("base_count")-1

	local mana_require = self:GetSpecialValueFor("mana_require")
	local bonus_count = math.floor(caster:GetMaxMana()/mana_require)
	count = count +  math.min(bonus_count,self:GetSpecialValueFor("max_count"))

	

	local rune_1_chance = self:GetSpecialValueFor("rune_1_chance")
	local rune_1_count = self:GetSpecialValueFor("rune_1_count")-1

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self:PlayEffect(target)
	caster:GameTimer(0.1, function()
		if IsValid(self) then
			local target = enemies[RandomInt(1, #enemies)]
			if not (IsValid(target)  and target:IsAlive() )  then
				for index, unit in ipairs(enemies) do
		
					if IsValid(unit) and  unit:IsAlive() then
						target = unit
						break
					end
				end
			end
			if IsValid(target) and target:IsAlive() then
				count = count - 1
				self:PlayEffect(target)
				if self:GetRuneType()==1 and caster:RollRandom(rune_1_chance,1) then
					for i = 1, rune_1_count, 1 do
						local bonus_target = enemies[RandomInt(1, #enemies)]
						if IsValid(bonus_target) and bonus_target:IsAlive() then
							self:PlayEffect(bonus_target)
						end
						
					end
					
					
				end
				if count>=1 then
					return 0.1
				end
			end

		end
	end)


	
end




function chaotic_scorching_ray:PlayEffect(target)
	EmitSoundOn("chaotic_ray_of_sickness_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)
	if self:GetRuneType()==2 then
		local time = self:GetSpecialValueFor("rune_2_time")
		local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage_index" )*self:GetCaster():HDGetPrimaryStatValue() *self:GetSpecialValueFor("rune_2_pct1")*0.01
		target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_scorching_ray_rune_2", {duration = time , damage = damage})
		return
	end

	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage_index" )*self:GetCaster():HDGetPrimaryStatValue()
	local burning = self:GetSpecialValueFor("burning")*self:GetCaster():HDGetPrimaryStatValue()
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage*self:GetEffectGain(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	target:ApplyMergeDamage(damageTable)
	if target:IsAlive() then
		target:Burning(self:GetCaster(), self, burning)
	end
	if self:GetRuneType()==3 then
		if target:IsAlive() then
			return
		end
		local index = 1 - self:GetSpecialValueFor("rune_3_hpcost")*0.01
		self:GetCaster():SetHealth(math.max(self:GetCaster():GetHealth()*index,1))
		local newCooldown = math.max(self:GetCooldownTimeRemaining() - self:GetSpecialValueFor("rune_3_cdback"),0)
		self:EndCooldown()
		self:StartCooldown(newCooldown)
	end

end



modifier_chaotic_scorching_ray_rune_2 = advanced_modifier({})

function modifier_chaotic_scorching_ray_rune_2:IsDebuff()			return true end
function modifier_chaotic_scorching_ray_rune_2:IsHidden() 		return true end
function modifier_chaotic_scorching_ray_rune_2:IsPurgable() 		return false end
function modifier_chaotic_scorching_ray_rune_2:IsPurgeException() return false end
function modifier_chaotic_scorching_ray_rune_2:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.damage = keys.damage
	self:SetStackCount(math.min((self:GetStackCount() + self.damage),9999999))
end

function modifier_chaotic_scorching_ray_rune_2:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.damage = keys.damage
	self:SetStackCount(math.min((self:GetStackCount() + self.damage),9999999))
	print(keys.damage)
	print(self:GetStackCount())
end

function modifier_chaotic_scorching_ray_rune_2:OnDestroy(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	parent:EmitSound("fire_ball.hit")
	local particle = ParticleManager:CreateParticle("particles/rebuild/spell/creeps_spell_flame_of_the_splitter/hit_effect/effect.vpcf", PATTACH_POINT_FOLLOW,parent)
	ParticleManager:SetParticleControl(particle, 0,  parent:GetAbsOrigin())
	DestroyParticleByDelay(particle,4)

	local damage = self:GetStackCount()
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage*self:GetAbility():GetEffectGain(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY ,
	}
	ApplyDamage(damageTable)
	self:SetStackCount(0)
end