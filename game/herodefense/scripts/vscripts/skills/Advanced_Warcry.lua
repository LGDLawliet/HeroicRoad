
--战吼

Advanced_Warcry = class({})

LinkLuaModifier("modifier_Advanced_Warcry_active", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warcry_passive", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warcry_effect", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warcry_Winters_Coming", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Warcry_unlock3", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warcry_unlock3_target", "skills/Advanced_Warcry", LUA_MODIFIER_MOTION_NONE)
function Advanced_Warcry:CheckKV(key)
	local table = {
		bonus_move_speed=1,
		bonus_str=1,
		radius=10,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Warcry:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Warcry:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Warcry:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Warcry_unlock3",{})
	return true

end

function Advanced_Warcry:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8.vpcf", context )

	
end




function Advanced_Warcry:IsHiddenWhenStolen() 		return false end
function Advanced_Warcry:IsRefreshable() 			return true end
function Advanced_Warcry:IsStealable() 			return true end
function Advanced_Warcry:IsNetherWardStealable()	return true end
-- function Advanced_Warcry:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Advanced_Warcry:GetIntrinsicModifierName() return "modifier_Advanced_Warcry_passive" end
-- function Advanced_Warcry:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Advanced_Warcry:GetCastRange(vLocation, hTarget)
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local radius = self:GetSpecialValueFor("radius") + advanced_level * 10
	if advanced_level>=20 then
		radius = 10000
	end
	return radius
end

function Advanced_Warcry:GetBehavior()


	if self:GetCaster():HasModifier("modifier_Advanced_Warcry_unlock3") then

		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_Warcry:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if not target:IsRealHero() then
			return UF_FAIL_CUSTOM
		end
		if target==self:GetCaster() then
			return UF_FAIL_CUSTOM
		end
		local modifier = target:FindModifierByName("modifier_Advanced_Warcry_unlock3_target")
		if modifier and modifier:GetStackCount()>=5 then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
	
end
function Advanced_Warcry:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end

function Advanced_Warcry:OnSpellStart()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_Warcry_unlock3")
	if modifier then

		local target = self:GetCursorTarget()
		local modifier_target = target:FindModifierByName("modifier_Advanced_Warcry_unlock3_target")
		if modifier_target and modifier_target:GetStackCount()>=5 then
			return
		end
		target:AddNewModifier(caster, self, "modifier_Advanced_Warcry_unlock3_target", {})
		modifier:SafeDestroy()
		self.CoreUnlock = false
		self.unlock3 = false
		_G.CORE_current_count =math.max( _G.CORE_current_count - 1,0)
		self:EndCooldown()
		self:StartCooldown(5)
		local particleName = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx,0,target:GetOrigin())
		ParticleManager:SetParticleControl(pfx,1,Vector(325,325,325))
		DestroyParticleByDelay(pfx,10)
		caster:EmitSound("Hero_Riki.Smoke_Screen.ti8")
		return
	end
	local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
	local pfx_name2 = "particles/units/heroes/hero_sven/sven_warcry_buff_sven.vpcf"
	local sound_name = "Hero_Sven.WarCry"
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	caster:Purge(false, true, false, true, true)
	local radius = self:GetSpecialValueFor("radius")
	if self.advanced_level>=20 then
		radius = 10000
	end
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if self.unlock1 then
		local bonus = 0
		for _, ally in pairs(allies) do
			if ally~=caster then
				if ally:IsRealHero() then
					bonus = bonus +20
				else
					bonus = bonus + 1
				end
			end
			
		end
		local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
		for _, ally in pairs(allies) do
			local buff = ally:AddNewModifier(caster, self, "modifier_Advanced_Warcry_active", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain,bonus = bonus})
			local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, ally)
			buff:AddParticle(pfx, false, false, 15, false, false)
		end
	elseif self.unlock2 then
		local bonus = 0
		for _, ally in pairs(allies) do
			if ally~=caster then
				if ally:IsRealHero() then
					bonus = bonus +60
				else
					bonus = bonus + 3
				end
			end
			
		end
		local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
		local buff = caster:AddNewModifier(caster, self, "modifier_Advanced_Warcry_active", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain,bonus = bonus})
		local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, caster)
		buff:AddParticle(pfx, false, false, 15, false, false)

	else
		local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
		for _, ally in pairs(allies) do
			
			local buff = ally:AddNewModifier(caster, self, "modifier_Advanced_Warcry_active", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
			-- if not ally:IsCreep() then
			-- 	ally:CalculateStatBonus()
			-- end
			local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, ally)
			buff:AddParticle(pfx, false, false, 15, false, false)
		end
	end

