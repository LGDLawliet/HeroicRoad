
--特效优化 √
Advanced_Arcane_Replacement = class({})


LinkLuaModifier("modifier_Advanced_Arcane_Replacement", "skills/Advanced_Arcane_Replacement", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Arcane_Replacement_effect", "skills/Advanced_Arcane_Replacement", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Arcane_Replacement_unlock3", "skills/Advanced_Arcane_Replacement", LUA_MODIFIER_MOTION_NONE)

function Advanced_Arcane_Replacement:GetIntrinsicModifierName() return "modifier_Advanced_Arcane_Replacement" end
function Advanced_Arcane_Replacement:IsHiddenWhenStolen() 		return false end
function Advanced_Arcane_Replacement:IsRefreshable() 			return true  end
function Advanced_Arcane_Replacement:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_replacement/effect.vpcf", context )
end
function Advanced_Arcane_Replacement:CheckKV(key)
	local table = {
		change_percentage = 0.5,




	}
	local value = table[key] or -1
	return value

end


function Advanced_Arcane_Replacement:CheckKVFixedOverride(key)
	if key=="change_limit2" then
		if self:GetUnlock(1)==1 then
			return 80
		end
	end

	return -999999

end



function Advanced_Arcane_Replacement:UnlockFirstCore(key)
	local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	local modifier = caster:FindModifierByName("modifier_Advanced_Arcane_Replacement")
	if modifier then
		modifier:StartIntervalThink(0.1)
	end
	return true
end
function Advanced_Arcane_Replacement:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_Arcane_Replacement:UnlockThirdCore(key)
	-- self:GetCaster():AddItemByName("item_hd_Song_of_Eagle_Voice_of_Dragonus")
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end







function Advanced_Arcane_Replacement:ReleasePower(stack)
	local caster = self:GetCaster()
	local effect_count = 1
	local unlock2 = false
	if self.unlock2 then
		if stack>=(self:GetSpecialValueFor("change_limit2")*caster:HDGetPrimaryStatValue()-5) then
			effect_count = 2
			unlock2 = true
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = caster,
		damage = stack,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	}

	local unlock2_pass = false

	local count = 3
	if self.advanced_level>=5 then
		count = 5
	end

	for _, unit in ipairs(enemies) do
		self:PlayEffect(caster,unit)
		damageTable.victim = unit
		ApplyDamage(damageTable)
		unit:EmitSound("Hero_Luna.Eclipse.Target")
		if unlock2 and not unit:IsAlive() then
			unlock2_pass = true
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
		for _, target in ipairs(units) do
			if unit~=target then
				count = count - 1
				self:PlayEffect(unit,target)
				damageTable.victim = target
				ApplyDamage(damageTable)
				if count<=0 then
					break
				end
			end
		end
		effect_count = effect_count -1
		if effect_count<=0 then
			break
		end
	end
	
	if self.advanced_level>=15 then
		if stack>=caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("change_limit2")*0.3 then
			local gain = caster:GetModifierDurationGainIndex(1)
			caster:AddNewModifier(
				caster,
				self,
				"modifier_Advanced_Arcane_Replacement_effect",
				{	duration = 30*gain}
			)
		end
	end
	
	local chance = 20
	if self.advanced_level>=10 then
		chance = 30
	end
	if chance>=RandomInt(1, 100) then
		return 0
	end

	if unlock2_pass then
		return stack*0.5
	end
	return stack

end


function Advanced_Arcane_Replacement:PlayEffect(source,target)
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/arcane_replacement/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_attack1", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end
modifier_Advanced_Arcane_Replacement= class({})

function modifier_Advanced_Arcane_Replacement:IsDebuff()			return false end
function modifier_Advanced_Arcane_Replacement:IsHidden() 			return false end
function modifier_Advanced_Arcane_Replacement:IsPurgable() 		return false end
function modifier_Advanced_Arcane_Replacement:IsPurgeException() 	return false end
function modifier_Advanced_Arcane_Replacement:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.change_percentage = ability:GetSpecialValueFor("change_percentage")*0.01
		-- self.change_limit = ability:GetSpecialValueFor("change_limit")
		self.change_limit2 = ability:GetSpecialValueFor("change_limit2")
		self:StartIntervalThink(0.3)
		if ability.unlock1 then
			self:StartIntervalThink(0.1)
		end
		self.ability = ability
	end
