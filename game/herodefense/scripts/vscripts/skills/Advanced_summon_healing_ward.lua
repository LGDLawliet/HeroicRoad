
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_buff", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_extra", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_extra_earth", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_extra_water", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_extra_fire", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_healing_ward_extra_storm", "skills/Advanced_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
 Advanced_summon_healing_ward						=  Advanced_summon_healing_ward or class({})
require("internal/timers")
function Advanced_summon_healing_ward:IsSummonSpell()return true end
function Advanced_summon_healing_ward:CheckKV(key)
	local table = {
		bonus_health=2,
		heal=2,
		hp_heal=0.1,
		duration=0.4,
	}
	local value = table[key] or -1
	return value
end

function Advanced_summon_healing_ward:UnlockFirstCore(key)

	return true
end
function Advanced_summon_healing_ward:UnlockSecondCore(key)

	return false
end
function Advanced_summon_healing_ward:UnlockThirdCore(key)

	return false

end
function  Advanced_summon_healing_ward:OnSpellStart()
	local caster =self:GetCaster()

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		if unit:FindModifierByNameAndCaster("modifier_Advanced_summon_healing_ward_buff", caster) then
			TrueKill(caster,unit,self)
		end
	end
	self.type = 0
	self.level = 0
	--决定图腾类型
	for i=0, 1 do  
		local Ability = caster:GetAbilityByIndex(i)
		if Ability and not self.unlock1 then  
			if Ability:GetAbilityName() == "Primary_Eldwurm_soul_Uldorak" or Ability:GetAbilityName() == "Middle_Eldwurm_soul_Uldorak" or Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Uldorak"then
				self.type = 1
				print("大地的意志激活")
				if Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Uldorak" then
					self.level = Ability.advanced_level
				end
				break
			end
			if Ability:GetAbilityName() == "Primary_Eldwurm_soul_Lirrak" or Ability:GetAbilityName() == "Middle_Eldwurm_soul_Lirrak" or Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Lirrak"then
				self.type = 2
				print("激流的意志激活")
				if Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Lirrak" then
					self.level = Ability.advanced_level
				end
				break
			end
			if self.advanced_level >= 10 then
				if Ability:GetAbilityName() == "Primary_Eldwurm_soul_Slyrak" or Ability:GetAbilityName() == "Middle_Eldwurm_soul_Slyrak" or Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Slyrak"then
					self.type = 3
					print("赤焰的意志激活")
					if Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Slyrak" then
						self.level = Ability.advanced_level
					end
					break
				end
			end
			if self.advanced_level >= 20 then
				if Ability:GetAbilityName() == "Primary_Eldwurm_soul_Aethrak" or Ability:GetAbilityName() == "Middle_Eldwurm_soul_Aethrak" or Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Aethrak"then
					self.type = 4
					print("风暴的意志激活")
					if Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Aethrak" then
						self.level = Ability.advanced_level
					end
					break
				end
			end
		end
	end

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = 0
	local damage = 0
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 
	EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", caster)	

	local unit = caster:SummonUnit("npc_hd_healing_ward",life_duration,unit_pos,self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
	unit:AddNewModifier(caster, self, "modifier_Advanced_summon_healing_ward_buff", {type = self.type , level = self.level})
end

--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_buff = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_buff:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_buff:IsHidden() 		return true end
function modifier_Advanced_summon_healing_ward_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_buff:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_buff:GetEffectName() return "particles/rebuild/spell/healing_ward/healing_ward.vpcf" end


function modifier_Advanced_summon_healing_ward_buff:OnCreated(keys)
	if IsServer() then
        self.level = keys.level
		self.type = keys.type
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		--print(self.level)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Advanced_summon_healing_ward_buff:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability then
		return
	end
	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local caster = self:GetCaster()
	for _, unit in pairs(units) do
		if unit ~= self:GetParent() then
			local heal = ability:GetSpecialValueFor("heal") + ability:GetSpecialValueFor("hp_heal")*0.01 * unit:GetMaxHealth()
			local healing = HealWithGain(heal,caster,unit,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		end

			unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra",{duration = 1.6})
			if self.type == 1 then
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_earth",{duration = 1.6 , level = self.level})
			end
			if self.type == 2 then
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_water",{duration = 1.6 , level = self.level})
				--LV15激流的意志+
				if ability.advanced_level >= 10 then
					local heal = ability:GetSpecialValueFor("heal") + ability:GetSpecialValueFor("hp_heal")*0.01 * unit:GetMaxHealth()
					local mp =  heal*0.15
					unit:GiveMana(mp)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, mp, nil)
				end
			end
			--LV10赤焰的意志
			if self.type == 3 and ability.advanced_level >= 10 then
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_fire",{duration = 1.6 , level = self.level})
			end
			--LV20风暴的意志
			if self.type == 4 and ability.advanced_level >= 20 then
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_storm",{duration = 1.6 , level = self.level})
			end
			--奥义1
			if ability.unlock1 then
				self.level = 25
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_storm",{duration = 1.6 , level = self.level})
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_fire",{duration = 1.6 , level = self.level})
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_water",{duration = 1.6 , level = self.level})
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Advanced_summon_healing_ward_extra_earth",{duration = 1.6 , level = self.level})
				local heal = ability:GetSpecialValueFor("heal") + ability:GetSpecialValueFor("hp_heal")*0.01 * unit:GetMaxHealth()
				local mp =  heal*0.15
				unit:GiveMana(mp)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, mp, nil)
			end
		
	end

	--LV5大地的意志+
	if self.type == 1 and ability.advanced_level >= 5 or ability.unlock1 then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),	self:GetParent():GetAbsOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,	0,	false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster,self:GetAbility(),"modifier_stunned",{duration = 0.5})
		end
	end
	--LV20风暴的意志
	if self.type == 4 and ability.advanced_level >= 20 or ability.unlock1 then
		for _, unit in pairs(units) do
			for i=0, unit:GetAbilityCount() - 1 do  
				local Ability = unit:GetAbilityByIndex(i)
				if Ability and Ability:IsRefreshable() and not Ability:IsCooldownReady() then
					local newCooldown = math.max(Ability:GetCooldownTimeRemaining() - 0.45,0)
					Ability:EndCooldown()
					Ability:StartCooldown(newCooldown)
				end
			end
		end
	end
