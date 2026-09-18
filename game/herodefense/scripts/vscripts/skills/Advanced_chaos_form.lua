--特效优化 √
Advanced_chaos_form = class({})

LinkLuaModifier("modifier_Advanced_chaos_form_transform", "skills/Advanced_chaos_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_chaos_form_transform_buff", "skills/Advanced_chaos_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_chaos_form_transform_shield", "skills/Advanced_chaos_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_chaos_form_mpcd", "skills/Advanced_chaos_form", LUA_MODIFIER_MOTION_NONE)
function Advanced_chaos_form:CheckKV(key)
	local table = {
		bonus_str =0.5,
		bonus_spell_range = 10,
		bonus_spell_damage_amplification = 0.5,
		duration = 0.5,
	}
	local value = table[key] or -1
	return value

end

require('internal/timers')   --计时器功能
function Advanced_chaos_form:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_chaos_form:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_chaos_form:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock3",{})
	return false

end

function Advanced_chaos_form:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
	end
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end


function Advanced_chaos_form:Precache( context )
	PrecacheResource( "model", "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl", context )
	PrecacheResource( "particle", "particles/econ/courier/courier_greevil_white/courier_greevil_white_ambient_3.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaos_form/unlock2/effect_compression.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaos_form/unlock3/effect.vpcf", context )
end




function Advanced_chaos_form:OnSpellStart()

	local caster = self:GetCaster()
	local ability = self
	local duration = ability:GetSpecialValueFor("duration")	
	EmitSoundOn("Hero_ShadowDemon.Disruption", caster)
	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Advanced_chaos_form_transform"

	local gain = caster:GetModifierDurationGainIndex(0.3)
	caster:AddNewModifier(caster, ability, "modifier_Advanced_chaos_form_transform", {duration = duration*gain})
	--LV15解锁轨道瞄准
	--新LV15魔神之眼
	if self.advanced_level>=15 then
		caster:AddNewModifier(caster, ability, "modifier_Advanced_chaos_form_transform_buff", {duration = 10})
	end
	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end

------------------------------------------------------------------------------------------------------

modifier_Advanced_chaos_form_transform = advanced_modifier({})
function modifier_Advanced_chaos_form_transform:IsHidden()	return false end
function modifier_Advanced_chaos_form_transform:IsPurgable()	return false end
function modifier_Advanced_chaos_form_transform:IsDebuff()	return false end
function modifier_Advanced_chaos_form_transform:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_10.vpcf" end
-- function modifier_item_hd_soul_of_balnock_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_chaos_form_transform:StatusEffectPriority() return 1000 end

function modifier_Advanced_chaos_form_transform:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		--MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
	}
	if IsServer() then
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_4" then
			decFuncs = {
				MODIFIER_PROPERTY_MODEL_SCALE,
				--MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
				MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
			}
		end
	end
	if self:GetAbility():GetUnlock(3)==3 then
		
	end
	return decFuncs	
end

function modifier_Advanced_chaos_form_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end

function modifier_Advanced_chaos_form_transform:Advanced_GetModifierBonusStats_Strength()	return self.bonus_str end--力
function modifier_Advanced_chaos_form_transform:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end--敏
function modifier_Advanced_chaos_form_transform:Advanced_GetModifierBonusStats_Agility()	return self.bonus_agi end--智
function modifier_Advanced_chaos_form_transform:Advanced_GetModifierSpellAmplifyBonus()--法强
	return self.bonus_spell_damage_amplification + self:GetStackCount()
end
function modifier_Advanced_chaos_form_transform:Advanced_GetModifierCastRangeBonusStacking(keys)--施法距离
	return self.bonus_spell_range 
end

function modifier_Advanced_chaos_form_transform:GetModifierModelScale() --模型大小
    return 30
end

function modifier_Advanced_chaos_form_transform:GetModifierModelChange()--模型改变
	if IsServer() then
		return self.model
	end
end

function modifier_Advanced_chaos_form_transform:GetModifierPercentageManacostStacking()--魔法消耗
	return self.auto_cast and  self.manaCost_reduce or 0
end

