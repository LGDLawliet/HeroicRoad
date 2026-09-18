
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_debuff", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_debuff2", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_buff", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_buff2", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_buff3", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_iAdvanced_summon_Dave_Chisnall_active", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_thinker", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_debuff4", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_Dave_Chisnall_debuff5", "skills/Advanced_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )





Advanced_summon_Dave_Chisnall						= Advanced_summon_Dave_Chisnall or class({})
function Advanced_summon_Dave_Chisnall:IsSummonSpell()return true end

function Advanced_summon_Dave_Chisnall:CheckKV(key)
	local table = {
		bonus_damage=2,
		bonus_armor=2,
		bonus_health=2,


	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_Dave_Chisnall:UnlockFirstCore(key)
	return true
end
function Advanced_summon_Dave_Chisnall:UnlockSecondCore(key)
	return true
end
function Advanced_summon_Dave_Chisnall:UnlockThirdCore(key)
	return true
end


function Advanced_summon_Dave_Chisnall:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_dave_chisnall/unlock1/effect_owner.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_dave_chisnall/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_dave_chisnall/unlock3/effect_fly.vpcf", context )


	PrecacheResource( "particle", "particles/rebuild/spell/chaos_meteor_move/invoker_chaos_meteor_crumble.vpcf", context )


	
end



function Advanced_summon_Dave_Chisnall:OnSpellStart()

	
	local caster =self:GetCaster()

	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", self:GetCaster())	
	

	
	local wolves_spawn_particle = nil
	self.summon_table = {}  --储存召唤物 用于在重复召唤时候移除它们

	local str = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetStrength() *0.01
	local agi = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetAgility()*0.01
	local int = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetIntellect(false)*0.01

	




	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = (self:GetSpecialValueFor("bonus_health"))*0.01 * caster:GetMaxHealth()
	local armor = (self:GetSpecialValueFor("bonus_armor"))*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = (self:GetSpecialValueFor("bonus_damage"))*0.01 * caster:GetBaseDamageMax()

	local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local index = 0.1
	local basic_index = 0.08
	--LV5解锁血肉献祭+
	if self.advanced_level>=5 then
		index = 0.2
		basic_index = basic_index*1.5
	end
	for _,unit in pairs(heros) do
		if unit~=caster then
			local str = unit:GetStrength() *index
		local agi = unit:GetAgility()*index
		local int = unit:GetIntellect(false)*index

		heal = heal+unit:GetMaxHealth()*index
		armor = armor +unit:GetPhysicalArmorValue(false)*index
		damage =damage + unit:GetBaseDamageMax()*index
	
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_debuff", 
		{duration = 20,str=str,agi=agi,int=int})

		local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf", PATTACH_ABSORIGIN, caster)
		local pos =caster:GetAbsOrigin()
		local pos2 = unit:GetAbsOrigin()
		pos.z = pos.z +64
		pos2.z = pos2.z +64
		
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)

		end
		
	end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local effect_name = "particles/rebuild/spell/summon_dave_chisnall/unlock2/effect.vpcf"
	local effect_count = 15
	if self.unlock2 then
		effect_name = "particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf"
		basic_index = 0.2
		effect_count =25
	end
	local count = 0
	for _,unit in pairs(units) do
	
		if unit:GetUnitName()~="npc_hd_Dave_Chisnall" then
			heal = heal+unit:GetMaxHealth()*basic_index
			damage =damage + unit:GetBaseDamageMax()*basic_index
			if self.unlock2 then
				TrueKill(caster, unit, self)
			else
				-- unit:SetHealth(unit:GetHealth()*0.5)
				unit:ModifyHealth(unit:GetHealth()*0.5,self,false,0)
			end
			
			local particle_cast_fx = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN, caster)
			local pos =caster:GetAbsOrigin()
			local pos2 = unit:GetAbsOrigin()
			pos.z = pos.z +64
			pos2.z = pos2.z +64
			
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			count = count + 1
			if count>=effect_count then
				break
			end
		end

		
	end
	
	
	local unit = caster:SummonUnit("npc_hd_Dave_Chisnall",life_duration,
	self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120  ),
	self:GetCaster():GetForwardVector(),
	self,0,heal,0,damage,armor,1,1)
	
	table.insert(self.summon_table,unit)
	
	-- Add spawn particles in spawn location
	wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)


	-- Add cast particles
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	local pos = self:GetCaster():GetAbsOrigin()
	local pos2 = unit:GetAbsOrigin()
	pos.z = pos.z +64
	pos2.z = pos2.z +64
	
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	--LV15解锁过度献祭
	if self.advanced_level>=15 then
		local index = math.min(caster:GetDisplayAttackSpeed()*0.5,200)

		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_buff2", {stack=index})
		caster:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_debuff2", {stack=index})
		--LV20解锁灵魂献祭
		if self.advanced_level>=20 then
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_buff3", {})
		end
	end
	unit:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_buff", {})
	caster:AddNewModifier(caster, self, "modifier_Advanced_summon_Dave_Chisnall_debuff", 
	{duration = self:GetSpecialValueFor("debuff_duration"),str=str,agi=agi,int=int})