end

function modifier_Advanced_summon_healing_ward_buff:CheckState()
	return{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY  ] = true,
	}
end

--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_extra = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_extra:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_extra:IsHidden() 		return true end
function modifier_Advanced_summon_healing_ward_extra:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_extra:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_extra:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_res")
	self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
	if IsServer() then
		self:SetStackCount(self:GetAbility().advanced_level) 
	end
end
function modifier_Advanced_summon_healing_ward_extra:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
	}
end
function modifier_Advanced_summon_healing_ward_extra:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end
function modifier_Advanced_summon_healing_ward_extra:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_Advanced_summon_healing_ward_extra:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end
function modifier_Advanced_summon_healing_ward_extra:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.hp_regen
end

function modifier_Advanced_summon_healing_ward_extra:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	if self:GetStackCount() >= 10 then
		return 15
	end
	return 0
end
function modifier_Advanced_summon_healing_ward_extra:Advanced_GetModifierCooldownReduction()
	if self:GetStackCount() >= 20 then
		return 5
	end
	return 0
end
function modifier_Advanced_summon_healing_ward_extra:GetModifierAttackSpeedPercentage()
	if self:GetStackCount() >= 20 then
		return 10
	end
	return 0
end
--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_extra_earth = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_extra_earth:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_extra_earth:IsHidden() 		return false end
function modifier_Advanced_summon_healing_ward_extra_earth:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_extra_earth:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_extra_earth:GetTexture() return "soul_of_Uldorak" end
function modifier_Advanced_summon_healing_ward_extra_earth:OnCreated(keys)
	
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	if IsServer() then
		self.level = keys.level
		print(self.level)
		self:SetStackCount(self.level) 
	end