function modifier_Advanced_chaos_form_transform:OnCreated()
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.caster = self:GetCaster()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.manaCost = 0
	self.manaCost_reduce = -50
	self.per_stack_bonus_spell_damage = self.ability:GetSpecialValueFor("middle_amp")
	self.max_stack = self.ability:GetSpecialValueFor("middle_amp_max")
	--self.need_cost_index = 0.1
	self.every_sec_cost = self.ability:GetSpecialValueFor("middle_cost")*0.01*self:GetParent():GetMana()
	self.mp_line = self.ability:GetSpecialValueFor("mp_line")
	self.crit_chance = self.ability:GetSpecialValueFor("chance")
	self.crit_damage = (self.ability:GetSpecialValueFor("crit_base")-100)*0.01
	--LV5解锁魔力涌动+
	--新LV5狂乱魔力流+
	if self.advanced_level>=5 then
		self.per_stack_bonus_spell_damage = 5
		self.every_sec_cost = self.every_sec_cost*2
		--self.need_cost_index = 0.07
	end
	--LV10解锁魔力流动感知+
	
    if IsServer() then
		self:StartIntervalThink(1)
		local caster = self:GetCaster()
		if self.ability:GetAutoCastState() then
			self.auto_cast = true
		end
		self.currentSpell = self.ability

		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self.ability:GetAbilityName())
		self.model = "models/items/warlock/golem/warlock_the_infernal_master_golem/warlock_the_infernal_master_golem.vmdl"
		if type=="ability_particle_3" then
			self.model = "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl"
			self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_white/courier_greevil_white_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.caster )
			ParticleManager:SetParticleControlEnt( self.attach_particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.attach_particle, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
			self:AddParticle( self.attach_particle, false, false, -1, true, false )
		end
		if self.ability.unlock1 then
			-- print("unlock1 trigger")
		
			self.bonus_shield_index = caster:GetSpellAmplification(false)*10
			self.bonus_shield_index = self.bonus_shield_index - self.bonus_shield_index%1
			self.bonus_shield_index = self.bonus_shield_index *0.3
			
			self.modifier = caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_chaos_form_transform_shield",
			{duration=5,index=self.bonus_shield_index*caster:GetIntellect(false)})
		end
		
		if self.ability.unlock2 then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaos_form/unlock2/effect_compression.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(1,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
		if self.ability.unlock3 then
			self.unlock3 = true
			self.max_stack = 150
		end
    end
end

function modifier_Advanced_chaos_form_transform:OnRefresh(table)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if ability:GetAutoCastState() then
			self.auto_cast = true
		else
			self.auto_cast = false
		end
		if self.ability.unlock1 then
			self.bonus_shield_index = caster:GetSpellAmplification(false)*10
			self.bonus_shield_index = self.bonus_shield_index - self.bonus_shield_index%1
			self.bonus_shield_index = self.bonus_shield_index *0.3
			
			self.modifier = caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_chaos_form_transform_shield",
			{duration=5,index=self.bonus_shield_index*caster:GetIntellect(false)})
		end
	end
	self:SetStackCount(self:GetStackCount())
end

function modifier_Advanced_chaos_form_transform:OnIntervalThink()

	local caster = self:GetCaster()
	if self.ability.unlock1 then
		self.bonus_shield_index = caster:GetSpellAmplification(false)*10
		self.bonus_shield_index = self.bonus_shield_index - self.bonus_shield_index%1
		self.bonus_shield_index = self.bonus_shield_index *0.3
		if self.modifier and not self.modifier:IsNull() then
			self.modifier:SetDuration(5, true)
			self.modifier:SetStackCount(self.modifier:GetStackCount()+self.bonus_shield_index*caster:GetIntellect(false))
		end
	end
	if caster:GetMana() <= 1 then
		self:SetStackCount(self:GetStackCount())
	else
		self:SetStackCount(math.min((self:GetStackCount() + self.per_stack_bonus_spell_damage),self.max_stack))
	end
	self.every_sec_cost = self.ability:GetSpecialValueFor("middle_cost")*0.01*self:GetParent():GetMana()
	self:GetParent():Script_ReduceMana(self.every_sec_cost,self:GetAbility())
	--新LV10灯之灵核+
	if self.ability.advanced_level >= 10 and self:GetParent():GetManaPercent()<=40 then--self.mp_line
		self.mp_regen = self:GetCaster():GetMaxMana()*0.015
		self:GetParent():GiveMana(self.mp_regen)
	end
end

function modifier_Advanced_chaos_form_transform:OnDestroy()
	if self.attach_particle then
		ParticleManager:DestroyParticle(self.attach_particle,true)
		ParticleManager:ReleaseParticleIndex(self.attach_particle)
		self.attach_particle = nil
	end
end


function modifier_Advanced_chaos_form_transform:OnAbilityFullyCast(keys)

	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ~= parent  then 
			if self.unlock3 and not IsEnemy(keys.unit,parent) then
				if keys.unit:HasModifier("modifier_Advanced_chaos_form_transform") then
					return
				end
				--队友消耗你的魔法
				local ability = keys.ability
				local manaCost = ability:GetManaCost(-1)
				if manaCost>0 then
					parent:SpendMana( manaCost, ability )
					keys.unit:GiveMana(manaCost)
					local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaos_form/unlock3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true )

					
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(nFXIndex,true)
						ParticleManager:ReleaseParticleIndex( nFXIndex )
					end)

					if self:GetStackCount()<self.max_stack then
						self.manaCost = self.manaCost +manaCost
						local parent_mana = parent:GetMaxMana()*self.need_cost_index
						if self.manaCost>=parent_mana then
							local stack = self.manaCost / parent_mana
							stack = stack-stack%1
							self.manaCost =self.manaCost -parent_mana * stack
							self:SetStackCount(math.min(self:GetStackCount()+stack,self.max_stack))
						end
					end
				end
				
			end
			return 
		end
		local ability = keys.ability
		if ability==self:GetAbility() then
			return
		end
	
		if self:GetStackCount()<self.max_stack then
			local manaCost = ability:GetManaCost(-1)
			if self.auto_cast then
				manaCost = manaCost * 6
			end
			self.manaCost = self.manaCost +manaCost
			local parent_mana = parent:GetMaxMana()*self.need_cost_index
			if self.manaCost>=parent_mana then
				local stack = self.manaCost / parent_mana
				stack = stack-stack%1
				self.manaCost =self.manaCost -parent_mana * stack
				self:SetStackCount(math.min(self:GetStackCount()+stack,self.max_stack))
			end
		end
		

	
		if self:GetAbility().unlock2 and ability:GetCooldown(-1)>=2 then
			if self.currentSpell~=ability then
				self.currentSpell = ability
				self:IncrementStackCount()
				local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				if self.nFXIndex then
					ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(math.min(self:GetStackCount(),100),math.min(self:GetStackCount()/20,10),0) )
				end
				
			end
		end
	
		
	end
