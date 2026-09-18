--特效优化 √
Advanced_counterspell = class({})
-- LinkLuaModifier("modifier_Advanced_counterspell_arua", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_counterspell_arua_effect", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_trigger_buff", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_Advanced_counterspell_active", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_effect", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_effect_enemy", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_counterspell_effect2", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_counterspell_active_standby", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_counterspell_debuff", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_counterspell_thinker", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_unlock2", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_unlock2_debuff", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_counterspell_unlock3", "skills/Advanced_counterspell", LUA_MODIFIER_MOTION_NONE)
function Advanced_counterspell:CheckKV(key)
	local table = {

		bonus_magic_resistance = 0.5,


	}
	local value = table[key] or -1
	return value

end
function Advanced_counterspell:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", context )
end
function Advanced_counterspell:UnlockFirstCore(key)
	return true
end
function Advanced_counterspell:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_counterspell_unlock2",{})
	return true
end
function Advanced_counterspell:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_counterspell_unlock3",{})
	return true
end
function Advanced_counterspell:GetCooldown(iLevel)
	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return 0
		end
		
	end

	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_counterspell:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_counterspell:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_counterspell:OnToggle()

end
function Advanced_counterspell:GetBehavior()
	
	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	-- -- local advanced_level = self:GetSpecialValueFor("advanced_level")
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	-- local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	-- if coreUnlockKV then
	-- if self:GetUnlock(2) ==2   then
	if self:GetSpecialValueFor("advanced_level")>=15 then
		
	
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IMMEDIATE +DOTA_ABILITY_BEHAVIOR_NO_TARGET +DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
		
	-- end

	return self.BaseClass.GetBehavior(self)
end

-- Item Passive
-- require('internal/timers')   --计时器功能
function Advanced_counterspell:GetIntrinsicModifierName()
	return "modifier_Advanced_counterspell"
end



modifier_Advanced_counterspell = class({})

function modifier_Advanced_counterspell:IsDebuff() return false end
function modifier_Advanced_counterspell:IsHidden() return true end
function modifier_Advanced_counterspell:IsPurgable() 		return false end
function modifier_Advanced_counterspell:IsPurgeException() 	return false end
function modifier_Advanced_counterspell:RemoveOnDeath()  return false end


function modifier_Advanced_counterspell:OnCreated(keys)
    self.ability = self:GetAbility()
	self:StartIntervalThink(0.1)
	self.advanced_level = 1
	self.radius = self:GetAbility():GetSpecialValueFor("range")
 

end
function modifier_Advanced_counterspell:OnRefresh(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("range")
 
end


function modifier_Advanced_counterspell:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_ABSORB_SPELL,
	

	}
end


function modifier_Advanced_counterspell:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or  self.bonus_magic_resistance end


--当触发法术反弹时 添加一个莲花的buff 并由此再触发一次 
--备注 所有法术反弹都是由莲花触发的 所以当有莲花BUFF时说明有别的道具或技能触发了这个even  直接返回即可
function modifier_Advanced_counterspell:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if ability.unlock2 then
		return
	end
	local parent =self:GetParent()
	if not ability:IsCooldownReady() then
		return
	end
	if parent:PassivesDisabled() then
		return
	end
	if not IsEnemy(keys.ability:GetCaster(), parent) then
		return 0
	end
	--说明这次法术吸收是由法术反弹引起的
	if parent:HasModifier("modifier_item_lotus_orb_active") then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, parent)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(400,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	parent:EmitSound("Hero_Antimage.Counterspell.Target")
	ability:UseResources(true, true, true, true)


	--LV5解锁法术吸收+
	if self.advanced_level>=5 then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_counterspell_trigger_buff", {duration =2})
	end

	--LV10解锁法术吸收
	if self.advanced_level>=10 then
		local hpregen = parent:GetMaxHealth()*(ability:GetSpecialValueFor("health_regen_percent")*0.01)
		local health = math.min(parent:GetHealth()+hpregen,parent:GetMaxHealth())
		--print("hpregen",hpregen,health)
		parent:SetHealth(health)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL , parent, hpregen, nil)
	end


	if not ability.unlock1 then
			--LV10解锁法术反弹
		if self.advanced_level>=10 then
			if not self.trigger then
				local modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_lotus_orb_active", {duration = 5})
				self.trigger = true
				parent:TriggerSpellAbsorb(keys.ability) --二次触发
				if modifier then
					modifier:SafeDestroy()
				end
				
				local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
				parent:EmitSound("DOTA_Item.LinkensSphere.Activate")

		
				--防止出现某些BUG
				Timers:CreateTimer(0.1, function()
					self.trigger = false
				end)
				return 1
			end
		end
	end




	return 1
