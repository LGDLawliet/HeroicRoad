heroTalent_npc_dota_hero_juggernaut_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_4", "heroTalent/heroTalent_npc_dota_hero_juggernaut_4", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_4_effect", "heroTalent/heroTalent_npc_dota_hero_juggernaut_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_juggernaut_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_juggernaut_4"
end



modifier_heroTalent_npc_dota_hero_juggernaut_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_juggernaut_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:OnCreated(keys)
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:OnRefresh(keys)
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_4:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end


function modifier_heroTalent_npc_dota_hero_juggernaut_4:OnAttackLanded(keys)

	if IsServer() then



		local ability = self:GetAbility()

		local parent = self:GetParent()

		if parent:IsAlive() then
			if parent:PassivesDisabled() then
				return
			end
			if not ability:IsCooldownReady() then
				return
			end
			local pass = false
			if (self.chance>=RandomInt(1, 100)) then
				pass = true
			else
				if AttackFilter(keys.record, ATTACK_STATE_CRIT) then
					pass = true
				end
			end
			if parent:IsInSpecialAttack() then
				return
			end
			if pass then
				local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:Script_GetAttackRange()+150, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER, false)
				for _, unit in ipairs(units) do
					if unit~=keys.target then
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =0,
							iDisableSplit = 0,
					
						}
						local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
						
						parent:PerformAttack(unit, false, true, true, false, true, false, true)
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						break
					end
				end
			end



		end
	end
	return 0
end