end





modifier_Advanced_summon_Dave_Chisnall_debuff = class({})

function modifier_Advanced_summon_Dave_Chisnall_debuff:IsDebuff()			    return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff:IsHidden() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff:IsPurgable() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff:IsPurgeException() 	return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_summon_Dave_Chisnall_debuff:OnCreated(keys)
	if IsServer() then
		self.agi = keys.agi
		self.str = keys.str
		self.int = keys.int
	end
end

function modifier_Advanced_summon_Dave_Chisnall_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

 

function modifier_Advanced_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Agility() 
	if self.agi ~= 0 then
		return (-self.agi) 
	else
	return 0 end end
function modifier_Advanced_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Intellect() 
	if self.int ~= 0 then
		return (-self.int)
	else
	return 0 end end
function modifier_Advanced_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Strength() 
	if self.str ~= 0 then
		return (-self.str)
	else
	return 0 end end
	

















modifier_Advanced_summon_Dave_Chisnall_buff = class({})

function modifier_Advanced_summon_Dave_Chisnall_buff:IsDebuff() return false end
function modifier_Advanced_summon_Dave_Chisnall_buff:IsHidden() return true end
function modifier_Advanced_summon_Dave_Chisnall_buff:IsPurgable() return false end
function modifier_Advanced_summon_Dave_Chisnall_buff:OnCreated(keys)
	self.bonus_attack = 0
	if IsServer() then
		self:SetStackCount(self:GetCaster():GetPrimaryAttribute())
		self.time =  GameRules:GetGameTime()
		if self:GetAbility().unlock1 then
			local parent = self:GetParent()
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/summon_dave_chisnall/unlock1/effect_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, parent, PATTACH_POINT_FOLLOW, "attach_head", parent:GetAbsOrigin(), true )

			
			ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
			if self:GetStackCount()==0 then --力量
				ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(246,255,0) )
			elseif self:GetStackCount()==1 then --敏捷
				ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(255,38,0) )
			else --智力
				ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,255,255) )

			end
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end

		
		
	end
end

function modifier_Advanced_summon_Dave_Chisnall_buff:OnDestroy()
	if self.nFXIndex then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		self.nFXIndex = nil
	end
end


function modifier_Advanced_summon_Dave_Chisnall_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}
end

function modifier_Advanced_summon_Dave_Chisnall_buff:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.attacker == parent then
			local ability =self:GetAbility()
			if not ability then
				return
			end
			if self.bonus_attack==0 then
				self.bonus_attack = 1
				--LV10解锁过往的记忆+
				if ability.advanced_level>=10 then
					self.bonus_attack = 2
				end
				keys.attacker:AddNewModifier(keys.attacker, ability, "modifier_iAdvanced_summon_Dave_Chisnall_active", {duration = 3})
			else
				self.bonus_attack = self.bonus_attack-1
			end
			if ability.unlock1 then
				local damageTable = {
					victim = keys.target,
					attacker = parent,
					-- damage = damage,	
					ability = ability,
					-- damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				
				if self:GetStackCount()==0 then --力量
					damageTable.damage =parent:GetMaxHealth()*0.05
					damageTable.damage_type = DAMAGE_TYPE_PURE
				elseif self:GetStackCount()==1 then --敏捷
					damageTable.damage =parent:GetAverageTrueAttackDamage(nil)
					damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
				else --智力
					damageTable.damage =self:GetCaster():GetMaxMana()*0.1
					damageTable.damage_type = DAMAGE_TYPE_MAGICAL
				end
				ApplyDamage( damageTable )
				
			end
			local caster = self:GetCaster()
		
			if ability.unlock3  then
				local chance = 10
				if GameRules:GetGameTime()>=self.time then
					chance = 100
				end
		
				if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
					if not parent:IsApplyModifier() or parent:IsInSpecialAttack()  then
						return
					end
					self.time = GameRules:GetGameTime()+5
					CreateModifierThinker(
						parent, -- player source
						ability, -- ability source
						"modifier_Advanced_summon_Dave_Chisnall_thinker", -- modifier name
						{}, -- kv
						keys.target:GetAbsOrigin(),
						caster:GetTeamNumber(),
						false
					)
				end
		
			end
			
			

		end
	end
end



modifier_iAdvanced_summon_Dave_Chisnall_active = class({})

function modifier_iAdvanced_summon_Dave_Chisnall_active:IsDebuff() return false end
function modifier_iAdvanced_summon_Dave_Chisnall_active:IsHidden() return true end
function modifier_iAdvanced_summon_Dave_Chisnall_active:IsPurgable() return false end

function modifier_iAdvanced_summon_Dave_Chisnall_active:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
			MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}
