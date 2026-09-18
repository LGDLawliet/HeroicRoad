
LinkLuaModifier( "modifier_FellOmen_Bad_3_active", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_4_attack", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_6_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_ChallengeInfo_010_debuff", "modifier/modifier_challenge", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_9_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_11_debuff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_12_debuff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_13_debuff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )








LinkLuaModifier( "modifier_FellOmen_Good_11", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )



LinkLuaModifier( "modifier_FellOmen_Good_3_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_FellOmen_Good_11_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_FellOmen_Bad_14_debuff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_14_buff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_15_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_FellOmen_Bad_16_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_17_infest", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_17_infest_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_18_effect", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_FellOmen_Bad_18_buff", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_thinker_INVULNERABLE", "modifier/modifier_thinker_INVULNERABLE", LUA_MODIFIER_MOTION_NONE )


require('internal/timers')   --计时器功能

-- modifier_FellOmen_Bad_1 = advanced_modifier({})

-- function modifier_FellOmen_Bad_1:IsHidden()return false end
-- function modifier_FellOmen_Bad_1:IsDebuff()return true end
-- function modifier_FellOmen_Bad_1:IsPurgable()return false end
-- function modifier_FellOmen_Bad_1:IsPurgeException() 	return false end
-- function modifier_FellOmen_Bad_1:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_1:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- -- function modifier_FellOmen_Bad_1:GetTexture() return "modifier_illusion" end
-- function modifier_FellOmen_Bad_1:OnCreated(keys)
--     if IsServer() then
--         print("被创建")
--         local unit = self:GetParent()
--         local bonus = 0.3
--         local bonus_stack = 0.05
--         local index =1+ bonus + bonus_stack* keys.level
--         unit:SetBaseDamageMax(unit:GetBaseDamageMax()*index)
--         unit:SetBaseDamageMin(unit:GetBaseDamageMin()*index)
--     end
-- end





function GetLevel(name)
    return CustomNetTables:GetTableValue( "fellOmenInfo", name).level
end


modifier_FellOmen_Bad_2 = advanced_modifier({})

function modifier_FellOmen_Bad_2:IsHidden()return true end
function modifier_FellOmen_Bad_2:IsDebuff()return true end
function modifier_FellOmen_Bad_2:IsPurgable()return false end
function modifier_FellOmen_Bad_2:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_2:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_2:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_2:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus = 18
    local bonus_stack = 4
    local max = 50
    self.bonus =math.min( max,bonus + bonus_stack*level)

    if IsServer() then
       self:StartIntervalThink(1)
    end
end

function modifier_FellOmen_Bad_2:OnIntervalThink()
    if self:GetParent():IsInDayTime() then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
end

function modifier_FellOmen_Bad_2:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

} end
function modifier_FellOmen_Bad_2:GetModifierMagicalResistanceBonus() return self:GetStackCount()==1 and self.bonus or 0 end






modifier_FellOmen_Bad_3 = advanced_modifier({})

function modifier_FellOmen_Bad_3:IsHidden()return true end
function modifier_FellOmen_Bad_3:IsDebuff()return true end
function modifier_FellOmen_Bad_3:IsPurgable()return false end
function modifier_FellOmen_Bad_3:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_3:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_3:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_3:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus = 0.05
    local bonus_stack = 0.01
    -- local max = 50
    -- self.bonus =math.min( max,bonus + bonus_stack*level)
    self.bonus = bonus + bonus_stack*level
end
function modifier_FellOmen_Bad_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end



function modifier_FellOmen_Bad_3:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
        -- keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 10})
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for i, unit in pairs(units) do
			if unit~=parent and unit:IsAlive() then
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				-- ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
                ParticleManager:SetParticleControlEnt(particle, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex(particle)
				local aiblity = self:GetAbility()
				local fbonus_health = self.bonus*parent:GetMaxHealth()
				local fbonus_damage = self.bonus*parent:GetDamageMax()
				local fbonus_armor =self.bonus*parent:GetPhysicalArmorBaseValue()

				unit:AddNewModifier(unit, aiblity, "modifier_FellOmen_Bad_3_active", {bonus_health=fbonus_health,bonus_damage=fbonus_damage,bonus_armor=fbonus_armor})

		
				break
			end

			  	   
		   end

    end
   
end







modifier_FellOmen_Bad_3_active = advanced_modifier({})

function modifier_FellOmen_Bad_3_active:IsDebuff() return false end
function modifier_FellOmen_Bad_3_active:IsHidden() return true end
function modifier_FellOmen_Bad_3_active:IsPurgable() return false end
function modifier_FellOmen_Bad_3_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_FellOmen_Bad_3_active:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_3_active:GetTexture() return "death_prophet_spirit_siphon" end
function modifier_FellOmen_Bad_3_active:OnCreated(keys)
	self.bonus_health = 10
	self.bonus_damage = 1
	self.bonus_armor = 1
	local parent = self:GetParent()


	self.bonus_damage = keys.bonus_damage
	
		-- 	self.bonus_armor = keys.bonus_armor


		-- end)
	if IsServer() then
		-- print(keys.bonus_damage)
		-- print(keys.bonus_health)
		-- print(keys.bonus_armor)
		-- parent:SetMaxHealth(parent:GetMaxHealth()+keys.bonus_health)
		-- parent:SetPhysicalArmorBaseValue(parent:GetPhysicalArmorBaseValue()+self.bonus_armor )
		parent:EmitSound("Hero_Nightstalker.Hunter.Target")
		IncreaseHealth(parent,keys.bonus_health)
		IncreaseArmor(parent, keys.bonus_armor)
	

	end
end
function modifier_FellOmen_Bad_3_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_FellOmen_Bad_3_active:GetModifierBaseAttack_BonusDamage()	return self.bonus_damage end








modifier_FellOmen_Bad_4 = advanced_modifier({})

function modifier_FellOmen_Bad_4:IsDebuff() return false end
function modifier_FellOmen_Bad_4:IsHidden() return true end
function modifier_FellOmen_Bad_4:IsPurgable() 		return false end
function modifier_FellOmen_Bad_4:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_4:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_4:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 80
		local bonus_stack = 16
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = (bonus + bonus_stack*level)*0.01

	end
end

function modifier_FellOmen_Bad_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end


function modifier_FellOmen_Bad_4:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end


	local stack =(100- keys.target:GetHealthPercent())*self.bonus
	keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_FellOmen_Bad_4_attack", {duration = 1,stack = stack})

end




function modifier_FellOmen_Bad_4:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount()*5 end


modifier_FellOmen_Bad_4_attack = advanced_modifier({})
function modifier_FellOmen_Bad_4_attack:IsHidden()	return true end
function modifier_FellOmen_Bad_4_attack:IsDebuff()	return false end
function modifier_FellOmen_Bad_4_attack:IsPurgable()	return false end

function modifier_FellOmen_Bad_4_attack:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_FellOmen_Bad_4_attack:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_FellOmen_Bad_4_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

	}
end

function modifier_FellOmen_Bad_4_attack:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount() end


modifier_FellOmen_Bad_5 = advanced_modifier({})

function modifier_FellOmen_Bad_5:IsDebuff() return false end
function modifier_FellOmen_Bad_5:IsHidden() return true end
function modifier_FellOmen_Bad_5:IsPurgable() 		return false end
function modifier_FellOmen_Bad_5:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_5:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_5:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 1
		local bonus_stack = 0.2
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = bonus + bonus_stack*level

	end
end

function modifier_FellOmen_Bad_5:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_FellOmen_Bad_5:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
		local target = keys.attacker
		if not target or target:IsMagicImmune() or target:IsInvulnerable() then
			return
		end
		target:AddNewModifier(parent, self:GetAbility(), "modifier_ChallengeInfo_010_debuff", {duration = self.bonus})
		target:EmitSound("Hero_Silencer.LastWord.Cast")


    end
   
end



modifier_FellOmen_Bad_6 = advanced_modifier({})

function modifier_FellOmen_Bad_6:IsDebuff() return false end
function modifier_FellOmen_Bad_6:IsHidden() return true end
function modifier_FellOmen_Bad_6:IsPurgable() 		return false end
function modifier_FellOmen_Bad_6:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_6:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_6:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 0.15
		local bonus_stack = 0.02
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = bonus + bonus_stack*level
		self:StartIntervalThink(10)

	end
