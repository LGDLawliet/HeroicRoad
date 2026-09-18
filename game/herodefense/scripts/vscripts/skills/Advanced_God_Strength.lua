--特效优化 √
Advanced_God_Strength = class({})

LinkLuaModifier("modifier_Advanced_God_Strength", "skills/Advanced_God_Strength", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_God_Strength_buff2", "skills/Advanced_God_Strength", LUA_MODIFIER_MOTION_NONE)


function Advanced_God_Strength:CheckKV(key)
	local table = {


	
		bonus_damage =2,




	}
	local value = table[key] or -1
	return value

end

function Advanced_God_Strength:UnlockFirstCore(key)
	return true
end
function Advanced_God_Strength:UnlockSecondCore(key)
	return true
end
function Advanced_God_Strength:UnlockThirdCore(key)
	return true
end


function Advanced_God_Strength:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/god_strength_attack/sven_ti10_helmet_gods_strength.vpcf", context )

	

end
function Advanced_God_Strength:IsHiddenWhenStolen() 		return false end
function Advanced_God_Strength:IsRefreshable() 			return true end
function Advanced_God_Strength:IsStealable() 				return true end
function Advanced_God_Strength:IsNetherWardStealable()	return true end
function Advanced_God_Strength:OnSpellStart()
	local caster = self:GetCaster()
	--派生技升级
	local pfx_name = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx_head = "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf"
	local sound_name = "Hero_Sven.GodsStrength"
	-- if HeroItems:UnitHasItem(self:GetCaster(), "sven_immortal_head_ti10") then
	-- 	pfx_name = "particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf"
	-- 	pfx_head = "particles/econ/items/sven/sven_ftp_weapon/sven_spell_gods_strength_ambient_ftp.vpcf"
	-- end
	caster:EmitSound(sound_name)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetBaseStrength()/self:GetSpecialValueFor("str_duration_index_other")
	local str_hero = caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH 
	if str_hero then
		duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetBaseStrength()/self:GetSpecialValueFor("str_duration_index")
	end
	--LV15解锁延时
	if self.advanced_level>=15 then
		duration = duration +10
		if str_hero then
			duration = duration +10
		end
		if self.unlock2 then
			duration = duration +10
		end
	end
	local buff = caster:AddNewModifier(caster, self, "modifier_Advanced_God_Strength", {duration = duration*ModifierStatusGain})
	--LV20解锁天神下凡
	if self.advanced_level>=20 then
		if str_hero then
			caster:AddNewModifier(caster, self, "modifier_Advanced_God_Strength_buff2", {duration = 30})
		else
			caster:AddNewModifier(caster, self, "modifier_Advanced_God_Strength_buff2", {duration = 10})
		end

	end
	local pfx = ParticleManager:CreateParticle(pfx_head, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	buff:AddParticle(pfx, false, false, 15, false, false)
	buff:SetStackCount(0)
end

modifier_Advanced_God_Strength = advanced_modifier({})

function modifier_Advanced_God_Strength:IsDebuff()			return false end
function modifier_Advanced_God_Strength:IsHidden() 			return false end
function modifier_Advanced_God_Strength:IsPurgable() 		return false end
function modifier_Advanced_God_Strength:IsPurgeException() 	return false end
function modifier_Advanced_God_Strength:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_Advanced_God_Strength:StatusEffectPriority() return 16 end
function modifier_Advanced_God_Strength:DeclareFunctions() 

	local funcs = {
		-- MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	} 
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV and coreUnlockKV.coreUnlock==2 then

		funcs = {
			-- MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			-- MODIFIER_EVENT_ON_ATTACK_LANDED,
			-- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
			-- MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_EVENT_ON_ATTACK_FAIL
		} 
		-- table.insert(funcs,MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE)
		-- table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_FAIL)
	end
	return funcs

end
-- function modifier_Advanced_God_Strength:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage")+self:GetStackCount() end

function modifier_Advanced_God_Strength:OnCreated(table) 
	self:GetParent().Advanced_God_Strength = 0
	self.bonus_base_damage = 0
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	self.bonus_status_resistance = 0
	if coreUnlockKV then
		self.unlock = coreUnlockKV.coreUnlock
	end
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.crit = {}
	if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
	end
end



function modifier_Advanced_God_Strength:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end

	local max_stack = 50
	if self.advanced_level>=10 then
		max_stack = 75
	end
	if self.unlock==2 then
		max_stack = 175
	end

	if self:GetParent().Advanced_God_Strength == 0 and self:GetStackCount()<max_stack then
		self:IncrementStackCount()
		--LV10解锁阿瑞斯之勇+
		if self.advanced_level>=10 and self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end

	local attack_chance = self:GetAbility():GetSpecialValueFor("chance")
	--LV5解锁撼神+
	if self.advanced_level>=5 then
		attack_chance = attack_chance + 10
	end

	
	if not self:GetParent():IsInSpecialAttack() then
		if attack_chance>=RandomInt(1, 100) then
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =0,
				iDisableSplit = 0,
		
			}
			local attackEffectRecord = keys.attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			keys.attacker:PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end
	elseif self.unlock==3 then
		if attack_chance*0.5>=RandomInt(1, 100) then
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =0,
				iDisableSplit = 0,
		
			}
			local attackEffectRecord = keys.attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			keys.attacker:PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end
	end


	if self.crit[keys.record] then

		

		local caster = self:GetCaster()
		local pos = keys.target:GetAbsOrigin()
		self:GetParent():EmitSound("Hero_Sven.GodsStrength")
		local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/god_strength_attack/sven_ti10_helmet_gods_strength.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
	    ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		self.crit[keys.record] = nil
	end


end



function modifier_Advanced_God_Strength:Advanced_GetModifierCriticalStrike(keys)



	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
		local pct = 2
		if pct > RandomInt(0,100) then
			self.crit[keys.record] = true


			local caster = self:GetParent()
			local damage_mul =  1000

			return damage_mul 

		else
	
			
			return 0
		end
	end
end

function modifier_Advanced_God_Strength:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_Advanced_God_Strength:ADDeclareFunctions()
	local funcs = {
		
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
	if self:GetAbility():GetUnlock(1)==1 then
		self.bonus_base_damage = 400
		table.insert(funcs,advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_StatusResistance)
	end
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_CRITICALSTRIKE)
	end
    return funcs
end

function modifier_Advanced_God_Strength:Advanced_GetModifier_StatusResistance(keys)
	return 100
end


function modifier_Advanced_God_Strength:Advanced_GetModifierBaseDamageOutgoing_Percentage() return self.bonus_damage+self:GetStackCount() end
function modifier_Advanced_God_Strength:Advanced_GetModifierBaseAttack_BonusDamage() return self.bonus_base_damage end


modifier_Advanced_God_Strength_buff2 = class({})

-----------------------------------------------------------------------------------------
function modifier_Advanced_God_Strength_buff2:IsDebuff() return false end
function modifier_Advanced_God_Strength_buff2:IsHidden() return false end
function modifier_Advanced_God_Strength_buff2:IsPurgable()
	return false
end
function modifier_Advanced_God_Strength_buff2:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_Advanced_God_Strength_buff2:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_God_Strength_buff2:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end