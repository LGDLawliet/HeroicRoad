Advanced_reincarnation = class({})
-- LinkLuaModifier("modifier_Advanced_reincarnation_arua", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_reincarnation_arua_effect", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_active", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_reincarnation_effect", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_reincarnation_effect2", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_reincarnation_active_standby", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_debuff", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_reincarnation_thinker", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_debuff_enemy", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_debuff2", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_buff", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_reincarnation_unlock3", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_reincarnation_unlock3_phantom", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)




LinkLuaModifier("modifier_Advanced_reincarnation_weak", "skills/Advanced_reincarnation", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function Advanced_reincarnation:GetIntrinsicModifierName()
	return "modifier_Advanced_reincarnation"
end

function Advanced_reincarnation:CheckKV(key)
	local table = {

	


		duration = -0.2,
		bonus_attribute = -0.01,

	



	}
	local value = table[key] or -1
	return value

end
function Advanced_reincarnation:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_rage_unlock1",{})
	return true
end
function Advanced_reincarnation:UnlockSecondCore(key)
	-- self.count = 100
	return true
end
function Advanced_reincarnation:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_reincarnation_unlock3",{})
	return true
end



function Advanced_reincarnation:Precache( context )
	PrecacheResource( "model", "models/items/wraith_king/arcana/wraith_king_arcana.vmdl", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon_blur_attack2_reverse.vpcf", context )



end



modifier_Advanced_reincarnation = modifier_Advanced_reincarnation or advanced_modifier({})
function modifier_Advanced_reincarnation:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	-- Ability specials
	self.reincarnate_delay = self.ability:GetSpecialValueFor("modifier_Advanced_reincarnation")
	--初始化部分

	self.ability.DeathAgain_Time = self.ability.DeathAgain_Time or 6
	self:GetParent().now_reincarnation = "modifier_Advanced_reincarnation"  --设置当前的重生技能名
	if IsServer() then
		self.timer = self.timer or 0
		-- Set WK as immortal!
		-- self.can_die = false
		-- Start interval think
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_reincarnation:IsHidden() 
	return true
end
function modifier_Advanced_reincarnation:IsPurgable() 		return false end
function modifier_Advanced_reincarnation:IsPurgeException() 	return false end
function modifier_Advanced_reincarnation:RemoveOnDeath()  return false end
function modifier_Advanced_reincarnation:IsDebuff() return false end

function modifier_Advanced_reincarnation:OnIntervalThink()
	if not self.ability or self.ability:IsNull() then self:SafeDestroy() return end
	
	-- If caster has sufficent mana and the ability is ready, apply
	-- if (self.ability:IsOwnersManaEnough()) and (self.ability:IsCooldownReady())  then
	-- 	self.can_die = false
	-- else
	-- 	self.can_die = true
	-- end

	--冥王归来
	if not self.ability:IsCooldownReady() and self.ability.advanced_level>=20 then
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_reincarnation_buff")
		
		if modifier then
			modifier:SetDuration(1, true)
		else
			self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_Advanced_reincarnation_buff", {duration = 1})
		end
	end
end

function modifier_Advanced_reincarnation:OnRefresh()
	self:OnCreated()
end

function modifier_Advanced_reincarnation:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_RESPAWN,
	}
end



function modifier_Advanced_reincarnation:ADDeclareFunctions()
    return 
    {
		MODIFIER_SPECIAL_Reincarnate= {nil,self:GetParent()},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		MODIFIER_EVENT_ON_Wave_End = {}
    }
end
function modifier_Advanced_reincarnation:OnWaveEnd()
	if not IsServer() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		self:GetAbility():EndCooldown()	
	end
end
function modifier_Advanced_reincarnation:OnRespawn(keys)
	if IsServer() then
		local unit = keys.unit
		if self:GetParent() == unit and self.reincarnation_weak then
			local duration = self.ability:GetSpecialValueFor("duration")

			if not self.ability.unlock3 then
				--unit:AddNewModifier(unit, self.ability, "modifier_Advanced_reincarnation_debuff", {duration = duration})
			end
			
			unit.reincarnation_weak = false

			local radius = 700
			local debuff_duration = 4
			--LV10解锁灵气释放+
			if self.ability.advanced_level>=10 then
				radius = 900
				debuff_duration = 6
			end

			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
	  		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for _, target in pairs(units) do
				target:AddNewModifier(unit, self:GetAbility(), "modifier_Advanced_reincarnation_debuff_enemy", {duration = debuff_duration})
		   end


		end
	end
end

function modifier_Advanced_reincarnation:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit


		if unit~=self:GetParent() then	
			if self.ability.unlock1 and not IsEnemy(unit,self:GetParent()) and unit:IsRealHero() then
				--do nothing
			else
				return
			end
			-- return 
		end
		-- if keys.damage>=unit:GetHealth() and self:GetAbility():IsCooldownReady() then
		print(" self.timer=", self.timer)
		print("GameRules:GetGameTime()=",GameRules:GetGameTime())
		if unit:GetHealth()<=0 and self.timer<=GameRules:GetGameTime() then
			local modifier = unit:FindModifierByName("modifier_item_hd_helm_of_the_undying")
			if modifier and modifier:GetAbility():IsCooldownReady() then
				return
			end
			if unit:HasModifier("modifier_item_hd_helm_of_the_undying_active") then
				return
			end
			unit:SetHealth(1)
			local duration = 10
			--LV5解锁灵魂存续+
			if self.ability.advanced_level>=5 then
				duration = 15
			end
			if self.ability.unlock1 then
				duration = 25
			end

			unit:AddNewModifier(unit, self.ability, "modifier_Advanced_reincarnation_active", {duration = duration})
			-- unit.reincarnation_soul_survival_coooldown = true
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
			self.timer = GameRules:GetGameTime()+60

		end
		
    end 
end

function modifier_Advanced_reincarnation:AdvancedGetModifierReincarnate(keys)
	if self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() then

		self.reincarnation_weak = false
		local data = {
			modifier = self,
			time = self.reincarnate_delay,
			priority = 10,
			invulnerable_time = 2,
	
		}



		return data
	end

	return nil
	
end

function modifier_Advanced_reincarnation:OnReincarnateTrigger(keys)
	local unit = keys.unit
	self.ability:UseResources(false, false, true,true)
	local particle_death_fx = ParticleManager:CreateParticle(self.particle_death, PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
	ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_death_fx)
	-- unit:AddNewModifier(unit, self.ability, "modifier_Primary_reincarnation_debuff", {duration = self.ability:GetSpecialValueFor("duration")})
	self.reincarnation_weak = true
end





--重生虚弱
modifier_Advanced_reincarnation_debuff = class({})

function modifier_Advanced_reincarnation_debuff:IsDebuff() return true end
function modifier_Advanced_reincarnation_debuff:IsHidden() return false end
function modifier_Advanced_reincarnation_debuff:IsPurgable() return false end
-- function modifier_Advanced_reincarnation_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_Advanced_reincarnation_debuff:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	-- self.pierce_proc 			= false   --用于金箍棒
	-- self.pierce_records			= {}      --用于金箍棒
	-- self.PrimaryAttribute =parent:GetPrimaryAttribute()
	local attribute_bonus = -self.ability:GetSpecialValueFor("bonus_attribute")
	self.bonus_str = attribute_bonus* parent:GetStrength()
	self.bonus_agi = attribute_bonus*parent:GetAgility()
	self.bonus_int = attribute_bonus*parent:GetIntellect(false)

end



function modifier_Advanced_reincarnation_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Advanced_reincarnation_debuff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_reincarnation_debuff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Advanced_reincarnation_debuff:GetModifierBonusStats_Agility()	return self.bonus_agi end




--灵魂存续
--延迟死亡
modifier_Advanced_reincarnation_active = advanced_modifier({})



function modifier_Advanced_reincarnation_active:OnCreated()
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	if not IsServer() then
		return
	end

	-- "false_death_delay"  "6"
	-- "level1_require"  "6"
	-- "level2_require"  "12"
	-- "level3_require"  "24"

	-- "bonus_trigger_count" "1"
	-- "bonus_effect_per_count"  "2"
	-- "bonus_effect_max"  "100"

	
	local interval = self.ability:GetSpecialValueFor("false_death_delay")
	local count = GetFalseDeathCount(self:GetParent())
	self.trigger_count = 1
	self.mul_index = math.min(self.ability:GetSpecialValueFor("bonus_effect_per_count")*count,self.ability:GetSpecialValueFor("bonus_effect_max"))
	if count>=self.ability:GetSpecialValueFor("level1_require") then
		self.trigger_count = self.trigger_count + self.ability:GetSpecialValueFor("bonus_trigger_count")
		if count>=self.ability:GetSpecialValueFor("level2_require") then
			self.trigger_count = self.trigger_count + self.ability:GetSpecialValueFor("bonus_trigger_count")
			if count>=self.ability:GetSpecialValueFor("level3_require") then
				self.trigger_count = self.trigger_count + self.ability:GetSpecialValueFor("bonus_trigger_count")
			end
		end
	end
	local interval = (self:GetRemainingTime()-0.5)/self.trigger_count

	self:StartIntervalThink(interval)
	
end

function modifier_Advanced_reincarnation_active:OnIntervalThink()
	if not IsServer() then
		return
	end
	local table = {
		mulEffect = true,
		multiTrigger = true,
		unit = self:GetParent(),
		modifier = self,
		ability = self:GetAbility()
	}
	FireDeathAgainEvent(table)


	self.trigger_count = self.trigger_count - 1
	if self.trigger_count<=0 then
		self:StartIntervalThink(-1)
	end
end

function modifier_Advanced_reincarnation_active:IsDebuff() return false end
function modifier_Advanced_reincarnation_active:IsHidden() return false end
function modifier_Advanced_reincarnation_active:IsPurgable() return false end
function modifier_Advanced_reincarnation_active:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_Advanced_reincarnation_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_reincarnation_active:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MIN_HEALTH
		
	}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_DEATH)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
	end
	return funcs
