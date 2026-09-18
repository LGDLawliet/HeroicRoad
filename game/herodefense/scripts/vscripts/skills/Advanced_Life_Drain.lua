--特效优化 √
Advanced_Life_Drain = class({})

LinkLuaModifier("modifier_Advanced_Life_Drain_enemy", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Life_Drain_enemy_sub", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Life_Drain_enemy_mark", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Life_Drain_friend", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Life_Drain_unlock2", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Life_Drain_unlock3_thinker", "skills/Advanced_Life_Drain", LUA_MODIFIER_MOTION_NONE)
function Advanced_Life_Drain:IsHiddenWhenStolen() 	return false end
function Advanced_Life_Drain:IsRefreshable() 			return true end
function Advanced_Life_Drain:IsStealable() 			return true end
function Advanced_Life_Drain:IsNetherWardStealable()	return true end
function Advanced_Life_Drain:IsRefreshable() 
	if self:GetUnlock(2)==2 then
		return false
	end
	return true
end
function Advanced_Life_Drain:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/life_drain/effect2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/life_drain/unlock3/effect.vpcf", context )
end
function Advanced_Life_Drain:CheckKV(key)
	local table = {
		health_drain = 6,
		intelligence_index = 0.04,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Life_Drain:GetSpellRange()
	return self:GetSpecialValueFor("break_range") + self:GetCaster():GetCastRangeBonus()
end

function Advanced_Life_Drain:GetChannelTime()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return 0
		end
		if coreUnlockKV.coreUnlock ==3 then
			return 0
		end
	end
	return self.BaseClass.GetChannelTime(self)
end

function Advanced_Life_Drain:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	return true
end
function Advanced_Life_Drain:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Life_Drain_unlock2",{})
	return true
end
function Advanced_Life_Drain:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock3",{})
	return true
end

function Advanced_Life_Drain:CastFilterResultTarget(target)
	if target == self:GetCaster() or target:IsBuilding() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end

end

function Advanced_Life_Drain:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end
function Advanced_Life_Drain:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_POINT
		end
	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_Life_Drain:OnSpellStart()
	local caster = self:GetCaster()
	if self.unlock3 then
		local target_point 	= self:GetCursorPosition()
		if self.thinker and not self.thinker:IsNull() then
			UTIL_Remove( self.thinker )
		end

		self.thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Life_Drain_unlock3_thinker", 
			{}, -- kv
			target_point,
			caster:GetTeamNumber(),
			false
		)
		return
	end
	self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
	self.caster = caster
	local target = self:GetCursorTarget()
	local target_ent = target:entindex()

	if self.unlock1 then
		local modifier = caster:FindModifierByName("modifier_Advanced_Life_Drain_friend")
		if modifier then
			modifier:SetDuration(0,true)
		end
	end
	local duration =  self:GetChannelTime()
	if IsEnemy(caster, target) then
		self.buff = caster:AddNewModifier(caster, self, "modifier_Advanced_Life_Drain_enemy", {duration = duration,target = target_ent})
	else
		if self.unlock1 then
			duration = -1
		end
		-- caster:InterruptChannel()
		self.buff = caster:AddNewModifier(target, self, "modifier_Advanced_Life_Drain_friend", {duration = duration,target = target_ent})
		
		
	end
	caster:EmitSound("Hero_Pugna.LifeDrain.Cast")
	-- target:EmitSound("Hero_Pugna.LifeDrain.Target")
	-- target:EmitSound("Hero_Pugna.LifeDrain.Loop")
	if not caster:HasModifier("modifier_Advanced_Life_Drain_enemy") then
		caster:EmitSound("Hero_Pugna.LifeDrain.Loop")
	end
end

function Advanced_Life_Drain:OnChannelFinish()

	if IsServer() then
		local duration = 0
		--LV15解锁断魂（不对友军生效）
		if self.advanced_level>=15 then
			duration = 6
		end
		if self.buff and not self.buff:IsNull() then
			if self.buff:GetName()=="modifier_Advanced_Life_Drain_enemy" then
				self.buff:SetDuration( duration, true )
			else
				if self.unlock1 then
					return
				end
				self.buff:SetDuration( 0, true )
			end
			self.buff = nil
		end

		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end


modifier_Advanced_Life_Drain_enemy = class({})

function modifier_Advanced_Life_Drain_enemy:IsDebuff()			return false end
function modifier_Advanced_Life_Drain_enemy:IsHidden() 			return true end
function modifier_Advanced_Life_Drain_enemy:IsPurgable() 		return false end
function modifier_Advanced_Life_Drain_enemy:IsPurgeException() 	return false end
function modifier_Advanced_Life_Drain_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Life_Drain_enemy:OnCreated(keys)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Loop")
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		
		self.Counter = 0
		self.target = EntIndexToHScript(keys.target)
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_5" then
			pfx_name = "particles/rebuild/spell/life_drain/effect2/effect.vpcf"
		end
		-- pfx_name ="particles/econ/items/pugna/pugna_ti10_immortal/pugna_ti10_immortal_life_drain.vpcf"
		self.source = caster
		if keys.source then
			self.source =  EntIndexToHScript(keys.source)
	
		end
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		if self.source:IsRealHero() then
			ParticleManager:SetParticleControlEnt(self.pfx, 0, self.source, PATTACH_CENTER_FOLLOW, "attach_attack1", self.source:GetAbsOrigin(), true)
		else
			ParticleManager:SetParticleControlEnt(self.pfx, 0, self.source, PATTACH_CENTER_FOLLOW, nil, self.source:GetAbsOrigin(), true)
		end
		
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		--技能数据
		local ability = self:GetAbility()
		self.range = math.max(ability:GetSpellRange(),100)
		self.advanced_level = ability.advanced_level
		--多重化间隔
		self.time = self:GetAbility():GetSpecialValueFor("proliferation_interval") / self:GetAbility():GetSpecialValueFor("tick_rate")
		--LV5解锁多重化+
		if self.advanced_level>=5 then
			self.time = 1 / self:GetAbility():GetSpecialValueFor("tick_rate")
		end
		--伤害
		self.dmg = (ability:GetSpecialValueFor("health_drain") + (ability:GetSpecialValueFor("intelligence_index"))*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))

	end
