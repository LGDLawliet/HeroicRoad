--特效优化 √
Advanced_fear_arua = class({})
LinkLuaModifier( "modifier_Advanced_fear_arua", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_fear_arua_effect", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_fear_arua_debuff", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_fear_arua_force_debuff", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_fear_arua_force_debuff2", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_fear_arua_unlock1_debuff", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_fear_arua_unlock2", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_hyakkiyakou_unlock2_effect", "skills/Advanced_fear_arua", LUA_MODIFIER_MOTION_NONE )
function Advanced_fear_arua:IsRefreshable()
	return false
end

function Advanced_fear_arua:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/bugs/bug.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/bugs/bug2.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/fear_arua/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf", context )




	
end
function Advanced_fear_arua:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_fear_arua:UnlockSecondCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_fear_arua:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_fear_arua:GetBehavior()
	if self:GetUnlock(1)==1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function Advanced_fear_arua:GetManaCost(level)
	if self:GetUnlock(1)==1 then
		return 200
	end
	return 0
end

function Advanced_fear_arua:GetCooldown(iLevel)
	if self:GetUnlock(1)==1 then
		return 30 /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
	end
	return 0
end



function Advanced_fear_arua:CheckKVFixedOverride(key)
	if key=="bonus_damage" then
		if self:GetUnlock(3)==3 then
			return 35
		end
	end

	return -999999

end


function Advanced_fear_arua:CheckKV(key)
	local table = {
		bonus_damage	 = 0.3,
		bonus_damage_resistance = 0.3,
	}
	local value = table[key] or -1
	return value
end

function Advanced_fear_arua:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if self.unlock1 then
		caster:EmitSound("Hero_Nightstalker.CripplingFear.Aura.TI10")
		target:AddNewModifier(caster, self, "modifier_Advanced_fear_arua_unlock1_debuff", {duration =5})
	end

end

-- require('internal/timers')   --计时器功能
function Advanced_fear_arua:GetIntrinsicModifierName()
	return "modifier_Advanced_fear_arua"
end

function Advanced_fear_arua:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_Advanced_fear_arua = advanced_modifier({})

function modifier_Advanced_fear_arua:IsHidden()	return true end
function modifier_Advanced_fear_arua:IsDebuff()	return false end
function modifier_Advanced_fear_arua:IsPurgable()	return false end
function modifier_Advanced_fear_arua:IsPurgeException() return false end
function modifier_Advanced_fear_arua:RemoveOnDeath() return false end
function modifier_Advanced_fear_arua:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_fear_arua:GetModifierAura()	return "modifier_Advanced_fear_arua_effect" end
function modifier_Advanced_fear_arua:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Advanced_fear_arua:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_fear_arua:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_fear_arua:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Advanced_fear_arua:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/bugs/bug.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end

function modifier_Advanced_fear_arua:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/bugs/bug.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if ability and not ability:IsNull() and ability.advanced_level>=15 then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #units<=3 then
				for _, unit in ipairs(units) do
					if not unit:IsNull() and unit:IsAlive() then
						unit:AddNewModifier(caster, ability, "modifier_Advanced_fear_arua_force_debuff", {duration = 1})
					end
				end
			end
		end

	end
end


modifier_Advanced_fear_arua_effect = advanced_modifier({})
function modifier_Advanced_fear_arua_effect:IsHidden()	return false end
function modifier_Advanced_fear_arua_effect:IsDebuff()	return true end
function modifier_Advanced_fear_arua_effect:IsPurgable()	return false end
-- function modifier_Advanced_fear_arua_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_fear_arua_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,  

	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		table.insert(funcs,MODIFIER_EVENT_ON_DEATH)
	end
	-- if self:GetAbility():GetUnlock(3)==3 then
	-- 	table.insert(funcs,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	-- end

	return funcs
end

function modifier_Advanced_fear_arua_effect:OnCreated(keys)

	if IsServer() then
		self.max_stack = 50
		self.perstack = 1
		self.chance = 5
		local ability = self:GetAbility()
		if ability.advanced_level>=5 then
			self.chance = 7
			if ability.advanced_level>=10 then
				self.perstack = 2
			end
		end
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_fear_arua_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	if self:GetStackCount()<self.max_stack then
		self:SetStackCount(math.min(self:GetStackCount()+self.perstack,self.max_stack))
	end
	if self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1)  >=RandomInt(1, 100) then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, ability, "modifier_Advanced_fear_arua_debuff", {duration = 3*StatusResistance})
		target:EmitSound("Hero_DarkWillow.ProjectileImpact")
	end