end

modifier_Advanced_Warcry_active = advanced_modifier({})

function modifier_Advanced_Warcry_active:IsDebuff()			return false end
function modifier_Advanced_Warcry_active:IsHidden() 		return false end
function modifier_Advanced_Warcry_active:IsPurgable() 		return false end
function modifier_Advanced_Warcry_active:IsPurgeException() return self.canbe_purgable end
function modifier_Advanced_Warcry_active:DeclareFunctions() return 
	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	  MODIFIER_EVENT_ON_ATTACK_LANDED,
	  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

	} end

function modifier_Advanced_Warcry_active:GetModifierMagicalResistanceBonus() return self.magic_resistance * (self:GetStackCount()*0.01+1) end

function modifier_Advanced_Warcry_active:GetModifierMoveSpeedBonus_Percentage() return self.bonus_move_speed* (self:GetStackCount()*0.01+1) end
function modifier_Advanced_Warcry_active:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor* (self:GetStackCount()*0.01+1)  end
function modifier_Advanced_Warcry_active:GetModifierBonusStats_Strength() return self.bonus_str* (self:GetStackCount()*0.01+1) end
function modifier_Advanced_Warcry_active:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.magic_resistance = 0
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_status_resistance = 0
	--LV15解锁屹立不倒
	if self.advanced_level>=15 then
		self.magic_resistance = 20
		self.bonus_status_resistance = 35
		if IsServer() then

			if keys.bonus then
				self:SetStackCount(keys.bonus)
			end
		end
	end
	self.canbe_purgable = true
	--LV20解锁我们是冠军
	if self.advanced_level>=20 then
		self.canbe_purgable = false
	end
	-- if IsServer() then
		
	-- end
end

function modifier_Advanced_Warcry_active:OnRefresh(keys)
	self:OnCreated(keys)
end



function modifier_Advanced_Warcry_active:OnAttackLanded(keys)

	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	keys.target:AddNewModifier(keys.attacker, ability, "modifier_Advanced_Warcry_Winters_Coming", {duration = 3})
end

function modifier_Advanced_Warcry_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end

function modifier_Advanced_Warcry_active:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end




modifier_Advanced_Warcry_passive = advanced_modifier({})

function modifier_Advanced_Warcry_passive:IsHidden() return true end
function modifier_Advanced_Warcry_passive:IsAura() return true end
function modifier_Advanced_Warcry_passive:IsPurgable() 		return false end
function modifier_Advanced_Warcry_passive:IsPurgeException() 	return false end
function modifier_Advanced_Warcry_passive:RemoveOnDeath()  return false end
function modifier_Advanced_Warcry_passive:GetAuraDuration() return 0.5 end
function modifier_Advanced_Warcry_passive:GetModifierAura() return "modifier_Advanced_Warcry_effect" end
function modifier_Advanced_Warcry_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or 15000 end
function modifier_Advanced_Warcry_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Warcry_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Warcry_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_Advanced_Warcry_effect = advanced_modifier({})

function modifier_Advanced_Warcry_effect:IsDebuff()			return false end
function modifier_Advanced_Warcry_effect:IsHidden() 			return false end
function modifier_Advanced_Warcry_effect:IsPurgable() 			return false end
function modifier_Advanced_Warcry_effect:IsPurgeException() 	return false end
function modifier_Advanced_Warcry_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Warcry_effect:OnCreated(keys)
	self.advanced_level = 1
	self.bonus_index= 0.5
	self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self:StartIntervalThink(1)
end
function modifier_Advanced_Warcry_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	--LV5解锁守夜法印+
	if self.advanced_level>=5 then
		self.bonus_index = 0.75
	end
end