end
function modifier_FellOmen_Bad_6:OnIntervalThink()
	if 5>=RandomInt(1, 100) then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_FellOmen_Bad_6_effect") then
			return
		end
		local tartget = FindStrongestEnemyInRangeAndPosition( parent,parent:GetAbsOrigin(), 1000,DOTA_UNIT_TARGET_FLAG_NONE )

		-- local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,
		-- 1000, DOTA_UNIT_TARGET_TEAM_ENEMY,
		--  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		--   DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if tartget then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Bad_6_effect", {duration = 5,target=tartget:entindex(),damage_index = self.bonus})
		end

		
	end
end




modifier_FellOmen_Bad_6_effect = advanced_modifier({})

function modifier_FellOmen_Bad_6_effect:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/fellomen_bad_6/link_blue.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf", context )
end

function modifier_FellOmen_Bad_6_effect:IsDebuff() return false end
function modifier_FellOmen_Bad_6_effect:IsHidden() return false end
function modifier_FellOmen_Bad_6_effect:IsPurgable() 		return false end
function modifier_FellOmen_Bad_6_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_6_effect:RemoveOnDeath()  return true end
function modifier_FellOmen_Bad_6_effect:GetTexture() return "warlock_fatal_bonds" end
function modifier_FellOmen_Bad_6_effect:OnCreated(keys)
	if IsServer() then
		self.damage = keys.damage_index
		self.target = EntIndexToHScript(keys.target)
		local parent = self:GetParent()
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/fellomen_bad_6/link_blue.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1,self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		parent:EmitSound("Hero_Grimstroke.SoulChain.Target")
	end
end



function modifier_FellOmen_Bad_6_effect:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
	}
end

function modifier_FellOmen_Bad_6_effect:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit


		if not attacker then
			return
		end
		if unit~=self:GetParent() then	return end
		if attacker:GetTeam()==unit:GetTeam() then
			return
		end
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		if keys.damage<=10 then return	end


		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		local damage = keys.damage *self.damage
		self:SetStackCount(self:GetStackCount()+damage)

		

 
    end 
end


function modifier_FellOmen_Bad_6_effect:OnDestroy()

	if IsServer() then
		local stack = self:GetStackCount()
		ParticleManager:DestroyParticle(self.pfx,false)
		if not self.target or self.target:IsNull()then
			return
		end
		if not self.target:IsAlive() or self.target:IsMagicImmune() then
			return
		end
		local parent = self:GetParent()
		if not parent or not parent:IsAlive() then
			return
		end
		if stack>=10 then
			local damageTable = {
				victim = self.target,
				attacker = parent,
				damage = stack,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT
				+DOTA_DAMAGE_FLAG_REFLECTION
				+DOTA_DAMAGE_FLAG_HPLOSS
				+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
				-- ability = self:GetAbility(), --Optional.
				}
			ApplyDamage(damageTable)

			local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
			ParticleManager:SetParticleControl( effect_cast, 0,self.target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			self.target:EmitSound("Hero_Undying.SoulRip.Cast")
		end
	end
end







modifier_FellOmen_Bad_7 = advanced_modifier({})

function modifier_FellOmen_Bad_7:IsDebuff() return false end
function modifier_FellOmen_Bad_7:IsHidden() return true end
function modifier_FellOmen_Bad_7:IsPurgable() 		return false end
function modifier_FellOmen_Bad_7:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_7:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_7:OnCreated(keys)
	local level = GetLevel(self:GetName())
	local bonus = 30
	local bonus_stack = 5
	local bonus2 = 20
	local bonus_stack2 = 4
	local max = 70

	self.bonus = bonus + bonus_stack*level
	self.bonus2 =math.min( max,bonus2 + bonus_stack2*level)
	if IsServer() then
		self:StartIntervalThink(0.5)

	end
end
function modifier_FellOmen_Bad_7:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=15 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end
function modifier_FellOmen_Bad_7:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,     

	}
end

function modifier_FellOmen_Bad_7:GetModifierMagicalResistanceBonus() 
	if self:GetStackCount()==1 then
		return self.bonus2
	end
	return 0
end


function modifier_FellOmen_Bad_7:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_FellOmen_Bad_7:Advanced_GetModifierPhysicalArmorBonus()
	if self:GetStackCount()==1 then
		return self.bonus
	end
    return 0
end




modifier_FellOmen_Bad_8 = advanced_modifier({})

function modifier_FellOmen_Bad_8:IsDebuff() return false end
function modifier_FellOmen_Bad_8:IsHidden() return true end
function modifier_FellOmen_Bad_8:IsPurgable() 		return false end
function modifier_FellOmen_Bad_8:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_8:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_8:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 25
		local bonus_stack = 4
		local index = bonus + bonus_stack*level
		self:SetStackCount(index)


	end
end



function modifier_FellOmen_Bad_8:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_FellOmen_Bad_8:Advanced_GetModifier_StatusResistance(keys)
	return -self:GetStackCount()
end




modifier_FellOmen_Bad_9 = advanced_modifier({})


function modifier_FellOmen_Bad_9:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
end
function modifier_FellOmen_Bad_9:IsHidden()return true end
function modifier_FellOmen_Bad_9:IsDebuff()return true end
function modifier_FellOmen_Bad_9:IsPurgable()return false end
function modifier_FellOmen_Bad_9:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_9:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_9:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_9:GetTexture() return "modifier_illusion" end

function modifier_FellOmen_Bad_9:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_FellOmen_Bad_9:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
		local pos = parent:GetAbsOrigin()
        -- keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 10})
		local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil, 500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		
		ParticleManager:SetParticleControl( effect_cast, 0,pos )
		ParticleManager:SetParticleControl( effect_cast, 0,Vector(500,0,0) )
		pos.z = pos.z +64
		ParticleManager:SetParticleControl( effect_cast, 2,pos )
		ParticleManager:ReleaseParticleIndex(effect_cast)
		parent:EmitSound("Hero_Batrider.StickyNapalm.Impact")
		for i, unit in pairs(units) do
			local StatusResistance = unit:GetHDStatusResistanceIndex(1)
			unit:AddNewModifier(unit, nil, "modifier_FellOmen_Bad_9_effect", {duration = 6*StatusResistance})
		end

    end
   
end




modifier_FellOmen_Bad_9_effect = advanced_modifier({})

function modifier_FellOmen_Bad_9_effect:IsDebuff() return true end
function modifier_FellOmen_Bad_9_effect:IsHidden() return false end
function modifier_FellOmen_Bad_9_effect:IsPurgable() 		return false end
function modifier_FellOmen_Bad_9_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_9_effect:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_9_effect:GetTexture() return "batrider_sticky_napalm" end
function modifier_FellOmen_Bad_9_effect:OnCreated(keys)
	local level = GetLevel("modifier_FellOmen_Bad_9")

	local bonus = 15
	local bonus_stack = 3
	local bonus2 = 20
	local bonus_stack2 = 4
	self.bonus = bonus + bonus_stack*level
	self.bonus2 = bonus2 + bonus_stack2 * level


	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_FellOmen_Bad_9_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_FellOmen_Bad_9_effect:OnIntervalThink()
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

function modifier_FellOmen_Bad_9_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}
end
function modifier_FellOmen_Bad_9_effect:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount()*self.bonus2 end
function modifier_FellOmen_Bad_9_effect:GetModifierMoveSpeedBonus_Percentage() return -self:GetStackCount()*self.bonus end





modifier_FellOmen_Bad_10 = advanced_modifier({})


function modifier_FellOmen_Bad_10:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )
end
function modifier_FellOmen_Bad_10:IsHidden()return true end
function modifier_FellOmen_Bad_10:IsDebuff()return false end
function modifier_FellOmen_Bad_10:IsPurgable()return false end
function modifier_FellOmen_Bad_10:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_10:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_10:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_10:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_10:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 0.15
		local bonus_stack = 0.03
		self.bonus = bonus + bonus_stack*level


	end
end
function modifier_FellOmen_Bad_10:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end

