
--特效优化 √
Advanced_Demonic_Conversion = class({})

LinkLuaModifier("modifier_Advanced_Demonic_Conversion_attack_count", "skills/Advanced_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Demonic_Conversion_buff", "skills/Advanced_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Demonic_Conversion_debuff", "skills/Advanced_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Demonic_Conversion_thinker", "skills/Advanced_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Demonic_Conversion_thinker_motion", "skills/Advanced_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)





function Advanced_Demonic_Conversion:CheckKV(key)
	local table = {

		bonus_attribute_percentage = 0.5,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Demonic_Conversion:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
function Advanced_Demonic_Conversion:UnlockSecondCore(key)
		-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock2",{})
	return true
end
function Advanced_Demonic_Conversion:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
function Advanced_Demonic_Conversion:Spawn()
	self.summonList = {}
	self.unlock1List = {}
end
function Advanced_Demonic_Conversion:Addstack(modifier)
	table.insert(self.summonList,modifier)
	-- self.summonList[modifier] = modifier
end
function Advanced_Demonic_Conversion:IsSummonSpell()return true end

function Advanced_Demonic_Conversion:AddUnlock1Stack(modifier)
	table.insert(self.unlock1List,modifier)
end
-- function Advanced_Demonic_Conversion:RemoveUnlock1FirstStack()
-- 	table.remove(self.unlock1List,1)
-- end
function Advanced_Demonic_Conversion:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/demonic_conversion/unlock.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_streak_start.vpcf", context )
	PrecacheResource( "model", "models/items/enigma/eidolon/life_cycle_life_cycle_eidolons/life_cycle_life_cycle_eidolons.vmdl", context )

	
end
function Advanced_Demonic_Conversion:OnTriggerUnlock2(pos)
	if self.unlock2 then
		local ability = self:GetCaster():FindAbilityByName("Advanced_Midnight_Pulse")
		if ability then
			ability:Demonic_Conversion_Trigger(pos)
		end
	end
end

function Advanced_Demonic_Conversion:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
	end


	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	
end

function Advanced_Demonic_Conversion:IsHiddenWhenStolen() 	return false end
function Advanced_Demonic_Conversion:IsRefreshable() 		return false  end
function Advanced_Demonic_Conversion:IsStealable() 			return true  end
function Advanced_Demonic_Conversion:IsNetherWardStealable() return false end

function Advanced_Demonic_Conversion:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not target:IsHero() then
		return
	end

	local life_duration = self:GetSpecialValueFor("duration")
	local heal = (self:GetSpecialValueFor("basic_heal") + (self:GetSpecialValueFor("bonus_attribute_percentage"))*0.01 * target:GetMaxHealth())
	local armor = ((self:GetSpecialValueFor("bonus_attribute_percentage"))*0.01 * target:GetPhysicalArmorValue(false))
	local damage = (self:GetSpecialValueFor("basic_damage") +(self:GetSpecialValueFor("bonus_attribute_percentage"))*0.01 * target:GetBaseDamageMax())
	local mana = ((self:GetSpecialValueFor("bonus_attribute_percentage"))*0.01 * target:GetMaxMana())
	if self.unlock3 then
		life_duration = life_duration *2
		heal = heal *2
		armor = armor * 2
		damage = damage * 2
	end
	target:EmitSound("Hero_Enigma.Demonic_Conversion")
	local str = self:GetSpecialValueFor("allied_attribute_loss") * target:GetStrength() *0.01
	local agi = self:GetSpecialValueFor("allied_attribute_loss") * target:GetAgility()*0.01
	local int = self:GetSpecialValueFor("allied_attribute_loss") * target:GetIntellect(false)*0.01

	target:AddNewModifier(caster, self, "modifier_Advanced_Demonic_Conversion_debuff", 
	{duration = self:GetSpecialValueFor("allied_recovery_time"),str=str,agi=agi,int=int})
	for i=1,self:GetSpecialValueFor("summon_number") do
	
		local unit = caster:SummonUnit("npc_eidolon",life_duration,target:GetAbsOrigin(),nil,self,0,heal,mana,damage,armor,0.5,0.5)
		if not self.unlock3 then
			unit:AddNewModifier(caster, self, "modifier_Advanced_Demonic_Conversion_attack_count",
			{duration=life_duration* caster:GetSummonTimeAmpIndex(1),damage = damage,heal = heal, armor = armor, mana = mana})
		end

		unit:AddNewModifier(caster, self, "modifier_Advanced_Demonic_Conversion_buff", {duration=life_duration* caster:GetSummonTimeAmpIndex(1)})

	end

	if #self.summonList>20 then
		local count =  #self.summonList-20
		for i = 1, count, 1 do
			local modifier = self.summonList[1]
			if not modifier:IsNull() then
				-- modifier:GetParent():Kill(self,nil)
				TrueKill(nil, modifier:GetParent(), self)
			end
			-- self:RemoveFirstStack()
		end
		
	end

end

modifier_Advanced_Demonic_Conversion_attack_count = class({})

function modifier_Advanced_Demonic_Conversion_attack_count:IsDebuff()			return false end
function modifier_Advanced_Demonic_Conversion_attack_count:IsHidden() 			return true end
function modifier_Advanced_Demonic_Conversion_attack_count:IsPurgable() 		return false end
function modifier_Advanced_Demonic_Conversion_attack_count:IsPurgeException() 	return false end

function modifier_Advanced_Demonic_Conversion_attack_count:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK} end

function modifier_Advanced_Demonic_Conversion_attack_count:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if IsServer() then
		local index =1 
		--LV5解锁分则能成++
		if self.advanced_level>=5 then
			index = 1.3
		end
		self.damage = keys.damage*index
		self.armor = keys.armor*index
		self.mana = keys.mana*index
		self.heal = keys.heal*index

		self.chance = self:GetAbility():GetSpecialValueFor("split_chance")
		--LV20解锁分则能成++
		if self.advanced_level>=20 then
			self.chance = self.chance+1
		end
	end

end

function modifier_Advanced_Demonic_Conversion_attack_count:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	self:IncrementStackCount()

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	if self:GetStackCount() % ability:GetSpecialValueFor("attacks_to_split") == 0 then
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		
		local time = ability:GetSpecialValueFor("child_duration") + self:GetRemainingTime()
		local unit = caster:SummonUnit("npc_eidolon",time,keys.attacker:GetAbsOrigin(),nil,ability,0,self.heal,self.mana,self.damage,self.armor,1,1)
		local pos = self:GetParent():GetOrigin()
		ability:OnTriggerUnlock2(pos)
		-- unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ability:GetSpecialValueFor("child_duration") + self:GetRemainingTime()})
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Demonic_Conversion_buff", {})

		
		if self:GetStackCount() >= ability:GetSpecialValueFor("attacks_to_split")*self.chance then
			self:SafeDestroy()
		end
	end
