
LinkLuaModifier("modifier_Advanced_presence_of_the_dark_lord_aura", "skills/Advanced_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_presence_of_the_dark_lord_debuff", "skills/Advanced_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_presence_of_the_dark_lord_debuff2", "skills/Advanced_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff", "skills/Advanced_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)

Advanced_presence_of_the_dark_lord	= Advanced_presence_of_the_dark_lord or class({})
require("internal/timers")

function Advanced_presence_of_the_dark_lord:CheckKV(key)
	local table = {
		armor_reduce = 0.3,
	}
	local value = table[key] or -1
	return value

end

-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
-- end
function Advanced_presence_of_the_dark_lord:GetIntrinsicModifierName()
	return "modifier_Advanced_presence_of_the_dark_lord_aura"
end
function Advanced_presence_of_the_dark_lord:Spawn()
	self.bonus_reduce = 0
	self.bonus_reduce_lv15 = 0
end
function Advanced_presence_of_the_dark_lord:GetBonusReduce()
	return self.bonus_reduce + math.min(self.bonus_reduce_lv15,20)
end

function Advanced_presence_of_the_dark_lord:SetBonusReduce(value)
	self.bonus_reduce = value
end
function Advanced_presence_of_the_dark_lord:SetBonusReduceLV15(value)
	self.bonus_reduce_lv15 = value
end
function Advanced_presence_of_the_dark_lord:GetBonusReduceLV15()
	return self.bonus_reduce_lv15
end

function Advanced_presence_of_the_dark_lord:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", context )

	

end


function Advanced_presence_of_the_dark_lord:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_presence_of_the_dark_lord:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_presence_of_the_dark_lord:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blade_Fury_unlock3",{})
	return true

end

function Advanced_presence_of_the_dark_lord:FindNecromasteryModifier()
	if self.unlock1Modifier and not self.unlock1Modifier:IsNull()  then
		return self.unlock1Modifier
	else
		self.unlock1Modifier = self:GetCaster():FindModifierByName("modifier_Advanced_necromastery")
	end
	return self.unlock1Modifier

end


modifier_Advanced_presence_of_the_dark_lord_aura =modifier_Advanced_presence_of_the_dark_lord_aura or  advanced_modifier({})
function modifier_Advanced_presence_of_the_dark_lord_aura:IsDebuff()	return false end
function modifier_Advanced_presence_of_the_dark_lord_aura:IsHidden()	return false end
function modifier_Advanced_presence_of_the_dark_lord_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	
	return true
end

function modifier_Advanced_presence_of_the_dark_lord_aura:GetModifierAura()
	return "modifier_Advanced_presence_of_the_dark_lord_debuff"
end
function modifier_Advanced_presence_of_the_dark_lord_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_Advanced_presence_of_the_dark_lord_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_Advanced_presence_of_the_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_Advanced_presence_of_the_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end
function modifier_Advanced_presence_of_the_dark_lord_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.self_reduce = 0
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_presence_of_the_dark_lord_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Advanced_presence_of_the_dark_lord_aura:OnIntervalThink()
	local parent = self:GetParent()

	local armor = parent:GetPhysicalArmorValue(false)+self.self_reduce  --得到本来的护甲值
	if armor>0 then
		self.self_reduce = math.min(armor*0.2,40)
	else
		self.self_reduce = 0
	end
	local ability = self:GetAbility()
	if ability.advanced_level>=5 then
		ability:SetBonusReduce(self.self_reduce*0.75)
		if ability.advanced_level>=20 then
			local bonus_radius = math.min(parent:GetMaxHealth()/30,600)
			self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )+bonus_radius
		end
	else
		ability:SetBonusReduce(self.self_reduce*0.5)
	end
	
	self:SetStackCount(self.self_reduce)
end

function modifier_Advanced_presence_of_the_dark_lord_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_presence_of_the_dark_lord_aura:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_presence_of_the_dark_lord_aura:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_presence_of_the_dark_lord_aura:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()
end







modifier_Advanced_presence_of_the_dark_lord_debuff =modifier_Advanced_presence_of_the_dark_lord_debuff or  advanced_modifier({})

