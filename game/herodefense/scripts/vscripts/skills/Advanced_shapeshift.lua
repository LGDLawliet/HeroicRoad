
Advanced_shapeshift = class({})
LinkLuaModifier("modifier_Advanced_shapeshift_transform_stun", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_shapeshift_transform", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_shapeshift", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_shapeshift_unloock2", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_shapeshift_unloock3", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_shapeshift_particle_2", "skills/Advanced_shapeshift", LUA_MODIFIER_MOTION_NONE)
function Advanced_shapeshift:CheckKV(key)
	local table = {
		bonus_damage=1,



	}
	local value = table[key] or -1
	return value

end

function Advanced_shapeshift:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_shapeshift:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_shapeshift:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_shapeshift_unloock3",{})
	return true

end

function Advanced_shapeshift:Precache( context )
	PrecacheResource( "model", "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl", context )
	PrecacheResource( "model", "models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl", context )
	PrecacheResource( "model", "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl", context )
	PrecacheResource( "model", "models/heroes/lycan/lycan_wolf.vmdl", context )
	PrecacheResource( "particle", "particles/new_effect/status/new_status_effect_soul_18.vpcf", context )




end

function Advanced_shapeshift:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local transformation_time = 1.2
	local duration = ability:GetSpecialValueFor("duration")	
	local flag = DOTA_UNIT_TARGET_HERO
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lycan") then
		duration = duration * 2
		flag = flag + DOTA_UNIT_TARGET_BASIC
	end

	-- Start transformation gesture
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Advanced_shapeshift_transform"

	
	-- Play cast sound
	EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
	
	-- Add cast particle effects
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	local gain = caster:GetModifierDurationGainIndex(0.3)
	duration = duration*gain

	--LV20解锁狼群
	if self.advanced_level>=20 then
		
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, flag, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		-- table.remove(units,1)

		for _, unit in ipairs(units) do
			if unit~=caster then
				local modifier = unit:FindModifierByName(unit.Form_MODIFIER_NAME)
				if not modifier then
					unit:AddNewModifier(unit, ability, "modifier_Advanced_shapeshift_transform_stun", {duration = transformation_time})
					Timers:CreateTimer(transformation_time, function()
						if unit:IsNull() then
							return
						end
						-- Give Lycan transform buff
						
						unit:AddNewModifier(caster, ability, "modifier_Advanced_shapeshift_transform", {duration =duration})
						if self.unlock2 then
							caster:AddNewModifier(caster, ability, "modifier_Advanced_shapeshift_unloock2", {duration = duration})
						end
						unit.Form_MODIFIER_NAME = "modifier_Advanced_shapeshift_transform"
	
					end)
				end
			end
		
		end
		
	end

	-- Disable Lycan for the transform duration
	caster:AddNewModifier(caster, ability, "modifier_Advanced_shapeshift_transform_stun", {duration = transformation_time})
	local self_duration = duration
	if self.unlock1 then
		self_duration = -1
	end
	-- Wait the transformation time
	Timers:CreateTimer(transformation_time, function()
		caster:AddNewModifier(caster, ability, "modifier_Advanced_shapeshift_transform", {duration = self_duration})
		if self.unlock2 then
			caster:AddNewModifier(caster, ability, "modifier_Advanced_shapeshift_unloock2", {duration = self_duration})
		end
	end)	
end


modifier_Advanced_shapeshift_transform_stun = class({})

function modifier_Advanced_shapeshift_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end
function modifier_Advanced_shapeshift_transform_stun:IsHidden()
	return true
end

modifier_Advanced_shapeshift_transform = advanced_modifier({})
function modifier_Advanced_shapeshift_transform:IsHidden()	return false end
function modifier_Advanced_shapeshift_transform:IsPurgable()	return false end
function modifier_Advanced_shapeshift_transform:IsDebuff()	return false end
function modifier_Advanced_shapeshift_transform:IsAura() return true end
function modifier_Advanced_shapeshift_transform:GetAuraDuration() return 0.1 end
function modifier_Advanced_shapeshift_transform:GetModifierAura() return "modifier_Advanced_shapeshift" end
function modifier_Advanced_shapeshift_transform:GetAuraRadius() return 4000 end
function modifier_Advanced_shapeshift_transform:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED +DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_Advanced_shapeshift_transform:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_shapeshift_transform:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_shapeshift_transform:AllowIllusionDuplicate()	return false end
function modifier_Advanced_shapeshift_transform:GetAuraEntityReject(target)
    if IsServer() then	    	
    	if target:IsRealHero() then
    		if target == self.caster then		
    			return false
    		end
    	end
    	
    	if target:GetOwnerEntity() then
    		if target:GetOwnerEntity() == self.caster then
    			return false
    		end
    	end	
    		
    	return true
    end
end



function modifier_Advanced_shapeshift_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,

		}
		
		return decFuncs	