function modifier_FellOmen_Bad_10:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then

		local parent = self:GetParent()
		local pos = parent:GetAbsOrigin()
        -- keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 10})
		local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil, 600,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		
		for i, unit in pairs(units) do
			if not unit:IsInvulnerable() and unit:GetHealthPercent()<100 then
				local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControlEnt(effect_cast, 0,parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt(effect_cast, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex(effect_cast)
				unit:EmitSound("Hero_LifeStealer.Assimilate.Target")
				local healing = HealWithGain(parent:GetMaxHealth()*self.bonus,parent,unit,self)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				break
			end
		end

    end
   
end





modifier_FellOmen_Bad_11 = advanced_modifier({})


function modifier_FellOmen_Bad_11:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )
end
function modifier_FellOmen_Bad_11:IsHidden()return true end
function modifier_FellOmen_Bad_11:IsDebuff()return false end
function modifier_FellOmen_Bad_11:IsPurgable()return false end
function modifier_FellOmen_Bad_11:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_11:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_11:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_11:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_11:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 35
		local bonus_stack = 5
		self.bonus = bonus + bonus_stack*level


	end
end
function modifier_FellOmen_Bad_11:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end

function modifier_FellOmen_Bad_11:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then

		local parent = self:GetParent()
		if not keys.attacker then
			return
		end
		if keys.attacker:IsMagicImmune() or not keys.attacker:IsRealHero() then
			return
		end
		-- local pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(pfx, 1,keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlForward(pfx, 1, keys.attacker:GetForwardVector())  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:EmitSound("Hero_Morphling.AdaptiveStrikeAgi.Target")



        keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_FellOmen_Bad_11_debuff", {duration = self.bonus})


    end
   
end

modifier_FellOmen_Bad_11_debuff = advanced_modifier({})
function modifier_FellOmen_Bad_11_debuff:IsHidden()return true  end
function modifier_FellOmen_Bad_11_debuff:IsDebuff()return true end
function modifier_FellOmen_Bad_11_debuff:IsPurgable()return false end
function modifier_FellOmen_Bad_11_debuff:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_11_debuff:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_11_debuff:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_11_debuff:GetTexture() return "morphling_morph_replicate" end
function modifier_FellOmen_Bad_11_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_FellOmen_Bad_11_debuff:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		local primary_Attribute = parent:GetPrimaryAttribute()
		if primary_Attribute==DOTA_ATTRIBUTE_STRENGTH  then
			if parent:GetStrength()>=5 then
				self.bonus_str = -5
				self.bonus_agi = 2
				self.bonus_int = 2	
			end
			return
		elseif  primary_Attribute==DOTA_ATTRIBUTE_AGILITY  then
			if parent:GetAgility()>=5 then
				self.bonus_str = 2
				self.bonus_agi = -5
				self.bonus_int = 2	
			end
			return
		else
			if parent:GetIntellect(false)>=5 then
				self.bonus_str = 2
				self.bonus_agi = 2
				self.bonus_int = -5	
			end
			return
		end

	end
end

function modifier_FellOmen_Bad_11_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_FellOmen_Bad_11_debuff:GetModifierBonusStats_Agility()   return self.bonus_agi end
function modifier_FellOmen_Bad_11_debuff:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_FellOmen_Bad_11_debuff:GetModifierBonusStats_Strength()  return self.bonus_str end






modifier_FellOmen_Bad_12 = advanced_modifier({})


function modifier_FellOmen_Bad_12:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf", context )
end
function modifier_FellOmen_Bad_12:IsHidden()return true end
function modifier_FellOmen_Bad_12:IsDebuff()return false end
function modifier_FellOmen_Bad_12:IsPurgable()return false end
function modifier_FellOmen_Bad_12:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_12:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_12:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_12:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_12:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 35
		local bonus_stack = 5
		self.bonus = bonus + bonus_stack*level


	end
end
function modifier_FellOmen_Bad_12:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end


function modifier_FellOmen_Bad_12:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then

		local parent = self:GetParent()
		if not keys.attacker then
			return
		end
		if keys.attacker:IsMagicImmune() then
			return
		end
		-- local pos = parent:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(pfx, 1,keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
		-- ParticleManager:SetParticleControlForward(pfx, 1, keys.attacker:GetForwardVector())  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")



        keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_FellOmen_Bad_12_debuff", {duration = 10})


    end
   
end






modifier_FellOmen_Bad_12_debuff = advanced_modifier({})
function modifier_FellOmen_Bad_12_debuff:IsHidden()return false  end
function modifier_FellOmen_Bad_12_debuff:IsDebuff()return true end
function modifier_FellOmen_Bad_12_debuff:IsPurgable()return false end
function modifier_FellOmen_Bad_12_debuff:IsPurgeException() 	return true end
function modifier_FellOmen_Bad_12_debuff:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_12_debuff:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_12_debuff:GetTexture() return "pugna_nether_ward_alt" end
function modifier_FellOmen_Bad_12_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_FellOmen_Bad_12_debuff:OnCreated(keys)
	local level = GetLevel("modifier_FellOmen_Bad_12")
	self.bonus = -10 - level
	if IsServer() then

	end
end

function modifier_FellOmen_Bad_12_debuff:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	
	} 
end
function modifier_FellOmen_Bad_12_debuff:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end


	self:IncrementStackCount()

end

function modifier_FellOmen_Bad_12_debuff:Advanced_GetModifierSpellAmplifyBonus()  return self:GetStackCount()*self.bonus end

function modifier_FellOmen_Bad_12_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end





modifier_FellOmen_Bad_13 = advanced_modifier({})

function modifier_FellOmen_Bad_13:IsDebuff() return false end
function modifier_FellOmen_Bad_13:IsHidden() return true end
function modifier_FellOmen_Bad_13:IsPurgable() 		return false end
function modifier_FellOmen_Bad_13:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_13:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_13:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 25
		local bonus_stack = 5
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = (bonus + bonus_stack*level)

	end
end
function modifier_FellOmen_Bad_13:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end



function modifier_FellOmen_Bad_13:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	if keys.attacker:GetHealthPercent()>=50 and  keys.attacker:GetHealthPercent()>=keys.target:GetHealthPercent() and keys.attacker:GetHealth()>=keys.target:GetHealth() then
		keys.attacker:ModifyHealth(keys.attacker:GetHealth()  -keys.attacker:GetMaxHealth()*0.01, self:GetAbility(), false, 0)
		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_FellOmen_Bad_13_debuff", {duration = self.bonus})

	end




end






modifier_FellOmen_Bad_13_debuff = advanced_modifier({})
function modifier_FellOmen_Bad_13_debuff:IsHidden()return false  end
function modifier_FellOmen_Bad_13_debuff:IsDebuff()return true end
function modifier_FellOmen_Bad_13_debuff:IsPurgable()return false end
function modifier_FellOmen_Bad_13_debuff:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_13_debuff:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_13_debuff:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_13_debuff:GetTexture() return "slark_essence_shift" end


function modifier_FellOmen_Bad_13_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_FellOmen_Bad_13_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_FellOmen_Bad_13_debuff:OnIntervalThink()
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




function modifier_FellOmen_Bad_13_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end


function modifier_FellOmen_Bad_13_debuff:GetModifierBonusStats_Agility()   return -self:GetStackCount() end
function modifier_FellOmen_Bad_13_debuff:GetModifierBonusStats_Intellect() return -self:GetStackCount() end
function modifier_FellOmen_Bad_13_debuff:GetModifierBonusStats_Strength()  return -self:GetStackCount() end






modifier_FellOmen_Bad_14 = advanced_modifier({})

function modifier_FellOmen_Bad_14:IsDebuff() return false end
function modifier_FellOmen_Bad_14:IsHidden() return true end
function modifier_FellOmen_Bad_14:IsPurgable() 		return false end
function modifier_FellOmen_Bad_14:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_14:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_14:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 20
		local bonus_stack = 3
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = (bonus + bonus_stack*level)

	end
end
function modifier_FellOmen_Bad_14:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end

function modifier_FellOmen_Bad_14:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	local parent = self:GetParent()
	if keys.attacker ~= parent or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	if parent:GetRandomEffect(self.bonus,INT_TYPE,1) >=RandomInt(1, 100) then
		local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		keys.target:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Bad_14_debuff", {duration =80*StatusResistance})
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Bad_14_buff", {})
	end





end





modifier_FellOmen_Bad_14_debuff = advanced_modifier({})
function modifier_FellOmen_Bad_14_debuff:IsHidden()return false  end
function modifier_FellOmen_Bad_14_debuff:IsDebuff()return true end
function modifier_FellOmen_Bad_14_debuff:IsPurgable()return false end
function modifier_FellOmen_Bad_14_debuff:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_14_debuff:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_14_debuff:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_14_debuff:GetTexture() return "silencer/bts_silencer_ability/silencer_glaives_of_wisdom" end
function modifier_FellOmen_Bad_14_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.2)
	end
end
function modifier_FellOmen_Bad_14_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_FellOmen_Bad_14_debuff:OnIntervalThink()
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




function modifier_FellOmen_Bad_14_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}
end

function modifier_FellOmen_Bad_14_debuff:GetModifierBonusStats_Intellect() return -self:GetStackCount() end





