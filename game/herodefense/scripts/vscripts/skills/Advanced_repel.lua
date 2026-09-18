--特效优化 √
Advanced_repel = class({})
LinkLuaModifier("modifier_Advanced_repel", "skills/Advanced_repel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_repel_unlock1", "skills/Advanced_repel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_repel_unlock3", "skills/Advanced_repel", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function Advanced_repel:CheckKV(key)
	local table = {
		bonus_str=1,
		bonus_regen=2,

	}
	local value = table[key] or -1
	return value

end

function Advanced_repel:UnlockFirstCore(key)
	return true
end
function Advanced_repel:UnlockSecondCore(key)
		-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lightning_storm_unlock2",{})
	return true
end
function Advanced_repel:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_frost_armor_unlock3",{})
	return true
end
function Advanced_repel:IsRefreshable() return false end




function Advanced_repel:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/repel/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
end




function Advanced_repel:GetCooldown(iLevel)
	return 14 /self:GetCaster():GetCooldownReduction()
end 


function Advanced_repel:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget() 
	local target_cast_response = "omniknight_omni_ability_repel_0"..math.random(1,6)
	local self_cast_response = {"omniknight_omni_ability_repel_01", "omniknight_omni_ability_repel_05", "omniknight_omni_ability_repel_06"}
	local sound_cast = "Hero_Omniknight.Repel"    

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")    

	-- Target cast responses
	if target ~= caster then
		EmitSoundOn(target_cast_response, caster)
	else
		-- Self cast responses
		EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)    

	-- Repel the target
	self:Repel(caster, ability, target, duration)

	-- #6 Talent: Repel affects nearby allies briefly
	-- if caster:HasTalent("special_bonus_imba_omniknight_6") then
	-- 	-- Talent values
	-- 	local radius = caster:FindTalentValue("special_bonus_imba_omniknight_6", "radius")
	-- 	local talent_duration = caster:FindTalentValue("special_bonus_imba_omniknight_6", "duration")

	-- 	-- Find all nearby allies
	-- 	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
	-- 									 target:GetAbsOrigin(),
	-- 									 nil,
	-- 									 radius,
	-- 									 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	-- 									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	-- 									 DOTA_UNIT_TARGET_FLAG_NONE,
	-- 									 FIND_ANY_ORDER,
	-- 									 false)

	-- 	-- Repel all allies except the target
	-- 	for _, ally in pairs(allies) do
	-- 		if ally ~= target then
	-- 			--Repel(caster, ability, ally, talent_duration)
	-- 			-- Lets make it just last for whole duration cause no one gets this thing otherwise
	-- 			Repel(caster, ability, ally, duration)
	-- 		end
	-- 	end
	-- end
end

function Advanced_repel:Repel(caster, ability, target, duration)
	-- Ability properties
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local modifier_repel = "modifier_Advanced_repel"


	-- Add particle effect
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())

	-- Apply a strong dispel on target
	target:Purge(false, true, false, true, true)

	-- Give target Repel buff and Degen Aura buffs
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, ability, modifier_repel, {duration = duration*gain})
	if self.unlock1 then
		target:AddNewModifier(caster, ability, "modifier_Advanced_repel_unlock1", {duration = duration*gain})
	end
	if self.unlock3 then
		target:AddNewModifier(caster, ability, "modifier_Advanced_repel_unlock3", {duration = duration*gain})
	end

end


-- Repel modifier
modifier_Advanced_repel = advanced_modifier({})

function modifier_Advanced_repel:IsHidden() return false end
function modifier_Advanced_repel:IsPurgable() return true end
function modifier_Advanced_repel:IsDebuff() return false end

function modifier_Advanced_repel:OnCreated(keys)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_res = ability:GetSpecialValueFor("bonus_res")
	self.bonus_health_regeneration = ability:GetSpecialValueFor("bonus_regen")
	
	if IsServer() then
		self.heal_index = 1
		--LV5解锁圣光环绕+
		if advanced_level>=5 then
			self.heal_index = 1.5
		end
		if not ability.unlock2 then
			self:SetStackCount(1)
			-- self:IncrementStackCount()
			--LV10解锁完人之诫+
			if advanced_level>=10 then
				self:IncrementStackCount()
			end
		end
	


		--LV15解锁圣盾
		if advanced_level>=15 then
			self.damage_reduce_chance=30
			if advanced_level>=20 then
				self.damage_reduce_chance = 50
			end
		end

	end

end
function modifier_Advanced_repel:OnRefresh(table)
	self:OnCreated()
end



function modifier_Advanced_repel:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
	}
end