end


function modifier_Advanced_shapeshift_transform:GetModifierMoveSpeed_AbsoluteMin()
return self.absolute_speed
end



function modifier_Advanced_shapeshift_transform:GetModifierModelScale() 
    return 25
end


function modifier_Advanced_shapeshift_transform:GetModifierModelChange()
	if not IsServer() then
		return
	end
	local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
	if type=="ability_particle_10" then
		if self:GetParent():IsRealHero() then
			return "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
		end
	
		return "models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl"
	end
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lycan")  then
		if self:GetParent():IsRealHero() then
			
			return "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl"
		end
		return "models/items/lycan/wolves/icewrack_pack/icewrack_pack.vmdl"
	end
	return "models/heroes/lycan/lycan_wolf.vmdl"
end

function modifier_Advanced_shapeshift_transform:OnCreated()
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.max_stack = 30
	self.bonus_damage_basic_health = 3
	self.life_steal = 0.1
	--LV5解锁野性狂暴+
	if self.advanced_level>=5 then
		self.life_steal = 0.15
		self.max_stack = 60
	end
    self.absolute_speed = self.ability:GetSpecialValueFor("bonus_move")
	--LV10解锁血液热忱
	if self.advanced_level>=10 then
		self.bonus_damage_basic_health = 6
	end
	-- self.nFXIndex = ParticleManager:CreateParticle( "particles/new_effect/status/new_status_effect_soul_18.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- self:AddParticle( self.nFXIndex, true, false, 9999, true, false )
    if IsServer() then
    	self.caster = self:GetCaster()
		self.take_damage = 0
		--LV15解锁血夜
		if self.advanced_level>=15 and not self.ability.unlock1 then
			self:StartIntervalThink(1)
		end
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_10" then
			self.particle_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_shapeshift_particle_2", {})
		end
	

		-- local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		-- if type=="ability_particle_10" then
		
		-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/new_effect/status/new_status_effect_soul_18.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- 	self:AddParticle( self.nFXIndex, true, false, 16, false, false )
		-- end

    end
end
function modifier_Advanced_shapeshift_transform:OnIntervalThink()
    if IsServer() then    
		if  self.ability.unlock1 then
			self:StartIntervalThink(-1)
			return
		end
		if self:GetParent():IsInNightTime() then
			self:SetDuration(self:GetRemainingTime()+0.5, true)
		end	

	end
end


function modifier_Advanced_shapeshift_transform:OnDestroy()
    if IsServer() then    	


    	
    	local particle_revert_fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    	ParticleManager:SetParticleControl(particle_revert_fx, 0, self:GetParent():GetAbsOrigin())
    	ParticleManager:SetParticleControl(particle_revert_fx, 3, self:GetParent():GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex(particle_revert_fx)
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_shapeshift_unloock2")
		if modifier then
			modifier:SafeDestroy()
		end
		if self.particle_modifier then
			self.particle_modifier:SafeDestroy()
		end
    end
end


function modifier_Advanced_shapeshift_transform:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是攻击伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		local parent = self:GetParent()
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then return end

		--触发吸血
		if tg.attacker==parent 	and not parent:IsIllusion() and tg.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then 
			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
			local hp = tg.damage*self.life_steal*life_steal_gain
	
            hp = hp-hp%1
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            parent:Heal(hp, self.ability)

        end 

		--触发受到伤害
		if tg.unit==parent 	and not parent:IsIllusion()  then 
			self.take_damage = self.take_damage +tg.damage
			local parent_health = parent:GetMaxHealth()*0.1

			if self.take_damage>=parent_health then
				local stack = self.take_damage / parent_health
				stack = stack-stack%1
				self.take_damage =self.take_damage -parent_health * stack
				self:SetStackCount(math.min(self:GetStackCount()+stack,self.max_stack))
			end

			

        end 




    end 
end



function modifier_Advanced_shapeshift_transform:GetModifierAttackSpeedBonus_Constant() 	return self:GetStackCount()*10 end
function modifier_Advanced_shapeshift_transform:GetModifierPreAttack_BonusDamagePostCrit(keys) 
	if IsServer() then
		local bonus_damage = keys.target:GetHealthPercent()*self.bonus_damage_basic_health
		return bonus_damage
	end
end

function modifier_Advanced_shapeshift_transform:Advanced_GetModifierAttackRangeOverride() 	return 200 end


function modifier_Advanced_shapeshift_transform:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
	}
end



-- Speed/crit modifier
modifier_Advanced_shapeshift = advanced_modifier({})
function modifier_Advanced_shapeshift:IsHidden()	return true end
function modifier_Advanced_shapeshift:IsPurgable()	return false end
function modifier_Advanced_shapeshift:IsDebuff()	return false end
function modifier_Advanced_shapeshift:OnCreated()	
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.parent = self:GetParent()    
	self.certain_crit_buff = "modifier_Advanced_shapeshift_certain_crit"
    self.transform_buff = "modifier_Advanced_shapeshift_transform"

    -- Ability specials
    self.night_vision_bonus = self.ability:GetSpecialValueFor("night_vision_bonus")
    self.absolute_speed = self.ability:GetSpecialValueFor("bonus_move")
    self.crit_chance = self.ability:GetSpecialValueFor("bonus_damage_chance")
    self.crit_damage = self.ability:GetSpecialValueFor("bonus_damage")  
	if IsServer() then
		if self:GetParent():HasModifier("modifier_Advanced_howl_unlock3") then
			self.howl_ability = self:GetParent():FindAbilityByName("Advanced_howl")
			if self.howl_ability then
				self:StartIntervalThink(2)
			end
		end
	end


end
function modifier_Advanced_shapeshift:OnIntervalThink()
	if self.howl_ability and not self.howl_ability:IsNull() then
		self.howl_ability:SpellEffect(self:GetParent())
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 2)
	end