modifier_FellOmen_Bad_14_buff = advanced_modifier({})
function modifier_FellOmen_Bad_14_buff:IsHidden()return false  end
function modifier_FellOmen_Bad_14_buff:IsDebuff()return false end
function modifier_FellOmen_Bad_14_buff:IsPurgable()return false end
function modifier_FellOmen_Bad_14_buff:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_14_buff:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_14_buff:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_14_buff:GetTexture() return "silencer/bts_silencer_ability/silencer_glaives_of_wisdom" end
function modifier_FellOmen_Bad_14_buff:OnCreated(params)

	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_FellOmen_Bad_14_buff:OnRefresh(params)
	if IsServer() then

		self:IncrementStackCount()
	end
end


function modifier_FellOmen_Bad_14_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_FellOmen_Bad_14_buff:Advanced_GetModifierSpellAmplifyBonus() return self:GetStackCount()*0.2 end



modifier_FellOmen_Bad_15 = advanced_modifier({})

function modifier_FellOmen_Bad_15:IsHidden()return true end
function modifier_FellOmen_Bad_15:IsDebuff()return false end
function modifier_FellOmen_Bad_15:IsPurgable()return false end
function modifier_FellOmen_Bad_15:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_15:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_15:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_3:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_15:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus =10
    local bonus_stack = 1
    -- local max = 50
    -- self.bonus =math.min( max,bonus + bonus_stack*level)
    self.bonus = bonus + bonus_stack*level
end

function modifier_FellOmen_Bad_15:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end


function modifier_FellOmen_Bad_15:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local aiblity = self:GetAbility()
		local parent = self:GetParent()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 300,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
		local sound_name = "Hero_Sven.WarCry"
		parent:EmitSound(sound_name)
		local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 2, parent, PATTACH_POINT_FOLLOW, "attach_head", parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		for i, unit in pairs(units) do
			if unit~=parent and unit:IsAlive() then
				unit:AddNewModifier(unit, aiblity, "modifier_FellOmen_Bad_15_effect", {duration=self.bonus})
			end 
		end
    end
   
end



modifier_FellOmen_Bad_15_effect = advanced_modifier({})
function modifier_FellOmen_Bad_15_effect:IsHidden()return false end
function modifier_FellOmen_Bad_15_effect:IsDebuff()return false end
function modifier_FellOmen_Bad_15_effect:IsPurgable()return false end
function modifier_FellOmen_Bad_15_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_15_effect:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_15_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_FellOmen_Bad_15_effect:GetTexture() return "furbolg_enrage_attack_speed" end
function modifier_FellOmen_Bad_15_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_FellOmen_Bad_15_effect:GetModifierMoveSpeedBonus_Percentage()	return 20 end
function modifier_FellOmen_Bad_15_effect:Advanced_GetModifierAttackSpeedPercentage()	return 20 end



function modifier_FellOmen_Bad_15_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end



modifier_FellOmen_Bad_16 = advanced_modifier({})

function modifier_FellOmen_Bad_16:IsHidden()return true end
function modifier_FellOmen_Bad_16:IsDebuff()return false end
function modifier_FellOmen_Bad_16:IsPurgable()return false end
function modifier_FellOmen_Bad_16:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_16:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_16:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_16:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_16:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus =10
    local bonus_stack = 1.5
    -- local max = 50
    -- self.bonus =math.min( max,bonus + bonus_stack*level)
    self.bonus = bonus + bonus_stack*level
end


function modifier_FellOmen_Bad_16:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end

function modifier_FellOmen_Bad_16:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then
		if not keys.attacker then
			return
		end
		if keys.attacker:IsMagicImmune() then
			return
		end
		local aiblity = self:GetAbility()
		local parent = self:GetParent()
		keys.attacker:AddNewModifier(parent, aiblity, "modifier_FellOmen_Bad_16_effect", {duration=self.bonus})
    end
end



modifier_FellOmen_Bad_16_effect = advanced_modifier({})
function modifier_FellOmen_Bad_16_effect:IsHidden()return false  end
function modifier_FellOmen_Bad_16_effect:IsDebuff()return true end
function modifier_FellOmen_Bad_16_effect:IsPurgable()return false end
function modifier_FellOmen_Bad_16_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_16_effect:RemoveOnDeath() return false end
-- function modifier_FellOmen_Bad_16_effect:DestroyOnExpire() return false end
function modifier_FellOmen_Bad_16_effect:GetTexture() return "antimage_mana_void" end
-- function modifier_FellOmen_Bad_16_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_FellOmen_Bad_16_effect:OnCreated(keys)
-- 	local level = GetLevel("modifier_FellOmen_Bad_12")
-- 	self.bonus = -10 - level
-- 	if IsServer() then
-- 		self:IncrementStackCount()
-- 	end
-- end
function modifier_FellOmen_Bad_16_effect:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_FellOmen_Bad_16_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_FellOmen_Bad_16_effect:OnIntervalThink()
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

function modifier_FellOmen_Bad_16_effect:DeclareFunctions() 
	return {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	} 
end
function modifier_FellOmen_Bad_16_effect:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.unit:IsMagicImmune() then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end
	local cost = keys.ability:GetManaCost(keys.ability:GetLevel())
	if cost<=0 then
		return
	end
	local count = cost *0.1*self:GetStackCount()
	keys.unit:SpendMana(count,self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS , keys.unit, count, nil)
	local damageTable = {
		victim = keys.unit,
		attacker = keys.unit,
		damage = count,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT
		+DOTA_DAMAGE_FLAG_REFLECTION
		+DOTA_DAMAGE_FLAG_HPLOSS
		+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
		-- ability = self:GetAbility(), --Optional.
		}
	ApplyDamage(damageTable)


	self:IncrementStackCount()

end



modifier_FellOmen_Bad_17 = advanced_modifier({})

function modifier_FellOmen_Bad_17:IsHidden()return true end
function modifier_FellOmen_Bad_17:IsDebuff()return false end
function modifier_FellOmen_Bad_17:IsPurgable()return false end
function modifier_FellOmen_Bad_17:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_17:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_17:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_16:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_17:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus =100
    local bonus_stack = 0.5
    -- local max = 50
    -- self.bonus =math.min( max,bonus + bonus_stack*level)
    self.bonus = bonus + bonus_stack*level
	if IsServer() then
		self:StartIntervalThink(10)
	end
end

