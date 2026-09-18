--特效优化 √
Advanced_purifying_flame = class({})

--------------------------------------------------------------------------------
-- Ability Start

LinkLuaModifier("modifier_Advanced_purifying_flame_active", "skills/Advanced_purifying_flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_purifying_flame_debuff", "skills/Advanced_purifying_flame", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_purifying_flame_thinker", "skills/Advanced_purifying_flame", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_purifying_flame_unlock2", "skills/Advanced_purifying_flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_purifying_flame_active_unlock3", "skills/Advanced_purifying_flame", LUA_MODIFIER_MOTION_NONE)


require('internal/timers')   --计时器功能
function Advanced_purifying_flame:CheckKV(key)
	local table = {

	


		basic_damage = 10,
		bonus_damage = 0.1,
		basic_heal = 20,
		bonus_heal = 0.15,




	}
	local value = table[key] or -1
	return value

end

function Advanced_purifying_flame:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/purifyingflames/unlock2/effect_hit.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf", context )

	
	
end

function Advanced_purifying_flame:UnlockFirstCore(key)
	return true
end
function Advanced_purifying_flame:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_purifying_flame_unlock2",{})
	return true
end

function Advanced_purifying_flame:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_purifying_flame_unlock2",{})
	return true
end

function Advanced_purifying_flame:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	
		-- elseif coreUnlockKV.coreUnlock ==3 then
		-- 	return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_purifying_flame:GetAOERadius()
	return 500
end
function Advanced_purifying_flame:OnSpellStart()
	-- unit identifier

	if self.unlock1 then
		local caster = self:GetCaster()
		local thinker =CreateModifierThinker(
			caster,
			self,
			"modifier_Advanced_purifying_flame_thinker",
			{
				duration = 5,
			},
			self:GetCursorPosition(),
			caster:GetTeamNumber(),
			false
		)
		caster:EmitSound("Hero_Oracle.RainOfDestiny")	
	else

		local target = self:GetCursorTarget()
		self:CastToTarget(target)
	end




	

end
function Advanced_purifying_flame:CastToTarget(target,unlock2)
	local caster = self:GetCaster()
	local ally = true
	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		ally = false
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end
	end


	local damage =self:GetSpecialValueFor("basic_damage")+(self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	local effect_name = "particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf"
	if unlock2 then
		effect_name = "particles/rebuild/spell/purifyingflames/unlock2/effect_hit.vpcf"
	else	
		if ally and self.unlock3 then
			effect_name = "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf"
		end
	end


	local particle = ParticleManager:CreateParticle(effect_name, PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	Timers:CreateTimer(0.2, function()
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self, --Optional.
		}
		if ally then
			--LV5解锁洗涤+
			if self.advanced_level>=5 then
				target:Purge(false, true, false, false, true)
			else
				target:Purge(false, true, false, false, false)
			end
			damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
			target:AddNewModifier(caster, self, "modifier_Advanced_purifying_flame_active", {duration = 10})
			local chance = 50
			--LV15解锁涤罪++
			if self.advanced_level>=15 then
				chance = 100
			end
			if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) then
				--do nothing
			else
				ApplyDamage(damageTable)
			end
			if self.unlock3 then
				target:AddNewModifier(caster, self, "modifier_Advanced_purifying_flame_active_unlock3", {})
			end
		else
			--LV5解锁洗涤+
			if self.advanced_level>=5 then
				target:Purge(true, false, false, false, true)
			else
				target:Purge(true, false, false, false, false)
			end
	

			target:AddNewModifier(caster, self, "modifier_Advanced_purifying_flame_active", {duration = 10})
			local damage_index = 2
			local chance = 30
			--LV10解锁涤罪+
			if self.advanced_level>=10 then
				damage_index = 3
				chance = chance*1.5
			end
			--LV15解锁涤罪++
			if self.advanced_level>=15 then
				chance = 100
			end
			if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) then
	
				damageTable.damage = damage*damage_index
			end
			ApplyDamage(damageTable)
		end
		target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")


		-- target:AddNewModifier(caster, self, "modifier_Advanced_purifying_flame_active", {duration = 10})
	end)
end


modifier_Advanced_purifying_flame_active = class({})

function modifier_Advanced_purifying_flame_active:IsDebuff() return false end
function modifier_Advanced_purifying_flame_active:IsHidden() return false end
function modifier_Advanced_purifying_flame_active:IsPurgable() return true end
function modifier_Advanced_purifying_flame_active:IsPurgeException() return true end
function modifier_Advanced_purifying_flame_active:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames_heal.vpcf" end
function modifier_Advanced_purifying_flame_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_purifying_flame_active:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_purifying_flame_active:OnDestroy()
	if IsServer() then
		for i = 1, self:GetStackCount(), 1 do
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_purifying_flame_debuff", {duration = 20})
		end
		
	end
