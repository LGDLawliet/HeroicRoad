
Advanced_brain_sap = class({})
LinkLuaModifier( "modifier_Advanced_brain_sap_debuff", "skills/Advanced_brain_sap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_brain_sap_buff", "skills/Advanced_brain_sap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_brain_sap_unlock2_debuff", "skills/Advanced_brain_sap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_brain_sap_unlock3_debuff", "skills/Advanced_brain_sap", LUA_MODIFIER_MOTION_NONE )
function Advanced_brain_sap:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context )
end
function Advanced_brain_sap:UnlockFirstCore(key)
	return true
end
function Advanced_brain_sap:UnlockSecondCore(key)
	return true
end
function Advanced_brain_sap:UnlockThirdCore(key)
	return true
end
function Advanced_brain_sap:CheckKV(key)
	local table = {
		base_damage = 10,
		bonus_damage =0.08,

	}
	local value = table[key] or -1
	return value

end
function Advanced_brain_sap:GetManaCost( level )

	local base = self.BaseClass.GetManaCost( self, level )
	if IsServer() and self:GetAutoCastState() then
		if self.unlock3 then
			return base
		end
		return base *2
	end

	return base
end
function Advanced_brain_sap:GetCooldown( level )

	local base = self.BaseClass.GetCooldown( self, level )
	if IsServer() and self:GetAutoCastState() then
		if self.unlock3 then
			return 1
		end
		return base *0.5
	end

	return base
end


function Advanced_brain_sap:GetBehavior( )
	if self:GetSpecialValueFor("advanced_level")>=10 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE +DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior( self )
end



function Advanced_brain_sap:GetAOERadius()
	local radius = 300
	if self:GetSpecialValueFor("advanced_level")>=10 then
		radius = 450
	end
	return radius
end
function Advanced_brain_sap:GetCastRange(vLocation, hTarget)
	local base_range = self.BaseClass.GetCastRange(self,vLocation, hTarget)
	if self.talent or self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		self.talent = true
		base_range = base_range +200
	end
	return base_range
end
function Advanced_brain_sap:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end
	if self.unlock3 and self:GetAutoCastState() then
		local mana = caster:GetMana()
		if mana>=400 then
			caster:SpendMana( 400, self )
		else
			
			caster:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_unlock3_debuff", {duration = 30})
			-- caster:SpendMana( 400, self )
		end
		
	end
	local damage = self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	local modifier = caster:FindModifierByName("modifier_Advanced_brain_sap_buff")

	if modifier then
		damage = damage * (1+modifier:GetStackCount()*0.1)
	end
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		damage = damage *1.2
	end


	local targets = {}
	targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetAOERadius(),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST ,	-- int, order filter
		false	-- bool, can grow cache
)

	local count = 3
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local index = 2
	local duration = 5
	if self.advanced_level>=5 then
		index = 3
		if self.advanced_level>=10 then
			count = 5
			if self.unlock1 then
				duration = 20
				index = 7
			end
		end
	end
	local real_damage = ApplyDamage(damageTable)
	
	if real_damage>0 then
		self:HealEffect(real_damage)
		target:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_debuff", {duration =duration,max_stack =real_damage * index})

	end
	if self.unlock2 then
		target:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_unlock2_debuff", {})
	end
	self:PlayEffects( caster,target )

	local i = 0
	for _,enemy in pairs(targets) do
		if enemy~=target then
			damageTable.victim = enemy
			local real_damage = ApplyDamage(damageTable)
			if real_damage>0 then
				self:HealEffect(real_damage*0.1)
				enemy:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_debuff", {duration =duration,max_stack =real_damage* index })
			end
			if self.unlock2 then
				enemy:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_unlock2_debuff", {})
			end
			self:PlayEffects( caster,enemy )
			i = i +1
			if i>=count then
				break
			end
		end
	

	
	end

	if self.advanced_level>=20 then
		caster:AddNewModifier(
			caster,
			self,
			"modifier_Advanced_brain_sap_buff",
			{	duration = 60} 
    	)
	end



end
function Advanced_brain_sap:HealEffect(count)
	local caster = self:GetCaster()
	if self.advanced_level>=15 then
		if caster:GetHealth()==caster:GetMaxHealth() then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			for _, unit in pairs(units) do
				if unit:GetHealthPercent()<100 then
					HealWithGain(count,caster,unit,self)
					self:PlayEffects( unit ,caster )
					break
				end
			end
		else
			local gain = caster:GetModifierLifeStealGain(1) --吸血增幅
			caster:Heal( count*gain, self )
		end
	else
		local gain = caster:GetModifierLifeStealGain(1) --吸血增幅
		caster:Heal( count*gain, self )
	end