end


--魔法伤害吸收
function modifier_Advanced_counterspell:OnIntervalThink()
	self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")

	--isServer
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if not parent or not parent:IsAlive() then
		return
	end
	local ability = self:GetAbility()
	if not ability:GetToggleState() then
		return
	end
	if parent:IsInvulnerable() then
		return
	end
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	

	for _, unit in ipairs(units) do
		if unit:HasModifier("modifier_Primary_counterspell") or unit:HasModifier("modifier_Middle_counterspell") or unit:HasModifier("modifier_Advanced_counterspell") then
			goto continue
		end
		if  unit ~= self:GetParent()   then
			unit:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_counterspell_effect", { duration = 1.0 })
		end
		::continue::
	end

	if self.ability.advanced_level>=15 and self.ability:GetAutoCastState() then
		units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(units) do
			unit:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_counterspell_effect_enemy", { duration = 1.0 })
		end
	end
	
end

modifier_Advanced_counterspell_effect = advanced_modifier({})

function modifier_Advanced_counterspell_effect:IsDebuff()			return false end
function modifier_Advanced_counterspell_effect:IsHidden() 			return false end
function modifier_Advanced_counterspell_effect:IsPurgable() 		return false end
function modifier_Advanced_counterspell_effect:IsPurgeException() 	return false end

function modifier_Advanced_counterspell_effect:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end
--受到伤害时检测是否是友军，是则将伤害转移到自己身上
function modifier_Advanced_counterspell_effect:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	local target = keys.target
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if not ability or ability:IsNull() then
		return 0
	end
	if not ability:GetToggleState() then
		return
	end
	if not parent or parent:IsNull() or not parent:IsAlive() then	return 0 end
	if not target or target:IsNull() or not target:IsAlive() then 	return 0 end
	local damage = keys.damage
	if damage<=0 then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS  ) == DOTA_DAMAGE_FLAG_HPLOSS  then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   then
		return 0
	end
	local pass = false
	if  keys.damage_type ==DAMAGE_TYPE_MAGICAL then
		pass = true
	else
		if ability:GetSpecialValueFor("advanced_level")>=20 and 25>=RandomInt(1, 100) then
			pass = true
		end
	end

	if  pass then
		local current_magic_resis = caster:Script_GetMagicalArmorValue(	false,nil)
		damage = damage*math.min(current_magic_resis,1)  --最大格挡所有伤害		
		if damage<=0 then
			return 0 --魔抗为负数时不格挡
		end
		local damage_flags =  keys.damage_flags +DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS   ) == DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION   ) == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL   ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
		end

		print("damage=",damage)
		local damageTable = {

			attacker =keys.attacker, --伤害来源
			victim = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, 
			damage_flags = damage_flags,
		}

		ApplyDamage(damageTable)
		self:PlayEffects( parent,caster )
		if IsEnemy(keys.attacker,caster) and not keys.attacker:IsInvulnerable() then
			caster:GameTimer(ability:GetSpecialValueFor("delay"), function()
				if IsValid(ability) and IsValid(keys.attacker) then
					local damageTable = {
						victim = keys.attacker,
						attacker = caster,
						damage = damage ,--增加反弹伤害
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = damage_flags,
						ability = ability,
					}
					ApplyDamage(damageTable)
					self:PlayEffects(caster,keys.attacker )	
				end
			end)
		end
		return damage
	end

	return 0
	
end


function modifier_Advanced_counterspell_effect:PlayEffects( target,caster )
	
	local particle_cast = "particles/rebuild/spell/counterspell/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  caster)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
end


modifier_Advanced_counterspell_effect_enemy = advanced_modifier({})

function modifier_Advanced_counterspell_effect_enemy:IsDebuff()			return true end
function modifier_Advanced_counterspell_effect_enemy:IsHidden() 			return true end
function modifier_Advanced_counterspell_effect_enemy:IsPurgable() 		return false end
function modifier_Advanced_counterspell_effect_enemy:IsPurgeException() 	return false end

