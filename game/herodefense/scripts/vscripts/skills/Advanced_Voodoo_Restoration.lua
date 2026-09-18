
Advanced_Voodoo_Restoration = class({})
LinkLuaModifier("modifier_Advanced_Voodoo_Restoration", "skills/Advanced_Voodoo_Restoration", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Voodoo_Restoration_heal", "skills/Advanced_Voodoo_Restoration", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Voodoo_Restoration_unlock3", "skills/Advanced_Voodoo_Restoration", LUA_MODIFIER_MOTION_NONE)

function Advanced_Voodoo_Restoration:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf", context )
end

function Advanced_Voodoo_Restoration:CheckKV(key)
	local table = {
		radius=8,
		basic_heal=1,
		bonus_heal=0.015,

	}
	local value = table[key] or -1
	return value

end
function Advanced_Voodoo_Restoration:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_Voodoo_Restoration:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Voodoo_Restoration:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock3",{})
	return true

end
function Advanced_Voodoo_Restoration:GetManaCost(iLevel)
	if self:GetUnlock(1)==1 then
		return 0
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end

function Advanced_Voodoo_Restoration:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function Advanced_Voodoo_Restoration:Spawn()
	if IsServer() then
		self.healingStack = 0
	end
end
function Advanced_Voodoo_Restoration:StackHealing(stack)
	self.healingStack = self.healingStack + stack
end

function Advanced_Voodoo_Restoration:GetHealingStackAndRefresh()
	local stack = self.healingStack
	self.healingStack = 0
	return stack
end


function Advanced_Voodoo_Restoration:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Voodoo_Restoration", {})

	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_Advanced_Voodoo_Restoration")
	end
end

modifier_Advanced_Voodoo_Restoration = modifier_Advanced_Voodoo_Restoration or advanced_modifier({})
function modifier_Advanced_Voodoo_Restoration:IsDebuff() return false end
function modifier_Advanced_Voodoo_Restoration:IsHidden() return true end
function modifier_Advanced_Voodoo_Restoration:IsPurgable() return false end
function modifier_Advanced_Voodoo_Restoration:IsPurgeException() return false end
function modifier_Advanced_Voodoo_Restoration:IsAura()	return true end
function modifier_Advanced_Voodoo_Restoration:IsAuraActiveOnDeath()	return false end
function modifier_Advanced_Voodoo_Restoration:GetAuraRadius()	return self.radius end
function modifier_Advanced_Voodoo_Restoration:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Voodoo_Restoration:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Voodoo_Restoration:GetModifierAura()	return "modifier_Advanced_Voodoo_Restoration_heal" end
function modifier_Advanced_Voodoo_Restoration:OnCreated()
	if IsServer() and self:GetAbility():IsTrained() then
		local ability = self:GetAbility()
		self.advanced_level = ability.advanced_level
		self.damage_index = 0.5
		self.heal_index = 1
		self.mana_cost_index =1
		if self.advanced_level>=5 then
			self.damage_index = 0.75
			if self.advanced_level>=10 then
				self.heal_index = 1.5
				if self.advanced_level>=15 then
					self.mana_cost_index = 0.5

				end
			end
		end
		self.interval = 1
		self.manacost = ability:GetSpecialValueFor("mana_cost_tick") * self.interval
		self.radius = ability:GetSpecialValueFor("radius")
		self:StartIntervalThink( self.interval )
		local name = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_witch_doctor_2") then
			name = "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf"
			self.mana_cost_index = self.mana_cost_index *0.3
			self.talentToggle = true
		end
		self.mainParticle = ParticleManager:CreateParticle(name, PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_Advanced_Voodoo_Restoration:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle then

			ParticleManager:DestroyParticle(self.mainParticle, false)
			ParticleManager:ReleaseParticleIndex(self.mainParticle)
		end
	end
end

function modifier_Advanced_Voodoo_Restoration:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end

	local hAbility = self:GetAbility()
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	if hAbility.unlock1 then
		
		self.manacost = hAbility:GetSpecialValueFor("mana_cost_tick") * self.interval
		caster:GiveMana(self.manacost)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , caster, self.manacost, nil)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local heal	= (hAbility:GetSpecialValueFor("basic_heal")+hAbility:GetSpecialValueFor("bonus_heal")*caster:GetIntellect(false))*self.damage_index
		heal = heal * 5
		for i, enemy in pairs(enemies) do
			
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = heal,
								damage_type = hAbility:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = hAbility, --Optional.
								}
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end


		if self.talentToggle then
			local stack = hAbility:GetHealingStackAndRefresh()
			if stack>0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for i, enemy in pairs(enemies) do
					self:PlayEffect(enemy)
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local damageTable = {
						-- victim = enemy,
						attacker = caster,
						damage = stack,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = hAbility, --Optional.
					}
					for i, enemy in pairs(enemies) do
						damageTable.victim = enemy
						ApplyDamage(damageTable)
					end
					break
				end
			end
		end
	else
		self.manacost = hAbility:GetSpecialValueFor("mana_cost_tick") * self.interval*self.mana_cost_index
		if caster:GetMana() >= hAbility:GetManaCost(-1) then
			caster:Script_ReduceMana(self.manacost,hAbility)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local heal	= (hAbility:GetSpecialValueFor("basic_heal")+hAbility:GetSpecialValueFor("bonus_heal")*caster:GetIntellect(false))*self.damage_index
			for i, enemy in pairs(enemies) do
				
				local damageTable = {
									victim = enemy,
									attacker = caster,
									damage = heal,
									damage_type = hAbility:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = hAbility, --Optional.
									}
				ApplyDamage(damageTable)
				if i>=5 then
					break
				end
			end


			if self.talentToggle then
				local stack = hAbility:GetHealingStackAndRefresh()
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for i, enemy in pairs(enemies) do
					self:PlayEffect(enemy)
					local damageTable = {
										victim = enemy,
										attacker = caster,
										damage = stack,
										damage_type = DAMAGE_TYPE_MAGICAL,
										damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
										ability = hAbility, --Optional.
										}
					ApplyDamage(damageTable)
					break
				end
			end
		else
			hAbility:ToggleAbility()
		end

	end