end

function modifier_Advanced_fear_arua_effect:GetModifierBaseDamageOutgoing_Percentage()	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return 0
	end
	return -ability:GetSpecialValueFor("bonus_damage") * (1+self:GetStackCount()*0.01)
end
function modifier_Advanced_fear_arua_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return 0
	end
	return ability:GetSpecialValueFor("bonus_damage_resistance") * (1+self:GetStackCount()*0.01)
end

function modifier_Advanced_fear_arua_effect:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
        local caster = self:GetCaster()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if not unit:IsNull() then
				unit:AddNewModifier(caster, ability, "modifier_Advanced_fear_arua_force_debuff2", {duration = 20})
			end
		end
    end
end



-- advanced_modifier
function modifier_Advanced_fear_arua_effect:ADDeclareFunctions()
	local funcs = {
        -- advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs

end
function modifier_Advanced_fear_arua_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		-- print("aaaaaaaa")
		if 1==RandomInt(1, 10) then
			-- print("success")
			return -1000
		end
	end

end





modifier_Advanced_fear_arua_debuff = advanced_modifier({})
function modifier_Advanced_fear_arua_debuff:IsHidden()	return false end
function modifier_Advanced_fear_arua_debuff:IsDebuff()	return true end
function modifier_Advanced_fear_arua_debuff:IsPurgable()	return true end
-- function modifier_Advanced_fear_arua_debuff:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_fear_arua_debuff:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf" end
function modifier_Advanced_fear_arua_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Advanced_fear_arua_debuff:Advanced_GetModifierIncomingDamage_Percentage()	
	return 25
end


function modifier_Advanced_fear_arua_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end















modifier_Advanced_fear_arua_force_debuff = advanced_modifier({})
function modifier_Advanced_fear_arua_force_debuff:IsHidden()	return false end
function modifier_Advanced_fear_arua_force_debuff:IsDebuff()	return true end
function modifier_Advanced_fear_arua_force_debuff:IsPurgable()	return true end
-- function modifier_Advanced_fear_arua_force_debuff:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_fear_arua_force_debuff:GetEffectName() return "particles/rebuild/spell/bugs/bug2.vpcf" end
function modifier_Advanced_fear_arua_force_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Advanced_fear_arua_force_debuff:OnCreated()	
	if IsClient() then
		return
	end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/bugs/bug2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
end

function modifier_Advanced_fear_arua_force_debuff:OnDestroy()	
	if IsClient() then
		return
	end
	ParticleManager:DestroyParticle(self.nFXIndex, true)
	ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	self.nFXIndex = nil
end

-- advanced_modifier
function modifier_Advanced_fear_arua_force_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_Advanced_fear_arua_force_debuff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -30
end


function modifier_Advanced_fear_arua_force_debuff:Advanced_GetModifier_StatusResistance(keys)
	return -30
end














modifier_Advanced_fear_arua_force_debuff2 = advanced_modifier({})

function modifier_Advanced_fear_arua_force_debuff2:IsHidden()	return false end
function modifier_Advanced_fear_arua_force_debuff2:IsDebuff()	return true end
function modifier_Advanced_fear_arua_force_debuff2:IsPurgable()	return false end
function modifier_Advanced_fear_arua_force_debuff2:OnCreated(params)

	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)


	end
end
function modifier_Advanced_fear_arua_force_debuff2:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 10 then
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

function modifier_Advanced_fear_arua_force_debuff2:OnIntervalThink()
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

function modifier_Advanced_fear_arua_force_debuff2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Advanced_fear_arua_force_debuff2:Advanced_GetModifier_StatusResistance(keys)
	return -self:GetStackCount()*5
end



modifier_Advanced_fear_arua_unlock1_debuff = advanced_modifier({})

