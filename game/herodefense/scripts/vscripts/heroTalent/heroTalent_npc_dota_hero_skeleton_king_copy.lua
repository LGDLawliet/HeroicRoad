heroTalent_npc_dota_hero_skeleton_king = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king", "heroTalent/heroTalent_npc_dota_hero_skeleton_king", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king_effect", "heroTalent/heroTalent_npc_dota_hero_skeleton_king", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_skeleton_king:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_skeleton_king"
end

-- function heroTalent_npc_dota_hero_skeleton_king:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 700 - caster:GetCastRangeBonus()

-- end

modifier_heroTalent_npc_dota_hero_skeleton_king = class({})

function modifier_heroTalent_npc_dota_hero_skeleton_king:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_skeleton_king:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_skeleton_king:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.refresh_timer = 0
		-- self:GetParent():AddActivityModifier("dance")
		self:StartIntervalThink(0.25)
	end

end


function modifier_heroTalent_npc_dota_hero_skeleton_king:OnIntervalThink()
	local caster = self:GetParent()
	if caster:IsMoving() then
		local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_skeleton_king_effect")
		self.refresh_timer = self.refresh_timer+0.25
		if modifier and self.refresh_timer<=9 then
			modifier:SetDuration(0.3, false)
		else
			self.refresh_timer = 0
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_skeleton_king_effect", {duration=0.3}) 
		end
		
	end
end











modifier_heroTalent_npc_dota_hero_skeleton_king_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:IsPurgable()	return false end


function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:AdvancedGetModifierConstantHealthRegenPercentage( params ) return self:GetAbility():GetSpecialValueFor("heal") end

-- function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:OnCreated(keys)
-- 	if IsServer() then
-- 		self:GetParent():PerformTaunt()
-- 		self:StartIntervalThink(5)	
-- 	end
-- end

-- function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:OnIntervalThink(keys)
-- 	if IsServer() then
-- 		self:GetParent():PerformTaunt()
-- 	end
-- end
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:GetActivityTranslationModifiers( params )
	return "throne"
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end