LinkLuaModifier("modifier_heroTalent_npc_dota_hero_monkey_king_2","heroTalent/heroTalent_npc_dota_hero_monkey_king_2",LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_monkey_king_2 = class({})
function heroTalent_npc_dota_hero_monkey_king_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Boundless_Strike",costKeys)
			end
		end)
	
	end

end

function heroTalent_npc_dota_hero_monkey_king_2:Unlockachievement()
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_monkey_king_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("monkey_king_power_1")
		end
	end

end
function heroTalent_npc_dota_hero_monkey_king_2:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_monkey_king_2"
end

function heroTalent_npc_dota_hero_monkey_king_2:CastWalrusPunch(hTarget)
    local caster = self:GetCaster()
	if caster.origin_model_name==caster:GetModelName() then
		local needTime = math.max(caster:GetSecondsPerAttack(false),0.06)
		caster:StartGestureWithPlaybackRate(ACT_DOTA_MK_STRIKE,1/needTime)
	end
end


function heroTalent_npc_dota_hero_monkey_king_2:GetBoundless_Strike()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Boundless_Strike")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Boundless_Strike")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Boundless_Strike")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_Boundless_Strike")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_Boundless_Strike")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_Boundless_Strike")
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

modifier_heroTalent_npc_dota_hero_monkey_king_2 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_monkey_king_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsPermanent() return true end
function modifier_heroTalent_npc_dota_hero_monkey_king_2:OnCreated(keys)
	if IsServer() then
		self.time_reduce = 0.1
		
		-- self.achievement_timer = GameRules:GetGameTime()
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"monkey_king_power_1") then
			-- print("获得奖励")
			self.time_reduce = 0.15
		end
	end
end

function modifier_heroTalent_npc_dota_hero_monkey_king_2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_heroTalent_npc_dota_hero_monkey_king_2:IsValidToTrigger(hTarget)
    -- Rejection based on target
    if hTarget:GetTeamNumber() ==  self:GetCaster():GetTeamNumber() then return false end
    if hTarget:IsBuilding() or hTarget:IsOther() then return false end

    
    if not self:GetAbility():IsCooldownReady()  then return false end
	if self:GetCaster():IsRangedAttacker() then
		return false
	end
	-- if self:GetParent():PassivesDisabled()  then return false end
    
    return true
end

function modifier_heroTalent_npc_dota_hero_monkey_king_2:OnAttackStart(keys)

	if keys.attacker ~= self:GetCaster() then return end
	local target = keys.target
    local ability = self:GetAbility()
    if not self:GetParent():IsRealHero() then
		return false
	end
	if self:GetParent():IsInSpecialAttack() then
		return
	end
    if not self:IsValidToTrigger(target) then return end
   
	

    ability:CastWalrusPunch()

	self.trigger = true
	-- :GetBoundless_Strike()
end


function modifier_heroTalent_npc_dota_hero_monkey_king_2:Advanced_GetModifierAttackRangeBonus()
	if IsClient() then
		return 0
	end
	if not self:GetParent():IsRealHero() then
		return 0
	end
	if self:GetParent():IsRangedAttacker() then
		return 0
	end
	return self:GetAbility():IsCooldownReady() and 700 or 0 
end

function modifier_heroTalent_npc_dota_hero_monkey_king_2:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		
		
		if keys.attacker==parent then
			if not parent:IsRealHero() then
				return false
			end
			if self.trigger then
				self.trigger = false
				self:GetAbility():UseResources(true,true,true,true)
				local ability = self:GetAbility():GetBoundless_Strike()
				if ability then
					parent:SetCursorPosition(keys.target:GetOrigin())
					ability:OnSpellStart()


					if not self.achievement_timer then
						self.achievement_timer = GameRules:GetGameTime() + 4

					else
						local time = GameRules:GetGameTime()
						if time<=self.achievement_timer then
							self:GetAbility():Unlockachievement()
						end
						self.achievement_timer = GameRules:GetGameTime() + 4
					end
					
				end
			end

			if not parent:PassivesDisabled() then
				if parent:IsInSpecialAttack() then
					return
				end
				local self_ability = self:GetAbility()
				local cooldown = self_ability:GetCooldownTimeRemaining()
				if cooldown<=0.5 then
					return
				end
				self_ability:EndCooldown()
				local new_time = cooldown*0.975-self.time_reduce
				if new_time>0 then
					self_ability:StartCooldown(new_time)
				end
				
			end
		end
	end
end



function modifier_heroTalent_npc_dota_hero_monkey_king_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end
