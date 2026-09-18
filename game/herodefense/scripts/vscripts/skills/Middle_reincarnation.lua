Middle_reincarnation = class({})
-- LinkLuaModifier("modifier_Middle_reincarnation_arua", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_reincarnation_arua_effect", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reincarnation", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reincarnation_active", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_reincarnation_effect", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_reincarnation_effect2", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_reincarnation_active_standby", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_reincarnation_debuff", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_reincarnation_thinker", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Middle_reincarnation_weak", "skills/Middle_reincarnation", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
require('internal/timers')   --计时器功能
function Middle_reincarnation:GetIntrinsicModifierName()
	return "modifier_Middle_reincarnation"
end




modifier_Middle_reincarnation = modifier_Middle_reincarnation or advanced_modifier({})

function modifier_Middle_reincarnation:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()    
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	self.reincarnate_delay = self.ability:GetSpecialValueFor("reincarnate_delay")
	self.caster.now_reincarnation = "modifier_Middle_reincarnation"  --设置当前的重生技能名
	if IsServer() then
		self.timer = self.timer or 0
		-- Set WK as immortal!
		-- self.can_die = false
		-- Start interval think
		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_Middle_reincarnation:IsHidden() 
	return true
end
function modifier_Middle_reincarnation:IsPurgable() 		return false end
function modifier_Middle_reincarnation:IsPurgeException() 	return false end
function modifier_Middle_reincarnation:RemoveOnDeath()  return false end
function modifier_Middle_reincarnation:IsDebuff() return false end

-- function modifier_Middle_reincarnation:OnIntervalThink()
-- 	if not self.ability or self.ability:IsNull() then self:SafeDestroy() return end
	
-- 	-- If caster has sufficent mana and the ability is ready, apply
-- 	if (self.ability:IsOwnersManaEnough()) and (self.ability:IsCooldownReady())  then
-- 		self.can_die = false
-- 	else
-- 		self.can_die = true
-- 	end

-- end

function modifier_Middle_reincarnation:OnRefresh()
	self:OnCreated()
end

function modifier_Middle_reincarnation:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_REINCARNATION,                      
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		-- MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end

-- function modifier_Middle_reincarnation:ReincarnateTime()
-- 	if IsServer() then
-- 		if not self.can_die and self.caster:IsRealHero() then
-- 			return self.reincarnate_delay
-- 		end

-- 		return nil
-- 	end
-- end

-- function modifier_Middle_reincarnation:GetActivityTranslationModifiers()
-- 	if self.reincarnation_death then
-- 		return "reincarnate"
-- 	end

-- 	return nil
-- end

-- function modifier_Middle_reincarnation:OnDeath(keys)
-- 	if IsServer() then
-- 		local unit = keys.unit
-- 		if self:GetParent() == unit and self.ability:IsCooldownReady()  and unit.reincarnation_trigger==1 then
-- 			self.ability:UseResources(false, false, true,true)
-- 			Timers:CreateTimer(0.1, function()
-- 				local pos = unit:GetAbsOrigin()
-- 				unit:SetTimeUntilRespawn(3)
-- 				Timers:CreateTimer(3, function()
-- 				if not unit:IsAlive() then --防止二次复活
-- 					unit:RespawnHero(false,false)
-- 					FindClearSpaceForUnit( unit, pos, true )
-- 				end
-- 				end)
-- 			end)
-- 			-- Add particle effects
-- 			local particle_death_fx = ParticleManager:CreateParticle(self.particle_death, PATTACH_CUSTOMORIGIN, unit)
-- 			ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
-- 			ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
-- 			ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_delay, 0, 0))
-- 			ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
-- 			ParticleManager:ReleaseParticleIndex(particle_death_fx)
-- 			-- unit:AddNewModifier(unit, self.ability, "modifier_Middle_reincarnation_debuff", {duration = self.ability:GetSpecialValueFor("duration")})
-- 			unit.reincarnation_weak = true

-- 		end
-- 	end
-- end




function modifier_Middle_reincarnation:ADDeclareFunctions()
    return 
    {
		MODIFIER_SPECIAL_Reincarnate= {nil,self:GetParent()},
		MODIFIER_EVENT_ON_Wave_End = {}
    }
end
function modifier_Middle_reincarnation:OnWaveEnd()
	if not IsServer() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		self:GetAbility():EndCooldown()	
	end
end

function modifier_Middle_reincarnation:OnRespawn(keys)
	if IsServer() then
		local unit = keys.unit
		if self:GetParent() == unit and self.reincarnation_weak then
			--unit:AddNewModifier(unit, self.ability, "modifier_Middle_reincarnation_debuff", {duration = self.ability:GetSpecialValueFor("duration")})
		end
	end
