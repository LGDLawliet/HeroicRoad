heroTalent_npc_dota_hero_dark_willow_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dark_willow_2", "heroTalent/heroTalent_npc_dota_hero_dark_willow_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dark_willow_2_attack", "heroTalent/heroTalent_npc_dota_hero_dark_willow_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_dark_willow_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_dark_willow_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_dark_willow_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_dark_willow_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_dark_willow_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_dark_willow_2" end
function heroTalent_npc_dota_hero_dark_willow_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", context )
end

modifier_heroTalent_npc_dota_hero_dark_willow_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dark_willow_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_dark_willow_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dark_willow_2:AllowIllusionDuplicate() return false end

function modifier_heroTalent_npc_dota_hero_dark_willow_2:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf" end


function modifier_heroTalent_npc_dota_hero_dark_willow_2:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf" 
    end	
end 


function modifier_heroTalent_npc_dota_hero_dark_willow_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_heroTalent_npc_dota_hero_dark_willow_2:Advanced_GetModifierAttackRangeBonus()		
    if self:GetParent():IsRangedAttacker() then
        return 150
    else 
		return 0
 	end
end

function modifier_heroTalent_npc_dota_hero_dark_willow_2:GetModifierProcAttack_BonusDamage_Magical(params) 
	local parent = self:GetParent()
	if IsServer() and parent:IsApplyModifier() then
		return (parent:GetStrength()+parent:GetAgility()+parent:GetIntellect(false))*0.3
	end
	return 0
end



function modifier_heroTalent_npc_dota_hero_dark_willow_2:CheckState()
	if IsClient() then
		return
	end
	return {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_dark_willow_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end