end

function modifier_Advanced_Voodoo_Restoration:PlayEffect(target)
	-- local caster = self:GetCaster()
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 50, 50, 0 ) )
	DestroyParticleByDelay(effect_cast,2)
end

function modifier_Advanced_Voodoo_Restoration:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_Advanced_Voodoo_Restoration:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
		local dis = CalculateDistance(keys.unit,self:GetParent())
		if dis<=self.radius then
			local caster = self:GetCaster()
			local hAbility =self:GetAbility()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local heal	= (hAbility:GetSpecialValueFor("basic_heal")+hAbility:GetSpecialValueFor("bonus_heal")*caster:GetIntellect(false))*self.heal_index 
			if hAbility.unlcok1 then
				heal = heal * 5
			end
			for i, unit in pairs(units) do
				local healing = HealWithGain(heal,caster,unit,hAbility)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				if i>=3 then
					break
				end
			end
		end
       
    end
end

-- advanced_modifier
function modifier_Advanced_Voodoo_Restoration:ADDeclareFunctions()
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
			return 
		{
			advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		}
	end
	return {}
    
end
function modifier_Advanced_Voodoo_Restoration:Advanced_GetModifierHealAMP_Percentage(keys)
	return 35
end



-------------------------------------------
modifier_Advanced_Voodoo_Restoration_heal = advanced_modifier({})
function modifier_Advanced_Voodoo_Restoration_heal:IsDebuff() return false end
function modifier_Advanced_Voodoo_Restoration_heal:IsHidden() return false end
function modifier_Advanced_Voodoo_Restoration_heal:IsPurgable() return false end
function modifier_Advanced_Voodoo_Restoration_heal:IsPurgeException() return false end
function modifier_Advanced_Voodoo_Restoration_heal:IsStunDebuff() return false end
function modifier_Advanced_Voodoo_Restoration_heal:RemoveOnDeath() return true end


-- function modifier_Advanced_Voodoo_Restoration_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Why was this made to stack
-------------------------------------------
function modifier_Advanced_Voodoo_Restoration_heal:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end
	if IsServer() then
		self.interval = 1
		self:StartIntervalThink( self.interval )
		if self:GetAbility().unlock2 then
			local parent = self:GetParent()
			self.unlock2_done = true
		end
		self.unlock3_reduce_index = 1 --储存值消耗
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_witch_doctor_2") then
			self.talentToggle = true
			
		end

	end
