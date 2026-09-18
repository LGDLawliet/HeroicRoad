creeps_spell_Spawn = class({})

LinkLuaModifier("modifier_creeps_spell_Spawn_delay", "creeps_spell/creeps_spell_Spawn", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Spawn:IsHiddenWhenStolen() 		return false end
function creeps_spell_Spawn:IsRefreshable() 			return true  end
function creeps_spell_Spawn:IsStealable() 		    	return false  end



function creeps_spell_Spawn:OnSpellStart()
	if not IsServer() then
		return
	end
	self:StartCooldown(self:GetCooldownTimeRemaining() + RandomInt(0, 5))
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Broodmother.SpawnSpiderlingsImpact")


	local min = self:GetSpecialValueFor("number_min")
	local max = self:GetSpecialValueFor("number_max")

	local delay = self:GetSpecialValueFor("spawn_time")
	local position = caster:GetAbsOrigin()
	for i = 1, RandomInt(min , max) do
		local unit = CreateUnitByName( "npc_monster_wave_4_1_2", Vector(position.x+RandomInt(-300, 300),position.y+RandomInt(-300, 300),position.z), true, caster, caster, caster:GetTeamNumber() )
		unit:AddNewModifier(caster, self, "modifier_creeps_spell_Spawn_delay", {duration = delay})
		unit:AddNewModifier(caster, self, "modifier_kill", {duration = delay+0.2})
		_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
		_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
	end

end

modifier_creeps_spell_Spawn_delay = class({})

function modifier_creeps_spell_Spawn_delay:IsDebuff()			return true end
function modifier_creeps_spell_Spawn_delay:IsHidden() 			return false end
function modifier_creeps_spell_Spawn_delay:IsPurgable() 		    return false end
function modifier_creeps_spell_Spawn_delay:IsPurgeException() 	return false end

function modifier_creeps_spell_Spawn_delay:OnCreated(table)
end
function modifier_creeps_spell_Spawn_delay:OnDestroy()
	if not IsServer() then
		return
	end
	if self:GetParent():GetHealth()>0 then
		local caster = self:GetCaster()
		if not caster or caster:IsNull() or not caster:IsAlive() then
			return
		end
		local unit = CreateUnitByName( "npc_monster_wave_4_1_1", self:GetParent():GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber() )
		self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_kill", {duration = 0.1})
		self:GetParent():EmitSound("Hero_Broodmother.SpawnSpiderlings")
		unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益
		local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
		ability:SetLevel(_G.GAME_DIFFICULTY)
		
		_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
		_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
	end
end