function modifier_Advanced_counterspell_effect_enemy:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end

function modifier_Advanced_counterspell_effect_enemy:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	local target = keys.target
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if not ability or ability:IsNull() then
		return 0
	end
	if not parent or parent:IsNull() or not parent:IsAlive() then	return 0 end
	if not target or target:IsNull() or not target:IsAlive() then 	return 0 end
	
	local damage = keys.damage
	if damage<=0 then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS  ) == DOTA_DAMAGE_FLAG_HPLOSS  then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT   then
		return 0
	end
	if not ability:GetAutoCastState() then
		return
	end
	if not ability:GetToggleState() then
		return
	end
	if  keys.damage_type ==DAMAGE_TYPE_MAGICAL then
		local current_magic_resis = caster:Script_GetMagicalArmorValue(	false,nil)*0.5
		damage = damage*math.min(current_magic_resis,1)  --最大格挡所有伤害		
		if damage<=0 then
			return 0 --魔抗为负数时不格挡
		end
		--自己吸收的魔法伤害，以反射的形式触发
		local damage_flags =  keys.damage_flags +DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS   ) == DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION   ) == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL   ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then
			damage_flags = damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
		end

		local damageTable = {

			attacker =keys.attacker, --伤害来源
			victim = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, 
			damage_flags = damage_flags,
		}
		ApplyDamage(damageTable)
		self:PlayEffects( parent,caster )
		caster:GameTimer(ability:GetSpecialValueFor("delay"), function()
			if IsValid(ability) and IsValid(parent) then
				local damageTable = {
					victim = parent,
					attacker = caster,
					damage = damage ,--增加反弹伤害
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = damage_flags,
					ability = ability,
				}
				ApplyDamage(damageTable)
				self:PlayEffects(caster,parent)
			end
		end)
		return 0
	end
	
end


function modifier_Advanced_counterspell_effect_enemy:PlayEffects( target,caster )
	
	local particle_cast = "particles/rebuild/spell/counterspell/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  caster)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
end



modifier_Advanced_counterspell_trigger_buff = class({})

function modifier_Advanced_counterspell_trigger_buff:IsDebuff() return false end
function modifier_Advanced_counterspell_trigger_buff:IsHidden() return false end
function modifier_Advanced_counterspell_trigger_buff:IsPurgable() return false end

function modifier_Advanced_counterspell_trigger_buff:DeclareFunctions()
	return {
	

		MODIFIER_PROPERTY_ABSORB_SPELL,
	

	}
end



function modifier_Advanced_counterspell_trigger_buff:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	local level = self:GetAbility().advanced_level

	local parent =self:GetParent()

	if parent:PassivesDisabled() then
		return
	end
	if not IsEnemy(keys.ability:GetCaster(), parent) then
		return 0
	end
	--说明这次法术吸收是由法术反弹引起的
	if parent:HasModifier("modifier_item_lotus_orb_active") then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, parent)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(400,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	parent:EmitSound("Hero_Antimage.Counterspell.Target")

	--LV10解锁法术吸收
	if level>=10 then
		local hpregen = parent:GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("health_regen_percent")*0.01)
		local health = math.min(parent:GetHealth()+hpregen,parent:GetMaxHealth())
		--print("hpregen",hpregen,health)
		parent:SetHealth(health)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL , parent, hpregen, nil)
	end

	
	return 1
end












modifier_Advanced_counterspell_unlock2 = class({})

