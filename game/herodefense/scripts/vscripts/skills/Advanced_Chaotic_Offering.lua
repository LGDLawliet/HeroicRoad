require('internal/timers')   --计时器功能
--特效优化 √
LinkLuaModifier( "modifier_Chaotic_Offering_ambient", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient1", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient2", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient4", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient5", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient_model", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient_buff", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_ambient_buff_unlock3", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Chaotic_Offering_ambient", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_channeling", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_move_5", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_thinker", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_fire", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_20", "skills/Advanced_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )

Advanced_Chaotic_Offering = class({})
function Advanced_Chaotic_Offering:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Advanced_Chaotic_Offering:IsRefreshable() return false end
function Advanced_Chaotic_Offering:IsSummonSpell() return true end
function Advanced_Chaotic_Offering:GetChannelTime() return self:GetSpecialValueFor("channel_time") end

function Advanced_Chaotic_Offering:GetIntrinsicModifierName()
	return "modifier_Chaotic_Offering_move_5"
end

function Advanced_Chaotic_Offering:UnlockFirstCore(key)
	return false
end
function Advanced_Chaotic_Offering:UnlockSecondCore(key)
	return true
end
function Advanced_Chaotic_Offering:UnlockThirdCore(key)
	return true
end

function Advanced_Chaotic_Offering:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_offering/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_offering/unlock1/effect2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_offering/infernal_fx.vpcf", context )
end

function Advanced_Chaotic_Offering:CheckKV(key)
	local table = {
		bonus_health = 2.5,
		bonus_armor = 2.5,
		bonus_damage = 2,
		middle_damage = 0.04,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Chaotic_Offering:OnSpellStart()
	local caster =self:GetCaster()
	local position = self:GetCursorPosition()
	self.pos = position
	
	local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave_5.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particleID2,0,position)
	caster:AddNewModifier( caster, self, "modifier_Chaotic_Offering_channeling", {duration = self:GetSpecialValueFor("channel_time")-0.1})
end

function Advanced_Chaotic_Offering:OnChannelFinish()

	local ability = self
	local radius = self:GetSpecialValueFor("radius")
	local position = self.pos
	local caster = self:GetCaster()
	if not ability or ability:IsNull() then
		return
	end

	local channel_finish = caster:FindModifierByName("modifier_Chaotic_Offering_channeling")
	if channel_finish then
		self:EndCooldown()
		channel_finish:SafeDestroy()
		return
	end
	local modifier = caster:FindModifierByName("modifier_Chaotic_Offering_ambient_buff_unlock3")
	if modifier then
		modifier:Destroy()
	end

	--------------------------------------------------------------------
	local point = position
	if point==caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end

	CreateModifierThinker(
		caster,
		self,
		"modifier_Chaotic_Offering_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)
	caster:GameTimer(1.5,function ()
		
	
	-------------------------------------------------------------------
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal_pre = (self:GetSpecialValueFor("bonus_health")*0.01) * caster:GetMaxHealth() +1000
	local armor_pre =( self:GetSpecialValueFor("bonus_armor")*0.01 )*caster:GetPhysicalArmorValue(false) +20
	local damage_pre =( self:GetSpecialValueFor("bonus_damage")*0.01) * caster:GetBaseDamageMax() +150
	local count = 1
	if self.unlock2 then
		count = 3
	end
	--local first_unit
	for i = 1, count, 1 do
		local heal = heal_pre
		local damage = damage_pre
		local armor =armor_pre

		caster:GameTimer((i-1)*0.7, function()
			if not ability or ability:IsNull() then
				return
			end
			local loc = position
			if self.unlock2 then
				loc  = loc + Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
			end
			EmitSoundOnLocationWithCaster( loc, "Hero_Invoker.ChaosMeteor.Impact", caster )
			--local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave_5.vpcf",PATTACH_WORLDORIGIN,nil)--
			--ParticleManager:SetParticleControl(particleID2,0,loc)
			--caster:GameTimer(0.2, function()
				if not ability or ability:IsNull() then
					return
				end
				local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_finish_5.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, loc)
				ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, radius, radius))
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
		
				local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local stun_duration = self:GetSpecialValueFor("stun_duration")
				for i,unit in pairs(units) do
					unit:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration} )
				end
		
				local unit = caster:SummonUnit("npc_hd_Golem_5",life_duration,
				loc,
				self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
				--新LV20远古连接
				if self.advanced_level >= 20 then
					unit:AddNewModifier( caster, self, "modifier_Chaotic_Offering_20", {})
				end
				
				unit:AddNewModifier( caster, self, "modifier_Chaotic_Offering_ambient_model", { id = 5} )
				--if i==1 then
				--	first_unit = unit
				--else
				--	if first_unit and together then
				--		unit:EmitSound("Hero_DoomBringer.Devour")
				--		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_ABSORIGIN, first_unit)
				--		ParticleManager:SetParticleControl(particle_cast_fx, 1, first_unit:GetAbsOrigin())
				--		ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetAbsOrigin())
				--		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
				--		caster:GameTimer(0.5, function()
				--			local damage = unit:GetDamageMax()*0.5
				--			local health = unit:GetMaxHealth()*0.5
				--			local armor =unit:GetPhysicalArmorValue(false)*0.5
				--			first_unit:AddNewModifier( caster, self, "modifier_Chaotic_Offering_ambient_buff", { bonus_damage = damage,health=health,armor = armor} )
				--			unit:ForceKill(true)
							-- unit:Kill(nil,nil)
				--		end)	
				--	end
				--end

				if self.unlock3 then
					caster:GameTimer(0.5, function()
						if not unit or unit:IsNull() then
							return
						end
						local damage = unit:GetDamageMax()*0.4
						local health = unit:GetMaxHealth()*0.4
						print(health)
						local armor =unit:GetPhysicalArmorValue(false)*0.4
						caster:AddNewModifier( caster, self, "modifier_Chaotic_Offering_ambient_buff_unlock3", {duration = life_duration*caster:GetSummonTimeAmpIndex(1), bonus_damage = damage,health=health,armor = armor} )
						unit:ForceKill(true)
					end)
				end
			--end)
		end)
	end
	end)