end




function modifier_Advanced_chaos_form_transform:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		self.mana_cost = self:GetAbility():GetSpecialValueFor("advanced_cost")*0.01*attacker:GetMaxMana()
		self.mp_line = self:GetAbility():GetSpecialValueFor("mp_line")
		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end
		if keys.damage<=50 then return	end
		if not IsEnemy(unit,attacker) then
			return
		end
		if self:GetParent():GetManaPercent() <= self.mp_line then
			return
		end
		if self:GetParent():GetMana() <= self.mana_cost then
			return
		end
		if Cannotcrit(keys) then return end
		
		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		if self.crit_chance>=RandomInt(1, 100) then

			--新LV20过量注能

			self.crit_damage = (self.ability:GetSpecialValueFor("crit_base")-100)*0.01
			if self.advanced_level>=20 then
				self.crit_damage = self.crit_damage + 0.5
			end
			
			local damage = keys.damage*self.crit_damage
			local damageTable = {
								victim = unit,
								attacker = attacker,
								damage = damage,
								damage_type = keys.damage_type,
								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
								ability = keys.inflictor, --Optional.
								}
			local applydamage = ApplyDamage(damageTable)
			if applydamage<=0 then
				return
			end
			fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
			local modifier_cd = attacker:FindModifierByName("modifier_Advanced_chaos_form_mpcd")
			if not modifier_cd then
				attacker:Script_ReduceMana(self.mana_cost,self:GetAbility())
				attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_Advanced_chaos_form_mpcd",{duration = 1})
			end
		end
    end 
end

-----------------------------------------------------------------------------

modifier_Advanced_chaos_form_transform_buff = advanced_modifier({})
function modifier_Advanced_chaos_form_transform_buff:IsHidden()	return false end
function modifier_Advanced_chaos_form_transform_buff:IsPurgable()	return false end
function modifier_Advanced_chaos_form_transform_buff:IsDebuff()	return false end

function modifier_Advanced_chaos_form_transform_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_BONUS_VISION,
    }
end
function modifier_Advanced_chaos_form_transform_buff:Advanced_GetModifierCastRangeBonusStacking(keys)
	return 2000
end
function modifier_Advanced_chaos_form_transform_buff:Advanced_GetBonusVision(keys)
	return 2000
end
-----------------------------------------------------------------------------
modifier_Advanced_chaos_form_mpcd= advanced_modifier({})
function modifier_Advanced_chaos_form_mpcd:IsHidden()	return true end
function modifier_Advanced_chaos_form_mpcd:IsPurgable()	return false end
function modifier_Advanced_chaos_form_mpcd:IsDebuff()	return false end
---------------------------------------------------------
modifier_Advanced_chaos_form_transform_shield = advanced_modifier({})
function modifier_Advanced_chaos_form_transform_shield:IsHidden() return false end
function modifier_Advanced_chaos_form_transform_shield:IsDebuff() return false end
function modifier_Advanced_chaos_form_transform_shield:IsPurgable() return false end
function modifier_Advanced_chaos_form_transform_shield:IsPurgeException() return false end
function modifier_Advanced_chaos_form_transform_shield:IsStunDebuff() return false end
function modifier_Advanced_chaos_form_transform_shield:AllowIllusionDuplicate() return false end
function modifier_Advanced_chaos_form_transform_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_Advanced_chaos_form_transform_shield:DeclareFunctions() return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK} end
function modifier_Advanced_chaos_form_transform_shield:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end
-- function modifier_Advanced_chaos_form_transform_shield:OnWaveStart()
-- 	self:SafeDestroy()
-- end
function modifier_Advanced_chaos_form_transform_shield:OnCreated(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(keys.index)
    self:StartIntervalThink(0.2)
end


function modifier_Advanced_chaos_form_transform_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
		MODIFIER_EVENT_ON_Wave_Start = {},
	}
end

function modifier_Advanced_chaos_form_transform_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end