end
-- function modifier_Advanced_purifying_flame_active:OnIntervalThink(table)
-- 	if IsServer() then
-- 		local healing = HealWithGain(self.heal,self.caster,self.parent,self.ability)
-- 		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
-- 	end
-- end


function modifier_Advanced_purifying_flame_active:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self.timer = 0
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_purifying_flame_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()

	end
end

function modifier_Advanced_purifying_flame_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()
		local caster = self:GetCaster()
		if not caster then
			return
		end
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_purifying_flame_debuff", {duration = 20})
			end
		end
		self.timer = self.timer + 0.1
		if self.timer>=1 then
			self.timer = self.timer - 1
			local ability = self:GetAbility()
			if ability  then

				local parent = self:GetParent()
				local heal = (ability:GetSpecialValueFor("basic_heal")+(ability:GetSpecialValueFor("bonus_heal"))*caster:GetIntellect(false))/10
				heal = heal * self:GetStackCount()
				local healing = HealWithGain(heal,caster,parent,ability)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
			else
				return
			end
		end
	end
end







modifier_Advanced_purifying_flame_debuff = class({})

function modifier_Advanced_purifying_flame_debuff:IsDebuff() return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() end
function modifier_Advanced_purifying_flame_debuff:IsHidden() return false end
function modifier_Advanced_purifying_flame_debuff:IsPurgable() return false end
function modifier_Advanced_purifying_flame_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	

	}
end
function modifier_Advanced_purifying_flame_debuff:GetModifierMagicalResistanceBonus()	return self.bonus*self:GetStackCount() end




function modifier_Advanced_purifying_flame_debuff:OnCreated(params)
	self.bonus = -2
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.bonus = 2
	end
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_purifying_flame_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 45 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end

	end
end

function modifier_Advanced_purifying_flame_debuff:OnIntervalThink()
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





modifier_Advanced_purifying_flame_thinker = class({})

function modifier_Advanced_purifying_flame_thinker:OnCreated(params)
	if IsServer() then
		self.radius = 500
		self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_purifying_flame_thinker:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()

	local type = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if ability:GetAutoCastState() then
		type = DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self.radius, 
	type, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
	for i, unit in ipairs(units) do
		ability:CastToTarget(unit)
		if i>=2 then
			break
		end

	end


end

function modifier_Advanced_purifying_flame_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	UTIL_Remove( self:GetParent() )
end











modifier_Advanced_purifying_flame_unlock2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_purifying_flame_unlock2:IsHidden()	return true end
function modifier_Advanced_purifying_flame_unlock2:IsPurgable() 		return false end
function modifier_Advanced_purifying_flame_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_purifying_flame_unlock2:RemoveOnDeath()  return false end
function modifier_Advanced_purifying_flame_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Advanced_purifying_flame_unlock2:OnAbilityFullyCast( params )
	if IsServer() then
		if params.ability:IsItem() then return end
		local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
		if cooldown <= 1 then
			return
		end

		if params.unit:GetTeamNumber()==self:GetParent():GetTeamNumber() then 
			self:GetAbility():CastToTarget(params.unit,true)

		end

	end
end









modifier_Advanced_purifying_flame_active_unlock3 = class({})

function modifier_Advanced_purifying_flame_active_unlock3:IsDebuff() return false end
function modifier_Advanced_purifying_flame_active_unlock3:IsHidden() return false end
function modifier_Advanced_purifying_flame_active_unlock3:IsPurgable() return false end
function modifier_Advanced_purifying_flame_active_unlock3:IsPurgeException() return false end
function modifier_Advanced_purifying_flame_active_unlock3:GetEffectName() return "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf" end
function modifier_Advanced_purifying_flame_active_unlock3:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_purifying_flame_active_unlock3:OnCreated(params)
	if IsServer() then

		self:IncrementStackCount()
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_purifying_flame_active_unlock3:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,200))
		-- self:IncrementStackCount()
	end
end

function modifier_Advanced_purifying_flame_active_unlock3:OnIntervalThink()
	if IsServer() then

		local ability = self:GetAbility()
		if ability then
			local caster = self:GetCaster()
			local parent = self:GetParent()
			local heal = (ability:GetSpecialValueFor("basic_heal")+(ability:GetSpecialValueFor("bonus_heal"))*caster:GetIntellect(false))/10
			heal = heal * self:GetStackCount()*0.2
			local healing = HealWithGain(heal,caster,parent,ability)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		else
			self:SafeDestroy()
			return
		end
		
	end
end