end

function modifier_Advanced_Life_Drain_enemy:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self.target
	if not target or target:IsNull() or self.source:IsNull() then
		self:SafeDestroy()
		return
	end
	self.Counter = self.Counter + 1
	local ability = self:GetAbility()
	target:AddNewModifier(caster, ability, "modifier_Advanced_Life_Drain_enemy_mark", {duration = ability:GetSpecialValueFor("tick_rate")})
	if self.Counter>= self.time and not ability.unlock3  then
		self.Counter = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetSpecialValueFor("break_range"), DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
         
		for _,target in pairs(enemies) do
				if not target:IsMagicImmune()  and not target:HasModifier("modifier_Advanced_Life_Drain_enemy_mark")  then        
				local target_ent = target:entindex()   
				caster:AddNewModifier(caster, ability, "modifier_Advanced_Life_Drain_enemy_sub", {duration = math.min(self:GetRemainingTime(),5),target = target_ent})
					break
				end
		end
	end
	if caster:IsSilenced() or IsHardDisabled(caster) or (self.source:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (self.range) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	if not caster:CanEntityBeSeenByMyTeam(target) then
		self:SafeDestroy()
		return
	end
	local ability = ability

	local damageTable = {
						victim = target,
						attacker = caster,
						damage = self.dmg,
						damage_type = ability:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = ability, --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)

	if caster:GetHealth() ~= caster:GetMaxHealth() then
		-- ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))

		HealWithGain(dmg_done,caster,caster,ability)
	else
		-- ParticleManager:SetParticleControl(self.pfx, 11, Vector(1,0,0))
		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done*0.05))
	end
end

function modifier_Advanced_Life_Drain_enemy:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end

		self.target = nil

		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetAbility():EndChannel(true)
	end
end



---------------------------------------------------------------------



modifier_Advanced_Life_Drain_enemy_sub = class({})

