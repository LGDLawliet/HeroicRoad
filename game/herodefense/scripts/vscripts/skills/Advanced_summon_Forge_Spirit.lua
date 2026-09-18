
LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_buff", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_buff_lv15", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_respawn", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_unlock2_debuff", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_big", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_summon_Forge_Spirit_unlock3", "skills/Advanced_summon_Forge_Spirit", LUA_MODIFIER_MOTION_NONE )
Advanced_summon_Forge_Spirit						= Advanced_summon_Forge_Spirit or class({})

require('internal/timers')   --计时器功能


function Advanced_summon_Forge_Spirit:IsSummonSpell()return true end
function Advanced_summon_Forge_Spirit:IsElementSummon()return true end

function Advanced_summon_Forge_Spirit:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_death.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_gold.vpcf", context )
	PrecacheResource( "model", "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl", context )
end

function Advanced_summon_Forge_Spirit:CheckKV(key)
	local table = {
		bonus_damage = 2,
		bonus_health = 1.3,


	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_Forge_Spirit:UnlockFirstCore(key)
	return true
end
function Advanced_summon_Forge_Spirit:UnlockSecondCore(key)
	return true
end
function Advanced_summon_Forge_Spirit:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_summon_Forge_Spirit_unlock3",{})
	
	return true
end

function Advanced_summon_Forge_Spirit:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end

	
	return self.BaseClass.GetBehavior(self)

end

function Advanced_summon_Forge_Spirit:Addstack(modifier)
	table.insert(self.summonList,modifier)
end

function Advanced_summon_Forge_Spirit:Spawn()
	self.summonList = {}
	self.unlock2_value = 0
end
function Advanced_summon_Forge_Spirit:Unlock2Damage(damage)
	self.unlock2_value =self.unlock2_value +damage
end
function Advanced_summon_Forge_Spirit:OnSpellStart()
	local caster =self:GetCaster()
	EmitSoundOn("Hero_Invoker.ColdSnap", self:GetCaster())	
	local life_duration = self:GetSpecialValueFor("duration") 
	local health = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	local summon_count = 2
	if self.advanced_level>=5 then
		summon_count=3
	end
	local respawn = 0
	if self.advanced_level>=20 then
		respawn = 1
		if self.unlock1 then
			respawn = respawn + 1
			for i=0, caster:GetAbilityCount() - 1 do
				local Ability = caster:GetAbilityByIndex(i)
				if Ability ~= nil and Ability.IsEldwurmSoulAbility then
					if Ability:IsEldwurmSoulAbility() then
						respawn = respawn + 1
					end
				end
			end
		end
	end
	
	for i = 0,summon_count-1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((summon_count- 1) / 2)))
		self:CreateSpirit(pos,health,armor,damage,life_duration,respawn,false)
		
	end	
	if self.unlock2 then
		local caster_health = caster:GetMaxHealth()*1.5
		if self.unlock2_value>=caster_health then
			self.unlock2_value = 0
			local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 400) + (self:GetCaster():GetRightVector() * 120 * (0 - ((summon_count- 1) / 2)))
			self:CreateSpirit(pos,health*3,armor*3,damage*3,life_duration,respawn,true)
		end
	end

	if #self.summonList>18 then
		local count =  #self.summonList-18
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
function Advanced_summon_Forge_Spirit:CreateSpirit(pos,health,armor,damage,life_duration,respawn,IsBig)
	local caster = self:GetCaster()
	local unit = caster:SummonUnit("npc_forge_spirit",life_duration,
	pos,
	self:GetCaster():GetForwardVector(),self,0,health,0,damage,armor,1,1)
	local particle_summon = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(particle_summon,0,unit:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle_summon)
	unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_buff", {})
	if self.advanced_level>=15 then
		if IsBig then
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_buff_lv15", {duration = 30})
		else
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_buff_lv15", {duration = 10})
		end
		
	end
	if respawn>=1 then
		if IsBig then
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_respawn", {respawn=respawn,health=health*1.1,armor=armor*1.1,damage=damage*1.1,life_duration=life_duration,big=1})
		else
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_respawn", {respawn=respawn,health=health*1.1,armor=armor*1.1,damage=damage*1.1,life_duration=life_duration,big=0})
		end
	
	end
	-- 解锁了奥义2 同时不是大型精灵时自燃
	if self.unlock2 and not IsBig then
		
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_unlock2_debuff", {})
	end
	if IsBig then
		unit:SetModelScale(2)
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Forge_Spirit_big", {})
	end
	EmitSoundOn("Hero_Invoker.ColdSnap",unit)	
