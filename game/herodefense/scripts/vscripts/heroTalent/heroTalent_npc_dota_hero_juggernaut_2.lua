heroTalent_npc_dota_hero_juggernaut_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_2", "heroTalent/heroTalent_npc_dota_hero_juggernaut_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_2_effect", "heroTalent/heroTalent_npc_dota_hero_juggernaut_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_juggernaut_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_juggernaut_2"
end

function heroTalent_npc_dota_hero_juggernaut_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Omni_Slash",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_juggernaut_2 = class({})

function modifier_heroTalent_npc_dota_hero_juggernaut_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_juggernaut_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_juggernaut_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_juggernaut_2:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not self:GetAbility():IsCooldownReady() then
			return
		end

		if keys.attacker == parent and 5>=RandomInt(1, 100) then
			if not parent:IsApplyModifier() or parent:IsInSpecialAttack()  then
				return
			end
			if parent:PassivesDisabled() then
				return
			end
			

			local ability = self:FindOmniSlash()
			if ability then	
				ability:TalentEffect(keys.target,1.5)		
				self:GetAbility():StartCooldown(0.5)
			end
	
		end
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_2:FindOmniSlash()
	if self.ability then
		if not self.ability:IsNull() then
			return self.ability
		end
	end
	local parent = self:GetParent()
	self.ability = parent:FindAbilityByName("Advanced_Omni_Slash")
	if not self.ability then
		self.ability = parent:FindAbilityByName("Middle_Omni_Slash")
		if not self.ability then
			self.ability = parent:FindAbilityByName("Primary_Omni_Slash")
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	end
	return nil
end