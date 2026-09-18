
LinkLuaModifier( "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff", "skills/Advanced_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect", "skills/Advanced_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count", "skills/Advanced_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1", "skills/Advanced_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3", "skills/Advanced_summons_ward_Aghanim_the_Wisest", LUA_MODIFIER_MOTION_NONE )
Advanced_summons_ward_Aghanim_the_Wisest						=  Advanced_summons_ward_Aghanim_the_Wisest or class({})
require("internal/timers")


function Advanced_summons_ward_Aghanim_the_Wisest:IsSummonSpell()return true end


function Advanced_summons_ward_Aghanim_the_Wisest:CheckKV(key)
	local table = {
		bonus_damage=0.5,


	}
	local value = table[key] or -1
	return value

end	
function Advanced_summons_ward_Aghanim_the_Wisest:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_blink_arrival.vpcf", context )

end

function Advanced_summons_ward_Aghanim_the_Wisest:UnlockFirstCore(key)
	if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
		self.CoreUnlock = false
		self.unlock1 = false
		SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	return true
end
function Advanced_summons_ward_Aghanim_the_Wisest:UnlockSecondCore(key)
	return true
end
function Advanced_summons_ward_Aghanim_the_Wisest:UnlockThirdCore(key)

	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3",{})
	

	
	return true
end
function  Advanced_summons_ward_Aghanim_the_Wisest:OnSpellStart()

	
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

	unit:AddNewModifier(caster, self, "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff", {})
	Timers:CreateTimer(0.3, function()
		unit:MoveToNPC(caster)
	end)
	
end



modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff = class({})

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:IsDebuff()			return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:IsHidden() 		return true end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:IsPurgable() 		return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:IsPurgeException() return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:GetEffectName() return "particles/rebuild/spell/summons_ward_aghanim/aghanim_arua.vpcf" end

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.mana_index = 0.25
		if self:GetAbility().advanced_level>=5 then
			self.mana_index = 0.4
		end
		local ability = self:GetAbility()
		local parent = self:GetParent()
	
		Timers:CreateTimer(0.3, function()
			if parent and not parent:IsNull() and ability and not ability:IsNull() then
				self.stack = self:GetParent():GetDamageMax()*self:GetAbility():GetSpecialValueFor("bonus_spell_damage_index")*0.01
			else
				self:SafeDestroy()
			end
			
			-- print(self:GetParent():GetDamageMax())
			-- print(self:GetAbility():GetSpecialValueFor("bonus_spell_damage_index"))
			-- print(self.stack)
		end)
		self:StartIntervalThink(0.5)
	end
end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:OnDestroy(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability and ability.unlock2 then


			local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
			)
			for _, unit in ipairs(enemies) do
				if unit~=self:GetParent() then
					unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect", {duration = 30,stack = self.stack})
					local particle_cast_fx = ParticleManager:CreateParticle("particles/creatures/aghanim/aghanim_blink_arrival.vpcf", PATTACH_CUSTOMORIGIN , unit)
					ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
					ParticleManager:ReleaseParticleIndex(particle_cast_fx)	
					EmitSoundOn( "Hero_FacelessVoid.TimeWalk", unit )
				end

			end
		end

	end
end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability then
		return
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local mana = self:GetParent():GetDamageMax()*self.mana_index
	
	for _, unit in ipairs(enemies) do
		if unit~=self:GetParent() then
			unit:GiveMana(mana)
			local modifier = unit:FindModifierByNameAndCaster("modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect", self:GetParent())
			if modifier then
				modifier:SetDuration(0.6, true)
			else
				unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect", {duration = 0.6,stack = self.stack})
			end
			
		end

	end

end






modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:IsHidden()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:IsDebuff()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:IsPurgable()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:OnCreated( kv )

	self.bonus_mana = 0
	self.duration_gain = 10
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if level>=10 then
		self.duration_gain = 15
		if level>=15 then
			self.bonus_mana = self:GetCaster():GetDamageMax()*8
		end
	
	end

	if IsServer() then
	
		self:SetStackCount(kv.stack)

		if self:GetAbility().advanced_level>=20 then
			if self:GetAbility().unlock1 then
				
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1", {})
				
			else
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count", {})
			end
			
		end
	

	end
end


-- Modifier Effects
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
	}

	return funcs
end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:GetModifierConstantManaRegen()
	return self.bonus_mana*0.05
end


-- advanced_modifier
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:Advanced_GetModifier_DurationGain(keys)
	return self.duration_gain
end


function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.duration_gain
end




modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:IsHidden()	return true end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:IsDebuff()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:IsPurgable()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect") then
		self:SafeDestroy()
	end
end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count:Advanced_GetAdvancedLevelBonus(keys)
	return 1
end


modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:IsHidden()	return true end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:IsDebuff()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:IsPurgable()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_effect") then
		self:SafeDestroy()
	end
end


function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock1:Advanced_GetAdvancedLevelBonus(keys)
	return 6
end





modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:IsHidden()	return true end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:IsDebuff()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:IsPurgable()	return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:IsPurgeException() return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:OnWaveEnd()
	if 100>=RandomInt(1, 100) then
		self:GetCaster():AddItemByName("item_secret_of_experience_3")
	end
end


function modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end


