
chaotic_hold_monster = class({})
LinkLuaModifier("modifier_chaotic_hold_monster", "chaotic_spell/class_5/chaotic_hold_monster", LUA_MODIFIER_MOTION_NONE)



function chaotic_hold_monster:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_hold_monster/effect_target/effect.vpcf", context )

end

function chaotic_hold_monster:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_hold_monster:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	return cost
end


function chaotic_hold_monster:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	-- caster:EmitSound("chaotic_hold_monster_cast")  

	local duration = self:GetSpecialValueFor("duration")
	local gain = self:GetEffectGain()
	self:ApplyModifier(target, duration,gain)
	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(enemies) do
			if not unit:HasModifier("modifier_chaotic_hold_monster") then
				count = count - 1
				self:ApplyModifier(unit, duration,gain)
				if count<=0 then
					break
				end
			end
		end
	end



	
end

function chaotic_hold_monster:ApplyModifier(target, duration,gain)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_hold_monster", {duration = duration*StatusResistance,gain=gain})

end




modifier_chaotic_hold_monster = modifier_chaotic_hold_monster or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_hold_monster:IsHidden()	return false end
function modifier_chaotic_hold_monster:IsDebuff()	return true end
function modifier_chaotic_hold_monster:IsPurgable()	return true end
function modifier_chaotic_hold_monster:OnCreated( kv )
	

	if not IsServer() then return end
	self.distance = self:GetAbility():GetSpecialValueFor("dis_require")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*kv.gain
	self.end_chance = self:GetAbility():GetSpecialValueFor("end_chance")

	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")+1
	self.rune_1_chance_bonus = self:GetAbility():GetSpecialValueFor("rune_1_chance_bonus")+1



	self:PlayEffects()
end


function modifier_chaotic_hold_monster:CheckState()
	local state = {
		-- [MODIFIER_STATE_OUT_OF_GAME] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end


function modifier_chaotic_hold_monster:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/rebuild/chaotic_spell/chaotic_hold_monster/effect_target/effect.vpcf"
	self:GetParent():EmitSound("chaotic_hold_monster_target")
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_CUSTOMORIGIN, self:GetParent() )
	
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( effect_cast1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( effect_cast1, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end


function modifier_chaotic_hold_monster:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_chaotic_hold_monster:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	local chance = self.end_chance
	local bonus_damage= self.bonus_damage
	if self:GetAbility():GetRuneType()==1 then
		if keys.damage_category==DOTA_DAMAGE_CATEGORY_SPELL then
			chance = chance * self.rune_1_chance_bonus
			bonus_damage = bonus_damage * self.rune_1_bonus
		end
	end
	if not self.ending and chance>=RandomInt(1, 100) then
		self.ending = true
		self:GetCaster():GameTimer(0.03, function()
			if IsValid(self) then
				self:Destroy()
			end
		end)
	end
	if keys.attacker and keys.target and CalculateDistance(keys.attacker,keys.target)<=self.distance then
		print("bonus_damage=",bonus_damage)
		return  bonus_damage
	end
	return 0
end