end




function modifier_Advanced_reincarnation_active:GetModifierBonusStats_Strength()	return self:GetStackCount()*5 end
function modifier_Advanced_reincarnation_active:GetModifierBonusStats_Intellect()	return self:GetStackCount()*5  end
function modifier_Advanced_reincarnation_active:GetModifierBonusStats_Agility()	return self:GetStackCount()*5  end



function modifier_Advanced_reincarnation_active:GetMinHealth() 
	return 1
end

function modifier_Advanced_reincarnation_active:KillPre() self:Destroy() end  

function modifier_Advanced_reincarnation_active:OnDestroy(keys)
    if IsServer() then  
		if self.forceEnd then
			return
		end
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_reincarnation_weak", {duration = 20})
		-- self:GetParent():ModifyHealth(0,nil,true, 0)
		-- self:GetParent():Kill(nil,self:GetParent())
		-- self:GetParent():ForceKill(true)
		-- TrueKill(self:GetParent(), self:GetParent(), self:GetAbility())
    end 
end
function modifier_Advanced_reincarnation_active:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local level = ability.advanced_level

	
	--LV15解锁灵魂漫步
	if level>=15 then
		
		
		keys.target:AddNewModifier(caster, ability, "modifier_Advanced_reincarnation_debuff2", {duration = 5})
	end


