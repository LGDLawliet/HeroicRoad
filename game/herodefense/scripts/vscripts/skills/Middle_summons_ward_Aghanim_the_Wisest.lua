
LinkLuaModifier( "modifier_Middle_summons_ward_Aghanim_the_Wisest_buff", "skills/Middle_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect", "skills/Middle_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
 Middle_summons_ward_Aghanim_the_Wisest						=  Middle_summons_ward_Aghanim_the_Wisest or class({})
require("internal/timers")




function Middle_summons_ward_Aghanim_the_Wisest:IsSummonSpell()return true end


function  Middle_summons_ward_Aghanim_the_Wisest:OnSpellStart()

	
	local caster =self:GetCaster()



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = 0
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local summon_intensity_gain = caster:GetSummonIntensityIndex(1)
	heal = heal*summon_intensity_gain
	
	damage = damage*summon_intensity_gain
	armor = armor *summon_intensity_gain
	--阶梯式攻击力计算

	local newDamage = damage
	if newDamage>=500 then
		newDamage = newDamage -500
		damage = newDamage*0.1 +370
	elseif newDamage>=300 then
		newDamage = newDamage -300
		damage = newDamage*0.5 +270
	elseif newDamage>=200 then
		newDamage = newDamage -200
		damage = newDamage*0.7 +200
	end

	-- Add spawn particles in spawn location
	EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", caster)	

	local unit = caster:SummonUnit("npc_hd_aghanim",life_duration,
	unit_pos,
	self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,0,1)

	unit:AddNewModifier(caster, self, "modifier_Middle_summons_ward_Aghanim_the_Wisest_buff", {})
	Timers:CreateTimer(0.3, function()
		unit:MoveToNPC(caster)
	end)
	
end



modifier_Middle_summons_ward_Aghanim_the_Wisest_buff = class({})

function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:IsDebuff()			return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:IsHidden() 		return true end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:IsPurgable() 		return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:IsPurgeException() return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:GetEffectName() return "particles/rebuild/spell/summons_ward_aghanim/aghanim_arua.vpcf" end

function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		
		local ability = self:GetAbility()
		local parent = self:GetParent()
	
		Timers:CreateTimer(0.3, function()
			if parent and not parent:IsNull() and ability and not ability:IsNull() then
				self.stack = self:GetParent():GetDamageMax()*self:GetAbility():GetSpecialValueFor("bonus_spell_damage_index")*0.01
			else
				self:SafeDestroy()
			end
			-- print(self:GetAbility():GetSpecialValueFor("bonus_spell_damage_index"))
			-- print(self.stack)
		end)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local mana = self:GetParent():GetDamageMax()*0.25
	
	for _, unit in ipairs(enemies) do
		if unit~=self:GetParent() then
			unit:GiveMana(mana)
			unit:AddNewModifier(caster, ability, "modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect", {duration = 0.5,stack = self.stack})
		end

	end

end










modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:IsHidden()	return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:IsDebuff()	return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:IsPurgable()	return false end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:OnCreated( kv )

	if IsServer() then
	
		self:SetStackCount(kv.stack)

	end
end

function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Middle_summons_ward_Aghanim_the_Wisest_buff_effect:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end