end
function modifier_Advanced_Arcane_Replacement:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.change_percentage = ability:GetSpecialValueFor("change_percentage")*0.01
		-- self.change_limit = ability:GetSpecialValueFor("change_limit")
		self.change_limit2 = ability:GetSpecialValueFor("change_limit2")
	end
end
function modifier_Advanced_Arcane_Replacement:OnCustomModifierFunction_Heal(keys)
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.unit:PassivesDisabled() then
			return
		end
		if keys.heal<5 then
			return
		end
		local caster = self:GetCaster()
		if self.ability.unlock3 and keys.pre_health<=keys.target:GetMaxHealth()*0.3333 then
			caster:AddNewModifier(
				caster,
				self.ability,
				"modifier_Advanced_Arcane_Replacement_unlock3",
				{	duration = 5}
			)
		end
		
		-- local gain = keys.heal *self.change_percentage
		-- local single_limit = keys.unit:HDGetPrimaryStatValue()*self.change_limit
		local total_limit = self.change_limit2
		-- if self.ability.unlock1 and gain>=single_limit*3  then
		-- 	single_limit = single_limit * 2
		-- end
		local heal = keys.heal *self.change_percentage
		if caster:HasModifier("modifier_Advanced_Arcane_Replacement_unlock3") then
			total_limit = 200
			-- heal = gain
		end
		

		local limit = keys.unit:HDGetPrimaryStatValue()*total_limit
		if limit>=self:GetStackCount()+heal then
			self:SetStackCount(self:GetStackCount()+heal)
		else
			self:SetStackCount(math.min(self:GetStackCount()+heal,limit))
		end
	
		if self.ability.advanced_level>=20 then
			local stack = self:GetStackCount()
			if stack>=limit and 35>=RandomInt(1, 100) then
				self:Release(stack)
			end
		end

	end
end
function modifier_Advanced_Arcane_Replacement:OnIntervalThink(keys)
	local stack = self:GetStackCount()
	if stack>=100 then
		self:Release(stack)
	end
	
end
function modifier_Advanced_Arcane_Replacement:Release(stack)
	local ability = self:GetAbility()
	local reduce = ability:ReleasePower(stack)
	self:SetStackCount(stack-reduce)
end










modifier_Advanced_Arcane_Replacement_effect = advanced_modifier({})

function modifier_Advanced_Arcane_Replacement_effect:IsHidden()	return false end
function modifier_Advanced_Arcane_Replacement_effect:IsDebuff()	return false end
function modifier_Advanced_Arcane_Replacement_effect:IsPurgable()	return false end

function modifier_Advanced_Arcane_Replacement_effect:OnCreated(params)
	self.ability = self:GetAbility()
	self.max = 70
	-- if self.ability:GetSpecialValueFor("advanced_level")>=5 then
	-- 	self.max = 80
	-- end
	if IsServer() then
	
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)


	end
end
function modifier_Advanced_Arcane_Replacement_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		--当叠加乘数没达到最高时
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()

	end
end

function modifier_Advanced_Arcane_Replacement_effect:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		-- local change = false
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				-- change = true
			end
		end
	end
end

function modifier_Advanced_Arcane_Replacement_effect:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end
function modifier_Advanced_Arcane_Replacement_effect:OnTooltip() return math.min( 2*self:GetStackCount(),self.max) end


-- advanced_modifier
function modifier_Advanced_Arcane_Replacement_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_Advanced_Arcane_Replacement_effect:Advanced_GetModifierHealAMP_Percentage(keys)
	local bonus = math.min( 2*self:GetStackCount(),self.max)
	return bonus
end









modifier_Advanced_Arcane_Replacement_unlock3= class({})

function modifier_Advanced_Arcane_Replacement_unlock3:IsDebuff()			return false end
function modifier_Advanced_Arcane_Replacement_unlock3:IsHidden() 			return false end
function modifier_Advanced_Arcane_Replacement_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Arcane_Replacement_unlock3:IsPurgeException() 	return false end