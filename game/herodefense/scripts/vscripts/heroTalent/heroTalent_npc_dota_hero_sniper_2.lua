heroTalent_npc_dota_hero_sniper_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sniper_2", "heroTalent/heroTalent_npc_dota_hero_sniper_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sniper_2_effect", "heroTalent/heroTalent_npc_dota_hero_sniper_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_sniper_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sniper_2"
end

function heroTalent_npc_dota_hero_sniper_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"assassinate",costKeys)




	
			end
		end)
	
	end

end










modifier_heroTalent_npc_dota_hero_sniper_2 = class({})

function modifier_heroTalent_npc_dota_hero_sniper_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sniper_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sniper_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_sniper_2:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end
-- function modifier_heroTalent_npc_dota_hero_sniper_2:OnCreated(keys)
-- 	self.advanced_level = 1
-- end
function modifier_heroTalent_npc_dota_hero_sniper_2:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	

		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() or not caster:IsApplyModifier() then
			return
		end
		local chance = 5
		if self:GetAbility():GetAutoCastState() then
			chance = 100
			self:GetAbility():StartCooldown(20)
		end
		if caster:GetRandomEffect(chance,INT_TYPE,1)>=RandomInt(1, 100) then
					
			local ability = self:FindTalentAbility()
			if ability then	
				caster:SetCursorCastTarget(keys.target)
				ability:OnSpellStart()
				-- self:GetAbility():StartCooldown(0.1)
				-- caster:EmitSound("Ability.Assassinate")
			end
		end


	
		
		
		
		
	end
end



function modifier_heroTalent_npc_dota_hero_sniper_2:FindTalentAbility()
	if self.ability then
		if not self.ability:IsNull() then
			return self.ability
		end
	end
	local parent = self:GetParent()
	self.ability = parent:FindAbilityByName("Advanced_assassinate")
	if not self.ability then
		self.ability = parent:FindAbilityByName("Middle_assassinate")
		if not self.ability then
			self.ability = parent:FindAbilityByName("Primary_assassinate")
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	end
	return nil
end