end

modifier_Advanced_Demonic_Conversion_buff = class({})

function modifier_Advanced_Demonic_Conversion_buff:IsDebuff()			return false end
function modifier_Advanced_Demonic_Conversion_buff:IsHidden() 			return false end
function modifier_Advanced_Demonic_Conversion_buff:IsPurgable() 			return false end
function modifier_Advanced_Demonic_Conversion_buff:IsPurgeException() 	return false end

function modifier_Advanced_Demonic_Conversion_buff:OnCreated()
	local ability = self:GetAbility()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	self.demon_attribute_gain = ability:GetSpecialValueFor("demon_attribute_gain")
	if IsServer() then
		ability:Addstack(self)
		local rate = 1
		--LV10解锁太初之能+
		if self.advanced_level>=10 then
			rate = 0.7
		end
		if ability.unlock3 then
			rate = rate * 0.5
		end
		self:StartIntervalThink(rate)


		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),ability:GetAbilityName())
		if type=="ability_particle_8" then
			self.model = "models/items/enigma/eidolon/life_cycle_life_cycle_eidolons/life_cycle_life_cycle_eidolons.vmdl"
		end
		

	end
end


function modifier_Advanced_Demonic_Conversion_buff:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Demonic_Conversion_buff:DeclareFunctions()

	if IsServer() then
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_8" then
			return  {
				MODIFIER_PROPERTY_MODEL_CHANGE,
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
				MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
				MODIFIER_EVENT_ON_TAKEDAMAGE,
		
			}
		end
	end
	return 
	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	 MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	 MODIFIER_EVENT_ON_TAKEDAMAGE
	}

end

 

function modifier_Advanced_Demonic_Conversion_buff:GetModifierMoveSpeedBonus_Percentage() return (self.demon_attribute_gain * self:GetStackCount()) end
function modifier_Advanced_Demonic_Conversion_buff:GetModifierDamageOutgoing_Percentage() return (self.demon_attribute_gain * self:GetStackCount()) end
function modifier_Advanced_Demonic_Conversion_buff:GetModifierModelChange()
	if IsServer() then
		return self.model
	end
	-- return "models/items/warlock/golem/warlock_the_infernal_master_golem/warlock_the_infernal_master_golem.vmdl"