end

function modifier_Advanced_shapeshift:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
end

function modifier_Advanced_shapeshift:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_shapeshift:DeclareFunctions()
	local decFuncs = {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
			-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
	}
	if self:GetParent():HasModifier("modifier_Advanced_howl_unlock3") then
		table.insert(decFuncs,MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE)
	end
	return decFuncs	
end
--嚎叫奥义的加成
function modifier_Advanced_shapeshift:GetModifierDamageOutgoing_Percentage()	
	return 50
end
function modifier_Advanced_shapeshift:Advanced_GetBonusNightVision()	
	return self.night_vision_bonus
end

function modifier_Advanced_shapeshift:GetModifierMoveSpeed_AbsoluteMin()
	return self.absolute_speed
end



function modifier_Advanced_shapeshift:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }

	return funcs

end
function modifier_Advanced_shapeshift:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.attacker==self.parent and self.crit_chance>=RandomInt(1, 100) then
			if keys.damage_category==DOTA_DAMAGE_CATEGORY_SPELL then
				return
			end
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast_e.vpcf", PATTACH_POINT_FOLLOW, keys.target)
			local pos = keys.target:GetAbsOrigin()
			pos.z = pos.z +64
			ParticleManager:SetParticleControl(particle, 3, pos)
			ParticleManager:ReleaseParticleIndex(particle)
			return self.crit_damage
		end
	end
	return 0
end



modifier_Advanced_shapeshift_unloock2 = class({})

function modifier_Advanced_shapeshift_unloock2:IsDebuff()			return false end
function modifier_Advanced_shapeshift_unloock2:IsHidden() 			return true end
function modifier_Advanced_shapeshift_unloock2:IsPurgable() 		return false end
function modifier_Advanced_shapeshift_unloock2:IsPurgeException() 	return false end
function modifier_Advanced_shapeshift_unloock2:RemoveOnDeath() return false end
function modifier_Advanced_shapeshift_unloock2:GetPriority()
	return 10
end

function modifier_Advanced_shapeshift_unloock2:CheckState()
    local state = 
	{
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_PASSIVES_DISABLED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_UNSLOWABLE] = true,
		[MODIFIER_STATE_TETHERED] = false,
	}
	

	return state
end






modifier_Advanced_shapeshift_unloock3 = class({})

function modifier_Advanced_shapeshift_unloock3:IsDebuff()			return false end
function modifier_Advanced_shapeshift_unloock3:IsHidden() 			return true end
function modifier_Advanced_shapeshift_unloock3:IsPurgable() 		return false end
function modifier_Advanced_shapeshift_unloock3:IsPurgeException() 	return false end
function modifier_Advanced_shapeshift_unloock3:RemoveOnDeath() return false end


modifier_Advanced_shapeshift_particle_2 = class({})
function modifier_Advanced_shapeshift_particle_2:IsHidden()	return true end
function modifier_Advanced_shapeshift_particle_2:IsPurgable()	return false end
function modifier_Advanced_shapeshift_particle_2:IsDebuff()	return false end
function modifier_Advanced_shapeshift_particle_2:StatusEffectPriority() return 16 end
function modifier_Advanced_shapeshift_particle_2:GetStatusEffectName()
	return "particles/new_effect/status/new_status_effect_soul_18.vpcf"
end