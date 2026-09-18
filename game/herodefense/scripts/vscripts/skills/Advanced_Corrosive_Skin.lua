--特效优化 √
Advanced_Corrosive_Skin = class({})
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_debuff", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_thinker", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_thinker_friendly", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_thinker_enemy", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_self", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Corrosive_Skin_unlock3", "skills/Advanced_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )

function Advanced_Corrosive_Skin:GetIntrinsicModifierName()
	return "modifier_Advanced_Corrosive_Skin"
end
function Advanced_Corrosive_Skin:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function Advanced_Corrosive_Skin:OnSpellStart()
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local i = 0
	for _,enemy in pairs(enemies) do
		enemy:RemoveModifierByNameAndCaster("modifier_hd_poison", self:GetCaster())
		i = i+1
	end
	local heal = i*self:GetSpecialValueFor("remove_heal")*0.01*self:GetCaster():GetMaxHealth()
	local fhealing =  HealWithGain(heal,self:GetCaster(),self:GetCaster(),self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
end
function Advanced_Corrosive_Skin:CheckKV(key)
	local table = {
		bonus_poison =0.03,
		poison =0.5,
		middle_heal =0.04
	}
	local value = table[key] or -1
	return value

end
function Advanced_Corrosive_Skin:UnlockFirstCore(key)
	return true
end
function Advanced_Corrosive_Skin:UnlockSecondCore(key)
	return true
end
function Advanced_Corrosive_Skin:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,nil,"modifier_Advanced_Corrosive_Skin_unlock3",{})
	return true
end

modifier_Advanced_Corrosive_Skin = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Corrosive_Skin:IsHidden()	return false end
function modifier_Advanced_Corrosive_Skin:IsPurgable()	return false end
function modifier_Advanced_Corrosive_Skin:IsPurgeException() return false end
function modifier_Advanced_Corrosive_Skin:RemoveOnDeath() return false end
function modifier_Advanced_Corrosive_Skin:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Corrosive_Skin:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
	self.advanced_level = self:GetAbility():GetSpecialValueFor( "advanced_level" )
	self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Corrosive_Skin_self",{})
end

function modifier_Advanced_Corrosive_Skin:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Advanced_Corrosive_Skin:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE={nil,self:GetParent()},
	}
	return funcs
end

function modifier_Advanced_Corrosive_Skin:OnTakeDamage( params )
	if not IsServer() then return end

	local caster = self:GetCaster()
	if params.unit~=caster then return end
	if caster:PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==caster:GetTeamNumber() then return end
	if params.attacker:IsMagicImmune() then return end

	local distance = (params.attacker:GetOrigin()-params.unit:GetOrigin()):Length2D()
	if distance>self.max_range then return end
	local ability = self:GetAbility()
	if ability.unlock2 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
		params.attacker:AddNewModifier(caster, ability, "modifier_Advanced_Corrosive_Skin_debuff", { duration = self.duration*ModifierStatusNegativeGain} )
	else
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = params.attacker:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain
		-- add debuff
		params.attacker:AddNewModifier(caster, ability, "modifier_Advanced_Corrosive_Skin_debuff", { duration = self.duration*StatusResistance } )
	end
	

	local sound_cast = "hero_viper.CorrosiveSkin"
	EmitSoundOn( sound_cast, params.attacker )

	self:SetStackCount(self:GetStackCount()+params.damage)
	local need = caster:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("line")*0.01
	if self:GetStackCount() >= need and self:GetRemainingTime() <=0 then
		self:SetStackCount(0)
		self:SetDuration(self:GetAbility():GetSpecialValueFor("middle_duration"),true)

		local pos = caster:GetAbsOrigin()
        CreateModifierThinker(caster, self:GetAbility(), "modifier_Middle_Corrosive_Skin_thinker", 
        {duration = self:GetAbility():GetSpecialValueFor("middle_duration")}, pos, caster:GetTeamNumber(), false)
	end
end



modifier_Advanced_Corrosive_Skin_debuff = advanced_modifier({})


function modifier_Advanced_Corrosive_Skin_debuff:IsHidden()	return false end
function modifier_Advanced_Corrosive_Skin_debuff:IsDebuff()	return true end
function modifier_Advanced_Corrosive_Skin_debuff:IsStunDebuff()	return false end
function modifier_Advanced_Corrosive_Skin_debuff:IsPurgable()	return false end

function modifier_Advanced_Corrosive_Skin_debuff:OnCreated( kv )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor( "attack_speed_down" )
	if not IsServer() then return end
	self:StartIntervalThink(1)

end

function modifier_Advanced_Corrosive_Skin_debuff:OnRefresh( kv )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor( "attack_speed_down" )
end

function modifier_Advanced_Corrosive_Skin_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_Advanced_Corrosive_Skin_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.slow
end
function modifier_Advanced_Corrosive_Skin_debuff:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()
end

function modifier_Advanced_Corrosive_Skin_debuff:OnIntervalThink()
	local poison = self:GetAbility():GetSpecialValueFor( "poison" )+self:GetAbility():GetSpecialValueFor( "bonus_poison" )*self:GetCaster():GetStrength()
	if self:GetAbility().unlock1 then
		poison = poison * 5
	end
	self:GetParent():Poison(self:GetCaster(), self:GetAbility(), poison)
	--新LV10慢性腐蚀
	--新LV20慢性腐蚀+
	if self:GetAbility().advanced_level >= 10 and self:GetAbility().advanced_level < 20  then
		self:SetStackCount(self:GetStackCount() + 1)
		
	else
		if self:GetAbility().advanced_level >= 20 then
			self:SetStackCount(self:GetStackCount() + 2)
		end
	end
end