end


-----------------------------------------------------------------------------------
modifier_Chaotic_Offering_ambient = class({})

function modifier_Chaotic_Offering_ambient:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient:IsHidden() return true end
function modifier_Chaotic_Offering_ambient:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient:OnCreated( kv )
	if IsServer() then	
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_offering/ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 10, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

modifier_Chaotic_Offering_ambient1 = class({})

function modifier_Chaotic_Offering_ambient1:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient1:IsHidden() return true end
function modifier_Chaotic_Offering_ambient1:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient1:GetEffectName() return "particles/models/items/warlock/ti10_puppet_summoner_golem/ti10_puppet_summoner_golem.vpcf" end
function modifier_Chaotic_Offering_ambient1:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


modifier_Chaotic_Offering_ambient2 = class({})

function modifier_Chaotic_Offering_ambient2:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient2:IsHidden() return true end
function modifier_Chaotic_Offering_ambient2:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient2:GetEffectName() return "particles/econ/items/warlock/warlock_ti9_cache_tribal/warlock_ti9_golem_ambient.vpcf" end
function modifier_Chaotic_Offering_ambient2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_Chaotic_Offering_ambient4 = class({})

function modifier_Chaotic_Offering_ambient4:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient4:IsHidden() return true end
function modifier_Chaotic_Offering_ambient4:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient4:GetEffectName() return "particles/rebuild/spell/chaotic_offering/unlock1/effect2.vpcf" end
function modifier_Chaotic_Offering_ambient4:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_Chaotic_Offering_ambient5 = class({})

function modifier_Chaotic_Offering_ambient5:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient5:IsHidden() return true end
function modifier_Chaotic_Offering_ambient5:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient5:OnCreated( kv )
	if IsServer() then	
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_offering/ambient_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self.nFXIndex2 = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_offering/infernal_fx.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex2, 0, self:GetParent(), PATTACH_CENTER_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 10, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end
---------------------------------------------------------------------------


modifier_Chaotic_Offering_ambient_model = class({})