end
function modifier_Advanced_summon_healing_ward_extra_earth:OnRefresh(keys)
	
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	if IsServer() then
		self.level = keys.level
		self:SetStackCount(self.level) 
	end
end

function modifier_Advanced_summon_healing_ward_extra_earth:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Advanced_summon_healing_ward_extra_earth:Advanced_GetModifierIncomingDamage_Percentage()
	return -(self.incoming_down + (self:GetStackCount()*0.5))
end

--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_extra_water = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_extra_water:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_extra_water:IsHidden() 		return false end
function modifier_Advanced_summon_healing_ward_extra_water:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_extra_water:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_extra_water:GetTexture() return "soul_of_Lirrak" end
function modifier_Advanced_summon_healing_ward_extra_water:OnCreated(keys)
	
	self.heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
	if IsServer() then
		self.level = keys.level
		print(self.level)
		self:SetStackCount(self.level) 
	end
end
function modifier_Advanced_summon_healing_ward_extra_water:OnRefresh(keys)
	
	self.heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
	if IsServer() then
		self.level = keys.level
		self:SetStackCount(self.level) 
	end
end

function modifier_Advanced_summon_healing_ward_extra_water:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
	}
end
function modifier_Advanced_summon_healing_ward_extra_water:Advanced_GetModifierHealAMP_Percentage()
	return (self.heal_amp + (self:GetStackCount()*2))
end


--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_extra_fire = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_extra_fire:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_extra_fire:IsHidden() 		return false end
function modifier_Advanced_summon_healing_ward_extra_fire:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_extra_fire:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_extra_fire:GetTexture() return "sould_of_Slyrak" end
function modifier_Advanced_summon_healing_ward_extra_fire:OnCreated(keys)
	
	self.damage_up = 20
	if IsServer() then
		self.level = keys.level
		print(self.level)
		self:SetStackCount(self.level) 
	end
end
function modifier_Advanced_summon_healing_ward_extra_fire:OnRefresh(keys)
	
	self.damage_up = 20
	if IsServer() then
		self.level = keys.level
		self:SetStackCount(self.level) 
	end
end

function modifier_Advanced_summon_healing_ward_extra_fire:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Advanced_summon_healing_ward_extra_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return (self.damage_up + (self:GetStackCount()*0.5))
end
function modifier_Advanced_summon_healing_ward_extra_fire:Advanced_GetModifierIncomingDamage_Percentage()
	return 15
end


--------------------------------------------------------------

modifier_Advanced_summon_healing_ward_extra_storm = advanced_modifier({})

function modifier_Advanced_summon_healing_ward_extra_storm:IsDebuff()			return false end
function modifier_Advanced_summon_healing_ward_extra_storm:IsHidden() 		return false end
function modifier_Advanced_summon_healing_ward_extra_storm:IsPurgable() 		return false end
function modifier_Advanced_summon_healing_ward_extra_storm:IsPurgeException() return false end
function modifier_Advanced_summon_healing_ward_extra_storm:GetTexture() return "soul_of_Aethrak" end
function modifier_Advanced_summon_healing_ward_extra_storm:OnCreated(keys)
	
	if IsServer() then
		self.level = keys.level
		print(self.level)
		self:SetStackCount(self.level) 
	end
end
function modifier_Advanced_summon_healing_ward_extra_storm:OnRefresh(keys)

	if IsServer() then
		self.level = keys.level
		self:SetStackCount(self.level) 
	end
end

function modifier_Advanced_summon_healing_ward_extra_storm:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		
	}
end
function modifier_Advanced_summon_healing_ward_extra_storm:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
		
	}
end
function modifier_Advanced_summon_healing_ward_extra_storm:GetModifierAttackSpeedPercentage()
	return (self:GetStackCount())
end
function modifier_Advanced_summon_healing_ward_extra_storm:Advanced_GetModifierCooldownReduction()
	return (self:GetStackCount()*0.2)
end