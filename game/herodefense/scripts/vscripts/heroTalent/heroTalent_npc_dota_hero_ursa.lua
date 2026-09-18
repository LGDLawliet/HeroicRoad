heroTalent_npc_dota_hero_ursa = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ursa", "heroTalent/heroTalent_npc_dota_hero_ursa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ursa_debuff", "heroTalent/heroTalent_npc_dota_hero_ursa", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_ursa:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ursa"
end



modifier_heroTalent_npc_dota_hero_ursa = class({})

function modifier_heroTalent_npc_dota_hero_ursa:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_ursa:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ursa:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ursa:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ursa:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_ursa:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_ursa:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_heroTalent_npc_dota_hero_ursa:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end

		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_heroTalent_npc_dota_hero_ursa_debuff", self:GetAbility():GetCaster())


		if modifier==nil then

			target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_ursa_debuff",{ duration = self:GetAbility():GetSpecialValueFor("duration") })
			stack = 1
		else
			if modifier:GetStackCount()<self:GetAbility():GetSpecialValueFor("max_count") then
				modifier:IncrementStackCount()
			end
			
			modifier:ForceRefresh()
			stack = modifier:GetStackCount()
		end
		local bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*(stack*self:GetAbility():GetSpecialValueFor("damage_index")*0.01)

		return bonus_damage
	end
end






modifier_heroTalent_npc_dota_hero_ursa_debuff = class({})

function modifier_heroTalent_npc_dota_hero_ursa_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_ursa_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_debuff:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_heroTalent_npc_dota_hero_ursa_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_ursa_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end