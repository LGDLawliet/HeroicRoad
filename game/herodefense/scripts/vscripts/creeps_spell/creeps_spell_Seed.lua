creeps_spell_Seed = class({})

LinkLuaModifier("modifier_creeps_spell_Seed", "creeps_spell/creeps_spell_Seed", LUA_MODIFIER_MOTION_NONE)

require("internal/timers")

function creeps_spell_Seed:IsHiddenWhenStolen() 		return false end
function creeps_spell_Seed:IsRefreshable() 			return true end
function creeps_spell_Seed:IsStealable() 				return true end
function creeps_spell_Seed:IsNetherWardStealable()		return true end
function creeps_spell_Seed:GetIntrinsicModifierName() return "modifier_creeps_spell_Seed" end



modifier_creeps_spell_Seed = advanced_modifier({})

function modifier_creeps_spell_Seed:IsDebuff()			return false end
function modifier_creeps_spell_Seed:IsHidden() 			return true end
function modifier_creeps_spell_Seed:IsPurgable() 		    return false end
function modifier_creeps_spell_Seed:IsPurgeException() 	return false end

function modifier_creeps_spell_Seed:OnCreated(table)
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_summon_intensity")
    if not IsServer()  then
        return
    end
    self:StartIntervalThink(2)

end


function modifier_creeps_spell_Seed:OnIntervalThink()

    if not IsServer()  then
        return
    end
    local caster		= self:GetCaster()
	if caster:GetHealth()<=0 then
		return
	end
    local pos = caster:GetAbsOrigin()
    local point = Vector(pos.x+RandomInt(-1000, 1000),pos.y+RandomInt(-1000, 1000),pos.z)
	-- point.z = point.z + 100
	local ability		= self:GetAbility()

    local DummyUnit = CreateUnitByName("npc_dummy_unit",point,false,caster,caster:GetOwner(),caster:GetTeamNumber())
	DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 10})
    DummyUnit:AddNewModifier(caster, ability, "modifier_phased", {duration = 10})
    DummyUnit:AddNewModifier(caster, ability, "modifier_invulnerable", {duration = 10})
 
	local pfx_explosion = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_bramble_root.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(pfx_explosion, 0, DummyUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", DummyUnit:GetAbsOrigin(), true)

	-- ParticleManager:SetParticleControl(pfx_explosion, 0, location)
	-- ParticleManager:ReleaseParticleIndex(pfx_explosion)

	-- EmitSoundOn("Hero_Phoenix.ProjectileImpact", DummyUnit)
	-- EmitSoundOn("Hero_Phoenix.FireSpirits.Target", DummyUnit)
    local second = 10
    local third = 5
    local UnitName
    if caster:IsInDayTime() or not caster:PassivesDisabled() then
        second = 20
        third = 10
    end

	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx_explosion,false)
		if caster and not caster:IsNull() and caster:GetHealth()>0   then
			-- local unit = CreateUnitByName(UnitName, point, true, caster, caster, caster:GetTeamNumber())
			if third >= RandomInt(1, 100) then
				UnitName = "npc_monster_wave_13_3"
				self:SummonUnit(UnitName,point,10000,1000,15)
			elseif second >= RandomInt(1, 100) then
				UnitName = "npc_monster_wave_13_2"
				self:SummonUnit(UnitName,point,7000,700,10)
			else
				UnitName = "npc_monster_wave_13_1"

				self:SummonUnit(UnitName,point,3000,350,15)
				self:SummonUnit(UnitName,point,3000,350,15)
			end
			

		end
	end)
end





function modifier_creeps_spell_Seed:SummonUnit(UnitName,point,health,damage,armor)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local unit = caster:SummonUnit(UnitName,-1,point,nil,ability,0,health,nil,damage,armor,1,1)
	unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益
	local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
	ability:SetLevel(_G.GAME_DIFFICULTY)
	_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
	_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
end


-- advanced_modifier
function modifier_creeps_spell_Seed:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_creeps_spell_Seed:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus
end