end


	
function modifier_Advanced_Demonic_Conversion_buff:OnTakeDamage( params )
	
	if IsServer() then
		--LV15解锁能量汲取
		if self.advanced_level<15 then
			return
		end
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local caster = self:GetCaster()
		if caster:GetHealthPercent()>=100 then
			return
		end

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end


		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local gain = caster:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * 0.1*gain
		caster:Heal( flLifesteal, self:GetAbility() )

	end

	return 0.0

end


function modifier_Advanced_Demonic_Conversion_buff:OnDestroy()
	if IsServer() then

		

		local ability = self:GetAbility()
		if not ability then
			return
		end
		local pos = self:GetParent():GetOrigin()
		ability:OnTriggerUnlock2(pos)
		for key, value in pairs(ability.summonList) do
			if value==self then
				-- print(key)
				-- print(value)
				table.remove(ability.summonList,key)
				break
			end
		end
	
		
		if ability.unlock1 and ability:GetAutoCastState() then
			if #ability.unlock1List>6 then
				local count =  #ability.unlock1List-6
				for i = 1, count, 1 do
					local modifier = ability.unlock1List[1]
					if modifier and not modifier:IsNull() then
			
						local target = modifier:GetParent()
						if not target:IsNull() then
							TrueKill(nil, target, ability)
						end
					
					end
					-- ability:RemoveUnlock1FirstStack()
				end
				
			end
			local caster = self:GetCaster()
			local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_Demonic_Conversion_thinker", {},pos, caster:GetTeamNumber(), false)
			ability:AddUnlock1Stack(thinker:FindModifierByName("modifier_Advanced_Demonic_Conversion_thinker"))
			-- thinker:AddNewModifier(caster, self, "modifier_Advanced_Demonic_Conversion_damage", {duration =duration})
		end
	end
end


modifier_Advanced_Demonic_Conversion_debuff = class({})

function modifier_Advanced_Demonic_Conversion_debuff:IsDebuff()			    return true end
function modifier_Advanced_Demonic_Conversion_debuff:IsHidden() 			return false end
function modifier_Advanced_Demonic_Conversion_debuff:IsPurgable() 			return false end
function modifier_Advanced_Demonic_Conversion_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Demonic_Conversion_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Demonic_Conversion_debuff:OnCreated(keys)

	if IsServer() then

		self.agi = keys.agi
		self.str = keys.str
		self.int = keys.int

	end
end

function modifier_Advanced_Demonic_Conversion_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

 

function modifier_Advanced_Demonic_Conversion_debuff:GetModifierBonusStats_Agility() 
	if self.agi ~= 0 then
		return (-self.agi) 
	else
	return 0 end end
function modifier_Advanced_Demonic_Conversion_debuff:GetModifierBonusStats_Intellect() 
	if self.int ~= 0 then
		return (-self.int)
	else
	return 0 end end
function modifier_Advanced_Demonic_Conversion_debuff:GetModifierBonusStats_Strength() 
	if self.str ~= 0 then
		return (-self.str)
	else
	return 0 end 
end
	








modifier_Advanced_Demonic_Conversion_thinker = class({})