function modifier_FellOmen_Bad_17:OnIntervalThink()
	local parent = self:GetParent()
	if parent:HasModifier("modifier_FellOmen_Bad_17_infest") or parent:HasModifier("modifier_FellOmen_Bad_17_infest_effect") then
		return
	end
	if parent:GetRandomEffect(self.bonus,INT_TYPE,1) >=RandomInt(1, 100) then

		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local ability = self:GetAbility()
		for i, unit in pairs(units) do
			if unit~=parent and not unit:IsInvulnerable() and not unit:HasModifier("modifier_FellOmen_Bad_17_infest") and not unit:IsInvisible() and not unit:IsOutOfGame() then --无敌或寄生到某个单位身上
				local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, unit)
				ParticleManager:SetParticleControl(infest_particle, 0, parent:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(infest_particle)
				parent:EmitSound("Hero_LifeStealer.Infest")
				parent:Purge(true, true, false, false, false)
				ProjectileManager:ProjectileDodge(parent)


				local infest_modifier = parent:AddNewModifier(self:GetCaster(), ability, "modifier_FellOmen_Bad_17_infest", 
				{
					duration =-1,
					target_ent		= unit:entindex(),
				})
				local infest_effect_modifier = unit:AddNewModifier(parent, ability, "modifier_FellOmen_Bad_17_infest_effect", {duration=-1})
				if infest_modifier and infest_effect_modifier then
					infest_modifier.infest_effect_modifier	= infest_effect_modifier
					infest_effect_modifier.infest_modifier	= infest_modifier
				end
				break
			end
		end
	end
end



---------------------
-- INFEST MODIFIER --
---------------------
modifier_FellOmen_Bad_17_infest = advanced_modifier ({})
function modifier_FellOmen_Bad_17_infest:IsPurgable()	return false end
function modifier_FellOmen_Bad_17_infest:OnCreated(params)
	if not IsServer() then return end
	self.target_ent	= EntIndexToHScript(params.target_ent)
	self:GetParent():AddNoDraw()
	self:StartIntervalThink(0.5)
end

function modifier_FellOmen_Bad_17_infest:OnIntervalThink()
	if not IsServer() then return end
	if not self.target_ent or self.target_ent:IsNull() then
		self:SafeDestroy()
		return
	end
	self:GetParent():SetAbsOrigin(self.target_ent:GetAbsOrigin())
	self:GetParent():AddNoDraw()
end

function modifier_FellOmen_Bad_17_infest:OnDestroy()
	if not IsServer() then return end
	

    self:GetParent():EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
    ParticleManager:ReleaseParticleIndex(infest_particle)
    self:GetParent():StartGesture(ACT_DOTA_SPAWN)
    FindClearSpaceForUnit(self:GetParent(),  self:GetParent():GetAbsOrigin(), false)
	self:GetParent():RemoveNoDraw()
	if self.infest_effect_modifier then
		self.infest_effect_modifier:SafeDestroy()
	end

end
function modifier_FellOmen_Bad_17_infest:GetPriority()
	return 20
end

function modifier_FellOmen_Bad_17_infest:CheckState(keys)
	if not IsServer() then return end

	-- Defaults
	local state = {
		[MODIFIER_STATE_SILENCED]						= true,
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		-- [MODIFIER_STATE_OUT_OF_GAME]						= true,
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true,
		[MODIFIER_STATE_MUTED]						= true,
	}
	return state
end



----------------------------
-- INFEST EFFECT MODIFIER --
----------------------------
modifier_FellOmen_Bad_17_infest_effect = advanced_modifier ({})

function modifier_FellOmen_Bad_17_infest_effect:IsHidden()		return false end
function modifier_FellOmen_Bad_17_infest_effect:IsPurgable()		return false end
function modifier_FellOmen_Bad_17_infest_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_FellOmen_Bad_17_infest_effect:ShouldUseOverheadOffset() return true end
function modifier_FellOmen_Bad_17_infest_effect:GetTexture() return "life_stealer_infest" end
function modifier_FellOmen_Bad_17_infest_effect:OnCreated()
	local ability = self:GetAbility()
	self.bonus_movement_speed	= 30
	self.bonus_damage = self:GetCaster():GetDamageMax()
	if not IsServer() then return end
end



function modifier_FellOmen_Bad_17_infest_effect:OnDestroy()
	if not IsServer() then return end
	
	if self.infest_modifier then
		self.infest_modifier:SafeDestroy()
	end

end

function modifier_FellOmen_Bad_17_infest_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	
	}
end

function modifier_FellOmen_Bad_17_infest_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movement_speed
end
function modifier_FellOmen_Bad_17_infest_effect:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_FellOmen_Bad_17_infest_effect:GetModifierIgnoreMovespeedLimit()             return   1  end




modifier_FellOmen_Bad_18 = advanced_modifier({})

function modifier_FellOmen_Bad_18:IsDebuff() return false end
function modifier_FellOmen_Bad_18:IsHidden() return true end
function modifier_FellOmen_Bad_18:IsPurgable() 		return false end
function modifier_FellOmen_Bad_18:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_18:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_18:OnCreated(keys)
	if IsServer() then
		self.index = keys.index

	end
end
function modifier_FellOmen_Bad_18:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end
function modifier_FellOmen_Bad_18:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	local parent = self:GetParent()
	if keys.attacker ~= parent or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	if parent:HasModifier("modifier_FellOmen_Bad_18_effect") then
		return
	end
	local modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Bad_18_effect", {duration = 6.5,index = self.index})
	if modifier then
		modifier.target = keys.target

	end
end


modifier_FellOmen_Bad_18_effect = advanced_modifier({})

function modifier_FellOmen_Bad_18_effect:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_arcana.vpcf", context )
	-- PrecacheResource( "particle", "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf", context )
end

function modifier_FellOmen_Bad_18_effect:IsDebuff() return false end
function modifier_FellOmen_Bad_18_effect:IsHidden() return false end
function modifier_FellOmen_Bad_18_effect:IsPurgable() 		return false end
function modifier_FellOmen_Bad_18_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_18_effect:RemoveOnDeath()  return true end
function modifier_FellOmen_Bad_18_effect:GetTexture() return "legion_commander_duel" end
function modifier_FellOmen_Bad_18_effect:OnCreated(keys)
	if IsServer() then
		self.index = keys.index
		self:StartIntervalThink(6)
	end
end

function modifier_FellOmen_Bad_18_effect:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
	}
end
function modifier_FellOmen_Bad_18_effect:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit


		if unit~=self:GetParent() then	return end
		if not self.target or self.target:IsNull() or attacker~=self.target then
			return
		end

		if keys.damage<=10 then return	end
		self:SafeDestroy()

		

 
    end 
end

function modifier_FellOmen_Bad_18_effect:OnIntervalThink()
	local parent = self:GetParent()
	local level = GetLevel("modifier_FellOmen_Bad_18")
    local bonus =15
    local bonus_stack = 2
    -- self.bonus = bonus + bonus_stack*level
	local bonus_damage = (bonus + bonus_stack*level)*0.01
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Bad_18_buff", {index =parent:GetDamageMax()*bonus_damage*self.index })


	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/legion/legion_weapon_voth_domosh/legion_commander_duel_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	local pos = parent:GetAbsOrigin()
	pos.z = pos.z +128
	ParticleManager:SetParticleControl( nFXIndex, 0, pos )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	parent:EmitSound("Hero_LegionCommander.Duel.Victory")

	self:SafeDestroy()
end	

modifier_FellOmen_Bad_18_buff = advanced_modifier({})

function modifier_FellOmen_Bad_18_buff:IsDebuff() return false end
function modifier_FellOmen_Bad_18_buff:IsHidden() return false end
function modifier_FellOmen_Bad_18_buff:IsPurgable() 		return false end
function modifier_FellOmen_Bad_18_buff:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_18_buff:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_18_buff:GetTexture() return "legion_commander_duel" end
-- function modifier_FellOmen_Bad_18_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf" end
function modifier_FellOmen_Bad_18_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_FellOmen_Bad_18_buff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.index)
	end
end

function modifier_FellOmen_Bad_18_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	}
end

function modifier_FellOmen_Bad_18_buff:GetModifierPreAttack_BonusDamage( params )
	return self:GetStackCount()
end





modifier_FellOmen_Bad_19 = advanced_modifier({})

function modifier_FellOmen_Bad_19:IsHidden()return true end
function modifier_FellOmen_Bad_19:IsDebuff()return false end
function modifier_FellOmen_Bad_19:IsPurgable()return false end
function modifier_FellOmen_Bad_19:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_19:RemoveOnDeath() return false end
function modifier_FellOmen_Bad_19:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_FellOmen_Bad_16:GetTexture() return "modifier_illusion" end
function modifier_FellOmen_Bad_19:OnCreated(keys)
    local level = GetLevel(self:GetName())
    local bonus =0.3
    local bonus_stack = 0.04
    -- local max = 50
    -- self.bonus =math.min( max,bonus + bonus_stack*level)
    self.bonus = bonus + bonus_stack*level
	-- if IsServer() then
	-- 	self:StartIntervalThink(10)
	-- end
end







modifier_FellOmen_Bad_20 = advanced_modifier({})

function modifier_FellOmen_Bad_20:IsDebuff() return false end
function modifier_FellOmen_Bad_20:IsHidden() return true end
function modifier_FellOmen_Bad_20:IsPurgable() 		return false end
function modifier_FellOmen_Bad_20:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_20:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_20:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 15
		local bonus_stack = 2
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		self.bonus = (bonus + bonus_stack*level)

	end
end
function modifier_FellOmen_Bad_20:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end




function modifier_FellOmen_Bad_20:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	local parent = self:GetParent()
	if keys.attacker ~= parent or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	if parent:GetRandomEffect(self.bonus,INT_TYPE,1) >=RandomInt(1, 100) then
		if math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(self:GetParent():GetForwardVector()).y)) <= 60 then
			local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			keys.target:AddNewModifier(parent, self:GetAbility(), "modifier_stunned", {duration =0.2*StatusResistance})

		end

	end





end





LinkLuaModifier( "modifier_modifier_FellOmen_Bad_21_thinker", "modifier/modifier_fellOmen", LUA_MODIFIER_MOTION_NONE )

modifier_FellOmen_Bad_21 = advanced_modifier({})