function modifier_Advanced_counterspell_unlock2:IsDebuff()			return false end
function modifier_Advanced_counterspell_unlock2:IsHidden() 			return true end
function modifier_Advanced_counterspell_unlock2:IsPurgable() 		return false end
function modifier_Advanced_counterspell_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_counterspell_unlock2:AllowIllusionDuplicate() return false end
function modifier_Advanced_counterspell_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_counterspell_unlock2:DeclareFunctions() 
    return {
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
 end

function modifier_Advanced_counterspell_unlock2:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() then
		return
    end
	if IsEnemy(keys.unit,self:GetParent()) or keys.target~=self:GetParent() then
		return
	end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=3 then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_CUSTOMORIGIN, parent)
		-- ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(500,0,0))
		ParticleManager:ReleaseParticleIndex(pfx)
		parent:EmitSound("Hero_Antimage.Counterspell.Target")
		local ability = self:GetAbility()
		local damage_table ={
			-- victim 			= target,
			damage 			= parent:GetMaxHealth()*0.1+keys.unit:GetMaxMana()*0.2,
			damage_type		= DAMAGE_TYPE_PHYSICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= parent,
			ability 		= ability
		}
		if ability:GetAutoCastState() then
			damage_table.damage = damage_table.damage*2
			self:RemoveRandomBuff(parent)
		end
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, unit in ipairs(units) do
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, unit)
			ParticleManager:SetParticleControl(pfx, 0,unit:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(400,0,0))
			ParticleManager:ReleaseParticleIndex(pfx)
			unit:EmitSound("Hero_Antimage.Counterspell.Target")
			unit:AddNewModifier(parent,ability,"modifier_Advanced_counterspell_unlock2_debuff",	{	duration = 20})
			damage_table.victim = unit
			ApplyDamage(damage_table)
			if i>=3 then
				break
			end
		end


	
    end
  
    
end

function modifier_Advanced_counterspell_unlock2:RemoveRandomBuff(target)
	local tModifiers = target:FindAllModifiers()
	local modifier_Table = {}
	for _, hModifier in pairs(tModifiers) do
 
		if hModifier.IsBuff and hModifier:IsBuff() or hModifier.IsDebuff and not hModifier:IsDebuff() then
			if hModifier:IsPurgable() then
				table.insert(modifier_Table,hModifier)
			end

		end
	end
	if #modifier_Table>0 then
		GetRandomElement(modifier_Table):SafeDestroy()
	end


end




modifier_Advanced_counterspell_unlock2_debuff = advanced_modifier({})

function modifier_Advanced_counterspell_unlock2_debuff:IsDebuff() return true end
function modifier_Advanced_counterspell_unlock2_debuff:IsHidden() return false end
function modifier_Advanced_counterspell_unlock2_debuff:IsPurgable() return false end
function modifier_Advanced_counterspell_unlock2_debuff:IsPurgeException() return true end

function modifier_Advanced_counterspell_unlock2_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_counterspell_unlock2_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_counterspell_unlock2_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end





function modifier_Advanced_counterspell_unlock2_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_counterspell_unlock2_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()*5
end




modifier_Advanced_counterspell_unlock3 = advanced_modifier({})

function modifier_Advanced_counterspell_unlock3:IsDebuff() return false end
function modifier_Advanced_counterspell_unlock3:IsHidden() return false end
function modifier_Advanced_counterspell_unlock3:IsPurgable() return false end
function modifier_Advanced_counterspell_unlock3:IsPurgeException() return false end
function modifier_Advanced_counterspell_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_counterspell_unlock3:OnCreated()
	if IsServer() then
		self.time = GameRules:GetGameTime()
		self.index = 0.5
	end
end

function modifier_Advanced_counterspell_unlock3:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
		if Game_State:IsInBattle() then
			if self.time >= GameRules:GetGameTime() then
				return
			end
			if keys.damage_type ==DAMAGE_TYPE_MAGICAL  then
				local damage = keys.original_damage
				self:SetStackCount(self:GetStackCount()+damage*self.index)
				self:TryRelease()
			end
		end
      
    end
	return 0
end

function modifier_Advanced_counterspell_unlock3:TryRelease()
	local stack = self:GetStackCount()
	local parent = self:GetParent()
	if stack>=parent:GetMaxHealth()*2 then
		self.index = math.min(self.index+0.01,2)
		self:SetStackCount(0)
		self.time = GameRules:GetGameTime() +0.5
		local pfx = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(600,0,0))
		ParticleManager:ReleaseParticleIndex(pfx)
		parent:EmitSound("Hero_Antimage.Counterspell.Target")
		local ability = self:GetAbility()
		local damage_table ={
			-- victim 			= target,
			damage 			= parent:GetMaxHealth(),
			damage_type		= DAMAGE_TYPE_PHYSICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= parent,
			ability 		= ability
		}
		parent:GiveMana(parent:GetMaxHealth()*0.1)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, parent, parent:GetMaxHealth()*0.1, nil)
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, unit in ipairs(units) do
			damage_table.victim = unit
			ApplyDamage(damage_table)
			
		end
	end


end


function modifier_Advanced_counterspell_unlock3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
