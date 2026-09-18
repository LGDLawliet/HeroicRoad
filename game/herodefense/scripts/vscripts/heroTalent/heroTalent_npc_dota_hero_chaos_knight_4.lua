heroTalent_npc_dota_hero_chaos_knight_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chaos_knight_4", "heroTalent/heroTalent_npc_dota_hero_chaos_knight_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_chaos_knight_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_chaos_knight_4"
end

function heroTalent_npc_dota_hero_chaos_knight_4:InCreaseModifierStack()
	if not self.modifier then
		self.modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_chaos_knight_4")
	end
	self.modifier:IncrementStackCount()
end
function heroTalent_npc_dota_hero_chaos_knight_4:ReSetStack()
	if not self.modifier then
		self.modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_chaos_knight_4")
	end
	self.modifier:SetStackCount(0)
end
function heroTalent_npc_dota_hero_chaos_knight_4:GetBonusChance()
	if not self.modifier then
		self.modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_chaos_knight_4")
	end
	return self.modifier:GetStackCount()*self:GetSpecialValueFor("bonus_chance")

end

function heroTalent_npc_dota_hero_chaos_knight_4:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"chaos_strike",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_chaos_knight_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_chaos_knight_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_4:OnCreated(keys)
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		self.max_count = self:GetAbility():GetSpecialValueFor("max_count")
		self.damage = 0
	end
	
end


