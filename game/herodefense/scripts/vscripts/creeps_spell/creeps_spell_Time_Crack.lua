creeps_spell_Time_Crack = class({})

-- LinkLuaModifier("modifier_creeps_spell_Time_Crack_thinker", "creeps_spell/creeps_spell_Time_Crack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Time_Crack_buff", "creeps_spell/creeps_spell_Time_Crack", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Time_Crack:IsHiddenWhenStolen() 		return false end
function creeps_spell_Time_Crack:IsRefreshable() 			return false  end
function creeps_spell_Time_Crack:IsStealable() 				return true  end
function creeps_spell_Time_Crack:IsNetherWardStealable() 	return true end
function creeps_spell_Time_Crack:Spawn()
	self.summon_table = {}
end
Spell_sound = {
	"faceless_void_fv_arc_cast_pain_02",
	"faceless_void_fv_arc_chronos_assist_01",
	"faceless_void_fv_arc_chronos_assist_03",
	"faceless_void_fv_arc_chronos_kill_01",

}


--------------------------------------------------------------------------------------------------------------
function creeps_spell_Time_Crack:OnSpellStart()
	for i = 1, #self.summon_table, 1 do
        local target = self.summon_table[i]
        if not target or target:IsNull() or not target:IsAlive() then
            table.remove(self.summon_table,i)
            i = i -1
        end
    end
	EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
	self:CreatePhantom()
end


function creeps_spell_Time_Crack:CreatePhantom()

	if #self.summon_table>=3 then
		local target = self.summon_table[1]
		if target and not target:IsNull() and target:IsAlive() then
            TrueKill(target, target, self)
        end
		table.remove(self.summon_table,1)
	end

    local  caster  =self:GetCaster()
    local unit = caster:SummonUnit("npc_hd_Claszian_Apostasy_phantom",nil,caster:GetAbsOrigin(),nil,self,0,15000,2000,700,30,1,1)
    FindClearSpaceForUnit( unit, caster:GetAbsOrigin(), true )
    unit:StartGesture(ACT_DOTA_TELEPORT_END)

	local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
	ability:SetLevel(_G.GAME_DIFFICULTY)
	if GetChallengeDifficulty()~=0 then
		local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
		ability:SetLevel(GetChallengeDifficulty())
	end
	_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
	_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
	if GetChallengeDifficulty()>=1 then
		CreateSpecialGainForUnit(unit,0,500,1)  --为产生的单位添加词条
	end

	table.insert(self.summon_table,unit)

end

function creeps_spell_Time_Crack:TriggerModifier()
	local  caster  =self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_Time_Crack_buff", {}) 
end



modifier_creeps_spell_Time_Crack_buff = modifier_creeps_spell_Time_Crack_buff or class({})
function modifier_creeps_spell_Time_Crack_buff:IsHidden()	return true end
function modifier_creeps_spell_Time_Crack_buff:IsDebuff()	return false end
function modifier_creeps_spell_Time_Crack_buff:IsPurgable()	return false end
function modifier_creeps_spell_Time_Crack_buff:IsPurgeException()	return false end
function modifier_creeps_spell_Time_Crack_buff:IsStunDebuff()	return false end
function modifier_creeps_spell_Time_Crack_buff:AllowIllusionDuplicate()	return false end

function modifier_creeps_spell_Time_Crack_buff:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,

	}
end


function modifier_creeps_spell_Time_Crack_buff:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_creeps_spell_Time_Crack_buff:GetModifierMoveSpeedBonus_Percentage() return   30 end
function modifier_creeps_spell_Time_Crack_buff:GetActivityTranslationModifiers()	
	return "haste"

end
