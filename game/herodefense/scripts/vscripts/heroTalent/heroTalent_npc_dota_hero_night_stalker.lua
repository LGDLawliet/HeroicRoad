heroTalent_npc_dota_hero_night_stalker = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_night_stalker", "heroTalent/heroTalent_npc_dota_hero_night_stalker", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_night_stalker:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_night_stalker:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_night_stalker:IsStealable() 				return true end
function heroTalent_npc_dota_hero_night_stalker:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_night_stalker:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_night_stalker" end


modifier_heroTalent_npc_dota_hero_night_stalker = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_night_stalker:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_night_stalker:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_night_stalker:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_night_stalker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_night_stalker:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_night_stalker:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end


        self:StartIntervalThink(0.3)     
    end
end
function modifier_heroTalent_npc_dota_hero_night_stalker:OnIntervalThink()

    -- self:GetParent():NotifyWearablesOfModelChange(true)
    -- self:GetParent():ManageModelChanges()
    local hero = self:GetParent()
    if hero:IsInNightTime() then

        self:SetStackCount(1)
        return
    end


    self:SetStackCount(0)
end

function modifier_heroTalent_npc_dota_hero_night_stalker:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,   
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

        MODIFIER_PROPERTY_VISUAL_Z_DELTA,

	}

	return funcs
end




function modifier_heroTalent_npc_dota_hero_night_stalker:GetActivityTranslationModifiers( params )
    if self:GetStackCount()==1 then
        return "hunter_night"
    end
	return 
end

function modifier_heroTalent_npc_dota_hero_night_stalker:Advanced_GetModifierAttackSpeedPercentage()	
    if self:GetStackCount()>=1 then
        return 30
    end
    return 0
end

function modifier_heroTalent_npc_dota_hero_night_stalker:GetModifierMoveSpeed_AbsoluteMin(keys) 
    if self:GetStackCount()==1 then
        return 550
    end

    return 
end

function modifier_heroTalent_npc_dota_hero_night_stalker:GetVisualZDelta( params )
	if self:GetStackCount()==1 then
        return 150
    end
end


function modifier_heroTalent_npc_dota_hero_night_stalker:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_Flying
    }

	return funcs

end


function modifier_heroTalent_npc_dota_hero_night_stalker:Advanced_GetModifier_Flying()	
    if self:GetStackCount()==1 then
        return 1
    end
	return 0
end