function modifier_Advanced_repel:OnTakeDamage(keys)
	if IsServer() then   
		-- local attacker = keys.attacker

		local unit = keys.unit

		-- if not keys.inflictor then return end
		if unit~=self:GetParent() then	return end

		if keys.damage<=100 then return	end
		
		if not unit:IsAlive() then
			return
		end
		if not unit:IsRealHero() then
			return
		end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		local ability = self:GetAbility()
		if ability.unlock1 then
			local heal = math.min(unit:GetStrength()*4,keys.damage)
			Timers:CreateTimer(0.2, function()
				if not ability or ability:IsNull() then
					return
				end
				HealWithGain(heal,unit,unit,ability,nil,0,0)
			end)
		else
			local heal = math.min(unit:GetStrength()*self.heal_index,keys.damage*0.5)
			Timers:CreateTimer(0.2, function()
				if not ability or ability:IsNull() then
					return
				end
				HealWithGain(heal,unit,unit,ability,nil,0,0)
			end)
		end
	
		

 
    end 
end


function modifier_Advanced_repel:OnAbilityFullyCast(keys)

	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end

		if self:GetStackCount()>=1 then
			self:RefreshAbility(keys,true)
			
		else
			if self:GetAbility() and self:GetAbility().unlock2 and 6>=RandomInt(1, 10) then
				self:RefreshAbility(keys,false)
			end

		end


	
		
	end
end

function modifier_Advanced_repel:RefreshAbility(keys,reduce)
	local ability = keys.ability
	if ability:GetName()=="item_hd_force_staff" or ability:GetName()=="item_hd_force_boots" then
		return
	end
	if ability==self:GetAbility() or ability:GetAbilityName()==self:GetAbility():GetAbilityName() then
		return
	end
	local cooldownreduce = 14
	if not ability:IsRefreshable() then
		cooldownreduce = 7
	end
	
	local newCooldown = ability:GetCooldownTimeRemaining() - cooldownreduce
	ability:EndCooldown()
	if newCooldown>=0 then
		ability:StartCooldown(newCooldown)
	end
	if reduce then
		self:DecrementStackCount()
	end
	-- self:DecrementStackCount()
end

function modifier_Advanced_repel:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_repel:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_Advanced_repel:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_Advanced_repel:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Advanced_repel:Advanced_GetModifierIncomingDamage_Percentage( params )
	if IsClient() then
		return 0
	end
	if self.damage_reduce_chance and self.damage_reduce_chance>=RandomInt(1, 100) then
		return -50
	end
	
end



function modifier_Advanced_repel:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
	return funcs
end

function modifier_Advanced_repel:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_res
end




modifier_Advanced_repel_unlock1 = advanced_modifier({})

function modifier_Advanced_repel_unlock1:IsHidden()	return false end
function modifier_Advanced_repel_unlock1:IsDebuff()	return false end
function modifier_Advanced_repel_unlock1:IsPurgable()	return false end
function modifier_Advanced_repel_unlock1:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_Advanced_repel_unlock1:GetEffectName() return "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf" end
-- function modifier_Advanced_repel_unlock1:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_repel_unlock1:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(10)
        local particle_cast = "particles/rebuild/spell/repel/unlock1/effect.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			nil,
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
        ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			nil,
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
        ParticleManager:SetParticleControlEnt(
			effect_cast,
			5,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			nil,
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
    end
end
function modifier_Advanced_repel_unlock1:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(10)
    end
end

function modifier_Advanced_repel_unlock1:GetModifierIncomingDamage_Percentage(keys)	
	if IsClient() then
		return -100
	end
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
        return
    end
    self:DecrementStackCount()
    self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
    return -100
end


function modifier_Advanced_repel_unlock1:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end






modifier_Advanced_repel_unlock3= class({})

function modifier_Advanced_repel_unlock3:IsDebuff()			return false end
function modifier_Advanced_repel_unlock3:IsHidden() 			return false end
function modifier_Advanced_repel_unlock3:IsPurgable() 		return false end
function modifier_Advanced_repel_unlock3:IsPurgeException() 	return false end

function modifier_Advanced_repel_unlock3:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(10)
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_repel_unlock3:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(10)
	end
end
function modifier_Advanced_repel_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=20 then
		local heal = parent:GetMaxHealth()*0.2
		local healing = HealWithGain(heal,self:GetCaster(),parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		self:DecrementStackCount()
		EmitSoundOn("Hero_Oracle.FalsePromise.Healed", parent)	
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0,parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end




function modifier_Advanced_repel_unlock3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end




function modifier_Advanced_repel_unlock3:GetModifierBonusStats_Strength()	return 100 end