end


function modifier_iAdvanced_summon_Dave_Chisnall_active:GetModifierAttackSpeedBonus_Constant()return 4000 end

function modifier_iAdvanced_summon_Dave_Chisnall_active:OnCreated(table)
	if IsServer() then

		--LV10解锁过往的记忆+
		if self:GetAbility().advanced_level>=10 then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end

		
	end
end

function modifier_iAdvanced_summon_Dave_Chisnall_active:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() then
			self:DecrementStackCount()
			if self:GetStackCount()==0 then
				self:SafeDestroy()
			end
		end
	end
end





modifier_Advanced_summon_Dave_Chisnall_debuff2 = class({})

function modifier_Advanced_summon_Dave_Chisnall_debuff2:IsDebuff()			    return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff2:IsHidden() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff2:IsPurgable() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff2:IsPurgeException() 	return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff2:RemoveOnDeath() return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Advanced_summon_Dave_Chisnall_debuff2:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

 

function modifier_Advanced_summon_Dave_Chisnall_debuff2:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount() end



modifier_Advanced_summon_Dave_Chisnall_buff2 = class({})

function modifier_Advanced_summon_Dave_Chisnall_buff2:IsDebuff()			    return false end
function modifier_Advanced_summon_Dave_Chisnall_buff2:IsHidden() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_buff2:IsPurgable() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_buff2:IsPurgeException() 	return false end

function modifier_Advanced_summon_Dave_Chisnall_buff2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_Advanced_summon_Dave_Chisnall_buff2:OnDestroy()
	if IsServer() then
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_summon_Dave_Chisnall_debuff2")
		if modifier then
			modifier:SafeDestroy()
		end
	end
end
function modifier_Advanced_summon_Dave_Chisnall_buff2:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

 

function modifier_Advanced_summon_Dave_Chisnall_buff2:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount() end













--决斗：每次攻击的第一个敌方单位，强制互相攻击直到有一方死亡，只受到0.01的其他来源的伤害。
modifier_Advanced_summon_Dave_Chisnall_buff3= class({})