end
--------------------------------------------------------------------------------
function Advanced_brain_sap:PlayEffects( caster ,target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bane/bane_sap.vpcf"
	local sound_cast = "Hero_Bane.BrainSap"
	local sound_target = "Hero_Bane.BrainSap.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
end


function Advanced_brain_sap:CastUnlock2SingleEffect(target)
	local caster = self:GetCaster()
	if target:TriggerSpellAbsorb( self ) then
		return
	end
	local damage = self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
	local modifier = caster:FindModifierByName("modifier_Advanced_brain_sap_buff")
	if modifier then
		damage = damage * (1+modifier:GetStackCount()*0.1)
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local index = 3
	local duration = 5
	local real_damage = ApplyDamage(damageTable)
	
	if real_damage>0 then
		self:HealEffect(real_damage)
		target:AddNewModifier(caster, self, "modifier_Advanced_brain_sap_debuff", {duration =duration,max_stack =real_damage * index})
	end
	self:PlayEffects( caster,target )
end


modifier_Advanced_brain_sap_debuff= class({})

function modifier_Advanced_brain_sap_debuff:IsDebuff()			return true end
function modifier_Advanced_brain_sap_debuff:IsHidden() 			return false end
function modifier_Advanced_brain_sap_debuff:IsPurgable() 		return false end
function modifier_Advanced_brain_sap_debuff:IsPurgeException() 	return false end
function modifier_Advanced_brain_sap_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_brain_sap_debuff:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end

function modifier_Advanced_brain_sap_debuff:OnCreated(keys)
	if IsServer() then
		self.max_stack = keys.max_stack
		self:SetStackCount(0)
	end
end

function modifier_Advanced_brain_sap_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local damageTable = {
			victim = parent,
			attacker = caster,
			damage = self:GetStackCount(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = ability, --Optional.
			
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
			hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
		}
		ApplyDamage(damageTable)
		ability:PlayEffects(caster,parent)
	end
end


function modifier_Advanced_brain_sap_debuff:OnTakeDamage( params )
	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent()  then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		self:SetStackCount(math.min(self.max_stack,self:GetStackCount()+flDamage))
		if self:GetStackCount()>=(self.max_stack-1) then
			self:SafeDestroy()
		end
	end
	return 0.0
end













modifier_Advanced_brain_sap_buff = class({})

function modifier_Advanced_brain_sap_buff:IsHidden()	return false end
function modifier_Advanced_brain_sap_buff:IsDebuff()	return false end
function modifier_Advanced_brain_sap_buff:IsPurgable()	return false end
function modifier_Advanced_brain_sap_buff:IsPurgeException()	return false end
function modifier_Advanced_brain_sap_buff:RemoveOnDeath() return false end
function modifier_Advanced_brain_sap_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_brain_sap_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()

	end
end
function modifier_Advanced_brain_sap_buff:OnDestroy()
	if IsServer() then
		-- local nPlayerID = self:GetCaster():GetPlayerOwnerID()
		-- local NetTable_key = tostring(nPlayerID).."_finger_of_death"

	end

end

function modifier_Advanced_brain_sap_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end












modifier_Advanced_brain_sap_unlock2_debuff= class({})

function modifier_Advanced_brain_sap_unlock2_debuff:IsDebuff()			return true end
function modifier_Advanced_brain_sap_unlock2_debuff:IsHidden() 			return false end
function modifier_Advanced_brain_sap_unlock2_debuff:IsPurgable() 		return false end
function modifier_Advanced_brain_sap_unlock2_debuff:IsPurgeException() 	return false end
function modifier_Advanced_brain_sap_unlock2_debuff:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	} 
end

function modifier_Advanced_brain_sap_unlock2_debuff:OnCreated(keys)
	if IsServer() then
		self.damage_count = 0
		self:SetStackCount(20)
	end
end
function modifier_Advanced_brain_sap_unlock2_debuff:OnRefresh(keys)
	if IsServer() then
		-- self.damage_count = 0
		self:SetStackCount(math.max(20,self:GetStackCount()-10))
	end
end
function modifier_Advanced_brain_sap_unlock2_debuff:OnTooltip()
	return self:GetStackCount()
end

function modifier_Advanced_brain_sap_unlock2_debuff:OnTakeDamage( params )
	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage


		if Target ~= self:GetParent()  then
			return 0
		end
		if flDamage<=10 then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		self.damage_count = self.damage_count + 1
		if self.damage_count>=self:GetStackCount() then
			local ability = self:GetAbility()
			if not ability then
				self:SafeDestroy()
				return
			end
			self:SetStackCount(self:GetStackCount()+5)
			self.damage_count = 0
			ability:CastUnlock2SingleEffect(self:GetParent())
		end
	end
	return 0.0
end









modifier_Advanced_brain_sap_unlock3_debuff= advanced_modifier({})

function modifier_Advanced_brain_sap_unlock3_debuff:IsDebuff()			return true end
function modifier_Advanced_brain_sap_unlock3_debuff:IsHidden() 			return false end
function modifier_Advanced_brain_sap_unlock3_debuff:IsPurgable() 		return false end
function modifier_Advanced_brain_sap_unlock3_debuff:IsPurgeException() 	return false end
function modifier_Advanced_brain_sap_unlock3_debuff:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end




function modifier_Advanced_brain_sap_unlock3_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_brain_sap_unlock3_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_brain_sap_unlock3_debuff:OnIntervalThink()
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


function modifier_Advanced_brain_sap_unlock3_debuff:OnTooltip()

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	end

end



-- advanced_modifier
function modifier_Advanced_brain_sap_unlock3_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_Advanced_brain_sap_unlock3_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return -3*self:GetStackCount()
end

function modifier_Advanced_brain_sap_unlock3_debuff:Advanced_GetModifierIncomingDamage_Percentage()	return 5*self:GetStackCount() end