function modifier_Chaotic_Offering_ambient_model:IsDebuff()			return false end
function modifier_Chaotic_Offering_ambient_model:IsHidden() 			return true end
function modifier_Chaotic_Offering_ambient_model:IsPurgable() 		    return false end
function modifier_Chaotic_Offering_ambient_model:IsPurgeException() 	return false end
function modifier_Chaotic_Offering_ambient_model:RemoveOnDeath() return false end
function modifier_Chaotic_Offering_ambient_model:OnCreated(keys)
    if not IsServer()  then
        return
    end
	local model = {
		"models/items/warlock/golem/doom_of_ithogoaki/doom_of_ithogoaki.vmdl",
		"models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl",
		"models/items/warlock/golem/ti9_cache_warlock_tribal_warlock_golem/ti9_cache_warlock_tribal_golem_alt.vmdl",
		"models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl",
		"models/items/tiny/burning_stone_giant/burning_stone_giant_03.vmdl",
		"models/items/warlock/golem/ti_8_warlock_darkness_apostate_golem/ti_8_warlock_darkness_apostate_golem.vmdl",
	}
	self.mode =model[keys.id]
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if keys.id==2 then
		parent:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient1", {} )
	elseif keys.id==3 then
		parent:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient2", {} )
	elseif keys.id==1 then
		parent:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient", {} )
	elseif keys.id==5 then
		parent:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient5", {} )
	elseif keys.id==4 then
		parent:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient4", {} )
		local ability = parent:AddAbility("creeps_spell_chasotic_fallen")
		if ability then
			ability:SetLevel(1)
		end
	end
end

function modifier_Chaotic_Offering_ambient_model:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function modifier_Chaotic_Offering_ambient_model:GetModifierModelChange()
	if self.mode ~= nil then
		return self.mode
	end
end
---------------------------------------------------------------------------


modifier_Chaotic_Offering_ambient_buff = class({})

function modifier_Chaotic_Offering_ambient_buff:IsDebuff()			return false end
function modifier_Chaotic_Offering_ambient_buff:IsHidden() 			return true end
function modifier_Chaotic_Offering_ambient_buff:IsPurgable() 		    return false end
function modifier_Chaotic_Offering_ambient_buff:IsPurgeException() 	return false end
function modifier_Chaotic_Offering_ambient_buff:RemoveOnDeath() return false end
function modifier_Chaotic_Offering_ambient_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Chaotic_Offering_ambient_buff:OnCreated(keys)
    if not IsServer()  then
        return
    end
	self:SetStackCount(keys.bonus_damage)
	print(keys.bonus_damage)
	-- self.bonus_health = keys.health
	-- self.bonus_armor = keys.armor
	IncreaseHealth(self:GetParent(), keys.health)
	IncreaseArmor(self:GetParent(), keys.armor)
	-- IncreaseDamage(self:GetParent(), keys.damage)
end
function modifier_Chaotic_Offering_ambient_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_Chaotic_Offering_ambient_buff:GetModifierBaseAttack_BonusDamage() return self:GetStackCount() end

---------------------------------------------------------------------------

modifier_Chaotic_Offering_ambient_buff_unlock3 = advanced_modifier({})

function modifier_Chaotic_Offering_ambient_buff_unlock3:IsDebuff()			return false end
function modifier_Chaotic_Offering_ambient_buff_unlock3:IsHidden() 			return false end
function modifier_Chaotic_Offering_ambient_buff_unlock3:IsPurgable() 		    return false end
function modifier_Chaotic_Offering_ambient_buff_unlock3:IsPurgeException() 	return false end
function modifier_Chaotic_Offering_ambient_buff_unlock3:RemoveOnDeath() return true end
function modifier_Chaotic_Offering_ambient_buff_unlock3:OnCreated(keys)
    if not IsServer()  then
        return
    end
	--local model = {
	--	"models/items/warlock/golem/doom_of_ithogoaki/doom_of_ithogoaki.vmdl",
	--	"models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl",
	--	"models/items/warlock/golem/ti9_cache_warlock_tribal_warlock_golem/ti9_cache_warlock_tribal_golem_alt.vmdl",
	--	"models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl",
	--}
	--self.mode =model[keys.id]
	self:SetStackCount(keys.bonus_damage)
	self.bonus_health = keys.health
	self.bonus_armor =  keys.armor
end

function modifier_Chaotic_Offering_ambient_buff_unlock3:OnRefresh(keys)
    if not IsServer()  then
        return
    end
	self:SetStackCount(self:GetStackCount()+ keys.bonus_damage)
	self.bonus_health = self.bonus_health+keys.health
	self.bonus_armor =self.bonus_armor+  keys.armor

