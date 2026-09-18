creeps_spell_Nature_Attendants = class({})
LinkLuaModifier("modifier_creeps_spell_Nature_Attendants_effect", "creeps_spell/creeps_spell_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Nature_Attendants_ready", "creeps_spell/creeps_spell_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_Nature_Attendants:GetIntrinsicModifierName() return "modifier_creeps_spell_Nature_Attendants_effect" end
function creeps_spell_Nature_Attendants:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


modifier_creeps_spell_Nature_Attendants_effect = class({})
function modifier_creeps_spell_Nature_Attendants_effect:IsHidden() return true end
function modifier_creeps_spell_Nature_Attendants_effect:IsDebuff() return false end
function modifier_creeps_spell_Nature_Attendants_effect:IsPurgable() return false end
function modifier_creeps_spell_Nature_Attendants_effect:IsPurgeException() return false end
function modifier_creeps_spell_Nature_Attendants_effect:IsStunDebuff() return false end
function modifier_creeps_spell_Nature_Attendants_effect:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Nature_Attendants_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end

Summon_10 = {
    "npc_monster_wave_13_1",
    "npc_monster_wave_14_3",
}
Summon_3 = {
    "npc_monster_wave_11_1",
    "npc_monster_wave_11_2",
    "npc_monster_wave_12_1",
    "npc_monster_wave_12_2",
    "npc_monster_wave_13_2",
    "npc_monster_wave_14_2",
    "npc_monster_wave_16_1",
    "npc_monster_wave_16_2",
    "npc_monster_wave_18_1",
}




function modifier_creeps_spell_Nature_Attendants_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
    local random = RandomInt(1, 2)
    local caster = self:GetAbility():GetCaster()
    if not caster.pattern_2 then
        return
    end
    if caster:GetHealth()<=0 then
        return
    end
    local pos = caster:GetAbsOrigin()
    _G.GAME_KING_WOLF_POS = caster:GetAbsOrigin()
   if random == 1 then
    for i = 1, 10 do
        local unit = CreateUnitByName(Summon_10[RandomInt(1, 2)], pos, true, caster, caster, caster:GetTeamNumber()) 
        unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益
        local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
        ability:SetLevel(_G.GAME_DIFFICULTY)
        if GetChallengeDifficulty()~=0 then
            local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
            ability:SetLevel(GetChallengeDifficulty())
        end
        _G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
        _G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
        if GetChallengeDifficulty()>=1 then
            CreateSpecialGainForUnit(unit,0,200,1)  --为产生的单位添加词条

        end
    end
   else
    for i = 1, 3 do
        local unit = CreateUnitByName(Summon_3[RandomInt(1, 9)], pos, true, caster, caster, caster:GetTeamNumber()) 
        unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益
        local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
        ability:SetLevel(_G.GAME_DIFFICULTY)
        if GetChallengeDifficulty()~=0 then
            local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
            ability:SetLevel(GetChallengeDifficulty())
        end
        
        _G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
        _G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
        if GetChallengeDifficulty()>=1 then
            CreateSpecialGainForUnit(unit,0,200,1)  --为产生的单位添加词条
        end
    end
   end
end

