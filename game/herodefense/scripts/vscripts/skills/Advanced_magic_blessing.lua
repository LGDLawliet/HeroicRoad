
LinkLuaModifier("modifier_Advanced_magic_blessing_meditate", "skills/Advanced_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_magic_blessing", "skills/Advanced_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_magic_blessing_unlock1", "skills/Advanced_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_magic_blessing_unlock2", "skills/Advanced_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_magic_blessing_unlock3", "skills/Advanced_magic_blessing", LUA_MODIFIER_MOTION_NONE)

Advanced_magic_blessing							= class({})
function Advanced_magic_blessing:CheckKV(key)
	local table = {

	


		bonus_spell_damage_amplification = 1,




	}
	local value = table[key] or -1
	return value

end
require('internal/timers')   --计时器功能
function Advanced_magic_blessing:GetIntrinsicModifierName()
	return "modifier_Advanced_magic_blessing_meditate"
end

function Advanced_magic_blessing:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock1",{})
	return true
end
function Advanced_magic_blessing:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_magic_blessing:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock3",{})
	return true
end

function Advanced_magic_blessing:Precache( context )
	PrecacheResource( "particle", "particles/world_shrine/radiant_shrine_active.vpcf", context )

	

end
function Advanced_magic_blessing:ProcsMagicStick() return false end

function Advanced_magic_blessing:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_magic_blessing:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_magic_blessing:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_KeeperOfTheLight.ManaLeak.Cast")
		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_magic_blessing", {})
	else
		self:GetCaster():EmitSound("Hero_Antimage.ManaBreak")

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_magic_blessing", self:GetCaster())
	end
	
end

-----------------------------------
-- MANA SHIELD MEDITATE MODIFIER --
-----------------------------------
modifier_Advanced_magic_blessing_meditate		= advanced_modifier({})

function modifier_Advanced_magic_blessing_meditate:IsHidden()	return true end
function modifier_Advanced_magic_blessing_meditate:IsPurgable() 		return false end
function modifier_Advanced_magic_blessing_meditate:IsPurgeException() 	return false end
function modifier_Advanced_magic_blessing_meditate:RemoveOnDeath()  return false end
function modifier_Advanced_magic_blessing_meditate:DeclareFunctions()
	local decFuncs = {	

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

    return decFuncs
end
function modifier_Advanced_magic_blessing_meditate:OnCreated(table)

	self.bonus_spell_damage_amplification = 0
	self.mana_regen = 0
	self.advanced_level = 1
	self:StartIntervalThink(1)
end
function modifier_Advanced_magic_blessing_meditate:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local index = 0.1
	--LV5解锁魔力操控+
	if self.advanced_level>=5 then
		index = 0.15
	end
	self.mana_regen = caster:GetIntellect(false)*index
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_damage_amplification")
end
-- function modifier_Advanced_magic_blessing_meditate:GetModifierManaBonus()	return self.bonus_mana end
function modifier_Advanced_magic_blessing_meditate:Advanced_GetModifierSpellAmplifyBonus()	
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	if IsClient() then
		return self.bonus_spell_damage_amplification
	end
	--最高造诣
	local chance = 10
	--LV10解锁最高造诣+
	if self.advanced_level>=10 then
		chance = 15
	end
	local bonus_chance = self:GetParent():GetIntellect(false)/100
	bonus_chance = bonus_chance-bonus_chance%1
	if bonus_chance>0 then
		chance = chance +bonus_chance
	end
	if chance>=RandomInt(1, 100) then
		return self.bonus_spell_damage_amplification *3
	end
	return self.bonus_spell_damage_amplification 
end
function modifier_Advanced_magic_blessing_meditate:GetModifierConstantManaRegen()	return self:GetParent():PassivesDisabled() and 0 or  self.mana_regen end



function modifier_Advanced_magic_blessing_meditate:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end
	if self.advanced_level<15 then
		return
	end
	local cooldown_reduction = 2.5
	local delay= 7
	--lv20解锁魔导+
	if self.advanced_level>=20 then
		cooldown_reduction = 4
		delay = 5.5
	end
		
	

	-- if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
	-- 	return 
	-- end
	if self:GetParent():PassivesDisabled() then
		return
	end

	local ability = keys.ability
	Timers:CreateTimer(delay, function()
		if not ability or ability:IsNull() then
			return
		end
		
		local newCooldown = ability:GetCooldownTimeRemaining() - cooldown_reduction
		ability:EndCooldown()
		if newCooldown>=0 then
			ability:StartCooldown(newCooldown)
		end
	end)


end

function modifier_Advanced_magic_blessing_meditate:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

--------------------------
modifier_Advanced_magic_blessing				= class({})


function modifier_Advanced_magic_blessing:IsPurgable() 		return false end
function modifier_Advanced_magic_blessing:RemoveOnDeath()	return false end

function modifier_Advanced_magic_blessing:OnCreated(table)
	if IsClient() then
		return
	end
	self.mana_regen = 0
	self:StartIntervalThink(1)
end
function modifier_Advanced_magic_blessing:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.mana_regen = caster:GetIntellect(false)*0.05
	if caster:GetHealth()<=0 then
		return
	end

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	table.remove(units,1)
	for _, unit in ipairs(units) do
		if unit:IsRealHero() then

			local mana_regen = unit:GetManaRegen()*0.5
			if mana_regen<=0 then
				return
			end--

			local pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_magic_blessing.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			caster:GiveMana(mana_regen)
			unit:Script_ReduceMana(mana_regen,ability)

		end
	end




end





modifier_Advanced_magic_blessing_unlock1		= advanced_modifier({})

function modifier_Advanced_magic_blessing_unlock1:IsHidden()	return false end
function modifier_Advanced_magic_blessing_unlock1:IsPurgable() 		return false end
function modifier_Advanced_magic_blessing_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_magic_blessing_unlock1:RemoveOnDeath()  return false end
function modifier_Advanced_magic_blessing_unlock1:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

    return decFuncs
end

function modifier_Advanced_magic_blessing_unlock1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint,
    }