function modifier_Advanced_presence_of_the_dark_lord_debuff:IsDebuff()	return true end
function modifier_Advanced_presence_of_the_dark_lord_debuff:IsHidden()	return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff:IsPurgable() return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff:IsPurgeException() return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff:OnCreated( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
	if IsServer() then
		local ability = self:GetAbility()
		self:SetStackCount(ability:GetBonusReduce())
		self.chance = 6
		if ability.advanced_level>=10 then
			self.chance = 8
			if ability.advanced_level>=15 then
				self.lv15 = true
			end
		end
		self.origin_chance = self.chance
		
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_presence_of_the_dark_lord_debuff:OnRefresh( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
end
function modifier_Advanced_presence_of_the_dark_lord_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	if self:GetUnlock(3)==3 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end

	return funcs
end
function modifier_Advanced_presence_of_the_dark_lord_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		if ability.advanced_level>=15 then
			if self:GetParent():IsAlive() then
				return
			end
			ability:SetBonusReduceLV15(ability:GetBonusReduceLV15()+1)
			Timers:CreateTimer(35, function()
				if ability and not ability:IsNull() then
					ability:SetBonusReduceLV15(ability:GetBonusReduceLV15()-1)
				end
			end)
			if ability.unlock1 then
				local unlock1Modifier = ability:FindNecromasteryModifier()
				if unlock1Modifier then
					unlock1Modifier:DarkLordInit()
					unlock1Modifier:AddStack(1)
					unlock1Modifier:PlayEffects( self:GetParent() )
				end
			end
		end
	end
end



function modifier_Advanced_presence_of_the_dark_lord_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	self:SetStackCount(ability:GetBonusReduce())
	if self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,0.5)  >=RandomInt(1, 100) then
		self.chance = self.origin_chance
		local caster = self:GetCaster()
		local target = self:GetParent()
		if target:IsMagicImmune() then
			return
		end
		local StatusResistance = target:GetHDStatusResistanceIndex()
		target:AddNewModifier(caster, ability, "modifier_Advanced_presence_of_the_dark_lord_debuff2", {duration =math.max( 3*StatusResistance,0.5)})
		target:EmitSound("Hero_DarkWillow.Fear.Target")
		if ability.unlock2 then
			local modifier = target:FindModifierByName("modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff")
			local heroes = GetAllRealHeroes()
			local currentHero;
			for  _, hero in pairs(heroes) do
				if not currentHero then
					currentHero = hero
				else
					if currentHero:GetAverageTrueAttackDamage(nil)<hero:GetAverageTrueAttackDamage(nil) then
						currentHero = hero
					end
				end
			end
			if currentHero then
				local damage = currentHero:GetAverageTrueAttackDamage(nil)*2.5
				if modifier then
					damage = damage * (1+modifier:GetStackCount()*0.15)
					modifier:SetStackCount(math.min(modifier:GetStackCount()+1,20))
				else
					target:AddNewModifier(caster, ability, "modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff", {})
				end
				local iPtclID = ParticleManager:CreateParticle('particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf', PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iPtclID, 0, target:GetOrigin())
				DestroyParticleByDelay(iPtclID,3)
				target:EmitSound("Hero_Nevermore.Shadowraze")
				ApplyDamage({
					victim = target, 
					attacker = caster,
					damage = damage, 
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					ability = ability
				})
				


			end
			
		end
	else
		if self.lv15 then
			self.chance = self.chance + 2
		end
	end
end



function modifier_Advanced_presence_of_the_dark_lord_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_presence_of_the_dark_lord_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_presence_of_the_dark_lord_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor_reduction-self:GetStackCount()
end



function modifier_Advanced_presence_of_the_dark_lord_debuff:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		-- if not keys.inflictor then return end
		if unit~=self:GetParent() then	return end
		if keys.damage<=50 then return	end
		if not IsEnemy(attacker,unit) then
			return
		end
		if keys.damage_category== DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		local damage = keys.damage*0.18
		unit:ModifyHealth(unit:GetHealth()  -damage, keys.inflictor , false, DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT)
    end 
end




modifier_Advanced_presence_of_the_dark_lord_debuff2 =modifier_Advanced_presence_of_the_dark_lord_debuff2 or  class({})

function modifier_Advanced_presence_of_the_dark_lord_debuff2:IsDebuff()	return true end
function modifier_Advanced_presence_of_the_dark_lord_debuff2:IsHidden()	return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff2:IsPurgable() return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff2:IsPurgeException() return false end
function modifier_Advanced_presence_of_the_dark_lord_debuff2:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf" end



function modifier_Advanced_presence_of_the_dark_lord_debuff2:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	
	
	}

	return state
end






modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff =modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff or  class({})

function modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff:IsDebuff()	return true end
function modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff:IsHidden()	return false end
function modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff:IsPurgable() return false end
function modifier_Advanced_presence_of_the_dark_lord_unlock2_debuff:IsPurgeException() return false end