end



function modifier_Advanced_reincarnation_active:OnDeath(keys)
	if IsServer() then
		local unit = keys.attacker
		if self:GetParent() == unit  then
			self:SetStackCount(math.min(self:GetStackCount()+1,60))
			self:SetDuration(self:GetRemainingTime()+2, true)
			local ability = self:GetAbility()
			if not ability:IsCooldownReady() then
				local time = ability:GetCooldownTimeRemaining()-2
				ability:EndCooldown()
				if time>0 then
					ability:StartCooldown(time)
				end
			end

		end
	end
end
function modifier_Advanced_reincarnation_active:OnWaveEnd()
	self.forceEnd = true
	self:SafeDestroy()
end


function modifier_Advanced_reincarnation_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only,
		MODIFIER_EVENT_ON_Wave_End = {},
		advanced_MODIFIER_PROPERTY_FALSE_DEATH_MUL_EFFECT
    }
end

function modifier_Advanced_reincarnation_active:Advanced_GetModifier_FlyingPathing()	
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then   
		return 1
	end
	return 0
end



function modifier_Advanced_reincarnation_active:Advanced_GetFalseDeathMulEffect(keys)	
	if self.mul_index then
		return self.mul_index
	end
	return 0
end






modifier_Advanced_reincarnation_debuff_enemy = class({})

