LinkLuaModifier("modifier_chaotic_phantasmal_killer", "chaotic_spell/class_4/chaotic_phantasmal_killer", LUA_MODIFIER_MOTION_NONE)




chaotic_phantasmal_killer = class({})
function chaotic_phantasmal_killer:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_phantasmal_killer/effect_target/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_phantasmal_killer/debuff_effect/ghosts_ambient.vpcf", context )

end




function chaotic_phantasmal_killer:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_phantasmal_killer:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	return cost
end

function chaotic_phantasmal_killer:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	-- caster:EmitSound("chaotic_phantasmal_killer_cast")  

	-- local damage = self:GetSpecialValueFor("base_damage")
	-- local bonus_damage_index = self:GetSpecialValueFor("bonus_damage_index")
	
	
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*ModifierStatusNegativeGain
	local effect_gain= self:GetEffectGain()
	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		self:PlayEffect(target,duration,effect_gain)
		for _, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				self:PlayEffect(unit,duration,effect_gain)
				if count<=0 then
					break
				end
			end
		end
	else
		self:PlayEffect(target,duration,effect_gain)
	end



	
end


function chaotic_phantasmal_killer:PlayEffect(target,duration,effect_gain)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_phantasmal_killer/effect_target/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	
	-- ParticleManager:SetParticleControl( effect_cast1, 0, target:GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( effect_cast1,1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_phantasmal_killer_target")


	local StatusResistance = target:GetHDStatusResistanceIndex()
	target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_phantasmal_killer", {duration = duration*StatusResistance,effect_gain=effect_gain})

end




modifier_chaotic_phantasmal_killer = modifier_chaotic_phantasmal_killer or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_phantasmal_killer:IsHidden()	return false end
function modifier_chaotic_phantasmal_killer:IsDebuff()	return true end
function modifier_chaotic_phantasmal_killer:IsPurgable()	return true end
function modifier_chaotic_phantasmal_killer:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_phantasmal_killer/debuff_effect/ghosts_ambient.vpcf" end
function modifier_chaotic_phantasmal_killer:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end


function modifier_chaotic_phantasmal_killer:OnCreated( keys )
	

	if not IsServer() then return end
	local ability = self:GetAbility()

	self.rune_type = ability:GetRuneType()
	
	self.damage = ability:GetSpecialValueFor("base_damage")*keys.effect_gain
	self.bonus_damage_index = ability:GetSpecialValueFor("bonus_damage_index")*keys.effect_gain

	self.end_chance = ability:GetSpecialValueFor("end_chance")
	if self.rune_type==1 then
		self.end_chance = self.end_chance * ability:GetSpecialValueFor("rune_1_chance")*0.01
		print("self.end_chance=",self.end_chance)
	end

	self.damageTable = {
		attacker	= self:GetCaster(),
		victim = self:GetParent(),
		-- damage		= self:GetSpecialValueFor("base_damage"),
		damage_type	= ability:GetAbilityDamageType(),
		ability		= ability,
	}


	self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
end


function modifier_chaotic_phantasmal_killer:OnIntervalThink()
	local caster = self:GetCaster()
	self.damageTable.damage = self.damage + caster:HDGetPrimaryStatValue()*self.bonus_damage_index
	ApplyDamage(self.damageTable)

	if self.rune_type~=1 and self.end_chance>=RandomInt(1, 100) then
		self:SafeDestroy()
	end
end



function modifier_chaotic_phantasmal_killer:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetRuneType()==1 then
		funcs["MODIFIER_EVENT_ON_TAKEDAMAGE"] = {nil, self:GetParent()}
	end

	return funcs
end

function modifier_chaotic_phantasmal_killer:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if unit~=self:GetParent() then
			return
		end
		print("self.end_chance=",self.end_chance)
		if self.end_chance>=RandomInt(1, 100) then
			self:SafeDestroy()
		end
		
    end 
end