end

function modifier_Middle_reincarnation:AdvancedGetModifierReincarnate(keys)
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


function modifier_Middle_reincarnation:OnReincarnateTrigger(keys)
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


function modifier_Middle_reincarnation:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit

		if unit~=self:GetParent() then	return end
		-- if keys.damage>=unit:GetHealth() and self:GetAbility():IsCooldownReady() then
		if unit:GetHealth()<=0 and self.timer<=GameRules:GetGameTime() then
			local modifier = unit:FindModifierByName("modifier_item_hd_helm_of_the_undying")
			if modifier and modifier:GetAbility():IsCooldownReady() then
				return
			end
			if unit:HasModifier("modifier_item_hd_helm_of_the_undying_active") then
				return
			end
			unit:SetHealth(1)
			unit:AddNewModifier(unit, self.ability, "modifier_Middle_reincarnation_active", {duration = 10})
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
			self.timer = GameRules:GetGameTime()+60


		end
		
    end 
end




modifier_Middle_reincarnation_debuff = class({})

function modifier_Middle_reincarnation_debuff:IsDebuff() return true end
function modifier_Middle_reincarnation_debuff:IsHidden() return false end
function modifier_Middle_reincarnation_debuff:IsPurgable() return false end
-- function modifier_Middle_reincarnation_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_Middle_reincarnation_debuff:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	-- self.pierce_proc 			= false   --用于金箍棒
	-- self.pierce_records			= {}      --用于金箍棒
	-- self.PrimaryAttribute =parent:GetPrimaryAttribute()
	self.bonus_str = -self.ability:GetSpecialValueFor("bonus_str") * parent:GetStrength()*0.01
	self.bonus_agi = -self.ability:GetSpecialValueFor("bonus_str") *parent:GetAgility()*0.01
	self.bonus_int = -self.ability:GetSpecialValueFor("bonus_str")*parent:GetIntellect(false)*0.01


end



function modifier_Middle_reincarnation_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Middle_reincarnation_debuff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Middle_reincarnation_debuff:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Middle_reincarnation_debuff:GetModifierBonusStats_Agility()	return self.bonus_agi end





modifier_Middle_reincarnation_active = advanced_modifier({})

function modifier_Middle_reincarnation_active:IsDebuff() return false end
function modifier_Middle_reincarnation_active:IsHidden() return false end
function modifier_Middle_reincarnation_active:IsPurgable() return false end
function modifier_Middle_reincarnation_active:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_Middle_reincarnation_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_reincarnation_active:KillPre() self:Destroy() end  

--寒霜传送门 测试用
function modifier_Middle_reincarnation_active:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(9)
	end
end

function modifier_Middle_reincarnation_active:OnIntervalThink()
	local table = {
		mulEffect = true,
		multiTrigger = true,
		unit = self:GetParent(),
		modifier = self,
		ability = self:GetAbility()
	}
	FireDeathAgainEvent(table)

	self:StartIntervalThink(-1)
end
function modifier_Middle_reincarnation_active:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_Middle_reincarnation_active:GetMinHealth() return 1 end
-- function modifier_Middle_reincarnation_active:OnTakeDamage(keys)
--     if IsServer() then  
-- 		if keys.unit == self:GetParent() then
-- 			if keys.damage<=0  then	return	end
-- 			-- if keys.damage >= keys.unit:GetHealth()   then
-- 			if keys.unit:GetHealth()<=0   then
-- 				keys.unit:SetHealth(1)

-- 			end	
-- 		end
--     end 
-- end
function modifier_Middle_reincarnation_active:OnDestroy(keys)
    if IsServer() then  
		-- self:GetParent():ModifyHealth(0,nil,true, 0)
		-- self:GetParent():ForceKill(true)
		-- self:GetParent():Kill(nil,self:GetParent())
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Middle_reincarnation_weak", {duration = 20})
		-- TrueKill(self:GetParent(), self:GetParent(), self:GetAbility())
		self:StartIntervalThink(-1)
    end 
end
















modifier_Middle_reincarnation_weak = class({})

function modifier_Middle_reincarnation_weak:IsDebuff() return true end
function modifier_Middle_reincarnation_weak:IsHidden() return false end
function modifier_Middle_reincarnation_weak:IsPurgable() return false end
function modifier_Middle_reincarnation_weak:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Middle_reincarnation_weak:GetModifierBonusStats_Strength()	return -9999 end
function modifier_Middle_reincarnation_weak:GetModifierBonusStats_Intellect()	return -9999 end
function modifier_Middle_reincarnation_weak:GetModifierBonusStats_Agility()	return -9999 end