function modifier_Advanced_reincarnation_debuff_enemy:IsDebuff() return true end
function modifier_Advanced_reincarnation_debuff_enemy:IsHidden() return false end
function modifier_Advanced_reincarnation_debuff_enemy:IsPurgable() return false end

function modifier_Advanced_reincarnation_debuff_enemy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end

function modifier_Advanced_reincarnation_debuff_enemy:CheckState()
		local state = {
			[MODIFIER_STATE_SILENCED] = true
		}
		return state
end


function modifier_Advanced_reincarnation_debuff_enemy:GetModifierAttackSpeedBonus_Constant() 	return -2000 end
function modifier_Advanced_reincarnation_debuff_enemy:GetModifierMoveSpeedBonus_Percentage()	return -500 end





--LV15灵魂漫步

modifier_Advanced_reincarnation_debuff2 = advanced_modifier({})

function modifier_Advanced_reincarnation_debuff2:IsDebuff() return true end
function modifier_Advanced_reincarnation_debuff2:IsHidden() return false end
function modifier_Advanced_reincarnation_debuff2:IsPurgable() return false end


function modifier_Advanced_reincarnation_debuff2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

	}
end
function modifier_Advanced_reincarnation_debuff2:GetModifierMagicalResistanceBonus() return -25 end
function modifier_Advanced_reincarnation_debuff2:Advanced_GetModifierPhysicalArmorBonus() return -10 end



function modifier_Advanced_reincarnation_debuff2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

modifier_Advanced_reincarnation_buff = advanced_modifier({})

function modifier_Advanced_reincarnation_buff:IsDebuff() return false end
function modifier_Advanced_reincarnation_buff:IsHidden() return true end
function modifier_Advanced_reincarnation_buff:IsPurgable() return false end



function modifier_Advanced_reincarnation_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_NegativeDurationGain
    }
end
function modifier_Advanced_reincarnation_buff:Advanced_GetModifier_DurationGain(keys)
	return 30
end

function modifier_Advanced_reincarnation_buff:Advanced_GetModifier_NegativeDurationGain(keys)
	return 30
end







modifier_Advanced_reincarnation_unlock3 = class({})

function modifier_Advanced_reincarnation_unlock3:IsDebuff()			return false end
function modifier_Advanced_reincarnation_unlock3:IsHidden() 			return true end
function modifier_Advanced_reincarnation_unlock3:IsPurgable() 		return false end
function modifier_Advanced_reincarnation_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_reincarnation_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_reincarnation_unlock3:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local pos = caster:GetOrigin()
		local unit  = CreateUnitByName("npc_hd_sk_double", pos, true, caster, caster, caster:GetTeamNumber())
		unit:SetOrigin(pos)
		unit:SetForwardVector(caster:GetForwardVector())
		unit:SetParent(caster,nil)
		unit:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_reincarnation_unlock3_phantom", {})

		

	end
end




modifier_Advanced_reincarnation_unlock3_phantom = modifier_Advanced_reincarnation_unlock3_phantom or class({})
function modifier_Advanced_reincarnation_unlock3_phantom:IsHidden()	return true end
function modifier_Advanced_reincarnation_unlock3_phantom:IsDebuff()	return false end
function modifier_Advanced_reincarnation_unlock3_phantom:IsPurgable()	return false end
function modifier_Advanced_reincarnation_unlock3_phantom:IsPurgeException()	return false end
function modifier_Advanced_reincarnation_unlock3_phantom:GetStatusEffectName() return "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf" end
function modifier_Advanced_reincarnation_unlock3_phantom:OnCreated(keys)
	if IsServer() then
		-- local caster = self:GetCaster()
		-- self.type = keys.type
		self:GetParent():SetHullRadius(0)
		-- self:GetParent():SetModelScale(0.9)
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.5)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_core_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head_fx", self:GetParent():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		self.type = 0

		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
	-- if self:GetStackCount()==2 then
	-- 	self.height_offect = 300
	-- end
