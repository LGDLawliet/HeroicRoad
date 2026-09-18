creeps_spell_Summon_Tree_Spirit = class({})


function creeps_spell_Summon_Tree_Spirit:IsHiddenWhenStolen() 		return false end
function creeps_spell_Summon_Tree_Spirit:IsRefreshable() 			return true end
function creeps_spell_Summon_Tree_Spirit:IsStealable() 				return true end
function creeps_spell_Summon_Tree_Spirit:IsNetherWardStealable()		return true end



function creeps_spell_Summon_Tree_Spirit:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    local number = self:GetSpecialValueFor("number")
    local duration = self:GetSpecialValueFor("duration")
    local pos = target:GetAbsOrigin()
    if caster:IsInDayTime() and not caster:PassivesDisabled() then
        number = number*1.5
    end
    for i = 1, number do
        local unit = CreateUnitByName("npc_monster_wave_13_1", pos, true, caster, caster, caster:GetTeamNumber())
        unit:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
        unit:SetForceAttackTarget(target)
    end
end

