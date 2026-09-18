heroTalent_npc_dota_hero_faceless_void_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_4", "heroTalent/heroTalent_npc_dota_hero_faceless_void_4", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_4_move", "heroTalent/heroTalent_npc_dota_hero_faceless_void_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_faceless_void_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_faceless_void_4"
end

function heroTalent_npc_dota_hero_faceless_void_4:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/faceless_void_4/effect.vpcf", context )
end


function heroTalent_npc_dota_hero_faceless_void_4:InitCooldown(unit)
	local ability = self:GetChronosphere()
	if ability and not ability:IsCooldownReady() then
		local caster = self:GetCaster()
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/faceless_void_4/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, Vector(125,125,125))
		DestroyParticleByDelay(nFXIndex,1.5)
		unit:EmitSound("killer_queen")
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/faceless_void_4/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, Vector(125,125,125))
		DestroyParticleByDelay(nFXIndex,1.5)
		caster:EmitSound("killer_queen")

		local cooldown = ability:GetCooldownTimeRemaining() * (1-0.01*self:GetSpecialValueFor("cooldown_reduction"))
		ability:EndCooldown()
		ability:StartCooldown(cooldown)


		return true
	end
	return false
end


function heroTalent_npc_dota_hero_faceless_void_4:GetChronosphere()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Chronosphere")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Chronosphere")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Chronosphere")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_Chronosphere")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_Chronosphere")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_Chronosphere")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end

function heroTalent_npc_dota_hero_faceless_void_4:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 750,
					to_level2_cost = 1500,
					to_level3_cost = 2200,
					upgrade_cost = 750,
				}
				skillshop:LearnTalentDefaultAbility(caster,"Chronosphere",costKeys)
			end
		end)
	
	end

end



modifier_heroTalent_npc_dota_hero_faceless_void_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_faceless_void_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_faceless_void_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_4:RemoveOnDeath() return false end
-- "AbilityValues"
-- {
--     "duration"  "1"
--     "max_duration"  "15"
--     "cooldown_reduction"  "1"
-- }
function modifier_heroTalent_npc_dota_hero_faceless_void_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
	}
end


function modifier_heroTalent_npc_dota_hero_faceless_void_4:OnDeath(keys)
	if IsServer() then

		local parent = self:GetParent()
		if keys.attacker==parent then
		
			local modifier = self:FindTargetModifier()
			if modifier then
				local tinker = modifier:GetAuraOwner()
				if IsValid(tinker) and IsValid(tinker.chronosphere_modifier) then
					local ability = self:GetAbility()
					local duration = ability:GetSpecialValueFor("duration")
					local max_duration = ability:GetSpecialValueFor("max_duration")
					tinker.chronosphere_modifier:InitFVTalent4(duration,max_duration)
				end
			end
		end
		
		
	end
end



function modifier_heroTalent_npc_dota_hero_faceless_void_4:FindTargetModifier()
	if IsValid(self.modifier) then
		return self.modifier
	end
	local parent = self:GetParent()
	local modifier = parent:FindModifierByName("modifier_Advanced_Chronosphere_debuff")
	if not modifier then
		modifier = parent:FindModifierByName("modifier_Middle_Chronosphere_debuff")
		if not modifier then
			modifier = parent:FindModifierByName("modifier_Primary_Chronosphere_debuff")
		end
	end
	if modifier and modifier:GetCaster()==self:GetCaster() then
		self.modifier = modifier
	end
	if IsValid(self.modifier) then
		return self.modifier
	else
		return nil
	end
end