function modifier_Advanced_Warcry_effect:DeclareFunctions()
	return 	{MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end
function modifier_Advanced_Warcry_effect:GetModifierMoveSpeedBonus_Percentage() return self.bonus_move*self.bonus_index end
function modifier_Advanced_Warcry_effect:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor*self.bonus_index end
function modifier_Advanced_Warcry_effect:GetModifierBonusStats_Strength() return self.bonus_str*self.bonus_index end


function modifier_Advanced_Warcry_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end





modifier_Advanced_Warcry_Winters_Coming = advanced_modifier({})

function modifier_Advanced_Warcry_Winters_Coming:IsDebuff()			return true end
function modifier_Advanced_Warcry_Winters_Coming:IsHidden() 			return false end
function modifier_Advanced_Warcry_Winters_Coming:IsPurgable() 			return false end
function modifier_Advanced_Warcry_Winters_Coming:IsPurgeException() 	return false end
function modifier_Advanced_Warcry_Winters_Coming:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability then
		self.bonus_damage = 0
		return
	end
	local caster = self:GetCaster()

	local advanced_level = ability:GetSpecialValueFor("advanced_level")
	self.bonus_damage = 15
	--LV10解锁凛冬将至
	if advanced_level>=10 then
		self.bonus_damage = 22
	end

end
function modifier_Advanced_Warcry_Winters_Coming:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage
end

function modifier_Advanced_Warcry_Winters_Coming:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_Advanced_Warcry_unlock3 = class({})

function modifier_Advanced_Warcry_unlock3:IsDebuff()			return false end
function modifier_Advanced_Warcry_unlock3:IsHidden() 			return true end
function modifier_Advanced_Warcry_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Warcry_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Warcry_unlock3:RemoveOnDeath() return false end




modifier_Advanced_Warcry_unlock3_target = class({})

function modifier_Advanced_Warcry_unlock3_target:IsDebuff()			return false end
function modifier_Advanced_Warcry_unlock3_target:IsHidden() 			return false end
function modifier_Advanced_Warcry_unlock3_target:IsPurgable() 		return false end
function modifier_Advanced_Warcry_unlock3_target:IsPurgeException() 	return false end
function modifier_Advanced_Warcry_unlock3_target:RemoveOnDeath() return false end
function modifier_Advanced_Warcry_unlock3_target:OnCreated(keys)
	if IsServer() then
		self.count = 0
		self:IncrementStackCount()
	end
end
function modifier_Advanced_Warcry_unlock3_target:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Warcry_unlock3_target:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}

	return funcs
end

function modifier_Advanced_Warcry_unlock3_target:GetModifierBonusStats_Strength()	return self:GetStackCount()*100 end
function modifier_Advanced_Warcry_unlock3_target:GetModifierBonusStats_Intellect()	return self:GetStackCount()*100 end
function modifier_Advanced_Warcry_unlock3_target:GetModifierBonusStats_Agility()	return self:GetStackCount()*100 end

function modifier_Advanced_Warcry_unlock3_target:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if keys.attacker==self:GetParent() then
		self.count = self.count + self:GetStackCount()
		if self.count>=30 then
			local caster = self:GetCaster()
			self.count = self.count -30
			local parnet = self:GetParent()
			local healthPercent = parnet:GetHealthPercent()
		
			if healthPercent<=20 then
				-- 造成即死效果
				local particleName = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, parnet)
				ParticleManager:SetParticleControl(pfx,0,parnet:GetOrigin())
				ParticleManager:SetParticleControl(pfx,1,Vector(325,325,325))
				-- ParticleManager:ReleaseParticleIndex(pfx)
				DestroyParticleByDelay(pfx,5)
				caster:EmitSound("Hero_Riki.Smoke_Screen.ti8")
				TrueKill(caster, parnet, ability)
			else
				--普通背刺效果
				local particleName = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, parnet)
				ParticleManager:SetParticleControl(pfx,0,parnet:GetOrigin())
				ParticleManager:SetParticleControl(pfx,1,Vector(325,325,325))
				DestroyParticleByDelay(pfx,5)
				-- ParticleManager:ReleaseParticleIndex(pfx)
				caster:EmitSound("Hero_Riki.Smoke_Screen.ti8")
				parnet:ModifyHealth(1,ability,false,0)


			end
		end
	end

end