creeps_spell_Boggart = class({})

LinkLuaModifier("modifier_creeps_spell_Boggart_arua", "creeps_spell/creeps_spell_Boggart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Boggart_buff", "creeps_spell/creeps_spell_Boggart", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_health_bar", "modifier/modifier_health_bar", LUA_MODIFIER_MOTION_NONE)



function creeps_spell_Boggart:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local unit = CreateUnitByName("npc_hd_Brain_worm_clone", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()) 
	FindClearSpaceForUnit( unit, caster:GetAbsOrigin(), true )
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
	unit:AddNewModifier(caster, self, "modifier_creeps_spell_Boggart_arua", {})--提供增益
	unit:SetHealth(caster:GetHealth())
	unit:AddNewModifier(unit, nil, "modifier_health_bar", {health_bar_type=1})
	-- Effects
	EmitSoundOn( "Hero_Leshrac.Split_Earth", caster )
	-- EmitSoundOn( "Hero_Techies.ProjectileImpact", caster )
end




modifier_creeps_spell_Boggart_arua = class({})

function modifier_creeps_spell_Boggart_arua:IsDebuff() return false end
function modifier_creeps_spell_Boggart_arua:IsHidden() return false end
function modifier_creeps_spell_Boggart_arua:IsPurgable() return false end
function modifier_creeps_spell_Boggart_arua:IsAura() return true end
function modifier_creeps_spell_Boggart_arua:GetAuraDuration() return 0.1 end
function modifier_creeps_spell_Boggart_arua:GetModifierAura() return "modifier_creeps_spell_Boggart_buff" end
function modifier_creeps_spell_Boggart_arua:GetAuraRadius() return 500 end
function modifier_creeps_spell_Boggart_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Boggart_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Boggart_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creeps_spell_Boggart_arua:GetAuraEntityReject(hEntity)

	if hEntity ~= self:GetCaster() then
		return true
	end
	return false
end

function modifier_creeps_spell_Boggart_arua:OnCreated(keys)
	self.damage_count = 0
	self.need_damage = self:GetParent():GetMaxHealth()*0.1
end
function modifier_creeps_spell_Boggart_arua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end


function modifier_creeps_spell_Boggart_arua:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit
		if unit~=self:GetParent() then	return end
		if keys.damage>0 then
			self.damage_count = self.damage_count+keys.damage
			if self.damage_count >=self.need_damage then
				unit:AddNewModifier(unit,  nil, "modifier_kill", {duration = 0.1}) --召唤持续时间
			end
		end


 
    end 
end



modifier_creeps_spell_Boggart_buff = class({})
function modifier_creeps_spell_Boggart_buff:IsHidden()	return false end
function modifier_creeps_spell_Boggart_buff:IsDebuff()	return false end
function modifier_creeps_spell_Boggart_buff:IsPurgable()	return false end


function modifier_creeps_spell_Boggart_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

function modifier_creeps_spell_Boggart_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_creeps_spell_Boggart_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end
