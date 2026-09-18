heroTalent_npc_dota_hero_nyx_assassin = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nyx_assassin", "heroTalent/heroTalent_npc_dota_hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_nyx_assassin:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_nyx_assassin:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_nyx_assassin:IsStealable() 				return true end
function heroTalent_npc_dota_hero_nyx_assassin:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_nyx_assassin:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_nyx_assassin" end


modifier_heroTalent_npc_dota_hero_nyx_assassin = class({})

function modifier_heroTalent_npc_dota_hero_nyx_assassin:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self:StartIntervalThink(0.3)     
    end
end
function modifier_heroTalent_npc_dota_hero_nyx_assassin:OnIntervalThink()

    -- self:GetParent():NotifyWearablesOfModelChange(true)
    -- self:GetParent():ManageModelChanges()
    local hero = self:GetParent()
    if hero:IsInNightTime() and not hero:PassivesDisabled() then
 
        self:SetStackCount(1)
        return
    end


    self:SetStackCount(0)
end

function modifier_heroTalent_npc_dota_hero_nyx_assassin:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比



	}

	return funcs
end




function modifier_heroTalent_npc_dota_hero_nyx_assassin:GetActivityTranslationModifiers( params )
    if self:GetStackCount()==1 then
        return "vendetta"
    end
	return 
end

function modifier_heroTalent_npc_dota_hero_nyx_assassin:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount()>=1 and 30 end

function modifier_heroTalent_npc_dota_hero_nyx_assassin:GetPriority()
	return 10
end

function modifier_heroTalent_npc_dota_hero_nyx_assassin:CheckState()
    local state = 
	{
		
	}
    if self:GetStackCount()==1 then
        state = 
        {
            [MODIFIER_STATE_STUNNED] = false,
            [MODIFIER_STATE_SILENCED] = false,
        }
    end
	

	return state
end