function modifier_Advanced_Life_Drain_enemy_sub:IsDebuff()			return false end
function modifier_Advanced_Life_Drain_enemy_sub:IsHidden() 			return true end
function modifier_Advanced_Life_Drain_enemy_sub:IsPurgable() 		return false end
function modifier_Advanced_Life_Drain_enemy_sub:IsPurgeException() 	return false end
function modifier_Advanced_Life_Drain_enemy_sub:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Life_Drain_enemy_sub:OnCreated(keys)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Loop")
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_5" then
			pfx_name = "particles/rebuild/spell/life_drain/effect2/effect.vpcf"
		end
		self.source = caster
		if keys.source then
			self.source =  EntIndexToHScript(keys.source)
	
		end

		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self.source, PATTACH_POINT_FOLLOW, "attach_attack1", self.source:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	
		-- ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		--技能数据
		
		local ability = self:GetAbility()
		self.range = math.max(ability:GetSpellRange(),100)
		self.advanced_level = ability.advanced_level
		self.dmg = (ability:GetSpecialValueFor("health_drain") + (ability:GetSpecialValueFor("intelligence_index"))*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))

	end
end

function modifier_Advanced_Life_Drain_enemy_sub:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self.target
	if not target or target:IsNull() then
		self:SafeDestroy()
		return
	end
	target:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Life_Drain_enemy_mark", {duration = self:GetAbility():GetSpecialValueFor("tick_rate")})
	if caster:IsSilenced() or IsHardDisabled(caster) or (self.source:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (self.range) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	-- if not caster:CanEntityBeSeenByMyTeam(target) then
	-- 	self:SafeDestroy()
	-- 	return
	-- end
	local ability = self:GetAbility()
	
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = self.dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)

	if caster:GetHealth() ~= caster:GetMaxHealth() then
		HealWithGain(dmg_done,caster,caster,ability)
	else

		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done*0.05))
	end
end

function modifier_Advanced_Life_Drain_enemy_sub:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self.target = nil

		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		-- self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end


modifier_Advanced_Life_Drain_enemy_mark = class({})

function modifier_Advanced_Life_Drain_enemy_mark:IsDebuff()			    return false end
function modifier_Advanced_Life_Drain_enemy_mark:IsHidden() 			return true end
function modifier_Advanced_Life_Drain_enemy_mark:IsPurgable() 		    return false end
function modifier_Advanced_Life_Drain_enemy_mark:IsPurgeException() 	return false end

function modifier_Advanced_Life_Drain_enemy_mark:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Life_Drain_enemy_mark:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.magic_res_reduce = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")
	--LV10解锁魂吸+
	if advanced_level>=10 then
		self.magic_res_reduce = self.magic_res_reduce -15
	end

	--LV20解锁魂吸++
	if advanced_level>=20 then
		local spell_gain = self:GetCaster():GetSpellAmplification(false)
		if spell_gain>0 then
			spell_gain = spell_gain/10
			spell_gain = spell_gain-spell_gain%1
			self.magic_res_reduce = self.magic_res_reduce - spell_gain*5
		end
	end
end
function modifier_Advanced_Life_Drain_enemy_mark:GetModifierMagicalResistanceBonus() return self.magic_res_reduce end



--------------------------------------------------------------------

modifier_Advanced_Life_Drain_friend = class({})

function modifier_Advanced_Life_Drain_friend:IsDebuff()			return false end
function modifier_Advanced_Life_Drain_friend:IsHidden() 			return true end
function modifier_Advanced_Life_Drain_friend:IsPurgable() 		return false end
function modifier_Advanced_Life_Drain_friend:IsPurgeException() 	return false end
function modifier_Advanced_Life_Drain_friend:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Life_Drain_friend:OnCreated(keys)
	if IsServer() then
		
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_5" then
			pfx_name = "particles/rebuild/spell/life_drain/effect2/effect.vpcf"
		end
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		-- local ent = keys.target
		-- if self:GetCaster() ~= self:GetAbility():GetCaster() then
		-- 	ent = self:GetCaster():entindex()
		-- end
		-- self:SetStackCount(ent)
		self.range = math.max(self:GetAbility():GetSpellRange(),100)
		if self:GetAbility().unlock1 then
			self.range = 99999
			self.unlock1 = true
			self.time = GameRules:GetGameTime()
			self.timer = 0
		end
	end
end