end




modifier_Advanced_summon_Forge_Spirit_buff = class({})

function modifier_Advanced_summon_Forge_Spirit_buff:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_buff:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_buff:IsPurgeException() 	return false end
function modifier_Advanced_summon_Forge_Spirit_buff:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		ability:Addstack(self)
		if ability.advanced_level>=15 then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end

function modifier_Advanced_summon_Forge_Spirit_buff:OnDestroy()
	if IsServer() then

		

		local ability = self:GetAbility()
		if not ability then
			return
		end
		for key, value in pairs(ability.summonList) do
			if value==self then
				table.remove(ability.summonList,key)
				break
			end
		end
	

	end
end





modifier_Advanced_summon_Forge_Spirit_big = class({})

function modifier_Advanced_summon_Forge_Spirit_big:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_big:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_big:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_big:IsPurgeException() 	return false end

modifier_Advanced_summon_Forge_Spirit_buff_lv15 = advanced_modifier({})

function modifier_Advanced_summon_Forge_Spirit_buff_lv15:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:IsPurgeException() 	return false end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1000)
		self.count = 1000
		self:StartIntervalThink(0.033)
	end
end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:OnIntervalThink()
	local index = self.count * self:GetRemainingTime()/self:GetDuration()
	self:SetStackCount(index)
end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
	}
end


function modifier_Advanced_summon_Forge_Spirit_buff_lv15:Advanced_GetModifierAttackSpeedPercentage()	return self:GetStackCount()*0.1 end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount()*0.1 end
function modifier_Advanced_summon_Forge_Spirit_buff_lv15:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end



modifier_Advanced_summon_Forge_Spirit_respawn = class({})

function modifier_Advanced_summon_Forge_Spirit_respawn:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_respawn:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_respawn:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_respawn:IsPurgeException() 	return false end
function modifier_Advanced_summon_Forge_Spirit_respawn:OnCreated(keys)
	if IsServer() then
		self.respawn = keys.respawn
		self.health = keys.health
		self.armor = keys.armor
		self.damage = keys.damage
		self.life_duration = keys.life_duration*0.8
		if keys.big==1 then
			self.big = true
		else
			self.big = false
		end
	
		
	end
end
function modifier_Advanced_summon_Forge_Spirit_respawn:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability and self.respawn>=1 then
			local pos = self:GetParent():GetOrigin()+self:GetParent():GetForwardVector()*18
			local delay = 2
			if self.big then
				delay = 3
			end
			Timers:CreateTimer(delay, function()
				if not ability:IsNull() then
					ability:CreateSpirit(pos,self.health,self.armor,self.damage,self.life_duration,self.respawn-1,self.big)
					local particle_summon = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_death.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(particle_summon,0,pos)
					ParticleManager:ReleaseParticleIndex(particle_summon)
				end
				
			
			end)
		
		end
	end

end


modifier_Advanced_summon_Forge_Spirit_unlock2_debuff = class({})

function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:IsPurgeException() 	return false end
function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

function modifier_Advanced_summon_Forge_Spirit_unlock2_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local health = parent:GetHealth()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	
    parent:ModifyHealth(health*0.97,nil,false,0)
	ability:Unlock2Damage(health*0.03)
	
end








modifier_Advanced_summon_Forge_Spirit_unlock3= advanced_modifier({})

function modifier_Advanced_summon_Forge_Spirit_unlock3:IsDebuff()			return false end
function modifier_Advanced_summon_Forge_Spirit_unlock3:IsHidden() 			return true end
function modifier_Advanced_summon_Forge_Spirit_unlock3:IsPurgable() 		return false end
function modifier_Advanced_summon_Forge_Spirit_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_summon_Forge_Spirit_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_summon_Forge_Spirit_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local melting = unit:AddAbility("creeps_Melting_Strike")
		if melting then
			melting:SetLevel(1)
		end
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_summon_Forge_Spirit_buff_lv15", {duration = 10})
		unit:AddNewModifier(caster, ability, "modifier_Advanced_summon_Forge_Spirit_buff", {})
	end
end

function modifier_Advanced_summon_Forge_Spirit_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_Advanced_summon_Forge_Spirit_unlock3:Advanced_GetModifier_Summon_Intensity(keys)
	
	return 40
end