end
function modifier_Advanced_Voodoo_Restoration_heal:OnDestroy()
	if IsServer() then
		if self.unlock2_done then
		end
	end
end
function modifier_Advanced_Voodoo_Restoration_heal:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local caster = self:GetCaster()
	local heal	= hAbility:GetSpecialValueFor("basic_heal")+hAbility:GetSpecialValueFor("bonus_heal")*caster:GetIntellect(false)
	if hAbility.unlock1 then
		heal = heal * 5
	end
	if hAbility.unlock3 then
		local health = hParent:GetHealth()
		local healing = HealWithGain(heal,caster,hParent,hAbility)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, healing, nil)
		
		local health_stack = hParent:GetHealth()-health
		if self.talentToggle then
			hAbility:StackHealing(health_stack)
		end
		health_stack = health_stack * 2
		local modifier = hParent:FindModifierByName("modifier_Advanced_Voodoo_Restoration_unlock3")
		if modifier then
			
			if health_stack>0 then
				self:SetStackCount(self:GetStackCount()+health_stack)
			end

			local reduce = hParent:GetMaxHealth()*0.2+500
			reduce = reduce * self.unlock3_reduce_index
			self.unlock3_reduce_index = self.unlock3_reduce_index * 1.05
			self:SetStackCount(math.max(0,self:GetStackCount()-reduce))
			if self:GetStackCount()<=0 then
				modifier:SafeDestroy()
			else
				modifier:SetDuration(3,true)
			end
		else
			if health_stack>0 then
				self:SetStackCount(self:GetStackCount()+health_stack)
				if self:GetStackCount()>=caster:GetMaxHealth() then
					hParent:EmitSound("Hero_Brewmaster.CinderBrew.Cast")
					hParent:AddNewModifier(caster, hAbility, "modifier_Advanced_Voodoo_Restoration_unlock3", {duration = 3})
				end
			end
		end
		
	else
		local health = hParent:GetHealth()
		local healing = HealWithGain(heal,caster,hParent,hAbility)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, healing, nil)
		local health_stack = hParent:GetHealth()-health
		if self.talentToggle then
			hAbility:StackHealing(heal)
		end
	end

end



function modifier_Advanced_Voodoo_Restoration_heal:Advanced_GetModifierAttackSpeedPercentage()	
	return 20 
end


function modifier_Advanced_Voodoo_Restoration_heal:Advanced_GetModifierPhysicalArmorBonus()	
	return 50
end

-- advanced_modifier
function modifier_Advanced_Voodoo_Restoration_heal:ADDeclareFunctions()
	if self:GetAbility():GetUnlock(2)==2 then
		return {
			advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
			advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
			advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		}
	elseif self:GetAbility():GetUnlock(3)==3 then
		
		return {

			advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,    
		
	
		}
	end
    return 
    {
        
    }
end
function modifier_Advanced_Voodoo_Restoration_heal:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return 100
end



function modifier_Advanced_Voodoo_Restoration_heal:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return 50
end






modifier_Advanced_Voodoo_Restoration_unlock3 = advanced_modifier({})
function modifier_Advanced_Voodoo_Restoration_unlock3:IsDebuff() return false end
function modifier_Advanced_Voodoo_Restoration_unlock3:IsHidden() return false end
function modifier_Advanced_Voodoo_Restoration_unlock3:IsPurgable() return false end
function modifier_Advanced_Voodoo_Restoration_unlock3:IsPurgeException() return false end
function modifier_Advanced_Voodoo_Restoration_unlock3:IsStunDebuff() return false end
function modifier_Advanced_Voodoo_Restoration_unlock3:RemoveOnDeath() return true end
function modifier_Advanced_Voodoo_Restoration_unlock3:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf" end
function modifier_Advanced_Voodoo_Restoration_unlock3:Advanced_GetModifierIncomingDamage_Percentage()	
	return -100
end
function modifier_Advanced_Voodoo_Restoration_unlock3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