function modifier_FellOmen_Bad_21:IsDebuff() return false end
function modifier_FellOmen_Bad_21:IsHidden() return true end
function modifier_FellOmen_Bad_21:IsPurgable() 		return false end
function modifier_FellOmen_Bad_21:IsPurgeException() 	return false end
function modifier_FellOmen_Bad_21:RemoveOnDeath()  return false end
function modifier_FellOmen_Bad_21:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 25
		local bonus_stack = 1
		-- local max = 50
		-- self.bonus =math.min( max,bonus + bonus_stack*level)
		-- self.bonus = (bonus - bonus_stack*level)
		self:StartIntervalThink(math.max(bonus - bonus_stack*level,2))

	end
end
function modifier_FellOmen_Bad_21:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/fellomen/bad_21/effect_snapfire_lizard_blobs_arced.vpcf", context )

	-- particles/rebuild/fellomen/bad_21/effect_snapfire_lizard_blobs_arced.vpcf
end
function modifier_FellOmen_Bad_21:OnIntervalThink()
	if not Game_State:IsInBattle() then --仅战斗回合
		return
	end
	local caster = self:GetParent()
	local heroes = randomTable(GetAllRealHeroes())
	local count = 1
	if #heroes>=4 then
		count = 2
	end
    for  i, hero in pairs(heroes) do
		local pos_source = Vector(RandomInt(-5000, 5000),RandomInt(-5000, 5000),5000)
		local pos = hero:GetAbsOrigin()+Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
		local vec = pos-pos_source


		local travel_time = 3
		local speed= vec:Length()/travel_time
	
		local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
		-- self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), DOTA_TEAM_GOODGUYS )
		ParticleManager:SetParticleControl( effect_cast, 0,pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 300, 0,-50)  )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 3, 0, 0 ) )
		-- local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_mouth"))
		-- attack_lock.z = attack_lock.z -10
		local thinker = CreateModifierThinker(
			caster, -- player source
			nil, -- ability source
			"modifier_modifier_FellOmen_Bad_21_thinker", -- modifier name

			{ travel_time =travel_time }, -- kv
			pos,
			caster:GetTeamNumber(),
			false
		)
		local unit = CreateUnitByName("npc_attack_unit", pos_source, true, caster, caster, caster:GetTeamNumber())
		-- unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
		unit:AddNewModifier(unit, nil, "modifier_thinker_INVULNERABLE", {duration = 0.5})
		unit:SetOrigin(pos_source)
		-- Timers:CreateTimer(0.5, function()
		-- 	UTIL_Remove(unit)
		-- end)
		local info = {
			-- Target = target,
			-- vSpawnOrigin = attack_lock,
			Source = unit,
			Ability = self:GetAbility(),	
			EffectName = "particles/rebuild/fellomen/bad_21/effect_snapfire_lizard_blobs_arced.vpcf",
			iMoveSpeed = speed,
			bDodgeable = false,                           -- Optional
			Target = thinker,
			-- vSourceLoc = attack_lock,                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bProvidesVision = true,                           -- Optional
			iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}
		ProjectileManager:CreateTrackingProjectile( info )
		Timers:CreateTimer(3.1, function()
			UTIL_Remove(thinker)
			ParticleManager:DestroyParticle(effect_cast,true)
			ParticleManager:ReleaseParticleIndex(effect_cast)
		end)
		if i>=count then
			break
		end
    end
end




modifier_modifier_FellOmen_Bad_21_thinker = advanced_modifier({})



------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

modifier_FellOmen_Good_1 = advanced_modifier({})
function modifier_FellOmen_Good_1:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack.vpcf", context )
end
function modifier_FellOmen_Good_1:IsDebuff() return false end
function modifier_FellOmen_Good_1:IsHidden() return self:GetParent():IsRealHero() and self:GetRemainingTime()<=0 end
function modifier_FellOmen_Good_1:IsPurgable() 		return false end
function modifier_FellOmen_Good_1:IsPurgeException() 	return false end
function modifier_FellOmen_Good_1:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_1:GetTexture() return "templar_assassin_meld" end
function modifier_FellOmen_Good_1:DestroyOnExpire() return false end
function modifier_FellOmen_Good_1:OnCreated(keys)
	if IsServer() then
		self.level = keys.level
		local bonus = 0.4
		local bonus_stack = 0.08
		self.bonus = bonus + bonus_stack*self.level
		self.summonChance = 0.7
		self.pierce_records = {}
	end
end



function modifier_FellOmen_Good_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害             
	}
end

function modifier_FellOmen_Good_1:GetModifierPreAttack_BonusDamagePostCrit(keys) 
	if IsServer() then
		if self:GetRemainingTime()<=0 then
			return self:GetParent():GetAverageTrueAttackDamage(nil) * self.bonus
		end
	end
end

function modifier_FellOmen_Good_1:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},

    }
end





function modifier_FellOmen_Good_1:OnAttack(keys)
	if IsClient() then
		return
	end
	if keys.attacker == self:GetParent() then
		if self:GetRemainingTime()<=0 then
			local parent = self:GetParent()
			local cooldown = math.max(5* self:GetCaster():GetCooldownReduction() ,1)
			self:SetDuration(cooldown, true)
			local info = 
			{
				Target = keys.target,
				Source = parent,
				-- Ability = self:GetAbility(),	
				EffectName = "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack.vpcf",
				iMoveSpeed = parent:IsRangedAttacker() and parent:GetProjectileSpeed() or 5000,
				-- sourceloc = pos,
				-- caster:GetProjectileSpeed()
				-- vSourceLoc = pos,
				bDrawsOnMinimap = false,  --？？
				bDodgeable = true,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
				ExtraData = {}   --额外的数据
			}
			ProjectileManager:CreateTrackingProjectile(info)
			parent:EmitSound("Hero_TemplarAssassin.Meld.Attack")
		end
	end
end

function modifier_FellOmen_Good_1:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_FellOmen_Good_1", {level=self.level})
		end
	end
end

modifier_FellOmen_Good_2 = advanced_modifier({})
function modifier_FellOmen_Good_2:IsHidden()return true  end
function modifier_FellOmen_Good_2:IsDebuff()return false end
function modifier_FellOmen_Good_2:IsPurgable()return false end
function modifier_FellOmen_Good_2:IsPurgeException() 	return false end
function modifier_FellOmen_Good_2:RemoveOnDeath() return false end
function modifier_FellOmen_Good_2:DestroyOnExpire() return false end
-- function modifier_FellOmen_Good_2:GetTexture() return "elder_titan_return_spirit" end
function modifier_FellOmen_Good_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_FellOmen_Good_2:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 15
		local bonus_stack = 3
		self.bonus = bonus + bonus_stack*level

		

	end
end

function modifier_FellOmen_Good_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_FellOmen_Good_2:GetModifierBonusStats_Agility()   return self.bonus end
function modifier_FellOmen_Good_2:GetModifierBonusStats_Intellect() return self.bonus end
function modifier_FellOmen_Good_2:GetModifierBonusStats_Strength()  return self.bonus end





modifier_FellOmen_Good_3 = advanced_modifier({})
function modifier_FellOmen_Good_3:IsHidden()return true  end
function modifier_FellOmen_Good_3:IsDebuff()return false end
function modifier_FellOmen_Good_3:IsPurgable()return false end
function modifier_FellOmen_Good_3:IsPurgeException() 	return false end
function modifier_FellOmen_Good_3:RemoveOnDeath() return false end
function modifier_FellOmen_Good_3:DestroyOnExpire() return false end
-- function modifier_FellOmen_Good_3:GetTexture() return "elder_titan_return_spirit" end
function modifier_FellOmen_Good_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_FellOmen_Good_3:IsAura()
	if self:GetParent():IsMoving() then
		return false
	end
	return true
end

function modifier_FellOmen_Good_3:GetModifierAura()	return "modifier_FellOmen_Good_3_effect" end
function modifier_FellOmen_Good_3:GetAuraRadius()	return 500  end
function modifier_FellOmen_Good_3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_FellOmen_Good_3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_FellOmen_Good_3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_FellOmen_Good_3:GetAuraDuration() return 0.1 end

modifier_FellOmen_Good_3_effect = advanced_modifier({})

function modifier_FellOmen_Good_3_effect:IsDebuff() return false end
function modifier_FellOmen_Good_3_effect:IsHidden() return true end
function modifier_FellOmen_Good_3_effect:IsPurgable() 		return false end
function modifier_FellOmen_Good_3_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Good_3_effect:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_3_effect:GetTexture() return "backdoor_protection" end
function modifier_FellOmen_Good_3_effect:OnCreated(keys)
	local level = GetLevel("modifier_FellOmen_Good_3")
	
	local bonus = 8
	local bonus_stack = 2
	-- local bonus2 = 30
	-- local bonus_stack2 = 5
	self.bonus = bonus + bonus_stack*level
	-- self.bonus2 = bonus2 + bonus_stack2 * level


