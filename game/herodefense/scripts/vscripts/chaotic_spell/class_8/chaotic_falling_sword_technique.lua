chaotic_falling_sword_technique = class({})
LinkLuaModifier("modifier_chaotic_falling_sword_technique", "chaotic_spell/class_8/chaotic_falling_sword_technique", LUA_MODIFIER_MOTION_NONE)

function chaotic_falling_sword_technique:GetIntrinsicModifierName() return "modifier_chaotic_falling_sword_technique" end



function chaotic_falling_sword_technique:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_falling_sword_technique/chaotic_falling_sword_technique_1.vpcf", context )
end


modifier_chaotic_falling_sword_technique = advanced_modifier({})

function modifier_chaotic_falling_sword_technique:IsDebuff()			return false end
function modifier_chaotic_falling_sword_technique:IsHidden() 		return true end
function modifier_chaotic_falling_sword_technique:IsPurgable() 		return false end
function modifier_chaotic_falling_sword_technique:IsPurgeException() return false end

function modifier_chaotic_falling_sword_technique:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
    }
end

function modifier_chaotic_falling_sword_technique:OnCreated() 

	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.radius_min = self.ability:GetSpecialValueFor("radius_min")
	self.Bonus_damage = self.ability:GetSpecialValueFor("Bonus_damage")
	self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction") * 0.01

end

function modifier_chaotic_falling_sword_technique:OnRefresh()

	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.radius_min = self.ability:GetSpecialValueFor("radius_min")
	self.Bonus_damage = self.ability:GetSpecialValueFor("Bonus_damage")
	self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction") * 0.01

end

function modifier_chaotic_falling_sword_technique:OnAttackLanded( params )
	if IsServer() then

		if params.attacker ~= self.parent then
			return
		end

		if RandomFloat(1, 100) > self.chance then
			return
		end

		local target = params.target

		local damage_pos = target:GetAbsOrigin()

		self:damage_effect(damage_pos)

		self.parent:GameTimer(0.4,function()

			if IsValid(self) then

				local enemies = FindUnitsInRadius(
					self.parent:GetTeamNumber(), 
					target:GetAbsOrigin(), 
					nil, 
					self.radius, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_CLOSEST,
					false
				)
		
				local damage = self.parent:GetAverageTrueAttackDamage(nil) * self.Bonus_damage * self.ability:GetEffectGain()
		
				local damageTable = {
					attacker = self.parent ,
					damage_type = self.ability:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE ,
					ability = self.ability
				} 
		
				for _, enemy in pairs(enemies) do
		
					damageTable.victim = enemy
					if CalculateDistance(self.parent,enemy) > self.radius_min then
						damageTable.damage = damage * self.damage_reduction
					else
						damageTable.damage = damage
					end
					
					ApplyDamage(damageTable)	
		
				end

				EmitSoundOnLocationWithCaster( damage_pos,"Hero_Centaur.HoofStomp", self.parent)

			end

		end)

	end
end

function modifier_chaotic_falling_sword_technique:damage_effect(damage_pos)

	if not IsServer() then
		return
	end

	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_falling_sword_technique/chaotic_falling_sword_technique_5.vpcf", PATTACH_CUSTOMORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, damage_pos)
	ParticleManager:SetParticleControl( effect_cast, 5, Vector(self.radius/4,0,0))
	DestroyParticleByDelay(effect_cast,2)

	EmitSoundOnLocationWithCaster( damage_pos,"Hero_Centaur.Retaliate.Target", self.parent)

end