function modifier_Advanced_fear_arua_unlock1_debuff:IsHidden()	return false end
function modifier_Advanced_fear_arua_unlock1_debuff:IsDebuff()	return true end
function modifier_Advanced_fear_arua_unlock1_debuff:IsPurgable()	return false end
function modifier_Advanced_fear_arua_unlock1_debuff:IsPurgeException() return false end
-- function modifier_Advanced_fear_arua_unlock1_debuff:RemoveOnDeath() return false end

function modifier_Advanced_fear_arua_unlock1_debuff:OnCreated(keys)
	if IsServer() then
	
		self:GetParent():EmitSound("Hero_Nightstalker.Trickling_Fear_lp")
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fear_arua/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(10,0,0) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		-- self:StartIntervalThink(0.5)
	end

end
function modifier_Advanced_fear_arua_unlock1_debuff:OnDestroy()

	if IsServer() then
		self:GetParent():StopSound("Hero_Nightstalker.Trickling_Fear_lp")
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(1,0,0) )
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end


function modifier_Advanced_fear_arua_unlock1_debuff:Advanced_GetModifierIncomingDamage_Percentage()	
	return 150
end


function modifier_Advanced_fear_arua_unlock1_debuff:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}

	return state
end


function modifier_Advanced_fear_arua_unlock1_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end















modifier_Advanced_fear_arua_unlock2 = advanced_modifier({})

function modifier_Advanced_fear_arua_unlock2:IsHidden()	return true end
function modifier_Advanced_fear_arua_unlock2:IsDebuff()	return false end
function modifier_Advanced_fear_arua_unlock2:IsPurgable()	return false end
function modifier_Advanced_fear_arua_unlock2:IsPurgeException() return false end
function modifier_Advanced_fear_arua_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_fear_arua_unlock2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		

		if unit:IsInsect() then
			local gain = self:GetParent():GetSummonIntensityIndex(1)
			if gain>0 then
				self.should_remove_gain = true
			end
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_hyakkiyakou_unlock2_effect", {})
		end
	end
end
--归置
function modifier_Advanced_fear_arua_unlock2:OnSummonUnitFinished(keys)
	if IsServer() then
		if self.should_remove_gain then
			self.should_remove_gain  = false
		end
		
	end
end



-- advanced_modifier
function modifier_Advanced_fear_arua_unlock2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity_Final_Percentage,
    }
end
function modifier_Advanced_fear_arua_unlock2:Advanced_GetModifier_Summon_Intensity_Final_Percentage(keys)
	if self.should_remove_gain then
		return 50
	end
	return 0
end






modifier_Advanced_hyakkiyakou_unlock2_effect = advanced_modifier({})

function modifier_Advanced_hyakkiyakou_unlock2_effect:IsHidden()	return false end
function modifier_Advanced_hyakkiyakou_unlock2_effect:IsDebuff()	return false end
function modifier_Advanced_hyakkiyakou_unlock2_effect:IsPurgable()	return false end
function modifier_Advanced_hyakkiyakou_unlock2_effect:IsPurgeException() return false end
-- function modifier_Advanced_fear_arua_unlock1_debuff:RemoveOnDeath() return false end

function modifier_Advanced_hyakkiyakou_unlock2_effect:OnCreated(keys)
	if IsServer() then
	
		-- self:GetParent():EmitSound("Hero_Nightstalker.Trickling_Fear_lp")
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(10,0,0) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		-- self:StartIntervalThink(0.5)
	end

end
function modifier_Advanced_hyakkiyakou_unlock2_effect:OnDestroy()

	if IsServer() then
		-- self:GetParent():StopSound("Hero_Nightstalker.Trickling_Fear_lp")
		-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(1,0,0) )
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end

-- function modifier_Advanced_hyakkiyakou_unlock2_effect:DeclareFunctions()
-- 	local funcs = {


-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   	   --受到伤害增加

-- 	}

-- 	return funcs
-- end


-- function modifier_Advanced_hyakkiyakou_unlock2_effect:GetModifierTotalDamageOutgoing_Percentage()	
-- 	return 40
-- end

-- advanced_modifier
function modifier_Advanced_hyakkiyakou_unlock2_effect:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_hyakkiyakou_unlock2_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 40
end