end


function modifier_FellOmen_Good_3_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_FellOmen_Good_3_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus
end

modifier_FellOmen_Good_4 = advanced_modifier({})

function modifier_FellOmen_Good_4:IsDebuff() return false end
function modifier_FellOmen_Good_4:IsHidden() return self:GetParent():IsRealHero() end
function modifier_FellOmen_Good_4:IsPurgable() 		return false end
function modifier_FellOmen_Good_4:IsPurgeException() 	return false end
function modifier_FellOmen_Good_4:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_4:GetTexture() return "huskar_inner_vitality" end
function modifier_FellOmen_Good_4:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 0.2
	local bonus_stack = 0.04
	-- local bonus2 = 30
	-- local bonus_stack2 = 5
	self.bonus = bonus + bonus_stack*self.level
	-- self.bonus2 = bonus2 + bonus_stack2 * level


	if IsServer() then
		self.summonChance = 0.7
	end
end



function modifier_FellOmen_Good_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_FellOmen_Good_4:AdvancedGetModifierConstantHealthRegen() return self:GetCaster():GetStrength()*self.bonus end

function modifier_FellOmen_Good_4:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(parent, self:GetAbility(), "modifier_FellOmen_Good_4", {level=self.level})
		end
	end
end


modifier_FellOmen_Good_5 = advanced_modifier({})

function modifier_FellOmen_Good_5:IsDebuff() return false end
function modifier_FellOmen_Good_5:IsHidden() return true end
function modifier_FellOmen_Good_5:IsPurgable() 		return false end
function modifier_FellOmen_Good_5:IsPurgeException() 	return false end
function modifier_FellOmen_Good_5:RemoveOnDeath()  return false end
-- function modifier_FellOmen_Good_5:GetTexture() return "templar_assassin_psi_blades" end
function modifier_FellOmen_Good_5:OnCreated(keys)
	local level = GetLevel(self:GetName())
	
	local bonus = 7
	local bonus_stack = 1
	self.bonus_cooldown = bonus + bonus_stack*level
	

end



function modifier_FellOmen_Good_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_FellOmen_Good_5:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end




modifier_FellOmen_Good_6 = advanced_modifier({})
function modifier_FellOmen_Good_6:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_heal_pluses.vpcf", context )
end
function modifier_FellOmen_Good_6:IsDebuff() return false end
function modifier_FellOmen_Good_6:IsHidden() return self:GetParent():IsRealHero() and self:GetRemainingTime()<=0 end
function modifier_FellOmen_Good_6:IsPurgable() 		return false end
function modifier_FellOmen_Good_6:IsPurgeException() 	return false end
function modifier_FellOmen_Good_6:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_6:DestroyOnExpire() return false end
function modifier_FellOmen_Good_6:GetTexture() return "phoenix_fire_spirits" end
function modifier_FellOmen_Good_6:OnCreated(keys)

	if IsServer() then
		self.level = keys.level
		local bonus = 8
		local bonus_stack = 1
		local bonus2 = 0.3
		local bonus_stack2 = 0.05
		self.bonus = bonus + bonus_stack*self.level
		self.bonus2 = bonus2 + bonus_stack2*self.level
		self.summonChance = 0.7
		self:StartIntervalThink(1)
	end
end
function modifier_FellOmen_Good_6:OnIntervalThink()
	if self:GetRemainingTime()>0 then
		return
	end
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=50 then
		if parent:GetRandomEffect(self.bonus,INT_TYPE,1) >=RandomInt(1, 100) then
			local healing = HealWithGain(parent:GetMaxHealth()*self.bonus2,parent,parent,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
			local cooldown = math.max(30* parent:GetCooldownReduction() ,1)
			local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_heal_pluses.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControlEnt(effect_cast, 0,parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			self:SetDuration(cooldown, true)
			parent:EmitSound("Hero_Dawnbreaker.Luminosity.Heal")
		end
	end
end

function modifier_FellOmen_Good_6:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_FellOmen_Good_6", {level=self.level})
		end
	end
end


modifier_FellOmen_Good_7 = advanced_modifier({})

function modifier_FellOmen_Good_7:IsDebuff() return false end
function modifier_FellOmen_Good_7:IsHidden() return self:GetParent():IsRealHero() end
function modifier_FellOmen_Good_7:IsPurgable() 		return false end
function modifier_FellOmen_Good_7:IsPurgeException() 	return false end
function modifier_FellOmen_Good_7:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_7:GetTexture() return "templar_assassin_psi_blades" end
function modifier_FellOmen_Good_7:OnCreated(keys)
	local level = GetLevel(self:GetName())
	
	local bonus = 15
	local bonus_stack = 3
	self.bonus = bonus + bonus_stack*level
	
	if IsServer() then
		self.summonChance = 0.7
	end
end



function modifier_FellOmen_Good_7:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE

    }
end


function modifier_FellOmen_Good_7:Advanced_GetModifierAttackRangeBonusPercentage() return self.bonus end

function modifier_FellOmen_Good_7:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_FellOmen_Good_7", {})
		end
	end
end



modifier_FellOmen_Good_8 = advanced_modifier({})
function modifier_FellOmen_Good_8:IsHidden()return self:GetRemainingTime()<=0  end
function modifier_FellOmen_Good_8:IsDebuff()return false end
function modifier_FellOmen_Good_8:IsPurgable()return false end
function modifier_FellOmen_Good_8:IsPurgeException() 	return false end
function modifier_FellOmen_Good_8:RemoveOnDeath() return false end
function modifier_FellOmen_Good_8:DestroyOnExpire() return false end
function modifier_FellOmen_Good_8:GetTexture() return "elder_titan_return_spirit" end
function modifier_FellOmen_Good_8:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_FellOmen_Good_8:OnCreated(keys)
	if IsServer() then
		local level = keys.level
		local bonus = 13
		local bonus_stack = 3
		self.bonus = bonus + bonus_stack*level

		

	end
end
function modifier_FellOmen_Good_8:OnWaveStart(keys)

	self:SetStackCount(self:GetStackCount() +self.bonus)
	self:SetDuration(15, true)

end
function modifier_FellOmen_Good_8:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_FellOmen_Good_8:GetModifierBonusStats_Agility()   return self:GetStackCount()*0.1 end
function modifier_FellOmen_Good_8:GetModifierBonusStats_Intellect() return self:GetStackCount()*0.1 end
function modifier_FellOmen_Good_8:GetModifierBonusStats_Strength()  return self:GetStackCount()*0.1 end
function modifier_FellOmen_Good_8:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end


modifier_FellOmen_Good_9 = advanced_modifier({})

function modifier_FellOmen_Good_9:IsDebuff() return true end
function modifier_FellOmen_Good_9:IsHidden() return true end
function modifier_FellOmen_Good_9:IsPurgable() 		return false end
function modifier_FellOmen_Good_9:IsPurgeException() 	return false end
function modifier_FellOmen_Good_9:RemoveOnDeath()  return false end
-- function modifier_FellOmen_Good_9:GetTexture() return "huskar_inner_vitality" end
function modifier_FellOmen_Good_9:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 13
	local bonus_stack = 2
	-- local bonus2 = 30
	-- local bonus_stack2 = 5
	self.bonus = bonus + bonus_stack*self.level
	-- self.bonus2 = bonus2 + bonus_stack2 * level


	-- if IsServer() then
	-- 	-- self.summonChance = 0.7
	-- end
end


function modifier_FellOmen_Good_9:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,     
	}
end
function modifier_FellOmen_Good_9:GetModifierPercentageCooldown() return -self.bonus end


modifier_FellOmen_Good_10 = advanced_modifier({})

function modifier_FellOmen_Good_10:IsDebuff() return false end
function modifier_FellOmen_Good_10:IsHidden() return true end
function modifier_FellOmen_Good_10:IsPurgable() 		return false end
function modifier_FellOmen_Good_10:IsPurgeException() 	return false end
function modifier_FellOmen_Good_10:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_10:GetTexture() return "magnataur_empower" end
function modifier_FellOmen_Good_10:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 12
	local bonus_stack = 2.5
	self.bonus = bonus + bonus_stack*self.level
	
	if IsServer() then
		self.summonChance = 0.7
	end
end


function modifier_FellOmen_Good_10:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,     
	}
end
function modifier_FellOmen_Good_10:GetModifierDamageOutgoing_Percentage() return self.bonus end

