heroTalent_npc_dota_hero_bounty_hunter_3 =heroTalent_npc_dota_hero_bounty_hunter_3 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bounty_hunter_3", "heroTalent/heroTalent_npc_dota_hero_bounty_hunter_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_bounty_hunter_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bounty_hunter_3"
end
function heroTalent_npc_dota_hero_bounty_hunter_3:Precache( context )
	PrecacheResource( "particle", "particles/econ/taunts/bounty_hunter/bh_taunt_goldpiles/bh_taunt_goldpiles.vpcf", context )
end

function heroTalent_npc_dota_hero_bounty_hunter_3:Unlockachievement()
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_bounty_hunter_3:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("golden_legend_1")
		end
	end

end


modifier_heroTalent_npc_dota_hero_bounty_hunter_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:OnCreated(keys)
	if IsServer() then
		self.conditions_count = 0
		self.max_bonus = self:GetAbility():GetSpecialValueFor("attack_max")
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"golden_legend_1") then
			self.max_bonus = self.max_bonus +500
			
		end
	end
end


function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:OnWaveEnd()
    
	self:GetParent():GameTimer(self:GetAbility():GetSpecialValueFor("time"), function()
		local parent = self:GetParent()
		local gold = parent:GetGold() + parent:GetGoldInChallenge038()
		if gold>=99999 then
			self.conditions_count = self.conditions_count + 1
			if self.conditions_count>=3 then
				self:GetAbility():Unlockachievement()
			end
		else
			self.conditions_count = 0
		end
		local gold = math.floor(gold/self:GetAbility():GetSpecialValueFor("gold_per"))*self:GetAbility():GetSpecialValueFor("attack")
		self:SetStackCount(math.min(self:GetStackCount()+gold,self:GetAbility():GetSpecialValueFor("attack_max")))
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/taunts/bounty_hunter/bh_taunt_goldpiles/bh_taunt_goldpiles.vpcf", PATTACH_WORLDORIGIN, parent )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		parent:EmitSound("Hero_BountyHunter.Shuriken")
	end)
    return 1
end

function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力

	}
end


function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:GetModifierPreAttack_BonusDamage()	return self:GetStackCount() end


function modifier_heroTalent_npc_dota_hero_bounty_hunter_3:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end