function modifier_Advanced_Life_Drain_friend:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	local target = self.target
	if caster:IsSilenced() or IsHardDisabled(caster) or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (self.range) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	if not caster:CanEntityBeSeenByMyTeam(target) then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("health_drain") + ability:GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))


	dmg = dmg * 0.5
	if not self.unlock1 then
		local damageTable = {
			victim = caster,
			attacker = caster,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
			ability = self:GetAbility(), --Optional.
			}
		ApplyDamage(damageTable)
	else
		self.timer = self.timer + GameRules:GetGameTime()-self.time  --计算出时间增长
		self.time = GameRules:GetGameTime()
		local need = 0.6
		local chance = math.floor(self.timer/need)
		if chance>=1 then
			self.timer = self.timer - need *chance
			--触发多重化
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, math.max(self:GetAbility():GetSpellRange()-25,75), DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
			 
			for _,enemy in pairs(enemies) do
				if not enemy:IsMagicImmune()  and not enemy:HasModifier("modifier_Advanced_Life_Drain_enemy_mark")  then        
					local enemy_ent = enemy:entindex()   
					caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Life_Drain_enemy_sub", {duration =5,source = target:entindex(),target = enemy_ent})
					break
				end
			end
		end
		if not target:IsAlive() then
			self:SafeDestroy()
			return
		end
		if target:GetHealth() ~= target:GetMaxHealth() then
			HealWithGain(dmg,caster,target,ability)
		end
		return
		
	end
	

	if target:GetHealth() ~= target:GetMaxHealth() then
		HealWithGain(dmg,caster,target,ability)
	else
		self:SafeDestroy()
		return
	end
end

function modifier_Advanced_Life_Drain_friend:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self.target = nil
		-- self.pfx = nil
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		-- self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetAbility():EndChannel(true)
	end
end










modifier_Advanced_Life_Drain_unlock2 = class({})

function modifier_Advanced_Life_Drain_unlock2:IsDebuff()			return false end
function modifier_Advanced_Life_Drain_unlock2:IsHidden() 			return true end
function modifier_Advanced_Life_Drain_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Life_Drain_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Life_Drain_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Life_Drain_unlock2:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_Advanced_Life_Drain_unlock2:OnIntervalThink()
	local ability = self:GetAbility()

	if ability:IsCooldownReady() then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, math.max(self:GetAbility():GetSpellRange()-25,75), DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune()  and not enemy:HasModifier("modifier_Advanced_Life_Drain_enemy_mark")  then        
				local enemy_ent = enemy:entindex()   
				caster:AddNewModifier(caster, ability, "modifier_Advanced_Life_Drain_enemy", {duration = 10,target = enemy_ent})
				ability:StartCooldown(5)
				break
			end
		end
	end
end



modifier_Advanced_Life_Drain_unlock3_thinker= modifier_Advanced_Life_Drain_unlock3_thinker or class({})

function modifier_Advanced_Life_Drain_unlock3_thinker:IsHidden()		return true end
function modifier_Advanced_Life_Drain_unlock3_thinker:IsPurgable()		return false end
function modifier_Advanced_Life_Drain_unlock3_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Life_Drain_unlock3_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		parent:SetOrigin(parent:GetOrigin()+Vector(0,0,2000))

		self:StartIntervalThink(0.1)
		self.effect_table = {}
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		local caster = self:GetCaster()
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),ability:GetAbilityName())
		if type=="ability_particle_5" then
			pfx_name = "particles/rebuild/spell/life_drain/effect2/effect.vpcf"
		end

		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0,caster, PATTACH_CENTER_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)	
		ParticleManager:SetParticleControlEnt(self.pfx, 1, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true)

		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/life_drain/unlock3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle,1,Vector(500,0,0))
		self:AddParticle( self.particle, false, false, -1, true, false )
	end
end
function modifier_Advanced_Life_Drain_unlock3_thinker:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		-- self:GetAbility():EndChannel(true)
		UTIL_Remove( self:GetParent() )

	end
end


function modifier_Advanced_Life_Drain_unlock3_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:IsAlive()then
		return
	end
	if not ability then
		self:SafeDestroy()
		return
	end
	local count = #caster:FindAllModifiersByName("modifier_Advanced_Life_Drain_enemy")
	if count>=20 then
		return
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
			 
	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune()  and not enemy:HasModifier("modifier_Advanced_Life_Drain_enemy_mark")  then
			if not self.effect_table[enemy] then
				self.effect_table[enemy] = GameRules:GetGameTime()
			end
			if self.effect_table[enemy]<= GameRules:GetGameTime()then
				self.effect_table[enemy] = GameRules:GetGameTime() +10
				local enemy_ent = enemy:entindex()   
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Life_Drain_enemy", {duration =5,source = parent:entindex(),target = enemy_ent})
				count = count+ 1
			end
		
			if count>=20 then
				break
			end
		end
	end

end