end
function modifier_Advanced_reincarnation_unlock3_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_reincarnation_unlock3_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_Advanced_reincarnation_unlock3_phantom:FindTalentMoidifer()
	if self.talent_modifier and not self.talent_modifier:IsNull() then
		return self.talent_modifier
	end
	self.talent_modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_skeleton_king_2")
	return self.talent_modifier
end
function modifier_Advanced_reincarnation_unlock3_phantom:OnIntervalThink()

	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or not ability then
		self:SafeDestroy()
		return
	end
	if not caster:IsAlive() then
		self.type = 0
		return
	end
	local parent = self:GetParent()
	
	if self.type==0 then
		local talent_modifier = self:FindTalentMoidifer()
		if talent_modifier then
			local pos = caster:GetOrigin()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,  700,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
		   	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)  
			if #units>0 then
				
				
				parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.7)
				parent:EmitSound("Hero_SkeletonKing.PreAttack")
				local talent_unit = talent_modifier:GetPhantom()
				talent_unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.7)
				talent_unit:EmitSound("Hero_SkeletonKing.PreAttack")
				self.type = 1
			end
		else
			local pos = caster:GetOrigin()
			local units = FindUnitsInLine(caster:GetTeamNumber(), pos, pos+caster:GetForwardVector()*700,nil, 350,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
			if #units>0 then
				
				
				parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.7)
				parent:EmitSound("Hero_SkeletonKing.PreAttack")
				self.type = 1
			end
		end
		
	else
		local pos = caster:GetOrigin()
		local talent_modifier = self:FindTalentMoidifer()
		if talent_modifier then
			local talent_unit = talent_modifier:GetPhantom()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,  500,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
		   	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)  
			if #units>0 then
				local damageTable = {
					-- victim = enemy,
					attacker = caster,
					damage = caster:GetAverageTrueAttackDamage(nil)*3,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = ability, --Optional.
					}
		
				for _, unit in ipairs(units) do
					damageTable.victim = unit
					ApplyDamage(damageTable)
				end
				
			end
			talent_unit:EmitSound("Hero_SkeletonKing.Attack")
		else
			local units = FindUnitsInLine(caster:GetTeamNumber(), pos, pos+caster:GetForwardVector()*500,nil, 200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
			if #units>0 then
				local damageTable = {
					-- victim = enemy,
					attacker = caster,
					damage = caster:GetAverageTrueAttackDamage(nil)*2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = ability, --Optional.
					}
		
				for _, unit in ipairs(units) do
					damageTable.victim = unit
					ApplyDamage(damageTable)
				end
				
			end
		end
		
		parent:EmitSound("Hero_SkeletonKing.Attack")
		self.type = 0
	end




	
end

function modifier_Advanced_reincarnation_unlock3_phantom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
		
	}
end
function modifier_Advanced_reincarnation_unlock3_phantom:GetVisualZDelta( params )
	-- if IsClient() then
	-- 	return
	-- end
	return -300
end
-- function modifier_Advanced_reincarnation_unlock3_phantom:GetModifierMoveSpeedBonus_Constant( params )
-- 	local index =  (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()/500
-- 	return self.bonus_move*index
-- end


function modifier_Advanced_reincarnation_unlock3_phantom:GetOverrideAnimation(params)
	return ACT_DOTA_IDLE_STATUE
end

function modifier_Advanced_reincarnation_unlock3_phantom:GetModifierInvisibilityLevel()return 1 end









modifier_Advanced_reincarnation_weak = class({})

function modifier_Advanced_reincarnation_weak:IsDebuff() return true end
function modifier_Advanced_reincarnation_weak:IsHidden() return false end
function modifier_Advanced_reincarnation_weak:IsPurgable() return false end
function modifier_Advanced_reincarnation_weak:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Advanced_reincarnation_weak:GetModifierBonusStats_Strength()	return -9999 end
function modifier_Advanced_reincarnation_weak:GetModifierBonusStats_Intellect()	return -9999 end
function modifier_Advanced_reincarnation_weak:GetModifierBonusStats_Agility()	return -9999 end

