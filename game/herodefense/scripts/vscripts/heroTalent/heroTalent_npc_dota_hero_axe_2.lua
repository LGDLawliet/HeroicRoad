heroTalent_npc_dota_hero_axe_2 = heroTalent_npc_dota_hero_axe_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_2", "heroTalent/heroTalent_npc_dota_hero_axe_2", LUA_MODIFIER_MOTION_NONE )


-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_axe_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_axe_2"
end

function heroTalent_npc_dota_hero_axe_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Culling_Blade",costKeys)



			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_axe_2 = modifier_heroTalent_npc_dota_hero_axe_2 or class({})

function modifier_heroTalent_npc_dota_hero_axe_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_axe_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_axe_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_axe_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_axe_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_axe_2:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()

		if parent:PassivesDisabled() then
			return
		end

		if keys.target == parent then

			if not keys.attacker.axe_talent_2_time then
				keys.attacker.axe_talent_2_time = GameRules:GetGameTime()
			end
			if GameRules:GetGameTime()>=keys.attacker.axe_talent_2_time then
				local chance = 7
				if self:GetAbility():IsCooldownReady() then
					chance = 100
					self:GetAbility():UseResources(true, true, true,true)
				end
				if chance>=RandomInt(1, 100) then
					local ability = self:FindCulling_Blade()
					if ability then	
						keys.attacker.axe_talent_2_time = GameRules:GetGameTime() + 3
						parent:SetCursorCastTarget(keys.attacker)
						ability:OnSpellStart()
						-- ability:TalentEffect(keys.attacker,1)		
						-- self:GetAbility():StartCooldown(0.5)
					end
				end
			end
		
			


	
		end
	end
end
function modifier_heroTalent_npc_dota_hero_axe_2:FindCulling_Blade()
	if self.ability then
		if not self.ability:IsNull() then
			return self.ability
		end
	end
	local parent = self:GetParent()
	self.ability = parent:FindAbilityByName("Advanced_Culling_Blade")
	if not self.ability then
		self.ability = parent:FindAbilityByName("Middle_Culling_Blade")
		if not self.ability then
			self.ability = parent:FindAbilityByName("Primary_Culling_Blade")
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	end
	return nil
end