function modifier_Advanced_summon_Dave_Chisnall_buff3:IsDebuff()			return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsHidden() 			return true end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsPurgable() 		return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsPurgeException() 	return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:DeclareFunctions() return 
	{
	MODIFIER_EVENT_ON_ATTACK_LANDED,

} end
--ON_ATTACK_LANDED触发后，攻击者和被攻击者互相攻击
function modifier_Advanced_summon_Dave_Chisnall_buff3:OnAttackLanded( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.target
		local Ability = params.inflictor
		local ability = self:GetAbility()
		if not ability then
			print("modifier_Advanced_summon_Dave_Chisnall_buff3:OnAttackLanded no ability")
			return
		end
		local caster = self:GetCaster()
		if not Attacker then
			--print("modifier_Advanced_summon_Dave_Chisnall_buff3:OnAttackLanded no Attacker")	
			return
		end
		if Attacker ~= self:GetParent() or Target == nil then
			--print("modifier_Advanced_summon_Dave_Chisnall_buff3:OnAttackLanded no Attacker")
			return
		end
		--血量大于20%不触发
		if Attacker:GetHealthPercent()>20 then
			return
		end
		
		Attacker:AddNewModifier(Attacker, ability, "modifier_Advanced_summon_Dave_Chisnall_debuff5", {duration = 3})
		--Target:AddNewModifier(Target, ability, "modifier_Advanced_summon_Dave_Chisnall_debuff5", {duration = 3})
		--让target攻击attacker，使用forceattack，SetForceAttackTarget
	

		
		Target:SetForceAttackTarget(Attacker)
		Target:MoveToTargetToAttack(Attacker)
		--Attacker:SetForceAttackTarget(Target)
		--Attacker:MoveToTargetToAttack(Target)


	end
end
--[[

modifier_Advanced_summon_Dave_Chisnall_buff3= class({})

function modifier_Advanced_summon_Dave_Chisnall_buff3:IsDebuff()			return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsHidden() 			return true end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsPurgable() 		return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:IsPurgeException() 	return false end
function modifier_Advanced_summon_Dave_Chisnall_buff3:DeclareFunctions() return 
	{
	MODIFIER_EVENT_ON_TAKEDAMAGE,

} end



function modifier_Advanced_summon_Dave_Chisnall_buff3:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local caster = self:GetCaster()
		if not Attacker then
			return
		end
		
		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if Attacker:GetHealthPercent()>50 then
			return
		end


		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		-- if self:GetParent():PassivesDisabled() then
		-- 	return
		-- end
		local flLifesteal = flDamage * 0.15
		if flLifesteal<=0 then
			return
		end
		local healing = HealWithGain(flLifesteal,caster,Attacker,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, Attacker, healing, nil)
		local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

	end

	return 0.0

end]]












modifier_Advanced_summon_Dave_Chisnall_thinker = class({})

function modifier_Advanced_summon_Dave_Chisnall_thinker:IsHidden()	return true end
function modifier_Advanced_summon_Dave_Chisnall_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.radius = 400
		
	


		self.fallen = false
		self.damageTable = {
			-- victim = target,
			damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*4,
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
		}
	
		self:StartIntervalThink( 1.3 )
		self:PlayEffects1()
	end
end



function modifier_Advanced_summon_Dave_Chisnall_thinker:OnDestroy( kv )
	if IsServer() then
		-- add vision
	
		-- stop effects
		-- local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		-- StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end


function modifier_Advanced_summon_Dave_Chisnall_thinker:OnIntervalThink()
	self:Burn()
end

function modifier_Advanced_summon_Dave_Chisnall_thinker:Burn()
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_summon_Dave_Chisnall_debuff4", {duration = 3})
	


	end
	self:PlayEffects2()
	self:SafeDestroy()
end



function modifier_Advanced_summon_Dave_Chisnall_thinker:PlayEffects1()
	if not self:GetCaster() then
		print("1")
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/summon_dave_chisnall/unlock3/effect_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"


	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1.3, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 60, 19, 249) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, self.radius*1.5/275, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_Advanced_summon_Dave_Chisnall_thinker:PlayEffects2()
	if not self:GetCaster() then
		return
	end
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor_move/invoker_chaos_meteor_crumble.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast,3, self.parent_origin )
	-- ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	-- ParticleManager:SetParticleControl( effect_cast, 1, self.direction )
	-- ParticleManager:SetParticleControl( effect_cast, 60, Vector( 60, 19, 249) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius/275, 0 ) )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	-- self:AddParticle(
	-- 	effect_cast,
	-- 	false,
	-- 	false,
	-- 	-1,
	-- 	false,
	-- 	false
	-- )
	-- ParticleManager:DestroyParticle(effect_cast,false)
end



modifier_Advanced_summon_Dave_Chisnall_debuff4 = advanced_modifier({})
function modifier_Advanced_summon_Dave_Chisnall_debuff4:IsDebuff()			return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff4:IsHidden() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff4:IsPurgable()         return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff4:IsPurgeException() 	return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff4:Advanced_GetModifierIncomingDamage_Percentage() return -90 end



function modifier_Advanced_summon_Dave_Chisnall_debuff4:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

modifier_Advanced_summon_Dave_Chisnall_debuff5 = advanced_modifier({})
function modifier_Advanced_summon_Dave_Chisnall_debuff5:IsDebuff()			return true end
function modifier_Advanced_summon_Dave_Chisnall_debuff5:IsHidden() 			return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff5:IsPurgable()         return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff5:IsPurgeException() 	return false end
function modifier_Advanced_summon_Dave_Chisnall_debuff5:Advanced_GetModifierIncomingDamage_Percentage()
	local hp_percent = self:GetParent():GetHealthPercent()
	--self.DmgReduction为最小80最大99的
	self.DmgReduction = math.max(80,99-hp_percent)*-1
	--print("当前减伤为",self.DmgReduction)
	return self.DmgReduction end



function modifier_Advanced_summon_Dave_Chisnall_debuff5:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