end
function modifier_Chaotic_Offering_ambient_buff_unlock3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_Chaotic_Offering_ambient_buff_unlock3:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end
function modifier_Chaotic_Offering_ambient_buff_unlock3:GetModifierHealthBonus() return self.bonus_health end

function modifier_Chaotic_Offering_ambient_buff_unlock3:GetModifierModelChange()
	return "models/items/tiny/burning_stone_giant/burning_stone_giant_03.vmdl"
end

function modifier_Chaotic_Offering_ambient_buff_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Chaotic_Offering_ambient_buff_unlock3:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

----------------------------------
modifier_Chaotic_Offering_channeling = advanced_modifier({})

function modifier_Chaotic_Offering_channeling:IsDebuff() return false end
function modifier_Chaotic_Offering_channeling:IsHidden() return true end
function modifier_Chaotic_Offering_channeling:IsPurgable() return false end
function modifier_Chaotic_Offering_channeling:OnCreated(keys)
	if IsServer() then
		self.pos = self:GetAbility():GetCursorPosition()
		self:StartIntervalThink(1)
	end
end
function modifier_Chaotic_Offering_channeling:OnIntervalThink()
	local position = self.pos
	local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave_5.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particleID2,0,position)
end

----------------------------------
modifier_Chaotic_Offering_move_5 = advanced_modifier({})

function modifier_Chaotic_Offering_move_5:IsDebuff() return false end
function modifier_Chaotic_Offering_move_5:IsHidden() return false end
function modifier_Chaotic_Offering_move_5:IsPurgable() return false end

