heroTalent_npc_dota_hero_troll_warlord = class({})
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_arua", "skills/heroTalent_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_arua_effect", "skills/heroTalent_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord", "heroTalent/heroTalent_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_pass", "heroTalent/heroTalent_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_troll_warlord_active", "heroTalent/heroTalent_npc_dota_hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_troll_warlord:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_troll_warlord"
end


modifier_heroTalent_npc_dota_hero_troll_warlord = advanced_modifier({})




function modifier_heroTalent_npc_dota_hero_troll_warlord:IsHidden() 	return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_troll_warlord:OnCreated( kv )
	self:SetStackCount(0)
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_count")
	self.currentTarget = {}
end

function modifier_heroTalent_npc_dota_hero_troll_warlord:OnRefresh( kv )
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_count")
end

function modifier_heroTalent_npc_dota_hero_troll_warlord:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_troll_warlord:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
	}
	return funcs
end


function modifier_heroTalent_npc_dota_hero_troll_warlord:OnAttack( params )
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if params.attacker==self:GetParent() then
			if self.currentTarget==params.target then
				self:AddStack()
			else
				if not self:GetParent():FindModifierByName("modifier_heroTalent_npc_dota_hero_troll_warlord_pass") then
					self:SetStackCount(math.max(self:GetStackCount()-self:GetAbility():GetSpecialValueFor("lose_count"),0))
				end
				self.currentTarget = params.target
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_troll_warlord:OnDeath(keys)
	if IsServer() then
		keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_troll_warlord_pass",{duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

function modifier_heroTalent_npc_dota_hero_troll_warlord:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetParent():PassivesDisabled() and 0 or  self:GetStackCount() * self.stack_multiplier
end



function modifier_heroTalent_npc_dota_hero_troll_warlord:AddStack()
	-- check if it is not maximum
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.max_stacks then
			self:IncrementStackCount()
		end
	end
end


----------
modifier_heroTalent_npc_dota_hero_troll_warlord_pass = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_troll_warlord_pass:IsHidden() 	return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_pass:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_pass:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_troll_warlord_pass:RemoveOnDeath() return false end
