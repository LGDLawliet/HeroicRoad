creeps_spell_Wave33 = class({})
require('internal/timers')   --计时器功能
LinkLuaModifier("modifier_creeps_spell_Wave33", "creeps_spell/creeps_spell_Wave33", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Wave33:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave33:IsRefreshable() 			return true end
function creeps_spell_Wave33:IsStealable() 				return true end
function creeps_spell_Wave33:IsNetherWardStealable()		return true end
function creeps_spell_Wave33:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave33" end


modifier_creeps_spell_Wave33 = advanced_modifier({})

function modifier_creeps_spell_Wave33:IsDebuff() return false end
function modifier_creeps_spell_Wave33:IsHidden() return true end
function modifier_creeps_spell_Wave33:IsPurgable() return false end
function modifier_creeps_spell_Wave33:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_16.vpcf" end
function modifier_creeps_spell_Wave33:StatusEffectPriority() return 1000 end
function modifier_creeps_spell_Wave33:OnCreated(keys)
    if IsServer() then
        _G.GAME_ENDLESS_WAVE = _G.GAME_ENDLESS_WAVE+1
        self.damage_reduce = -GetPlayerCount()*10
        self:SetStackCount(_G.GAME_ENDLESS_WAVE)
        local stack = self:GetStackCount()
        local index = 0.011
        if stack>=150 then
            index =index + (stack-150)/50000
            if stack>=450 then
                index =index+ (stack-450)/1000
            end
        end
        IncreaseHealth(self:GetParent(), math.min(self:GetStackCount()*2000*(1+self:GetStackCount()*index), 2100000000))
        -- SetCreatureHealth(self:GetParent(), 20000+self:GetStackCount()*2000, true)
    end

end

--
function modifier_creeps_spell_Wave33:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力
		MODIFIER_EVENT_ON_DEATH,                            --死亡
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

	}
end

function modifier_creeps_spell_Wave33:GetModifierAttackSpeedBonus_Constant()
    local stack = self:GetStackCount()
    if stack>200 then
        return stack*2-400
    end
	return 0
end

function modifier_creeps_spell_Wave33:GetModifierBaseAttack_BonusDamage()	
    local stack = self:GetStackCount()
    local index = 0.011
    if stack>=150 then
        index =index + (stack-150)/50000
        if stack>=450 then
            index =index+ (stack-450)/2000
        end
    end
    return 700+stack*100*(1+stack*index) 
end
-- function modifier_creeps_spell_Wave33:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_creeps_spell_Wave33:GetModifierMoveSpeedBonus_Constant()	return self:GetStackCount()*6.5 end
function modifier_creeps_spell_Wave33:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_creeps_spell_Wave33:Advanced_GetModifierIncomingDamage_Percentage()	return self.damage_reduce end

function modifier_creeps_spell_Wave33:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		
        _G.GAME_ENDLESS_WAVE_COUNT = _G.GAME_ENDLESS_WAVE_COUNT+1
        if _G.GAME_Reincarnation_Wave>=1 then --
            
            if _G.GAME_ENDLESS_WAVE_COUNT%3==0 then
                local chance = _G._G.GAME_ENDLESS_WAVE_COUNT*RandomFloat(0, 1.3)
                if _G.GAME_ENDLESS_WAVE_COUNT%50==0 then
                    chance = chance * 20
                end
                skillshop:RollBonusCore(chance) 
            end
           
        end
        local count = _G.GAME_ENDLESS_WAVE_COUNT
        if 5>=RandomInt(1, 100) or count%5==0 and 50>=RandomInt(1, 100) then
            player_database:UpdateHeroInfo()
        end
        for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
            if steamID ~= "0" then
                local player = PlayerResource:GetPlayer(nPlayerID)

                CustomGameEventManager:Send_ServerToPlayer(player, "ShowEndless",{count})
            end
    
        end
    end
   
end
function modifier_creeps_spell_Wave33:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetStackCount()*0.01
end
function modifier_creeps_spell_Wave33:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
	return funcs
end