function modifier_Advanced_Demonic_Conversion_thinker:IsDebuff()			return true end
function modifier_Advanced_Demonic_Conversion_thinker:IsHidden() 			return true end
function modifier_Advanced_Demonic_Conversion_thinker:IsPurgable() 		return false end
function modifier_Advanced_Demonic_Conversion_thinker:IsPurgeException() 	return false end
function modifier_Advanced_Demonic_Conversion_thinker:OnCreated(keys)
	if IsServer() then
		-- EmitSoundOn( "Hero_Enigma.Black_Hole", self:GetParent() )
		-- EmitSoundOn( "gravity.Black_Hole", self:GetParent() )
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/demonic_conversion/unlock.vpcf", PATTACH_CUSTOMORIGIN, nil)
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = pos.z +128

		ParticleManager:SetParticleControl(self.particle, 0, pos)
		ParticleManager:SetParticleControl(self.particle, 4, pos)
		ParticleManager:SetParticleControl(self.particle, 61, Vector(20,0,0))
		self:GetParent():SetAbsOrigin(pos)
		self:AddParticle(self.particle, false, false, 15, false, false)
		self.damage_index = 1

		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Demonic_Conversion_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end


	local parent = self:GetParent()
	local caster = self:GetCaster()
	local pos = parent:GetOrigin()
	if not parent:HasModifier("modifier_Advanced_Demonic_Conversion_thinker_motion") then
		local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", pos, 600)
		for _, unit in ipairs(thinkers) do
			if unit~=parent then
				local modifier = unit:FindModifierByName("modifier_Advanced_Demonic_Conversion_thinker")
				if modifier then
					if not unit:HasModifier("modifier_Advanced_Demonic_Conversion_thinker_motion") then
						--看谁比较大
						if self.damage_index>=modifier.damage_index then
							unit:AddNewModifier(caster, ability, "modifier_Advanced_Demonic_Conversion_thinker_motion", {target = parent:entindex(),fuse = 0})
							parent:AddNewModifier(caster, ability, "modifier_Advanced_Demonic_Conversion_thinker_motion", {target = unit:entindex(),fuse = 1})
						else
							unit:AddNewModifier(caster, ability, "modifier_Advanced_Demonic_Conversion_thinker_motion", {target = parent:entindex(),fuse = 1})
							parent:AddNewModifier(caster, ability, "modifier_Advanced_Demonic_Conversion_thinker_motion", {target = unit:entindex(),fuse = 0})
						end
					
						break
					end
				end
	
			end
		end
	end


	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 400,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = caster:GetIntellect(false)*2*self.damage_index,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability, --Optional.
	}
	-- ApplyDamage(damageTable)
	for _, unit in pairs(enemies) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
	end
end

function modifier_Advanced_Demonic_Conversion_thinker:OnDestroy(keys)
	if IsServer() then
		local ability = self:GetAbility()
		for key, value in pairs(ability.unlock1List) do
			if value==self then
				-- print(key)
				-- print(value)
				table.remove(ability.unlock1List,key)
				break
			end
		end
		-- local thinker = self:GetParent()
		-- self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		-- self:GetParent():StopSound("gravity.Black_Hole")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)

		UTIL_Remove(self:GetParent())
		
	end
end
function modifier_Advanced_Demonic_Conversion_thinker:PowerUp()
	self.damage_index = math.min(self.damage_index+0.3,5)
	ParticleManager:SetParticleControl(self.particle, 61, Vector(self.damage_index*20,0,0))
end

modifier_Advanced_Demonic_Conversion_thinker_motion = class({})

function modifier_Advanced_Demonic_Conversion_thinker_motion:IsDebuff()			return true end
function modifier_Advanced_Demonic_Conversion_thinker_motion:IsHidden() 			return true end
function modifier_Advanced_Demonic_Conversion_thinker_motion:IsPurgable() 		return true end
function modifier_Advanced_Demonic_Conversion_thinker_motion:IsPurgeException() 	return true end
function modifier_Advanced_Demonic_Conversion_thinker_motion:OnCreated(keys)
	if IsServer() then
		self.current_unit = EntIndexToHScript(keys.target)
		local target_pos = self.current_unit:GetOrigin()
		local now_pos = self:GetParent():GetOrigin()
		self.dir = ( target_pos-now_pos):Normalized()
		self.particle = self:GetParent():FindModifierByName("modifier_Advanced_Demonic_Conversion_thinker").particle
		self.fuse = false
		if keys.fuse ==1 then
			self.fuse = true
		end
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_Advanced_Demonic_Conversion_thinker_motion:OnIntervalThink()
	if self.current_unit:IsNull() or not self.current_unit:IsAlive() then
		self:SafeDestroy()
		return
	end
	local parent = self:GetParent()
	local pos = parent:GetOrigin()
	pos = pos +self.dir*100*FrameTime()
	if self.particle then
		ParticleManager:SetParticleControl(self.particle, 0, pos)
		ParticleManager:SetParticleControl(self.particle, 4, pos)
	end
	self:GetParent():SetAbsOrigin(pos)
	if self.fuse then
		local dis = CalculateDistance(parent,self.current_unit)
		if dis<=20 then
			parent:EmitSound("Hero_Enigma.Black_Hole.Stop")
			local particle = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_streak_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle, 0, pos)
			ParticleManager:ReleaseParticleIndex(particle)



			local self_modifier = parent:FindModifierByName("modifier_Advanced_Demonic_Conversion_thinker")
			self_modifier:PowerUp()
			local target_modifier = self.current_unit:FindModifierByName("modifier_Advanced_Demonic_Conversion_thinker")
			target_modifier:SafeDestroy()
			self:SafeDestroy()
		end
	end
	
end