function modifier_Advanced_Corrosive_Skin_debuff:GetEffectName()	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf" end
function modifier_Advanced_Corrosive_Skin_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Corrosive_Skin_debuff:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_StatusResistance)
	end
    return funcs
end

function modifier_Advanced_Corrosive_Skin_debuff:Advanced_GetModifier_StatusResistance(keys)
	return -60
end


--------------------------------------------------------------------------------





modifier_Advanced_Corrosive_Skin_thinker = class({})

function modifier_Advanced_Corrosive_Skin_thinker:RemoveOnDeath() return true end
function modifier_Advanced_Corrosive_Skin_thinker:IsAura()

	return true
end

function modifier_Advanced_Corrosive_Skin_thinker:GetModifierAura()	return "modifier_Advanced_Corrosive_Skin_thinker_friendly" end
function modifier_Advanced_Corrosive_Skin_thinker:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("middle_radius")  end
function modifier_Advanced_Corrosive_Skin_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Corrosive_Skin_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Corrosive_Skin_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Corrosive_Skin_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.poison = self:GetAbility():GetSpecialValueFor( "poison" )+self:GetAbility():GetSpecialValueFor( "bonus_poison" )*self:GetCaster():GetStrength()
        self.radius = self:GetAbility():GetSpecialValueFor("middle_radius")

        self:StartIntervalThink(0.3)
        self.caster = ability:GetCaster()
        self.ability = ability

		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/nethertoxin_with_radius/hethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 61, Vector(self.radius, self.radius/400, 0))

		self:AddParticle(pfx, false, false, 15, false, false)
        self.team = self.caster:GetTeamNumber()
	end
end

function modifier_Advanced_Corrosive_Skin_thinker:OnIntervalThink()
	local caster = self.caster
	local enemies = FindUnitsInRadius(self.team, self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Corrosive_Skin_thinker_enemy",{duration = 0.35})
	end
end



function modifier_Advanced_Corrosive_Skin_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end





modifier_Advanced_Corrosive_Skin_thinker_friendly = advanced_modifier({})
function modifier_Advanced_Corrosive_Skin_thinker_friendly:IsHidden()	return true end
function modifier_Advanced_Corrosive_Skin_thinker_friendly:IsDebuff()	return false end
function modifier_Advanced_Corrosive_Skin_thinker_friendly:IsPurgable()	return false end
function modifier_Advanced_Corrosive_Skin_thinker_friendly:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Corrosive_Skin_thinker_friendly:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end


function modifier_Advanced_Corrosive_Skin_thinker_friendly:AdvancedGetModifierConstantHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("middle_heal")
end


modifier_Advanced_Corrosive_Skin_thinker_enemy = advanced_modifier({})
function modifier_Advanced_Corrosive_Skin_thinker_enemy:IsHidden()	return false end
function modifier_Advanced_Corrosive_Skin_thinker_enemy:IsDebuff()	return true end
function modifier_Advanced_Corrosive_Skin_thinker_enemy:IsPurgable()	return false end

function modifier_Advanced_Corrosive_Skin_thinker_enemy:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

--新LV5腐毒迸发+
function modifier_Advanced_Corrosive_Skin_thinker_enemy:GetModifierMagicalResistanceBonus()
	local magic_resist_down = self:GetAbility():GetSpecialValueFor("magic_resist_down")
	if self:GetAbility().advanced_level >=5 then
		magic_resist_down = 30
	end

	return -magic_resist_down
end



--------------------
modifier_Advanced_Corrosive_Skin_self = advanced_modifier({})


function modifier_Advanced_Corrosive_Skin_self:IsHidden()	return true end
function modifier_Advanced_Corrosive_Skin_self:IsPurgable()	return false end
function modifier_Advanced_Corrosive_Skin_self:IsPurgeException() return false end
function modifier_Advanced_Corrosive_Skin_self:RemoveOnDeath() return false end
function modifier_Advanced_Corrosive_Skin_self:OnCreated() 
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_Advanced_Corrosive_Skin_self:OnIntervalThink()
	--新LV15毒血
	if self:GetAbility().advanced_level>=15 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end
function modifier_Advanced_Corrosive_Skin_self:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_Corrosive_Skin_self:Advanced_GetModifierIncomingDamage_Percentage()
	if self:GetCaster():PassivesDisabled() then return 0 end
	return -50*self:GetStackCount()
end

function modifier_Advanced_Corrosive_Skin_self:OnTakeDamage(keys)
	--新LV15毒血
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() then
		return
	end
	
	if self:GetAbility().advanced_level>=15 then
		local caster = self:GetCaster()
		if keys.unit~=caster then return end
		if caster:PassivesDisabled() then return end
		local poison_self = keys.damage*0.6--备注：takedamage拿到的是减伤计算后的数据，所以这里实际上要写0.6才是30%

		local poison = caster:FindModifierByName("modifier_hd_poison")
		if poison then
			if poison:GetStackCount()>= 999999 then
				return
			end
		end
		caster:Poison(self:GetCaster(), self:GetAbility(), poison_self)
	end
	
end

modifier_Advanced_Corrosive_Skin_unlock3 = advanced_modifier({})

function modifier_Advanced_Corrosive_Skin_unlock3:IsDebuff()			return false end
function modifier_Advanced_Corrosive_Skin_unlock3:IsHidden() 			return true end
function modifier_Advanced_Corrosive_Skin_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Corrosive_Skin_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Corrosive_Skin_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Corrosive_Skin_unlock3:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


-- advanced_modifier
function modifier_Advanced_Corrosive_Skin_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_Advanced_Corrosive_Skin_unlock3:Advanced_GetModifier_NegativeDurationGain(keys)
	return 45 
end
