
chaotic_blight = class({})
function chaotic_blight:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_blight/effect.vpcf", context )

end
function chaotic_blight:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_blight:Spawn()
	self.bonus_damage = 0
end



function chaotic_blight:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	return cost
end

function chaotic_blight:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_blight_cast")  

	local damage = self:GetSpecialValueFor("base_damage")+self.bonus_damage
	local bonus_damage_index = self:GetSpecialValueFor("bonus_damage_index")
	local damageTable = {
		attacker	= self:GetCaster(),
		victim = target,
		-- damage		= self:GetSpecialValueFor("base_damage"),
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
	}
	if target:IsBotanicalCreature() then
		damageTable.damage = damage * bonus_damage_index*self:GetEffectGain()
	else
		damageTable.damage = damage*self:GetEffectGain()
	end
	

	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		self:PlayEffect(target)
		ApplyDamage(damageTable)
		self:CheckCooldownEffect(target)
		for _, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				damageTable.victim = unit
				if unit:IsBotanicalCreature() then
					damageTable.damage = damage * bonus_damage_index
				else
					damageTable.damage = damage
				end
				self:PlayEffect(unit)
				ApplyDamage(damageTable)
				self:CheckCooldownEffect(unit)
				if count<=0 then
					break
				end
			end
		end
	else
		self:PlayEffect(target)
		ApplyDamage(damageTable)
		self:CheckCooldownEffect(target)
	end



	
end


function chaotic_blight:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_blight/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	
	-- ParticleManager:SetParticleControl( effect_cast1, 0, target:GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_blight_target")
end

function chaotic_blight:CheckCooldownEffect(target)
	local pass = false
	if IsValid(target) then
		if not target:IsAlive() then
			pass = true
		end
	else
		pass = true
	end
	if pass then
		local cooldown = 1-self:GetSpecialValueFor("cooldown_reduction")*0.01
		local current = self:GetCooldownTimeRemaining()*cooldown
		self:EndCooldown()
		self:StartCooldown(current)
		if self:GetRuneType()==1 then
			if IsValid(target) and target:IsBotanicalCreature() then
				self.bonus_damage = self.bonus_damage + self:GetSpecialValueFor("rune_1_bonus_damage")
			end
			
		end
	end
end