function modifier_FellOmen_Good_10:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_FellOmen_Good_10", {level=self.level})
		end
	end
end






modifier_FellOmen_Good_11 = advanced_modifier({})

function modifier_FellOmen_Good_11:IsDebuff() return false end
function modifier_FellOmen_Good_11:IsHidden() return false end
function modifier_FellOmen_Good_11:IsPurgable() 		return false end
function modifier_FellOmen_Good_11:IsPurgeException() 	return false end
function modifier_FellOmen_Good_11:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_11:DestroyOnExpire() return false end
function modifier_FellOmen_Good_11:GetTexture() return "faceless_void_backtrack" end
function modifier_FellOmen_Good_11:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 30
	local bonus_stack = 1
	self.bonus = math.max(bonus - bonus_stack*self.level,7)
	
	if IsServer() then
		-- self.trigger_time =  GameRules:GetGameTime()
		self.summonChance = 0.7
	end
end


function modifier_FellOmen_Good_11:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end
	-- if not self:GetParent():IsRealHero() then
	-- 	return false
	-- end
	if params.target~=self:GetParent() then return end
	-- local ability = self:GetAbility()
	if self:GetRemainingTime()<=0 and params.damage>=params.target:GetHealth() then
		-- self.trigger_time =  GameRules:GetGameTime() + self.bonus
		self:SetDuration(self.bonus, true)
		self:SpellToTarget()
		return -1000
	end

end

function modifier_FellOmen_Good_11:SpellToTarget()
	if IsServer() then
		local caster = self:GetCaster()
		local pos = caster:GetAbsOrigin()-Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		if pos==caster:GetAbsOrigin() then
			pos = pos+caster:GetForwardVector()
		end
		local direction = (pos - caster:GetAbsOrigin()):Normalized()    --GetAbsOrigin()应该是施法点  	Normalized()返回单位矢量
		direction.z = 0  --初始化Z值

		pos = caster:GetAbsOrigin()+direction*800
		local distance = math.min(800, (caster:GetAbsOrigin() - pos):Length2D())    --Length2D()矢量XY平面上长度（模） 该项为 如果释放点大于施法距离则取最大施法距离 否则则取施法点到自身的距离
		local tralve_duration = distance / 1600   --计算移动时间 为距离/速度(键值)
		caster:EmitSound( "Hero_FacelessVoid.TimeWalk" )
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_FellOmen_Good_11_effect", {duration = tralve_duration,dir = direction})  --添加冲刺修饰器 传入时间与一个点


		-- self:PlayEffects1( origin, target ,direction)
	end

end


function modifier_FellOmen_Good_11:OnSummonUnitFinished(keys)
	if IsServer() then
		local ability = keys.inflictor
		local parent = self:GetParent()
		local cooldownTime = ability:GetCooldown(ability:GetLevel())
		local baseChance = cooldownTime / self.summonChance
		if parent:GetRandomEffect(baseChance,INT_TYPE,1) >=RandomInt(1, 100) then
			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_FellOmen_Good_11", {level=self.level})
		end
	end
end


function modifier_FellOmen_Good_11:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end








modifier_FellOmen_Good_11_effect = advanced_modifier({})

function modifier_FellOmen_Good_11_effect:IsDebuff()			return false end
function modifier_FellOmen_Good_11_effect:IsHidden() 			return true end
function modifier_FellOmen_Good_11_effect:IsPurgable() 		return false end
function modifier_FellOmen_Good_11_effect:IsPurgeException() 	return false end
function modifier_FellOmen_Good_11_effect:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf" end
function modifier_FellOmen_Good_11_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_FellOmen_Good_11_effect:CheckState() return {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
} 
end
function modifier_FellOmen_Good_11_effect:IsMotionController() return true end
function modifier_FellOmen_Good_11_effect:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_FellOmen_Good_11_effect:OnCreated(keys)
	if IsServer() then
		--self.direction = StringToVector(keys.direction)
		self.direction =StringToVector( keys.dir)
		self.speed = 1600
		self.MotionControll = 1
		if not self.MotionControll then
			self:SafeDestroy()
		else
			self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
		end
	end
end

function modifier_FellOmen_Good_11_effect:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  --需要debug确认作用
	new_pos = GetGroundPosition(new_pos, nil)   --返回移动到提供的position的地面位置。第二个参数是一个NPC，用于测量碰撞体积
	me:SetOrigin(new_pos)  --Sets the location of this entity
	
	self.MotionControll = 0
end



function modifier_FellOmen_Good_11_effect:OnDestroy()   --当时间漫游结束时
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true) 
		self.direction = nil
		self.speed = nil
	end
end



modifier_FellOmen_Good_12 = advanced_modifier({})

function modifier_FellOmen_Good_12:IsDebuff() return false end
function modifier_FellOmen_Good_12:IsHidden() return true end
function modifier_FellOmen_Good_12:IsPurgable() 		return false end
function modifier_FellOmen_Good_12:IsPurgeException() 	return false end
function modifier_FellOmen_Good_12:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_12:DestroyOnExpire() return false end
function modifier_FellOmen_Good_12:GetTexture() return "bounty_hunter_jinada_ti9" end
function modifier_FellOmen_Good_12:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 20
	local bonus_stack = 5
	self.bonus = bonus + bonus_stack*self.level
	
	-- if IsServer() then
	-- 	-- self.trigger_time =  GameRules:GetGameTime()
	-- 	self.summonChance = 0.7
	-- end
end


modifier_FellOmen_Good_13 = advanced_modifier({})

function modifier_FellOmen_Good_13:IsDebuff() return false end
function modifier_FellOmen_Good_13:IsHidden() return true end
function modifier_FellOmen_Good_13:IsPurgable() 		return false end
function modifier_FellOmen_Good_13:IsPurgeException() 	return false end
function modifier_FellOmen_Good_13:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_13:DestroyOnExpire() return false end
function modifier_FellOmen_Good_13:GetTexture() return "modifier_halloffame_glow" end
function modifier_FellOmen_Good_13:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 10
	local bonus_stack = 0.6
	self.bonus =( bonus + bonus_stack*self.level)*0.01+1
	
	-- if IsServer() then
	-- 	-- self.trigger_time =  GameRules:GetGameTime()
	-- 	self.summonChance = 0.7
	-- end
end



modifier_FellOmen_Good_14 = advanced_modifier({})

function modifier_FellOmen_Good_14:IsDebuff() return false end
function modifier_FellOmen_Good_14:IsHidden() return true end
function modifier_FellOmen_Good_14:IsPurgable() 		return false end
function modifier_FellOmen_Good_14:IsPurgeException() 	return false end
function modifier_FellOmen_Good_14:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_14:DestroyOnExpire() return false end
function modifier_FellOmen_Good_14:GetTexture() return "rubick_arcane_supremacy" end
function modifier_FellOmen_Good_14:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus = 150
	local bonus_stack = 15
	self.bonus =( bonus + bonus_stack*self.level)
	local bonus2 = 10
	local bonus_stack2 = 1.5
	self.bonus2 =( bonus2 + bonus_stack2*self.level)
	-- if IsServer() then
	-- 	-- self.trigger_time =  GameRules:GetGameTime()
	-- 	self.summonChance = 0.7
	-- end
end


function modifier_FellOmen_Good_14:GetModifierCastRangeBonusStacking()
	return self.bonus
end
function modifier_FellOmen_Good_14:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus2
end


-- advanced_modifier
function modifier_FellOmen_Good_14:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_FellOmen_Good_14:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus
end




modifier_FellOmen_Good_15 = advanced_modifier({})

function modifier_FellOmen_Good_15:IsDebuff() return false end
function modifier_FellOmen_Good_15:IsHidden() return true end
function modifier_FellOmen_Good_15:IsPurgable() 		return false end
function modifier_FellOmen_Good_15:IsPurgeException() 	return false end
function modifier_FellOmen_Good_15:RemoveOnDeath()  return false end
function modifier_FellOmen_Good_15:DestroyOnExpire() return false end
function modifier_FellOmen_Good_15:GetTexture() return "gyrocopter_skyhigh_call_down" end
function modifier_FellOmen_Good_15:OnCreated(keys)
	self.level = GetLevel(self:GetName())
	
	local bonus =10
	local bonus_stack = 0.5
	self.bonus =( bonus + bonus_stack*self.level)

end

-- advanced_modifier
function modifier_FellOmen_Good_15:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
    }
end
function modifier_FellOmen_Good_15:Advanced_GetModifier_RandomEffectGain(keys)
	return self.bonus
end