function modifier_Chaotic_Offering_move_5:Fireblast()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	self.middle_radius = self:GetAbility():GetSpecialValueFor("middle_radius")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")
	--print("开始找")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	--print("找单位中")
	for _,unit in pairs(units) do
		--print("找到了单位")
		local modifier = unit:FindModifierByNameAndCaster("modifier_Chaotic_Offering_ambient5",caster)
		if modifier then
		--print("找到了地狱火")
			local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave_5.vpcf",PATTACH_WORLDORIGIN,nil)
			ParticleManager:SetParticleControl(particleID2,0,unit:GetAbsOrigin())
		
			local damage = unit:GetAverageTrueAttackDamage(nil)*self.middle_damage
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), unit:GetAbsOrigin(), nil, self.middle_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				if enemy ~= nil then
               	 local damageTable= {
                 	victim = enemy,
                   	attacker = unit,
                    damage = damage,
                   	damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags =DOTA_DAMAGE_FLAG_NONE, 
                    ability = self:GetAbility(),
                   	hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
                	}
	    	   		enemy:ApplyMergeDamage(damageTable)
				end
			end
			--新LV5烈焰爆发+
			if self:GetAbility().advanced_level >= 5 then
				local rain = unit:FindAbilityByName("creeps_spell_Golem_rain_5")
				if rain and not rain:IsCooldownReady() then
					rain:EndCooldown()
				end
			end
			--新LV10毁灭献祭
			if self:GetAbility().advanced_level >= 10 then
				local fire = unit:FindAbilityByName("creeps_spell_Golem_5")
				if fire then
					unit:AddNewModifier(caster, self:GetAbility(), "modifier_Chaotic_Offering_fire", {duration = 5})
				end
			end
			
			--新LV20远古链接
			if self:GetAbility().advanced_level >= 20 then
				unit:Purge(false, true, false, false, true) --强驱散
				caster:Purge(false, true, false, false, true) --强驱散
			end

		end
	end
	--新LV15混乱之雨
	if self:GetAbility().advanced_level >= 15 then
		self:SetStackCount(math.min(self:GetStackCount() + 1,7))
		if self:GetStackCount() >= 7 then
			local ability = self:GetAbility()
			local radius = self:GetAbility():GetSpecialValueFor("radius")
			local position = caster:GetAbsOrigin()
			local caster = self:GetCaster()
			if not ability or ability:IsNull() then
				return
			end
			--------------------------------------------------------------------
			local point = position
			if point==caster:GetAbsOrigin() then
				point = point + caster:GetForwardVector()
			end
		
			CreateModifierThinker(
				caster,
				self:GetAbility(),
				"modifier_Chaotic_Offering_thinker",
				{},
				point,
				caster:GetTeamNumber(),
				false
			)
			self:SetStackCount(0)
			
			caster:GameTimer(1.5,function ()
			-------------------------------------------------------------------
				local life_duration = self:GetAbility():GetSpecialValueFor("duration")*0.4
				local heal_pre = (self:GetAbility():GetSpecialValueFor("bonus_health")*0.01) * caster:GetMaxHealth() +1000
				local armor_pre =( self:GetAbility():GetSpecialValueFor("bonus_armor")*0.01 )*caster:GetPhysicalArmorValue(false) +20
				local damage_pre =( self:GetAbility():GetSpecialValueFor("bonus_damage")*0.01) * caster:GetBaseDamageMax() +150

				local heal = heal_pre*0.4
				local damage = damage_pre*0.4
				local armor =armor_pre*0.4
		
				caster:GameTimer(0.1, function()
					if not ability or ability:IsNull() then
						return
					end
					local loc = position +  Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)

					EmitSoundOnLocationWithCaster( loc, "Hero_Invoker.ChaosMeteor.Impact", caster )
						if not ability or ability:IsNull() then
							return
						end
						local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_finish_5.vpcf", PATTACH_ABSORIGIN, caster)
						ParticleManager:SetParticleControl(particle_main_fx, 0, loc)
						ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, radius, radius))
						ParticleManager:ReleaseParticleIndex(particle_main_fx)
				
						local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
						local stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
						for i,unit in pairs(units) do
							unit:AddNewModifier( caster, self:GetAbility(), "modifier_stunned", { duration = stun_duration} )
						end
				
						local unit = caster:SummonUnit("npc_hd_Golem_5",life_duration,
						loc,
						self:GetCaster():GetForwardVector(),self:GetAbility(),0,heal,0,damage,armor,1,1)
						unit:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient_model", { id = 5} )
						--新LV20远古连接
						if self:GetAbility().advanced_level >= 20 then
							unit:AddNewModifier( caster, self, "modifier_Chaotic_Offering_20", {})
						end
						if self.unlock3 then
							caster:GameTimer(0.5, function()
								if not unit or unit:IsNull() then
									return
								end
								local damage = unit:GetDamageMax()*0.4
								local health = unit:GetMaxHealth()*0.4
								--print(health)
								local armor =unit:GetPhysicalArmorValue(false)*0.4
								caster:AddNewModifier( caster, self:GetAbility(), "modifier_Chaotic_Offering_ambient_buff_unlock3", {duration = life_duration*caster:GetSummonTimeAmpIndex(1), bonus_damage = damage,health=health,armor = armor} )
								unit:ForceKill(true)
							end)
						end
					
				end)
			end)
		end
	end
end
----------------------------------
modifier_Chaotic_Offering_thinker = advanced_modifier({})

function modifier_Chaotic_Offering_thinker:IsHidden()	return true end


function modifier_Chaotic_Offering_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		self.radius = ability:GetSpecialValueFor("radius")
		self.distance = ability:GetSpecialValueFor("distance")
		self.speed = 200	
		self.interval = 0.3
		self.fallen = false
		self.effect_unit = {}
		--self:StartIntervalThink( self.delay )
		self:PlayEffects1()
	end
end

function modifier_Chaotic_Offering_thinker:OnDestroy( kv )
	if IsServer() then

		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end

function modifier_Chaotic_Offering_thinker:PlayEffects1()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaotic_offering/summon_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self:GetAbility():GetSpecialValueFor("radius")*1.5/275, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

----------------------------------
modifier_Chaotic_Offering_fire = advanced_modifier({})

function modifier_Chaotic_Offering_fire:IsDebuff() return false end
function modifier_Chaotic_Offering_fire:IsHidden() return false end
function modifier_Chaotic_Offering_fire:IsPurgable() return false end

----------------------------------
modifier_Chaotic_Offering_20 = advanced_modifier({})

function modifier_Chaotic_Offering_20:IsDebuff() return false end
function modifier_Chaotic_Offering_20:IsHidden() return true end
function modifier_Chaotic_Offering_20:IsPurgable() return false end
function modifier_Chaotic_Offering_20:CheckState()
	return{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end