end



function modifier_Advanced_magic_blessing_unlock1:Advanced_GetModifierSpellAmplifyBonus()	
	return 20*self:GetStackCount()
end
function modifier_Advanced_magic_blessing_unlock1:Advanced_GetModifier_CastPoint() return 1000 end



function modifier_Advanced_magic_blessing_unlock1:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end
	if keys.ability==self.current_spell then
		self:SetStackCount(math.min(self:GetStackCount()+1,20))
	else
		self:SetStackCount(0)
		self.current_spell = keys.ability
	end

end








modifier_Advanced_magic_blessing_unlock2		= advanced_modifier({})

function modifier_Advanced_magic_blessing_unlock2:IsHidden()	return false end
function modifier_Advanced_magic_blessing_unlock2:IsPurgable() 		return false end
function modifier_Advanced_magic_blessing_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_magic_blessing_unlock2:RemoveOnDeath()  return false end
function modifier_Advanced_magic_blessing_unlock2:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	    }

    return decFuncs
end

function modifier_Advanced_magic_blessing_unlock2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Advanced_magic_blessing_unlock2:OnCreated(table)
	if IsServer() then
		self.abilitu_list = {}
	end
end

function modifier_Advanced_magic_blessing_unlock2:Advanced_GetModifierSpellAmplifyBonus()	
	return 2*self:GetStackCount()
end


function modifier_Advanced_magic_blessing_unlock2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	local name = keys.ability:GetAbilityName()
	if IsInTable(name,self.abilitu_list) then
		return
	end
	table.insert(self.abilitu_list,name)
	self:SetStackCount(math.min(self:GetStackCount()+1,300))
	keys.unit:EmitSound("ui.books.pageturns")
	keys.unit:EmitSound("Shrine.Cast")
	local pfx = ParticleManager:CreateParticle("particles/world_shrine/radiant_shrine_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)

	-- ParticleManager:SetParticleControl( pfx, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControlEnt(pfx, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end






modifier_Advanced_magic_blessing_unlock3		= advanced_modifier({})

function modifier_Advanced_magic_blessing_unlock3:IsHidden()	return true end
function modifier_Advanced_magic_blessing_unlock3:IsPurgable() 		return false end
function modifier_Advanced_magic_blessing_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_magic_blessing_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_magic_blessing_unlock3:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_Advanced_magic_blessing_unlock3:Advanced_GetAdvancedLevelBonus(keys)
	return 10
end

